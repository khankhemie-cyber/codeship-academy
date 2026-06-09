import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import Link from 'next/link'

export default async function AdminDashboardPage({ params }: { params: { locale: string } }) {
  const supabase = await createClient()
  await requireRole(supabase, 'admin')

  const [usersRes, subscriptionsRes, studentsRes, recentAuditRes] = await Promise.all([
    supabase.from('users').select('role', { count: 'exact', head: true }),
    supabase.from('subscriptions').select('plan, status'),
    supabase.from('student_profiles').select('id', { count: 'exact', head: true }),
    supabase.from('audit_logs').select('action, created_at, user_id').order('created_at', { ascending: false }).limit(20),
  ])

  const { count: totalUsers } = usersRes
  const { count: students } = studentsRes
  const roleCounts = await supabase.from('users').select('role')
  const users = roleCounts.data || []
  const parents = users.filter((u) => u.role === 'parent').length
  const teachers = users.filter((u) => u.role === 'teacher').length
  const subs = subscriptionsRes.data || []
  const activeSubscriptions = subs.filter((s) => s.status === 'active').length
  const trialing = subs.filter((s) => s.status === 'trial').length

  const adminCards = [
    { title: 'Total Users', value: totalUsers ?? 0, color: 'text-brand-navy', icon: '👥' },
    { title: 'Student Profiles', value: students ?? 0, color: 'text-green-600', icon: '🎓' },
    { title: 'Parents', value: parents, color: 'text-blue-600', icon: '👨‍👩‍👧' },
    { title: 'Teachers', value: teachers, color: 'text-purple-600', icon: '👩‍🏫' },
    { title: 'Active Subscriptions', value: activeSubscriptions, color: 'text-brand-gold', icon: '💳' },
    { title: 'Trials', value: trialing, color: 'text-orange-500', icon: '⏱️' },
  ]

  const quickLinks = [
    { href: 'admin/users', label: '👥 Manage Users' },
    { href: 'admin/subscriptions', label: '💳 Subscriptions' },
    { href: 'admin/analytics', label: '📊 Analytics' },
    { href: 'admin/audit-log', label: '📋 Audit Log' },
    { href: 'admin/curriculum', label: '📚 Curriculum CMS' },
  ]

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Admin Dashboard</h1>
        <p className="text-gray-500 mt-1">CODEship Academy platform overview</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
        {adminCards.map(card => (
          <div key={card.title} className="card p-4 text-center">
            <div className="text-3xl mb-2">{card.icon}</div>
            <p className={`text-2xl font-bold ${card.color}`}>{card.value.toLocaleString()}</p>
            <p className="text-xs text-gray-500 mt-1">{card.title}</p>
          </div>
        ))}
      </div>

      {/* Quick links */}
      <div>
        <h2 className="text-lg font-semibold text-gray-900 mb-3">Admin Tools</h2>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3">
          {quickLinks.map(link => (
            <Link
              key={link.href}
              href={`/${params.locale}/dashboard/${link.href}`}
              className="card p-4 text-center hover:border-brand-navy hover:shadow-md transition-all"
            >
              <p className="font-medium text-gray-800 text-sm">{link.label}</p>
            </Link>
          ))}
        </div>
      </div>

      {/* Recent activity */}
      <div>
        <h2 className="text-lg font-semibold text-gray-900 mb-3">Recent Activity</h2>
        <div className="card overflow-hidden">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Action</th>
                <th className="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Time</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {(recentAuditRes.data || []).map((log: any, i: number) => (
                <tr key={i}>
                  <td className="px-4 py-3">
                    <span className="font-mono text-sm text-gray-700">{log.action}</span>
                  </td>
                  <td className="px-4 py-3 text-right text-xs text-gray-400">
                    {new Date(log.created_at).toLocaleString('en-CA', { dateStyle: 'short', timeStyle: 'short' })}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
