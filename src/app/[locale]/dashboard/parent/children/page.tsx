import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import AddChildForm from '@/components/parent/AddChildForm'

export default async function ChildrenPage() {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent')

  const { data: parent } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  const { data: children } = await supabase
    .from('parent_student_links')
    .select(`
      student_id,
      consent_given,
      profiles!parent_student_links_student_id_fkey (
        id, display_name, level, total_xp, current_streak
      )
    `)
    .eq('parent_id', parent!.id)

  const levelLabels: Record<string, string> = {
    explorers: '🌱 Explorers',
    builders: '🔨 Builders',
    developers: '💻 Developers',
    engineers: '⚙️ Engineers',
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">My Children</h1>
      </div>

      {children && children.length > 0 && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {children.map((link: any) => {
            const child = link.profiles
            if (!child) return null
            return (
              <div key={link.student_id} className="card p-6">
                <div className="flex items-center gap-4 mb-4">
                  <div className="w-12 h-12 rounded-full bg-brand-mid flex items-center justify-center text-white text-xl font-bold">
                    {child.display_name?.[0]?.toUpperCase() || '?'}
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900">{child.display_name || 'Student'}</h3>
                    <p className="text-sm text-gray-500">{levelLabels[child.level] || child.level}</p>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-3 mb-4">
                  <div className="bg-gray-50 rounded-lg p-3 text-center">
                    <p className="text-xl font-bold text-brand-gold">{child.total_xp?.toLocaleString() || 0}</p>
                    <p className="text-xs text-gray-500">XP</p>
                  </div>
                  <div className="bg-gray-50 rounded-lg p-3 text-center">
                    <p className="text-xl font-bold text-orange-500">🔥 {child.current_streak || 0}</p>
                    <p className="text-xs text-gray-500">Day Streak</p>
                  </div>
                </div>
                {!link.consent_given && (
                  <div className="p-2 bg-yellow-50 border border-yellow-200 rounded text-xs text-yellow-700 mb-3">
                    ⚠️ Parental consent pending
                  </div>
                )}
                <div className="flex gap-2">
                  <a href={`progress?child=${link.student_id}`} className="btn-secondary text-sm py-1 flex-1 text-center">
                    View Progress
                  </a>
                  <button className="btn-secondary text-sm py-1 px-3 text-red-600 hover:bg-red-50">
                    Remove
                  </button>
                </div>
              </div>
            )
          })}
        </div>
      )}

      <div className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Add a Child</h2>
        <AddChildForm parentId={parent!.id} />
      </div>
    </div>
  )
}
