import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { resolveStudentId } from '@/lib/student-session'
import { z } from 'zod'

const schema = z.object({
  code: z.string().min(4).max(12).optional(),
  token: z.string().min(8).max(64).optional(),
  studentId: z.string().uuid().optional(),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = schema.safeParse(body)
  if (!parsed.success || (!parsed.data.code && !parsed.data.token)) {
    return NextResponse.json({ error: 'Provide code or token' }, { status: 400 })
  }

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser) return NextResponse.json({ error: 'Forbidden' }, { status: 403 })

  const studentId =
    parsed.data.studentId ||
    (await resolveStudentId(supabase, user.id, appUser.role))

  if (!studentId) {
    return NextResponse.json({ error: 'No student profile to join with' }, { status: 400 })
  }

  let memberId: string | null = null
  if (parsed.data.code) {
    const { data, error } = await supabase.rpc('join_class_by_code', {
      p_code: parsed.data.code.toUpperCase(),
      p_student_id: studentId,
    })
    if (error) return NextResponse.json({ error: error.message }, { status: 400 })
    memberId = data as string
  } else if (parsed.data.token) {
    const { data, error } = await supabase.rpc('join_class_by_token', {
      p_token: parsed.data.token,
      p_student_id: studentId,
    })
    if (error) return NextResponse.json({ error: error.message }, { status: 400 })
    memberId = data as string
  }

  return NextResponse.json({ ok: true, membership_id: memberId })
}
