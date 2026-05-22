import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import Link from 'next/link'

export default async function ClassesPage({ params }: { params: { locale: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'teacher')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  const { data: classes } = await supabase
    .from('classes')
    .select(`
      id, name, grade, join_code, is_active, created_at,
      class_memberships(count)
    `)
    .eq('teacher_id', profile!.id)
    .order('created_at', { ascending: false })

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-900">My Classes</h1>
        <Link href="classes/new" className="btn-primary">+ New Class</Link>
      </div>

      {(!classes || classes.length === 0) ? (
        <div className="card p-12 text-center">
          <div className="text-5xl mb-4">🏫</div>
          <h2 className="text-xl font-semibold text-gray-700 mb-2">No classes yet</h2>
          <p className="text-gray-500 mb-6">Create your first class to start managing students.</p>
          <Link href="classes/new" className="btn-primary">Create a Class</Link>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {classes.map((cls: any) => (
            <div key={cls.id} className="card p-6">
              <div className="flex items-start justify-between mb-3">
                <div>
                  <h3 className="font-semibold text-gray-900 text-lg">{cls.name}</h3>
                  {cls.grade && <p className="text-sm text-gray-500">Grade {cls.grade}</p>}
                </div>
                <span className={`badge ${cls.is_active ? 'badge-green' : 'badge-gray'}`}>
                  {cls.is_active ? 'Active' : 'Inactive'}
                </span>
              </div>
              <div className="flex items-center gap-4 mb-4">
                <div className="text-center">
                  <p className="text-2xl font-bold text-brand-navy">
                    {(cls.class_memberships as any)?.[0]?.count || 0}
                  </p>
                  <p className="text-xs text-gray-500">Students</p>
                </div>
                <div className="bg-gray-50 rounded-lg px-3 py-2 flex-1">
                  <p className="text-xs text-gray-500 mb-1">Join Code</p>
                  <p className="font-mono font-bold text-brand-navy tracking-widest text-lg">{cls.join_code}</p>
                </div>
              </div>
              <div className="flex gap-2">
                <Link href={`classes/${cls.id}`} className="btn-secondary text-sm flex-1 text-center py-1.5">
                  Manage
                </Link>
                <Link href={`reports?class=${cls.id}`} className="btn-secondary text-sm flex-1 text-center py-1.5">
                  Reports
                </Link>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
