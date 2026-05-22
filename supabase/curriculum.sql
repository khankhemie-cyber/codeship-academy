-- =============================================================================
-- CODEship Academy — Curriculum Helpers
-- Run after schema.sql.
-- Adds indexes, constraints, and helper functions for the curriculum tables
-- (lessons, projects, quizzes, quiz_questions are defined in schema.sql).
-- =============================================================================

-- =============================================================================
-- ADDITIONAL CURRICULUM INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_lessons_level          ON public.lessons(level);
CREATE INDEX IF NOT EXISTS idx_lessons_category       ON public.lessons(category);
CREATE INDEX IF NOT EXISTS idx_lessons_slug           ON public.lessons(slug);
CREATE INDEX IF NOT EXISTS idx_lessons_level_category ON public.lessons(level, category);
CREATE INDEX IF NOT EXISTS idx_lessons_sort_order     ON public.lessons(level, sort_order);

CREATE INDEX IF NOT EXISTS idx_projects_level         ON public.projects(level);
CREATE INDEX IF NOT EXISTS idx_projects_category      ON public.projects(category);
CREATE INDEX IF NOT EXISTS idx_projects_level_cat     ON public.projects(level, category);
CREATE INDEX IF NOT EXISTS idx_projects_sort_order    ON public.projects(level, sort_order);

CREATE INDEX IF NOT EXISTS idx_quiz_questions_quiz_id ON public.quiz_questions(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_order   ON public.quiz_questions(quiz_id, sort_order);

CREATE INDEX IF NOT EXISTS idx_quizzes_level          ON public.quizzes(level);
CREATE INDEX IF NOT EXISTS idx_quizzes_category       ON public.quizzes(category);
CREATE INDEX IF NOT EXISTS idx_quizzes_level_cat      ON public.quizzes(level, category);

-- =============================================================================
-- FUNCTION: award_xp
-- Awards XP to a student, applying a streak-based multiplier.
--
-- Streak multiplier thresholds:
--   >= 30 days  → 2.0x
--   >= 14 days  → 1.5x
--   >= 7 days   → 1.25x
--   < 7 days    → uses xp_multiplier column on student_profiles (default 1.0)
--
-- Returns the actual XP awarded after multiplier is applied.
-- Minimum 1 XP is always awarded regardless of rounding.
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
  -- Fetch current streak and the student's configured base multiplier.
  SELECT streak_days, xp_multiplier
  INTO   v_streak, v_multiplier
  FROM   public.student_profiles
  WHERE  id = p_student_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Student % not found', p_student_id;
  END IF;

  -- Override base multiplier with streak tier if applicable.
  IF v_streak >= 30 THEN
    v_multiplier := 2.0;
  ELSIF v_streak >= 14 THEN
    v_multiplier := 1.5;
  ELSIF v_streak >= 7 THEN
    v_multiplier := 1.25;
  END IF;
  -- Below 7-day streak: use existing xp_multiplier value (default 1.0).

  v_xp_to_add := GREATEST(1, ROUND(p_base_xp * v_multiplier)::int);

  UPDATE public.student_profiles
  SET    xp_points  = xp_points + v_xp_to_add,
         updated_at = now()
  WHERE  id = p_student_id;

  RETURN v_xp_to_add;
END;
$$;

-- =============================================================================
-- FUNCTION: check_level_completion
-- Returns TRUE when a student has satisfied both of:
--   - Completed >= 80% of visible lessons at their current level
--   - Passed   >= 70% of visible quizzes at their current level
--     (based on most-recent attempt per quiz; no quizzes = lesson-only check)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.check_level_completion(
  p_student_id uuid
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_level            text;
  v_total_lessons    int;
  v_done_lessons     int;
  v_total_quizzes    int;
  v_passed_quizzes   int;
  v_lesson_pct       numeric;
  v_quiz_pct         numeric;
BEGIN
  -- Resolve student's current level.
  SELECT level INTO v_level
  FROM   public.student_profiles
  WHERE  id = p_student_id;

  IF NOT FOUND THEN
    RETURN false;
  END IF;

  -- Total visible lessons for this level.
  SELECT COUNT(*) INTO v_total_lessons
  FROM   public.lessons
  WHERE  level      = v_level
    AND  is_visible = true;

  IF v_total_lessons = 0 THEN
    RETURN false;  -- No content yet; cannot be complete.
  END IF;

  -- Lessons the student has fully completed.
  SELECT COUNT(*) INTO v_done_lessons
  FROM   public.lesson_progress lp
  JOIN   public.lessons l ON l.id = lp.lesson_id
  WHERE  lp.student_id = p_student_id
    AND  lp.status     = 'completed'
    AND  l.level       = v_level
    AND  l.is_visible  = true;

  v_lesson_pct := v_done_lessons::numeric / v_total_lessons;

  -- Total visible quizzes for this level.
  SELECT COUNT(*) INTO v_total_quizzes
  FROM   public.quizzes
  WHERE  level      = v_level
    AND  is_visible = true;

  IF v_total_quizzes = 0 THEN
    -- Level has no quizzes; only lesson threshold applies.
    RETURN (v_lesson_pct >= 0.8);
  END IF;

  -- Count passed quizzes using each quiz's most recent attempt only.
  SELECT COUNT(*) INTO v_passed_quizzes
  FROM (
    SELECT DISTINCT ON (qa.quiz_id)
           qa.passed
    FROM   public.quiz_attempts qa
    JOIN   public.quizzes q ON q.id = qa.quiz_id
    WHERE  qa.student_id = p_student_id
      AND  q.level       = v_level
      AND  q.is_visible  = true
    ORDER  BY qa.quiz_id, qa.created_at DESC
  ) latest
  WHERE latest.passed = true;

  v_quiz_pct := v_passed_quizzes::numeric / v_total_quizzes;

  RETURN (v_lesson_pct >= 0.8 AND v_quiz_pct >= 0.7);
END;
$$;

-- =============================================================================
-- FUNCTION: get_student_curriculum_summary
-- Returns a JSON summary of a student's progress across all levels.
-- Useful for dashboard widgets and AI learning plan generation.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.get_student_curriculum_summary(
  p_student_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'lessons', jsonb_build_object(
      'total',     COUNT(DISTINCT lp.lesson_id),
      'completed', COUNT(DISTINCT lp.lesson_id) FILTER (WHERE lp.status = 'completed'),
      'in_progress', COUNT(DISTINCT lp.lesson_id) FILTER (WHERE lp.status = 'in_progress')
    ),
    'quizzes', jsonb_build_object(
      'attempts', COUNT(DISTINCT qa.id),
      'passed',   COUNT(DISTINCT qa.id) FILTER (WHERE qa.passed = true)
    ),
    'projects', jsonb_build_object(
      'submitted', COUNT(DISTINCT ps.id)
    )
  )
  INTO v_result
  FROM public.student_profiles sp
  LEFT JOIN public.lesson_progress lp ON lp.student_id = sp.id
  LEFT JOIN public.quiz_attempts   qa ON qa.student_id  = sp.id
  LEFT JOIN public.project_submissions ps ON ps.student_id = sp.id
  WHERE sp.id = p_student_id;

  RETURN COALESCE(v_result, '{}'::jsonb);
END;
$$;
