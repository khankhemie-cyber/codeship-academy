'use client'

import { useRouter } from 'next/navigation'
import { useState } from 'react'

type Student = {
  id: string
  full_name: string
  avatar_emoji: string | null
}

export function ChildSwitcher({
  students,
  locale,
  activeId,
}: {
  students: Student[]
  locale: string
  activeId?: string
}) {
  const router = useRouter()
  const [loading, setLoading] = useState(false)

  async function selectStudent(studentId: string) {
    setLoading(true)
    await fetch('/api/students/active', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ studentId }),
    })
    setLoading(false)
    router.push(`/${locale}/dashboard/student`)
    router.refresh()
  }

  return (
    <div className="flex flex-wrap gap-2 items-center">
      <span className="text-sm text-gray-500">Active learner:</span>
      {students.map((s) => (
        <button
          key={s.id}
          type="button"
          disabled={loading}
          onClick={() => selectStudent(s.id)}
          className={`px-3 py-1.5 rounded-lg text-sm font-semibold border transition-colors ${
            activeId === s.id
              ? 'bg-brand-gold text-brand-navy border-brand-gold'
              : 'border-gray-200 hover:border-brand-gold'
          }`}
        >
          {s.avatar_emoji ?? '🚀'} {s.full_name}
        </button>
      ))}
    </div>
  )
}
