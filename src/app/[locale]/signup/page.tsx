'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'

export default function SignupPage() {
  const router = useRouter()
  const [form, setForm] = useState({
    fullName: '',
    email: '',
    password: '',
    role: 'parent' as 'parent' | 'teacher',
    weeklyDigest: false,
    productUpdates: false,
    promotionalOffers: false,
    schoolNewsletter: false,
    termsAccepted: false,
    privacyAccepted: false,
  })
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  function update(field: string, value: string | boolean) {
    setForm((prev) => ({ ...prev, [field]: value }))
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)

    if (!form.termsAccepted || !form.privacyAccepted) {
      setError('You must accept the Terms of Service and Privacy Policy to continue.')
      return
    }
    if (form.password.length < 8) {
      setError('Password must be at least 8 characters.')
      return
    }

    setLoading(true)

    const supabase = createClient()
    const { data, error: authError } = await supabase.auth.signUp({
      email: form.email,
      password: form.password,
      options: {
        data: { full_name: form.fullName, role: form.role },
        emailRedirectTo: `${window.location.origin}/en/verify-email`,
      },
    })

    if (authError) {
      setError(authError.message)
      setLoading(false)
      return
    }

    if (data.user) {
      // Store email consents
      const consentTypes = [
        { type: 'weekly_digest', given: form.weeklyDigest },
        { type: 'product_updates', given: form.productUpdates },
        { type: 'promotions', given: form.promotionalOffers },
        { type: 'school_newsletter', given: form.schoolNewsletter && form.role === 'teacher' },
      ].filter((c) => c.given)

      if (consentTypes.length > 0) {
        await supabase.from('email_consents').insert(
          consentTypes.map((c) => ({
            user_id: data.user!.id,
            consent_type: c.type as 'weekly_digest' | 'product_updates' | 'promotions' | 'school_newsletter',
            consent_method: 'signup_form' as const,
          }))
        )
      }

      router.push('/en/verify-email')
    }
  }

  return (
    <div className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="w-full max-w-lg">
        <div className="text-center mb-8">
          <Link href="/en" className="font-extrabold text-2xl text-brand-navy">
            CODEship Academy
          </Link>
          <h1 className="text-xl font-bold text-brand-dark mt-2">Create your account</h1>
          <p className="text-gray-500 text-sm mt-1">14-day free trial · No credit card required</p>
        </div>

        <div className="card">
          <form onSubmit={handleSubmit} noValidate>
            {/* Role selection */}
            <fieldset className="mb-6">
              <legend className="label mb-2">I am a…</legend>
              <div className="flex gap-4">
                {(['parent', 'teacher'] as const).map((role) => (
                  <label
                    key={role}
                    className={`flex-1 border-2 rounded-xl p-4 text-center cursor-pointer transition-colors ${
                      form.role === role
                        ? 'border-brand-gold bg-yellow-50'
                        : 'border-gray-200 hover:border-gray-300'
                    }`}
                  >
                    <input
                      type="radio"
                      name="role"
                      value={role}
                      checked={form.role === role}
                      onChange={() => update('role', role)}
                      className="sr-only"
                    />
                    <div className="text-2xl mb-1">{role === 'parent' ? '👪' : '🍎'}</div>
                    <div className="font-bold capitalize">{role}</div>
                  </label>
                ))}
              </div>
            </fieldset>

            <div className="mb-4">
              <label htmlFor="fullName" className="label">Full name</label>
              <input
                id="fullName"
                type="text"
                autoComplete="name"
                required
                className="input"
                value={form.fullName}
                onChange={(e) => update('fullName', e.target.value)}
              />
            </div>

            <div className="mb-4">
              <label htmlFor="signup-email" className="label">Email address</label>
              <input
                id="signup-email"
                type="email"
                autoComplete="email"
                required
                className="input"
                value={form.email}
                onChange={(e) => update('email', e.target.value)}
              />
            </div>

            <div className="mb-6">
              <label htmlFor="signup-password" className="label">Password</label>
              <input
                id="signup-password"
                type="password"
                autoComplete="new-password"
                required
                minLength={8}
                className="input"
                value={form.password}
                onChange={(e) => update('password', e.target.value)}
              />
              <p className="text-xs text-gray-500 mt-1">At least 8 characters</p>
            </div>

            {/* Email preferences — CASL compliant, none pre-ticked */}
            <fieldset className="mb-6 p-4 bg-gray-50 rounded-xl">
              <legend className="text-sm font-bold text-brand-dark mb-3">
                Email preferences (optional)
              </legend>
              <p className="text-xs text-gray-500 mb-3">
                You will always receive important account and security emails. These are optional:
              </p>
              {[
                { key: 'weeklyDigest', label: form.role === 'parent' ? 'Weekly progress report for my child' : 'Weekly class summary' },
                { key: 'productUpdates', label: 'New features and curriculum updates' },
                { key: 'promotionalOffers', label: 'Special offers and discounts' },
                ...(form.role === 'teacher' ? [{ key: 'schoolNewsletter', label: 'Workshop schedules and school updates' }] : []),
              ].map(({ key, label }) => (
                <label key={key} className="flex items-start gap-3 mb-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={form[key as keyof typeof form] as boolean}
                    onChange={(e) => update(key, e.target.checked)}
                    className="mt-0.5"
                  />
                  <span className="text-sm text-gray-700">{label}</span>
                </label>
              ))}
            </fieldset>

            {/* Required consents */}
            <div className="mb-6 space-y-3">
              <label className="flex items-start gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  required
                  checked={form.termsAccepted}
                  onChange={(e) => update('termsAccepted', e.target.checked)}
                  className="mt-0.5"
                  aria-describedby="terms-desc"
                />
                <span id="terms-desc" className="text-sm text-gray-700">
                  I accept the{' '}
                  <Link href="/en/terms" target="_blank" className="text-brand-navy underline">
                    Terms of Service
                  </Link>
                </span>
              </label>

              <label className="flex items-start gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  required
                  checked={form.privacyAccepted}
                  onChange={(e) => update('privacyAccepted', e.target.checked)}
                  className="mt-0.5"
                  aria-describedby="privacy-desc"
                />
                <span id="privacy-desc" className="text-sm text-gray-700">
                  I have read and agree to the{' '}
                  <Link href="/en/privacy" target="_blank" className="text-brand-navy underline">
                    Privacy Policy
                  </Link>
                  , including how we process data for children under 13
                </span>
              </label>
            </div>

            {error && (
              <div role="alert" className="mb-4 p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Creating account…' : 'Create account — Start free trial'}
            </button>
          </form>

          <div className="mt-6 pt-6 border-t border-gray-100 text-center text-sm text-gray-600">
            Already have an account?{' '}
            <Link href="/en/login" className="text-brand-navy font-bold hover:underline">
              Sign in
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}
