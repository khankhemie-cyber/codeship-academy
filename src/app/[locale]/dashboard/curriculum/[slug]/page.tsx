import { createClient } from '@/lib/supabase/server'
import { redirect, notFound } from 'next/navigation'
import Link from 'next/link'
import LessonViewer from '@/components/curriculum/LessonViewer'

export default async function LessonPage({
  params,
}: {
  params: Promise<{ locale: string; slug: string }>
}) {
  const { locale, slug } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: lesson } = await supabase
    .from('lessons')
    .select('*')
    .eq('slug', slug)
    .eq('is_visible', true)
    .single()

  if (!lesson) notFound()

  const { data: userData } = await supabase.from('users').select('role').eq('id', user.id).single()
  let studentId = user.id

  if (userData?.role === 'parent') {
    const { data: firstChild } = await supabase
      .from('student_profiles')
      .select('id')
      .eq('parent_id', user.id)
      .limit(1)
      .single()
    studentId = firstChild?.id ?? user.id
  }

  const { data: progress } = await supabase
    .from('lesson_progress')
    .select('*')
    .eq('student_id', studentId)
    .eq('lesson_id', lesson.id)
    .single()

  const { data: student } = await supabase
    .from('student_profiles')
    .select('level, age')
    .eq('id', studentId)
    .single()

  return (
    <div>
      <div className="mb-6">
        <Link href={`/${locale}/dashboard/curriculum`} className="text-sm text-gray-500 hover:text-brand-navy">
          ← Back to Curriculum
        </Link>
      </div>

      <LessonViewer
        lesson={lesson}
        progress={progress}
        studentId={studentId}
        studentLevel={student?.level ?? 'explorers'}
        studentAge={student?.age ?? 10}
        locale={locale}
      />
    </div>
  )
}
