import { createClient } from '@/lib/supabase/server'
import { requireAuth } from '@/lib/utils/auth'

export default async function NotificationsPage() {
  const supabase = await createClient()
  const user = await requireAuth(supabase)

  const { data: notifications } = await supabase
    .from('audit_logs')
    .select('id, action, created_at, metadata')
    .eq('user_id', user.id)
    .in('action', ['achievement_earned', 'level_completed', 'quiz_passed', 'certificate_issued'])
    .order('created_at', { ascending: false })
    .limit(50)

  const iconMap: Record<string, string> = {
    achievement_earned: '🏆',
    level_completed: '🎉',
    quiz_passed: '✅',
    certificate_issued: '🎓',
  }

  const labelMap: Record<string, string> = {
    achievement_earned: 'Achievement Earned',
    level_completed: 'Level Completed',
    quiz_passed: 'Quiz Passed',
    certificate_issued: 'Certificate Issued',
  }

  return (
    <div className="max-w-2xl space-y-4">
      <h1 className="text-2xl font-bold text-gray-900">Notifications</h1>

      {(!notifications || notifications.length === 0) ? (
        <div className="card p-12 text-center">
          <div className="text-5xl mb-4">🔔</div>
          <p className="text-gray-500">No notifications yet. Keep learning to earn achievements!</p>
        </div>
      ) : (
        <div className="space-y-3">
          {notifications.map((n: any) => (
            <div key={n.id} className="card p-4 flex items-start gap-4">
              <span className="text-2xl">{iconMap[n.action] || '📌'}</span>
              <div className="flex-1">
                <p className="font-semibold text-gray-900">{labelMap[n.action] || n.action}</p>
                {n.metadata && typeof n.metadata === 'object' && (
                  <p className="text-sm text-gray-600 mt-0.5">
                    {(n.metadata as any).title || (n.metadata as any).message || ''}
                  </p>
                )}
                <p className="text-xs text-gray-400 mt-1">
                  {new Date(n.created_at).toLocaleString('en-CA', {
                    dateStyle: 'medium',
                    timeStyle: 'short',
                  })}
                </p>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
