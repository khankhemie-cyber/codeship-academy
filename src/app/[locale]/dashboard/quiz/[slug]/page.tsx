import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { notFound } from 'next/navigation'
import QuizPlayer from '@/components/student/QuizPlayer'

export default async function QuizPage({ params }: { params: { locale: string; slug: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student')

  const { data: quiz } = await supabase
    .from('quizzes')
    .select('*')
    .eq('slug', params.slug)
    .single()

  if (!quiz) notFound()

  const { data: questions } = await supabase
    .from('quiz_questions')
    .select('id, question, options, points, sort_order')
    .eq('quiz_id', quiz.id)
    .order('sort_order', { ascending: true })

  const { data: profile } = await supabase
    .from('profiles')
    .select('id')
    .eq('user_id', user.id)
    .single()

  // Check for existing incomplete attempt
  const { data: existingAttempt } = await supabase
    .from('quiz_attempts')
    .select('id, answers, started_at')
    .eq('quiz_id', quiz.id)
    .eq('student_id', profile!.id)
    .is('completed_at', null)
    .order('started_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  // Check best score
  const { data: bestAttempt } = await supabase
    .from('quiz_attempts')
    .select('score, passed')
    .eq('quiz_id', quiz.id)
    .eq('student_id', profile!.id)
    .not('completed_at', 'is', null)
    .order('score', { ascending: false })
    .limit(1)
    .maybeSingle()

  return (
    <QuizPlayer
      quiz={quiz}
      questions={questions || []}
      studentId={profile!.id}
      existingAttemptId={existingAttempt?.id}
      existingAnswers={existingAttempt?.answers as number[] | null}
      bestScore={bestAttempt?.score ?? null}
      bestPassed={bestAttempt?.passed ?? null}
      locale={params.locale}
    />
  )
}
