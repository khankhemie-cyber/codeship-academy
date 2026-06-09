import { NextRequest, NextResponse } from 'next/server'
import { createClient, createServiceClient } from '@/lib/supabase/server'
import { z } from 'zod'

const createSchema = z.object({
  name: z.string().min(3).max(80),
  grade: z.string().max(10).nullable().optional(),
})

async function requireTeacher() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return { error: NextResponse.json({ error: 'Unauthorized' }, { status: 401 }) }

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || (appUser.role !== 'teacher' && appUser.role !== 'admin')) {
    return { error: NextResponse.json({ error: 'Forbidden' }, { status: 403 }) }
  }

  return { supabase, user }
}

export async function GET() {
  const ctx = await requireTeacher()
  if ('error' in ctx && ctx.error) return ctx.error
  const { supabase, user } = ctx as { supabase: Awaited<ReturnType<typeof createClient>>; user: { id: string } }

  const { data: classes } = await supabase
    .from('classes')
    .select('id, name, grade, code, is_active, created_at, class_memberships(count)')
    .eq('teacher_id', user.id)
    .order('created_at', { ascending: false })

  return NextResponse.json({ classes: classes || [] })
}

export async function POST(req: NextRequest) {
  const ctx = await requireTeacher()
  if ('error' in ctx && ctx.error) return ctx.error
  const { supabase, user } = ctx as { supabase: Awaited<ReturnType<typeof createClient>>; user: { id: string } }

  const body = await req.json().catch(() => null)
  const parsed = createSchema.safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input' }, { status: 400 })

  const service = await createServiceClient()
  const { data: codeData, error: codeError } = await service.rpc('generate_class_code')
  if (codeError) {
    return NextResponse.json({ error: 'Could not generate class code' }, { status: 500 })
  }

  const { data: cls, error } = await supabase
    .from('classes')
    .insert({
      teacher_id: user.id,
      name: parsed.data.name,
      grade: parsed.data.grade || null,
      code: codeData as string,
      is_active: true,
    })
    .select()
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  await service.from('audit_logs').insert({
    user_id: user.id,
    action: 'class_created',
    target_type: 'class',
    target_id: cls.id,
    metadata: { name: cls.name, code: cls.code },
  })

  return NextResponse.json({ id: cls.id, code: cls.code })
}
