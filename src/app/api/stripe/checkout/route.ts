import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import Stripe from 'stripe'
import { z } from 'zod'
import { randomUUID } from 'crypto'

const CheckoutSchema = z.object({
  plan: z.enum(['monthly', 'annual', 'family', 'teacher', 'sessions_5', 'sessions_10', 'sessions_20', 'school_monthly', 'school_annual']),
})

const PRICE_MAP: Record<string, string> = {
  monthly:       process.env.STRIPE_PRICE_MONTHLY ?? '',
  annual:        process.env.STRIPE_PRICE_ANNUAL ?? '',
  family:        process.env.STRIPE_PRICE_FAMILY ?? '',
  teacher:       process.env.STRIPE_PRICE_TEACHER ?? '',
  sessions_5:    process.env.STRIPE_PRICE_SESSIONS_5 ?? '',
  sessions_10:   process.env.STRIPE_PRICE_SESSIONS_10 ?? '',
  sessions_20:   process.env.STRIPE_PRICE_SESSIONS_20 ?? '',
  school_monthly: process.env.STRIPE_PRICE_SCHOOL_MONTHLY ?? '',
  school_annual:  process.env.STRIPE_PRICE_SCHOOL_ANNUAL ?? '',
}

export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 })
  }

  const parsed = CheckoutSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid plan' }, { status: 400 })
  }

  const { plan } = parsed.data
  const priceId = PRICE_MAP[plan]
  if (!priceId) return NextResponse.json({ error: 'Plan not configured' }, { status: 500 })

  const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!)

  // Get or create Stripe customer
  let { data: subscription } = await supabase
    .from('subscriptions')
    .select('stripe_customer_id')
    .eq('user_id', user.id)
    .single()

  let customerId = subscription?.stripe_customer_id

  if (!customerId) {
    const { data: userData } = await supabase.from('users').select('email, full_name').eq('id', user.id).single()
    const customer = await stripe.customers.create({
      email: userData?.email ?? user.email,
      name: userData?.full_name ?? undefined,
      metadata: { supabase_user_id: user.id },
    })
    customerId = customer.id
  }

  const isOneTime = ['sessions_5', 'sessions_10', 'sessions_20'].includes(plan)
  const appUrl = process.env.NEXT_PUBLIC_APP_URL ?? 'http://localhost:3000'

  const session = await stripe.checkout.sessions.create(
    {
      customer: customerId,
      payment_method_types: ['card'],
      mode: isOneTime ? 'payment' : 'subscription',
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${appUrl}/en/dashboard/parent/subscription?success=1`,
      cancel_url: `${appUrl}/en/dashboard/parent/subscription?cancelled=1`,
      metadata: { user_id: user.id, plan },
      ...(isOneTime ? {} : { subscription_data: { metadata: { user_id: user.id, plan } } }),
    },
    { idempotencyKey: randomUUID() }
  )

  return NextResponse.json({ url: session.url })
}
