'use client'

import { useState, useEffect, useCallback } from 'react'
import { useRouter } from 'next/navigation'

interface Question {
  id: string
  question: string
  options: string[]
  points: number
  sort_order: number
}

interface Quiz {
  id: string
  slug: string
  title: string
  time_limit_seconds: number
  passing_score: number
  xp_reward: number
  level: string
  category: string
}

interface Props {
  quiz: Quiz
  questions: Question[]
  studentId: string
  existingAttemptId?: string
  existingAnswers?: number[] | null
  bestScore?: number | null
  bestPassed?: boolean | null
  locale: string
}

export default function QuizPlayer({
  quiz,
  questions,
  studentId,
  existingAttemptId,
  existingAnswers,
  bestScore,
  bestPassed,
  locale,
}: Props) {
  const router = useRouter()
  const [started, setStarted] = useState(false)
  const [currentQ, setCurrentQ] = useState(0)
  const [answers, setAnswers] = useState<(number | null)[]>(
    existingAnswers || Array(questions.length).fill(null)
  )
  const [timeLeft, setTimeLeft] = useState(quiz.time_limit_seconds)
  const [submitted, setSubmitted] = useState(false)
  const [result, setResult] = useState<{ score: number; passed: boolean; xp_awarded: number; feedback: string } | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [attemptId, setAttemptId] = useState<string | undefined>(existingAttemptId)

  const handleSubmit = useCallback(async (finalAnswers: (number | null)[]) => {
    if (submitting) return
    setSubmitting(true)
    try {
      const res = await fetch('/api/quiz-submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          quiz_id: quiz.id,
          attempt_id: attemptId,
          answers: finalAnswers,
        }),
      })
      const data = await res.json()
      if (res.ok) {
        setResult(data)
        setSubmitted(true)
      }
    } finally {
      setSubmitting(false)
    }
  }, [quiz.id, attemptId, submitting])

  // Timer
  useEffect(() => {
    if (!started || submitted) return
    const interval = setInterval(() => {
      setTimeLeft(prev => {
        if (prev <= 1) {
          clearInterval(interval)
          handleSubmit(answers)
          return 0
        }
        return prev - 1
      })
    }, 1000)
    return () => clearInterval(interval)
  }, [started, submitted, answers, handleSubmit])

  // Save progress every 10 seconds
  useEffect(() => {
    if (!started || submitted || !attemptId) return
    const interval = setInterval(async () => {
      await fetch('/api/quiz-submit', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ attempt_id: attemptId, answers }),
      })
    }, 10000)
    return () => clearInterval(interval)
  }, [started, submitted, attemptId, answers])

  async function handleStart() {
    if (!existingAttemptId) {
      const res = await fetch('/api/quiz-submit', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ quiz_id: quiz.id }),
      })
      const data = await res.json()
      if (data.attempt_id) setAttemptId(data.attempt_id)
    }
    setStarted(true)
  }

  function selectAnswer(optionIndex: number) {
    const next = [...answers]
    next[currentQ] = optionIndex
    setAnswers(next)
  }

  const minutes = Math.floor(timeLeft / 60)
  const seconds = timeLeft % 60
  const progress = ((currentQ + 1) / questions.length) * 100

  // Pre-quiz screen
  if (!started) {
    return (
      <div className="max-w-2xl mx-auto">
        <div className="card p-8 text-center">
          <div className="text-5xl mb-4">📝</div>
          <h1 className="text-2xl font-bold text-gray-900 mb-2">{quiz.title}</h1>
          <p className="text-gray-500 mb-6">
            {quiz.category} · {quiz.level} level
          </p>
          <div className="grid grid-cols-3 gap-4 mb-8 text-center">
            <div className="bg-gray-50 rounded-lg p-3">
              <p className="text-2xl font-bold text-brand-navy">{questions.length}</p>
              <p className="text-xs text-gray-500">Questions</p>
            </div>
            <div className="bg-gray-50 rounded-lg p-3">
              <p className="text-2xl font-bold text-brand-navy">{quiz.time_limit_seconds / 60}m</p>
              <p className="text-xs text-gray-500">Time Limit</p>
            </div>
            <div className="bg-gray-50 rounded-lg p-3">
              <p className="text-2xl font-bold text-brand-gold">{quiz.xp_reward}</p>
              <p className="text-xs text-gray-500">XP Reward</p>
            </div>
          </div>
          {bestScore !== null && (
            <div className={`p-3 rounded-lg mb-6 text-sm font-medium ${bestPassed ? 'bg-green-50 text-green-700' : 'bg-yellow-50 text-yellow-700'}`}>
              Your best score: {bestScore}% · {bestPassed ? 'Passed ✓' : 'Not passed yet'}
            </div>
          )}
          <p className="text-sm text-gray-500 mb-6">
            You need {quiz.passing_score}% to pass. Answer all {questions.length} questions before time runs out.
          </p>
          <button onClick={handleStart} className="btn-primary text-lg px-8 py-3">
            {existingAttemptId ? 'Resume Quiz' : 'Start Quiz'}
          </button>
        </div>
      </div>
    )
  }

  // Results screen
  if (submitted && result) {
    return (
      <div className="max-w-2xl mx-auto">
        <div className="card p-8 text-center">
          <div className="text-6xl mb-4">{result.passed ? '🎉' : '📚'}</div>
          <h1 className="text-2xl font-bold text-gray-900 mb-2">
            {result.passed ? 'Quiz Passed!' : 'Keep Practising!'}
          </h1>
          <div className={`text-5xl font-bold my-6 ${result.passed ? 'text-green-600' : 'text-orange-500'}`}>
            {result.score}%
          </div>
          {result.passed && (
            <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-6">
              <p className="font-semibold text-yellow-800">+{result.xp_awarded} XP earned!</p>
            </div>
          )}
          {result.feedback && (
            <p className="text-gray-600 text-sm mb-6 text-left bg-gray-50 rounded-lg p-4">{result.feedback}</p>
          )}
          <div className="flex gap-3 justify-center">
            <button onClick={() => router.back()} className="btn-secondary">
              Back to Lessons
            </button>
            {!result.passed && (
              <button onClick={() => { setStarted(false); setSubmitted(false); setAnswers(Array(questions.length).fill(null)); setTimeLeft(quiz.time_limit_seconds) }} className="btn-primary">
                Try Again
              </button>
            )}
          </div>
        </div>
      </div>
    )
  }

  const q = questions[currentQ]
  const answered = answers.filter(a => a !== null).length

  // Quiz in progress
  return (
    <div className="max-w-2xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-lg font-bold text-gray-900">{quiz.title}</h1>
          <p className="text-sm text-gray-500">Question {currentQ + 1} of {questions.length}</p>
        </div>
        <div className={`text-2xl font-mono font-bold ${timeLeft < 60 ? 'text-red-600' : 'text-brand-navy'}`}>
          {String(minutes).padStart(2, '0')}:{String(seconds).padStart(2, '0')}
        </div>
      </div>

      {/* Progress */}
      <div className="w-full bg-gray-200 rounded-full h-2">
        <div className="bg-brand-gold h-2 rounded-full transition-all" style={{ width: `${progress}%` }} />
      </div>

      {/* Question */}
      <div className="card p-6">
        <p className="text-lg font-semibold text-gray-900 mb-6">{q.question}</p>
        <div className="space-y-3">
          {q.options.map((opt: string, i: number) => (
            <button
              key={i}
              onClick={() => selectAnswer(i)}
              className={`w-full text-left p-4 rounded-lg border-2 transition-all font-medium ${
                answers[currentQ] === i
                  ? 'border-brand-navy bg-brand-navy text-white'
                  : 'border-gray-200 text-gray-800 hover:border-brand-navy hover:bg-brand-navy/5'
              }`}
            >
              <span className="inline-flex items-center justify-center w-7 h-7 rounded-full bg-current/10 mr-3 text-sm font-bold">
                {String.fromCharCode(65 + i)}
              </span>
              {opt}
            </button>
          ))}
        </div>
      </div>

      {/* Navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => setCurrentQ(prev => Math.max(0, prev - 1))}
          disabled={currentQ === 0}
          className="btn-secondary disabled:opacity-40"
        >
          ← Previous
        </button>
        <span className="text-sm text-gray-500">{answered}/{questions.length} answered</span>
        {currentQ < questions.length - 1 ? (
          <button onClick={() => setCurrentQ(prev => prev + 1)} className="btn-primary">
            Next →
          </button>
        ) : (
          <button
            onClick={() => handleSubmit(answers)}
            disabled={submitting}
            className="btn-primary bg-green-600 hover:bg-green-700"
          >
            {submitting ? 'Submitting…' : 'Submit Quiz'}
          </button>
        )}
      </div>

      {/* Question navigator */}
      <div className="card p-4">
        <p className="text-xs text-gray-500 mb-3 font-semibold uppercase tracking-wide">Question Map</p>
        <div className="flex flex-wrap gap-2">
          {questions.map((_: Question, i: number) => (
            <button
              key={i}
              onClick={() => setCurrentQ(i)}
              className={`w-8 h-8 rounded-md text-xs font-bold ${
                i === currentQ ? 'bg-brand-navy text-white' :
                answers[i] !== null ? 'bg-brand-gold text-white' :
                'bg-gray-100 text-gray-500'
              }`}
            >
              {i + 1}
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}
