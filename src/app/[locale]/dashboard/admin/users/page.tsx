import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function AdminUsersPage({
  searchParams,
}: {
  searchParams: { role?: string; q?: string; page?: string }
}) {
  const supabase = await createClient()
  await requireRole(supabase, 'admin')

  const page = parseInt(searchParams.page || '1')
  const perPage = 25
  const offset = (page - 1) * perPage

  let query = supabase
    .from('profiles')
    .select('id, user_id, display_name, role, level, subscription_plan, subscription_status, created_at, deletion_requested_at', { count: 'exact' })
    .order('created_at', { ascending: false })
    .range(offset, offset + perPage - 1)

  if (searchParams.role) query = query.eq('role', searchParams.role)
  if (searchParams.q) query = query.ilike('display_name', `%${searchParams.q}%`)

  const { data: users, count } = await query
  const totalPages = Math.ceil((count || 0) / perPage)

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Users</h1>

      {/* Filters */}
      <form method="GET" className="flex gap-3">
        <input
          type="text"
          name="q"
          defaultValue={searchParams.q}
          placeholder="Search by name…"
          className="input w-64"
        />
        <select name="role" defaultValue={searchParams.role} className="input w-40">
          <option value="">All roles</option>
          <option value="parent">Parents</option>
          <option value="teacher">Teachers</option>
          <option value="student">Students</option>
          <option value="admin">Admins</option>
        </select>
        <button type="submit" className="btn-primary">Search</button>
        <a href="?" className="btn-secondary">Reset</a>
      </form>

      <div className="card overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Name</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Role</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Plan</th>
              <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Status</th>
              <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Joined</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {(users || []).map((u: any) => (
              <tr key={u.id} className={u.deletion_requested_at ? 'bg-red-50' : ''}>
                <td className="px-4 py-3">
                  <span className="font-medium text-gray-900">{u.display_name || '—'}</span>
                  {u.deletion_requested_at && <span className="ml-2 text-xs text-red-500">⚠️ Deletion requested</span>}
                </td>
                <td className="px-4 py-3">
                  <span className="badge badge-gray capitalize">{u.role}</span>
                </td>
                <td className="px-4 py-3 text-sm text-gray-500 capitalize">{u.subscription_plan || 'free'}</td>
                <td className="px-4 py-3">
                  <span className={`badge ${u.subscription_status === 'active' ? 'badge-green' : u.subscription_status === 'trialing' ? 'badge-blue' : 'badge-gray'} capitalize`}>
                    {u.subscription_status || 'none'}
                  </span>
                </td>
                <td className="px-4 py-3 text-right text-sm text-gray-500">
                  {new Date(u.created_at).toLocaleDateString('en-CA')}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-between">
          <p className="text-sm text-gray-500">
            Showing {offset + 1}–{Math.min(offset + perPage, count || 0)} of {count?.toLocaleString()} users
          </p>
          <div className="flex gap-2">
            {page > 1 && (
              <a href={`?page=${page - 1}${searchParams.role ? `&role=${searchParams.role}` : ''}${searchParams.q ? `&q=${searchParams.q}` : ''}`} className="btn-secondary text-sm py-1 px-3">
                ← Previous
              </a>
            )}
            {page < totalPages && (
              <a href={`?page=${page + 1}${searchParams.role ? `&role=${searchParams.role}` : ''}${searchParams.q ? `&q=${searchParams.q}` : ''}`} className="btn-secondary text-sm py-1 px-3">
                Next →
              </a>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
