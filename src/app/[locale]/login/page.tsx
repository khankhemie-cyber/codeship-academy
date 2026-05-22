'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'

export default function LoginPage({ params }: { params: Promise<{ locale: string }> }) {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    const supabase = createClient()
    const { data, error: authError } = await supabase.auth.signInWithPassword({ email, password })

    if (authError) {
      setError(authError.message)
      setLoading(false)
      return
    }

    if (data.user) {
      const { data: userData } = await supabase
        .from('users')
        .select('role')
        .eq('id', data.user.id)
        .single()

      const role = userData?.role ?? 'parent'
      router.push(`/en/dashboard/${role}`)
    }
  }

  return (
    <div className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <Link href="/en" className="font-extrabold text-2xl text-brand-navy">
            CODEship Academy
          </Link>
          <h1 className="text-xl font-bold text-brand-dark mt-2">Welcome back!</h1>
        </div>

        <div className="card">
          <form onSubmit={handleSubmit} noValidate>
            <div className="mb-4">
              <label htmlFor="email" className="label">Email address</label>
              <input
                id="email"
                type="email"
                autoComplete="email"
                required
                className="input"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                aria-describedby={error ? 'login-error' : undefined}
                aria-invalid={!!error}
              />
            </div>

            <div className="mb-6">
              <label htmlFor="password" className="label">Password</label>
              <input
                id="password"
                type="password"
                autoComplete="current-password"
                required
                className="input"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>

            {error && (
              <div
                id="login-error"
                role="alert"
                className="mb-4 p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm"
              >
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Signing in…' : 'Sign in'}
            </button>
          </form>

          <div className="mt-4 text-center text-sm">
            <Link href="/en/reset-password" className="text-brand-navy hover:underline">
              Forgot your password?
            </Link>
          </div>

          <div className="mt-6 pt-6 border-t border-gray-100 text-center text-sm text-gray-600">
            Don&apos;t have an account?{' '}
            <Link href="/en/signup" className="text-brand-navy font-bold hover:underline">
              Start free trial
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}
