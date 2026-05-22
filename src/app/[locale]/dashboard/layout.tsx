import { requireAuth } from '@/lib/utils/auth'
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import DashboardShell from '@/components/layout/DashboardShell'

export const dynamic = 'force-dynamic'

export default async function DashboardLayout({
  children,
  params,
}: {
  children: React.ReactNode
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) redirect(`/${locale}/login`)

  const { data: userData } = await supabase
    .from('users')
    .select('role, full_name, locale')
    .eq('id', user.id)
    .single()

  if (!userData) redirect(`/${locale}/login`)

  const role = userData.role as 'parent' | 'teacher' | 'student' | 'admin'

  return (
    <DashboardShell
      role={role}
      userName={userData.full_name ?? user.email ?? 'User'}
      locale={locale}
    >
      {children}
    </DashboardShell>
  )
}
