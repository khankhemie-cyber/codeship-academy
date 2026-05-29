import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import { getTranslations } from 'next-intl/server'
import { resolveStudentId } from '@/lib/student-session'

type AchievementRow = {
  id: string
  name: string
  description: string | null
  icon_emoji: string | null
  xp_reward: number
}

function normalizeAchievement(raw: unknown): AchievementRow | null {
  if (!raw) return null
  if (Array.isArray(raw)) return (raw[0] as AchievementRow) ?? null
  return raw as AchievementRow
}

export default async function AchievementsPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || !['parent', 'admin'].includes(appUser.role)) redirect(`/${locale}/dashboard`)

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) redirect(`/${locale}/dashboard/parent/children`)

  const t = await getTranslations('achievements')

  const { data: earned } = await supabase
    .from('student_achievements')
    .select('awarded_at, achievements(id, slug, name, description, icon_emoji, xp_reward)')
    .eq('student_id', studentId)
    .order('awarded_at', { ascending: false })

  const { data: allAchievements } = await supabase
    .from('achievements')
    .select('*')
    .eq('is_active', true)
    .order('name')

  const earnedIds = new Set(
    (earned || [])
      .map((e) => normalizeAchievement(e.achievements)?.id)
      .filter((id): id is string => Boolean(id))
  )

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">{t('title')}</h1>
        <p className="text-gray-500 mt-1">
          {earned?.length || 0} / {allAchievements?.length || 0} earned
        </p>
      </div>

      {earned && earned.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold text-gray-800 mb-4">{t('earned')}</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            {earned.map((e) => {
              const a = normalizeAchievement(e.achievements)
              if (!a) return null
              return (
                <div key={a.id} className="card text-center p-4 border-2 border-brand-gold">
                  <div className="text-4xl mb-2">{a.icon_emoji}</div>
                  <p className="font-semibold text-sm">{a.name}</p>
                  <p className="text-xs text-gray-500 mt-1">{a.description}</p>
                  <p className="text-xs font-bold text-brand-gold mt-2">+{a.xp_reward} XP</p>
                </div>
              )
            })}
          </div>
        </section>
      )}

      <section>
        <h2 className="text-lg font-semibold text-gray-800 mb-4">{t('locked')}</h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
          {(allAchievements || [])
            .filter((a) => !earnedIds.has(a.id))
            .map((a) => (
              <div key={a.id} className="card text-center p-4 opacity-50 grayscale">
                <div className="text-4xl mb-2">{a.icon_emoji}</div>
                <p className="font-semibold text-sm">{a.name}</p>
                <p className="text-xs text-gray-500 mt-1">{a.description}</p>
                <div className="text-xs text-gray-400 mt-2">🔒 Locked</div>
              </div>
            ))}
        </div>
      </section>
    </div>
  )
}
