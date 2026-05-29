import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function ParentProgressPage({
  params,
  searchParams,
}: {
  params: Promise<{ locale: string }>
  searchParams: Promise<{ student?: string }>
}) {
  const { locale } = await params
  const { student: studentParam } = await searchParams
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent', locale)

  const { data: students } = await supabase
    .from('student_profiles')
    .select('id, full_name, level, xp_points, streak_days')
    .eq('parent_id', user.id)
    .order('created_at', { ascending: true })

  const selectedId = studentParam || students?.[0]?.id
  const selectedChild = students?.find((s) => s.id === selectedId)

  let lessonProgress: Array<{
    status: string
    completed_at: string | null
    lessons: { title: string; level: string; category: string } | null
  }> = []
  let quizAttempts: Array<{
    score: number | null
    passed: boolean | null
    completed_at: string | null
    quizzes: { title: string; level: string } | null
  }> = []

  if (selectedId) {
    const [progressRes, quizRes] = await Promise.all([
      supabase
        .from('lesson_progress')
        .select('status, completed_at, lessons(title, level, category)')
        .eq('student_id', selectedId)
        .order('updated_at', { ascending: false })
        .limit(20),
      supabase
        .from('quiz_attempts')
        .select('score, passed, completed_at, quizzes(title, level)')
        .eq('student_id', selectedId)
        .not('completed_at', 'is', null)
        .order('completed_at', { ascending: false })
        .limit(10),
    ])
    lessonProgress = (progressRes.data || []).map((row) => ({
      status: row.status,
      completed_at: row.completed_at,
      lessons: Array.isArray(row.lessons) ? row.lessons[0] ?? null : row.lessons,
    }))
    quizAttempts = (quizRes.data || []).map((row) => ({
      score: row.score,
      passed: row.passed,
      completed_at: row.completed_at,
      quizzes: Array.isArray(row.quizzes) ? row.quizzes[0] ?? null : row.quizzes,
    }))
  }

  const completedLessons = lessonProgress.filter((p) => p.status === 'completed').length

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Progress Reports</h1>

      {students && students.length > 1 && (
        <div className="flex gap-3 flex-wrap">
          {students.map((child) => (
            <a
              key={child.id}
              href={`/${locale}/dashboard/parent/progress?student=${child.id}`}
              className={`px-4 py-2 rounded-lg border font-medium text-sm transition-colors ${
                child.id === selectedId
                  ? 'bg-brand-navy text-white border-brand-navy'
                  : 'border-gray-200 text-gray-700 hover:bg-gray-50'
              }`}
            >
              {child.full_name}
            </a>
          ))}
        </div>
      )}

      {selectedChild ? (
        <>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-brand-gold">{selectedChild.xp_points?.toLocaleString() || 0}</p>
              <p className="text-sm text-gray-500">Total XP</p>
            </div>
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-orange-500">🔥 {selectedChild.streak_days || 0}</p>
              <p className="text-sm text-gray-500">Day Streak</p>
            </div>
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-green-600">{completedLessons}</p>
              <p className="text-sm text-gray-500">Lessons Done</p>
            </div>
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-blue-600">
                {quizAttempts.filter((q) => q.passed).length}
              </p>
              <p className="text-sm text-gray-500">Quizzes Passed</p>
            </div>
          </div>

          <section>
            <h2 className="text-lg font-semibold text-gray-900 mb-3">Recent Lessons</h2>
            {lessonProgress.length === 0 ? (
              <p className="text-gray-500 text-sm">No lessons started yet.</p>
            ) : (
              <div className="card overflow-hidden">
                <table className="w-full">
                  <thead className="bg-gray-50 border-b border-gray-200">
                    <tr>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Lesson</th>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Level</th>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
                      <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Completed</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {lessonProgress.map((p, i) => (
                      <tr key={i}>
                        <td className="px-4 py-3 font-medium text-gray-900">{p.lessons?.title || '—'}</td>
                        <td className="px-4 py-3 text-sm text-gray-500 capitalize">{p.lessons?.level}</td>
                        <td className="px-4 py-3">
                          <span
                            className={`badge ${
                              p.status === 'completed'
                                ? 'badge-green'
                                : p.status === 'in_progress'
                                  ? 'badge-blue'
                                  : 'badge-gray'
                            }`}
                          >
                            {p.status?.replace('_', ' ')}
                          </span>
                        </td>
                        <td className="px-4 py-3 text-right text-sm text-gray-500">
                          {p.completed_at ? new Date(p.completed_at).toLocaleDateString() : '—'}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </section>

          <section>
            <h2 className="text-lg font-semibold text-gray-900 mb-3">Quiz Results</h2>
            {quizAttempts.length === 0 ? (
              <p className="text-gray-500 text-sm">No quizzes taken yet.</p>
            ) : (
              <div className="space-y-3">
                {quizAttempts.map((qa, i) => (
                  <div key={i} className="card p-4 flex items-center justify-between">
                    <div>
                      <p className="font-medium text-gray-900">{qa.quizzes?.title || 'Quiz'}</p>
                      <p className="text-sm text-gray-500 capitalize">{qa.quizzes?.level}</p>
                    </div>
                    <div className="text-right">
                      <p className={`text-2xl font-bold ${qa.passed ? 'text-green-600' : 'text-orange-500'}`}>
                        {qa.score}%
                      </p>
                      <p className="text-xs text-gray-400">{qa.passed ? '✓ Passed' : 'Not passed'}</p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </section>
        </>
      ) : (
        <div className="card p-12 text-center text-gray-500">
          No children added yet.{' '}
          <a href={`/${locale}/dashboard/parent/children`} className="text-brand-navy underline">
            Add a child
          </a>{' '}
          to see their progress.
        </div>
      )}
    </div>
  )
}
