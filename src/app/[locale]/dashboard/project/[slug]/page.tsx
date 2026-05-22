import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { notFound } from 'next/navigation'
import ProjectViewer from '@/components/student/ProjectViewer'

export default async function ProjectPage({ params }: { params: { locale: string; slug: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student')

  const { data: project } = await supabase
    .from('projects')
    .select('*')
    .eq('slug', params.slug)
    .single()

  if (!project) notFound()

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  const { data: submission } = await supabase
    .from('project_submissions')
    .select('*')
    .eq('project_id', project.id)
    .eq('student_id', profile!.id)
    .order('submitted_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  return (
    <ProjectViewer
      project={project}
      studentId={profile!.id}
      existingSubmission={submission}
      locale={params.locale}
    />
  )
}
