import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { notFound } from 'next/navigation'
import Link from 'next/link'

export default async function ClassDetailPage({
  params,
}: {
  params: { locale: string; id: string }
}) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'teacher')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  const { data: cls } = await supabase
    .from('classes')
    .select('id, name, grade, level, join_code, teacher_id')
    .eq('id', params.id)
    .single()

  if (!cls || cls.teacher_id !== profile?.id) notFound()

  const { data: memberships } = await supabase
    .from('class_memberships')
    .select(`
      student_id, joined_at,
      profiles!class_memberships_student_id_fkey ( id, display_name, level, total_xp, current_streak )
    `)
    .eq('class_id', cls.id)
    .eq('is_active', true)

  const students = (memberships ?? []).map((m: any) => m.profiles).filter(Boolean)

  return (
    <div className="space-y-6">
      <div>
        <Link href={`/${params.locale}/dashboard/classes`} className="text-sm text-gray-500 hover:text-brand-navy">
          ← Back to Classes
        </Link>
      </div>

      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{cls.name}</h1>
          <p className="text-gray-500">{cls.grade ? `Grade ${cls.grade}` : ''} {cls.level ? `· ${cls.level}` : ''}</p>
        </div>
        <div className="text-right">
          <p className="text-xs text-gray-500">Class code</p>
          <p className="font-mono font-bold text-brand-navy tracking-widest text-lg">{cls.join_code}</p>
        </div>
      </div>

      <div className="flex gap-3">
        <Link href={`/${params.locale}/dashboard/reports?class=${cls.id}`} className="btn-secondary text-sm py-2">
          View Reports
        </Link>
      </div>

      <section>
        <h2 className="text-lg font-semibold text-gray-900 mb-3">Roster ({students.length})</h2>
        {students.length > 0 ? (
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
                    <td className="px-4 py-3 font-medium text-gray-900">{s.display_name || 'Student'}</td>
                    <td className="px-4 py-3 text-sm text-gray-500 capitalize">{s.level}</td>
                    <td className="px-4 py-3 text-right font-bold text-brand-gold">{s.total_xp?.toLocaleString() || 0}</td>
                    <td className="px-4 py-3 text-right text-gray-600">🔥 {s.current_streak || 0}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="card p-12 text-center text-gray-500">
            No students yet. Share the class code <strong>{cls.join_code}</strong> with your students to let them join.
          </div>
        )}
      </section>
    </div>
  )
}
