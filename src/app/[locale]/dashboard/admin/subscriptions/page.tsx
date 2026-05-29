import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function AdminSubscriptionsPage({
  params,
}: {
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params
  const supabase = await createClient()
  await requireRole(supabase, 'admin', locale)

  const { data: subs } = await supabase
    .from('subscriptions')
    .select('*, users(email, full_name)')
    .order('updated_at', { ascending: false })
    .limit(100)

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Subscriptions</h1>
      <div className="card overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-4 py-3 text-left">User</th>
              <th className="px-4 py-3 text-left">Plan</th>
              <th className="px-4 py-3 text-left">Status</th>
              <th className="px-4 py-3 text-right">Period end</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {(subs || []).map((s) => {
              const u = Array.isArray(s.users) ? s.users[0] : s.users
              return (
                <tr key={s.id}>
                  <td className="px-4 py-3">{u?.full_name || u?.email || s.user_id}</td>
                  <td className="px-4 py-3 capitalize">{s.plan}</td>
                  <td className="px-4 py-3 capitalize">{s.status}</td>
                  <td className="px-4 py-3 text-right text-gray-500">
                    {s.current_period_end
                      ? new Date(s.current_period_end).toLocaleDateString('en-CA')
                      : '—'}
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  )
}
