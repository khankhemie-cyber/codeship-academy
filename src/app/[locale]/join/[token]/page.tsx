import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { resolveStudentId } from '@/lib/student-session'

export default async function JoinClassPage({
  params,
}: {
  params: Promise<{ locale: string; token: string }>
}) {
  const { locale, token } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  const { data: invite } = await supabase
    .from('class_invites')
    .select('id, class_id, max_uses, use_count, expires_at, classes(name, grade)')
    .eq('token', token)
    .single()

  const isExpired = invite?.expires_at && new Date(invite.expires_at) <= new Date()
  const isExhausted = invite && invite.use_count >= invite.max_uses
  const isValid = invite && !isExpired && !isExhausted

  if (!isValid) {
    return (
      <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
        <div className="card max-w-md w-full p-8 text-center">
          <div className="text-5xl mb-4">❌</div>
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Invalid invite</h1>
          <p className="text-gray-600 mb-6">
            This invite has expired or reached its use limit. Ask your teacher for a new link.
          </p>
          <Link href={`/${locale}`} className="btn-primary">
            Go home
          </Link>
        </div>
      </main>
    )
  }

  const cls = Array.isArray(invite.classes) ? invite.classes[0] : invite.classes

  if (user) {
    const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
    const studentId = appUser
      ? await resolveStudentId(supabase, user.id, appUser.role)
      : null

    if (studentId) {
      const { error } = await supabase.rpc('join_class_by_token', {
        p_token: token,
        p_student_id: studentId,
      })
      if (!error) redirect(`/${locale}/dashboard/student`)
    }
  }

  return (
    <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="card max-w-md w-full p-8 text-center">
        <div className="text-5xl mb-4">🏫</div>
        <h1 className="text-2xl font-bold text-gray-900 mb-2">You&apos;ve been invited</h1>
        <p className="text-gray-600 mb-2">
          Join <strong>{cls?.name ?? 'a class'}</strong>
          {cls?.grade ? ` (Grade ${cls.grade})` : ''}
        </p>
        <p className="text-sm text-gray-500 mb-8">Sign in as a parent and add or select your child to accept.</p>
        <div className="flex gap-3 justify-center">
          <Link href={`/${locale}/signup?invite=${token}`} className="btn-primary flex-1">
            Sign up
          </Link>
          <Link href={`/${locale}/login?invite=${token}`} className="btn-secondary flex-1">
            Log in
          </Link>
        </div>
      </div>
    </main>
  )
}
