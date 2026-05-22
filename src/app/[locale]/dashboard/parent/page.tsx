import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'

export default async function ParentDashboard({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: userData } = await supabase.from('users').select('*').eq('id', user.id).single()
  if (userData?.role !== 'parent' && userData?.role !== 'admin') redirect(`/${locale}/dashboard`)

  const { data: students } = await supabase
    .from('student_profiles')
    .select('*')
    .eq('parent_id', user.id)

  const { data: subscription } = await supabase
    .from('subscriptions')
    .select('*')
    .eq('user_id', user.id)
    .single()

  const trialEnds = subscription?.trial_ends_at ? new Date(subscription.trial_ends_at) : null
  const daysLeft = trialEnds ? Math.max(0, Math.ceil((trialEnds.getTime() - Date.now()) / 86400000)) : 0
  const isTrial = subscription?.status === 'trial'

  return (
    <div>
      <h1 className="text-2xl font-extrabold text-brand-navy mb-2">
        Welcome back, {userData?.full_name?.split(' ')[0] ?? 'Parent'}! 👋
      </h1>
      <p className="text-gray-500 mb-8">Here&apos;s how your children are doing</p>

      {isTrial && (
        <div className="mb-6 p-4 bg-amber-50 border border-amber-200 rounded-xl flex items-center justify-between">
          <div>
            <span className="font-bold text-amber-800">Free trial: {daysLeft} days remaining</span>
            <p className="text-sm text-amber-700 mt-0.5">Subscribe to keep full access after your trial ends.</p>
          </div>
          <Link href={`/${locale}/dashboard/parent/subscription`} className="btn-primary text-sm py-2">
            Subscribe Now
          </Link>
        </div>
      )}

      {/* Children overview */}
      <section className="mb-8">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-brand-navy">My Children</h2>
          <Link href={`/${locale}/dashboard/parent/children/add`} className="btn-secondary text-sm py-2">
            + Add Child
          </Link>
        </div>

        {students && students.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {students.map((student) => (
              <div key={student.id} className="card hover:shadow-md transition-shadow">
                <div className="flex items-center gap-3 mb-4">
                  <div className="text-4xl">{student.avatar_emoji ?? '🚀'}</div>
                  <div>
                    <div className="font-bold text-brand-navy">{student.full_name}</div>
                    <div className="text-sm text-gray-500">Grade {student.grade} · Age {student.age}</div>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-2 mb-4">
                  <div className="text-center p-2 bg-brand-light rounded-xl">
                    <div className="font-extrabold text-brand-navy">{student.xp_points}</div>
                    <div className="text-xs text-gray-500">XP</div>
                  </div>
                  <div className="text-center p-2 bg-brand-light rounded-xl">
                    <div className="font-extrabold text-brand-navy">{student.streak_days}</div>
                    <div className="text-xs text-gray-500">Streak</div>
                  </div>
                  <div className="text-center p-2 bg-brand-light rounded-xl">
                    <div className="font-extrabold text-brand-navy capitalize">{student.level?.charAt(0).toUpperCase() + student.level?.slice(1)}</div>
                    <div className="text-xs text-gray-500">Level</div>
                  </div>
                </div>

                <div className="flex gap-2">
                  <Link
                    href={`/${locale}/dashboard/parent/progress?student=${student.id}`}
                    className="flex-1 btn-outline text-xs py-2 text-center"
                  >
                    View Progress
                  </Link>
                  <Link
                    href={`/${locale}/dashboard/parent/planner?student=${student.id}`}
                    className="flex-1 btn-secondary text-xs py-2 text-center"
                  >
                    Learning Plan
                  </Link>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="card text-center py-12">
            <div className="text-6xl mb-4">👶</div>
            <h3 className="font-bold text-lg mb-2">No children yet</h3>
            <p className="text-gray-500 mb-6">Add your first child to get started with the AI assessment.</p>
            <Link href={`/${locale}/dashboard/parent/children/add`} className="btn-primary">
              Add Your First Child
            </Link>
          </div>
        )}
      </section>

      {/* Quick actions */}
      <section>
        <h2 className="text-lg font-bold text-brand-navy mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {[
            { href: `/${locale}/dashboard/parent/assessment`, icon: '🎯', label: 'Run AI Assessment', desc: 'Find the right level' },
            { href: `/${locale}/dashboard/parent/planner`, icon: '📅', label: 'Generate Plan', desc: 'AI weekly learning plan' },
            { href: `/${locale}/dashboard/parent/progress`, icon: '📊', label: 'View Progress', desc: 'Lessons & quiz scores' },
            { href: `/${locale}/dashboard/parent/subscription`, icon: '💳', label: 'Subscription', desc: 'Manage your plan' },
          ].map((action) => (
            <Link key={action.href} href={action.href} className="card hover:shadow-md transition-shadow text-center">
              <div className="text-3xl mb-2">{action.icon}</div>
              <div className="font-bold text-brand-navy text-sm">{action.label}</div>
              <div className="text-xs text-gray-500 mt-1">{action.desc}</div>
            </Link>
          ))}
        </div>
      </section>
    </div>
  )
}
