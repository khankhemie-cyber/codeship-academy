-- =============================================================================
-- CODEship Academy — Patch / Migration
-- Safe to run multiple times (all statements are idempotent).
-- Run after schema.sql, curriculum.sql, school-portal.sql, and classes.sql.
--
-- What this file does:
--   1. Adds missing columns to existing tables (IF NOT EXISTS guards).
--   2. Ensures topic_mastery table exists (in case schema.sql was an old version).
--   3. Replaces award_xp with the canonical streak-multiplier implementation.
-- =============================================================================

-- =============================================================================
-- 1. ADD MISSING COLUMNS
-- =============================================================================

-- student_profiles.visibility
-- Added here in case an earlier schema.sql version omitted it.
ALTER TABLE public.student_profiles
  ADD COLUMN IF NOT EXISTS visibility visibility_type NOT NULL DEFAULT 'public';

-- student_profiles.xp_multiplier
-- Stores a custom per-student multiplier; overridden by streak tiers in award_xp.
ALTER TABLE public.student_profiles
  ADD COLUMN IF NOT EXISTS xp_multiplier numeric NOT NULL DEFAULT 1.0;

-- users.locale
-- BCP-47 language tag; defaults to English.
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS locale text NOT NULL DEFAULT 'en';

-- =============================================================================
-- 2. ENSURE topic_mastery EXISTS
-- (schema.sql current version includes this table; patch guards against older
-- deployments that may not have it.)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.topic_mastery (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id    uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  topic         text NOT NULL,
  level         text,
  mastery_score int NOT NULL DEFAULT 0,
  attempts      int NOT NULL DEFAULT 0,
  updated_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, topic)
);

-- Enable RLS if table was just created by this patch.
ALTER TABLE public.topic_mastery ENABLE ROW LEVEL SECURITY;

-- Guard: create policies only if they don't already exist.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'topic_mastery'
      AND policyname = 'topic_mastery: parent sees children'
  ) THEN
    EXECUTE $policy$
      CREATE POLICY "topic_mastery: parent sees children"
        ON public.topic_mastery FOR ALL
        USING (
          EXISTS (
            SELECT 1 FROM public.student_profiles sp
            WHERE sp.id = student_id AND sp.parent_id = auth.uid()
          )
        )
    $policy$;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'topic_mastery'
      AND policyname = 'topic_mastery: admin full'
  ) THEN
    EXECUTE $policy$
      CREATE POLICY "topic_mastery: admin full"
        ON public.topic_mastery FOR ALL
        USING (
          EXISTS (
            SELECT 1 FROM public.users u
            WHERE u.id = auth.uid() AND u.role = 'admin'
          )
        )
    $policy$;
  END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_topic_mastery_student ON public.topic_mastery(student_id);
CREATE INDEX IF NOT EXISTS idx_topic_mastery_topic   ON public.topic_mastery(student_id, topic);

-- =============================================================================
-- 3. REPLACE award_xp WITH CANONICAL STREAK-MULTIPLIER VERSION
--
-- Streak thresholds:
--   >= 30 days  → 2.0x
--   >= 14 days  → 1.5x
--   >= 7 days   → 1.25x
--   < 7 days    → uses xp_multiplier column value (default 1.0)
--
-- Minimum 1 XP always awarded.
-- Returns actual XP credited.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.award_xp(
  p_student_id uuid,
  p_base_xp    int
)
RETURNS int
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_streak      int;
  v_multiplier  numeric;
  v_xp_to_add   int;
BEGIN
  SELECT streak_days, xp_multiplier
  INTO   v_streak, v_multiplier
  FROM   public.student_profiles
  WHERE  id = p_student_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Student % not found', p_student_id;
  END IF;

  -- Apply streak tier (overrides xp_multiplier column).
  IF v_streak >= 30 THEN
    v_multiplier := 2.0;
  ELSIF v_streak >= 14 THEN
    v_multiplier := 1.5;
  ELSIF v_streak >= 7 THEN
    v_multiplier := 1.25;
  END IF;
  -- Below 7 days: keep xp_multiplier as fetched from the row.

  v_xp_to_add := GREATEST(1, ROUND(p_base_xp * v_multiplier)::int);

  UPDATE public.student_profiles
  SET    xp_points  = xp_points + v_xp_to_add,
         updated_at = now()
  WHERE  id = p_student_id;

  RETURN v_xp_to_add;
END;
$$;

-- =============================================================================
-- 4. ADDITIONAL SAFETY INDEXES
-- (Idempotent — IF NOT EXISTS guards prevent duplicate index errors.)
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_student_profiles_level   ON public.student_profiles(level);
CREATE INDEX IF NOT EXISTS idx_student_profiles_xp      ON public.student_profiles(xp_points DESC);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_completed ON public.lesson_progress(student_id, completed_at DESC)
  WHERE status = 'completed';
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_passed      ON public.quiz_attempts(student_id, passed);

-- =============================================================================
-- 5. RATE LIMIT LOG (AI + auth endpoints)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.rate_limit_log (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  action     text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_rate_limit_log_user_action
  ON public.rate_limit_log(user_id, action, created_at DESC);

ALTER TABLE public.rate_limit_log ENABLE ROW LEVEL SECURITY;

-- Service role only (API routes use service client for inserts/counts)
CREATE POLICY "rate_limit_log: service only"
  ON public.rate_limit_log FOR ALL
  USING (false)
  WITH CHECK (false);

-- =============================================================================
-- 6. update_streak — call after lesson/quiz completion
-- =============================================================================

CREATE OR REPLACE FUNCTION public.update_streak(p_student_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_last      date;
  v_streak    int;
  v_multiplier numeric;
BEGIN
  SELECT (updated_at AT TIME ZONE 'UTC')::date, streak_days
  INTO   v_last, v_streak
  FROM   public.student_profiles
  WHERE  id = p_student_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Student % not found', p_student_id;
  END IF;

  IF v_last = (now() AT TIME ZONE 'UTC')::date THEN
    RETURN;
  END IF;

  IF v_last = (now() AT TIME ZONE 'UTC')::date - 1 THEN
    v_streak := v_streak + 1;
  ELSE
    v_streak := 1;
  END IF;

  IF v_streak >= 30 THEN
    v_multiplier := 2.0;
  ELSIF v_streak >= 14 THEN
    v_multiplier := 1.5;
  ELSIF v_streak >= 7 THEN
    v_multiplier := 1.25;
  ELSE
    v_multiplier := 1.0;
  END IF;

  UPDATE public.student_profiles
  SET    streak_days   = v_streak,
         xp_multiplier = v_multiplier,
         updated_at    = now()
  WHERE  id = p_student_id;
END;
$$;
