import { NextRequest, NextResponse } from 'next/server'
import { createClient, createServiceClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { z } from 'zod'

// PUT: start a new attempt
export async function PUT(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student').catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = z.object({ quiz_id: z.string().uuid() }).safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  if (!profile) return NextResponse.json({ error: 'Profile not found' }, { status: 404 })

  const { data: attempt, error } = await supabase
    .from('quiz_attempts')
    .insert({
      quiz_id: parsed.data.quiz_id,
      student_id: profile.id,
      answers: [],
      started_at: new Date().toISOString(),
    })
    .select('id')
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ attempt_id: attempt.id })
}

// PATCH: save progress (auto-save)
export async function PATCH(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student').catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = z.object({
    attempt_id: z.string().uuid(),
    answers: z.array(z.number().nullable()),
  }).safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  // Verify ownership
  const { data: attempt } = await supabase
    .from('quiz_attempts')
    .select('id, student_id')
    .eq('id', parsed.data.attempt_id)
    .single()

  if (!attempt || attempt.student_id !== profile?.id) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 })
  }

  await supabase
    .from('quiz_attempts')
    .update({ answers: parsed.data.answers })
    .eq('id', parsed.data.attempt_id)

  return NextResponse.json({ ok: true })
}

// POST: submit and grade
export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student').catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = z.object({
    quiz_id: z.string().uuid(),
    attempt_id: z.string().uuid().optional(),
    answers: z.array(z.number().nullable()),
  }).safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  if (!profile) return NextResponse.json({ error: 'Profile not found' }, { status: 404 })

  // Load quiz and questions with correct answers
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

  if (!questions) return NextResponse.json({ error: 'No questions' }, { status: 500 })

  // Grade
  let earned = 0
  let total = 0
  questions.forEach((q, i) => {
    total += q.points
    if (parsed.data.answers[i] === q.correct_answer) {
      earned += q.points
    }
  })

  const scorePercent = total > 0 ? Math.round((earned / total) * 100) : 0
  const passed = scorePercent >= quiz.passing_score

  // Upsert attempt
  let finalAttemptId = parsed.data.attempt_id
  if (finalAttemptId) {
    await supabase
      .from('quiz_attempts')
      .update({
        answers: parsed.data.answers,
        score: scorePercent,
        passed,
        completed_at: new Date().toISOString(),
      })
      .eq('id', finalAttemptId)
      .eq('student_id', profile.id)
  } else {
    const { data: newAttempt } = await supabase
      .from('quiz_attempts')
      .insert({
        quiz_id: parsed.data.quiz_id,
        student_id: profile.id,
        answers: parsed.data.answers,
        score: scorePercent,
        passed,
        started_at: new Date().toISOString(),
        completed_at: new Date().toISOString(),
      })
      .select('id')
      .single()
    finalAttemptId = newAttempt?.id
  }

  // Award XP if passed
  let xp_awarded = 0
  if (passed) {
    xp_awarded = quiz.xp_reward
    const serviceSupabase = await createServiceClient()
    await serviceSupabase.rpc('award_xp', {
      p_student_id: profile.id,
      p_xp: xp_awarded,
      p_source: 'quiz',
      p_source_id: parsed.data.quiz_id,
    })

    await supabase.from('audit_logs').insert({
      user_id: user.id,
      action: 'quiz_passed',
      metadata: { quiz_id: parsed.data.quiz_id, score: scorePercent, xp_awarded },
    })
  }

  const feedback = passed
    ? `Great job! You scored ${scorePercent}% and earned ${xp_awarded} XP. Keep it up!`
    : `You scored ${scorePercent}%. You need ${quiz.passing_score}% to pass. Review the material and try again!`

  return NextResponse.json({ score: scorePercent, passed, xp_awarded, feedback })
}
