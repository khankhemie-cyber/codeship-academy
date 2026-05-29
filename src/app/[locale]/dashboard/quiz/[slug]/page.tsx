import { createClient } from '@/lib/supabase/server'
import { redirect, notFound } from 'next/navigation'
import QuizPlayer from '@/components/student/QuizPlayer'
import { resolveStudentId } from '@/lib/student-session'

export default async function QuizPage({
  params,
}: {
  params: Promise<{ locale: string; slug: string }>
}) {
  const { locale, slug } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || !['parent', 'admin'].includes(appUser.role)) {
    redirect(`/${locale}/dashboard`)
  }

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) redirect(`/${locale}/dashboard/parent/children`)

  const { data: quiz } = await supabase.from('quizzes').select('*').eq('slug', slug).single()
  if (!quiz) notFound()

  const { data: questions } = await supabase
    .from('quiz_questions')
    .select('id, question, options, points, sort_order')
    .eq('quiz_id', quiz.id)
    .order('sort_order', { ascending: true })

  const { data: existingAttempt } = await supabase
    .from('quiz_attempts')
    .select('id, answers')
    .eq('quiz_id', quiz.id)
    .eq('student_id', studentId)
    .is('completed_at', null)
    .order('created_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  const { data: bestAttempt } = await supabase
    .from('quiz_attempts')
    .select('score, passed')
    .eq('quiz_id', quiz.id)
    .eq('student_id', studentId)
    .not('completed_at', 'is', null)
    .order('score', { ascending: false })
    .limit(1)
    .maybeSingle()

  return (
    <QuizPlayer
      quiz={quiz}
      questions={questions || []}
      studentId={studentId}
      existingAttemptId={existingAttempt?.id}
      existingAnswers={existingAttempt?.answers as number[] | null}
      bestScore={bestAttempt?.score ?? null}
      bestPassed={bestAttempt?.passed ?? null}
      locale={locale}
    />
  )
}
