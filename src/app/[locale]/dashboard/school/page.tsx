import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import Link from 'next/link'

export default async function SchoolPortalPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  await requireRole(supabase, ['teacher', 'admin'], locale)

  const { data: schools } = await supabase.from('schools').select('id, name, board').limit(20)

  const { data: sessions } = await supabase
    .from('school_sessions')
    .select('id, date, topic, status, student_count, schools(name)')
    .order('date', { ascending: false })
    .limit(10)

  const totalStudents = sessions?.reduce((sum, s) => sum + (s.student_count ?? 0), 0) ?? 0
  const totalHours = (sessions?.length ?? 0) * 1.5
  const base = `/${locale}/dashboard/school`

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div>
          <h1 className="text-2xl font-bold text-brand-navy">School portal</h1>
          <p className="text-gray-500 text-sm">Workshop sessions and impact reporting for Ontario schools</p>
        </div>
        <Link href={`${base}/sessions/new`} className="btn-primary">
          Book session
        </Link>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="card p-4 text-center">
          <p className="text-3xl font-bold text-brand-navy">{totalStudents}</p>
          <p className="text-xs text-gray-500">Students reached (recent)</p>
        </div>
        <div className="card p-4 text-center">
          <p className="text-3xl font-bold text-brand-navy">{totalHours}</p>
          <p className="text-xs text-gray-500">Hours delivered (est.)</p>
        </div>
        <div className="card p-4 text-center">
          <p className="text-3xl font-bold text-brand-navy">{sessions?.length ?? 0}</p>
          <p className="text-xs text-gray-500">Sessions logged</p>
        </div>
        <div className="card p-4 text-center">
          <p className="text-3xl font-bold text-brand-navy">{schools?.length ?? 0}</p>
          <p className="text-xs text-gray-500">Partner schools</p>
        </div>
      </div>

      <section>
        <h2 className="text-lg font-bold mb-4">Recent sessions</h2>
        {!sessions?.length ? (
          <p className="text-gray-500 text-sm">No workshop sessions yet.</p>
        ) : (
          <div className="card overflow-hidden">
            <table className="w-full text-sm">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left">Date</th>
                  <th className="px-4 py-3 text-left">School</th>
                  <th className="px-4 py-3 text-left">Topic</th>
                  <th className="px-4 py-3 text-left">Status</th>
                  <th className="px-4 py-3 text-right">Students</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {sessions.map((s) => {
                  const school = Array.isArray(s.schools) ? s.schools[0] : s.schools
                  return (
                    <tr key={s.id}>
                      <td className="px-4 py-3">{s.date}</td>
                      <td className="px-4 py-3">{school?.name ?? '—'}</td>
                      <td className="px-4 py-3">{s.topic ?? '—'}</td>
                      <td className="px-4 py-3 capitalize">{s.status}</td>
                      <td className="px-4 py-3 text-right">{s.student_count ?? '—'}</td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}
      </section>

      <section className="card p-6 bg-brand-light">
        <h2 className="font-bold text-brand-navy mb-2">Grant application snippet</h2>
        <p className="text-sm text-gray-700 whitespace-pre-wrap">
          {`CODEship Academy delivered ${totalHours} hours of K–8 coding workshops to ${totalStudents} students across ${schools?.length ?? 0} Ontario school partners, using bilingual curriculum aligned to provincial digital literacy goals.`}
        </p>
      </section>
    </div>
  )
}
