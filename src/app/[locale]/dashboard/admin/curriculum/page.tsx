import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function CurriculumCMSPage({ searchParams }: { searchParams: { level?: string; type?: string } }) {
  const supabase = await createClient()
  await requireRole(supabase, 'admin')

  const level = searchParams.level || 'explorers'
  const type = searchParams.type || 'lessons'

  const levels = ['explorers', 'builders', 'developers', 'engineers']
  const types = ['lessons', 'projects', 'quizzes']

  let data: any[] = []
  let count = 0

  if (type === 'lessons') {
    const res = await supabase
      .from('lessons')
      .select('id, slug, title, category, duration_minutes, sort_order, is_published', { count: 'exact' })
      .eq('level', level)
      .order('sort_order', { ascending: true })
    data = res.data || []
    count = res.count || 0
  } else if (type === 'projects') {
    const res = await supabase
      .from('projects')
      .select('id, slug, title, difficulty, duration_minutes, sort_order, is_published', { count: 'exact' })
      .eq('level', level)
      .order('sort_order', { ascending: true })
    data = res.data || []
    count = res.count || 0
  } else {
    const res = await supabase
      .from('quizzes')
      .select('id, slug, title, category, time_limit_seconds, passing_score', { count: 'exact' })
      .eq('level', level)
      .order('title', { ascending: true })
    data = res.data || []
    count = res.count || 0
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Curriculum CMS</h1>

      {/* Level/type selectors */}
      <div className="flex flex-wrap gap-2">
        {levels.map(l => (
          <a
            key={l}
            href={`?level=${l}&type=${type}`}
            className={`px-3 py-1.5 rounded-lg border text-sm font-medium capitalize transition-colors ${l === level ? 'bg-brand-navy text-white border-brand-navy' : 'border-gray-200 text-gray-700 hover:bg-gray-50'}`}
          >
            {l}
          </a>
        ))}
        <span className="mx-2 text-gray-300">|</span>
        {types.map(t => (
          <a
            key={t}
            href={`?level=${level}&type=${t}`}
            className={`px-3 py-1.5 rounded-lg border text-sm font-medium capitalize transition-colors ${t === type ? 'bg-brand-gold text-brand-dark border-brand-gold' : 'border-gray-200 text-gray-700 hover:bg-gray-50'}`}
          >
            {t}
          </a>
        ))}
      </div>

      <div className="flex items-center justify-between">
        <p className="text-sm text-gray-500">{count} {type} in {level}</p>
        <button className="btn-primary text-sm">+ Add {type.slice(0, -1)}</button>
      </div>

      <div className="card overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">#</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Slug</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Title</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Category</th>
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Duration</th>
              {type !== 'quizzes' && (
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Published</th>
              )}
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {data.map((item: any, i: number) => (
              <tr key={item.id} className="hover:bg-gray-50">
                <td className="px-4 py-2 text-gray-400">{item.sort_order || i + 1}</td>
                <td className="px-4 py-2 font-mono text-xs text-gray-500">{item.slug}</td>
                <td className="px-4 py-2 font-medium text-gray-900">{item.title}</td>
                <td className="px-4 py-2 text-gray-500">{item.category || '—'}</td>
                <td className="px-4 py-2 text-right text-gray-500">
                  {item.duration_minutes ? `${item.duration_minutes}m` : item.time_limit_seconds ? `${item.time_limit_seconds / 60}m` : '—'}
                </td>
                {type !== 'quizzes' && (
                  <td className="px-4 py-2 text-center">
                    <span className={`inline-block w-2 h-2 rounded-full ${item.is_published ? 'bg-green-500' : 'bg-gray-300'}`} />
                  </td>
                )}
                <td className="px-4 py-2 text-right">
                  <button className="text-xs text-brand-navy hover:underline">Edit</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {data.length === 0 && (
          <p className="text-center text-gray-500 py-8">No {type} found for {level}.</p>
        )}
      </div>
    </div>
  )
}
