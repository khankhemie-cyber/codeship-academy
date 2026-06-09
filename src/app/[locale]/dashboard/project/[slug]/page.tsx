import { createClient } from '@/lib/supabase/server'
import { redirect, notFound } from 'next/navigation'
import ProjectViewer from '@/components/student/ProjectViewer'
import { resolveStudentId } from '@/lib/student-session'

export default async function ProjectPage({
  params,
}: {
  params: Promise<{ locale: string; slug: string }>
}) {
  const { locale, slug } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || !['parent', 'admin'].includes(appUser.role)) redirect(`/${locale}/dashboard`)

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) redirect(`/${locale}/dashboard/parent/children`)

  const { data: project } = await supabase.from('projects').select('*').eq('slug', slug).single()
  if (!project) notFound()

  const { data: submission } = await supabase
    .from('project_submissions')
    .select('*')
    .eq('project_id', project.id)
    .eq('student_id', studentId)
    .order('created_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  return (
    <ProjectViewer
      project={project}
      studentId={studentId}
      existingSubmission={submission}
      locale={locale}
    />
  )
}
