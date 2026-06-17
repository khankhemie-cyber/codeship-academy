'use client'

import { useState } from 'react'

export default function SubscribeButton({
  plan,
  label,
  highlighted,
}: {
  plan: string
  label: string
  highlighted?: boolean
}) {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function startCheckout() {
    setLoading(true)
    setError(null)
    try {
      const res = await fetch('/api/stripe/checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plan }),
      })
      const data = await res.json()
      if (res.ok && data.url) {
        window.location.href = data.url
      } else {
        setError(data.error ?? 'Could not start checkout. Please try again.')
        setLoading(false)
      }
    } catch {
      setError('Could not start checkout. Please try again.')
      setLoading(false)
    }
  }

  return (
    <div>
      <button
        type="button"
        onClick={startCheckout}
        disabled={loading}
        className={`w-full py-2 rounded-lg font-semibold transition-colors disabled:opacity-50 ${
          highlighted ? 'btn-primary' : 'btn-secondary'
        }`}
      >
        {loading ? 'Redirecting…' : label}
      </button>
      {error && (
        <p role="alert" className="text-xs text-red-600 mt-2">
          {error}
        </p>
      )}
    </div>
  )
}
