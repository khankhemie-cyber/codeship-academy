import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function ReportsPage({
  params,
  searchParams,
}: {
  params: Promise<{ locale: string }>
  searchParams: Promise<{ class?: string }>
}) {
  const { locale } = await params
  const { class: classParam } = await searchParams
  const supabase = await createClient()
  const user = await requireRole(supabase, ['teacher', 'admin'], locale)

  const { data: classes } = await supabase
    .from('classes')
    .select('id, name')
    .eq('teacher_id', user.id)
    .eq('is_active', true)

  const selectedClassId = classParam || classes?.[0]?.id

  type StudentRow = {
    id: string
    full_name: string
    level: string
    xp_points: number
    streak_days: number
  }

  let students: StudentRow[] = []

  if (selectedClassId && classes?.some((c) => c.id === selectedClassId)) {
    const { data: memberships } = await supabase
      .from('class_memberships')
      .select('student_id, student_profiles(id, full_name, level, xp_points, streak_days)')
      .eq('class_id', selectedClassId)

    students = (memberships || [])
      .map((m) => {
        const sp = Array.isArray(m.student_profiles) ? m.student_profiles[0] : m.student_profiles
        return sp as StudentRow | null
      })
      .filter((s): s is StudentRow => Boolean(s))
  }

  const base = `/${locale}/dashboard`

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Class reports</h1>

      {classes && classes.length > 1 && (
        <div className="flex gap-2 flex-wrap">
          {classes.map((c) => (
            <a
              key={c.id}
              href={`${base}/reports?class=${c.id}`}
              className={`px-4 py-2 rounded-lg border text-sm font-medium ${
                c.id === selectedClassId
                  ? 'bg-brand-navy text-white border-brand-navy'
                  : 'border-gray-200 hover:bg-gray-50'
              }`}
            >
              {c.name}
            </a>
          ))}
        </div>
      )}

      {students.length === 0 ? (
        <div className="card p-8 text-center text-gray-500">
          No students in this class yet. Share your class code from the class page.
        </div>
      ) : (
        <div className="card overflow-hidden">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500">Student</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500">Level</th>
                <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500">XP</th>
                <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500">Streak</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {students.map((s) => (
                <tr key={s.id}>
                  <td className="px-4 py-3 font-medium">{s.full_name}</td>
                  <td className="px-4 py-3 capitalize text-sm">{s.level}</td>
                  <td className="px-4 py-3 text-right">{s.xp_points}</td>
                  <td className="px-4 py-3 text-right">🔥 {s.streak_days}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
