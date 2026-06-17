import { NextRequest, NextResponse } from 'next/server'
import { createClient, createServiceClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { z } from 'zod'

const schema = z.object({
  display_name: z.string().min(2).max(50),
  date_of_birth: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent').catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = schema.safeParse(body)
  if (!parsed.success) return NextResponse.json({ error: 'Invalid input', issues: parsed.error.issues }, { status: 400 })

  // Check child is under 18
  const dob = new Date(parsed.data.date_of_birth)
  const age = Math.floor((Date.now() - dob.getTime()) / (365.25 * 24 * 60 * 60 * 1000))
  if (age < 4 || age > 17) {
    return NextResponse.json({ error: 'Child must be between 4 and 17 years old.' }, { status: 400 })
  }

  const { data: parent } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  if (!parent) return NextResponse.json({ error: 'Parent profile not found' }, { status: 404 })

  // Determine level based on age
  let level: string
  if (age <= 7) level = 'explorers'
  else if (age <= 10) level = 'builders'
  else level = 'developers'

  // Use service client to create a new auth user for the child
  const serviceSupabase = await createServiceClient()
  const childEmail = `child.${Date.now()}.${Math.random().toString(36).slice(2)}@internal.codeship.academy`
  const childPassword = Math.random().toString(36).slice(2) + Math.random().toString(36).slice(2)

  const { data: authData, error: authError } = await serviceSupabase.auth.admin.createUser({
    email: childEmail,
    password: childPassword,
    email_confirm: true,
    user_metadata: { role: 'student', display_name: parsed.data.display_name },
  })

  if (authError || !authData.user) {
    return NextResponse.json({ error: 'Failed to create student account.' }, { status: 500 })
  }

  // Profile is created by trigger; update it
  await serviceSupabase
    .from('profiles')
    .update({
      display_name: parsed.data.display_name,
      role: 'student',
      level,
      date_of_birth: parsed.data.date_of_birth,
    })
    .eq('user_id', authData.user.id)

  const { data: studentProfile } = await serviceSupabase
    .from('profiles')
    .select('id')
    .eq('user_id', authData.user.id)
    .single()

  if (!studentProfile) {
    return NextResponse.json({ error: 'Profile creation failed.' }, { status: 500 })
  }

  // Link parent to student
  await serviceSupabase.from('parent_student_links').insert({
    parent_id: parent.id,
    student_id: studentProfile.id,
    consent_given: true,
    consent_ip: req.headers.get('x-forwarded-for') || 'unknown',
    consent_ua: req.headers.get('user-agent') || 'unknown',
  })

  // Record consent
  await serviceSupabase.from('consent_records').insert({
    user_id: authData.user.id,
    consent_type: 'parental',
    method: 'web_form',
    ip_address: req.headers.get('x-forwarded-for') || 'unknown',
    user_agent: req.headers.get('user-agent') || 'unknown',
    consented_by: user.id,
  })

  await serviceSupabase.from('audit_logs').insert({
    user_id: user.id,
    action: 'student_created',
    metadata: { student_id: studentProfile.id, display_name: parsed.data.display_name, level },
  })

  return NextResponse.json({ ok: true, student_id: studentProfile.id, level })
}
