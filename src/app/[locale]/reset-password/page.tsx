'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useLocale } from 'next-intl'
import { createClient } from '@/lib/supabase/client'

export default function ResetPasswordPage() {
  const locale = useLocale()
  const [email, setEmail] = useState('')
  const [sent, setSent] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    const supabase = createClient()
    const { error: resetError } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/${locale}/reset-password/confirm`,
    })

    if (resetError) {
      setError(resetError.message)
    } else {
      setSent(true)
    }
    setLoading(false)
  }

  if (sent) {
    return (
      <div className="min-h-screen bg-brand-light flex items-center justify-center p-4">
        <div className="max-w-md w-full text-center card">
          <div className="text-6xl mb-4">✅</div>
          <h1 className="text-xl font-bold mb-2">Reset link sent!</h1>
          <p className="text-gray-600 mb-6">Check your email for the password reset link.</p>
          <Link href={`/${locale}/login`} className="btn-secondary">Back to Login</Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <Link href={`/${locale}`} className="font-extrabold text-2xl text-brand-navy">CODEship Academy</Link>
          <h1 className="text-xl font-bold mt-2">Reset your password</h1>
        </div>
        <div className="card">
          <form onSubmit={handleSubmit} noValidate>
            <div className="mb-6">
              <label htmlFor="reset-email" className="label">Email address</label>
              <input
                id="reset-email"
                type="email"
                autoComplete="email"
                required
                className="input"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            {error && (
              <div role="alert" className="mb-4 p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">{error}</div>
            )}
            <button type="submit" disabled={loading} className="w-full btn-primary disabled:opacity-50">
              {loading ? 'Sending…' : 'Send reset link'}
            </button>
          </form>
          <div className="mt-4 text-center text-sm">
            <Link href={`/${locale}/login`} className="text-brand-navy hover:underline">Back to login</Link>
          </div>
        </div>
      </div>
    </div>
  )
}
