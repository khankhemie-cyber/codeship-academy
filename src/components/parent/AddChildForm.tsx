'use client'

import { useState } from 'react'
import { GRADE_OPTIONS } from '@/lib/utils/user'

export default function AddChildForm() {
  const [fullName, setFullName] = useState('')
  const [age, setAge] = useState('')
  const [grade, setGrade] = useState<string>('K')
  const [avatarEmoji, setAvatarEmoji] = useState('🚀')
  const [consentPrivacy, setConsentPrivacy] = useState(false)
  const [consentAi, setConsentAi] = useState(false)
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setMessage(null)

    if (!consentPrivacy || !consentAi) {
      setMessage({
        type: 'error',
        text: 'You must accept the Privacy Policy and acknowledge AI processing for your child.',
      })
      return
    }

    const ageNum = parseInt(age, 10)
    if (Number.isNaN(ageNum) || ageNum < 4 || ageNum > 18) {
      setMessage({ type: 'error', text: 'Please enter a valid age between 4 and 18.' })
      return
    }

    setLoading(true)

    const res = await fetch('/api/students', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        fullName,
        age: ageNum,
        grade,
        avatarEmoji,
        aiProcessingAcknowledged: true,
        privacyPolicyVersion: '2026-04-14',
        termsVersion: '2026-04-14',
      }),
    })

    setLoading(false)
    if (res.ok) {
      const data = await res.json()
      await fetch('/api/students/active', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ studentId: data.student_id }),
      })
      setMessage({ type: 'success', text: 'Child profile created successfully!' })
      setFullName('')
      setAge('')
      setGrade('K')
      setConsentPrivacy(false)
      setConsentAi(false)
      window.location.reload()
    } else {
      const data = await res.json()
      setMessage({ type: 'error', text: data.error || 'Failed to create profile.' })
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4" noValidate>
      {message && (
        <div
          role="alert"
          className={`p-3 rounded-lg text-sm ${
            message.type === 'success'
              ? 'bg-green-50 text-green-800 border border-green-200'
              : 'bg-red-50 text-red-800 border border-red-200'
          }`}
        >
          {message.text}
        </div>
      )}
      <div>
        <label htmlFor="child-name" className="label">
          Child&apos;s first name
        </label>
        <input
          id="child-name"
          type="text"
          className="input"
          value={fullName}
          onChange={(e) => setFullName(e.target.value)}
          placeholder="E.g. Alex"
          required
          minLength={2}
          maxLength={100}
        />
        <p className="text-xs text-gray-400 mt-1">First name only — we do not collect full legal name or birthdate.</p>
      </div>
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label htmlFor="child-age" className="label">
            Age
          </label>
          <input
            id="child-age"
            type="number"
            className="input"
            value={age}
            onChange={(e) => setAge(e.target.value)}
            required
            min={4}
            max={18}
          />
        </div>
        <div>
          <label htmlFor="child-grade" className="label">
            Grade
          </label>
          <select
            id="child-grade"
            className="input"
            value={grade}
            onChange={(e) => setGrade(e.target.value)}
            required
          >
            {GRADE_OPTIONS.map((g) => (
              <option key={g} value={g}>
                {g === 'K' ? 'Kindergarten' : `Grade ${g}`}
              </option>
            ))}
          </select>
        </div>
      </div>
      <div>
        <label htmlFor="child-emoji" className="label">
          Avatar emoji
        </label>
        <input
          id="child-emoji"
          type="text"
          className="input max-w-[120px]"
          value={avatarEmoji}
          onChange={(e) => setAvatarEmoji(e.target.value)}
          maxLength={4}
        />
      </div>
      <fieldset className="space-y-3 p-4 bg-gray-50 rounded-xl">
        <legend className="text-sm font-bold text-brand-dark">Parental consent (required)</legend>
        <label className="flex items-start gap-3 cursor-pointer">
          <input
            type="checkbox"
            checked={consentPrivacy}
            onChange={(e) => setConsentPrivacy(e.target.checked)}
            className="mt-0.5"
            required
          />
          <span className="text-sm text-gray-700">
            I am the parent or legal guardian. I have read the Privacy Policy and consent to my child&apos;s
            participation under PIPEDA and Ontario privacy law.
          </span>
        </label>
        <label className="flex items-start gap-3 cursor-pointer">
          <input
            type="checkbox"
            checked={consentAi}
            onChange={(e) => setConsentAi(e.target.checked)}
            className="mt-0.5"
            required
          />
          <span className="text-sm text-gray-700">
            I understand that lesson context may be sent to Anthropic&apos;s AI tutor to provide educational hints.
            No personal identifiers are included in those requests.
          </span>
        </label>
      </fieldset>
      <button type="submit" disabled={loading} className="btn-primary">
        {loading ? 'Creating…' : 'Add child'}
      </button>
    </form>
  )
}
