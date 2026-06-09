'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function ParentAssessmentPage() {
  const router = useRouter()
  const [step, setStep] = useState(0)
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<Record<string, unknown> | null>(null)
  const [form, setForm] = useState({
    age: 8,
    grade: '2',
    experience: 'none',
    skills: { reading: 3, math: 3, logic: 3, focus: 3 },
    interests: [] as string[],
    goals: [] as string[],
  })

  async function submit() {
    setLoading(true)
    const res = await fetch('/api/ai/assessment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form),
    })
    setLoading(false)
    if (res.ok) {
      setResult(await res.json())
      setStep(4)
    }
  }

  return (
    <div className="max-w-xl space-y-6">
      <h1 className="text-2xl font-bold text-brand-navy">AI Placement Assessment</h1>
      <p className="text-gray-500 text-sm">
        Answer a few questions to get a recommended curriculum level. Nothing is saved until you confirm.
      </p>

      {step === 0 && (
        <div className="card space-y-4">
          <label className="label">Child&apos;s age</label>
          <input
            type="number"
            className="input"
            min={4}
            max={18}
            value={form.age}
            onChange={(e) => setForm({ ...form, age: parseInt(e.target.value, 10) })}
          />
          <button type="button" className="btn-primary" onClick={() => setStep(1)}>
            Next
          </button>
        </div>
      )}

      {step === 1 && (
        <div className="card space-y-4">
          <label className="label">Prior coding experience</label>
          <select
            className="input"
            value={form.experience}
            onChange={(e) => setForm({ ...form, experience: e.target.value })}
          >
            <option value="none">None</option>
            <option value="blocks">Block coding only</option>
            <option value="some">Some text-based coding</option>
            <option value="regular">Regular practice</option>
          </select>
          <div className="flex gap-2">
            <button type="button" className="btn-secondary" onClick={() => setStep(0)}>
              Back
            </button>
            <button type="button" className="btn-primary" onClick={() => setStep(2)}>
              Next
            </button>
          </div>
        </div>
      )}

      {step === 2 && (
        <div className="card space-y-4">
          <p className="text-sm text-gray-600">Rate skills from 1 (developing) to 5 (strong):</p>
          {(['reading', 'math', 'logic', 'focus'] as const).map((skill) => (
            <div key={skill}>
              <label className="label capitalize">{skill}</label>
              <input
                type="range"
                min={1}
                max={5}
                value={form.skills[skill]}
                onChange={(e) =>
                  setForm({
                    ...form,
                    skills: { ...form.skills, [skill]: parseInt(e.target.value, 10) },
                  })
                }
                className="w-full"
              />
            </div>
          ))}
          <div className="flex gap-2">
            <button type="button" className="btn-secondary" onClick={() => setStep(1)}>
              Back
            </button>
            <button type="button" className="btn-primary" onClick={() => setStep(3)}>
              Next
            </button>
          </div>
        </div>
      )}

      {step === 3 && (
        <div className="card space-y-4">
          <p className="text-sm">Ready to generate your recommendation?</p>
          <div className="flex gap-2">
            <button type="button" className="btn-secondary" onClick={() => setStep(2)}>
              Back
            </button>
            <button type="button" className="btn-primary" disabled={loading} onClick={submit}>
              {loading ? 'Analyzing…' : 'Get recommendation'}
            </button>
          </div>
        </div>
      )}

      {step === 4 && result && (
        <div className="card space-y-3">
          <h2 className="font-bold text-lg">Recommendation</h2>
          <p>
            <strong>Level:</strong> {(result as { recommendedLevel?: string }).recommendedLevel}
          </p>
          <p className="text-sm text-gray-600">{(result as { summary?: string }).summary}</p>
          <button
            type="button"
            className="btn-primary"
            onClick={() => router.push('/en/dashboard/parent/children')}
          >
            Add child with this level
          </button>
        </div>
      )}
    </div>
  )
}
