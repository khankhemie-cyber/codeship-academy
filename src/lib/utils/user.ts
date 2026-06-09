import type { SupabaseClient } from '@supabase/supabase-js'
import type { UserRole } from '@/types/database'

export type AppUser = {
  id: string
  email: string
  full_name: string | null
  role: UserRole
  locale: string
  deleted_at: string | null
}

export async function getAppUser(
  supabase: SupabaseClient,
  authUserId: string
): Promise<AppUser | null> {
  const { data } = await supabase
    .from('users')
    .select('id, email, full_name, role, locale, deleted_at')
    .eq('id', authUserId)
    .single()

  return data as AppUser | null
}

export function levelFromAge(age: number): string {
  if (age <= 7) return 'explorers'
  if (age <= 9) return 'builders'
  if (age <= 12) return 'developers'
  return 'engineers'
}

export const GRADE_OPTIONS = ['K', '1', '2', '3', '4', '5', '6', '7', '8'] as const
