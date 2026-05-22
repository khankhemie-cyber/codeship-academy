import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'

export default async function SharePage({ params }: { params: { locale: string; token: string } }) {
  const supabase = await createClient()

  const { data: shareToken } = await supabase
    .from('share_tokens')
    .select('*, profiles!share_tokens_student_id_fkey(display_name)')
    .eq('token', params.token)
    .eq('is_active', true)
    .single()

  if (!shareToken) notFound()

  const isExpired = shareToken.expires_at && new Date(shareToken.expires_at) < new Date()
  if (isExpired) {
    return (
      <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
        <div className="card max-w-md w-full p-8 text-center">
          <div className="text-5xl mb-4">⏱️</div>
          <h1 className="text-xl font-bold text-gray-900 mb-2">This link has expired</h1>
          <p className="text-gray-600">Ask the student to share it again from their dashboard.</p>
        </div>
      </main>
    )
  }

  const studentName = (shareToken.profiles as any)?.display_name || 'A student'

  const levelColors: Record<string, string> = {
    explorers: 'from-green-400 to-emerald-600',
    builders: 'from-blue-400 to-indigo-600',
    developers: 'from-purple-400 to-violet-600',
    engineers: 'from-orange-400 to-red-600',
  }

  return (
    <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="card max-w-lg w-full overflow-hidden">
        {shareToken.resource_type === 'certificate' ? (
          <>
            <div className={`bg-gradient-to-br ${levelColors[shareToken.metadata?.level] || 'from-gray-400 to-gray-600'} p-10 text-white text-center`}>
              <div className="text-6xl mb-4">🎓</div>
              <p className="text-sm font-semibold uppercase tracking-widest opacity-80">Certificate of Completion</p>
              <p className="text-3xl font-bold mt-2 capitalize">{shareToken.metadata?.level} Level</p>
              <p className="text-xl mt-2 opacity-90">CODEship Academy</p>
              <p className="text-base mt-4 opacity-80">Awarded to {studentName}</p>
            </div>
            <div className="p-6 text-center">
              <p className="text-sm text-gray-500 mb-2">
                Issued {shareToken.metadata?.issued_at ? new Date(shareToken.metadata.issued_at).toLocaleDateString('en-CA', { dateStyle: 'long' }) : ''}
              </p>
              <p className="text-xs text-gray-400 mb-4">Certificate ID: {shareToken.token.slice(0, 12).toUpperCase()}</p>
              <Link href={`/${params.locale}/signup`} className="btn-primary">
                Join CODEship Academy
              </Link>
            </div>
          </>
        ) : (
          <div className="p-8 text-center">
            <div className="text-5xl mb-4">📂</div>
            <h1 className="text-xl font-bold text-gray-900 mb-2">{studentName}&apos;s Project</h1>
            <p className="text-gray-500 mb-6">This project was created on CODEship Academy.</p>
            <Link href={`/${params.locale}/signup`} className="btn-primary">
              Build Your Own Projects
            </Link>
          </div>
        )}
      </div>
    </main>
  )
}
