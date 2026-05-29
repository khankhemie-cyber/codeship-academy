import { cookies } from 'next/headers'
import type { SupabaseClient } from '@supabase/supabase-js'

export const ACTIVE_STUDENT_COOKIE = 'active_student_id'

/** Resolve which student profile the current session is acting as. */
export async function resolveStudentId(
  supabase: SupabaseClient,
  userId: string,
  role: string
): Promise<string | null> {
  if (role === 'parent' || role === 'admin') {
    const cookieStore = await cookies()
    const activeId = cookieStore.get(ACTIVE_STUDENT_COOKIE)?.value

    if (activeId) {
      const query = supabase
        .from('student_profiles')
        .select('id')
        .eq('id', activeId)

      if (role === 'parent') {
        query.eq('parent_id', userId)
      }

      const { data } = await query.single()
      if (data) return data.id
    }

    if (role === 'parent') {
      const { data: first } = await supabase
        .from('student_profiles')
        .select('id')
        .eq('parent_id', userId)
        .order('created_at', { ascending: true })
        .limit(1)
        .single()
      return first?.id ?? null
    }
  }

  return null
}

/** Verify the authenticated user may act on this student profile. */
export async function verifyStudentAccess(
  supabase: SupabaseClient,
  userId: string,
  role: string,
  studentId: string
): Promise<boolean> {
  if (role === 'admin') return true
  if (role === 'parent') {
    const { data } = await supabase
      .from('student_profiles')
      .select('id')
      .eq('id', studentId)
      .eq('parent_id', userId)
      .single()
    return !!data
  }
  return false
}
