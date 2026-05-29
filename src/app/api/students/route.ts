import { NextRequest, NextResponse } from 'next/server'
import { createClient, createServiceClient } from '@/lib/supabase/server'
import { z } from 'zod'
import { levelFromAge, GRADE_OPTIONS } from '@/lib/utils/user'

const PRIVACY_POLICY_VERSION = '2026-04-14'
const TERMS_VERSION = '2026-04-14'

const CreateStudentSchema = z.object({
  fullName: z.string().min(2).max(100).trim(),
  age: z.number().int().min(4).max(18),
  grade: z.enum(GRADE_OPTIONS),
  avatarEmoji: z.string().max(8).optional(),
  aiProcessingAcknowledged: z.literal(true),
  privacyPolicyVersion: z.string().optional(),
  termsVersion: z.string().optional(),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: parentUser } = await supabase
    .from('users')
    .select('id, role, email')
    .eq('id', user.id)
    .single()

  if (!parentUser || parentUser.role !== 'parent') {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  const body = await req.json().catch(() => null)
  const parsed = CreateStudentSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json(
      { error: 'Invalid input', details: parsed.error.flatten() },
      { status: 400 }
    )
  }

  if (!parsed.data.aiProcessingAcknowledged) {
    return NextResponse.json(
      { error: 'Parental consent for AI processing is required.' },
      { status: 400 }
    )
  }

  const level = levelFromAge(parsed.data.age)
  const ip = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ?? 'unknown'
  const ua = req.headers.get('user-agent') ?? 'unknown'

  const serviceSupabase = await createServiceClient()

  const { data: student, error: studentError } = await serviceSupabase
    .from('student_profiles')
    .insert({
      parent_id: user.id,
      full_name: parsed.data.fullName,
      age: parsed.data.age,
      grade: parsed.data.grade,
      level,
      avatar_emoji: parsed.data.avatarEmoji ?? '🚀',
    })
    .select('id, full_name, level')
    .single()

  if (studentError || !student) {
    console.error('student_profiles insert:', studentError)
    return NextResponse.json({ error: 'Failed to create student profile.' }, { status: 500 })
  }

  await serviceSupabase.from('parental_consents').insert({
    parent_user_id: user.id,
    student_name: parsed.data.fullName,
    student_age: parsed.data.age,
    consent_method: 'checkbox_with_policy_link',
    ip_address: ip,
    user_agent: ua,
    privacy_policy_version: parsed.data.privacyPolicyVersion ?? PRIVACY_POLICY_VERSION,
    data_retention_acknowledged: true,
    ai_processing_acknowledged: true,
    marketing_opt_in: false,
  })

  await serviceSupabase.from('audit_logs').insert({
    user_id: user.id,
    action: 'student_profile_created',
    target_type: 'student_profile',
    target_id: student.id,
    metadata: {
      student_name: parsed.data.fullName,
      level,
      parent_email: parentUser.email,
    },
    ip_address: ip,
    user_agent: ua,
  })

  return NextResponse.json({
    ok: true,
    student_id: student.id,
    level: student.level,
  })
}
