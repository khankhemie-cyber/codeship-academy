import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { resolveStudentId, verifyStudentAccess } from '@/lib/student-session'
import { z } from 'zod'

const schema = z.object({
  project_id: z.string().uuid(),
  code: z.string().min(1).max(100_000),
  notes: z.string().max(2000).optional(),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) return NextResponse.json({ error: 'No active student' }, { status: 400 })

  const allowed = await verifyStudentAccess(supabase, user.id, appUser.role, studentId)
  if (!allowed) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  const body = await req.json().catch(() => null)
  const parsed = schema.safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: project } = await supabase
    .from('projects')
    .select('id, xp_reward')
    .eq('id', parsed.data.project_id)
    .single()

  if (!project) return NextResponse.json({ error: 'Project not found' }, { status: 404 })

  const { data: existing } = await supabase
    .from('project_submissions')
    .select('id')
    .eq('project_id', parsed.data.project_id)
    .eq('student_id', studentId)
    .maybeSingle()

  const payload = {
    code_snapshot: parsed.data.code,
    notes: parsed.data.notes || null,
    status: 'submitted',
    updated_at: new Date().toISOString(),
  }

  let submission
  if (existing) {
    const { data } = await supabase
      .from('project_submissions')
      .update(payload)
      .eq('id', existing.id)
      .select()
      .single()
    submission = data
  } else {
    const { data } = await supabase
      .from('project_submissions')
      .insert({
        project_id: parsed.data.project_id,
        student_id: studentId,
        ...payload,
      })
      .select()
      .single()
    submission = data

    await supabase.rpc('award_xp', {
      p_student_id: studentId,
      p_base_xp: project.xp_reward,
    })
  }

  return NextResponse.json({ ok: true, submission })
}
