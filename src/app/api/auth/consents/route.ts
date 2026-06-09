import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

const ConsentsSchema = z.object({
  weeklyDigest: z.boolean(),
  productUpdates: z.boolean(),
  promotions: z.boolean(),
  schoolNewsletter: z.boolean().optional(),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = ConsentsSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid input' }, { status: 400 })
  }

  const ip = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ?? null
  const ua = req.headers.get('user-agent') ?? null

  const rows: {
    user_id: string
    consent_type: 'weekly_digest' | 'product_updates' | 'promotions' | 'school_newsletter'
    consent_method: 'signup_form'
    ip_address: string | null
  }[] = []

  if (parsed.data.weeklyDigest) {
    rows.push({ user_id: user.id, consent_type: 'weekly_digest', consent_method: 'signup_form', ip_address: ip })
  }
  if (parsed.data.productUpdates) {
    rows.push({ user_id: user.id, consent_type: 'product_updates', consent_method: 'signup_form', ip_address: ip })
  }
  if (parsed.data.promotions) {
    rows.push({ user_id: user.id, consent_type: 'promotions', consent_method: 'signup_form', ip_address: ip })
  }
  if (parsed.data.schoolNewsletter) {
    rows.push({ user_id: user.id, consent_type: 'school_newsletter', consent_method: 'signup_form', ip_address: ip })
  }

  if (rows.length > 0) {
    const { error } = await supabase.from('email_consents').upsert(rows, {
      onConflict: 'user_id,consent_type',
    })
    if (error) {
      console.error('email_consents upsert:', error)
      return NextResponse.json({ error: 'Failed to save preferences' }, { status: 500 })
    }
  }

  void ua
  return NextResponse.json({ ok: true })
}
