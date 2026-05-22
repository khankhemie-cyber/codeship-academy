'use client'

import { useState } from 'react'
import { useRouter, useParams } from 'next/navigation'

export default function NewClassPage() {
  const router = useRouter()
  const params = useParams()
  const locale = params.locale as string
  const [name, setName] = useState('')
  const [grade, setGrade] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const res = await fetch('/api/classes', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, grade: grade || null }),
    })

    setLoading(false)
    if (res.ok) {
      const data = await res.json()
      router.push(`/${locale}/dashboard/classes/${data.id}`)
    } else {
      const data = await res.json()
      setError(data.error || 'Failed to create class.')
    }
  }

  return (
    <div className="max-w-lg">
      <h1 className="text-2xl font-bold text-gray-900 mb-6">Create a New Class</h1>
      <div className="card p-6">
        <form onSubmit={handleSubmit} className="space-y-4">
          {error && (
            <div className="p-3 bg-red-50 text-red-800 border border-red-200 rounded-lg text-sm">{error}</div>
          )}
          <div>
            <label className="label">Class Name</label>
            <input
              type="text"
              className="input"
              value={name}
              onChange={e => setName(e.target.value)}
              placeholder="E.g. Grade 4 Coding Club"
              required
              minLength={3}
              maxLength={80}
            />
          </div>
          <div>
            <label className="label">Grade (optional)</label>
            <select className="input" value={grade} onChange={e => setGrade(e.target.value)}>
              <option value="">Select grade…</option>
              {['JK', 'SK', '1', '2', '3', '4', '5', '6', '7', '8'].map(g => (
                <option key={g} value={g}>Grade {g}</option>
              ))}
            </select>
          </div>
          <div className="flex gap-3 pt-2">
            <button type="button" onClick={() => router.back()} className="btn-secondary flex-1">
              Cancel
            </button>
            <button type="submit" disabled={loading} className="btn-primary flex-1">
              {loading ? 'Creating…' : 'Create Class'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
