import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { resolveStudentId } from '@/lib/student-session'

export default async function CertificatesPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: appUser } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!appUser || !['parent', 'admin'].includes(appUser.role)) redirect(`/${locale}/dashboard`)

  const studentId = await resolveStudentId(supabase, user.id, appUser.role)
  if (!studentId) redirect(`/${locale}/dashboard/parent/children`)

  const { data: student } = await supabase
    .from('student_profiles')
    .select('full_name')
    .eq('id', studentId)
    .single()

  const { data: certificates } = await supabase
    .from('certificates')
    .select('*')
    .eq('student_id', studentId)
    .order('issued_at', { ascending: false })

  const appUrl = process.env.NEXT_PUBLIC_APP_URL ?? 'https://app.codeshipacademy.com'
  const levelLabels: Record<string, string> = {
    explorers: 'Explorers',
    builders: 'Builders',
    developers: 'Developers',
    engineers: 'Engineers',
  }
  const levelColors: Record<string, string> = {
    explorers: 'from-green-400 to-emerald-600',
    builders: 'from-blue-400 to-indigo-600',
    developers: 'from-purple-400 to-violet-600',
    engineers: 'from-orange-400 to-red-600',
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Certificates</h1>

      {!certificates?.length ? (
        <div className="card p-12 text-center">
          <div className="text-6xl mb-4">🎓</div>
          <h2 className="text-xl font-semibold text-gray-700 mb-2">No certificates yet</h2>
          <p className="text-gray-500 mb-6">Complete a level to earn a shareable certificate.</p>
          <Link href={`/${locale}/dashboard/curriculum`} className="btn-primary">
            Start learning
          </Link>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {certificates.map((cert) => (
            <div key={cert.id} className="card overflow-hidden">
              <div
                className={`bg-gradient-to-br ${levelColors[cert.level] || 'from-gray-400 to-gray-600'} p-8 text-white text-center`}
              >
                <div className="text-5xl mb-3">🎓</div>
                <p className="text-sm font-semibold uppercase tracking-widest opacity-80">
                  Certificate of completion
                </p>
                <p className="text-2xl font-bold mt-2">{levelLabels[cert.level] || cert.level}</p>
                <p className="text-sm mt-3 opacity-75">Awarded to {student?.full_name}</p>
              </div>
              <div className="p-4 flex items-center justify-between flex-wrap gap-2">
                <p className="text-sm text-gray-500">
                  {new Date(cert.issued_at).toLocaleDateString('en-CA', { dateStyle: 'long' })}
                </p>
                <div className="flex gap-2">
                  {cert.share_token && (
                    <a
                      href={`${appUrl}/${locale}/share/${cert.share_token}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="btn-secondary text-sm py-1 px-3"
                    >
                      Share
                    </a>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
