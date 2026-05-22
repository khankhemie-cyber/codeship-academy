import { NextRequest, NextResponse } from 'next/server'
import { createServiceClient } from '@/lib/supabase/server'
import { jwtVerify } from 'jose'
import { UNSUBSCRIBE_SECRET } from '@/lib/utils/unsubscribe-token'

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const token = searchParams.get('token')
  const type = searchParams.get('type')

  if (!token || !type) {
    return NextResponse.redirect(new URL('/en/unsubscribed?error=invalid', request.url))
  }

  try {
    const { payload } = await jwtVerify(token, UNSUBSCRIBE_SECRET)
    const { userId, consentType } = payload as { userId: string; consentType: string }

    if (consentType !== type) {
      return NextResponse.redirect(new URL('/en/unsubscribed?error=mismatch', request.url))
    }

    const supabase = await createServiceClient()

    await supabase
      .from('email_consents')
      .update({
        withdrawn_at: new Date().toISOString(),
        withdrawn_method: 'unsubscribe_link',
      })
      .eq('user_id', userId)
      .eq('consent_type', type as any)
      .is('withdrawn_at', null)

    await supabase.from('audit_logs').insert({
      user_id: userId,
      action: 'email_unsubscribe',
      metadata: { consent_type: type, method: 'unsubscribe_link' },
    })

    return NextResponse.redirect(new URL(`/en/unsubscribed?type=${encodeURIComponent(type)}`, request.url))
  } catch {
    return NextResponse.redirect(new URL('/en/unsubscribed?error=expired', request.url))
  }
}
