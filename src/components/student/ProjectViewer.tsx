'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

interface Project {
  id: string
  slug: string
  title: string
  description: string
  level: string
  difficulty: string
  duration_minutes: number
  xp_reward: number
  starter_code: string | null
  instructions: string | null
  learning_objectives: string[]
}

interface Submission {
  id: string
  code: string
  notes: string | null
  status: string
  submitted_at: string
}

interface Props {
  project: Project
  studentId: string
  existingSubmission?: Submission | null
  locale: string
}

export default function ProjectViewer({ project, studentId, existingSubmission, locale }: Props) {
  const router = useRouter()
  const [tab, setTab] = useState<'instructions' | 'code' | 'preview'>('instructions')
  const [code, setCode] = useState(existingSubmission?.code || project.starter_code || '')
  const [notes, setNotes] = useState(existingSubmission?.notes || '')
  const [submitting, setSubmitting] = useState(false)
  const [submitted, setSubmitted] = useState(!!existingSubmission)
  const [message, setMessage] = useState<string | null>(null)

  async function handleSubmit() {
    setSubmitting(true)
    setMessage(null)
    const res = await fetch('/api/projects/submit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        project_id: project.id,
        code,
        notes,
      }),
    })
    setSubmitting(false)
    if (res.ok) {
      setSubmitted(true)
      setMessage('Project submitted for review! 🎉')
    } else {
      const data = await res.json()
      setMessage(data.error || 'Failed to submit. Please try again.')
    }
  }

  const previewSrc = `data:text/html;charset=utf-8,${encodeURIComponent(code)}`

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <span className="badge badge-blue capitalize">{project.level}</span>
            <span className="badge badge-gray capitalize">{project.difficulty}</span>
            <span className="text-sm text-gray-500">{project.duration_minutes} min</span>
          </div>
          <h1 className="text-2xl font-bold text-gray-900">{project.title}</h1>
          <p className="text-gray-600 mt-1">{project.description}</p>
        </div>
        <div className="text-right">
          <p className="text-2xl font-bold text-brand-gold">{project.xp_reward} XP</p>
          <p className="text-xs text-gray-500">on completion</p>
        </div>
      </div>

      {message && (
        <div className={`p-3 rounded-lg text-sm font-medium ${message.includes('🎉') ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'}`}>
          {message}
        </div>
      )}

      {submitted && existingSubmission?.status && (
        <div className="card p-3 bg-blue-50 border border-blue-200">
          <p className="text-sm text-blue-800">
            Status: <span className="font-semibold capitalize">{existingSubmission.status.replace('_', ' ')}</span>
            {existingSubmission.status === 'approved' && ' ✓ Your project has been approved!'}
          </p>
        </div>
      )}

      {/* Tabs */}
      <div className="border-b border-gray-200">
        <div className="flex gap-1">
          {(['instructions', 'code', 'preview'] as const).map(t => (
            <button
              key={t}
              onClick={() => setTab(t)}
              className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors capitalize ${tab === t ? 'border-brand-navy text-brand-navy' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
            >
              {t === 'instructions' ? '📋 Instructions' : t === 'code' ? '💻 Code Editor' : '👁️ Preview'}
            </button>
          ))}
        </div>
      </div>

      {/* Instructions */}
      {tab === 'instructions' && (
        <div className="space-y-4">
          {project.learning_objectives && project.learning_objectives.length > 0 && (
            <div className="card p-4">
              <h3 className="font-semibold text-gray-800 mb-2">Learning Objectives</h3>
              <ul className="space-y-1">
                {project.learning_objectives.map((obj, i) => (
                  <li key={i} className="text-sm text-gray-700 flex items-start gap-2">
                    <span className="text-brand-gold font-bold mt-0.5">✓</span>
                    {obj}
                  </li>
                ))}
              </ul>
            </div>
          )}
          {project.instructions && (
            <div className="card p-4 prose prose-sm max-w-none">
              <div className="whitespace-pre-wrap text-gray-700 text-sm leading-relaxed">
                {project.instructions}
              </div>
            </div>
          )}
          <button onClick={() => setTab('code')} className="btn-primary">
            Open Code Editor →
          </button>
        </div>
      )}

      {/* Code Editor */}
      {tab === 'code' && (
        <div className="space-y-4">
          <textarea
            value={code}
            onChange={e => setCode(e.target.value)}
            className="w-full h-96 font-mono text-sm p-4 bg-gray-900 text-green-400 rounded-lg border border-gray-700 focus:outline-none focus:border-brand-gold resize-none"
            spellCheck={false}
          />
          <div>
            <label className="label">Notes for your teacher (optional)</label>
            <textarea
              value={notes}
              onChange={e => setNotes(e.target.value)}
              className="input h-24 resize-none"
              placeholder="Describe what you built, what you're proud of, or any challenges you faced..."
            />
          </div>
          <div className="flex gap-3">
            <button onClick={() => setTab('preview')} className="btn-secondary">
              Preview →
            </button>
            <button
              onClick={handleSubmit}
              disabled={submitting || !code.trim()}
              className="btn-primary"
            >
              {submitting ? 'Submitting…' : submitted ? 'Resubmit Project' : 'Submit for Review'}
            </button>
          </div>
        </div>
      )}

      {/* Preview */}
      {tab === 'preview' && (
        <div className="space-y-4">
          <div className="border border-gray-200 rounded-lg overflow-hidden">
            <div className="bg-gray-100 px-4 py-2 flex items-center gap-2 border-b border-gray-200">
              <div className="w-3 h-3 rounded-full bg-red-400" />
              <div className="w-3 h-3 rounded-full bg-yellow-400" />
              <div className="w-3 h-3 rounded-full bg-green-400" />
              <span className="text-xs text-gray-500 ml-2">Preview</span>
            </div>
            {/* Sandboxed iframe — no scripts from parent, no access to cookies */}
            <iframe
              srcDoc={code}
              sandbox="allow-scripts"
              className="w-full h-96 bg-white"
              title="Project Preview"
            />
          </div>
          <div className="flex gap-3">
            <button onClick={() => setTab('code')} className="btn-secondary">
              ← Back to Editor
            </button>
            <button
              onClick={handleSubmit}
              disabled={submitting || !code.trim()}
              className="btn-primary"
            >
              {submitting ? 'Submitting…' : 'Submit for Review'}
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
