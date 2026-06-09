import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { checkRateLimit } from '@/lib/rate-limit'
import Anthropic from '@anthropic-ai/sdk'
import { z } from 'zod'

const TutorSchema = z.object({
  lessonSlug: z.string().min(1).max(50),
  lessonTitle: z.string().min(1).max(200),
  level: z.enum(['explorers', 'builders', 'developers', 'engineers']),
  age: z.number().int().min(4).max(18),
  message: z.string().min(1).max(1000).trim(),
  history: z.array(z.object({
    role: z.enum(['user', 'assistant']),
    content: z.string().max(1000),
  })).max(10).default([]),
})

const AGE_TONES: Record<string, string> = {
  explorers: 'You are talking to a 6-7 year old child. Use very simple words, short sentences, and lots of encouragement. Use fun emojis.',
  builders:  'You are talking to an 8-9 year old child. Use simple language and be enthusiastic and encouraging.',
  developers: 'You are talking to a 10-12 year old student. Use clear technical language but keep it accessible and encouraging.',
  engineers:  'You are talking to a 13-16 year old student. You can use proper technical language and treat them as a capable peer.',
}

export async function POST(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { data: userData } = await supabase.from('users').select('role').eq('id', user.id).single()
  if (!userData || !['parent', 'admin'].includes(userData.role)) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  const rate = await checkRateLimit(user.id, 'ai_tutor', 20, 3600)
  if (!rate.allowed) {
    return NextResponse.json({ error: 'Rate limit reached. Try again in an hour.' }, { status: 429 })
  }

  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 })
  }

  const parsed = TutorSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid request', details: parsed.error.flatten() }, { status: 400 })
  }

  const { lessonSlug, lessonTitle, level, age, message, history } = parsed.data

  const systemPrompt = `You are a friendly AI coding tutor for CODEship Academy.

${AGE_TONES[level]}

Current lesson: "${lessonTitle}" (${lessonSlug})

CRITICAL RULES:
- NEVER provide the complete answer to a coding problem — guide with hints only
- NEVER discuss anything unrelated to coding or this lesson
- NEVER ask personal questions or discuss personal information
- If asked something off-topic, say "I'm your coding helper! Let's focus on ${lessonTitle}."
- For students under 13: never ask about school name, location, family, or personal details
- Keep responses concise (2-4 sentences for simple questions)
- Be warm, encouraging, and positive
- If a student is stuck, provide a gentle hint that leads them to the answer`

  try {
    const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

    const messages: Anthropic.MessageParam[] = [
      ...history.map((h) => ({ role: h.role as 'user' | 'assistant', content: h.content })),
      { role: 'user', content: message },
    ]

    const response = await anthropic.messages.create({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 400,
      system: systemPrompt,
      messages,
    })

    const reply = response.content[0].type === 'text' ? response.content[0].text : 'I had trouble with that. Could you rephrase?'

    // Log the request (not the content — privacy)
    await supabase.from('audit_logs').insert({
      user_id: user.id,
      action: 'ai_tutor_request',
      target_id: lessonSlug,
      target_type: 'lesson',
      metadata: { level },
    })

    return NextResponse.json({ reply })
  } catch (error) {
    console.error('AI tutor error:', error)
    return NextResponse.json({ error: 'AI service unavailable' }, { status: 503 })
  }
}
