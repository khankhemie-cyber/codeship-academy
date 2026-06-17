'use client'

import { useState } from 'react'

interface Child {
  id: string
  full_name: string
  level: string
}

interface PlanDay {
  day: string
  lessonTitle: string
  estimatedMinutes: number
  estimatedXP: number
  type: string
}
interface PlanWeek {
  weekNumber: number
  theme: string
  days: PlanDay[]
  milestone: string
  estimatedXP: number
}
interface Plan {
  weeks: PlanWeek[]
  totalXP: number
  summary: string
}

export default function PlannerForm({ students }: { students: Child[] }) {
  const [studentId, setStudentId] = useState(students[0]?.id ?? '')
  const [daysPerWeek, setDaysPerWeek] = useState(3)
  const [minutesPerSession, setMinutesPerSession] = useState(30)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [plan, setPlan] = useState<Plan | null>(null)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    if (!studentId) {
      setError('Add a child first to generate a plan.')
      return
    }
    setLoading(true)
    setError(null)
    setPlan(null)
    try {
      const res = await fetch('/api/ai/planner', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ studentId, daysPerWeek, minutesPerSession }),
      })
      const data = await res.json()
      if (res.ok) setPlan(data)
      else setError(data.error ?? 'Could not generate a plan. Please try again.')
    } catch {
      setError('Could not generate a plan. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <form onSubmit={submit} className="card p-6 space-y-5">
        <div>
          <label htmlFor="child" className="label">Child</label>
          <select id="child" className="input" value={studentId} onChange={(e) => setStudentId(e.target.value)}>
          {students.length === 0 && <option value="">No children yet</option>}
          {students.map((c) => (
              <option key={c.id} value={c.id}>{c.full_name} · {c.level}</option>
            ))}
          </select>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label htmlFor="days" className="label">Days per week</label>
            <input id="days" type="number" min={1} max={7} className="input" value={daysPerWeek}
              onChange={(e) => setDaysPerWeek(parseInt(e.target.value || '3', 10))} />
          </div>
          <div>
            <label htmlFor="mins" className="label">Minutes per session</label>
            <input id="mins" type="number" min={10} max={120} step={5} className="input" value={minutesPerSession}
              onChange={(e) => setMinutesPerSession(parseInt(e.target.value || '30', 10))} />
          </div>
        </div>
        {error && <div role="alert" className="p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">{error}</div>}
        <button type="submit" disabled={loading} className="btn-primary w-full disabled:opacity-50">
          {loading ? 'Generating plan…' : 'Generate 4-Week Plan'}
        </button>
      </form>

      {plan && (
        <div className="space-y-4">
          <div className="card p-5 bg-brand-light">
            <p className="text-sm text-gray-700">{plan.summary}</p>
            <p className="text-sm font-bold text-brand-navy mt-2">Estimated total: {plan.totalXP} XP</p>
          </div>
          {plan.weeks?.map((week) => (
            <div key={week.weekNumber} className="card p-5">
              <h3 className="font-bold text-brand-navy">Week {week.weekNumber}: {week.theme}</h3>
              <ul className="mt-3 space-y-2">
                {week.days?.map((d, i) => (
                  <li key={i} className="flex items-center justify-between text-sm border-b border-gray-100 pb-2">
                    <span className="font-semibold text-gray-700 w-24">{d.day}</span>
                    <span className="flex-1 text-gray-700">{d.lessonTitle}</span>
                    <span className="text-gray-400">{d.estimatedMinutes}m · {d.estimatedXP}XP</span>
                  </li>
                ))}
              </ul>
              {week.milestone && <p className="text-xs text-brand-mid mt-3">🎯 {week.milestone}</p>}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
