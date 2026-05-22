'use client'

import { useState } from 'react'

interface Props {
  parentId: string
}

export default function AddChildForm({ parentId }: Props) {
  const [displayName, setDisplayName] = useState('')
  const [dateOfBirth, setDateOfBirth] = useState('')
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setMessage(null)

    const res = await fetch('/api/students', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ display_name: displayName, date_of_birth: dateOfBirth }),
    })

    setLoading(false)
    if (res.ok) {
      setMessage({ type: 'success', text: 'Child account created successfully!' })
      setDisplayName('')
      setDateOfBirth('')
      // Reload to show new child
      window.location.reload()
    } else {
      const data = await res.json()
      setMessage({ type: 'error', text: data.error || 'Failed to create account.' })
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {message && (
        <div className={`p-3 rounded-lg text-sm ${message.type === 'success' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'}`}>
          {message.text}
        </div>
      )}
      <div>
        <label className="label">Child&apos;s Display Name</label>
        <input
          type="text"
          className="input"
          value={displayName}
          onChange={e => setDisplayName(e.target.value)}
          placeholder="E.g. Alex"
          required
          minLength={2}
          maxLength={50}
        />
        <p className="text-xs text-gray-400 mt-1">This is how their name appears in the app. No last name needed.</p>
      </div>
      <div>
        <label className="label">Date of Birth</label>
        <input
          type="date"
          className="input"
          value={dateOfBirth}
          onChange={e => setDateOfBirth(e.target.value)}
          required
          max={new Date().toISOString().split('T')[0]}
        />
        <p className="text-xs text-gray-400 mt-1">Used to assign the right curriculum level. Required by PIPEDA.</p>
      </div>
      <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
        <p className="text-xs text-blue-700">
          By adding a child, you confirm that you are their parent or legal guardian and consent to their participation in CODEship Academy under PIPEDA and Ontario privacy law.
        </p>
      </div>
      <button type="submit" disabled={loading} className="btn-primary">
        {loading ? 'Creating…' : 'Add Child'}
      </button>
    </form>
  )
}
