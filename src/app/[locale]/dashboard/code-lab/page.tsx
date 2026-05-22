import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import CodeLabEditor from '@/components/student/CodeLabEditor'

export default async function CodeLabPage() {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, level')
    .eq('user_id', user.id)
    .single()

  // Explorers (K-3) use block-based; builders+ use text editor
  const isBlockBased = profile?.level === 'explorers'

  return <CodeLabEditor level={profile?.level || 'explorers'} isBlockBased={isBlockBased} />
}
