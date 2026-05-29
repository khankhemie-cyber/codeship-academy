'use client'

import { useState } from 'react'
import { useRouter, useParams } from 'next/navigation'

export default function NewSchoolSessionPage() {
  const router = useRouter()
  const params = useParams()
  const locale = params.locale as string
  const [schoolId, setSchoolId] = useState('')
  const [date, setDate] = useState('')
  const [topic, setTopic] = useState('')
  const [studentCount, setStudentCount] = useState(20)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const res = await fetch('/api/schools/sessions', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        school_id: schoolId,
        date,
        topic,
        student_count: studentCount,
      }),
    })

    setLoading(false)
    if (res.ok) {
      router.push(`/${locale}/dashboard/school`)
    } else {
      const data = await res.json()
      setError(data.error || 'Failed to book session')
    }
  }

  return (
    <div className="max-w-lg space-y-6">
      <h1 className="text-2xl font-bold text-brand-navy">Book workshop session</h1>
      <form onSubmit={handleSubmit} className="card p-6 space-y-4">
        {error && <div className="p-3 bg-red-50 text-red-800 rounded-lg text-sm">{error}</div>}
        <div>
          <label className="label">School ID (UUID)</label>
          <input
            className="input"
            value={schoolId}
            onChange={(e) => setSchoolId(e.target.value)}
            required
            placeholder="From schools table"
          />
        </div>
        <div>
          <label className="label">Date</label>
          <input type="date" className="input" value={date} onChange={(e) => setDate(e.target.value)} required />
        </div>
        <div>
          <label className="label">Topic</label>
          <input className="input" value={topic} onChange={(e) => setTopic(e.target.value)} />
        </div>
        <div>
          <label className="label">Expected students</label>
          <input
            type="number"
            className="input"
            min={1}
            value={studentCount}
            onChange={(e) => setStudentCount(parseInt(e.target.value, 10))}
          />
        </div>
        <button type="submit" disabled={loading} className="btn-primary w-full">
          {loading ? 'Saving…' : 'Book session'}
        </button>
      </form>
    </div>
  )
}
