import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

const ProgressSchema = z.object({
  lessonId: z.string().uuid(),
  studentId: z.string().uuid(),
  status: z.enum(['in_progress', 'completed', 'needs_review']),
  heartsRemaining: z.number().int().min(0).max(5).optional(),
  score: z.number().int().min(0).max(100).optional(),
})

export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 })
  }

  const parsed = ProgressSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid request', details: parsed.error.flatten() }, { status: 400 })
  }

  const { lessonId, studentId, status, heartsRemaining, score } = parsed.data

  // Verify ownership: user must be the student, or the parent of the student
  const { data: userData } = await supabase.from('users').select('role').eq('id', user.id).single()

  let authorised = false
  if (userData?.role === 'student' && user.id === studentId) authorised = true
  if (userData?.role === 'parent') {
    const { data: student } = await supabase
      .from('student_profiles')
      .select('id')
      .eq('id', studentId)
      .eq('parent_id', user.id)
      .single()
    authorised = !!student
  }
  if (userData?.role === 'admin') authorised = true

  if (!authorised) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  const { data: existing } = await supabase
    .from('lesson_progress')
    .select('id')
    .eq('student_id', studentId)
    .eq('lesson_id', lessonId)
    .single()

  const updateData = {
    status,
    hearts_remaining: heartsRemaining ?? 5,
    score: score ?? null,
    completed_at: status === 'completed' ? new Date().toISOString() : null,
    updated_at: new Date().toISOString(),
  }

  if (existing) {
    await supabase.from('lesson_progress').update(updateData).eq('id', existing.id)
  } else {
    await supabase.from('lesson_progress').insert({
      student_id: studentId,
      lesson_id: lessonId,
      ...updateData,
    })
  }

  // Award XP if completed
  if (status === 'completed') {
    await supabase.rpc('award_xp', { p_student_id: studentId, p_base_xp: 100 })
  }

  return NextResponse.json({ success: true })
}
