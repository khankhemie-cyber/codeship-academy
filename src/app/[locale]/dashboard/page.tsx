import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

export default async function DashboardRootPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: userData } = await supabase.from('users').select('role').eq('id', user.id).single()
  const role = userData?.role ?? 'parent'

  redirect(`/${locale}/dashboard/${role}`)
}
