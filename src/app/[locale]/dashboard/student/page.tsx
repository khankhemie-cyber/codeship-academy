import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { resolveStudentId } from '@/lib/student-session'

export default async function StudentDashboard({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: userData } = await supabase.from('users').select('*').eq('id', user.id).single()
  if (!userData) redirect(`/${locale}/login`)

  if (userData.role === 'parent') {
    const studentId = await resolveStudentId(supabase, user.id, 'parent')
    if (!studentId) redirect(`/${locale}/dashboard/parent/children`)
  } else if (userData.role !== 'admin') {
    redirect(`/${locale}/dashboard`)
  }

  const studentId = await resolveStudentId(supabase, user.id, userData.role)
  if (!studentId) redirect(`/${locale}/dashboard/parent/children`)

  const { data: student } = await supabase
    .from('student_profiles')
    .select('*')
    .eq('id', studentId)
    .single()

  const { data: recentProgress } = await supabase
    .from('lesson_progress')
    .select('*, lessons(slug, title, level, category, duration_minutes)')
    .eq('student_id', studentId)
    .eq('status', 'in_progress')
    .limit(3)

  const { data: achievements } = await supabase
    .from('student_achievements')
    .select('*, achievements(name, icon_emoji)')
    .eq('student_id', studentId)
    .order('awarded_at', { ascending: false })
    .limit(3)

  const { data: nextLesson } = await supabase
    .from('lessons')
    .select('*')
    .eq('level', student?.level ?? 'explorers')
    .eq('is_visible', true)
    .order('sort_order')
    .limit(1)
    .single()

  const level = student?.level ?? 'explorers'
  const levelEmoji: Record<string, string> = {
    explorers: '🌱',
    builders: '🏗️',
    developers: '💻',
    engineers: '⚙️',
  }

  const displayName = student?.full_name?.split(' ')[0] ?? 'Coder'

  return (
    <div>
      <div className="flex items-center gap-3 mb-8">
        <div className="text-4xl">{student?.avatar_emoji ?? '🚀'}</div>
        <div>
          <h1 className="text-2xl font-extrabold text-brand-navy">
            Hi, {displayName}! {levelEmoji[level]}
          </h1>
          <p className="text-gray-500">
            {student?.streak_days ?? 0} day streak · {student?.xp_points ?? 0} XP
          </p>
        </div>
      </div>

      <section className="mb-8">
        <h2 className="text-lg font-bold text-brand-navy mb-4">📚 Today&apos;s Task</h2>
        {nextLesson ? (
          <div className="card bg-gradient-to-r from-brand-navy to-brand-mid text-white">
            <div className="flex items-center justify-between flex-wrap gap-4">
              <div>
                <div className="text-xs uppercase tracking-wide text-gray-300 mb-1">{nextLesson.category}</div>
                <h3 className="font-extrabold text-xl mb-2">{nextLesson.title}</h3>
                <div className="flex items-center gap-4 text-sm text-gray-300">
                  <span>⏱️ {nextLesson.duration_minutes} min</span>
                  <span>⭐ {nextLesson.xp_reward} XP</span>
                </div>
              </div>
              <Link
                href={`/${locale}/dashboard/curriculum/${nextLesson.slug}`}
                className="bg-brand-gold text-brand-navy font-bold px-6 py-3 rounded-xl hover:opacity-90 transition-opacity whitespace-nowrap"
              >
                Start Now →
              </Link>
            </div>
          </div>
        ) : (
          <div className="card text-center py-8">
            <div className="text-4xl mb-2">🎉</div>
            <p className="font-bold">All caught up! Explore more lessons.</p>
          </div>
        )}
      </section>

      <section className="mb-8">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {[
            { icon: '⭐', label: 'XP Points', value: student?.xp_points ?? 0 },
            { icon: '🔥', label: 'Day Streak', value: student?.streak_days ?? 0 },
            { icon: '✅', label: 'Lessons Done', value: '—' },
            { icon: '🏅', label: 'Achievements', value: achievements?.length ?? 0 },
          ].map((stat) => (
            <div key={stat.label} className="card text-center">
              <div className="text-3xl mb-1">{stat.icon}</div>
              <div className="font-extrabold text-2xl text-brand-navy">{stat.value}</div>
              <div className="text-xs text-gray-500">{stat.label}</div>
            </div>
          ))}
        </div>
      </section>

      {recentProgress && recentProgress.length > 0 && (
        <section className="mb-8">
          <h2 className="text-lg font-bold text-brand-navy mb-4">📖 Continue Learning</h2>
          <div className="grid gap-4">
            {recentProgress.map((p: { id: string; lessons?: { slug?: string; title?: string; category?: string; duration_minutes?: number } }) => (
              <Link
                key={p.id}
                href={`/${locale}/dashboard/curriculum/${p.lessons?.slug}`}
                className="card hover:shadow-md transition-shadow flex items-center justify-between"
              >
                <div>
                  <div className="font-bold text-brand-navy">{p.lessons?.title}</div>
                  <div className="text-sm text-gray-500">
                    {p.lessons?.category} · {p.lessons?.duration_minutes} min
                  </div>
                </div>
                <span className="badge badge-blue">In Progress</span>
              </Link>
            ))}
          </div>
        </section>
      )}

      <section>
        <h2 className="text-lg font-bold text-brand-navy mb-4">Explore</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {[
            { href: `/${locale}/dashboard/curriculum`, icon: '📚', label: 'All Lessons' },
            { href: `/${locale}/dashboard/code-lab`, icon: '💻', label: 'Code Lab' },
            { href: `/${locale}/dashboard/achievements`, icon: '🏆', label: 'Achievements' },
            { href: `/${locale}/dashboard/leaderboard`, icon: '⚔️', label: 'Leaderboard' },
          ].map((item) => (
            <Link key={item.href} href={item.href} className="card text-center hover:shadow-md transition-shadow">
              <div className="text-3xl mb-2">{item.icon}</div>
              <div className="font-bold text-sm text-brand-navy">{item.label}</div>
            </Link>
          ))}
        </div>
      </section>
    </div>
  )
}
