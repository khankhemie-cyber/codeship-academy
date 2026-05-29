import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { checkRateLimit } from '@/lib/rate-limit'
import Anthropic from '@anthropic-ai/sdk'
import { z } from 'zod'

const PlannerSchema = z.object({
  studentId: z.string().uuid(),
  daysPerWeek: z.number().int().min(1).max(7),
  minutesPerSession: z.number().int().min(10).max(120),
})

export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: userData } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (userData?.role !== 'parent' && userData?.role !== 'admin') {
    return NextResponse.json({ error: 'Parents only' }, { status: 403 })
  }

  const rate = await checkRateLimit(user.id, 'ai_planner', 10, 86400)
  if (!rate.allowed) {
    return NextResponse.json({ error: 'Daily planner limit reached. Try again tomorrow.' }, { status: 429 })
  }

  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 })
  }

  const parsed = PlannerSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid request', details: parsed.error.flatten() }, { status: 400 })
  }

  const { studentId, daysPerWeek, minutesPerSession } = parsed.data

  // Verify parent owns this student
  const { data: student } = await supabase
    .from('student_profiles')
    .select('*')
    .eq('id', studentId)
    .eq('parent_id', user.id)
    .single()

  if (!student) return NextResponse.json({ error: 'Student not found' }, { status: 404 })

  // Get current lesson progress
  const { data: completedLessons } = await supabase
    .from('lesson_progress')
    .select('lessons(slug, title)')
    .eq('student_id', studentId)
    .eq('status', 'completed')
    .limit(10)

  const prompt = `Generate a personalised 4-week coding learning plan for a student.

Student profile:
- Name: ${student.full_name}
- Age: ${student.age}
- Grade: ${student.grade}
- Current level: ${student.level}
- XP points: ${student.xp_points}
- Learning schedule: ${daysPerWeek} days/week, ${minutesPerSession} minutes/session

Respond in JSON format only:
{
  "weeks": [
    {
      "weekNumber": 1,
      "theme": "Week theme",
      "startDate": "2026-05-22",
      "days": [
        {
          "day": "Monday",
          "lessonSlug": "exp-l01",
          "lessonTitle": "What Is a Computer?",
          "estimatedMinutes": 20,
          "estimatedXP": 100,
          "type": "lesson|quiz|project"
        }
      ],
      "milestone": "By the end of this week, you will...",
      "estimatedXP": 500
    }
  ],
  "totalXP": 2000,
  "summary": "Overview of the 4-week plan"
}`

  try {
    const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

    const response = await anthropic.messages.create({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 2000,
      messages: [{ role: 'user', content: prompt }],
    })

    const text = response.content[0].type === 'text' ? response.content[0].text : '{}'
    const plan = JSON.parse(text)

    // Save plan to DB
    await supabase.from('learning_plans').insert({
      student_id: studentId,
      parent_id: user.id,
      plan,
      week_start: new Date().toISOString().split('T')[0],
    })

    return NextResponse.json(plan)
  } catch (error) {
    console.error('Planner error:', error)
    return NextResponse.json({ error: 'Planner service unavailable' }, { status: 503 })
  }
}
