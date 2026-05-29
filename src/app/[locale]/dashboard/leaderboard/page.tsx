import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { getTranslations } from 'next-intl/server'
import { resolveStudentId } from '@/lib/student-session'

export default async function LeaderboardPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || !['parent', 'admin'].includes(appUser.role)) redirect(`/${locale}/dashboard`)

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) redirect(`/${locale}/dashboard/parent/children`)

  const t = await getTranslations('leaderboard')

  const { data: myProfile } = await supabase
    .from('student_profiles')
    .select('id, full_name, avatar_emoji, xp_points, streak_days, visibility, level')
    .eq('id', studentId)
    .single()

  const { data: leaders } = await supabase
    .from('student_profiles')
    .select('id, full_name, avatar_emoji, xp_points, streak_days, level')
    .neq('visibility', 'private')
    .eq('level', myProfile?.level ?? 'explorers')
    .order('xp_points', { ascending: false })
    .limit(50)

  const myRank = leaders?.findIndex((l) => l.id === studentId)

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">{t('title')}</h1>

      {myProfile?.visibility === 'private' && (
        <div className="card p-4 bg-yellow-50 border border-yellow-200 text-sm text-yellow-800">
          Your profile is set to private. Update visibility in Settings to appear on the leaderboard.
        </div>
      )}

      {myRank !== undefined && myRank >= 0 && (
        <div className="card p-4 bg-brand-light border-2 border-brand-gold">
          <p className="font-bold text-brand-navy">
            Your rank: #{myRank + 1} · {myProfile?.xp_points ?? 0} XP · 🔥 {myProfile?.streak_days ?? 0}
          </p>
        </div>
      )}

      <div className="card overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500">Rank</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500">Student</th>
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500">XP</th>
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500">Streak</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {(leaders || []).map((row, i) => (
              <tr
                key={row.id}
                className={row.id === studentId ? 'bg-yellow-50 font-semibold' : ''}
              >
                <td className="px-4 py-3">{i + 1}</td>
                <td className="px-4 py-3">
                  <span className="mr-2">{row.avatar_emoji ?? '🚀'}</span>
                  {row.full_name}
                </td>
                <td className="px-4 py-3 text-right">{row.xp_points}</td>
                <td className="px-4 py-3 text-right">🔥 {row.streak_days}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
