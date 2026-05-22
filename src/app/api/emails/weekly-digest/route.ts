import { NextRequest, NextResponse } from 'next/server'
import { createServiceClient } from '@/lib/supabase/server'
import { Resend } from 'resend'

export async function GET(request: NextRequest) {
  const authHeader = request.headers.get('authorization')
  const expected = `Bearer ${process.env.CRON_SECRET}`

  if (authHeader !== expected) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const supabase = await createServiceClient()
  const resend = new Resend(process.env.RESEND_API_KEY)
  const appUrl = process.env.NEXT_PUBLIC_APP_URL ?? 'https://app.codeshipacademy.com'

  // Get all parents with weekly digest consent
  const { data: consents } = await supabase
    .from('email_consents')
    .select('user_id, users(email, full_name, locale)')
    .eq('consent_type', 'weekly_digest')
    .is('withdrawn_at', null)

  if (!consents) return NextResponse.json({ sent: 0 })

  let sentCount = 0
  const oneWeekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString()

  for (const consent of consents) {
    try {
      const userId = consent.user_id
      const userRecord = (consent as any).users

      // Get children
      const { data: students } = await supabase
        .from('student_profiles')
        .select('*')
        .eq('parent_id', userId)

      if (!students?.length) continue

      for (const student of students) {
        // XP earned this week
        const { data: weekProgress } = await supabase
          .from('lesson_progress')
          .select('lessons(title, xp_reward)')
          .eq('student_id', student.id)
          .eq('status', 'completed')
          .gte('completed_at', oneWeekAgo)

        const lessonsThisWeek = weekProgress?.map((p: any) => p.lessons?.title).filter(Boolean) ?? []
        const xpThisWeek = weekProgress?.reduce((sum: number, p: any) => sum + (p.lessons?.xp_reward ?? 0), 0) ?? 0

        const locale = userRecord?.locale ?? 'en'
        const isFr = locale === 'fr'

        const subject = isFr
          ? `Rapport hebdomadaire de ${student.full_name}`
          : `${student.full_name}'s Weekly Progress Report`

        const html = `
<!DOCTYPE html>
<html lang="${locale}">
<head><meta charset="UTF-8"><title>${subject}</title></head>
<body style="font-family: Nunito, Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background: #F4F4F8;">
  <div style="background: #1E2140; color: white; padding: 24px; border-radius: 16px 16px 0 0; text-align: center;">
    <h1 style="color: #F5C518; margin: 0; font-size: 24px;">CODEship Academy</h1>
    <p style="margin: 8px 0 0; color: #ccc;">${isFr ? 'Rapport Hebdomadaire' : 'Weekly Progress Report'}</p>
  </div>

  <div style="background: white; padding: 24px; border-radius: 0 0 16px 16px; border: 1px solid #e5e7eb; border-top: none;">
    <h2 style="color: #1E2140;">
      ${isFr ? `Bonjour! Voici la semaine de ${student.full_name} 🚀` : `Hi! Here's ${student.full_name}'s week 🚀`}
    </h2>

    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin: 20px 0;">
      <div style="background: #F4F4F8; border-radius: 12px; padding: 16px; text-align: center;">
        <div style="font-size: 28px; font-weight: 800; color: #1E2140;">${xpThisWeek}</div>
        <div style="font-size: 12px; color: #6b7280;">${isFr ? 'XP cette semaine' : 'XP this week'}</div>
      </div>
      <div style="background: #F4F4F8; border-radius: 12px; padding: 16px; text-align: center;">
        <div style="font-size: 28px; font-weight: 800; color: #1E2140;">${lessonsThisWeek.length}</div>
        <div style="font-size: 12px; color: #6b7280;">${isFr ? 'leçons complètes' : 'lessons done'}</div>
      </div>
      <div style="background: #F4F4F8; border-radius: 12px; padding: 16px; text-align: center;">
        <div style="font-size: 28px; font-weight: 800; color: #1E2140;">🔥 ${student.streak_days}</div>
        <div style="font-size: 12px; color: #6b7280;">${isFr ? 'jours consécutifs' : 'day streak'}</div>
      </div>
    </div>

    ${lessonsThisWeek.length > 0 ? `
    <h3 style="color: #1E2140;">${isFr ? 'Leçons complétées' : 'Lessons Completed'}</h3>
    <ul style="color: #374151; padding-left: 20px;">
      ${lessonsThisWeek.slice(0, 5).map((title: string) => `<li>${title}</li>`).join('')}
    </ul>` : `<p style="color: #6b7280;">${isFr ? 'Pas de leçons cette semaine — encouragez-les à commencer!' : 'No lessons this week — encourage them to start!'}</p>`}

    <div style="margin: 24px 0; text-align: center;">
      <a href="${appUrl}/en/dashboard/parent"
         style="background: #F5C518; color: #1E2140; font-weight: 700; padding: 14px 28px; border-radius: 12px; text-decoration: none; display: inline-block;">
        ${isFr ? 'Voir le tableau de bord complet →' : 'View Full Dashboard →'}
      </a>
    </div>

    <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 24px 0;">

    <p style="font-size: 11px; color: #9ca3af; text-align: center;">
      CODEship Academy Inc., 21 Simcoe St S, Oshawa, ON L1H 4G2<br>
      <a href="${appUrl}/api/unsubscribe?type=weekly_digest&token=UNSUBSCRIBE_TOKEN" style="color: #9ca3af;">
        ${isFr ? 'Se désabonner' : 'Unsubscribe from weekly digest'}
      </a>
    </p>
  </div>
</body>
</html>`

        await resend.emails.send({
          from: process.env.EMAIL_FROM ?? 'noreply@codeshipacademy.com',
          to: userRecord?.email ?? '',
          subject,
          html,
        })

        sentCount++
      }
    } catch (err) {
      console.error('Failed to send digest for user:', consent.user_id, err)
    }
  }

  return NextResponse.json({ sent: sentCount })
}
