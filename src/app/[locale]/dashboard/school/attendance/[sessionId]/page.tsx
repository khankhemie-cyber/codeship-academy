import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { revalidatePath } from 'next/cache'
import { notFound } from 'next/navigation'
import Link from 'next/link'

async function addAttendee(formData: FormData) {
  'use server'
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return
  const { data: profile } = await supabase.from('profiles').select('role').eq('user_id', user.id).single()
  if (!profile || !['teacher', 'admin'].includes(profile.role)) return

  const sessionId = String(formData.get('session_id') || '')
  const name = String(formData.get('student_name') || '').trim()
  if (!sessionId || !name) return

  await supabase.from('session_attendance').insert({
    session_id: sessionId,
    student_name: name,
    grade: String(formData.get('grade') || '') || null,
    engagement_score: formData.get('engagement_score')
      ? parseInt(String(formData.get('engagement_score')), 10)
      : null,
  })

  revalidatePath('/[locale]/dashboard/school/attendance/[sessionId]', 'page')
}

export default async function AttendancePage({
  params,
}: {
  params: { locale: string; sessionId: string }
}) {
  const supabase = await createClient()
  await requireRole(supabase, ['teacher', 'admin'])

  const { data: session } = await supabase
    .from('school_sessions')
    .select('id, date, grade_range, level, schools(name)')
    .eq('id', params.sessionId)
    .single()

  if (!session) notFound()

  const { data: attendees } = await supabase
    .from('session_attendance')
    .select('id, student_name, grade, engagement_score')
    .eq('session_id', params.sessionId)
    .order('student_name')

  return (
    <div className="space-y-6 max-w-2xl">
      <div>
        <Link href={`/${params.locale}/dashboard/school`} className="text-sm text-gray-500 hover:text-brand-navy">
          ← Back to School Portal
        </Link>
      </div>

      <div>
        <h1 className="text-2xl font-bold text-gray-900">Attendance</h1>
        <p className="text-gray-500">
          {(session as any).schools?.name ?? 'School'} ·{' '}
          {new Date(session.date).toLocaleDateString('en-CA', { dateStyle: 'medium' })}
          {session.grade_range ? ` · ${session.grade_range}` : ''}
        </p>
      </div>

      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Add Student</h2>
        <form action={addAttendee} className="grid grid-cols-1 sm:grid-cols-4 gap-3 items-end">
          <input type="hidden" name="session_id" value={params.sessionId} />
          <div className="sm:col-span-2">
            <label className="label" htmlFor="student_name">Student name</label>
            <input id="student_name" name="student_name" className="input" required />
          </div>
          <div>
            <label className="label" htmlFor="grade">Grade</label>
            <input id="grade" name="grade" className="input" />
          </div>
          <div>
            <label className="label" htmlFor="engagement_score">Engagement (1–5)</label>
            <input id="engagement_score" name="engagement_score" type="number" min={1} max={5} className="input" />
          </div>
          <div className="sm:col-span-4">
            <button type="submit" className="btn-primary">Add</button>
          </div>
        </form>
      </section>

      <section>
        <h2 className="text-lg font-semibold text-gray-900 mb-3">Attendance Sheet ({attendees?.length ?? 0})</h2>
        {attendees && attendees.length > 0 ? (
          <div className="card overflow-hidden">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Name</th>
                  <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Grade</th>
                  <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Engagement</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {attendees.map((a: any) => (
                  <tr key={a.id}>
                    <td className="px-4 py-3 font-medium text-gray-900">{a.student_name}</td>
                    <td className="px-4 py-3 text-sm text-gray-500">{a.grade ?? '—'}</td>
                    <td className="px-4 py-3 text-right text-gray-600">{a.engagement_score ? `${a.engagement_score}/5` : '—'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="card p-8 text-center text-gray-500">No attendees recorded yet.</div>
        )}
      </section>
    </div>
  )
}
