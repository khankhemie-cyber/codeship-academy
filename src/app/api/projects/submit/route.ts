import { NextRequest, NextResponse } from 'next/server'
import { createClient, createServiceClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { z } from 'zod'

const schema = z.object({
  project_id: z.string().uuid(),
  code: z.string().min(1).max(100_000),
  notes: z.string().max(2000).optional(),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student').catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = schema.safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  if (!profile) return NextResponse.json({ error: 'Profile not found' }, { status: 404 })

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
    .eq('student_id', profile.id)
    .maybeSingle()

  let submission
  if (existing) {
    const { data } = await supabase
      .from('project_submissions')
      .update({
        code: parsed.data.code,
        notes: parsed.data.notes || null,
        status: 'submitted',
        submitted_at: new Date().toISOString(),
      })
      .eq('id', existing.id)
      .select()
      .single()
    submission = data
  } else {
    const { data } = await supabase
      .from('project_submissions')
      .insert({
        project_id: parsed.data.project_id,
        student_id: profile.id,
        code: parsed.data.code,
        notes: parsed.data.notes || null,
        status: 'submitted',
        submitted_at: new Date().toISOString(),
      })
      .select()
      .single()
    submission = data

    // Award XP on first submission
    const serviceSupabase = await createServiceClient()
    await serviceSupabase.rpc('award_xp', {
      p_student_id: profile.id,
      p_xp: project.xp_reward,
      p_source: 'project',
      p_source_id: parsed.data.project_id,
    })
  }

  return NextResponse.json({ ok: true, submission })
}
