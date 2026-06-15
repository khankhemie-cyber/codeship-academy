import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import Link from 'next/link'
import SubscribeButton from '@/components/parent/SubscribeButton'

export default async function SubscriptionPage({ params }: { params: { locale: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, subscription_plan, subscription_status, trial_ends_at, stripe_customer_id')
    .eq('user_id', user.id)
    .single()

  const isTrialing = profile?.subscription_status === 'trial'
  const isActive = profile?.subscription_status === 'active'
  const isCanceled = profile?.subscription_status === 'cancelled'
  const trialDaysLeft = profile?.trial_ends_at
    ? Math.max(0, Math.ceil((new Date(profile.trial_ends_at).getTime() - Date.now()) / (86400 * 1000)))
    : 0

  const planNames: Record<string, string> = {
    trial: 'Free Trial',
    monthly: 'Personal — $19/mo',
    annual: 'Personal Annual — $149/yr',
    family: 'Family — $29/mo',
    teacher: 'Teacher — $49/mo',
    school_monthly: 'School — $299/mo',
    school_annual: 'School — $2,499/yr',
  }

  const PLANS = [
    {
      key: 'monthly',
      name: 'Personal Monthly',
      price: '$19',
      period: '/month',
      features: ['1 child account', 'All curriculum levels', 'AI Tutor', 'Progress reports', 'Certificates'],
      highlighted: false,
    },
    {
      key: 'annual',
      name: 'Personal Annual',
      price: '$149',
      period: '/year',
      features: ['1 child account', 'All curriculum levels', 'AI Tutor', 'Save vs monthly', 'Certificates'],
      highlighted: false,
    },
    {
      key: 'family',
      name: 'Family',
      price: '$29',
      period: '/month',
      features: ['Up to 4 children', 'All curriculum levels', 'AI Tutor', 'Progress reports', 'Certificates', 'Priority support'],
      highlighted: true,
    },
  ]

  return (
    <div className="max-w-3xl space-y-8">
      <h1 className="text-2xl font-bold text-gray-900">Subscription</h1>

      {/* Current plan */}
      <div className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Current Plan</h2>
        <div className="flex items-center justify-between">
          <div>
            <p className="text-xl font-bold text-brand-navy">
              {planNames[profile?.subscription_plan || 'trial'] || 'Free Trial'}
            </p>
            {isTrialing && (
              <p className="text-sm text-orange-600 mt-1">Free trial · {trialDaysLeft} days remaining</p>
            )}
            {isActive && <p className="text-sm text-green-600 mt-1">Active ✓</p>}
            {isCanceled && <p className="text-sm text-red-600 mt-1">Canceled — access ends at period end</p>}
          </div>
          {profile?.stripe_customer_id && isActive && (
            <form action="/api/stripe/portal" method="POST">
              <button type="submit" className="btn-secondary">
                Manage Billing
              </button>
            </form>
          )}
        </div>
      </div>

      {/* Upgrade options */}
      {!isActive && (
        <div>
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            {isTrialing ? 'Choose a plan before your trial ends' : 'Upgrade your plan'}
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {PLANS.map(plan => (
              <div key={plan.key} className={`card p-6 ${plan.highlighted ? 'border-2 border-brand-gold' : ''}`}>
                {plan.highlighted && (
                  <div className="text-xs font-bold text-brand-gold uppercase tracking-wide mb-2">Most Popular</div>
                )}
                <h3 className="text-xl font-bold text-gray-900">{plan.name}</h3>
                <div className="flex items-baseline gap-1 my-3">
                  <span className="text-3xl font-bold text-brand-navy">{plan.price}</span>
                  <span className="text-gray-500">{plan.period}</span>
                </div>
                <ul className="space-y-2 mb-6">
                  {plan.features.map(f => (
                    <li key={f} className="flex items-center gap-2 text-sm text-gray-700">
                      <span className="text-brand-gold font-bold">✓</span>
                      {f}
                    </li>
                  ))}
                </ul>
                <SubscribeButton plan={plan.key} label={`Subscribe to ${plan.name}`} highlighted={plan.highlighted} />
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="card p-4 bg-gray-50 border border-gray-200">
        <p className="text-sm text-gray-600">
          All plans include a 14-day free trial. Cancel anytime. Payments processed securely by Stripe.
          For school pricing, <Link href={`/${params.locale}#schools`} className="text-brand-navy underline">contact us</Link>.
        </p>
      </div>
    </div>
  )
}
