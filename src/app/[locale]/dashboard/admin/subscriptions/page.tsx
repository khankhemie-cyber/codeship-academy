import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function AdminSubscriptionsPage() {
  const supabase = await createClient()
  await requireRole(supabase, 'admin')

  const { data: subs } = await supabase
    .from('subscriptions')
    .select('id, user_id, plan, status, current_period_end, trial_ends_at, created_at')
    .order('created_at', { ascending: false })
    .limit(200)

  const userIds = (subs ?? []).map((s: any) => s.user_id)
  const { data: profiles } = userIds.length
    ? await supabase.from('profiles').select('user_id, display_name, email').in('user_id', userIds)
    : { data: [] as any[] }

  const nameByUser = new Map((profiles ?? []).map((p: any) => [p.user_id, p.display_name || p.email || '—']))

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Subscriptions</h1>

      <div className="card overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">User</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Plan</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Period End</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {(subs || []).map((s: any) => (
              <tr key={s.id}>
                <td className="px-4 py-3 font-medium text-gray-900">{nameByUser.get(s.user_id) ?? '—'}</td>
                <td className="px-4 py-3 text-sm text-gray-500 capitalize">{s.plan}</td>
                <td className="px-4 py-3">
                  <span className={`badge capitalize ${s.status === 'active' ? 'badge-green' : s.status === 'trial' ? 'badge-blue' : 'badge-gray'}`}>
                    {s.status}
                  </span>
                </td>
                <td className="px-4 py-3 text-right text-sm text-gray-500">
                  {s.current_period_end
                    ? new Date(s.current_period_end).toLocaleDateString('en-CA')
                    : s.trial_ends_at
                    ? `Trial ends ${new Date(s.trial_ends_at).toLocaleDateString('en-CA')}`
                    : '—'}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {(!subs || subs.length === 0) && (
          <p className="text-center text-gray-500 py-8">No subscriptions yet.</p>
        )}
      </div>
    </div>
  )
}
