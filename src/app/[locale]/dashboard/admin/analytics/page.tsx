import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'

export default async function AnalyticsPage() {
  const supabase = await createClient()
  await requireRole(supabase, 'admin')

  const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString()

  const [newUsersRes, completionsRes, quizPassRes, plansRes] = await Promise.all([
    supabase.from('profiles').select('created_at, role').gte('created_at', thirtyDaysAgo),
    supabase.from('lesson_progress').select('completed_at, lessons(level)').eq('status', 'completed').gte('completed_at', thirtyDaysAgo),
    supabase.from('quiz_attempts').select('passed, quizzes(level)').eq('passed', true).gte('completed_at', thirtyDaysAgo),
    supabase.from('profiles').select('subscription_plan').neq('subscription_plan', 'free').eq('subscription_status', 'active'),
  ])

  const newUsers = newUsersRes.data || []
  const completions = completionsRes.data || []
  const quizPasses = quizPassRes.data || []
  const activePlans = plansRes.data || []

  const planBreakdown: Record<string, number> = {}
  activePlans.forEach((p: any) => {
    planBreakdown[p.subscription_plan] = (planBreakdown[p.subscription_plan] || 0) + 1
  })

  const levelCompletions: Record<string, number> = {}
  completions.forEach((c: any) => {
    const level = (c.lessons as any)?.level || 'unknown'
    levelCompletions[level] = (levelCompletions[level] || 0) + 1
  })

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Analytics</h1>
        <p className="text-sm text-gray-500 mt-1">Last 30 days</p>
      </div>

      {/* KPIs */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="card p-5 text-center">
          <p className="text-3xl font-bold text-brand-navy">{newUsers.length}</p>
          <p className="text-sm text-gray-500 mt-1">New Users</p>
          <p className="text-xs text-gray-400">{newUsers.filter((u: any) => u.role === 'student').length} students</p>
        </div>
        <div className="card p-5 text-center">
          <p className="text-3xl font-bold text-green-600">{completions.length}</p>
          <p className="text-sm text-gray-500 mt-1">Lessons Completed</p>
        </div>
        <div className="card p-5 text-center">
          <p className="text-3xl font-bold text-brand-gold">{quizPasses.length}</p>
          <p className="text-sm text-gray-500 mt-1">Quizzes Passed</p>
        </div>
        <div className="card p-5 text-center">
          <p className="text-3xl font-bold text-purple-600">{activePlans.length}</p>
          <p className="text-sm text-gray-500 mt-1">Active Subscriptions</p>
        </div>
      </div>

      {/* Subscription breakdown */}
      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Active Subscription Plans</h2>
        <div className="space-y-3">
          {Object.entries(planBreakdown).map(([plan, count]) => (
            <div key={plan} className="flex items-center gap-3">
              <span className="text-sm font-medium text-gray-700 w-24 capitalize">{plan}</span>
              <div className="flex-1 bg-gray-100 rounded-full h-4 overflow-hidden">
                <div
                  className="h-4 bg-brand-navy rounded-full"
                  style={{ width: `${(count / activePlans.length) * 100}%` }}
                />
              </div>
              <span className="text-sm font-bold text-gray-900 w-8 text-right">{count}</span>
            </div>
          ))}
          {Object.keys(planBreakdown).length === 0 && (
            <p className="text-gray-500 text-sm">No active subscriptions yet.</p>
          )}
        </div>
      </section>

      {/* Lesson completions by level */}
      <section className="card p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Lesson Completions by Level</h2>
        <div className="space-y-3">
          {Object.entries(levelCompletions).map(([level, count]) => (
            <div key={level} className="flex items-center gap-3">
              <span className="text-sm font-medium text-gray-700 w-24 capitalize">{level}</span>
              <div className="flex-1 bg-gray-100 rounded-full h-4 overflow-hidden">
                <div
                  className="h-4 bg-brand-gold rounded-full"
                  style={{ width: completions.length > 0 ? `${(count / completions.length) * 100}%` : '0%' }}
                />
              </div>
              <span className="text-sm font-bold text-gray-900 w-8 text-right">{count}</span>
            </div>
          ))}
          {Object.keys(levelCompletions).length === 0 && (
            <p className="text-gray-500 text-sm">No lesson completions in the last 30 days.</p>
          )}
        </div>
      </section>
    </div>
  )
}
