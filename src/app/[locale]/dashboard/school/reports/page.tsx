import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function SchoolReportsPage() {
  const supabase = await createClient()
  await requireRole(supabase, ['teacher', 'admin'])

  const { data: sessions } = await supabase
    .from('school_sessions')
    .select('id, date, level, duration_minutes, status')

  const { data: attendance } = await supabase
    .from('session_attendance')
    .select('id, engagement_score, session_id')

  const completed = (sessions ?? []).filter((s: any) => s.status === 'completed' || new Date(s.date) < new Date())
  const totalSessions = sessions?.length ?? 0
  const totalStudents = attendance?.length ?? 0
  const totalMinutes = (sessions ?? []).reduce((sum: number, s: any) => sum + (s.duration_minutes ?? 0), 0)
  const totalHours = Math.round((totalMinutes / 60) * 10) / 10

  const levelCounts: Record<string, number> = {}
  for (const s of sessions ?? []) {
    const lvl = s.level ?? 'unspecified'
    levelCounts[lvl] = (levelCounts[lvl] ?? 0) + 1
  }

  const grantSnippet =
    `CODEship Academy delivered ${totalSessions} in-person coding workshop session(s) ` +
    `(${totalHours} instructional hours), reaching ${totalStudents} student attendance records ` +
    `across grades K–8 in Ontario.`

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Impact Report</h1>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="card text-center p-5">
          <div className="text-3xl font-extrabold text-brand-navy">{totalStudents}</div>
          <div className="text-xs text-gray-500 mt-1">Students Reached</div>
        </div>
        <div className="card text-center p-5">
          <div className="text-3xl font-extrabold text-brand-navy">{totalSessions}</div>
          <div className="text-xs text-gray-500 mt-1">Sessions Booked</div>
        </div>
        <div className="card text-center p-5">
          <div className="text-3xl font-extrabold text-brand-navy">{completed.length}</div>
          <div className="text-xs text-gray-500 mt-1">Sessions Delivered</div>
        </div>
        <div className="card text-center p-5">
          <div className="text-3xl font-extrabold text-brand-navy">{totalHours}</div>
          <div className="text-xs text-gray-500 mt-1">Hours Delivered</div>
        </div>
      </div>

      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-3">Sessions by Level</h2>
        {Object.keys(levelCounts).length > 0 ? (
          <ul className="space-y-2">
            {Object.entries(levelCounts).map(([lvl, count]) => (
              <li key={lvl} className="flex items-center justify-between text-sm">
                <span className="capitalize text-gray-700">{lvl}</span>
                <span className="font-bold text-brand-navy">{count}</span>
              </li>
            ))}
          </ul>
        ) : (
          <p className="text-gray-500 text-sm">No sessions recorded yet.</p>
        )}
      </section>

      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-3">Copy for Grant Applications</h2>
        <p className="text-sm text-gray-700 bg-gray-50 border border-gray-200 rounded-lg p-4">{grantSnippet}</p>
      </section>
    </div>
  )
}
