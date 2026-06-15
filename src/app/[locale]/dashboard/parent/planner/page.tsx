import { createClient } from '@/lib/supabase/server'
import { requireRole } from '@/lib/utils/auth'
import PlannerForm from '@/components/parent/PlannerForm'

export default async function PlannerPage() {
  const supabase = await createClient()
  const user = await requireRole(supabase, 'parent')

  const { data: children } = await supabase
    .from('student_profiles')
    .select('id, full_name, level')
    .eq('parent_id', user.id)

  return (
    <div className="max-w-2xl space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">AI Learning Planner</h1>
        <p className="text-gray-500 mt-1">
          Generate a personalised 4-week coding plan tailored to your child&apos;s level and schedule.
        </p>
      </div>
      <PlannerForm students={children ?? []} />
    </div>
  )
}
