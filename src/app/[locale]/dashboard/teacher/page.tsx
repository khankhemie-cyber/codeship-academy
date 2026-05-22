import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'

export default async function TeacherDashboard({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: userData } = await supabase.from('users').select('*').eq('id', user.id).single()
  if (userData?.role !== 'teacher' && userData?.role !== 'admin') redirect(`/${locale}/dashboard`)

  const { data: classes } = await supabase
    .from('classes')
    .select('*, class_memberships(count)')
    .eq('teacher_id', user.id)
    .eq('is_active', true)

  const { data: teacherProfile } = await supabase
    .from('teacher_profiles')
    .select('*')
    .eq('user_id', user.id)
    .single()

  return (
    <div>
      <h1 className="text-2xl font-extrabold text-brand-navy mb-2">
        Teacher Dashboard 🍎
      </h1>
      <p className="text-gray-500 mb-8">
        {teacherProfile?.school_name ?? 'Manage your classes and track student progress'}
      </p>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        <div className="card text-center">
          <div className="text-3xl font-extrabold text-brand-navy">{classes?.length ?? 0}</div>
          <div className="text-sm text-gray-500 mt-1">Active Classes</div>
        </div>
        <div className="card text-center">
          <div className="text-3xl font-extrabold text-brand-navy">
            {classes?.reduce((acc: number, c: any) => acc + (c.class_memberships?.[0]?.count ?? 0), 0) ?? 0}
          </div>
          <div className="text-sm text-gray-500 mt-1">Total Students</div>
        </div>
        <div className="card text-center">
          <div className="text-3xl font-extrabold text-brand-navy">—</div>
          <div className="text-sm text-gray-500 mt-1">Quizzes This Week</div>
        </div>
      </div>

      {/* Classes */}
      <section className="mb-8">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-brand-navy">My Classes</h2>
          <Link href={`/${locale}/dashboard/classes/new`} className="btn-secondary text-sm py-2">
            + New Class
          </Link>
        </div>

        {classes && classes.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {classes.map((cls: any) => (
              <div key={cls.id} className="card hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between mb-3">
                  <h3 className="font-bold text-brand-navy">{cls.name}</h3>
                  <span className="badge badge-navy font-mono text-xs tracking-widest">{cls.code}</span>
                </div>
                <div className="text-sm text-gray-500 mb-4">
                  Grade {cls.grade} · {cls.class_memberships?.[0]?.count ?? 0} students
                </div>
                <div className="flex gap-2">
                  <Link href={`/${locale}/dashboard/classes/${cls.id}`} className="flex-1 btn-outline text-xs py-2 text-center">
                    View Roster
                  </Link>
                  <Link href={`/${locale}/dashboard/reports?class=${cls.id}`} className="flex-1 btn-secondary text-xs py-2 text-center">
                    Reports
                  </Link>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="card text-center py-10">
            <div className="text-5xl mb-4">🏫</div>
            <h3 className="font-bold mb-2">No classes yet</h3>
            <p className="text-gray-500 mb-4">Create your first class to get started.</p>
            <Link href={`/${locale}/dashboard/classes/new`} className="btn-primary">Create a Class</Link>
          </div>
        )}
      </section>

      {/* Quick actions */}
      <section>
        <h2 className="text-lg font-bold text-brand-navy mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {[
            { href: `/${locale}/dashboard/classes`, icon: '👥', label: 'Manage Classes' },
            { href: `/${locale}/dashboard/reports`, icon: '📊', label: 'Quiz Reports' },
            { href: `/${locale}/dashboard/school`, icon: '🏫', label: 'School Portal' },
            { href: `/${locale}/dashboard/school/impact`, icon: '📈', label: 'Impact Report' },
          ].map((action) => (
            <Link key={action.href} href={action.href} className="card text-center hover:shadow-md transition-shadow">
              <div className="text-3xl mb-2">{action.icon}</div>
              <div className="font-bold text-sm text-brand-navy">{action.label}</div>
            </Link>
          ))}
        </div>
      </section>
    </div>
  )
}
