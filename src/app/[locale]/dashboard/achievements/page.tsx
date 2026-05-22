import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { useTranslations } from 'next-intl'
import { getTranslations } from 'next-intl/server'

export default async function AchievementsPage() {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student')
  const t = await getTranslations('achievements')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  const { data: earned } = await supabase
    .from('student_achievements')
    .select('earned_at, achievements(id, slug, title, description, icon, xp_value, category)')
    .eq('student_id', profile!.id)
    .order('earned_at', { ascending: false })

  const { data: allAchievements } = await supabase
    .from('achievements')
    .select('*')
    .order('category', { ascending: true })

  const earnedIds = new Set((earned || []).map((e: any) => e.achievements?.id))

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">{t('title')}</h1>
        <p className="text-gray-500 mt-1">{earned?.length || 0} / {allAchievements?.length || 0} earned</p>
      </div>

      {/* Earned */}
      {earned && earned.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold text-gray-800 mb-4">{t('earned')}</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            {earned.map((e: any) => {
              const a = e.achievements
              if (!a) return null
              return (
                <div key={a.id} className="card text-center p-4 border-2 border-brand-gold">
                  <div className="text-4xl mb-2">{a.icon}</div>
                  <p className="font-semibold text-sm text-gray-900">{a.title}</p>
                  <p className="text-xs text-gray-500 mt-1">{a.description}</p>
                  <p className="text-xs font-bold text-brand-gold mt-2">+{a.xp_value} XP</p>
                  <p className="text-xs text-gray-400 mt-1">
                    {new Date(e.earned_at).toLocaleDateString()}
                  </p>
                </div>
              )
            })}
          </div>
        </section>
      )}

      {/* Locked */}
      <section>
        <h2 className="text-lg font-semibold text-gray-800 mb-4">{t('locked')}</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {(allAchievements || [])
            .filter((a: any) => !earnedIds.has(a.id))
            .map((a: any) => (
              <div key={a.id} className="card text-center p-4 opacity-50 grayscale">
                <div className="text-4xl mb-2">{a.icon}</div>
                <p className="font-semibold text-sm text-gray-900">{a.title}</p>
                <p className="text-xs text-gray-500 mt-1">{a.description}</p>
                <p className="text-xs font-bold text-gray-400 mt-2">+{a.xp_value} XP</p>
                <div className="text-xs text-gray-400 mt-1">🔒 Locked</div>
              </div>
            ))}
        </div>
        {(allAchievements || []).filter((a: any) => !earnedIds.has(a.id)).length === 0 && (
          <p className="text-gray-500">{t('noAchievements')}</p>
        )}
      </section>
    </div>
  )
}
