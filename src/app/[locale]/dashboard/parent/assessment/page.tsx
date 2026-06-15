'use client'

import { useState } from 'react'

interface AssessmentResult {
  recommendedLevel: string
  confidence: string
  rationale: string
  learningStyle: string
  suggestedFirstLesson: string
  goals: string[]
  parentTips: string[]
}

const LEVEL_LABELS: Record<string, string> = {
  explorers: '🌱 Explorers (K–1)',
  builders: '🏗️ Builders (Gr 2–3)',
  developers: '💻 Developers (Gr 4–6)',
  engineers: '⚙️ Engineers (Gr 7–8)',
}

export default function AssessmentPage() {
  const [studentName, setStudentName] = useState('')
  const [age, setAge] = useState(7)
  const [grade, setGrade] = useState('1')
  const [experience, setExperience] = useState<'none' | 'some' | 'lots'>('none')
  const [skills, setSkills] = useState({ reading: 3, math: 3, logic: 3, focus: 3 })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [result, setResult] = useState<AssessmentResult | null>(null)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)
    setResult(null)
    try {
      const res = await fetch('/api/ai/assessment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ studentName, age, grade, experience, skills }),
      })
      const data = await res.json()
      if (res.ok) setResult(data)
      else setError(data.error ?? 'Assessment failed. Please try again.')
    } catch {
      setError('Assessment failed. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-2xl space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">AI Placement Assessment</h1>
        <p className="text-gray-500 mt-1">
          Answer a few questions and our AI will recommend the best starting level for your child.
        </p>
      </div>

      {!result && (
        <form onSubmit={submit} className="card p-6 space-y-5">
          <div>
            <label htmlFor="name" className="label">Child&apos;s first name</label>
            <input id="name" className="input" value={studentName} required minLength={1}
              onChange={(e) => setStudentName(e.target.value)} placeholder="E.g. Alex" />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label htmlFor="age" className="label">Age</label>
              <input id="age" type="number" min={4} max={18} className="input" value={age}
                onChange={(e) => setAge(parseInt(e.target.value || '7', 10))} />
            </div>
            <div>
              <label htmlFor="grade" className="label">Grade</label>
              <select id="grade" className="input" value={grade} onChange={(e) => setGrade(e.target.value)}>
                {['K', '1', '2', '3', '4', '5', '6', '7', '8'].map((g) => (
                  <option key={g} value={g}>{g === 'K' ? 'Kindergarten' : `Grade ${g}`}</option>
                ))}
              </select>
            </div>
          </div>

          <div>
            <label htmlFor="exp" className="label">Prior coding experience</label>
            <select id="exp" className="input" value={experience}
              onChange={(e) => setExperience(e.target.value as 'none' | 'some' | 'lots')}>
              <option value="none">No experience</option>
              <option value="some">Some basic experience</option>
              <option value="lots">Lots of experience</option>
            </select>
          </div>

          <fieldset className="space-y-3">
            <legend className="label">Rate these skills (1 = beginning, 5 = strong)</legend>
            {(['reading', 'math', 'logic', 'focus'] as const).map((skill) => (
              <div key={skill} className="flex items-center justify-between gap-4">
                <span className="text-sm capitalize text-gray-700 w-24">{skill}</span>
                <input
                  type="range" min={1} max={5} value={skills[skill]}
                  aria-label={`${skill} rating`}
                  onChange={(e) => setSkills((s) => ({ ...s, [skill]: parseInt(e.target.value, 10) }))}
                  className="flex-1"
                />
                <span className="font-bold text-brand-navy w-6 text-center">{skills[skill]}</span>
              </div>
            ))}
          </fieldset>

          {error && <div role="alert" className="p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm">{error}</div>}

          <button type="submit" disabled={loading} className="btn-primary w-full disabled:opacity-50">
            {loading ? 'Analysing…' : 'Run Assessment'}
          </button>
        </form>
      )}

      {result && (
        <div className="space-y-4">
          <div className="card p-6 bg-brand-navy text-white">
            <p className="text-sm opacity-75">Recommended level</p>
            <p className="text-2xl font-extrabold text-brand-gold mt-1">
              {LEVEL_LABELS[result.recommendedLevel] ?? result.recommendedLevel}
            </p>
            <p className="text-sm opacity-90 mt-3">{result.rationale}</p>
          </div>

          <div className="grid md:grid-cols-2 gap-4">
            <div className="card p-5">
              <h2 className="font-bold text-brand-navy mb-2">Goals</h2>
              <ul className="text-sm text-gray-700 space-y-1 list-disc pl-4">
                {result.goals?.map((g, i) => <li key={i}>{g}</li>)}
              </ul>
            </div>
            <div className="card p-5">
              <h2 className="font-bold text-brand-navy mb-2">Tips for parents</h2>
              <ul className="text-sm text-gray-700 space-y-1 list-disc pl-4">
                {result.parentTips?.map((t, i) => <li key={i}>{t}</li>)}
              </ul>
            </div>
          </div>

          <button onClick={() => setResult(null)} className="btn-secondary">Run another assessment</button>
        </div>
      )}
    </div>
  )
}
