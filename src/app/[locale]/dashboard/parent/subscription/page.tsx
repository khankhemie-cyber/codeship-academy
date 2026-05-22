import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import Link from 'next/link'

export default async function SubscriptionPage({ params }: { params: { locale: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, subscription_plan, subscription_status, trial_ends_at, stripe_customer_id')
    .eq('user_id', user.id)
    .single()

  const isTrialing = profile?.subscription_status === 'trialing'
  const isActive = profile?.subscription_status === 'active'
  const isCanceled = profile?.subscription_status === 'canceled'
  const trialDaysLeft = profile?.trial_ends_at
    ? Math.max(0, Math.ceil((new Date(profile.trial_ends_at).getTime() - Date.now()) / (86400 * 1000)))
    : 0

  const planNames: Record<string, string> = {
    free: 'Free',
    individual: 'Individual — $9.99/mo',
    family: 'Family — $17.99/mo',
    school: 'School',
  }

  const PLANS = [
    {
      key: 'individual',
      name: 'Individual',
      price: '$9.99',
      period: '/month',
      features: ['1 child account', 'All curriculum levels', 'AI Tutor', 'Progress reports', 'Certificates'],
      highlighted: false,
    },
    {
      key: 'family',
      name: 'Family',
      price: '$17.99',
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
              {planNames[profile?.subscription_plan || 'free'] || 'Free'}
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
      {(!isActive || profile?.subscription_plan === 'free') && (
        <div>
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            {isTrialing ? 'Choose a plan before your trial ends' : 'Upgrade your plan'}
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
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
                <form action="/api/stripe/checkout" method="POST">
                  <input type="hidden" name="plan" value={plan.key} />
                  <button
                    type="submit"
                    className={`w-full py-2 rounded-lg font-semibold transition-colors ${plan.highlighted ? 'btn-primary' : 'btn-secondary'}`}
                  >
                    Subscribe to {plan.name}
                  </button>
                </form>
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
