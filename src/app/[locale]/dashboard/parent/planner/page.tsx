'use client'

import { useState } from 'react'

export default function ParentPlannerPage() {
  const [studentId, setStudentId] = useState('')
  const [daysPerWeek, setDaysPerWeek] = useState(3)
  const [minutes, setMinutes] = useState(30)
  const [focus, setFocus] = useState('balanced')
  const [plan, setPlan] = useState<Record<string, unknown> | null>(null)
  const [loading, setLoading] = useState(false)

  async function generate() {
    if (!studentId) return
    setLoading(true)
    const res = await fetch('/api/ai/planner', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        studentId,
        daysPerWeek,
        minutesPerSession: minutes,
        focusPreference: focus,
      }),
    })
    setLoading(false)
    if (res.ok) setPlan(await res.json())
  }

  return (
    <div className="max-w-2xl space-y-6">
      <h1 className="text-2xl font-bold text-brand-navy">AI Learning Planner</h1>
      <p className="text-gray-500 text-sm">Generate a 4-week learning plan for your child.</p>

      <div className="card space-y-4">
        <div>
          <label htmlFor="planner-student" className="label">
            Student profile ID
          </label>
          <input
            id="planner-student"
            className="input"
            value={studentId}
            onChange={(e) => setStudentId(e.target.value)}
            placeholder="Paste student UUID from My Children"
          />
        </div>
        <div>
          <label className="label">Days per week</label>
          <input
            type="number"
            className="input"
            min={1}
            max={7}
            value={daysPerWeek}
            onChange={(e) => setDaysPerWeek(parseInt(e.target.value, 10))}
          />
        </div>
        <div>
          <label className="label">Minutes per session</label>
          <input
            type="number"
            className="input"
            min={15}
            max={90}
            value={minutes}
            onChange={(e) => setMinutes(parseInt(e.target.value, 10))}
          />
        </div>
        <div>
          <label className="label">Focus</label>
          <select className="input" value={focus} onChange={(e) => setFocus(e.target.value)}>
            <option value="balanced">Balanced</option>
            <option value="lessons">More lessons</option>
            <option value="projects">More projects</option>
          </select>
        </div>
        <button type="button" className="btn-primary" disabled={loading || !studentId} onClick={generate}>
          {loading ? 'Generating…' : 'Generate 4-week plan'}
        </button>
      </div>

      {plan && (
        <div className="card">
          <h2 className="font-bold mb-2">Your plan</h2>
          <pre className="text-xs overflow-auto bg-gray-50 p-4 rounded-lg">
            {JSON.stringify(plan, null, 2)}
          </pre>
        </div>
      )}
    </div>
  )
}
