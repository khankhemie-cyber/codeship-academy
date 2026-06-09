import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { checkRateLimit } from '@/lib/rate-limit'
import Anthropic from '@anthropic-ai/sdk'
import { z } from 'zod'

const AssessmentSchema = z.object({
  studentName: z.string().min(1).max(100).trim(),
  age: z.number().int().min(4).max(18),
  grade: z.enum(['K', '1', '2', '3', '4', '5', '6', '7', '8']),
  experience: z.enum(['none', 'some', 'lots']),
  skills: z.object({
    reading: z.number().int().min(1).max(5),
    math: z.number().int().min(1).max(5),
    logic: z.number().int().min(1).max(5),
    focus: z.number().int().min(1).max(5),
  }),
})

export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: userData } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (userData?.role !== 'parent' && userData?.role !== 'admin') {
    return NextResponse.json({ error: 'Parents only' }, { status: 403 })
  }

  const rate = await checkRateLimit(user.id, 'ai_assessment', 10, 86400)
  if (!rate.allowed) {
    return NextResponse.json({ error: 'Daily assessment limit reached. Try again tomorrow.' }, { status: 429 })
  }

  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 })
  }

  const parsed = AssessmentSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid request', details: parsed.error.flatten() }, { status: 400 })
  }

  const { studentName, age, grade, experience, skills } = parsed.data

  const prompt = `You are an educational assessment AI for CODEship Academy, a K-8 coding education platform.

Assess this student and recommend the best starting level and learning plan.

Student info:
- Name: ${studentName} (use first name only in response)
- Age: ${age} years old
- Grade: ${grade === 'K' ? 'Kindergarten' : `Grade ${grade}`}
- Prior coding experience: ${experience === 'none' ? 'No experience' : experience === 'some' ? 'Some basic experience' : 'Significant experience'}
- Skills (1-5 scale): Reading ${skills.reading}/5, Math ${skills.math}/5, Logic ${skills.logic}/5, Focus/attention ${skills.focus}/5

CODEship Academy levels:
- Explorers (K-1, ages 6-7): Block coding, visual logic, computational thinking
- Builders (Gr 2-3, ages 8-9): HTML, CSS, Scratch
- Developers (Gr 4-6, ages 10-12): JavaScript, APIs, React, Python intro
- Engineers (Gr 7-8, ages 13-16): Python, Flask, SQL, Git, ML basics

Respond in JSON format only:
{
  "recommendedLevel": "explorers|builders|developers|engineers",
  "confidence": "high|medium|low",
  "rationale": "2-3 sentence explanation for the parent",
  "learningStyle": "visual|hands-on|conceptual|mixed",
  "suggestedFirstLesson": "slug of the first lesson to start (e.g., exp-l01)",
  "goals": ["goal 1", "goal 2", "goal 3"],
  "parentTips": ["tip 1", "tip 2"]
}`

  try {
    const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

    const response = await anthropic.messages.create({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 800,
      messages: [{ role: 'user', content: prompt }],
    })

    const text = response.content[0].type === 'text' ? response.content[0].text : '{}'
    const result = JSON.parse(text)

    // Save assessment to DB (without storing until parent explicitly saves)
    await supabase.from('assessments').insert({
      parent_id: user.id,
      student_name: studentName,
      age,
      grade,
      experience,
      skills,
      recommended_level: result.recommendedLevel,
    })

    return NextResponse.json(result)
  } catch (error) {
    console.error('Assessment error:', error)
    return NextResponse.json({ error: 'Assessment service unavailable' }, { status: 503 })
  }
}
