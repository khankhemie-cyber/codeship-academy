import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

type AnySupabase = any

function isSupabaseClient(arg: unknown): arg is AnySupabase {
  return (
    typeof arg === 'object' &&
    arg !== null &&
    !Array.isArray(arg) &&
    'auth' in arg
  )
}

export async function requireAuth(
  supabaseOrLocale?: AnySupabase | string,
  _locale = 'en'
) {
  const locale = typeof supabaseOrLocale === 'string' ? supabaseOrLocale : _locale
  const supabase = isSupabaseClient(supabaseOrLocale)
    ? supabaseOrLocale
    : await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)
  return user
}

export async function requireRole(
  supabaseOrRole: AnySupabase | string | string[],
  roleOrLocale?: string | string[],
  _locale = 'en'
) {
  let supabase: AnySupabase
  let role: string | string[]
  let locale: string

  if (isSupabaseClient(supabaseOrRole)) {
    supabase = supabaseOrRole
    role = roleOrLocale as string | string[]
    locale = _locale
  } else {
    supabase = await createClient()
    role = supabaseOrRole as string | string[]
    locale = typeof roleOrLocale === 'string' ? roleOrLocale : _locale
  }

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect(`/${locale}/login`)

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('user_id', user.id)
    .single()

  const allowed = Array.isArray(role) ? role : [role]
  if (!profile || !allowed.includes(profile.role as string)) {
    redirect(`/${locale}/dashboard`)
  }

  return user
}

export async function getSessionUser() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return null
  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('user_id', user.id)
    .single()
  return { user, profile }
}
