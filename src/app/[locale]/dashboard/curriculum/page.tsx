import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'

const LEVEL_META: Record<string, { emoji: string; label: string; grades: string }> = {
  explorers:  { emoji: '🌱', label: 'Explorers',  grades: 'K–1' },
  builders:   { emoji: '🏗️', label: 'Builders',   grades: 'Gr 2–3' },
  developers: { emoji: '💻', label: 'Developers', grades: 'Gr 4–8' },
  engineers:  { emoji: '⚙️', label: 'Engineers',  grades: 'Gr 7–8' },
}

const STATUS_STYLES: Record<string, string> = {
  completed:    'bg-brand-gold text-brand-navy',
  in_progress:  'bg-blue-100 text-blue-800',
  needs_review: 'bg-amber-100 text-amber-800',
  not_started:  'bg-gray-100 text-gray-500',
}

export default async function CurriculumPage({
  params,
  searchParams,
}: {
  params: Promise<{ locale: string }>
  searchParams: Promise<{ level?: string; category?: string; type?: string }>
}) {
  const { locale } = await params
  const { level: levelFilter, category: catFilter, type = 'lessons' } = await searchParams

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: userData } = await supabase.from('users').select('role').eq('id', user.id).single()
  const { data: ownProfile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()
  let studentId = ownProfile?.id ?? user.id

  // For parents, get the first child
  if (userData?.role === 'parent') {
    const { data: firstChild } = await supabase
      .from('student_profiles')
      .select('id')
      .eq('parent_id', user.id)
      .limit(1)
      .single()
    studentId = firstChild?.id ?? studentId
  }

  // Fetch curriculum items
  const table = type === 'projects' ? 'projects' : type === 'quizzes' ? 'quizzes' : 'lessons'
  let query = supabase.from(table).select('*').eq('is_visible', true).order('sort_order', { nullsFirst: true })

  if (levelFilter) query = query.eq('level', levelFilter)
  if (catFilter) query = query.eq('category', catFilter)

  const { data: items } = await query.limit(50)

  // Fetch progress for lessons
  let progressMap: Record<string, string> = {}
  if (type === 'lessons' && items) {
    const { data: progress } = await supabase
      .from('lesson_progress')
      .select('lesson_id, status')
      .eq('student_id', studentId)
      .in('lesson_id', items.map((i: any) => i.id))

    progress?.forEach((p: any) => { progressMap[p.lesson_id] = p.status })
  }

  const levels = ['explorers', 'builders', 'developers']
  const categories: Record<string, string[]> = {
    explorers:  ['Fundamentals', 'Algorithms', 'Block Coding', 'Creative Coding', 'Digital Citizenship', 'Computational Thinking', 'Art & Design'],
    builders:   ['HTML', 'CSS', 'Scratch', 'Accessibility', 'Digital Citizenship', 'Projects'],
    developers: ['JavaScript', 'Node.js', 'React', 'Python', 'Algorithms', 'Testing', 'Fundamentals', 'Projects'],
  }

  return (
    <div>
      <h1 className="text-2xl font-extrabold text-brand-navy mb-6">Curriculum Browser</h1>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 mb-6">
        {/* Level filter */}
        <div className="flex gap-2 flex-wrap">
          <Link
            href={`/${locale}/dashboard/curriculum?type=${type}`}
            className={`badge py-1.5 px-3 text-sm ${!levelFilter ? 'badge-navy' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}`}
          >
            All Levels
          </Link>
          {levels.map((lvl) => (
            <Link
              key={lvl}
              href={`/${locale}/dashboard/curriculum?level=${lvl}&type=${type}`}
              className={`badge py-1.5 px-3 text-sm capitalize ${levelFilter === lvl ? 'badge-navy' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}`}
            >
              {LEVEL_META[lvl].emoji} {LEVEL_META[lvl].label}
            </Link>
          ))}
        </div>

        {/* Type filter */}
        <div className="flex gap-2 ml-auto">
          {['lessons', 'projects', 'quizzes'].map((t) => (
            <Link
              key={t}
              href={`/${locale}/dashboard/curriculum?${levelFilter ? `level=${levelFilter}&` : ''}type=${t}`}
              className={`badge py-1.5 px-3 text-sm capitalize ${type === t ? 'badge-gold' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}`}
            >
              {t}
            </Link>
          ))}
        </div>
      </div>

      {/* Category filter (when level selected) */}
      {levelFilter && categories[levelFilter] && (
        <div className="flex flex-wrap gap-2 mb-6">
          <Link
            href={`/${locale}/dashboard/curriculum?level=${levelFilter}&type=${type}`}
            className={`badge py-1 px-2.5 text-xs ${!catFilter ? 'badge-navy' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}
          >
            All
          </Link>
          {categories[levelFilter].map((cat) => (
            <Link
              key={cat}
              href={`/${locale}/dashboard/curriculum?level=${levelFilter}&category=${encodeURIComponent(cat)}&type=${type}`}
              className={`badge py-1 px-2.5 text-xs ${catFilter === cat ? 'badge-navy' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}`}
            >
              {cat}
            </Link>
          ))}
        </div>
      )}

      {/* Items grid */}
      {items && items.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {items.map((item: any) => {
            const status = type === 'lessons' ? (progressMap[item.id] ?? 'not_started') : null
            const href = type === 'projects'
              ? `/${locale}/dashboard/project/${item.slug}`
              : type === 'quizzes'
              ? `/${locale}/dashboard/quiz/${item.slug}`
              : `/${locale}/dashboard/curriculum/${item.slug}`
            const lvlMeta = LEVEL_META[item.level] ?? { emoji: '📚', label: item.level, grades: '' }

            return (
              <Link key={item.id} href={href} className="card hover:shadow-md transition-shadow group">
                <div className="flex items-start justify-between mb-3">
                  <span className="badge bg-gray-100 text-gray-700 capitalize text-xs">
                    {lvlMeta.emoji} {item.category}
                  </span>
                  {status && (
                    <span className={`badge text-xs ${STATUS_STYLES[status] ?? STATUS_STYLES.not_started}`}>
                      {status === 'not_started' ? '○ New' : status === 'in_progress' ? '◑ In Progress' : status === 'completed' ? '● Done' : '↻ Review'}
                    </span>
                  )}
                </div>

                <h3 className="font-bold text-brand-navy group-hover:text-brand-mid transition-colors mb-2 line-clamp-2">
                  {item.title}
                </h3>

                <div className="flex items-center gap-3 text-xs text-gray-500">
                  {item.duration_minutes && <span>⏱️ {item.duration_minutes} min</span>}
                  {item.xp_reward && <span>⭐ {item.xp_reward} XP</span>}
                  {item.difficulty && <span className="badge bg-gray-100 text-gray-600">{item.difficulty}</span>}
                </div>
              </Link>
            )
          })}
        </div>
      ) : (
        <div className="card text-center py-12">
          <div className="text-5xl mb-4">📚</div>
          <h3 className="font-bold mb-2">No content found</h3>
          <p className="text-gray-500">Try adjusting your filters or select a different level.</p>
        </div>
      )}
    </div>
  )
}
