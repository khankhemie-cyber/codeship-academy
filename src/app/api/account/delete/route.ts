import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { requireAuth } from '@/lib/utils/auth'

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const user = await requireAuth(supabase).catch(() => null)
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  // Schedule deletion — soft delete with 30-day grace period
  const deletionDate = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString()

  await supabase
    .from('profiles')
    .update({ deletion_requested_at: deletionDate })
    .eq('user_id', user.id)

  await supabase.from('audit_logs').insert({
    user_id: user.id,
    action: 'deletion_requested',
    metadata: {
      scheduled_deletion: deletionDate,
      ip: req.headers.get('x-forwarded-for') || 'unknown',
    },
  })

  return NextResponse.json({ ok: true, scheduled_deletion: deletionDate })
}
