import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { getTranslations } from 'next-intl/server'
import Link from 'next/link'

export default async function CertificatesPage({ params }: { params: { locale: string } }) {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'student')
  const t = await getTranslations('nav')

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, display_name')
    .eq('user_id', user.id)
    .single()

  const { data: certificates } = await supabase
    .from('certificates')
    .select('*')
    .eq('student_id', profile!.id)
    .order('issued_at', { ascending: false })

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
      <h1 className="text-2xl font-bold text-gray-900">{t('certificates')}</h1>

      {(!certificates || certificates.length === 0) ? (
        <div className="card p-12 text-center">
          <div className="text-6xl mb-4">🎓</div>
          <h2 className="text-xl font-semibold text-gray-700 mb-2">No certificates yet</h2>
          <p className="text-gray-500 mb-6">Complete all lessons in a level to earn your certificate!</p>
          <Link href={`/${params.locale}/dashboard/curriculum`} className="btn-primary">
            Start Learning
          </Link>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {certificates.map((cert: any) => (
            <div key={cert.id} className="card overflow-hidden">
              {/* Certificate visual */}
              <div className={`bg-gradient-to-br ${levelColors[cert.level] || 'from-gray-400 to-gray-600'} p-8 text-white text-center`}>
                <div className="text-5xl mb-3">🎓</div>
                <p className="text-sm font-semibold uppercase tracking-widest opacity-80">Certificate of Completion</p>
                <p className="text-2xl font-bold mt-2">{levelLabels[cert.level] || cert.level} Level</p>
                <p className="text-lg mt-1 opacity-90">CODEship Academy</p>
                <p className="text-sm mt-3 opacity-75">
                  Awarded to {profile?.display_name || 'Student'}
                </p>
              </div>
              <div className="p-4 flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-500">
                    Issued: {new Date(cert.issued_at).toLocaleDateString('en-CA', { year: 'numeric', month: 'long', day: 'numeric' })}
                  </p>
                  {cert.share_url && (
                    <p className="text-xs text-gray-400 mt-1">ID: {cert.id.slice(0, 8).toUpperCase()}</p>
                  )}
                </div>
                <div className="flex gap-2">
                  {cert.share_url && (
                    <a
                      href={cert.share_url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="btn-secondary text-sm py-1 px-3"
                    >
                      Share
                    </a>
                  )}
                  <a
                    href={`/api/certificates/${cert.id}/pdf`}
                    className="btn-primary text-sm py-1 px-3"
                  >
                    Download
                  </a>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      <div className="card p-4 bg-brand-navy/5 border border-brand-navy/20">
        <h3 className="font-semibold text-gray-800 mb-2">How to earn certificates</h3>
        <ul className="text-sm text-gray-600 space-y-1">
          <li>✓ Complete all lessons in a level</li>
          <li>✓ Score 70%+ on the level final quiz</li>
          <li>✓ Submit at least 3 projects for review</li>
        </ul>
      </div>
    </div>
  )
}
