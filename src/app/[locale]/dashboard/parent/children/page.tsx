import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import AddChildForm from '@/components/parent/AddChildForm'
import Link from 'next/link'
import { ChildSwitcher } from '@/components/parent/ChildSwitcher'

export default async function ChildrenPage({
  params,
}: {
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent', locale)

  const { data: students } = await supabase
    .from('student_profiles')
    .select('id, full_name, level, grade, age, xp_points, streak_days, avatar_emoji')
    .eq('parent_id', user.id)
    .order('created_at', { ascending: true })

  const levelLabels: Record<string, string> = {
    explorers: '🌱 Explorers',
    builders: '🏗️ Builders',
    developers: '💻 Developers',
    engineers: '⚙️ Engineers',
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between flex-wrap gap-4">
        <h1 className="text-2xl font-bold text-gray-900">My Children</h1>
        {students && students.length > 0 && (
          <ChildSwitcher students={students} locale={locale} />
        )}
      </div>

      {students && students.length > 0 && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {students.map((child) => (
            <div key={child.id} className="card p-6">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-12 h-12 rounded-full bg-brand-mid flex items-center justify-center text-2xl">
                  {child.avatar_emoji ?? '🚀'}
                </div>
                <div>
                  <h3 className="font-semibold text-gray-900">{child.full_name}</h3>
                  <p className="text-sm text-gray-500">
                    {levelLabels[child.level] || child.level} · Grade {child.grade}
                  </p>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3 mb-4">
                <div className="bg-gray-50 rounded-lg p-3 text-center">
                  <p className="text-xl font-bold text-brand-gold">{child.xp_points?.toLocaleString() || 0}</p>
                  <p className="text-xs text-gray-500">XP</p>
                </div>
                <div className="bg-gray-50 rounded-lg p-3 text-center">
                  <p className="text-xl font-bold text-orange-500">🔥 {child.streak_days || 0}</p>
                  <p className="text-xs text-gray-500">Day Streak</p>
                </div>
              </div>
              <div className="flex gap-2">
                <Link
                  href={`/${locale}/dashboard/parent/progress?student=${child.id}`}
                  className="btn-secondary text-sm py-1 flex-1 text-center"
                >
                  View Progress
                </Link>
                <Link
                  href={`/${locale}/dashboard/student`}
                  className="btn-primary text-sm py-1 flex-1 text-center"
                >
                  Learn as {child.full_name.split(' ')[0]}
                </Link>
              </div>
            </div>
          ))}
        </div>
      )}

      <div className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Add a child</h2>
        <AddChildForm />
      </div>
    </div>
  )
}
