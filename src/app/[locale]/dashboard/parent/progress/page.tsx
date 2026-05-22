import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function ParentProgressPage({ searchParams }: { searchParams: { child?: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent')

  const { data: parent } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  // Verify parent owns this child
  const { data: links } = await supabase
    .from('parent_student_links')
    .select(`
      student_id,
      profiles!parent_student_links_student_id_fkey (
        id, display_name, level, total_xp, current_streak
      )
    `)
    .eq('parent_id', parent!.id)

  const selectedId = searchParams.child || links?.[0]?.student_id

  const selectedLink = links?.find((l: any) => l.student_id === selectedId)
  const selectedChild = selectedLink?.profiles as any

  let lessonProgress: any[] = []
  let quizAttempts: any[] = []

  if (selectedId && selectedChild) {
    const [progressRes, quizRes] = await Promise.all([
      supabase
        .from('lesson_progress')
        .select('status, completed_at, lessons(title, level, category)')
        .eq('student_id', selectedChild.id)
        .order('updated_at', { ascending: false })
        .limit(20),
      supabase
        .from('quiz_attempts')
        .select('score, passed, completed_at, quizzes(title, level)')
        .eq('student_id', selectedChild.id)
        .not('completed_at', 'is', null)
        .order('completed_at', { ascending: false })
        .limit(10),
    ])
    lessonProgress = progressRes.data || []
    quizAttempts = quizRes.data || []
  }

  const completedLessons = lessonProgress.filter((p: any) => p.status === 'completed').length

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Progress Reports</h1>

      {/* Child selector */}
      {links && links.length > 1 && (
        <div className="flex gap-3">
          {links.map((link: any) => {
            const child = link.profiles
            if (!child) return null
            return (
              <a
                key={link.student_id}
                href={`?child=${link.student_id}`}
                className={`px-4 py-2 rounded-lg border font-medium text-sm transition-colors ${link.student_id === selectedId ? 'bg-brand-navy text-white border-brand-navy' : 'border-gray-200 text-gray-700 hover:bg-gray-50'}`}
              >
                {child.display_name}
              </a>
            )
          })}
        </div>
      )}

      {selectedChild ? (
        <>
          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-brand-gold">{selectedChild.total_xp?.toLocaleString() || 0}</p>
              <p className="text-sm text-gray-500">Total XP</p>
            </div>
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-orange-500">🔥 {selectedChild.current_streak || 0}</p>
              <p className="text-sm text-gray-500">Day Streak</p>
            </div>
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-green-600">{completedLessons}</p>
              <p className="text-sm text-gray-500">Lessons Done</p>
            </div>
            <div className="card p-4 text-center">
              <p className="text-3xl font-bold text-blue-600">{quizAttempts.filter((q: any) => q.passed).length}</p>
              <p className="text-sm text-gray-500">Quizzes Passed</p>
            </div>
          </div>

          {/* Recent lessons */}
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
                    {lessonProgress.map((p: any, i: number) => (
                      <tr key={i}>
                        <td className="px-4 py-3 font-medium text-gray-900">{p.lessons?.title || '—'}</td>
                        <td className="px-4 py-3 text-sm text-gray-500 capitalize">{p.lessons?.level}</td>
                        <td className="px-4 py-3">
                          <span className={`badge ${p.status === 'completed' ? 'badge-green' : p.status === 'in_progress' ? 'badge-blue' : 'badge-gray'}`}>
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

          {/* Quiz scores */}
          <section>
            <h2 className="text-lg font-semibold text-gray-900 mb-3">Quiz Results</h2>
            {quizAttempts.length === 0 ? (
              <p className="text-gray-500 text-sm">No quizzes taken yet.</p>
            ) : (
              <div className="space-y-3">
                {quizAttempts.map((qa: any, i: number) => (
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
          No children added yet. <a href="../children" className="text-brand-navy underline">Add a child</a> to see their progress.
        </div>
      )}
    </div>
  )
}
