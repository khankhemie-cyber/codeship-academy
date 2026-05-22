import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { z } from 'zod'

const createSchema = z.object({
  name: z.string().min(3).max(80),
  grade: z.string().max(10).nullable().optional(),
})

export async function GET(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'teacher').catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  const { data: classes } = await supabase
    .from('classes')
    .select('*, class_memberships(count)')
    .eq('teacher_id', profile!.id)
    .order('created_at', { ascending: false })

  return NextResponse.json({ classes: classes || [] })
}

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'teacher').catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = createSchema.safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  if (!profile) return NextResponse.json({ error: 'Profile not found' }, { status: 404 })

  // Generate unique join code
  const joinCode = Math.random().toString(36).slice(2, 8).toUpperCase()

  const { data: cls, error } = await supabase
    .from('classes')
    .insert({
      teacher_id: profile.id,
      name: parsed.data.name,
      grade: parsed.data.grade || null,
      join_code: joinCode,
      is_active: true,
    })
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  await supabase.from('audit_logs').insert({
    user_id: user.id,
    action: 'class_created',
    metadata: { class_id: cls.id, name: cls.name },
  })

  return NextResponse.json({ id: cls.id, join_code: cls.join_code })
}
