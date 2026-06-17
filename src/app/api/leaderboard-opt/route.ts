import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function POST(req: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const form = await req.formData().catch(() => null)
  const optOut = form?.get('opt_out') === 'true'

  await supabase
    .from('profiles')
    .update({ leaderboard_opt_out: optOut })
    .eq('user_id', user.id)

  const origin = req.headers.get('origin') || process.env.NEXT_PUBLIC_APP_URL || ''
  const referer = req.headers.get('referer')
  const dest = referer || `${origin}/en/dashboard/leaderboard`
  return NextResponse.redirect(dest, 303)
}
