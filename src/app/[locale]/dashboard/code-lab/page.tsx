import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import CodeLabEditor from '@/components/student/CodeLabEditor'
import BlocksEnvironment from '@/components/student/BlocksEnvironment'
import { resolveStudentId } from '@/lib/student-session'

export default async function CodeLabPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || !['parent', 'admin'].includes(appUser.role)) {
    redirect(`/${locale}/dashboard`)
  }

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) redirect(`/${locale}/dashboard/parent/children`)

  const { data: student } = await supabase
    .from('student_profiles')
    .select('level')
    .eq('id', studentId)
    .single()

  const level = student?.level || 'explorers'
  const isBlockBased = level === 'explorers' || level === 'builders'

  if (isBlockBased) {
    return <BlocksEnvironment />
  }

  return <CodeLabEditor level={level} isBlockBased={false} />
}
