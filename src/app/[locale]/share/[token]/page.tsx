import { createServiceClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'

export default async function SharePage({
  params,
}: {
  params: Promise<{ locale: string; token: string }>
}) {
  const { locale, token } = await params
  const supabase = await createServiceClient()

  const { data: rows } = await supabase.rpc('resolve_share_token', { p_token: token })
  const resolved = Array.isArray(rows) ? rows[0] : rows
  if (!resolved?.token_type || !resolved?.target_id) notFound()

  const type = resolved.token_type as string
  const targetId = resolved.target_id as string

  let studentName = 'A student'
  let title = 'Shared content'
  let level = 'explorers'
  let issuedAt: string | null = null
  let codePreview: string | null = null

  if (type === 'certificate') {
    const { data: cert } = await supabase
      .from('certificates')
      .select('level, issued_at, student_profiles(full_name)')
      .eq('id', targetId)
      .single()
    if (cert) {
      level = cert.level
      issuedAt = cert.issued_at
      const sp = Array.isArray(cert.student_profiles) ? cert.student_profiles[0] : cert.student_profiles
      studentName = sp?.full_name ?? studentName
      title = `${level} certificate`
    }
  } else if (type === 'project') {
    const { data: sub } = await supabase
      .from('project_submissions')
      .select('code_snapshot, student_profiles(full_name), projects(title)')
      .eq('id', targetId)
      .single()
    if (sub) {
      codePreview = sub.code_snapshot
      const sp = Array.isArray(sub.student_profiles) ? sub.student_profiles[0] : sub.student_profiles
      studentName = sp?.full_name ?? studentName
      const proj = Array.isArray(sub.projects) ? sub.projects[0] : sub.projects
      title = proj?.title ?? 'Project'
    }
  }

  const levelColors: Record<string, string> = {
    explorers: 'from-green-400 to-emerald-600',
    builders: 'from-blue-400 to-indigo-600',
    developers: 'from-purple-400 to-violet-600',
    engineers: 'from-orange-400 to-red-600',
  }

  return (
    <main className="min-h-screen bg-brand-light flex items-center justify-center p-4">
      <div className="card max-w-lg w-full overflow-hidden">
        {type === 'certificate' ? (
          <>
            <div
              className={`bg-gradient-to-br ${levelColors[level] || 'from-gray-400 to-gray-600'} p-10 text-white text-center`}
            >
              <div className="text-6xl mb-4">🎓</div>
              <p className="text-sm font-semibold uppercase tracking-widest opacity-80">
                Certificate of completion
              </p>
              <p className="text-3xl font-bold mt-2 capitalize">{level} level</p>
              <p className="text-xl mt-2 opacity-90">CODEship Academy</p>
              <p className="text-base mt-4 opacity-80">Awarded to {studentName}</p>
            </div>
            <div className="p-6 text-center">
              {issuedAt && (
                <p className="text-sm text-gray-500 mb-4">
                  Issued {new Date(issuedAt).toLocaleDateString('en-CA', { dateStyle: 'long' })}
                </p>
              )}
              <Link href={`/${locale}/signup`} className="btn-primary">
                Join CODEship Academy
              </Link>
            </div>
          </>
        ) : (
          <div className="p-6">
            <h1 className="text-xl font-bold text-brand-navy mb-2">{studentName}&apos;s {title}</h1>
            {codePreview && (
              <iframe
                sandbox="allow-scripts"
                srcDoc={codePreview}
                title="Project preview"
                className="w-full h-64 rounded-xl border mb-4 bg-white"
              />
            )}
            <div className="text-center">
              <Link href={`/${locale}/signup`} className="btn-primary">
                Build your own projects
              </Link>
            </div>
          </div>
        )}
      </div>
    </main>
  )
}
