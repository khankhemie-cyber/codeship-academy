import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { revalidatePath } from 'next/cache'
import Link from 'next/link'

async function bookSession(formData: FormData) {
  'use server'
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return

  const { data: profile } = await supabase.from('profiles').select('id, role').eq('user_id', user.id).single()
  if (!profile || !['teacher', 'admin'].includes(profile.role)) return

  const schoolName = String(formData.get('school_name') || '').trim()
  const date = String(formData.get('date') || '')
  if (!schoolName || !date) return

  // Find or create the school record.
  let schoolId: string | null = null
  const { data: existingSchool } = await supabase.from('schools').select('id').eq('name', schoolName).maybeSingle()
  if (existingSchool) {
    schoolId = existingSchool.id
  } else {
    const { data: created } = await supabase.from('schools').insert({ name: schoolName }).select('id').single()
    schoolId = created?.id ?? null
  }

  await supabase.from('school_sessions').insert({
    school_id: schoolId,
    teacher_id: profile.id,
    date,
    start_time: String(formData.get('start_time') || '') || null,
    duration_minutes: parseInt(String(formData.get('duration_minutes') || '90'), 10),
    grade_range: String(formData.get('grade_range') || '') || null,
    level: String(formData.get('level') || '') || null,
    capacity: formData.get('capacity') ? parseInt(String(formData.get('capacity')), 10) : null,
    location: String(formData.get('location') || '') || null,
    status: 'scheduled',
  })

  revalidatePath('/[locale]/dashboard/school', 'page')
}

export default async function SchoolPortalPage({ params }: { params: { locale: string } }) {
  const supabase = await createClient()
  await requireRole(supabase, ['teacher', 'admin'])

  const { data: sessions } = await supabase
    .from('school_sessions')
    .select('id, date, start_time, grade_range, level, status, location, schools(name)')
    .order('date', { ascending: false })
    .limit(50)

  const now = new Date()
  const upcoming = (sessions ?? []).filter((s: any) => new Date(s.date) >= now)
  const past = (sessions ?? []).filter((s: any) => new Date(s.date) < now)

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">School Portal</h1>
          <p className="text-gray-500">Book in-person workshops and track your impact.</p>
        </div>
        <Link href={`/${params.locale}/dashboard/school/reports`} className="btn-secondary text-sm py-2">
          View Impact Report →
        </Link>
      </div>

      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Book a Workshop Session</h2>
        <p className="text-sm text-gray-500 mb-4">
          $280 per 90-minute class session · $950 per full day (4 classes).
        </p>
        <form action={bookSession} className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="label" htmlFor="school_name">School name</label>
            <input id="school_name" name="school_name" className="input" required />
          </div>
          <div>
            <label className="label" htmlFor="date">Date</label>
            <input id="date" name="date" type="date" className="input" required />
          </div>
          <div>
            <label className="label" htmlFor="start_time">Start time</label>
            <input id="start_time" name="start_time" type="time" className="input" />
          </div>
          <div>
            <label className="label" htmlFor="grade_range">Grade range</label>
            <input id="grade_range" name="grade_range" className="input" placeholder="E.g. Gr 4–6" />
          </div>
          <div>
            <label className="label" htmlFor="level">Level</label>
            <select id="level" name="level" className="input">
              <option value="explorers">Explorers</option>
              <option value="builders">Builders</option>
              <option value="developers">Developers</option>
              <option value="engineers">Engineers</option>
            </select>
          </div>
          <div>
            <label className="label" htmlFor="capacity">Capacity</label>
            <input id="capacity" name="capacity" type="number" min={1} className="input" placeholder="30" />
          </div>
          <div className="md:col-span-2">
            <label className="label" htmlFor="location">Location</label>
            <input id="location" name="location" className="input" placeholder="Room / address" />
          </div>
          <div className="md:col-span-2">
            <button type="submit" className="btn-primary">Book Session</button>
          </div>
        </form>
      </section>

      <section>
        <h2 className="text-lg font-semibold text-gray-900 mb-3">Upcoming Sessions ({upcoming.length})</h2>
        {upcoming.length > 0 ? (
          <div className="space-y-3">
            {upcoming.map((s: any) => (
              <div key={s.id} className="card p-4 flex items-center justify-between">
                <div>
                  <p className="font-medium text-gray-900">{s.schools?.name ?? 'School'}</p>
                  <p className="text-sm text-gray-500">
                    {new Date(s.date).toLocaleDateString('en-CA', { dateStyle: 'medium' })}
                    {s.start_time ? ` · ${s.start_time}` : ''} {s.grade_range ? `· ${s.grade_range}` : ''}
                  </p>
                </div>
                <Link
                  href={`/${params.locale}/dashboard/school/attendance/${s.id}`}
                  className="btn-secondary text-sm py-1 px-3"
                >
                  Attendance
                </Link>
              </div>
            ))}
          </div>
        ) : (
          <div className="card p-8 text-center text-gray-500">No upcoming sessions booked yet.</div>
        )}
      </section>

      {past.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold text-gray-900 mb-3">Past Sessions</h2>
          <div className="space-y-2">
            {past.map((s: any) => (
              <div key={s.id} className="card p-3 flex items-center justify-between text-sm">
                <span className="text-gray-700">{s.schools?.name ?? 'School'}</span>
                <span className="text-gray-400">{new Date(s.date).toLocaleDateString('en-CA')}</span>
              </div>
            ))}
          </div>
        </section>
      )}
    </div>
  )
}
