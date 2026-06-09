import { NextRequest, NextResponse } from 'next/server'
import { createClient, createServiceClient } from '@/lib/supabase/server'
import Stripe from 'stripe'
import { z } from 'zod'

const DeleteSchema = z.object({
  confirm: z.literal('DELETE'),
})

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const body = await req.json().catch(() => null)
  const parsed = DeleteSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Type DELETE to confirm.' }, { status: 400 })
  }

  const ip = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ?? 'unknown'
  const serviceSupabase = await createServiceClient()

  const { data: subscription } = await supabase
    .from('subscriptions')
    .select('stripe_subscription_id, stripe_customer_id')
    .eq('user_id', user.id)
    .single()

  if (subscription?.stripe_subscription_id && process.env.STRIPE_SECRET_KEY) {
    try {
      const stripe = new Stripe(process.env.STRIPE_SECRET_KEY)
      await stripe.subscriptions.cancel(subscription.stripe_subscription_id)
    } catch (err) {
      console.error('Stripe cancel on delete:', err)
    }
  }

  await serviceSupabase
    .from('users')
    .update({ deleted_at: new Date().toISOString() })
    .eq('id', user.id)

  await serviceSupabase.from('audit_logs').insert({
    user_id: user.id,
    action: 'account_deletion_requested',
    target_type: 'user',
    target_id: user.id,
    metadata: {
      grace_days: 30,
      scheduled_hard_delete: new Date(Date.now() + 30 * 86400000).toISOString(),
    },
    ip_address: ip,
    user_agent: req.headers.get('user-agent') ?? 'unknown',
  })

  return NextResponse.json({
    ok: true,
    message: 'Your account and data will be permanently deleted within 30 days.',
  })
}
