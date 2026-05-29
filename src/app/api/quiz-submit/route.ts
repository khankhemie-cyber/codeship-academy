import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { resolveStudentId, verifyStudentAccess } from '@/lib/student-session'
import { z } from 'zod'

export async function PUT(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) return NextResponse.json({ error: 'No active student profile' }, { status: 400 })

  const body = await req.json().catch(() => null)
  const parsed = z.object({ quiz_id: z.string().uuid() }).safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: attempt, error } = await supabase
    .from('quiz_attempts')
    .insert({
      quiz_id: parsed.data.quiz_id,
      student_id: studentId,
      answers: [],
    })
    .select('id')
    .single()

  if (error) return NextResponse.json({ error: 'Could not start attempt' }, { status: 500 })
  return NextResponse.json({ attempt_id: attempt.id })
}

export async function PATCH(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = z.object({
    attempt_id: z.string().uuid(),
    answers: z.array(z.number().nullable()),
    student_id: z.string().uuid().optional(),
  }).safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  const { data: attempt } = await supabase
    .from('quiz_attempts')
    .select('id, student_id')
    .eq('id', parsed.data.attempt_id)
    .single()

  if (!attempt) return NextResponse.json({ error: 'Not found' }, { status: 404 })

  const allowed = await verifyStudentAccess(supabase, user.id, appUser.role, attempt.student_id)
  if (!allowed) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  await supabase
    .from('quiz_attempts')
    .update({ answers: parsed.data.answers })
    .eq('id', parsed.data.attempt_id)

  return NextResponse.json({ ok: true })
}

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = z.object({
    quiz_id: z.string().uuid(),
    attempt_id: z.string().uuid().optional(),
    answers: z.array(z.number().nullable()),
  }).safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) return NextResponse.json({ error: 'No active student profile' }, { status: 400 })

  const { data: quiz } = await supabase
    .from('quizzes')
    .select('*')
    .eq('id', parsed.data.quiz_id)
    .single()

  if (!quiz) return NextResponse.json({ error: 'Quiz not found' }, { status: 404 })

  const { data: questions } = await supabase
    .from('quiz_questions')
    .select('id, correct_answer, points, sort_order')
    .eq('quiz_id', parsed.data.quiz_id)
    .order('sort_order', { ascending: true })

  if (!questions?.length) return NextResponse.json({ error: 'No questions' }, { status: 500 })

  let earned = 0
  let total = 0
  questions.forEach((q, i) => {
    total += q.points
    if (parsed.data.answers[i] === q.correct_answer) earned += q.points
  })

  const scorePercent = total > 0 ? Math.round((earned / total) * 100) : 0
  const passed = scorePercent >= quiz.passing_score

  let finalAttemptId = parsed.data.attempt_id
  const attemptPayload = {
    answers: parsed.data.answers,
    score: scorePercent,
    passed,
    completed_at: new Date().toISOString(),
  }

  if (finalAttemptId) {
    await supabase
      .from('quiz_attempts')
      .update(attemptPayload)
      .eq('id', finalAttemptId)
      .eq('student_id', studentId)
  } else {
    const { data: newAttempt } = await supabase
      .from('quiz_attempts')
      .insert({
        quiz_id: parsed.data.quiz_id,
        student_id: studentId,
        ...attemptPayload,
      })
      .select('id')
      .single()
    finalAttemptId = newAttempt?.id
  }

  let xp_awarded = 0
  if (passed) {
    const { data: xpResult } = await supabase.rpc('award_xp', {
      p_student_id: studentId,
      p_base_xp: quiz.xp_reward,
    })
    await supabase.rpc('update_streak', { p_student_id: studentId })
    xp_awarded = typeof xpResult === 'number' ? xpResult : quiz.xp_reward
    await supabase.from('audit_logs').insert({
      user_id: user.id,
      action: 'quiz_passed',
      target_type: 'quiz',
      target_id: parsed.data.quiz_id,
      metadata: { score: scorePercent, xp_awarded, student_id: studentId },
    })
  }

  const feedback = passed
    ? `Great job! You scored ${scorePercent}% and earned ${xp_awarded} XP.`
    : `You scored ${scorePercent}%. You need ${quiz.passing_score}% to pass. Review and try again!`

  return NextResponse.json({
    score: scorePercent,
    passed,
    xp_awarded,
    feedback,
    attempt_id: finalAttemptId,
  })
}
