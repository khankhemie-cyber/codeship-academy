import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import AddChildForm from '@/components/parent/AddChildForm'
import Link from 'next/link'

export default async function AddChildPage({ params }: { params: { locale: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent')

  const { data: parent } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  return (
    <div className="max-w-xl space-y-6">
      <div>
        <Link
          href={`/${params.locale}/dashboard/parent/children`}
          className="text-sm text-gray-500 hover:text-brand-navy"
        >
          ← Back to My Children
        </Link>
      </div>
      <h1 className="text-2xl font-bold text-gray-900">Add a Child</h1>
      <p className="text-gray-500">
        Create a learning profile for your child. You can run the AI placement
        assessment afterwards to find the right starting level.
      </p>
      <div className="card p-6">
        <AddChildForm parentId={parent!.id} />
      </div>
    </div>
  )
}
