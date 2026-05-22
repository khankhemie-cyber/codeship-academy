import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { getTranslations } from 'next-intl/server'

export default async function LeaderboardPage() {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student')
  const t = await getTranslations('leaderboard')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, leaderboard_opt_out')
    .eq('user_id', user.id)
    .single()

  // Top 50 students by XP (only those who haven't opted out)
  const { data: leaders } = await supabase
    .from('profiles')
    .select('id, display_name, avatar_url, total_xp, current_streak')
    .eq('role', 'student')
    .eq('leaderboard_opt_out', false)
    .order('total_xp', { ascending: false })
    .limit(50)

  const myRank = leaders?.findIndex((l: any) => l.id === profile?.id)

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">{t('title')}</h1>
        {profile?.leaderboard_opt_out ? (
          <span className="badge badge-gray">{t('private')}</span>
        ) : null}
      </div>

      {profile?.leaderboard_opt_out && (
        <div className="card p-4 bg-yellow-50 border border-yellow-200">
          <p className="text-sm text-yellow-800">
            You have opted out of the leaderboard. Your name is hidden from other students.
          </p>
          <form action="/api/leaderboard-opt" method="POST">
            <input type="hidden" name="opt_out" value="false" />
            <button type="submit" className="btn-secondary mt-2 text-sm py-1 px-3">
              Rejoin Leaderboard
            </button>
          </form>
        </div>
      )}

      {myRank !== undefined && myRank >= 0 && (
        <div className="card p-4 bg-brand-navy text-white">
          <p className="text-sm opacity-75">Your Ranking</p>
          <p className="text-3xl font-bold">#{myRank + 1}</p>
        </div>
      )}

      <div className="card overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wide">{t('rank')}</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wide">{t('student')}</th>
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase tracking-wide">{t('xp')}</th>
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase tracking-wide">{t('streak')}</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {(leaders || []).map((leader: any, i: number) => {
              const isMe = leader.id === profile?.id
              return (
                <tr key={leader.id} className={isMe ? 'bg-yellow-50' : ''}>
                  <td className="px-4 py-3">
                    <span className={`font-bold ${i === 0 ? 'text-yellow-500 text-lg' : i === 1 ? 'text-gray-400 text-lg' : i === 2 ? 'text-amber-600 text-lg' : 'text-gray-600'}`}>
                      {i === 0 ? '🥇' : i === 1 ? '🥈' : i === 2 ? '🥉' : `#${i + 1}`}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-3">
                      {leader.avatar_url ? (
                        <img src={leader.avatar_url} alt="" className="w-8 h-8 rounded-full" />
                      ) : (
                        <div className="w-8 h-8 rounded-full bg-brand-mid flex items-center justify-center text-white text-sm font-bold">
                          {leader.display_name?.[0]?.toUpperCase() || '?'}
                        </div>
                      )}
                      <span className="font-medium text-gray-900">
                        {leader.display_name || 'Student'}
                        {isMe && <span className="ml-2 text-xs text-brand-gold font-semibold">You</span>}
                      </span>
                    </div>
                  </td>
                  <td className="px-4 py-3 text-right font-bold text-brand-navy">
                    {leader.total_xp?.toLocaleString() || 0}
                  </td>
                  <td className="px-4 py-3 text-right text-gray-600">
                    🔥 {leader.current_streak || 0}
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
        {(!leaders || leaders.length === 0) && (
          <p className="text-center text-gray-500 py-8">No rankings yet. Start learning to appear here!</p>
        )}
      </div>

      <div className="text-center">
        <form action="/api/leaderboard-opt" method="POST">
          <input type="hidden" name="opt_out" value="true" />
          <button type="submit" className="text-sm text-gray-400 hover:text-gray-600 underline">
            {t('optOut')}
          </button>
        </form>
      </div>
    </div>
  )
}
