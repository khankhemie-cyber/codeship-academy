import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import Link from 'next/link'
import CheckoutButton from '@/components/billing/CheckoutButton'

export default async function SubscriptionPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent', locale)

  const { data: subscription } = await supabase
    .from('subscriptions')
    .select('*')
    .eq('user_id', user.id)
    .single()

  const isTrial = subscription?.status === 'trial'
  const isActive = subscription?.status === 'active'
  const trialDaysLeft = subscription?.trial_ends_at
    ? Math.max(0, Math.ceil((new Date(subscription.trial_ends_at).getTime() - Date.now()) / 86400000))
    : 14

  const PLANS = [
    {
      key: 'monthly',
      name: 'Personal Monthly',
      price: '$19',
      period: '/month',
      features: ['1 child', 'All levels', 'AI tutor', 'Weekly digest'],
    },
    {
      key: 'annual',
      name: 'Personal Annual',
      price: '$149',
      period: '/year',
      features: ['1 child', 'Save vs monthly', 'All features'],
    },
    {
      key: 'family',
      name: 'Family',
      price: '$29',
      period: '/month',
      features: ['Up to 4 children', 'All levels', 'Priority support'],
      highlighted: true,
    },
  ]

  return (
    <div className="max-w-3xl space-y-8">
      <h1 className="text-2xl font-bold text-gray-900">Subscription</h1>

      <div className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Current Plan</h2>
        <p className="text-xl font-bold text-brand-navy capitalize">
          {subscription?.plan ?? 'trial'}
        </p>
        {isTrial && (
          <p className="text-sm text-orange-600 mt-1">Free trial · {trialDaysLeft} days remaining</p>
        )}
        {isActive && <p className="text-sm text-green-600 mt-1">Active</p>}
        {subscription?.stripe_customer_id && (
          <form action="/api/stripe/portal" method="POST" className="mt-4">
            <button type="submit" className="btn-secondary">
              Manage Billing
            </button>
          </form>
        )}
      </div>

      {(!isActive || isTrial) && (
        <div>
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Choose a plan</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {PLANS.map((plan) => (
              <div
                key={plan.key}
                className={`card p-6 ${plan.highlighted ? 'border-2 border-brand-gold' : ''}`}
              >
                <h3 className="text-xl font-bold">{plan.name}</h3>
                <div className="flex items-baseline gap-1 my-3">
                  <span className="text-3xl font-bold text-brand-navy">{plan.price}</span>
                  <span className="text-gray-500">{plan.period}</span>
                </div>
                <ul className="space-y-2 mb-6 text-sm">
                  {plan.features.map((f) => (
                    <li key={f}>✓ {f}</li>
                  ))}
                </ul>
                <CheckoutButton plan={plan.key} label={`Subscribe to ${plan.name}`} />
              </div>
            ))}
          </div>
        </div>
      )}

      <p className="text-sm text-gray-600">
        14-day free trial · Cancel anytime · Payments by Stripe.{' '}
        <Link href={`/${locale}#schools`} className="underline text-brand-navy">
          School pricing
        </Link>
      </p>
    </div>
  )
}
