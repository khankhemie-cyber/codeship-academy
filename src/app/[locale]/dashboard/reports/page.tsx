import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function ReportsPage({ searchParams }: { searchParams: { class?: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'teacher')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  const { data: classes } = await supabase
    .from('classes')
    .select('id, name')
    .eq('teacher_id', profile!.id)
    .eq('is_active', true)

  const selectedClassId = searchParams.class || classes?.[0]?.id

  let students: any[] = []
  let submissions: any[] = []

  if (selectedClassId) {
    // Verify teacher owns this class
    const cls = classes?.find((c: any) => c.id === selectedClassId)
    if (cls) {
      const { data: memberships } = await supabase
        .from('class_memberships')
        .select(`
          student_id,
          profiles!class_memberships_student_id_fkey (
            id, display_name, level, total_xp, current_streak
          )
        `)
        .eq('class_id', selectedClassId)
        .eq('is_active', true)

      students = (memberships || []).map((m: any) => m.profiles).filter(Boolean)

      // Recent submissions from these students
      const studentIds = students.map((s: any) => s.id)
      if (studentIds.length > 0) {
        const { data: subs } = await supabase
          .from('project_submissions')
          .select('student_id, status, submitted_at, projects(title)')
          .in('student_id', studentIds)
          .order('submitted_at', { ascending: false })
          .limit(20)
        submissions = subs || []
      }
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">Class Reports</h1>
      </div>

      {/* Class selector */}
      {classes && classes.length > 1 && (
        <div className="flex gap-3 flex-wrap">
          {classes.map((cls: any) => (
            <a
              key={cls.id}
              href={`?class=${cls.id}`}
              className={`px-4 py-2 rounded-lg border font-medium text-sm transition-colors ${cls.id === selectedClassId ? 'bg-brand-navy text-white border-brand-navy' : 'border-gray-200 text-gray-700 hover:bg-gray-50'}`}
            >
              {cls.name}
            </a>
          ))}
        </div>
      )}

      {students.length > 0 ? (
        <>
          {/* Student overview */}
          <section>
            <h2 className="text-lg font-semibold text-gray-900 mb-3">Students ({students.length})</h2>
            <div className="card overflow-hidden">
              <table className="w-full">
                <thead className="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Student</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Level</th>
                    <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">XP</th>
                    <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Streak</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {students.map((s: any) => (
                    <tr key={s.id}>
                      <td className="px-4 py-3">
                        <div className="flex items-center gap-2">
                          <div className="w-8 h-8 rounded-full bg-brand-mid flex items-center justify-center text-white text-sm font-bold">
                            {s.display_name?.[0]?.toUpperCase() || '?'}
                          </div>
                          <span className="font-medium text-gray-900">{s.display_name || 'Student'}</span>
                        </div>
                      </td>
                      <td className="px-4 py-3 text-sm text-gray-500 capitalize">{s.level}</td>
                      <td className="px-4 py-3 text-right font-bold text-brand-gold">
                        {s.total_xp?.toLocaleString() || 0}
                      </td>
                      <td className="px-4 py-3 text-right text-gray-600">
                        🔥 {s.current_streak || 0}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>

          {/* Recent submissions */}
          {submissions.length > 0 && (
            <section>
              <h2 className="text-lg font-semibold text-gray-900 mb-3">Recent Project Submissions</h2>
              <div className="space-y-3">
                {submissions.map((sub: any, i: number) => {
                  const student = students.find((s: any) => s.id === sub.student_id)
                  return (
                    <div key={i} className="card p-4 flex items-center justify-between">
                      <div>
                        <p className="font-medium text-gray-900">{sub.projects?.title || 'Project'}</p>
                        <p className="text-sm text-gray-500">{student?.display_name || 'Student'}</p>
                      </div>
                      <div className="text-right">
                        <span className={`badge ${sub.status === 'approved' ? 'badge-green' : sub.status === 'submitted' ? 'badge-blue' : 'badge-gray'}`}>
                          {sub.status}
                        </span>
                        <p className="text-xs text-gray-400 mt-1">
                          {new Date(sub.submitted_at).toLocaleDateString()}
                        </p>
                      </div>
                    </div>
                  )
                })}
              </div>
            </section>
          )}
        </>
      ) : (
        <div className="card p-12 text-center text-gray-500">
          {selectedClassId ? 'No students in this class yet.' : 'Create a class to see reports.'}
        </div>
      )}
    </div>
  )
}
