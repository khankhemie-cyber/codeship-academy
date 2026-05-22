import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'

export default async function JoinClassPage({
  params,
}: {
  params: { locale: string; token: string }
}) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  // Look up the invite
  const { data: invite } = await supabase
    .from('class_invites')
    .select('id, class_id, email, expires_at, used_at, classes(name, grade)')
    .eq('token', params.token)
    .single()

  const isValid = invite && !invite.used_at && new Date(invite.expires_at) > new Date()

  if (!isValid) {
    return (
      <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
        <div className="card max-w-md w-full p-8 text-center">
          <div className="text-5xl mb-4">❌</div>
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Invalid Invite</h1>
          <p className="text-gray-600 mb-6">
            This invite link has expired or has already been used.
            Please ask your teacher for a new invite.
          </p>
          <Link href={`/${params.locale}`} className="btn-primary">Go Home</Link>
        </div>
      </main>
    )
  }

  const cls = invite.classes as any

  // If user is logged in, try to join automatically
  if (user) {
    const { error } = await supabase.rpc('join_class_by_token', { p_token: params.token })
    if (!error) {
      redirect(`/${params.locale}/dashboard/student`)
    }
  }

  return (
    <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="card max-w-md w-full p-8 text-center">
        <div className="text-5xl mb-4">🏫</div>
        <h1 className="text-2xl font-bold text-gray-900 mb-2">You've been invited!</h1>
        <p className="text-gray-600 mb-2">
          Join <strong>{cls?.name || 'a class'}</strong>
          {cls?.grade ? ` (Grade ${cls.grade})` : ''}
        </p>
        <p className="text-sm text-gray-500 mb-8">
          Sign up or log in to accept this invitation.
        </p>
        <div className="flex gap-3 justify-center">
          <Link href={`/${params.locale}/signup?invite=${params.token}`} className="btn-primary flex-1">
            Sign Up
          </Link>
          <Link href={`/${params.locale}/login?invite=${params.token}`} className="btn-secondary flex-1">
            Log In
          </Link>
        </div>
        <p className="text-xs text-gray-400 mt-6">
          This invite expires {new Date(invite.expires_at).toLocaleDateString('en-CA', { dateStyle: 'medium' })}.
        </p>
      </div>
    </main>
  )
}
