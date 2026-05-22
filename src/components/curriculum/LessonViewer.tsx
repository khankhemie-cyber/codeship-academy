'use client'

import { useState, useRef, useEffect } from 'react'
import { Heart, MessageCircle, ChevronRight, ChevronLeft, CheckCircle2, X } from 'lucide-react'

interface LessonViewerProps {
  lesson: {
    id: string
    slug: string
    title: string
    level: string
    category: string
    duration_minutes: number
    instructions: string | null
    xp_reward: number
  }
  progress: {
    id?: string
    status: string
    hearts_remaining: number
    score?: number | null
  } | null
  studentId: string
  studentLevel: string
  studentAge: number
  locale: string
}

interface TutorMessage {
  role: 'user' | 'assistant'
  content: string
}

export default function LessonViewer({ lesson, progress, studentId, studentLevel, studentAge, locale }: LessonViewerProps) {
  const [hearts, setHearts] = useState(progress?.hearts_remaining ?? 5)
  const [completed, setCompleted] = useState(progress?.status === 'completed')
  const [tutorOpen, setTutorOpen] = useState(false)
  const [tutorMessages, setTutorMessages] = useState<TutorMessage[]>([])
  const [tutorInput, setTutorInput] = useState('')
  const [tutorLoading, setTutorLoading] = useState(false)
  const tutorEndRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    tutorEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [tutorMessages])

  async function markComplete() {
    const res = await fetch('/api/lesson-progress', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ lessonId: lesson.id, studentId, status: 'completed', heartsRemaining: hearts }),
    })
    if (res.ok) setCompleted(true)
  }

  async function sendTutorMessage(e: React.FormEvent) {
    e.preventDefault()
    if (!tutorInput.trim() || tutorLoading) return

    const userMessage = tutorInput.trim()
    setTutorInput('')
    setTutorMessages((prev) => [...prev, { role: 'user', content: userMessage }])
    setTutorLoading(true)

    try {
      const res = await fetch('/api/ai/tutor', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          lessonSlug: lesson.slug,
          lessonTitle: lesson.title,
          level: studentLevel,
          age: studentAge,
          message: userMessage,
          history: tutorMessages.slice(-4),
        }),
      })
      const data = await res.json()
      setTutorMessages((prev) => [...prev, { role: 'assistant', content: data.reply ?? 'I had trouble with that. Try again!' }])
    } catch {
      setTutorMessages((prev) => [...prev, { role: 'assistant', content: 'Oops! I ran into an issue. Please try again.' }])
    } finally {
      setTutorLoading(false)
    }
  }

  // Simple markdown renderer (safe - content comes from our DB only)
  function renderContent(text: string) {
    return text
      .replace(/^### (.+)$/gm, '<h3 class="text-lg font-bold text-brand-navy mt-6 mb-2">$1</h3>')
      .replace(/^## (.+)$/gm, '<h2 class="text-xl font-extrabold text-brand-navy mt-8 mb-3">$1</h2>')
      .replace(/^# (.+)$/gm, '<h1 class="text-2xl font-extrabold text-brand-navy mt-8 mb-4">$1</h1>')
      .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
      .replace(/`(.+?)`/g, '<code class="bg-gray-100 px-1 rounded font-mono text-sm">$1</code>')
      .replace(/```[\w]*\n([\s\S]*?)```/g, '<pre class="bg-gray-900 text-green-400 p-4 rounded-xl overflow-x-auto my-4 text-sm font-mono"><code>$1</code></pre>')
      .replace(/^- (.+)$/gm, '<li class="ml-4 list-disc">$1</li>')
      .replace(/\n\n/g, '</p><p class="mb-3">')
      .replace(/^(?!<[h|p|l|u|p])/gm, '<p class="mb-3">')
  }

  return (
    <div className="flex gap-6 relative">
      {/* Main lesson content */}
      <div className={`flex-1 min-w-0 transition-all ${tutorOpen ? 'md:mr-80' : ''}`}>
        {/* Header */}
        <div className="card mb-6">
          <div className="flex items-start justify-between mb-4">
            <div>
              <span className="badge badge-blue mb-2">{lesson.category}</span>
              <h1 className="text-2xl font-extrabold text-brand-navy">{lesson.title}</h1>
              <div className="flex items-center gap-4 mt-2 text-sm text-gray-500">
                <span>⏱️ {lesson.duration_minutes} min</span>
                <span>⭐ {lesson.xp_reward} XP</span>
              </div>
            </div>
            <div className="flex items-center gap-1" aria-label={`${hearts} hearts remaining`}>
              {Array.from({ length: 5 }).map((_, i) => (
                <Heart
                  key={i}
                  size={20}
                  className={i < hearts ? 'text-red-500 fill-red-500' : 'text-gray-200 fill-gray-200'}
                />
              ))}
            </div>
          </div>

          {completed && (
            <div role="status" className="flex items-center gap-2 p-3 bg-green-50 rounded-xl text-green-700 font-semibold">
              <CheckCircle2 size={18} /> Lesson completed! +{lesson.xp_reward} XP earned
            </div>
          )}
        </div>

        {/* Content */}
        <div className="card mb-6 prose max-w-none">
          {lesson.instructions ? (
            <div
              dangerouslySetInnerHTML={{ __html: renderContent(lesson.instructions) }}
            />
          ) : (
            <p className="text-gray-500">Lesson content coming soon!</p>
          )}
        </div>

        {/* Actions */}
        {!completed && (
          <div className="flex items-center justify-between">
            <button
              onClick={() => setTutorOpen(!tutorOpen)}
              className="flex items-center gap-2 btn-outline"
              aria-expanded={tutorOpen}
            >
              <MessageCircle size={16} />
              Ask AI Tutor
            </button>
            <button onClick={markComplete} className="btn-primary">
              Mark as Complete ✓
            </button>
          </div>
        )}
      </div>

      {/* AI Tutor sidebar */}
      {tutorOpen && (
        <aside
          className="fixed right-0 top-0 h-full w-80 bg-white border-l border-gray-200 shadow-xl z-30 flex flex-col md:fixed"
          role="complementary"
          aria-label="AI Tutor"
        >
          <div className="flex items-center justify-between p-4 border-b border-gray-200">
            <div>
              <h2 className="font-bold text-brand-navy">🤖 AI Tutor</h2>
              <p className="text-xs text-gray-500">Ask for hints — not answers!</p>
            </div>
            <button
              onClick={() => setTutorOpen(false)}
              className="p-1 hover:bg-gray-100 rounded"
              aria-label="Close tutor"
            >
              <X size={18} />
            </button>
          </div>

          <div className="flex-1 overflow-y-auto p-4 space-y-3">
            {tutorMessages.length === 0 && (
              <div className="text-center text-gray-400 text-sm mt-4">
                <div className="text-4xl mb-2">🤖</div>
                Hi! I&apos;m your coding helper. Ask me anything about this lesson!
              </div>
            )}
            {tutorMessages.map((msg, i) => (
              <div
                key={i}
                className={`p-3 rounded-xl text-sm ${
                  msg.role === 'user'
                    ? 'bg-brand-navy text-white ml-4'
                    : 'bg-gray-100 text-gray-800 mr-4'
                }`}
              >
                {msg.content}
              </div>
            ))}
            {tutorLoading && (
              <div className="bg-gray-100 text-gray-500 p-3 rounded-xl text-sm mr-4">
                Thinking… 💭
              </div>
            )}
            <div ref={tutorEndRef} />
          </div>

          <form onSubmit={sendTutorMessage} className="p-4 border-t border-gray-200">
            <div className="flex gap-2">
              <input
                type="text"
                value={tutorInput}
                onChange={(e) => setTutorInput(e.target.value)}
                placeholder="Ask a question…"
                className="flex-1 input text-sm py-2"
                disabled={tutorLoading}
                aria-label="Ask AI tutor"
              />
              <button
                type="submit"
                disabled={tutorLoading || !tutorInput.trim()}
                className="btn-primary px-3 py-2 text-sm disabled:opacity-50"
              >
                <ChevronRight size={16} />
              </button>
            </div>
          </form>
        </aside>
      )}
    </div>
  )
}
