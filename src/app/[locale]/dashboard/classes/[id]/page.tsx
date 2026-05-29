import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import { notFound } from 'next/navigation'
import Link from 'next/link'

export default async function ClassDetailPage({
  params,
}: {
  params: Promise<{ locale: string; id: string }>
}) {
  const { locale, id } = await params
  const supabase = await createClient()
  const user = await requireRole(supabase, ['teacher', 'admin'], locale)

  const { data: cls } = await supabase
    .from('classes')
    .select('id, name, grade, code, is_active, created_at')
    .eq('id', id)
    .eq('teacher_id', user.id)
    .single()

  if (!cls) notFound()

  const { data: memberships } = await supabase
    .from('class_memberships')
    .select('joined_at, student_profiles(id, full_name, level, xp_points, streak_days, avatar_emoji)')
    .eq('class_id', id)
    .order('joined_at', { ascending: false })

  const { data: invites } = await supabase
    .from('class_invites')
    .select('id, token, max_uses, use_count, expires_at')
    .eq('class_id', id)
    .order('created_at', { ascending: false })
    .limit(5)

  const appUrl = process.env.NEXT_PUBLIC_APP_URL ?? 'https://app.codeshipacademy.com'
  const base = `/${locale}/dashboard`

  return (
    <div className="space-y-8">
      <div>
        <Link href={`${base}/classes`} className="text-sm text-gray-500 hover:text-brand-navy">
          ← Back to classes
        </Link>
        <h1 className="text-2xl font-bold text-gray-900 mt-2">{cls.name}</h1>
        <p className="text-gray-500">
          Code: <span className="font-mono font-bold text-brand-navy">{cls.code}</span>
          {cls.grade ? ` · Grade ${cls.grade}` : ''}
        </p>
      </div>

      <section className="card p-6">
        <h2 className="text-lg font-semibold mb-4">Invite families</h2>
        <p className="text-sm text-gray-600 mb-4">
          Share the class code <strong>{cls.code}</strong> or an invite link below.
        </p>
        {invites && invites.length > 0 ? (
          <ul className="space-y-2">
            {invites.map((inv) => (
              <li key={inv.id} className="text-sm bg-gray-50 p-3 rounded-lg break-all">
                <a
                  href={`${appUrl}/${locale}/join/${inv.token}`}
                  className="text-brand-navy underline"
                >
                  {appUrl}/{locale}/join/{inv.token}
                </a>
                <span className="text-gray-500 ml-2">
                  ({inv.use_count}/{inv.max_uses} uses)
                </span>
              </li>
            ))}
          </ul>
        ) : (
          <p className="text-sm text-gray-500">No invite links yet. Create one from class settings (coming soon).</p>
        )}
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-4">Roster ({memberships?.length ?? 0})</h2>
        {!memberships?.length ? (
          <p className="text-gray-500 text-sm">No students have joined yet.</p>
        ) : (
          <div className="card overflow-hidden">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500">Student</th>
                  <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500">Level</th>
                  <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500">XP</th>
                  <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500">Streak</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {memberships.map((m) => {
                  const sp = Array.isArray(m.student_profiles)
                    ? m.student_profiles[0]
                    : m.student_profiles
                  if (!sp) return null
                  return (
                    <tr key={sp.id}>
                      <td className="px-4 py-3">
                        {sp.avatar_emoji} {sp.full_name}
                      </td>
                      <td className="px-4 py-3 capitalize text-sm">{sp.level}</td>
                      <td className="px-4 py-3 text-right">{sp.xp_points}</td>
                      <td className="px-4 py-3 text-right">🔥 {sp.streak_days}</td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </div>
  )
}
