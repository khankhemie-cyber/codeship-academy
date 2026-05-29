import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { verifyStudentAccess } from '@/lib/student-session'
import { ACTIVE_STUDENT_COOKIE } from '@/lib/student-session'
import { z } from 'zod'

const schema = z.object({
  studentId: z.string().uuid(),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || (appUser.role !== 'parent' && appUser.role !== 'admin')) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  const body = await req.json().catch(() => null)
  const parsed = schema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid student id' }, { status: 400 })
  }

  const allowed = await verifyStudentAccess(
    supabase,
    user.id,
    appUser.role,
    parsed.data.studentId
  )
  if (!allowed) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  const response = NextResponse.json({ ok: true })
  response.cookies.set(ACTIVE_STUDENT_COOKIE, parsed.data.studentId, {
    httpOnly: true,
    sameSite: 'lax',
    secure: process.env.NODE_ENV === 'production',
    path: '/',
    maxAge: 60 * 60 * 24 * 365,
  })
  return response
}
