import { createServiceClient } from '@/lib/supabase/server'

export async function checkRateLimit(
  userId: string,
  action: string,
  limit: number,
  windowSeconds: number
): Promise<{ allowed: boolean }> {
  const supabase = await createServiceClient()
  const windowStart = new Date(Date.now() - windowSeconds * 1000).toISOString()

  const { count } = await supabase
    .from('rate_limit_log')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .eq('action', action)
    .gte('created_at', windowStart)

  if ((count ?? 0) >= limit) {
    return { allowed: false }
  }

  await supabase.from('rate_limit_log').insert({ user_id: userId, action })
  return { allowed: true }
}
