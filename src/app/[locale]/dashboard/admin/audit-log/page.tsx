import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function AuditLogPage({ searchParams }: { searchParams: { page?: string; action?: string } }) {
  const supabase = await createClient()
  await requireRole(supabase, 'admin')

  const page = parseInt(searchParams.page || '1')
  const perPage = 50
  const offset = (page - 1) * perPage

  let query = supabase
    .from('audit_logs')
    .select('id, action, user_id, created_at, metadata, ip_address', { count: 'exact' })
    .order('created_at', { ascending: false })
    .range(offset, offset + perPage - 1)

  if (searchParams.action) query = query.eq('action', searchParams.action)

  const { data: logs, count } = await query
  const totalPages = Math.ceil((count || 0) / perPage)

  const sensitiveActions = ['deletion_requested', 'student_created', 'consent_withdrawn', 'login_failed']

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Audit Log</h1>
        <p className="text-sm text-gray-500 mt-1">Immutable record of all significant platform actions. Logs are never deleted.</p>
      </div>

      <form method="GET" className="flex gap-3">
        <input type="text" name="action" defaultValue={searchParams.action} placeholder="Filter by action…" className="input w-64" />
        <button type="submit" className="btn-primary">Filter</button>
        <a href="?" className="btn-secondary">Reset</a>
      </form>

      <div className="card overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Time</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Action</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">User ID</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Details</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 font-mono">
            {(logs || []).map((log: any) => (
              <tr key={log.id} className={sensitiveActions.includes(log.action) ? 'bg-orange-50' : ''}>
                <td className="px-4 py-2 text-gray-500 whitespace-nowrap">
                  {new Date(log.created_at).toISOString().replace('T', ' ').slice(0, 19)}
                </td>
                <td className="px-4 py-2">
                  <span className={`font-semibold ${sensitiveActions.includes(log.action) ? 'text-orange-700' : 'text-gray-700'}`}>
                    {log.action}
                  </span>
                </td>
                <td className="px-4 py-2 text-gray-400 text-xs">{log.user_id?.slice(0, 8) || '—'}</td>
                <td className="px-4 py-2 text-gray-500 text-xs truncate max-w-xs">
                  {log.metadata ? JSON.stringify(log.metadata).slice(0, 80) : '—'}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-between">
          <p className="text-sm text-gray-500">
            {count?.toLocaleString()} total log entries
          </p>
          <div className="flex gap-2">
            {page > 1 && <a href={`?page=${page - 1}${searchParams.action ? `&action=${searchParams.action}` : ''}`} className="btn-secondary text-sm py-1 px-3">← Previous</a>}
            {page < totalPages && <a href={`?page=${page + 1}${searchParams.action ? `&action=${searchParams.action}` : ''}`} className="btn-secondary text-sm py-1 px-3">Next →</a>}
          </div>
        </div>
      )}
    </div>
  )
}
