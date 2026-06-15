-- =============================================================================
-- CODEship Academy — Canonical Database Schema
-- PostgreSQL / Supabase compatible.
--
-- This is the SINGLE source of truth for the application data model. It matches
-- the queries used throughout the Next.js app (the `profiles`-centric model).
--
-- RUN ORDER:
--   1. schema.sql                              (this file)
--   2. curriculum-explorers.sql
--   3. curriculum-explorers-projects.sql
--   4. curriculum-builders.sql
--   5. curriculum-builders-projects.sql
--   6. curriculum-builders-quizzes.sql
--   7. curriculum-builders-quizzes-complete.sql
--   8. curriculum-developers.sql
--   9. curriculum-developers-quizzes.sql
--
-- Re-runnable: uses IF NOT EXISTS / OR REPLACE / DROP POLICY IF EXISTS guards.
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- ENUMS
-- =============================================================================

DO $$ BEGIN
  CREATE TYPE user_role AS ENUM ('parent', 'teacher', 'student', 'admin');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE lesson_status AS ENUM ('not_started', 'in_progress', 'completed', 'needs_review');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE visibility_type AS ENUM ('public', 'class_only', 'private');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE consent_type AS ENUM ('weekly_digest', 'product_updates', 'promotions', 'school_newsletter');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE consent_method AS ENUM ('signup_form', 'settings_update');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE withdraw_method AS ENUM ('unsubscribe_link', 'settings', 'admin_request');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- =============================================================================
-- CORE IDENTITY TABLES
-- =============================================================================

-- users — lightweight mirror of auth.users (id == auth.users.id).
CREATE TABLE IF NOT EXISTS public.users (
  id          uuid PRIMARY KEY,
  email       text,
  full_name   text,
  role        user_role NOT NULL DEFAULT 'parent',
  locale      text NOT NULL DEFAULT 'en',
  avatar_url  text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  deleted_at  timestamptz
);

-- profiles — one row per auth user (any role). The hub of the data model.
CREATE TABLE IF NOT EXISTS public.profiles (
  id                    uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id               uuid NOT NULL UNIQUE,
  email                 text,
  display_name          text,
  role                  user_role NOT NULL DEFAULT 'parent',
  level                 text NOT NULL DEFAULT 'explorers',
  date_of_birth         date,
  grade                 text,
  avatar_emoji          text,
  avatar_url            text,
  total_xp              int NOT NULL DEFAULT 0,
  current_streak        int NOT NULL DEFAULT 0,
  xp_multiplier         numeric NOT NULL DEFAULT 1.0,
  visibility            visibility_type NOT NULL DEFAULT 'public',
  leaderboard_opt_out   boolean NOT NULL DEFAULT false,
  stripe_customer_id    text,
  subscription_plan     text DEFAULT 'trial',
  subscription_status   text DEFAULT 'trial',
  trial_ends_at         timestamptz,
  locale                text NOT NULL DEFAULT 'en',
  last_active_at        timestamptz,
  deletion_requested_at timestamptz,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);

-- parent_profiles / teacher_profiles — optional role-specific metadata.
CREATE TABLE IF NOT EXISTS public.parent_profiles (
  id                 uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id            uuid NOT NULL UNIQUE,
  notification_prefs jsonb,
  timezone           text,
  phone              text,
  created_at         timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.teacher_profiles (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         uuid NOT NULL UNIQUE,
  school_name     text,
  classroom_name  text,
  grade_range     text,
  certification   text,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- parent_student_links — connects a parent profile to a child (student) profile.
CREATE TABLE IF NOT EXISTS public.parent_student_links (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  parent_id     uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  student_id    uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  consent_given boolean NOT NULL DEFAULT false,
  consent_ip    text,
  consent_ua    text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (parent_id, student_id)
);

-- =============================================================================
-- CONSENT / COMPLIANCE TABLES
-- =============================================================================

-- email_consents — CASL marketing consent (one row per user per type).
CREATE TABLE IF NOT EXISTS public.email_consents (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           uuid NOT NULL,
  consent_type      consent_type NOT NULL,
  consent_given_at  timestamptz NOT NULL DEFAULT now(),
  consent_method    consent_method NOT NULL DEFAULT 'signup_form',
  ip_address        text,
  withdrawn_at      timestamptz,
  withdrawn_method  withdraw_method,
  UNIQUE (user_id, consent_type)
);

-- consent_records — generic consent ledger (e.g. parental consent for a child).
CREATE TABLE IF NOT EXISTS public.consent_records (
  id           uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      uuid,
  consent_type text NOT NULL,
  method       text,
  ip_address   text,
  user_agent   text,
  consented_by uuid,
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- parental_consents — COPPA/PIPEDA detailed parental consent records.
CREATE TABLE IF NOT EXISTS public.parental_consents (
  id                          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  parent_user_id              uuid NOT NULL,
  student_name                text NOT NULL,
  student_age                 int NOT NULL,
  consent_given_at            timestamptz NOT NULL DEFAULT now(),
  consent_method              text NOT NULL DEFAULT 'checkbox_with_policy_link',
  ip_address                  text,
  user_agent                  text,
  privacy_policy_version      text,
  data_retention_acknowledged boolean NOT NULL DEFAULT false,
  ai_processing_acknowledged  boolean NOT NULL DEFAULT false,
  marketing_opt_in            boolean NOT NULL DEFAULT false
);

-- =============================================================================
-- CURRICULUM TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.lessons (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug              text UNIQUE NOT NULL,
  title             text NOT NULL,
  level             text,
  category          text,
  language          text NOT NULL DEFAULT 'en',
  difficulty        text,
  duration_minutes  int,
  instructions      text,
  xp_reward         int NOT NULL DEFAULT 100,
  is_visible        boolean NOT NULL DEFAULT true,
  sort_order        int,
  created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.projects (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug                text UNIQUE NOT NULL,
  title               text NOT NULL,
  level               text,
  category            text,
  difficulty          text,
  duration_minutes    int,
  starter_code        text,
  description         text,
  instructions        text,
  tags                text[],
  learning_objectives text[],
  xp_reward           int NOT NULL DEFAULT 200,
  is_visible          boolean NOT NULL DEFAULT true,
  is_published        boolean NOT NULL DEFAULT true,
  sort_order          int,
  created_at          timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.quizzes (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug                text UNIQUE NOT NULL,
  title               text NOT NULL,
  level               text,
  category            text,
  time_limit_seconds  int NOT NULL DEFAULT 600,
  passing_score       int NOT NULL DEFAULT 70,
  xp_reward           int NOT NULL DEFAULT 150,
  is_visible          boolean NOT NULL DEFAULT true,
  created_at          timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.quiz_questions (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id         uuid NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  question        text NOT NULL,
  options         jsonb NOT NULL,
  correct_answer  int NOT NULL,
  explanation     text,
  points          int NOT NULL DEFAULT 10,
  sort_order      int
);

-- =============================================================================
-- PROGRESS / ACTIVITY TABLES (student_id references profiles.id)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.lesson_progress (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id       uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  lesson_id        uuid NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  status           lesson_status NOT NULL DEFAULT 'not_started',
  score            int,
  hearts_remaining int NOT NULL DEFAULT 5,
  completed_at     timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, lesson_id)
);

CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id           uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id   uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  quiz_id      uuid NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  score        int,
  answers      jsonb,
  passed       boolean,
  started_at   timestamptz,
  completed_at timestamptz,
  created_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.project_submissions (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id    uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  project_id    uuid NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  code          text,
  notes         text,
  status        text NOT NULL DEFAULT 'submitted',
  submitted_at  timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, project_id)
);

CREATE TABLE IF NOT EXISTS public.achievements (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug            text UNIQUE NOT NULL,
  name            text NOT NULL,
  description     text,
  icon_emoji      text,
  xp_reward       int NOT NULL DEFAULT 0,
  condition_type  text,
  is_active       boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS public.student_achievements (
  id             uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id     uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  achievement_id uuid NOT NULL REFERENCES public.achievements(id) ON DELETE CASCADE,
  awarded_at     timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, achievement_id)
);

CREATE TABLE IF NOT EXISTS public.topic_mastery (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id    uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  topic         text NOT NULL,
  level         text,
  mastery_score int NOT NULL DEFAULT 0,
  attempts      int NOT NULL DEFAULT 0,
  updated_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, topic)
);

-- =============================================================================
-- PLANNING / AI TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.assessments (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  parent_id         uuid,
  student_name      text,
  age               int,
  grade             text,
  experience        text,
  skills            jsonb,
  recommended_level text,
  saved_at          timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.learning_plans (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id  uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  parent_id   uuid,
  plan        jsonb,
  week_start  date,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- NOTIFICATIONS / BILLING TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.notifications (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    uuid NOT NULL,
  type       text NOT NULL,
  title      text NOT NULL,
  message    text,
  read       boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.subscriptions (
  id                     uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                uuid NOT NULL UNIQUE,
  stripe_customer_id     text,
  stripe_subscription_id text,
  plan                   text NOT NULL DEFAULT 'trial',
  status                 text NOT NULL DEFAULT 'trial',
  trial_ends_at          timestamptz,
  current_period_end     timestamptz,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.payments (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id          uuid,
  stripe_invoice_id text,
  amount           int,
  currency         text DEFAULT 'cad',
  status           text,
  created_at       timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- CLASSES / SCHOOL PORTAL TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.classes (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id  uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  school_id   uuid,
  name        text NOT NULL,
  grade       text,
  level       text,
  join_code   text UNIQUE NOT NULL,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.class_memberships (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id    uuid NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
  student_id  uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  joined_via  text,
  is_active   boolean NOT NULL DEFAULT true,
  joined_at   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (class_id, student_id)
);

CREATE TABLE IF NOT EXISTS public.class_invites (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id   uuid NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
  token      text UNIQUE NOT NULL,
  email      text,
  max_uses   int NOT NULL DEFAULT 100,
  use_count  int NOT NULL DEFAULT 0,
  used_at    timestamptz,
  expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.schools (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          text NOT NULL,
  board         text,
  address       text,
  contact_name  text,
  contact_email text,
  contact_phone text,
  license_type  text,
  license_count int NOT NULL DEFAULT 0,
  status        text NOT NULL DEFAULT 'active',
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.school_sessions (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  school_id        uuid REFERENCES public.schools(id) ON DELETE CASCADE,
  teacher_id       uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  date             date NOT NULL,
  start_time       text,
  duration_minutes int NOT NULL DEFAULT 90,
  grade_range      text,
  level            text,
  topic            text,
  instructor       text,
  capacity         int,
  location         text,
  student_count    int,
  status           text NOT NULL DEFAULT 'scheduled',
  notes            text,
  created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.session_attendance (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id       uuid NOT NULL REFERENCES public.school_sessions(id) ON DELETE CASCADE,
  student_name     text NOT NULL,
  grade            text,
  engagement_score int,
  notes            text
);

CREATE TABLE IF NOT EXISTS public.session_packs (
  id             uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id        uuid,
  pack_type      text,
  total_sessions int NOT NULL DEFAULT 0,
  sessions_used  int NOT NULL DEFAULT 0,
  created_at     timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- CERTIFICATES / SHARING TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.certificates (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id  uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  level       text NOT NULL,
  pdf_url     text,
  share_url   text,
  share_token text UNIQUE,
  issued_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.share_tokens (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  token         text UNIQUE NOT NULL,
  student_id    uuid REFERENCES public.profiles(id) ON DELETE CASCADE,
  resource_type text NOT NULL DEFAULT 'project',
  resource_id   uuid,
  metadata      jsonb,
  is_active     boolean NOT NULL DEFAULT true,
  expires_at    timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- AUDIT / RATE LIMITING TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     uuid,
  action      text NOT NULL,
  target_id   text,
  target_type text,
  metadata    jsonb,
  ip_address  text,
  user_agent  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.email_log (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    uuid,
  type       text,
  subject    text,
  status     text DEFAULT 'sent',
  sent_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.rate_limit_log (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    uuid,
  action     text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_profiles_user          ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_role          ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_leaderboard   ON public.profiles(role, leaderboard_opt_out, total_xp DESC);
CREATE INDEX IF NOT EXISTS idx_psl_parent             ON public.parent_student_links(parent_id);
CREATE INDEX IF NOT EXISTS idx_psl_student            ON public.parent_student_links(student_id);
CREATE INDEX IF NOT EXISTS idx_lessons_level          ON public.lessons(level, sort_order);
CREATE INDEX IF NOT EXISTS idx_lessons_category       ON public.lessons(category);
CREATE INDEX IF NOT EXISTS idx_projects_level         ON public.projects(level, sort_order);
CREATE INDEX IF NOT EXISTS idx_quizzes_level          ON public.quizzes(level);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_quiz    ON public.quiz_questions(quiz_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_student ON public.lesson_progress(student_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_student  ON public.quiz_attempts(student_id);
CREATE INDEX IF NOT EXISTS idx_project_subs_student   ON public.project_submissions(student_id);
CREATE INDEX IF NOT EXISTS idx_student_ach_student    ON public.student_achievements(student_id);
CREATE INDEX IF NOT EXISTS idx_topic_mastery_student  ON public.topic_mastery(student_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user     ON public.notifications(user_id, read);
CREATE INDEX IF NOT EXISTS idx_subscriptions_user     ON public.subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_classes_teacher        ON public.classes(teacher_id);
CREATE INDEX IF NOT EXISTS idx_class_memberships_class ON public.class_memberships(class_id);
CREATE INDEX IF NOT EXISTS idx_class_memberships_student ON public.class_memberships(student_id);
CREATE INDEX IF NOT EXISTS idx_email_consents_user    ON public.email_consents(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created     ON public.audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_rate_limit_lookup      ON public.rate_limit_log(user_id, action, created_at DESC);

-- =============================================================================
-- HELPER FUNCTIONS (SECURITY DEFINER — used in RLS to avoid recursion)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.current_profile_id()
RETURNS uuid LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT id FROM public.profiles WHERE user_id = auth.uid() LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.profiles WHERE user_id = auth.uid() AND role = 'admin');
$$;

CREATE OR REPLACE FUNCTION public.is_parent_of(p_student uuid)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.parent_student_links l
    JOIN public.profiles pp ON pp.id = l.parent_id
    WHERE l.student_id = p_student AND pp.user_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.is_teacher_of(p_student uuid)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.class_memberships cm
    JOIN public.classes c   ON c.id = cm.class_id
    JOIN public.profiles tp ON tp.id = c.teacher_id
    WHERE cm.student_id = p_student
      AND cm.is_active = true
      AND tp.user_id = auth.uid()
  );
$$;

-- =============================================================================
-- COMPAT VIEW: student_profiles
-- Maps the profiles + parent_student_links model into the legacy shape used by
-- some parent-facing pages (parent_id = the parent's auth user id).
-- =============================================================================

CREATE OR REPLACE VIEW public.student_profiles
WITH (security_invoker = true) AS
SELECT
  sp.id                                                              AS id,
  pp.user_id                                                         AS parent_id,
  NULL::uuid                                                         AS teacher_id,
  COALESCE(sp.display_name, 'Student')                               AS full_name,
  CASE
    WHEN sp.date_of_birth IS NOT NULL
      THEN date_part('year', age(sp.date_of_birth))::int
    ELSE NULL
  END                                                                AS age,
  sp.grade                                                           AS grade,
  sp.level                                                           AS level,
  sp.total_xp                                                        AS xp_points,
  sp.current_streak                                                  AS streak_days,
  sp.xp_multiplier                                                   AS xp_multiplier,
  sp.visibility                                                      AS visibility,
  sp.avatar_emoji                                                    AS avatar_emoji,
  sp.created_at                                                      AS created_at,
  sp.updated_at                                                      AS updated_at
FROM public.parent_student_links l
JOIN public.profiles sp ON sp.id = l.student_id
JOIN public.profiles pp ON pp.id = l.parent_id;

-- =============================================================================
-- TRIGGER FUNCTIONS
-- =============================================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DO $$ BEGIN
  CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TRIGGER trg_lesson_progress_updated_at BEFORE UPDATE ON public.lesson_progress
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TRIGGER trg_project_submissions_updated_at BEFORE UPDATE ON public.project_submissions
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TRIGGER trg_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- handle_new_user — creates users + profiles rows on every auth signup.
-- Parents/teachers get a 14-day trial. Children (role=student) do not.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_role user_role;
  v_name text;
BEGIN
  v_role := COALESCE((NEW.raw_user_meta_data->>'role')::user_role, 'parent');
  v_name := COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'display_name', '');

  INSERT INTO public.users (id, email, full_name, role)
  VALUES (NEW.id, NEW.email, v_name, v_role)
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.profiles (user_id, email, display_name, role, subscription_plan, subscription_status, trial_ends_at)
  VALUES (
    NEW.id,
    NEW.email,
    v_name,
    v_role,
    CASE WHEN v_role IN ('parent', 'teacher') THEN 'trial' ELSE NULL END,
    CASE WHEN v_role IN ('parent', 'teacher') THEN 'trial' ELSE NULL END,
    CASE WHEN v_role IN ('parent', 'teacher') THEN now() + interval '14 days' ELSE NULL END
  )
  ON CONFLICT (user_id) DO NOTHING;

  IF v_role IN ('parent', 'teacher') THEN
    INSERT INTO public.subscriptions (user_id, plan, status, trial_ends_at)
    VALUES (NEW.id, 'trial', 'trial', now() + interval '14 days')
    ON CONFLICT (user_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_on_auth_user_created ON auth.users;
CREATE TRIGGER trg_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =============================================================================
-- BUSINESS LOGIC FUNCTIONS
-- =============================================================================

-- award_xp (2-arg) — applies streak multiplier and adds XP to a student profile.
CREATE OR REPLACE FUNCTION public.award_xp(p_student_id uuid, p_base_xp int)
RETURNS int LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_streak     int;
  v_multiplier numeric := 1.0;
  v_xp         int;
BEGIN
  SELECT current_streak, xp_multiplier INTO v_streak, v_multiplier
  FROM public.profiles WHERE id = p_student_id;

  IF NOT FOUND THEN RETURN 0; END IF;

  IF v_streak >= 30 THEN v_multiplier := 2.0;
  ELSIF v_streak >= 14 THEN v_multiplier := 1.5;
  ELSIF v_streak >= 7 THEN v_multiplier := 1.25;
  END IF;

  v_xp := GREATEST(1, ROUND(p_base_xp * v_multiplier)::int);

  UPDATE public.profiles
  SET total_xp = total_xp + v_xp, updated_at = now()
  WHERE id = p_student_id;

  RETURN v_xp;
END;
$$;

-- award_xp (4-arg overload) — same logic; accepts a source label/id for callers.
CREATE OR REPLACE FUNCTION public.award_xp(
  p_student_id uuid, p_xp int, p_source text, p_source_id uuid
)
RETURNS int LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  RETURN public.award_xp(p_student_id, p_xp);
END;
$$;

-- update_streak — recomputes a student's streak based on activity timing.
CREATE OR REPLACE FUNCTION public.update_streak(p_student_id uuid)
RETURNS int LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_last  timestamptz;
  v_streak int;
BEGIN
  SELECT last_active_at, current_streak INTO v_last, v_streak
  FROM public.profiles WHERE id = p_student_id;

  IF NOT FOUND THEN RETURN 0; END IF;

  IF v_last IS NULL THEN
    v_streak := 1;
  ELSIF v_last::date = current_date THEN
    v_streak := GREATEST(v_streak, 1);
  ELSIF v_last::date = current_date - 1 THEN
    v_streak := v_streak + 1;
  ELSE
    v_streak := 1;
  END IF;

  UPDATE public.profiles
  SET current_streak = v_streak,
      last_active_at = now(),
      xp_multiplier = CASE
        WHEN v_streak >= 30 THEN 2.0
        WHEN v_streak >= 14 THEN 1.5
        WHEN v_streak >= 7  THEN 1.25
        ELSE 1.0
      END,
      updated_at = now()
  WHERE id = p_student_id;

  RETURN v_streak;
END;
$$;

-- check_level_completion — true when student met lesson+quiz thresholds.
CREATE OR REPLACE FUNCTION public.check_level_completion(p_student_id uuid)
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_level         text;
  v_total_lessons int;
  v_done_lessons  int;
  v_total_quizzes int;
  v_passed        int;
BEGIN
  SELECT level INTO v_level FROM public.profiles WHERE id = p_student_id;
  IF NOT FOUND THEN RETURN false; END IF;

  SELECT COUNT(*) INTO v_total_lessons FROM public.lessons WHERE level = v_level AND is_visible;
  IF v_total_lessons = 0 THEN RETURN false; END IF;

  SELECT COUNT(*) INTO v_done_lessons
  FROM public.lesson_progress lp JOIN public.lessons l ON l.id = lp.lesson_id
  WHERE lp.student_id = p_student_id AND lp.status = 'completed' AND l.level = v_level AND l.is_visible;

  SELECT COUNT(*) INTO v_total_quizzes FROM public.quizzes WHERE level = v_level AND is_visible;

  IF v_total_quizzes = 0 THEN
    RETURN (v_done_lessons::numeric / v_total_lessons) >= 0.8;
  END IF;

  SELECT COUNT(*) INTO v_passed FROM (
    SELECT DISTINCT ON (qa.quiz_id) qa.passed
    FROM public.quiz_attempts qa JOIN public.quizzes q ON q.id = qa.quiz_id
    WHERE qa.student_id = p_student_id AND q.level = v_level AND q.is_visible
    ORDER BY qa.quiz_id, qa.created_at DESC
  ) latest WHERE latest.passed;

  RETURN (v_done_lessons::numeric / v_total_lessons) >= 0.8
     AND (v_passed::numeric / v_total_quizzes) >= 0.7;
END;
$$;

-- join_class_by_code — current student joins a class by its join code.
CREATE OR REPLACE FUNCTION public.join_class_by_code(p_code text)
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_class   uuid;
  v_student uuid;
BEGIN
  v_student := public.current_profile_id();
  IF v_student IS NULL THEN RETURN false; END IF;

  SELECT id INTO v_class FROM public.classes WHERE join_code = upper(p_code) AND is_active;
  IF v_class IS NULL THEN RETURN false; END IF;

  INSERT INTO public.class_memberships (class_id, student_id, joined_via)
  VALUES (v_class, v_student, 'code')
  ON CONFLICT (class_id, student_id) DO UPDATE SET is_active = true;

  RETURN true;
END;
$$;

-- join_class_by_token — current student joins via an invite token.
CREATE OR REPLACE FUNCTION public.join_class_by_token(p_token text)
RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_invite  public.class_invites%ROWTYPE;
  v_student uuid;
BEGIN
  v_student := public.current_profile_id();
  IF v_student IS NULL THEN RETURN false; END IF;

  SELECT * INTO v_invite FROM public.class_invites WHERE token = p_token;
  IF NOT FOUND THEN RETURN false; END IF;
  IF v_invite.expires_at IS NOT NULL AND v_invite.expires_at < now() THEN RETURN false; END IF;
  IF v_invite.use_count >= v_invite.max_uses THEN RETURN false; END IF;

  INSERT INTO public.class_memberships (class_id, student_id, joined_via)
  VALUES (v_invite.class_id, v_student, 'invite')
  ON CONFLICT (class_id, student_id) DO UPDATE SET is_active = true;

  UPDATE public.class_invites
  SET use_count = use_count + 1,
      used_at = COALESCE(used_at, now())
  WHERE id = v_invite.id;

  RETURN true;
END;
$$;

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE public.users               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_profiles     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teacher_profiles    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_student_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_consents      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consent_records     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parental_consents   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_progress     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.topic_mastery       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assessments         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_plans      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classes             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_memberships   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_invites       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schools             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.school_sessions     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_attendance  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_packs       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.certificates        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.share_tokens        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_log           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rate_limit_log      ENABLE ROW LEVEL SECURITY;

-- ---- users ----
DROP POLICY IF EXISTS users_self ON public.users;
CREATE POLICY users_self ON public.users FOR SELECT USING (id = auth.uid() OR public.is_admin());
DROP POLICY IF EXISTS users_update_self ON public.users;
CREATE POLICY users_update_self ON public.users FOR UPDATE USING (id = auth.uid());

-- ---- profiles ----
DROP POLICY IF EXISTS profiles_select ON public.profiles;
CREATE POLICY profiles_select ON public.profiles FOR SELECT
  USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_parent_of(id)
    OR public.is_teacher_of(id)
    OR (role = 'student' AND leaderboard_opt_out = false)  -- leaderboard visibility
  );
DROP POLICY IF EXISTS profiles_update_self ON public.profiles;
CREATE POLICY profiles_update_self ON public.profiles FOR UPDATE
  USING (user_id = auth.uid() OR public.is_admin());
DROP POLICY IF EXISTS profiles_insert_self ON public.profiles;
CREATE POLICY profiles_insert_self ON public.profiles FOR INSERT
  WITH CHECK (user_id = auth.uid() OR public.is_admin());

-- ---- parent_profiles / teacher_profiles ----
DROP POLICY IF EXISTS parent_profiles_own ON public.parent_profiles;
CREATE POLICY parent_profiles_own ON public.parent_profiles FOR ALL USING (user_id = auth.uid());
DROP POLICY IF EXISTS teacher_profiles_own ON public.teacher_profiles;
CREATE POLICY teacher_profiles_own ON public.teacher_profiles FOR ALL USING (user_id = auth.uid());

-- ---- parent_student_links ----
DROP POLICY IF EXISTS psl_parent ON public.parent_student_links;
CREATE POLICY psl_parent ON public.parent_student_links FOR ALL
  USING (parent_id = public.current_profile_id() OR public.is_admin());

-- ---- consents ----
DROP POLICY IF EXISTS email_consents_own ON public.email_consents;
CREATE POLICY email_consents_own ON public.email_consents FOR ALL USING (user_id = auth.uid());
DROP POLICY IF EXISTS consent_records_own ON public.consent_records;
CREATE POLICY consent_records_own ON public.consent_records FOR ALL
  USING (user_id = auth.uid() OR consented_by = auth.uid() OR public.is_admin());
DROP POLICY IF EXISTS parental_consents_own ON public.parental_consents;
CREATE POLICY parental_consents_own ON public.parental_consents FOR ALL
  USING (parent_user_id = auth.uid() OR public.is_admin());

-- ---- curriculum (read for authenticated, manage for admin) ----
DROP POLICY IF EXISTS lessons_read ON public.lessons;
CREATE POLICY lessons_read ON public.lessons FOR SELECT USING (is_visible AND auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS lessons_admin ON public.lessons;
CREATE POLICY lessons_admin ON public.lessons FOR ALL USING (public.is_admin());

DROP POLICY IF EXISTS projects_read ON public.projects;
CREATE POLICY projects_read ON public.projects FOR SELECT USING (is_visible AND auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS projects_admin ON public.projects;
CREATE POLICY projects_admin ON public.projects FOR ALL USING (public.is_admin());

DROP POLICY IF EXISTS quizzes_read ON public.quizzes;
CREATE POLICY quizzes_read ON public.quizzes FOR SELECT USING (is_visible AND auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS quizzes_admin ON public.quizzes;
CREATE POLICY quizzes_admin ON public.quizzes FOR ALL USING (public.is_admin());

DROP POLICY IF EXISTS quiz_questions_read ON public.quiz_questions;
CREATE POLICY quiz_questions_read ON public.quiz_questions FOR SELECT USING (auth.uid() IS NOT NULL);
DROP POLICY IF EXISTS quiz_questions_admin ON public.quiz_questions;
CREATE POLICY quiz_questions_admin ON public.quiz_questions FOR ALL USING (public.is_admin());

-- ---- progress / activity (student self, parent, teacher, admin) ----
DROP POLICY IF EXISTS lesson_progress_access ON public.lesson_progress;
CREATE POLICY lesson_progress_access ON public.lesson_progress FOR ALL
  USING (student_id = public.current_profile_id() OR public.is_parent_of(student_id) OR public.is_teacher_of(student_id) OR public.is_admin());

DROP POLICY IF EXISTS quiz_attempts_access ON public.quiz_attempts;
CREATE POLICY quiz_attempts_access ON public.quiz_attempts FOR ALL
  USING (student_id = public.current_profile_id() OR public.is_parent_of(student_id) OR public.is_teacher_of(student_id) OR public.is_admin());

DROP POLICY IF EXISTS project_subs_access ON public.project_submissions;
CREATE POLICY project_subs_access ON public.project_submissions FOR ALL
  USING (student_id = public.current_profile_id() OR public.is_parent_of(student_id) OR public.is_teacher_of(student_id) OR public.is_admin());

DROP POLICY IF EXISTS student_ach_access ON public.student_achievements;
CREATE POLICY student_ach_access ON public.student_achievements FOR ALL
  USING (student_id = public.current_profile_id() OR public.is_parent_of(student_id) OR public.is_teacher_of(student_id) OR public.is_admin());

DROP POLICY IF EXISTS topic_mastery_access ON public.topic_mastery;
CREATE POLICY topic_mastery_access ON public.topic_mastery FOR ALL
  USING (student_id = public.current_profile_id() OR public.is_parent_of(student_id) OR public.is_teacher_of(student_id) OR public.is_admin());

-- ---- achievements (read all) ----
DROP POLICY IF EXISTS achievements_read ON public.achievements;
CREATE POLICY achievements_read ON public.achievements FOR SELECT USING (true);
DROP POLICY IF EXISTS achievements_admin ON public.achievements;
CREATE POLICY achievements_admin ON public.achievements FOR ALL USING (public.is_admin());

-- ---- assessments / learning_plans (parent owns) ----
DROP POLICY IF EXISTS assessments_own ON public.assessments;
CREATE POLICY assessments_own ON public.assessments FOR ALL USING (parent_id = auth.uid() OR public.is_admin());
DROP POLICY IF EXISTS learning_plans_own ON public.learning_plans;
CREATE POLICY learning_plans_own ON public.learning_plans FOR ALL
  USING (parent_id = auth.uid() OR student_id = public.current_profile_id() OR public.is_admin());

-- ---- notifications / subscriptions / payments ----
DROP POLICY IF EXISTS notifications_own ON public.notifications;
CREATE POLICY notifications_own ON public.notifications FOR ALL USING (user_id = auth.uid());
DROP POLICY IF EXISTS subscriptions_own ON public.subscriptions;
CREATE POLICY subscriptions_own ON public.subscriptions FOR SELECT USING (user_id = auth.uid() OR public.is_admin());
DROP POLICY IF EXISTS payments_own ON public.payments;
CREATE POLICY payments_own ON public.payments FOR SELECT USING (user_id = auth.uid() OR public.is_admin());

-- ---- classes / memberships / invites ----
DROP POLICY IF EXISTS classes_teacher ON public.classes;
CREATE POLICY classes_teacher ON public.classes FOR ALL
  USING (teacher_id = public.current_profile_id() OR public.is_admin());
DROP POLICY IF EXISTS classes_member_read ON public.classes;
CREATE POLICY classes_member_read ON public.classes FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.class_memberships cm WHERE cm.class_id = id AND cm.student_id = public.current_profile_id()));

DROP POLICY IF EXISTS memberships_access ON public.class_memberships;
CREATE POLICY memberships_access ON public.class_memberships FOR ALL
  USING (
    student_id = public.current_profile_id()
    OR public.is_admin()
    OR EXISTS (SELECT 1 FROM public.classes c WHERE c.id = class_id AND c.teacher_id = public.current_profile_id())
  );

DROP POLICY IF EXISTS invites_teacher ON public.class_invites;
CREATE POLICY invites_teacher ON public.class_invites FOR ALL
  USING (
    public.is_admin()
    OR EXISTS (SELECT 1 FROM public.classes c WHERE c.id = class_id AND c.teacher_id = public.current_profile_id())
  );
DROP POLICY IF EXISTS invites_public_read ON public.class_invites;
CREATE POLICY invites_public_read ON public.class_invites FOR SELECT USING (true);

-- ---- schools / sessions (teachers + admins) ----
DROP POLICY IF EXISTS schools_staff ON public.schools;
CREATE POLICY schools_staff ON public.schools FOR ALL
  USING (public.is_admin() OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.user_id = auth.uid() AND p.role IN ('teacher','admin')));
DROP POLICY IF EXISTS sessions_staff ON public.school_sessions;
CREATE POLICY sessions_staff ON public.school_sessions FOR ALL
  USING (public.is_admin() OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.user_id = auth.uid() AND p.role IN ('teacher','admin')));
DROP POLICY IF EXISTS attendance_staff ON public.session_attendance;
CREATE POLICY attendance_staff ON public.session_attendance FOR ALL
  USING (public.is_admin() OR EXISTS (SELECT 1 FROM public.profiles p WHERE p.user_id = auth.uid() AND p.role IN ('teacher','admin')));
DROP POLICY IF EXISTS session_packs_own ON public.session_packs;
CREATE POLICY session_packs_own ON public.session_packs FOR ALL USING (user_id = auth.uid() OR public.is_admin());

-- ---- certificates ----
DROP POLICY IF EXISTS certificates_access ON public.certificates;
CREATE POLICY certificates_access ON public.certificates FOR ALL
  USING (student_id = public.current_profile_id() OR public.is_parent_of(student_id) OR public.is_admin());

-- ---- share_tokens (public read for sharing, owner manage) ----
DROP POLICY IF EXISTS share_tokens_public_read ON public.share_tokens;
CREATE POLICY share_tokens_public_read ON public.share_tokens FOR SELECT USING (true);
DROP POLICY IF EXISTS share_tokens_owner ON public.share_tokens;
CREATE POLICY share_tokens_owner ON public.share_tokens FOR ALL
  USING (student_id = public.current_profile_id() OR public.is_admin());

-- ---- audit logs / email log / rate limit (admin read; service writes) ----
DROP POLICY IF EXISTS audit_admin_read ON public.audit_logs;
CREATE POLICY audit_admin_read ON public.audit_logs FOR SELECT USING (public.is_admin());
DROP POLICY IF EXISTS audit_insert ON public.audit_logs;
CREATE POLICY audit_insert ON public.audit_logs FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS email_log_admin ON public.email_log;
CREATE POLICY email_log_admin ON public.email_log FOR SELECT USING (public.is_admin());
DROP POLICY IF EXISTS email_log_insert ON public.email_log;
CREATE POLICY email_log_insert ON public.email_log FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS rate_limit_all ON public.rate_limit_log;
CREATE POLICY rate_limit_all ON public.rate_limit_log FOR ALL USING (true) WITH CHECK (true);

-- =============================================================================
-- ACHIEVEMENT SEEDS
-- =============================================================================

INSERT INTO public.achievements (slug, name, description, icon_emoji, xp_reward, condition_type, is_active) VALUES
  ('first_lesson',              'First Code!',        'Completed your very first lesson',           '🎓', 50,  'lesson_complete',    true),
  ('first_quiz',                'Quiz Starter',       'Completed your first quiz',                  '📝', 50,  'quiz_complete',      true),
  ('quiz_star',                 'Quiz Star',          'Passed 10 quizzes',                          '🌟', 150, 'quiz_count',         true),
  ('first_project',             'Builder Begins',     'Submitted your first project',              '🔨', 50,  'project_submit',     true),
  ('streak_3',                  '3-Day Streak',       'Learned 3 days in a row',                    '✨', 60,  'streak_days',        true),
  ('streak_7',                  '7-Day Streak',       'Learned every day for 7 days in a row',      '🔥', 100, 'streak_days',        true),
  ('streak_14',                 '14-Day Streak',      'Kept going for 14 days straight',            '⚡', 200, 'streak_days',        true),
  ('streak_30',                 '30-Day Streak',      'An unstoppable 30-day learning streak',      '🏆', 500, 'streak_days',        true),
  ('level_complete_explorers',  'Explorer Graduate',  'Completed the Explorers level',              '🚀', 300, 'level_complete',     true),
  ('level_complete_builders',   'Builder Graduate',   'Completed the Builders level',               '🏗️', 400, 'level_complete',     true),
  ('level_complete_developers', 'Developer Graduate', 'Completed the Developers level',             '💻', 500, 'level_complete',     true),
  ('level_complete_engineers',  'Engineer Graduate',  'Completed the Engineers level',              '⚙️', 750, 'level_complete',     true),
  ('quiz_perfect',              'Perfect Score',      'Got 100% on any quiz',                       '⭐', 150, 'quiz_perfect_score', true),
  ('xp_1000',                   'XP Milestone 1,000', 'Earned 1,000 total XP points',               '💎', 100, 'total_xp',           true),
  ('xp_5000',                   'XP Milestone 5,000', 'Earned 5,000 total XP points',               '👑', 500, 'total_xp',           true),
  ('share_project',             'Show and Tell',      'Shared a project with others',              '📢', 75,  'project_share',      true),
  ('night_owl',                 'Night Owl',          'Completed a lesson after 9 PM',              '🦉', 50,  'time_of_day',        true)
ON CONFLICT (slug) DO NOTHING;
