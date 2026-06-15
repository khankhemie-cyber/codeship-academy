-- =============================================================================
-- CODEship Academy — Consolidated Setup (auto-generated)
-- Paste this entire file into the Supabase SQL Editor and run once.
-- It runs schema.sql + all curriculum files in the correct order.
-- Idempotent: safe to re-run.
-- =============================================================================


-- >>>>>>>>>>>>>>>>>>>>>>>> schema.sql >>>>>>>>>>>>>>>>>>>>>>>>

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


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-explorers.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Explorers Level Lessons (K-1, Ages 6-7)
-- 25 lessons: exp-l01 through exp-l25
-- Run after schema.sql and curriculum.sql
-- =============================================================================

INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('exp-l01', 'What Is a Computer? (And Why It''s Amazing)', 'explorers', 'Fundamentals', 'en', 'beginner', 20, 100, 1,
'## What Is a Computer? 🖥️

A computer is an amazing machine that can follow instructions super fast! Computers help us learn, play, draw, and so much more.

### What Makes a Computer Special?
A computer can remember lots and lots of information — way more than we can! It can also do maths problems in a split second. And best of all, it does exactly what you tell it to do.

### Parts of a Computer
- **Screen (Monitor):** This is where you see everything. It''s like the computer''s face! 👀
- **Keyboard:** This is where you type letters and numbers. It has all 26 letters of the alphabet!
- **Mouse:** You move this to point and click on things. 🖱️
- **Tower or Laptop Body:** This is the brain of the computer. All the smart stuff happens inside here!

### How Do Computers Help Us Every Day?
Computers help doctors keep people healthy. They help pilots fly aeroplanes. They help teachers make lessons fun. Even your favourite cartoons are made with computers!

### Activity: Computer Hunt! 🔍
Look around your room or your home. Can you find **3 things** that are computers or have computers inside them? Here is a hint: your TV, microwave, and some toys all have tiny computers inside!

Draw a picture of each thing you find. Share it with someone you love!

### Fun Fact 🚀
The phone in your pocket is more powerful than the computers that sent astronauts to the Moon in 1969! Technology has come such a long way.

### What Did You Learn Today?
- A computer is a machine that follows instructions
- Computers have a screen, keyboard, mouse, and a brain
- Computers help people in almost every job
- Computers are hidden inside many everyday objects'),

('exp-l02', 'Computers Are Hiding Everywhere!', 'explorers', 'Fundamentals', 'en', 'beginner', 20, 100, 2,
'## Computers Are Hiding Everywhere! 🔍

Did you know that computers are not just on desks? They are hiding in places you might never expect!

### Computers in Your Home 🏠
Look around your kitchen — your microwave has a tiny computer inside that counts down the time. Your fridge might even tell you when you are running out of milk! The washing machine knows exactly how long to wash your clothes. Even some lightbulbs can be controlled by a computer now!

### Computers in Your School 🏫
Your school is full of computers. There are computers in the classroom for learning. The library might have computers to help you find books. Even the school printer has a little computer telling it what to print!

### Computers in Your Neighbourhood 🌆
When you go outside, computers are everywhere too! Traffic lights use computers to decide when to turn green or red. Shops use computers called cash registers to add up prices. ATM machines (the ones that give out money) are computers too!

### The Tiny Computers Called Chips 🔬
The computers inside everyday things are very, very small — they are called **microchips**. A microchip can be smaller than your fingernail, but it can do millions of calculations every second!

### Activity: The Computer Hunt Game 🕵️
Today you are a Computer Detective! Walk around your home with a grown-up and try to find as many hidden computers as you can. Make a list or draw pictures of everything you find.

**Hint list to get you started:**
- Microwave oven
- Television
- Tablet or phone
- Game controller
- Digital clock
- Car dashboard
- Toy robot

How many did you find? Could you find more than 10?

### Fun Fact 🤯
Every single day, more than **4 billion people** use a computer or phone. That is more than half of all the people on Earth!

### What Did You Learn Today?
- Computers are hidden inside many everyday objects
- Tiny computers called microchips make everyday things smart
- Traffic lights, fridges, and washing machines all have computers
- We use computers in almost every part of our lives'),

('exp-l03', 'How Computers Think: Input, Process, Output', 'explorers', 'Fundamentals', 'en', 'beginner', 20, 100, 3,
'## How Computers Think 🧠

Computers think in a very organised way. Every single thing a computer does follows three steps: **Input → Process → Output**. Let''s find out what each step means!

### Step 1: Input — Telling the Computer Something 📥
Input is information that **goes IN** to the computer. When you type a letter on the keyboard, that is input. When you click the mouse, that is input. When you touch a touchscreen, that is input!

Think of input like telling your friend what game you want to play. You are giving them information.

### Step 2: Process — The Computer Thinks 🔄
Processing is what happens **inside** the computer. The computer takes your input and figures out what to do with it. This happens super fast — in less than a second!

Think of processing like your friend thinking about what you said and deciding what to do next.

### Step 3: Output — The Computer Tells You Something 📤
Output is information that **comes OUT** of the computer. When you see words appear on the screen, that is output. When music plays from the speakers, that is output. When a printer prints a page, that is output!

Think of output like your friend answering you or starting to play the game.

### Real Life Examples 🌟
| Input | Process | Output |
|-------|---------|--------|
| You press a key | Computer reads the letter | Letter appears on screen |
| You click "play" | Computer finds the video | Video plays on screen |
| You ask a question | Computer searches for answer | Answer appears on screen |

### Activity: Be a Human Computer! 🤖
Play this game with a friend or family member:
1. One person is the **Input** — they whisper a number (like 5) to the middle person
2. One person is the **Process** — they add 10 to the number (5 + 10 = 15)
3. One person is the **Output** — they say the answer out loud (15!)

Take turns being each part of the computer!

### Fun Fact 💡
Your brain works in a similar way! Your eyes and ears are your **inputs**, your brain is the **processor**, and your voice and hands are the **outputs**!

### What Did You Learn Today?
- Input is information that goes INTO a computer
- Processing is when the computer thinks about that information
- Output is the result that comes OUT of the computer
- Your brain works in a similar way!'),

('exp-l04', 'Meet the Coders: People Who Change the World', 'explorers', 'Fundamentals', 'en', 'beginner', 20, 100, 4,
'## Meet the Coders! 🌍

People who write instructions for computers are called **coders** or **programmers**. Coders are some of the most creative and important people in the world today!

### What Do Coders Actually Do? 💻
Coders write special instructions (called **code**) that tell computers what to do. These instructions are written in special languages that computers can understand. Coders built the websites you visit, the games you play, and the apps on phones and tablets!

### Amazing Coders from History 🏆

**Ada Lovelace** lived in the 1800s — before computers even existed! She wrote the very first computer program ever. She imagined that machines could do amazing things, and she was right! People call her the **Mother of Computing**.

**Grace Hopper** was a brilliant scientist who helped build some of the first real computers. She invented a way to write code using English words instead of just numbers. She also found the very first computer bug — it was an actual moth stuck inside the computer! 🦋

**Alan Turing** was a mathematician who helped crack secret codes during a big war. He also imagined how computers could one day think like humans. He is called the **Father of Computer Science**.

### Coders Today 🌐
Today, coders build:
- 🎮 **Video games** that millions of people play
- 📱 **Apps** that help people communicate and learn
- 🏥 **Medical software** that helps doctors save lives
- 🚗 **Self-driving cars** that can drive themselves
- 🤖 **Robots** that explore space and the deep ocean

### Activity: Draw Your Dream App! 🎨
If you could build ANY app, what would it do? Draw a picture of your dream app on paper. What would it look like? What could it do? Would it help people? Would it be fun?

Share your drawing and explain your idea to someone!

### Fun Fact ✨
There are more than **26 million coders** in the world today. And the world needs millions more! Maybe YOU will be one of them!

### What Did You Learn Today?
- Coders write instructions that tell computers what to do
- Ada Lovelace wrote the first computer program ever
- Grace Hopper and Alan Turing changed the world with their ideas
- Coders build games, apps, medical tools, and so much more'),

('exp-l05', 'Patterns: The Secret Language of Computers', 'explorers', 'Algorithms', 'en', 'beginner', 25, 100, 5,
'## Patterns: The Secret Language! 🎨

Computers LOVE patterns! In fact, everything a computer does is based on patterns. Learning to spot and create patterns is one of the most important skills a coder can have!

### What Is a Pattern? 🔍
A pattern is something that **repeats** in a predictable way. Patterns can be made of colours, shapes, sounds, numbers, or even actions!

Look at this pattern: 🔴 🔵 🔴 🔵 🔴 🔵
Can you guess what comes next? Yes! 🔴

### Patterns Are Everywhere! 🌈
- The days of the week repeat every 7 days (Monday, Tuesday... Sunday, Monday...)
- Seasons follow a pattern (Spring, Summer, Autumn, Winter, Spring...)
- Your heartbeat is a pattern (beat, pause, beat, pause...)
- Zebra stripes are a pattern! 🦓
- Music is made of repeating patterns of sound

### Why Do Computers Love Patterns? 🤖
Computers look for patterns to understand information. When your face unlock app recognises you, it is comparing patterns in your face to patterns it has stored. When you get a song recommendation, the app found a pattern in the songs you like!

### Colour Patterns Activity 🖍️
Using crayons or coloured pencils, complete these patterns on paper:

1. 🔴 🟡 🔴 🟡 🔴 ___
2. 🟢 🟢 🔵 🟢 🟢 🔵 🟢 🟢 ___
3. ⭐ ⭐ 🌙 ⭐ ⭐ 🌙 ⭐ ___

Now CREATE your own pattern for a friend to continue!

### Shape Patterns 🔺
Patterns can also be made with shapes:
- Circle, Square, Circle, Square...
- Triangle, Triangle, Circle, Triangle, Triangle, Circle...
- Big, Small, Small, Big, Small, Small...

### Numbers Make Patterns Too! 🔢
- 2, 4, 6, 8, 10, ___  (add 2 each time)
- 1, 3, 5, 7, 9, ___  (odd numbers!)
- 10, 20, 30, 40, ___  (add 10 each time)

### Fun Fact 🌟
The word "algorithm" (which you will learn more about soon!) comes from a mathematician''s name. Algorithms are just very precise patterns of instructions!

### What Did You Learn Today?
- A pattern is something that repeats in a predictable way
- Patterns can be made of colours, shapes, sounds, and numbers
- Computers use patterns to recognise faces, recommend music, and more
- Spotting patterns is a superpower for coders!'),

('exp-l06', 'Step by Step: Why Order Matters', 'explorers', 'Algorithms', 'en', 'beginner', 25, 100, 6,
'## Step by Step: Order Matters! 📋

Have you ever tried to put your shoes on BEFORE your socks? It does not work! Order matters in real life, and it matters in computer coding too!

### What Is an Algorithm? 🤖
An **algorithm** is a set of instructions that are followed **in order**, step by step. Every recipe, every dance move, every game has an algorithm!

Programmers write algorithms to tell computers exactly what to do and in what order. If the order is wrong, the computer gets confused — just like putting shoes before socks!

### Making a Sandwich Algorithm 🥪
Let''s write an algorithm for making a sandwich:

1. Get two slices of bread
2. Open the jam jar
3. Pick up a knife
4. Spread jam on one slice of bread
5. Put the second slice of bread on top
6. Enjoy your sandwich! 😋

What would happen if we did step 5 before step 4? We would have a sandwich with no jam! Order matters!

### A Morning Routine Algorithm ☀️
Can you put these steps in the RIGHT order?
- Brush your teeth
- Wake up
- Put on clothes
- Eat breakfast
- Go to school
- Get out of bed

The order you do things matters for a good morning!

### Computers Follow Orders Exactly 🎯
Computers are very good at following instructions, but they follow them **exactly** — they do not guess or skip steps. If you forget a step, the computer will not figure it out on its own. It will just do what you told it, even if that is wrong!

### Activity: Write Your Own Algorithm! ✍️
Pick ONE of these activities and write the steps in order:
- How to wash your hands
- How to draw a smiley face
- How to get dressed
- How to play your favourite game

Try to be as specific as possible! Pretend you are giving instructions to a robot who has never done it before.

### Fun Fact 🌍
The word **algorithm** comes from the name of a brilliant mathematician called **Al-Khwarizmi** who lived over 1,000 years ago! He wrote important books about maths that helped people for centuries.

### What Did You Learn Today?
- An algorithm is a set of instructions followed in a specific order
- Order matters — doing things in the wrong order gives wrong results
- Computers follow instructions exactly, with no guessing
- Writing clear, ordered steps is a key coding skill'),

('exp-l07', 'Making Choices: If This, Then That!', 'explorers', 'Algorithms', 'en', 'beginner', 20, 100, 7,
'## Making Choices: If This, Then That! 🤔

Every day you make choices. "If it is raining, then I will take an umbrella." "If I am hungry, then I will have a snack." Computers make choices in exactly the same way!

### What Is an "If-Then" Rule? 💡
An **if-then** rule is a way of making decisions. It says:

**IF** (something is true) **THEN** (do this action)

This is one of the most important ideas in all of computer programming!

### Examples of If-Then Rules 🌟
- **IF** the light is red, **THEN** stop the car 🚗
- **IF** it is bedtime, **THEN** turn off the lights 🌙
- **IF** the score reaches 10, **THEN** the player wins! 🏆
- **IF** the phone battery is low, **THEN** show a warning 🔋

### Adding "Else" — The Other Choice 🔀
Sometimes we also have an **else** part:

**IF** (something is true) **THEN** (do this) **ELSE** (do that instead)

For example:
- **IF** it is sunny, **THEN** play outside **ELSE** play inside
- **IF** you have enough money, **THEN** buy the toy **ELSE** save up more

### Real Computer Examples 💻
Games use if-then rules all the time!
- IF the player touches the enemy, THEN lose a life
- IF the player collects all coins, THEN go to the next level
- IF the timer reaches zero, THEN game over!

### Activity: If-Then Sorting Game! 🎮
Read each rule and say what the computer should do:

1. **IF** it is raining **THEN** _______
2. **IF** the student scores 100% **THEN** _______
3. **IF** the door is locked **THEN** _______
4. **IF** you find the treasure **THEN** _______

Now make up 3 if-then rules of your own!

### Activity: Simon Says with If-Then! 🎭
Play this with friends:
- IF I say "Simon says" THEN do the action
- IF I do NOT say "Simon says" THEN stay still

You were just following an if-then rule!

### Fun Fact 🤖
Computers process millions of if-then decisions every single second. Your phone is constantly asking: "If the screen is touched here, then open this app. If the battery drops below 20%, then show a warning."

### What Did You Learn Today?
- If-then rules help computers (and us!) make decisions
- IF something is true, THEN the computer does an action
- ELSE is used when the condition is not true
- If-then rules are used in every computer program ever written'),

('exp-l08', 'Loops: Do It Again (and Again and Again!)', 'explorers', 'Algorithms', 'en', 'beginner', 25, 100, 8,
'## Loops: Do It Again! 🔁

What if you had to clap your hands 100 times? You would not count to 100 individually — you would just keep clapping! Computers use something called a **loop** to repeat things without writing the same instruction over and over.

### What Is a Loop? 🔄
A **loop** is an instruction that makes a computer repeat something. Instead of writing the same instruction 100 times, you just say "do this 100 times" — and the computer does it!

### Types of Loops 🌀

**Count Loops** — repeat a specific number of times:
- Clap 5 times
- Jump 10 times
- Draw 20 circles

**Forever Loops** — repeat until something makes them stop:
- Keep playing music (until the user presses stop)
- Keep the game running (until the player loses)
- Keep blinking (until the power goes off)

### Loops in Real Life 🌍
- A merry-go-round goes around and around — that is a loop! 🎠
- The washing machine spin cycle repeats — that is a loop! 🌀
- A song chorus repeats — that is a loop! 🎵
- The seasons repeat every year — that is a loop! 🍂❄️🌸☀️

### Why Are Loops So Useful? 💡
Without loops, programmers would have to write out every single step. Imagine writing "move forward" 1,000 times for a character to walk across a screen! With a loop, you just write "move forward" ONE time and say "repeat 1000 times."

Loops save time and make code much shorter and cleaner!

### Activity: Human Loop! 🤸
Stand up and do this:
1. Clap hands — 1 time
2. Stomp feet — 2 times
3. Turn around — 1 time
4. **LOOP** — go back to step 1 and do it all 3 more times!

You just ran a loop with your body!

### Activity: Loop Drawing 🖍️
Draw the following with loops:
- A pattern of 5 circles in a row (loop: draw a circle, move right — repeat 5 times)
- A ladder with 6 rungs (loop: draw a rung, move up — repeat 6 times)

### Fun Fact ⚡
When computers run too many loops without stopping, it is called an **infinite loop** — the computer gets stuck going around and around forever! This is actually a common coding mistake that even professional programmers make.

### What Did You Learn Today?
- A loop makes a computer repeat an instruction
- Count loops repeat a specific number of times
- Forever loops repeat until something stops them
- Loops save time and make code shorter and smarter'),

('exp-l09', 'Binary: How Computers Count with 0 and 1', 'explorers', 'Fundamentals', 'en', 'beginner', 20, 100, 9,
'## Binary: The Language of 0s and 1s! 🔢

Computers are incredibly clever, but there is one amazing secret about them: **computers only know two things — 0 and 1!** Everything a computer does — every photo, every song, every word — is made of just these two numbers!

### Why Only 0 and 1? 💡
Inside a computer, there are billions of tiny switches called **transistors**. Each switch can be either OFF (0) or ON (1). By combining billions of these on/off switches, computers can represent any information in the world!

Think of it like light switches in your house:
- Light OFF = 0
- Light ON = 1

### The Binary Number System 🔢
We normally count using 10 digits (0, 1, 2, 3, 4, 5, 6, 7, 8, 9). This is called **decimal** or base-10.

Computers count using only 2 digits (0 and 1). This is called **binary** or base-2.

Here is how to count in binary:
- 0 = 0
- 1 = 1
- 2 = 10
- 3 = 11
- 4 = 100
- 5 = 101

### Decoding with Cards 🃏
Imagine you have 4 cards with these values: 8, 4, 2, 1

To make the number **5**, flip up the 4 card and the 1 card: 4 + 1 = 5
In binary, that is: 0101

To make the number **7**, flip up 4, 2, and 1: 4 + 2 + 1 = 7
In binary, that is: 0111

### Binary in Everyday Life 💻
- Every letter on your screen is stored as binary numbers
- Every colour in a photo is stored as binary
- Every note in a song is stored as binary
- Even this lesson is stored as billions of 0s and 1s!

### Activity: Binary Name Decoder! 🕵️
Using this simple code, can you write your initials in binary?
A=01, B=10, C=11, D=100, E=101

Write your first initial in binary. Now write it out as 0s and 1s on paper!

### Fun Fact 🌟
A single **bit** is one binary digit (0 or 1). Eight bits together make a **byte**. A single character like the letter "A" is stored as 1 byte (8 bits): 01000001

### What Did You Learn Today?
- Computers only understand 0 and 1 (binary)
- Inside computers, tiny switches are either OFF (0) or ON (1)
- Every photo, word, and song is made of binary numbers
- 8 bits = 1 byte, and bytes make up all computer data'),

('exp-l10', 'Keeping Safe Online: Your Digital Shield', 'explorers', 'Digital Citizenship', 'en', 'beginner', 20, 100, 10,
'## Keeping Safe Online! 🛡️

The internet is like a huge, exciting playground — but just like a real playground, there are some safety rules to follow. Your digital shield keeps you safe online!

### Rule 1: Keep Personal Information Private 🔒
Never share these things online:
- Your full name
- Your home address
- Your school name
- Your phone number
- Your photo (without a parent''s permission)

Think of personal information like a secret treasure — keep it hidden!

### Rule 2: Always Ask a Grown-Up First ✋
Before you:
- Click on a link
- Download something
- Visit a new website
- Talk to someone online

...always ask a trusted adult first! A good grown-up will help you stay safe.

### Rule 3: Not Everything Online Is True 🤔
Anyone can put information on the internet, and not all of it is correct. If you read something surprising or confusing, check with a grown-up or look it up in a book.

### Rule 4: Be Kind Online 💜
Online, treat others the way you want to be treated! Say kind words. Do not share anything mean about someone else. If someone is being unkind to you online, tell a trusted adult right away.

### Rule 5: Passwords Are Secret 🔑
A password is like a secret key to your online accounts. Keep your password private — do not share it with friends, even best friends! (Only share it with a parent or guardian.)

A good password is:
- Long (at least 8 characters)
- Has letters AND numbers
- Does NOT use your name or birthday

### The SMART Safety Rules 🌟
- **S** — Keep things **Safe**: do not share personal info
- **M** — Do not **Meet** people you only know online
- **A** — Do not **Accept** files from strangers
- **R** — Do not **Reply** to upsetting messages
- **T** — **Tell** a trusted adult if something feels wrong

### Activity: Safety Quiz! 📝
True or False?
1. It is okay to tell an online friend your home address. (False!)
2. I should tell a grown-up if something online makes me feel scared. (True!)
3. I can share my password with my best friend. (False!)
4. Not everything on the internet is true. (True!)

### Fun Fact 🔐
The most commonly used password in the world is "123456" — that is a very unsafe password! Good passwords are like secret codes that only you can crack.

### What Did You Learn Today?
- Keep personal information like your address private online
- Always ask a grown-up before clicking links or visiting new sites
- Be kind online — your words have power even through a screen
- Tell a trusted adult if anything online makes you feel worried'),

('exp-l11', 'What Is Coding? The Secret Language of Machines', 'explorers', 'Fundamentals', 'en', 'beginner', 20, 100, 11,
'## What Is Coding? 💻

Coding is writing instructions in a special language that computers can understand. It is the way humans and computers talk to each other!

### Why Do We Need Special Languages? 🗣️
Computers do not understand English, French, or any human language on their own. They understand their own special languages! These are called **programming languages**.

Just like you might learn French to talk to someone from France, programmers learn programming languages to talk to computers!

### Different Programming Languages 🌍
There are hundreds of programming languages! Each one is great for different things:

- **Scratch** — Uses colourful blocks to make games and stories (perfect for beginners!)
- **Python** — Used to build websites, analyse data, and create AI
- **JavaScript** — Makes websites interactive and fun
- **Swift** — Used to make iPhone and iPad apps
- **C++** — Used to make fast video games and robots

### What Does Code Look Like? 👀
Here is a very simple line of code in a language called Python:
```
print("Hello, World!")
```
This tells the computer to display the message "Hello, World!" on the screen. It is the first program almost every coder ever writes!

### From Idea to Code 💡
Every app, game, and website started as an idea in someone''s head. Then a coder:
1. Thought about what they wanted to create
2. Broke the idea down into small steps
3. Wrote those steps in a programming language
4. Tested it to make sure it worked
5. Fixed any mistakes (called **bugs**)
6. Shared it with the world!

### You Can Code Too! 🌟
You do not need to be a maths genius or a technology expert to code. You just need:
- Curiosity to learn new things
- Patience to try again when something does not work
- Creativity to come up with ideas
- Practice, practice, practice!

### Activity: Code a Friend! 🤖
Pretend your friend is a robot. You are the programmer! Give them these exact instructions to see if your "code" works:
1. Stand up
2. Turn to face the door
3. Take 3 steps forward
4. Clap 2 times
5. Say "Beep Boop!"

Did the robot follow your code correctly? Did you need to fix (debug) any instructions?

### Fun Fact 🚀
The first computer program was written in 1843 — more than 180 years ago! — by Ada Lovelace, before any actual computer existed.

### What Did You Learn Today?
- Coding means writing instructions in a language computers understand
- Programming languages include Scratch, Python, and JavaScript
- Every app and game was built by a coder writing code
- Anyone can learn to code with curiosity and practice!'),

('exp-l12', 'Hello Scratch Jr! Your First Code', 'explorers', 'Block Coding', 'en', 'beginner', 30, 100, 12,
'## Hello, Scratch Jr! 🐱

Welcome to Scratch Jr — the perfect place to start your coding adventure! Scratch Jr uses colourful picture blocks that you snap together like puzzle pieces to make characters move, talk, and dance!

### What Is Scratch Jr? 🎨
Scratch Jr is a free coding app designed especially for children aged 5-7. Instead of typing complicated words, you drag and drop colourful blocks. Each block does something different:

- 🟡 **Yellow blocks** — Start your code (like a green flag!)
- 🔵 **Blue blocks** — Move your character around
- 🟣 **Purple blocks** — Make sounds and music
- 🟢 **Green blocks** — Change how your character looks
- 🔴 **Red blocks** — Stop your code

### Your First Character: The Scratch Cat! 🐱
When you open Scratch Jr, you will see a friendly orange cat. This is the **Scratch Cat**! You can make the cat walk, jump, spin, talk, and so much more.

You can also add other characters called **sprites** — animals, people, vehicles, and more!

### Your First Program: Make the Cat Walk! 👣
Let us write your very first program! Here is what to do in Scratch Jr:

1. Open Scratch Jr on your tablet
2. Tap the green flag block (Start) and drag it to the scripting area
3. Drag a "Move Right" block and connect it to the flag
4. Tap the green flag to run your program
5. Watch the cat walk to the right! 🎉

Congratulations — you just wrote your first program!

### Adding More Blocks 🔧
Now let us make it more exciting:
1. After the Move Right block, add a "Jump" block
2. Then add a "Play Sound" block
3. Run your program and watch the cat walk, jump, and make a sound!

Each block is one instruction. Together, they make a program!

### The Scripting Area 🖥️
The scripting area is where you build your programs. Think of it like a blank page where you write your story — but instead of words, you use blocks!

### Activity: Make the Cat Dance! 💃
Try to make the Scratch Cat dance! Can you make it:
- Move right then left
- Spin around
- Jump up
- Make a sound

Experiment with different blocks and see what you discover! There is no wrong answer — just exploration!

### Fun Fact 🌍
Scratch Jr was created by MIT (a famous university) and is used by millions of children in over 150 countries around the world!

### What Did You Learn Today?
- Scratch Jr uses colourful picture blocks to create programs
- Different coloured blocks do different things
- You connect blocks together to write a program
- The Scratch Cat is your first character to animate!'),

('exp-l13', 'Loops in Scratch Jr: Make Things Repeat!', 'explorers', 'Block Coding', 'en', 'beginner', 25, 100, 13,
'## Loops in Scratch Jr! 🔁

Remember loops from lesson 8? Now it is time to use loops in a real program in Scratch Jr! Loops make characters repeat actions without you having to add the same block over and over.

### The Repeat Block 🔄
In Scratch Jr, there is a special block that makes other blocks repeat. It looks like a looping arrow! You put other blocks INSIDE the repeat block, and Scratch Jr will run those blocks again and again!

**Without a loop (long way):**
Move Right → Move Right → Move Right → Move Right → Move Right

**With a loop (smart way!):**
Repeat 5 times: Move Right

Both do the same thing, but the loop is much shorter and smarter!

### Types of Loops in Scratch Jr 🌀

**Number Loop** — Repeats a specific number of times:
- Repeat 3 times → spin
- Repeat 10 times → jump

**Forever Loop** — Repeats forever until you stop it:
- Great for making characters dance continuously!
- Great for making a background animation loop

### Activity: The Dancing Loop! 💃
Open Scratch Jr and try this:

1. Start block (green flag)
2. Forever loop block
3. Inside the loop: Move Right 2 steps
4. Inside the loop: Move Left 2 steps
5. Inside the loop: Play a sound
6. Run it and watch your character bounce left and right forever!

Press the red stop button to end the loop.

### Activity: The Spinning Star ⭐
Try making a star shape with a loop:
1. Start block
2. Repeat 4 times:
   - Move Right
   - Turn right 90 degrees

Watch your character trace a square pattern! (Bonus: change 4 to 6 and see what shape you get!)

### Challenge: Make a Character Walk Across the Screen! 🚶
Can you use a loop to make the Scratch Cat walk all the way from one side of the screen to the other?

Hint: Use a "Repeat" block with "Move Right" inside. How many times do you need to repeat to reach the other side? Experiment!

### Debugging Your Loop 🔧
If your loop does not do what you expected, try:
- Checking how many times you set the repeat
- Making sure the blocks are properly connected inside the loop
- Trying smaller numbers first to see what happens

### Fun Fact 🎮
Almost every video game uses loops! The game loop is what keeps checking "did the player press a button? did they collect a coin? is it game over?" — all happening many times every second!

### What Did You Learn Today?
- The Repeat block in Scratch Jr creates a loop
- Loops repeat blocks inside them again and again
- Forever loops keep going until you press stop
- Loops make your programs shorter and smarter!'),

('exp-l14', 'Characters and Stories: Making Digital Books', 'explorers', 'Creative Coding', 'en', 'beginner', 30, 100, 14,
'## Making Digital Stories! 📚

One of the most creative things you can do with code is tell stories! In Scratch Jr, you can make your own digital books and animations with characters, backgrounds, and even talking text!

### Stories Have Three Things 📖
Every great story has:
1. **Characters** — the people, animals, or creatures in the story
2. **Setting** — the place where the story happens
3. **Plot** — what happens in the story (beginning, middle, end)

In Scratch Jr, you can create all three with code!

### Pages in Scratch Jr 📄
Scratch Jr lets you create PAGES — like the pages of a book! Each page can have:
- A different background (forest, space, underwater, city...)
- Different characters doing different things
- Text that appears on screen

You can make characters walk, talk, and react on each page!

### Activity: My Three-Page Story! 📚

**Page 1: The Beginning**
- Choose a background (a house, a forest, or a school)
- Add a character
- Make the character walk in and say "Hello!"

**Page 2: The Middle**
- Change the background (somewhere the character travels to)
- Add something exciting — maybe another character, a problem to solve, or a treasure to find!

**Page 3: The End**
- Show the resolution — did the character solve the problem?
- Make everyone celebrate! (Try adding a jump and a sound!)

### Adding Text to Your Story ✏️
Scratch Jr has a text tool that lets you add words to the screen. Use it to:
- Add a title to your book
- Show what characters are saying
- Tell what is happening in the story

### Choosing Characters and Backgrounds 🎭
Scratch Jr comes with lots of built-in sprites (characters) and backgrounds. You can also:
- Draw your own character using the paint tool 🎨
- Choose from animals, people, and fantasy creatures
- Pick backgrounds like space, underwater, city, forest, and more!

### Tips for a Great Digital Story 💡
- Keep each page simple with one or two actions
- Use sounds to make it more exciting
- Make your characters move — animation makes stories come alive!
- Tell a story you care about — about your pet, your favourite place, or a dream adventure!

### Fun Fact 📱
Digital story apps for children are used in classrooms all over the world. Teachers use stories made by students to help everyone learn to read! Maybe YOUR story could help someone learn!

### What Did You Learn Today?
- Stories need characters, a setting, and a plot
- Scratch Jr pages work like the pages of a book
- You can add backgrounds, characters, text, and sounds to each page
- Making a digital story is a creative coding project!'),

('exp-l15', 'Debugging: Finding and Fixing Mistakes', 'explorers', 'Algorithms', 'en', 'beginner', 20, 100, 15,
'## Debugging: Be a Bug Finder! 🐛🔍

Every programmer in the world — even the most expert ones — makes mistakes in their code. These mistakes are called **bugs**, and fixing them is called **debugging**. Being a great debugger is one of the most important skills a coder can have!

### Why Are Mistakes Called "Bugs"? 🦋
Way back in 1947, a computer scientist named **Grace Hopper** was working on a huge computer. The computer stopped working, and when her team investigated, they found an actual moth (a real insect!) stuck inside the machine, causing problems. They taped the moth into their notebook and wrote "first actual case of bug being found!" The word "bug" stuck around forever after that!

### Types of Coding Bugs 🔧

**The Typo Bug** — Something is spelled wrong or in the wrong place
Example: You want the cat to move right, but you accidentally used "move left"

**The Order Bug** — Steps are in the wrong order
Example: You put the "Play Sound" block before the "Start" block, so nothing works

**The Missing Step Bug** — You forgot to include an important instruction
Example: You made the cat walk but forgot to add a background, so it is just walking in blank space

**The Infinite Loop Bug** — A loop that never ends!
Example: You made a forever loop but forgot to add a stop condition

### The Debugging Process 🕵️
Professional programmers follow these steps when they find a bug:

1. **Identify** — Find where the problem is happening
2. **Understand** — Why is it happening? What did the code actually do vs. what you wanted?
3. **Fix** — Change the code to correct the mistake
4. **Test** — Run it again to make sure the fix worked!
5. **Repeat** — Sometimes fixing one bug reveals another one!

### Activity: Find the Bug! 🔍
Read this story and find the bug:

Tia wants to make her Scratch Cat walk right, then jump, then make a sound. Here is what she did:
1. Start (green flag)
2. Play sound
3. Jump
4. Move right

**Can you find the bug?** The steps are in the wrong order! It should be: Start → Move right → Jump → Play sound. The SEQUENCE (order) is wrong!

### Activity: Debug Your Own Code! 💻
Open a Scratch Jr project you made before. Deliberately swap two blocks around. Can you spot the difference when you run it? Can you fix it?

### Fun Fact 💡
Professional software companies have entire teams of people whose only job is to find and fix bugs! They are called **Quality Assurance (QA) Engineers** and they are incredibly important.

### What Did You Learn Today?
- Bugs are mistakes in computer code
- The word "bug" comes from an actual moth found in a computer in 1947
- Bugs can be typos, wrong order, missing steps, or infinite loops
- Debugging means finding and fixing bugs, step by step'),

('exp-l16', 'Sorting and Grouping: How Computers Organise', 'explorers', 'Computational Thinking', 'en', 'beginner', 20, 100, 16,
'## Sorting and Grouping! 📦

Computers are amazingly good at organising information. They can sort millions of things in seconds! But first, let us understand how sorting and grouping works.

### What Is Sorting? 📋
Sorting means putting things in a specific ORDER. Things can be sorted by:
- **Alphabetical order** (A, B, C...) — like names in a phone book
- **Numerical order** (1, 2, 3...) — like scores on a leaderboard
- **Size order** — smallest to biggest (or biggest to smallest)
- **Date order** — oldest to newest (or newest to oldest)
- **Colour** — all reds together, all blues together...

### What Is Grouping? 🗂️
Grouping (also called **categorising**) means putting things into groups based on what they have in common.

For example:
- Animals can be grouped as: mammals, birds, fish, reptiles
- Foods can be grouped as: fruits, vegetables, dairy, grains
- Shapes can be grouped as: circles, squares, triangles

### Why Do Computers Sort and Group? 💻
Every time you search for something online, a computer sorts through BILLIONS of web pages and groups the most relevant ones at the top of the results — all in less than one second! Every song in a music app is sorted and grouped so you can find what you want quickly.

### Activity: Sort the Classroom! 🏫
Look around your room. Sort all the objects into groups:
- **By colour:** red things, blue things, yellow things
- **By size:** big, medium, small
- **By material:** wood things, plastic things, fabric things

How many objects fit in each group?

### Activity: Alphabetical Sorting Game! 🔤
Sort these animal names in alphabetical order:
- Zebra, Cat, Elephant, Bear, Dog, Ant

Answer: Ant, Bear, Cat, Dog, Elephant, Zebra

Now sort these numbers from smallest to biggest:
42, 7, 19, 3, 85, 31

### The Sorting Algorithm 🤖
Computers use special methods called **sorting algorithms** to sort data efficiently. One simple method is called **Bubble Sort**:
1. Look at two numbers side by side
2. If the bigger number is on the left, swap them
3. Move to the next pair and repeat
4. Keep going until everything is sorted!

### Fun Fact 🌟
If you searched for something on Google and it had to show you results in random order (not sorted by relevance), you might have to look through billions of pages to find what you need! Sorting makes the internet useful.

### What Did You Learn Today?
- Sorting means putting things in a specific order
- Grouping means organising things by what they have in common
- Computers use sorting to help us find information quickly
- Sorting algorithms are the methods computers use to sort data'),

('exp-l17', 'Giving Directions: Programming a Robot', 'explorers', 'Algorithms', 'en', 'beginner', 25, 100, 17,
'## Programming a Robot! 🤖

What if you had a robot friend who would do anything you said — but ONLY if you gave perfectly clear instructions? Today you are going to practice giving directions so precise that even a robot could follow them!

### Robots Follow Instructions Exactly 🎯
A real robot cannot think for itself. It only does EXACTLY what it is programmed to do. If you say "go forward 3 steps" it goes forward 3 steps — no more, no less! This means your instructions need to be:
- Clear (no vague words)
- Specific (exact numbers and directions)
- In the right order

### Direction Words for Robots 🗺️
Instead of "go over there," robots need precise commands:
- **Forward** (and how many steps!)
- **Backward** (and how many steps!)
- **Turn left** (exactly 90 degrees)
- **Turn right** (exactly 90 degrees)
- **Stop**
- **Pick up**
- **Put down**

### Activity: Be a Robot! 🤸
One person is the **programmer**, one person is the **robot**. The robot must follow instructions EXACTLY — no thinking or guessing allowed!

The programmer gives instructions to guide the robot from one side of the room to a chair, following ONLY the instructions:
- "Take 4 steps forward"
- "Turn right"
- "Take 2 steps forward"
- "Stop — you have reached the chair!"

What happened if the instructions were wrong? Did the robot need debugging?

### The Grid Game 🗓️
Draw a 5x5 grid on paper. Mark a START and a FINISH. Now write the instructions to get from start to finish:

Example path:
- Forward 2
- Turn right
- Forward 3
- Turn left
- Forward 1
- FINISH!

Can your friend follow your robot instructions and reach the finish?

### Real Robots in the World 🌍
Today, real robots use instructions just like these:
- **Warehouse robots** follow precise paths to pick up boxes 📦
- **Mars rovers** receive movement commands from Earth 🚀
- **Surgery robots** follow a surgeon''s precise movements
- **Vacuum cleaner robots** map their path around your room 🏠

### Coding a Real Robot Toy 🎮
Many toy robots like Bee-Bot can be programmed with button presses:
- Press the forward arrow → robot moves forward one step
- Press the turn right arrow → robot turns right
- Press GO → robot follows all your instructions!

### Fun Fact 🚀
NASA''s Perseverance rover on Mars receives driving instructions from Earth — but because radio signals take up to 20 minutes to travel between Earth and Mars, the instructions have to be VERY precise. There is no time to correct mistakes quickly!

### What Did You Learn Today?
- Robots follow instructions exactly — no guessing or thinking for themselves
- Good robot instructions are clear, specific, and in the right order
- Direction words like forward, backward, and turn need specific values
- Real robots in warehouses, hospitals, and space follow the same kind of instructions'),

('exp-l18', 'Asking Good Questions: The Coder''s Superpower', 'explorers', 'Computational Thinking', 'en', 'beginner', 20, 100, 18,
'## Asking Good Questions! ❓

Did you know that asking questions is one of the most important skills a coder can have? The best programmers are incredibly good at asking the right questions before they start coding!

### Why Questions Matter in Coding 💡
Before a programmer builds anything, they ask questions like:
- "What problem am I trying to solve?"
- "Who will use this?"
- "How should it work?"
- "What could go wrong?"

Asking good questions helps coders build the RIGHT thing, not just ANY thing!

### Types of Questions 🌈

**Who questions** — Who is this for? Who will use it?
**What questions** — What should it do? What does it need?
**How questions** — How will it work? How many steps does it take?
**Why questions** — Why is this needed? Why would someone want it?
**What if questions** — What if someone does something unexpected?

### The 5 Whys Technique 🔍
When you have a problem, asking "Why?" five times helps you get to the REAL cause:

Problem: "My code is not working!"
Why 1: Why is it not working? → Because the character is not moving.
Why 2: Why is it not moving? → Because there is no movement block.
Why 3: Why is there no movement block? → Because I forgot to add it.
Why 4: Why did I forget? → Because I rushed and skipped a step.
Why 5: Why did I rush? → Because I did not plan carefully first.

Solution: Next time, plan before you start coding!

### Asking Questions When You Are Stuck 🤔
When you are stuck coding, try asking:
- "What was the LAST thing that worked?"
- "What did I change since then?"
- "What does the code ACTUALLY do vs. what I WANT it to do?"
- "Can I search for help or look at an example?"

### Activity: Question Storm! ⛈️
Think about building a game where a cat catches falling stars. Before building ANYTHING, write down as many questions as you can:

Possible questions:
- How fast do the stars fall?
- What happens when the cat catches a star?
- How many stars are there?
- Does the game ever end?
- What happens if the cat misses a star?
- How does the player control the cat?

Great programmers ask questions like these before writing a single line of code!

### Activity: Interview a Friend! 🎙️
Pretend your friend wants you to build them a digital greeting card. Interview them by asking:
1. Who is the card for?
2. What should it say?
3. What colours do they like?
4. Should it have music?
5. Should something move on the card?

Now build the card based on their answers!

### Fun Fact 🌍
The famous scientist Albert Einstein once said: "If I had an hour to solve a problem, I would spend 55 minutes thinking about the problem and 5 minutes thinking about solutions." Asking great questions IS the work!

### What Did You Learn Today?
- Asking questions is a key coding skill
- Who, What, How, Why, and What If questions help you plan better
- The 5 Whys technique helps find the root cause of problems
- Great coders think and ask questions before they start building'),

('exp-l19', 'Creating Art With Code: Pixel Pictures', 'explorers', 'Art & Design', 'en', 'beginner', 25, 100, 19,
'## Creating Art With Code! 🎨

Art and coding are more connected than you might think! Digital art — every picture on a screen, every emoji, every photo — is made of tiny coloured squares called **pixels**. Today you become a digital artist!

### What Are Pixels? 🔲
A **pixel** is the tiniest dot of colour on a screen. Your computer screen is made of millions of pixels all lined up in a grid. When you look at a photo, you are actually looking at millions of tiny coloured squares — so tiny you cannot see them individually!

**Pixel** comes from "Picture Element" — the smallest element of a picture.

### Zooming In on Pixels 🔍
If you zoom in very close on any image on a screen, you will start to see the individual pixels — small squares of colour. Old video games from the 1980s had very large, visible pixels, giving them that classic "blocky" look. Modern screens have so many pixels that each one is invisible to the naked eye.

### Pixel Art: Art Made Square by Square! 🎮
Pixel art is a style of digital art where each pixel is placed one by one to create an image. Famous video game characters like Super Mario, Pikachu, and Pac-Man all started as pixel art!

You can make pixel art on paper too — using graph paper and coloured pencils!

### Activity: Graph Paper Pixel Art! 🖍️
Get a piece of graph paper (or draw a grid of 10x10 squares on plain paper). Each square is one pixel.

Try to draw one of these in pixel art:
- A simple heart ❤️
- A smiley face 😊
- A star ⭐
- Your initial letter

Colour in the squares to make your design. Share it with someone!

### Colours in Computers: RGB 🌈
Computers make every colour by mixing three colours of light:
- **R** = Red
- **G** = Green
- **B** = Blue

By changing how much of each colour to use (0-255), computers can make over 16 **million** different colours! Every colour you see on screen is a mix of red, green, and blue light.

For example:
- Pure red = R:255, G:0, B:0
- Pure blue = R:0, G:0, B:255
- Yellow = R:255, G:255, B:0
- White = R:255, G:255, B:255
- Black = R:0, G:0, B:0

### Digital Artists Who Code 🌟
Today many professional artists use code to create their art! They write programs that generate patterns, animations, and interactive pieces. This is called **generative art** or **creative coding**.

### Activity: Colour Mixing Experiment 🎨
Use watercolour or crayon mixing to explore:
- Red + Blue = Purple
- Red + Yellow = Orange
- Blue + Yellow = Green

Now try to make 5 more colours by mixing! Computers do the same thing — mixing red, green, and blue light in different amounts.

### Fun Fact 🖥️
A standard HD screen (1920 x 1080) has 2,073,600 pixels — over 2 million! A 4K screen has over 8 million pixels. And computers update ALL of those pixels up to 60 or even 120 times every second!

### What Did You Learn Today?
- Pixels are the tiny squares of colour that make up every digital image
- Pixel art creates pictures square by square
- Computers mix Red, Green, and Blue light to make millions of colours
- Art and coding combine in creative and exciting ways!'),

('exp-l20', 'Sharing and Teamwork: Coding Together', 'explorers', 'Digital Citizenship', 'en', 'beginner', 20, 100, 20,
'## Sharing and Teamwork in Coding! 🤝

Some of the best things ever built were built by TEAMS working together! The internet itself, huge video games, and life-saving medical apps were all created by many people collaborating. Today we learn about coding as a team sport!

### Why Teams Are Better Than Working Alone 💪
When people work together on a coding project:
- Different people bring different strengths and ideas
- More people can spot bugs and mistakes
- Big projects can be split into smaller tasks and done faster
- Everyone learns from each other!

### Roles in a Coding Team 👥
In real tech companies, teams have different roles:

- **Designer** — Decides what the app looks like and how it feels 🎨
- **Programmer** — Writes the actual code 💻
- **Tester** — Tries to find bugs and problems 🔍
- **Project Manager** — Makes sure everyone works together and meets deadlines 📋
- **Storyteller/Writer** — Creates the content and words in the app ✍️

### Sharing Your Code 🔗
Sharing code is a big part of coding culture! Professional programmers share their code so others can:
- Learn from it
- Improve it
- Use it in their own projects
- Build on top of it to make something new!

This is called **open source** coding — and it is how many of the world''s most important programs were built!

### Giving Helpful Feedback 💬
When someone shares their project with you, give USEFUL feedback:
- Say one thing you LIKED about it: "I loved how the character jumped!"
- Say one thing that could be BETTER: "Maybe the character could be a bit bigger?"
- Ask one QUESTION: "How did you make the background change?"

This is called a **"sandwich"** — something nice, something to improve, something nice!

### Activity: Swap and Debug! 🐛
With a friend:
1. Each person makes a simple Scratch Jr animation
2. Swap your devices
3. Try to understand what the other person''s code does
4. Try to find and fix ONE thing that could be better
5. Give it back with kind, helpful feedback

What was it like to read someone else''s code?

### Activity: Build Together! 🏗️
With a partner, create a Scratch Jr story where:
- Person A creates Page 1 of the story
- Person B creates Page 2
- Together, you create Page 3

Combine your pages and tell your story to the class!

### Being a Good Team Member Online 💜
When sharing work online:
- Give credit when you use someone else''s idea
- Be kind in comments and messages
- Encourage others when they are struggling
- Celebrate each other''s successes!

### Fun Fact 🌍
The Linux operating system — which runs billions of devices including most of the internet''s servers — was built by thousands of volunteer programmers from all over the world, all working together and sharing their code for FREE!

### What Did You Learn Today?
- Great software is usually built by teams, not individuals working alone
- Teams have different roles: designer, programmer, tester, and more
- Sharing code helps everyone learn and build better things
- Good feedback is kind, specific, and helpful'),

('exp-l21', 'My First Game: Catch the Star!', 'explorers', 'Creative Coding', 'en', 'beginner', 40, 100, 21,
'## My First Game: Catch the Star! ⭐🎮

Today you are going to build your very first game from scratch! In "Catch the Star," a character catches falling stars to earn points. Let''s put everything you have learned together!

### Planning Your Game First 📋
Remember lesson 18 — we always plan before we code! Let''s answer the important questions:

- **What is the goal?** The player moves a character to catch falling stars
- **How does the player control it?** By tapping left and right (or pressing arrow keys)
- **What happens when you catch a star?** You earn a point!
- **When does the game end?** When you miss 3 stars

### Breaking the Game into Parts 🔧
Big projects become manageable when we break them into small parts:

**Part 1:** Make the catcher character move left and right
**Part 2:** Make a star appear and fall down from the top
**Part 3:** Detect when the catcher touches the star (and add a point!)
**Part 4:** Add sounds and visual effects
**Part 5:** Add a "Game Over" message

### Building in Scratch Jr: The Catcher Character 🐱
1. Open Scratch Jr and delete the default cat (or keep it as your catcher!)
2. Add a "When device is tilted left → Move Left" block
3. Add a "When device is tilted right → Move Right" block

Now your character can be controlled by tilting the tablet!

### The Falling Star ⭐
Add a new sprite — choose the yellow star!

1. Place the star at the top of the screen
2. Create a program: Start → Move Down (many steps) → End
3. The star will fall down the screen!

### Making It a Real Game! 🏆
Add these elements to make it feel like a game:

- **Background:** Choose a night sky background for extra atmosphere! 🌙
- **Music:** Add a repeating musical loop to create atmosphere
- **Celebration:** When the catcher touches the star, make both characters flash and add a "ding" sound!

### Testing and Debugging Your Game 🔍
Run your game and test it:
- Does the catcher move when you tilt?
- Does the star fall from top to bottom?
- What happens at the edges of the screen?
- Is it too fast or too slow?

Adjust the speeds and positions until it feels right. This process is called **playtesting**!

### Activity: Add Your Own Twist! 🎨
Once your basic game works, add your OWN creative ideas:
- Change the catcher to a different character (an animal? a robot?)
- Change the stars to something different (hearts? bananas? rockets?)
- Change the background to somewhere interesting
- Add more obstacles or bonuses

Make it YOUR game!

### Sharing Your Game 🌟
Show your finished game to:
- A family member
- A friend
- Your teacher

Tell them: "I made this game — would you like to play it?" Feel proud of what you built!

### Fun Fact 🎮
The world''s first video game was created in 1958. It was called "Tennis for Two" — and it was played on an oscilloscope, not even a regular screen! Games have come a very long way since then.

### What Did You Learn Today?
- Planning a game before coding it makes the process easier
- Breaking a big project into small parts makes it manageable
- Testing (playtesting) and debugging make your game better
- You can create a real, playable game in Scratch Jr!'),

('exp-l22', 'Sound and Music in Code', 'explorers', 'Creative Coding', 'en', 'beginner', 25, 100, 22,
'## Sound and Music in Code! 🎵

Music and sound effects make every game, video, and app so much more exciting! Did you know that computers use code to create, record, and play all the sounds you hear? Today we explore the musical side of coding!

### How Do Computers Make Sound? 🔊
Sound is made of invisible waves travelling through the air. When these waves reach your ears, you hear sound! Computers create sound by making their speakers vibrate very quickly, creating these air waves.

Computers represent sound as numbers — measuring how high or low the air wave is at thousands of points every second. Music players, headphones, and speakers all read these numbers and turn them back into sound!

### Sound in Scratch Jr 🎶
Scratch Jr has built-in sounds and music you can add to your projects:
- **Animal sounds** 🐱🐶🦁
- **Musical instruments** 🎺🥁🎹
- **Sound effects** (pop, whoosh, ding!)
- **Record your own voice!** 🎤

### Adding Sound to Your Projects 🔧
In Scratch Jr, the **purple blocks** control sound:
- **Play Sound** — plays a sound once
- **Play Sound Until Done** — waits for the sound to finish before moving to the next block
- **Record** — records a new sound using the microphone

### Music as Patterns! 🎼
Remember patterns from lesson 5? Music is basically made of sound patterns!

A musical beat is a repeating pattern of sounds:
🥁 BOOM, cha, BOOM, cha, BOOM, cha...

Each "BOOM" and "cha" happens at exact intervals. Computers are perfect at maintaining perfect timing for music because they are so precise!

### Activity: Compose in Scratch Jr! 🎹
Create a musical performance in Scratch Jr:

1. Add 3 different animal or instrument sprites
2. Give each sprite a different sound block
3. Arrange them to play in a sequence (one after another)
4. Use a "Forever" loop to make the music play continuously!

Can you create a song using only the built-in Scratch Jr sounds?

### Record Your Own Voice! 🎤
The most powerful sound is YOUR voice! In Scratch Jr:
1. Choose the microphone icon to record
2. Say a line of dialogue for a character: "Hello! I am exploring the moon!"
3. Attach it to a "When tapped" block
4. Now your character speaks when you tap it!

### Sound and Stories 📖
Sound makes stories come alive:
- A spooky story needs mysterious background music and creaky sounds
- An adventure needs exciting, energetic music
- A peaceful story needs soft, gentle sounds

Practise choosing the RIGHT sounds for the mood of your story!

### Activity: Sound Story! 🌟
Create a Scratch Jr page where:
1. A character walks in (footstep sounds!)
2. Something surprising happens (gasp sound!)
3. The character celebrates (cheer sound!)
4. Music plays throughout

Can you tell the whole story just through movement and sound — without any words?

### Fun Fact 🌍
The music streaming service Spotify has over 100 million songs in its library — all stored as digital sound data. If you listened to every song for one second each, it would take over 3 years of non-stop listening!

### What Did You Learn Today?
- Computers turn sound into numbers and store it digitally
- Scratch Jr has purple sound blocks and a recording feature
- Music is made of repeating patterns of sound
- Sound effects and music make coding projects come alive!'),

('exp-l23', 'Problem Solving: Think Like a Coder', 'explorers', 'Computational Thinking', 'en', 'beginner', 20, 100, 23,
'## Think Like a Coder! 🧠

Coding is really about solving problems. The way a coder thinks about problems — breaking them down, looking for patterns, and trying solutions — is a superpower that works in ALL areas of life, not just computers!

### Computational Thinking: The Coder''s Way of Thinking 💡
Computer scientists have a special name for this way of thinking: **Computational Thinking**. It has four main parts:

**1. Decomposition — Break It Down! 🔨**
Break a big problem into smaller, manageable pieces. Instead of "make a game," think: "make the character move" THEN "make things fall" THEN "detect when they touch."

**2. Pattern Recognition — Spot the Similarities! 🔍**
Look for patterns and similarities. Many problems have been solved before in similar ways. Can you use a similar solution?

**3. Abstraction — Focus on What Matters! 🎯**
Ignore details that do not matter right now. When making a character walk, you do not need to think about the background yet. Focus on one thing at a time.

**4. Algorithms — Make a Plan! 📋**
Write out the step-by-step instructions to solve the problem before you start building.

### Using These Skills Together: A Example 🌟
**Problem:** A game character is not jumping high enough.

- **Decomposition:** Is it the jump HEIGHT that is wrong? The jump SPEED? The SOUND?
- **Pattern Recognition:** Have I fixed similar jumping problems before? What did I do?
- **Abstraction:** Focus just on the jump mechanics — ignore colours and sounds for now.
- **Algorithm:** 1. Find the jump block. 2. Change the height value. 3. Test it. 4. Repeat until it feels right.

### Computational Thinking in Real Life 🌍
These four skills work everywhere:

**Planning a party 🎉**
- Decompose: food, decorations, invitations, games
- Pattern: similar to last year''s party — what worked?
- Abstract: focus on invitations first
- Algorithm: write the guest list, address envelopes, send them

**Packing a school bag 🎒**
- Decompose: books, lunch, PE kit, homework
- Pattern: what do I need on Mondays vs. Thursdays?
- Abstract: today is Monday — only today''s items
- Algorithm: checklist of items to pack

### Activity: The Sandwich Challenge! 🥪
Your mission: teach a robot (a friend acting as a robot!) how to make a peanut butter sandwich.

The robot is VERY literal — it only does exactly what you say! Try to write the perfect algorithm. Then have the "robot" follow it EXACTLY. What went wrong? What did you learn?

### Activity: Decompose Your Day! 📋
Take "going to school" and decompose it into as many steps as you can. Try to write at least 10 steps! You might be surprised how complex even simple things are when you really think about them.

### Fun Fact 🏆
Many successful business people, doctors, lawyers, and artists use computational thinking every day — even if they have never written a line of code! It is a universal problem-solving method.

### What Did You Learn Today?
- Computational thinking has four parts: decomposition, pattern recognition, abstraction, and algorithms
- These skills help solve any problem, not just computer problems
- Breaking big problems into smaller pieces makes them manageable
- Coders use these thinking skills before writing any code'),

('exp-l24', 'The Internet: How Computers Talk to Each Other', 'explorers', 'Digital Citizenship', 'en', 'beginner', 20, 100, 24,
'## How Computers Talk to Each Other! 🌐

The internet connects billions of computers around the world. It lets you watch videos from the other side of the planet, play games with friends in different countries, and learn things from anyone, anywhere! How does it all work?

### What Is the Internet? 🕸️
The internet is like a massive web of connected computers. "Inter" means "between" and "net" comes from "network" — so the internet is a network between networks!

Every time you open a website or send a message, your device is talking to computers that might be thousands of kilometres away, and it happens in milliseconds!

### How Does Information Travel? 🚀
When you visit a website:
1. Your device sends a REQUEST (like asking a question): "Please send me the YouTube homepage!"
2. This request travels through cables (some even under the ocean!) to YouTube''s computers
3. YouTube''s computers send back a RESPONSE (the answer): the website data
4. Your browser reads the data and shows you the page

This round trip — all the way around the world and back — can happen in less than **one second!**

### Internet vs. The World Wide Web 🌍
Many people think these are the same thing, but they are different!

- **The Internet** = the physical network of cables, computers, and connections
- **The World Wide Web** = the websites and apps that USE the internet to share information

The internet is like the roads and motorways. The World Wide Web is like the cars and vehicles using those roads!

### What Is a Browser? 🖥️
A **web browser** is a program that reads websites and shows them to you. Popular browsers include:
- Google Chrome 🔵
- Safari 🧭
- Firefox 🦊
- Microsoft Edge 🌀

Browsers know how to read the special language of websites (called **HTML**) and turn it into the colourful, clickable pages you see!

### Safety on the Internet 🔐
The internet is amazing, but it is important to stay safe:
- Only visit websites a trusted adult has approved
- Never share personal information on websites you do not know
- Tell an adult if you see something that makes you uncomfortable
- Remember: the internet never forgets — think before you post!

### Activity: Map the Journey! 🗺️
Draw a simple map showing what happens when you visit a website:

1. Your device (draw a computer or tablet)
2. → Arrow (labelled "sends request")
3. → Internet cables (draw lines connecting countries)
4. → A server (draw a big computer in another country)
5. → Arrow back (labelled "sends website")
6. → Your browser shows the page!

### Fun Fact 🌊
There are over 400 undersea cables running along the ocean floor, connecting countries and continents! These cables carry 99% of all international internet traffic. Satellites only carry 1%!

### What Did You Learn Today?
- The internet is a global network connecting billions of computers
- Information travels as requests and responses between devices
- The internet is the network; the World Wide Web is the websites on it
- Browsers read websites and display them for us
- Staying safe online means protecting personal information'),

('exp-l25', 'Explorers Celebration: Look How Far You''ve Come!', 'explorers', 'Fundamentals', 'en', 'beginner', 20, 100, 25,
'## Explorers Celebration! 🎉🚀

You have reached the end of the Explorers level — and you should be INCREDIBLY proud! Let''s look back at everything you have learned and celebrate how far you have come!

### Your Explorers Journey 🗺️

Look at all the amazing things you now know about computers and coding:

🖥️ **Lesson 1-4: Computers and Coding**
You discovered what computers are, how they work (input → process → output), where they hide in everyday life, and who the incredible coders are who changed the world!

🎨 **Lesson 5-8: Thinking Like a Programmer**
You learned about patterns (the secret language of computers), algorithms (step-by-step instructions), if-then decisions, and loops (making things repeat)!

🔢 **Lesson 9: Binary**
You discovered how computers count using only 0s and 1s — and you will never look at a computer the same way again!

🛡️ **Lessons 10, 20, 24: Digital Citizenship**
You learned how to stay safe online, how to be kind in the digital world, and how the internet actually works!

💻 **Lessons 11-14: Real Coding in Scratch Jr**
You used a REAL coding tool! You made characters move, created loops, told digital stories, and built animated books!

🐛 **Lesson 15: Debugging**
You learned to find and fix bugs — just like professional programmers do every day!

📊 **Lessons 16-18: Computational Thinking**
You learned to sort and group data, program robots, and ask great questions!

🎮 **Lessons 19-23: Creative Projects**
You made pixel art, composed music, built your first game, and learned to think like a coder!

### Your Skills Certificate 🏆
By completing the Explorers level, you have developed these real coding skills:
- ✅ Understanding how computers work
- ✅ Writing and following algorithms
- ✅ Using loops and if-then decisions
- ✅ Creating programs in Scratch Jr
- ✅ Debugging your code
- ✅ Thinking computationally
- ✅ Staying safe online
- ✅ Creating digital art, music, and games

### Activity: My Coding Portfolio! 📁
Collect all the projects you made during the Explorers level:
- Your Scratch Jr stories and animations
- Your pixel art drawings
- Your robot programming grids
- Your algorithm writing

Present your portfolio to a family member and explain what you made and how it works. You are a REAL coder!

### What Comes Next: The Builders Level! 🏗️
In the next level — Builders — you will learn:
- How to build real websites with HTML and CSS
- How to make webpages look beautiful
- More advanced Scratch coding
- How to build projects that others can visit in a web browser!

The coding adventure is just getting started. The Explorers level was your foundation — now you are ready to build something incredible!

### A Message for You 💌
You did it! You are an Explorer who has completed their very first coding journey. Remember:
- Every expert coder started exactly where you started
- Mistakes are not failures — they are how you learn
- The most important skill in coding is curiosity — and you have LOTS of it!
- Keep exploring, keep creating, keep coding!

### Fun Fact 🌟
Tim Berners-Lee, who invented the World Wide Web in 1989, once said: "The web is more a social creation than a technical one." He built it so that ALL people could share knowledge with ALL other people. YOU are now part of that story!

### What Did You Learn in the Explorers Level?
- Everything a computer is and how it works
- How to think like a coder with algorithms and computational thinking
- How to create real programs in Scratch Jr
- How to stay safe and be kind in the digital world
- That YOU can be a coder — and the world needs more of them!')

ON CONFLICT (slug) DO NOTHING;


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-explorers-projects.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Explorers Projects (exp-p01 to exp-p100)
-- Target: Ages 5–8 | Scratch, basic typing, digital citizenship
-- =============================================================================

INSERT INTO projects (slug, title, level, difficulty, duration_minutes, xp_reward, sort_order, is_published, description, instructions, starter_code, learning_objectives)
VALUES

('exp-p01', 'My Name in Lights', 'explorers', 'beginner', 20, 50, 1, true,
'Create a Scratch project that shows your name with colours and sounds!',
'1. Open Scratch and delete the cat sprite
2. Click "Choose a Sprite" and pick a letter sprite OR use the text tool
3. Add text showing your first name
4. Make each letter a different colour using the Looks blocks
5. Add a fun sound when the green flag is clicked
6. Add a backdrop that matches your favourite colour',
NULL,
ARRAY['Use Looks blocks to change colours', 'Add sounds to a project', 'Customise sprites and backdrops']),

('exp-p02', 'Animal Sound Board', 'explorers', 'beginner', 25, 50, 2, true,
'Build a Scratch sound board where clicking animals plays their sounds!',
'1. Choose 4 different animal sprites
2. Record or add animal sound effects for each
3. When each animal is clicked, it should:
   - Play its sound
   - Say its name for 2 seconds
   - Do a short animation (spin, bounce, or grow)
4. Add a fun backdrop like a zoo or jungle',
NULL,
ARRAY['Add click events to sprites', 'Play sounds in Scratch', 'Use the Say block', 'Animate sprites']),

('exp-p03', 'Moving Butterfly', 'explorers', 'beginner', 20, 50, 3, true,
'Create a butterfly that follows your mouse and flaps its wings!',
'1. Find or draw a butterfly sprite with 2 costumes (wings up, wings down)
2. Make it follow the mouse pointer
3. Make it switch costumes every 0.2 seconds (wing flapping!)
4. When it touches the edge, make it bounce back
5. Add a garden or meadow backdrop',
NULL,
ARRAY['Use the "go to mouse pointer" block', 'Animate with costume switching', 'Use the Forever loop', 'Detect edge collision']),

('exp-p04', 'Happy or Sad?', 'explorers', 'beginner', 20, 50, 4, true,
'Make a face sprite that reacts when you click it — happy or sad!',
'1. Draw a simple face sprite with 3 costumes: neutral, happy, sad
2. When the green flag is clicked, show the neutral face
3. When the sprite is clicked:
   - If it was happy, switch to sad and play a sad sound
   - If it was sad, switch to happy and play a happy sound
4. Add a variable "mood" to track happy vs sad',
NULL,
ARRAY['Use multiple costumes', 'Track state with a variable', 'Use if/else blocks', 'Add sound effects']),

('exp-p05', 'Catch the Star!', 'explorers', 'beginner', 30, 75, 5, true,
'A simple catching game — move your basket and catch falling stars!',
'1. Create a star sprite that starts at the top
2. Make the star fall down (change y by -5 in a forever loop)
3. When it hits the bottom, reset it to a random x position at the top
4. Create a basket sprite that moves left/right with arrow keys
5. When the star touches the basket:
   - Play a sound
   - Change score by 1
   - Reset star to top
6. Display the score on stage',
NULL,
ARRAY['Move sprites with arrow keys', 'Use random position', 'Detect sprite collision', 'Keep score with a variable']),

('exp-p06', 'My Week Story', 'explorers', 'beginner', 25, 50, 6, true,
'Create an animated story about your week using Scratch!',
'1. Plan 5 scenes (one for each school day)
2. Create a different backdrop for each day
3. Use a character sprite
4. For each scene, make the character say something interesting that happened
5. Use the "next backdrop" block to move between scenes
6. Add background music',
NULL,
ARRAY['Create multi-scene stories', 'Use backdrop switching', 'Control timing with Wait blocks', 'Plan a narrative']),

('exp-p07', 'Counting Game', 'explorers', 'beginner', 25, 50, 7, true,
'Build a counting game that teaches numbers 1-10!',
'1. Create number sprites (or use text) for 1-10
2. Arrange them randomly on the stage
3. Ask the player "Click on number ___!"
4. When they click the right number:
   - Say "Correct!" and play a happy sound
   - Show the next number challenge
5. Count how many correct answers and show the score',
NULL,
ARRAY['Use Ask and Answer blocks', 'Create interactive elements', 'Give feedback to player', 'Track progress']),

('exp-p08', 'Colour Mixing Experiment', 'explorers', 'beginner', 20, 50, 8, true,
'Create a Scratch art tool that mixes colours!',
'1. Create a white backdrop
2. Make a sprite that follows your mouse
3. When the mouse is down, change the pen colour and draw
4. Add 4 colour buttons (red, blue, yellow, green)
5. Clicking each button changes the drawing colour
6. Add a "Clear" button that wipes the canvas',
NULL,
ARRAY['Use the Pen extension', 'Create interactive buttons', 'Change properties dynamically', 'Build creative tools']),

('exp-p09', 'Weather Reporter', 'explorers', 'beginner', 20, 50, 9, true,
'Be a weather reporter! Create an animated weather forecast.',
'1. Create a character sprite (your weather reporter)
2. Create 4 weather backdrops: sunny, rainy, snowy, cloudy
3. When green flag clicked, character says "Today''s weather forecast:"
4. Switch to a random weather backdrop
5. Character says what the weather is and what to wear
6. After 5 seconds, switch to the next weather',
NULL,
ARRAY['Use random numbers', 'Switch backdrops', 'Use Say and Think blocks', 'Create narrative sequences']),

('exp-p10', 'Shape Drawing Tool', 'explorers', 'beginner', 25, 50, 10, true,
'Build a drawing tool that stamps shapes when you click!',
'1. Create button sprites for: circle, square, triangle, star
2. When each button is clicked, it broadcasts a shape message
3. Create a drawing sprite that receives the message
4. When a message is received, stamp that shape at the mouse position
5. Add colour buttons to change the stamp colour
6. Add a clear button',
NULL,
ARRAY['Use broadcast and receive', 'Use the Stamp block', 'Create button interactions', 'Build drawing tools']),

-- Projects 11-30: More Scratch projects with varied themes
('exp-p11', 'Alphabet Adventure', 'explorers', 'beginner', 25, 50, 11, true,
'Learn the alphabet with an interactive Scratch game!',
'Make a sprite say a word for each letter A-Z. When you press a letter key, show a picture and hear the word.',
NULL,
ARRAY['Use key pressed events', 'Display images for each letter', 'Play sounds', 'Create educational interactions']),

('exp-p12', 'Simple Calculator', 'explorers', 'beginner', 30, 75, 12, true,
'Build a basic adding calculator in Scratch!',
'Ask for two numbers and show the sum. Add buttons for +, -, ×.',
NULL,
ARRAY['Use Ask and Answer', 'Perform math operations', 'Display results', 'Create buttons']),

('exp-p13', 'Maze Runner', 'explorers', 'beginner', 35, 75, 13, true,
'Draw a maze and program a sprite to navigate it!',
'Design a maze backdrop. Program a sprite to move with arrow keys. Detect wall collisions. Add a goal!',
NULL,
ARRAY['Move with arrow keys', 'Detect colour collision', 'Build a complete game', 'Design levels']),

('exp-p14', 'Dance Party', 'explorers', 'beginner', 20, 50, 14, true,
'Create a Scratch dance party with multiple dancing sprites!',
'Add 3+ sprites. Make them dance (switch costumes). Add background music. Change colours on beat.',
NULL,
ARRAY['Coordinate multiple sprites', 'Synchronise animations', 'Use music timing', 'Create visual effects']),

('exp-p15', 'Guess My Number', 'explorers', 'beginner', 25, 50, 15, true,
'Program a number guessing game from 1 to 20!',
'Pick a random number. Ask player to guess. Say "too high", "too low", or "correct!" Count attempts.',
NULL,
ARRAY['Use random numbers', 'Use conditional logic', 'Count with variables', 'Give hints to player']),

('exp-p16', 'Pet Simulator', 'explorers', 'beginner', 30, 50, 16, true,
'Create a virtual pet that needs feeding and petting!',
'A pet sprite has hunger and happiness variables. Clicking "feed" or "pet" buttons changes the values.',
NULL,
ARRAY['Track multiple variables', 'Create interactive buttons', 'Simulate systems', 'Use conditional states']),

('exp-p17', 'Rock Paper Scissors', 'explorers', 'intermediate', 35, 75, 17, true,
'Build the classic Rock Paper Scissors game!',
'Player clicks rock, paper, or scissors. Computer picks randomly. Determine and announce the winner.',
NULL,
ARRAY['Use random pick', 'Create win conditions', 'Display results', 'Use if/else chains']),

('exp-p18', 'Space Explorer', 'explorers', 'beginner', 25, 50, 18, true,
'Create an animated space scene with a moving rocket!',
'Rocket flies across a starfield. Stars twinkle. Planets spin. Add asteroid obstacles.',
NULL,
ARRAY['Animate multiple sprites', 'Create parallax scrolling', 'Use random movement', 'Build atmosphere']),

('exp-p19', 'Story Builder', 'explorers', 'beginner', 25, 50, 19, true,
'Create a choose-your-own-adventure story!',
'Main character faces choices. Player clicks buttons to decide what happens next. Multiple endings!',
NULL,
ARRAY['Create branching narratives', 'Use button clicks for decisions', 'Track story state', 'Plan multiple paths']),

('exp-p20', 'Musical Instrument', 'explorers', 'beginner', 20, 50, 20, true,
'Build a virtual piano or drum kit in Scratch!',
'Create key sprites. When clicked/pressed, each plays a different note. Record a simple song.',
NULL,
ARRAY['Use the Sound extension', 'Map keys to sounds', 'Create musical patterns', 'Build interactive instruments']),

('exp-p21', 'Fruit Catcher', 'explorers', 'beginner', 30, 75, 21, true,
'Catch falling fruit — different fruits = different points!',
'Fruit falls at random x positions. Basket moves with mouse. Different fruits worth different points.',
NULL,
ARRAY['Use random spawn positions', 'Track score', 'Handle multiple sprite types', 'Increase difficulty']),

('exp-p22', 'Spelling Bee', 'explorers', 'beginner', 25, 50, 22, true,
'A spelling practice game for common words!',
'Show a picture, ask player to type the word. Give hints. Track score.',
NULL,
ARRAY['Use Ask for typed input', 'Check text answers', 'Show visual hints', 'Create educational feedback']),

('exp-p23', 'Traffic Light Controller', 'explorers', 'beginner', 20, 50, 23, true,
'Simulate a working traffic light in Scratch!',
'Traffic light cycles through red, yellow, green with correct timing. Cars stop and go.',
NULL,
ARRAY['Control timing with Wait blocks', 'Coordinate multiple sprites', 'Simulate real systems', 'Use broadcast messages']),

('exp-p24', 'Cookie Clicker', 'explorers', 'beginner', 20, 50, 24, true,
'Build a simple clicker game — click the cookie to earn cookies!',
'Click a cookie sprite to increase count. Use count to buy upgrades.',
NULL,
ARRAY['Count clicks with variables', 'Create upgrade systems', 'Display values on screen', 'Build addictive game loops']),

('exp-p25', 'Explorers Level Showcase', 'explorers', 'intermediate', 45, 100, 25, true,
'Your final Explorers project — show everything you have learned!',
'Build a complete Scratch project that includes: a sprite with multiple costumes, keyboard controls, score tracking, at least 2 scenes, and a win/lose condition.',
NULL,
ARRAY['Combine all learned skills', 'Create complete games', 'Show creativity', 'Build confidence as a coder']),

-- Projects 26-100: Structured entries
('exp-p26', 'Jumping Frog Game', 'explorers', 'intermediate', 35, 75, 26, true, 'Make a frog jump from lily pad to lily pad!', 'Use space bar to jump. Miss a lily pad = lose a life. Reach 10 lily pads to win!', NULL, ARRAY['Jumping mechanics', 'Platform games', 'Lives system']),
('exp-p27', 'Rainbow Painter', 'explorers', 'beginner', 20, 50, 27, true, 'Draw with rainbow colours that cycle automatically!', 'Pen changes colour as you draw. Fill the whole canvas!', NULL, ARRAY['Pen extension', 'Colour cycling', 'Creative tools']),
('exp-p28', 'Treasure Hunt Map', 'explorers', 'beginner', 25, 50, 28, true, 'Create an interactive treasure hunt map!', 'Click locations to discover clues. Find the treasure at the end!', NULL, ARRAY['Click detection', 'Sequential clues', 'Storytelling']),
('exp-p29', 'Animal Quiz', 'explorers', 'beginner', 25, 50, 29, true, 'Quiz players about animal facts!', '5 animal questions. Show the animal picture. Track score.', NULL, ARRAY['Quiz format', 'Answer checking', 'Score tracking']),
('exp-p30', 'Ballon Pop Game', 'explorers', 'beginner', 25, 50, 30, true, 'Click balloons before they float away!', 'Balloons appear at random positions. Click to pop them. Score points!', NULL, ARRAY['Random positioning', 'Click events', 'Time pressure']),
('exp-p31', 'Simon Says', 'explorers', 'intermediate', 35, 75, 31, true, 'Classic Simon Says memory game!', 'Coloured buttons light up in a sequence. Repeat the sequence!', NULL, ARRAY['Memory sequences', 'Increasing difficulty', 'Visual feedback']),
('exp-p32', 'Penguin Slide', 'explorers', 'beginner', 25, 50, 32, true, 'Slide the penguin down the ice slope!', 'Control speed with up/down. Avoid obstacles. Reach the bottom!', NULL, ARRAY['Momentum', 'Obstacle avoidance', 'Speed control']),
('exp-p33', 'Birthday Card Creator', 'explorers', 'beginner', 20, 50, 33, true, 'Make an animated birthday card!', 'Add a name, animate balloons and confetti, play happy birthday!', NULL, ARRAY['Animation', 'Personalisation', 'Creative project']),
('exp-p34', 'Bug Squisher', 'explorers', 'beginner', 25, 50, 34, true, 'Squish bugs before they reach your food!', 'Bugs move toward food. Click to squish. Miss 5 = game over!', NULL, ARRAY['Moving sprites', 'Click detection', 'Lose condition']),
('exp-p35', 'Number Line Jump', 'explorers', 'beginner', 20, 50, 35, true, 'Jump along a number line to solve math problems!', 'Ask a math problem. Show jumps on the number line. Reach the answer!', NULL, ARRAY['Visual math', 'Number sense', 'Educational games']),
('exp-p36', 'Underwater World', 'explorers', 'beginner', 25, 50, 36, true, 'Create an animated underwater scene!', 'Fish swim, bubbles float up, seaweed sways. Add a diver!', NULL, ARRAY['Continuous animation', 'Multiple sprite types', 'Scene building']),
('exp-p37', 'Sticker Book', 'explorers', 'beginner', 20, 50, 37, true, 'Build an interactive sticker book!', 'Click stickers to stamp them on the page. Resize and position them.', NULL, ARRAY['Stamping', 'Positioning', 'Creative expression']),
('exp-p38', 'Time Table Tester', 'explorers', 'beginner', 25, 50, 38, true, 'Test your times tables 1-12!', 'Random multiplication question. Check answer. Track score.', NULL, ARRAY['Math practice', 'Random questions', 'Correct/incorrect feedback']),
('exp-p39', 'Monster Maker', 'explorers', 'beginner', 25, 50, 39, true, 'Mix and match body parts to create monsters!', 'Click buttons to swap head, body, legs, arms. Create unique monsters!', NULL, ARRAY['Costume switching', 'Randomisation', 'Creative design']),
('exp-p40', 'Marble Run', 'explorers', 'intermediate', 35, 75, 40, true, 'Animate a marble rolling through a course!', 'Design ramps and obstacles. Animate marble bouncing and rolling.', NULL, ARRAY['Physics simulation', 'Animation paths', 'Course design']),
('exp-p41', 'Colour Sorter', 'explorers', 'beginner', 25, 50, 41, true, 'Sort coloured balls into matching buckets!', 'Drag coloured balls to the right buckets. Race against the clock!', NULL, ARRAY['Dragging sprites', 'Colour matching', 'Timed challenges']),
('exp-p42', 'Postcard Sender', 'explorers', 'beginner', 20, 50, 42, true, 'Design and send a virtual postcard!', 'Choose a background, add a stamp, write a message, animate sending.', NULL, ARRAY['Creative design', 'Text input', 'Multi-step interactions']),
('exp-p43', 'Plant Growth Timer', 'explorers', 'beginner', 20, 50, 43, true, 'Animate a plant growing through stages!', 'Show seed, sprout, small plant, full plant. Add watering animation!', NULL, ARRAY['Sequential animation', 'Growth simulation', 'Science learning']),
('exp-p44', 'Emoji Maker', 'explorers', 'beginner', 20, 50, 44, true, 'Create custom emojis by combining features!', 'Mix eyes, mouths, accessories to make unique emoji faces.', NULL, ARRAY['Layer combination', 'Creative expression', 'Design thinking']),
('exp-p45', 'Forest Fire Simulator', 'explorers', 'intermediate', 35, 75, 45, true, 'Simulate forest fire spreading and firefighters stopping it!', 'Trees can catch fire. Water from the firetruck puts it out.', NULL, ARRAY['Simulation', 'Cause and effect', 'Systems thinking']),
('exp-p46', 'Treasure Map Creator', 'explorers', 'beginner', 25, 50, 46, true, 'Draw your own treasure map with Scratch Pen!', 'Use pen blocks to draw landmasses, mark an X, add a compass.', NULL, ARRAY['Pen drawing', 'Creative maps', 'Coordinate system']),
('exp-p47', 'Weather Station', 'explorers', 'beginner', 25, 50, 47, true, 'Create an animated weather forecast station!', 'Display current weather with animation. Include temperature, conditions.', NULL, ARRAY['Data display', 'Weather simulation', 'UI design']),
('exp-p48', 'Jungle Safari', 'explorers', 'beginner', 25, 50, 48, true, 'Go on a virtual safari and spot animals!', 'Animals hide in the jungle. Find them by clicking the right spots!', NULL, ARRAY['Hidden object game', 'Click detection', 'Exploration']),
('exp-p49', 'Magic 8-Ball', 'explorers', 'beginner', 20, 50, 49, true, 'Build a Magic 8-Ball fortune teller!', 'Click the ball to shake it and reveal a random fortune message.', NULL, ARRAY['Random messages', 'Animation on click', 'List of options']),
('exp-p50', 'Explorers Mid-Point Challenge', 'explorers', 'intermediate', 45, 100, 50, true, 'Mid-point challenge: build a game with 3+ features learned so far!', 'Score, lives, timer, multiple sprites, collision detection, win/lose states.', NULL, ARRAY['Combine skills', 'Complete game mechanics', 'Creative problem solving']),

-- Projects 51-100 (abbreviated structures)
('exp-p51', 'Space Invaders Lite', 'explorers', 'intermediate', 40, 75, 51, true, 'Simple space invaders: shoot aliens before they land!', 'Spaceship moves left/right. Press space to fire. Aliens descend.', NULL, ARRAY['Shooting mechanics', 'Alien movement', 'Lives system']),
('exp-p52', 'Memory Card Game', 'explorers', 'intermediate', 40, 75, 52, true, 'Flip cards to match pairs!', '8 pairs of cards. Click to flip. Match all pairs to win!', NULL, ARRAY['Memory game logic', 'Card flipping', 'Match detection']),
('exp-p53', 'Dragon Flyer', 'explorers', 'beginner', 25, 50, 53, true, 'Fly a dragon through clouds!', 'Dragon flaps wings to stay aloft. Pass through cloud gaps.', NULL, ARRAY['Gravity simulation', 'Gap navigation', 'Flapping mechanic']),
('exp-p54', 'Hopscotch Game', 'explorers', 'beginner', 25, 50, 54, true, 'Virtual hopscotch on screen!', 'Numbered squares light up. Click in order. Beat the clock!', NULL, ARRAY['Sequential clicking', 'Timing', 'Order recognition']),
('exp-p55', 'Solar System Model', 'explorers', 'beginner', 30, 50, 55, true, 'Build an animated solar system model!', 'Sun in centre. Planets orbit at different speeds. Click for facts.', NULL, ARRAY['Circular motion', 'Scale models', 'Science learning']),
('exp-p56', 'Paint by Numbers', 'explorers', 'beginner', 25, 50, 56, true, 'Click numbered sections to paint by numbers!', 'Numbered areas fill with the right colour when clicked.', NULL, ARRAY['Click area detection', 'Colour filling', 'Patience and precision']),
('exp-p57', 'Sorting Hat', 'explorers', 'beginner', 20, 50, 57, true, 'A magical hat that sorts you into a group!', 'Ask name. Animate the hat. Announce a random result.', NULL, ARRAY['Randomisation', 'Animation', 'Input and output']),
('exp-p58', 'Food Chain Game', 'explorers', 'beginner', 25, 50, 58, true, 'Show the food chain — who eats who?', 'Drag animals to show predator-prey relationships.', NULL, ARRAY['Drag and drop', 'Science concepts', 'System relationships']),
('exp-p59', 'Rainstorm Simulator', 'explorers', 'beginner', 20, 50, 59, true, 'Make a rainstorm with lightning and thunder!', 'Rain drops fall. Lightning flashes. Thunder sounds after delay.', NULL, ARRAY['Weather simulation', 'Timing and delay', 'Multiple effects']),
('exp-p60', 'City Builder', 'explorers', 'intermediate', 40, 75, 60, true, 'Click to add buildings and grow your city!', 'Click empty lots to add houses, shops, parks. Track population.', NULL, ARRAY['City simulation', 'Resource management', 'Building placement']),
('exp-p61', 'Dino Runner', 'explorers', 'intermediate', 35, 75, 61, true, 'Endless runner — jump over obstacles!', 'Dino runs automatically. Press space to jump. Obstacles speed up.', NULL, ARRAY['Endless runner', 'Jumping', 'Speed increase']),
('exp-p62', 'Number Bonds', 'explorers', 'beginner', 25, 50, 62, true, 'Practice making numbers with number bonds!', 'Show a total. Click two numbers that add up to it.', NULL, ARRAY['Number bonds', 'Addition practice', 'Math games']),
('exp-p63', 'Ice Cream Shop', 'explorers', 'beginner', 25, 50, 63, true, 'Build an ice cream order simulator!', 'Choose cone, scoops, toppings. Show the final creation!', NULL, ARRAY['Multi-step selection', 'Display combination', 'Customer simulation']),
('exp-p64', 'Rhythm Game', 'explorers', 'intermediate', 35, 75, 64, true, 'Hit the beat! Press keys in rhythm!', 'Blocks fall toward targets. Press the right key at the right time.', NULL, ARRAY['Timing games', 'Key press detection', 'Beat matching']),
('exp-p65', 'Volcano Eruption', 'explorers', 'beginner', 25, 50, 65, true, 'Animate an exploding volcano!', 'Lava flows, ash clouds rise, rocks fly. Science in action!', NULL, ARRAY['Particle effects', 'Science animation', 'Multiple layers']),
('exp-p66', 'Submarine Adventure', 'explorers', 'beginner', 25, 50, 66, true, 'Guide a submarine through underwater caves!', 'Move sub with arrow keys. Avoid rocks. Collect treasure chests.', NULL, ARRAY['Navigation', 'Obstacle avoidance', 'Collection mechanics']),
('exp-p67', 'Fruit Salad Recipe', 'explorers', 'beginner', 20, 50, 67, true, 'Make a virtual fruit salad step by step!', 'Follow recipe steps. Click to add each fruit. Show the result!', NULL, ARRAY['Sequential steps', 'Recipe following', 'Cause and effect']),
('exp-p68', 'Alien Message Decoder', 'explorers', 'beginner', 25, 50, 68, true, 'Decode secret alien messages!', 'Replace symbols with letters to reveal the message. Then send a reply!', NULL, ARRAY['Symbol substitution', 'Pattern recognition', 'Code breaking']),
('exp-p69', 'Mini Golf', 'explorers', 'intermediate', 40, 75, 69, true, 'Play mini golf with a bouncing ball!', 'Aim with mouse. Click to set power. Ball bounces off walls.', NULL, ARRAY['Aiming mechanics', 'Bouncing physics', 'Mini golf logic']),
('exp-p70', 'Constellation Maker', 'explorers', 'beginner', 20, 50, 70, true, 'Draw constellations by connecting stars!', 'Stars appear on a dark backdrop. Drag to draw lines between them.', NULL, ARRAY['Drawing lines', 'Astronomy', 'Creative mapping']),
('exp-p71', 'Pond Life Simulator', 'explorers', 'beginner', 25, 50, 71, true, 'Simulate a pond ecosystem!', 'Frogs eat flies. Fish eat tadpoles. Balance the ecosystem.', NULL, ARRAY['Ecosystem simulation', 'Balance', 'Systems thinking']),
('exp-p72', 'Basketball Shooter', 'explorers', 'intermediate', 35, 75, 72, true, 'Shoot hoops — aim and click to shoot!', 'Ball arcs toward basket. Calculate the right angle. Score 3!', NULL, ARRAY['Trajectory', 'Angle calculation', 'Score tracking']),
('exp-p73', 'World Flags Quiz', 'explorers', 'beginner', 25, 50, 73, true, 'Guess the country from the flag!', '10 flags shown. Multiple choice answers. Track correct answers.', NULL, ARRAY['Quiz format', 'Multiple choice', 'World knowledge']),
('exp-p74', 'Caterpillar to Butterfly', 'explorers', 'beginner', 20, 50, 74, true, 'Animate the butterfly life cycle!', 'Egg → Caterpillar → Cocoon → Butterfly. Click to advance stages.', NULL, ARRAY['Life cycle animation', 'Sequential stages', 'Science learning']),
('exp-p75', 'Typing Trainer', 'explorers', 'beginner', 25, 50, 75, true, 'Practice typing with a fun Scratch game!', 'Letters fall down. Type them before they reach the bottom.', NULL, ARRAY['Keyboard detection', 'Typing practice', 'Speed challenge']),
('exp-p76', 'Museum Tour Guide', 'explorers', 'beginner', 25, 50, 76, true, 'Create a virtual museum tour!', 'Guide sprite leads player through 5 exhibits. Each has a fact.', NULL, ARRAY['Tour design', 'Information presentation', 'Scene switching']),
('exp-p77', 'Snail Race', 'explorers', 'beginner', 25, 50, 77, true, 'Race snails using button mashing!', 'Two players mash keys to make snails move. First to finish wins!', NULL, ARRAY['Two-player games', 'Button mashing mechanic', 'Race conditions']),
('exp-p78', 'Morning Routine Chart', 'explorers', 'beginner', 20, 50, 78, true, 'Interactive morning routine checklist!', 'Check off each morning task. Celebrate when all done!', NULL, ARRAY['Checklist logic', 'Celebration animations', 'Routine building']),
('exp-p79', 'Volcano Island Map', 'explorers', 'beginner', 25, 50, 79, true, 'Build an interactive island map with secrets!', 'Click different areas to discover facts. Find all 5 secrets!', NULL, ARRAY['Interactive maps', 'Click to reveal', 'Exploration design']),
('exp-p80', 'Penguin Ice Skater', 'explorers', 'beginner', 25, 50, 80, true, 'Control a sliding penguin on ice!', 'Penguin slides with momentum. Steer with arrow keys. Avoid cracks!', NULL, ARRAY['Momentum', 'Ice physics', 'Directional control']),
('exp-p81', 'Virtual Aquarium', 'explorers', 'beginner', 25, 50, 81, true, 'Build a virtual aquarium with animated fish!', '5+ fish species swim around. Click to learn about each.', NULL, ARRAY['Ambient animation', 'Click for information', 'Scene design']),
('exp-p82', 'Addition Race', 'explorers', 'beginner', 20, 50, 82, true, 'Race to solve addition problems!', 'Math problems appear. Type answer. Correct = car moves forward.', NULL, ARRAY['Math racing game', 'Speed vs accuracy', 'Progress representation']),
('exp-p83', 'Haunted House', 'explorers', 'intermediate', 35, 75, 83, true, 'Create a spooky haunted house interactive story!', 'Navigate rooms. Ghosts pop out. Find the escape route!', NULL, ARRAY['Navigation', 'Surprise elements', 'Room-based design']),
('exp-p84', 'Cloud Watcher', 'explorers', 'beginner', 20, 50, 84, true, 'Watch cloud shapes drift and change!', 'Clouds move across sky. Click to identify shapes. Add animals!', NULL, ARRAY['Drifting animation', 'Imagination', 'Nature observation']),
('exp-p85', 'Coin Sorter', 'explorers', 'beginner', 25, 50, 85, true, 'Sort Canadian coins — nickel, dime, quarter, loonie!', 'Coins appear randomly. Drag them to the right slot. Count the total.', NULL, ARRAY['Money recognition', 'Drag and drop', 'Canadian currency']),
('exp-p86', 'Build a Sandwich', 'explorers', 'beginner', 20, 50, 86, true, 'Stack sandwich ingredients in the right order!', 'Drag bread, fillings, toppings to build a sandwich layer by layer.', NULL, ARRAY['Drag and drop', 'Layer ordering', 'Food sequencing']),
('exp-p87', 'Sentence Builder', 'explorers', 'beginner', 25, 50, 87, true, 'Drag words to build correct sentences!', 'Scrambled words appear. Arrange them into a proper sentence.', NULL, ARRAY['Word ordering', 'Language learning', 'Drag and arrange']),
('exp-p88', 'Shadow Matching', 'explorers', 'beginner', 20, 50, 88, true, 'Match objects to their shadows!', 'Coloured objects on one side. Silhouettes on other. Drag to match.', NULL, ARRAY['Pattern matching', 'Shape recognition', 'Visual discrimination']),
('exp-p89', 'Pond Frogs Counting', 'explorers', 'beginner', 20, 50, 89, true, 'Count the frogs jumping into the pond!', 'Frogs jump in one by one. Count as they go. Answer the total.', NULL, ARRAY['Counting', 'Subitising', 'Number recognition']),
('exp-p90', 'Music Composer', 'explorers', 'beginner', 30, 50, 90, true, 'Compose a simple song by clicking note blocks!', 'A grid of note buttons. Click to toggle notes. Play your composition!', NULL, ARRAY['Music creation', 'Grid interaction', 'Pattern making']),
('exp-p91', 'Planet Fact Finder', 'explorers', 'beginner', 25, 50, 91, true, 'Click on planets to learn facts about our solar system!', 'Interactive solar system. Click each planet for a fact card.', NULL, ARRAY['Information display', 'Science learning', 'Interactive reference']),
('exp-p92', 'Dress-Up Game', 'explorers', 'beginner', 25, 50, 92, true, 'Mix and match clothes on a character!', 'Arrow buttons cycle through tops, bottoms, shoes, hats.', NULL, ARRAY['Costume cycling', 'Fashion design', 'Layer selection']),
('exp-p93', 'Dinosaur Facts', 'explorers', 'beginner', 25, 50, 93, true, 'Learn about dinosaurs with an interactive quiz!', 'Dinosaur appears. Click to see its name and a cool fact. Quiz at end!', NULL, ARRAY['Flashcard format', 'Prehistoric science', 'Fun facts']),
('exp-p94', 'Car Park Puzzle', 'explorers', 'intermediate', 35, 75, 94, true, 'Slide cars to let the red car escape!', 'Cars block the red car. Move them out of the way in the right order.', NULL, ARRAY['Sliding puzzle', 'Logical thinking', 'Problem solving']),
('exp-p95', 'Volcano Science Experiment', 'explorers', 'beginner', 20, 50, 95, true, 'Simulate a vinegar and baking soda volcano!', 'Click to add ingredients. Watch the reaction. Learn the science!', NULL, ARRAY['Chemistry concepts', 'Sequential steps', 'Science simulation']),
('exp-p96', 'Butterfly Life Cycle Quiz', 'explorers', 'beginner', 20, 50, 96, true, 'Put the butterfly life cycle stages in order!', 'Drag and drop: egg, larva, pupa, adult butterfly in correct order.', NULL, ARRAY['Life cycle knowledge', 'Ordering', 'Biology learning']),
('exp-p97', 'Dream House Builder', 'explorers', 'beginner', 30, 50, 97, true, 'Design your dream house by adding rooms and features!', 'Click rooms to add them: kitchen, bedroom, pool, garden. See the result!', NULL, ARRAY['Design choices', 'Accumulation', 'Creative vision']),
('exp-p98', 'Library Book Organiser', 'explorers', 'beginner', 25, 50, 98, true, 'Sort books by colour or size onto the correct shelf!', 'Books appear randomly. Drag to matching shelf. Level up with more books!', NULL, ARRAY['Categorisation', 'Drag and drop', 'Library skills']),
('exp-p99', 'Emergency Vehicle Race', 'explorers', 'beginner', 25, 50, 99, true, 'Race emergency vehicles to the scene!', 'Police car, ambulance, fire truck: choose the right one for each emergency.', NULL, ARRAY['Decision making', 'Community helpers', 'Selection matching']),
('exp-p100', 'Explorers Grand Finale', 'explorers', 'intermediate', 60, 150, 100, true,
'Your grand finale Explorers project! Build the most amazing Scratch project you can!',
'Combine EVERYTHING you have learned: multiple sprites, costumes, backdrops, variables, score, timer, events, broadcasts, sensing, and animations. Make us proud!',
NULL,
ARRAY['Master-level Scratch skills', 'Creative expression', 'Show all you have learned', 'Build something you are proud of'])

ON CONFLICT (slug) DO NOTHING;


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-builders.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Builders Level Lessons (bld-l01 to bld-l30)
-- Target: Ages 8–11 | HTML, CSS, Scratch
-- =============================================================================

INSERT INTO lessons (slug, title, level, category, duration_minutes, xp_reward, sort_order, is_visible, instructions)
VALUES

('bld-l01', 'Welcome to Builders Level', 'builders', 'HTML', 20, 100, 1, true,
'# Welcome to Builders Level! 🔨

You will learn to build real websites using HTML and CSS.

## Your First Webpage

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My First Page</title>
</head>
<body>
  <h1>Hello, World!</h1>
  <p>I am learning to build websites!</p>
</body>
</html>
```

### Breaking it down:
- `<!DOCTYPE html>` — tells the browser this is HTML
- `<html lang="en">` — the root element
- `<head>` — information about the page (not visible)
- `<meta charset="UTF-8">` — supports all characters
- `<meta name="viewport">` — makes it look right on phones
- `<title>` — text shown in the browser tab
- `<body>` — everything shown on the page

## Try It!

1. Open the Code Lab
2. Type the HTML above exactly
3. Press Run to see your page
4. Change the `<h1>` text to your name
5. Add a second `<p>` about yourself'),

('bld-l02', 'HTML Text and Headings', 'builders', 'HTML', 25, 100, 2, true,
'# HTML Text and Headings

HTML has six levels of headings from `<h1>` (biggest) to `<h6>` (smallest).

```html
<h1>Main Title — only ONE per page!</h1>
<h2>Section Heading</h2>
<h3>Sub-section</h3>
```

## Paragraphs and Emphasis

```html
<p>This is a paragraph with a <strong>bold word</strong> and an <em>italic word</em>.</p>
<p>Second paragraph.<br>Line break inside a paragraph.</p>
```

## Lists

```html
<!-- Bullet list -->
<ul>
  <li>Apples</li>
  <li>Bananas</li>
</ul>

<!-- Numbered list -->
<ol>
  <li>Step one</li>
  <li>Step two</li>
</ol>
```

## Challenge

Build a page about your favourite animal with an `<h1>`, a list of 3 fun facts, and a description paragraph.'),

('bld-l03', 'HTML Links and Images', 'builders', 'HTML', 25, 100, 3, true,
'# HTML Links and Images

## Links

```html
<a href="https://example.com" target="_blank" rel="noopener noreferrer">Open in new tab</a>
<a href="about.html">Go to About page</a>
<a href="#section-id">Jump to section</a>
```

Always add `rel="noopener noreferrer"` with `target="_blank"` for security.

## Images

```html
<img src="cat.jpg" alt="A fluffy orange cat on a windowsill" width="400">
<img src="https://picsum.photos/400/300" alt="Random nature photo">
```

The `alt` attribute is REQUIRED for accessibility — screen readers read it aloud.

## Image Links

```html
<a href="https://example.com">
  <img src="logo.png" alt="Visit Example.com">
</a>
```

## Challenge

Build a "Favourite Websites" page with 3 links opening in new tabs and one image from picsum.photos.'),

('bld-l04', 'HTML Semantic Structure', 'builders', 'HTML', 25, 100, 4, true,
'# Semantic HTML — The Right Tag for the Right Job

Semantic HTML uses tags that describe their meaning, not just appearance.

```html
<body>
  <header>
    <h1>My Website</h1>
    <nav>
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/about">About</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <article>
      <h2>My Post</h2>
      <p>Main content goes here.</p>
    </article>
    <aside>
      <p>Related links go here.</p>
    </aside>
  </main>

  <footer>
    <p>&copy; 2025 My Website</p>
  </footer>
</body>
```

Key tags: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, `<footer>`

Only ONE `<main>` per page!

## Challenge

Build a structured personal webpage using all the semantic tags above.'),

('bld-l05', 'HTML Tables', 'builders', 'HTML', 25, 100, 5, true,
'# HTML Tables — For Data

Tables display information in rows and columns, like a spreadsheet.

```html
<table>
  <caption>Class Schedule</caption>
  <thead>
    <tr>
      <th scope="col">Time</th>
      <th scope="col">Monday</th>
      <th scope="col">Tuesday</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>9:00 AM</td>
      <td>Math</td>
      <td>Science</td>
    </tr>
    <tr>
      <td>10:00 AM</td>
      <td>Art</td>
      <td>PE</td>
    </tr>
  </tbody>
</table>
```

`colspan="2"` makes a cell span 2 columns. `rowspan="2"` spans 2 rows.

**Important:** Use tables for data ONLY, not for page layout.

## Challenge

Build an HTML table showing your weekly schedule with at least 5 subjects.'),

('bld-l06', 'HTML Forms', 'builders', 'HTML', 30, 100, 6, true,
'# HTML Forms

Forms collect information from users.

```html
<form action="/submit" method="POST">
  <label for="name">Your Name:</label>
  <input type="text" id="name" name="name" placeholder="Alex" required>

  <label for="email">Email:</label>
  <input type="email" id="email" name="email" required>

  <label for="grade">Grade:</label>
  <select id="grade" name="grade">
    <option value="">Choose...</option>
    <option value="4">Grade 4</option>
    <option value="5">Grade 5</option>
  </select>

  <label for="message">Message:</label>
  <textarea id="message" name="message" rows="4"></textarea>

  <input type="checkbox" id="agree" name="agree" required>
  <label for="agree">I agree to the terms</label>

  <button type="submit">Send</button>
</form>
```

Always link `<label>` to `<input>` using matching `for` and `id`.

## Challenge

Build a contact form with name, email, subject dropdown, message, and submit button.'),

('bld-l07', 'Introduction to CSS', 'builders', 'CSS', 25, 100, 7, true,
'# Introduction to CSS

CSS (Cascading Style Sheets) controls how HTML looks.

## Adding CSS

```html
<!-- Best practice: external file -->
<link rel="stylesheet" href="styles.css">
```

## CSS Syntax

```css
/* selector { property: value; } */

h1 {
  color: navy;
  font-size: 32px;
}

.highlight {
  background-color: yellow;
}

#main-title {
  text-align: center;
}
```

Selectors: `element`, `.class`, `#id`, `nav a` (descendant)

## Common Properties

```css
color: #1E2140;
font-family: Arial, sans-serif;
font-size: 18px;
font-weight: bold;
background-color: #F4F4F8;
margin: 20px;
padding: 15px;
border: 2px solid navy;
border-radius: 8px;
text-decoration: none;
```

## Challenge

Style a webpage with custom colours, fonts, and spacing using a separate CSS file.'),

('bld-l08', 'CSS Box Model', 'builders', 'CSS', 30, 100, 8, true,
'# The CSS Box Model

Every HTML element is a box with 4 layers: content, padding, border, margin.

```
[ MARGIN [ BORDER [ PADDING [ CONTENT ] ] ] ]
```

## Setting Properties

```css
* { box-sizing: border-box; }  /* Always add this! */

.card {
  width: 300px;
  padding: 24px;           /* inside space */
  border: 2px solid navy;
  border-radius: 12px;
  margin: 16px;            /* outside space */
}

/* Shorthand: top right bottom left */
padding: 10px 20px 10px 20px;

/* Shorthand: top/bottom left/right */
padding: 10px 20px;

/* Centre horizontally */
margin: 0 auto;
```

## Why `box-sizing: border-box`?

Without it, `padding` is ADDED to `width` (confusing!).
With it, `padding` is INSIDE the `width` (makes sense!).

Always put `* { box-sizing: border-box; }` at the top of your CSS.

## Challenge

Build a card component with proper padding, border-radius, and margin.'),

('bld-l09', 'CSS Colors and Typography', 'builders', 'CSS', 25, 100, 9, true,
'# CSS Colors and Typography

## Colour Formats

```css
color: red;              /* named */
color: #1E2140;          /* hex (most common) */
color: rgb(30, 33, 64);  /* RGB */
color: rgba(30, 33, 64, 0.5); /* RGB + transparency */
```

## Backgrounds

```css
background-color: #F4F4F8;
background: linear-gradient(135deg, #1E2140, #3A3D5C);
background-image: url(''hero.jpg'');
background-size: cover;
background-position: center;
```

## Typography

```css
font-family: ''Arial'', sans-serif;
font-size: 18px;
font-weight: bold;  /* or 700 */
line-height: 1.6;
letter-spacing: 0.05em;
text-transform: uppercase;
```

## CSS Custom Properties (Variables)

```css
:root {
  --color-primary: #1E2140;
  --color-accent: #F5C518;
  --space-md: 16px;
}

h1 { color: var(--color-primary); }
.btn { background: var(--color-accent); }
```

## Challenge

Create a typography showcase using Google Fonts and CSS variables for your colour palette.'),

('bld-l10', 'CSS Flexbox Basics', 'builders', 'CSS', 30, 100, 10, true,
'# CSS Flexbox — Flexible Layouts

Flexbox arranges items in a row or column.

```css
.container {
  display: flex;
  flex-direction: row;          /* or column */
  justify-content: space-between; /* main axis alignment */
  align-items: center;           /* cross axis alignment */
  gap: 16px;
  flex-wrap: wrap;               /* items wrap if no room */
}
```

## justify-content options:
`flex-start` | `flex-end` | `center` | `space-between` | `space-around` | `space-evenly`

## align-items options:
`flex-start` | `flex-end` | `center` | `stretch`

## Centering Anything

```css
.centered {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
```

## Navigation Bar

```css
nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 32px;
  background: #1E2140;
}
nav ul {
  display: flex;
  list-style: none;
  gap: 24px;
}
```

## Challenge

Build a responsive navigation bar using Flexbox: logo left, links right.'),

('bld-l11', 'CSS Grid Layout', 'builders', 'CSS', 30, 100, 11, true,
'# CSS Grid — Two-Dimensional Layouts

Grid controls both rows AND columns at the same time.

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto 1fr auto;
  gap: 20px;
}
```

## Named Areas

```css
.page {
  display: grid;
  grid-template-areas:
    "header header"
    "sidebar content"
    "footer footer";
  grid-template-columns: 200px 1fr;
}

header  { grid-area: header; }
.sidebar { grid-area: sidebar; }
main    { grid-area: content; }
footer  { grid-area: footer; }
```

## Auto-Responsive Grid (No Media Queries!)

```css
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 16px;
}
```

## Challenge

Build a magazine layout: full-width header, 3-column article grid, sidebar, footer.'),

('bld-l12', 'CSS Hover and Transitions', 'builders', 'CSS', 25, 100, 12, true,
'# CSS Hover Effects and Transitions

## :hover

```css
button {
  background: navy;
  transition: all 0.3s ease;  /* add BEFORE hover */
}

button:hover {
  background: gold;
  transform: translateY(-2px);
}
```

## Transitions

```css
/* transition: property duration timing */
transition: background-color 0.3s ease;
transition: all 0.3s ease-out;
transition: transform 0.2s, box-shadow 0.2s;
```

## Transform

```css
transform: translateY(-4px);  /* move up */
transform: scale(1.05);       /* 5% bigger */
transform: rotate(45deg);     /* rotate */
```

## Card Hover Effect

```css
.card {
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.15);
}
```

## Challenge

Build 4 cards each with a different hover effect: colour change, lift, scale, border glow.'),

('bld-l13', 'CSS Positioning', 'builders', 'CSS', 25, 100, 13, true,
'# CSS Positioning

```css
position: static;    /* default, normal flow */
position: relative;  /* offset from normal position */
position: absolute;  /* relative to nearest positioned parent */
position: fixed;     /* fixed to the viewport */
position: sticky;    /* normal flow, then fixed when scrolled */
```

## Practical Examples

```css
/* Fixed navbar */
.navbar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 100;
}

/* Badge on a card */
.card { position: relative; }
.badge {
  position: absolute;
  top: -8px; right: -8px;
  width: 24px; height: 24px;
  border-radius: 50%;
  background: red;
  color: white;
}

/* Sticky sidebar */
.sidebar {
  position: sticky;
  top: 20px;
}
```

## z-index

Higher z-index = appears on top of other elements.

## Challenge

Build a page with: a fixed navbar, a sticky sidebar, and a card with an absolute badge.'),

('bld-l14', 'CSS Animations', 'builders', 'CSS', 25, 100, 14, true,
'# CSS Animations

## @keyframes

```css
@keyframes slideIn {
  from { transform: translateX(-100%); opacity: 0; }
  to   { transform: translateX(0);     opacity: 1; }
}

.element {
  animation: slideIn 0.5s ease forwards;
}
```

## Multiple Steps

```css
@keyframes bounce {
  0%   { transform: translateY(0); }
  25%  { transform: translateY(-20px); }
  50%  { transform: translateY(0); }
  75%  { transform: translateY(-10px); }
  100% { transform: translateY(0); }
}

.ball { animation: bounce 1s ease infinite; }
```

## Loading Spinner

```css
@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}

.spinner {
  width: 40px; height: 40px;
  border: 4px solid #f3f3f3;
  border-top-color: navy;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}
```

## Challenge

Create a loading spinner, a pulsing button, and a slide-in hero section.'),

('bld-l15', 'Responsive Design', 'builders', 'CSS', 30, 100, 15, true,
'# Responsive Design — Every Screen Size

## The Viewport Meta Tag

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

Always include this! Without it, mobile browsers zoom out.

## Media Queries

```css
/* Mobile first: default styles for small screens */
.cards { grid-template-columns: 1fr; }

/* Tablet */
@media (min-width: 600px) {
  .cards { grid-template-columns: repeat(2, 1fr); }
}

/* Desktop */
@media (min-width: 1024px) {
  .cards { grid-template-columns: repeat(3, 1fr); }
}
```

## Common Breakpoints

- Mobile: up to 600px
- Tablet: 600px–1024px
- Desktop: 1024px+

## Fluid Images

```css
img { max-width: 100%; height: auto; }
```

## Challenge

Make a desktop layout fully responsive: 1 column on mobile, 2 on tablet, 3 on desktop.'),

('bld-l16', 'Building a Navigation Bar', 'builders', 'CSS', 30, 100, 16, true,
'# Professional Navigation Bar

## HTML

```html
<header>
  <nav class="navbar">
    <a href="/" class="logo">🚀 MySite</a>
    <button class="hamburger" id="menuBtn" aria-label="Open menu">☰</button>
    <ul class="nav-links" id="navLinks">
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
      <li><a href="/contact">Contact</a></li>
    </ul>
  </nav>
</header>
```

## CSS

```css
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 32px;
  background: #1E2140;
  position: sticky;
  top: 0;
  z-index: 100;
}
.logo { color: #F5C518; font-size: 24px; font-weight: bold; text-decoration: none; }
.nav-links { display: flex; list-style: none; gap: 32px; }
.nav-links a { color: white; text-decoration: none; transition: color 0.2s; }
.nav-links a:hover { color: #F5C518; }
.hamburger { display: none; background: none; border: none; color: white; font-size: 24px; }

@media (max-width: 768px) {
  .hamburger { display: block; }
  .nav-links {
    display: none; flex-direction: column;
    position: absolute; top: 100%; left: 0; right: 0;
    background: #1E2140; padding: 16px;
  }
  .nav-links.open { display: flex; }
}
```

## JavaScript

```html
<script>
  document.getElementById(''menuBtn'').addEventListener(''click'', () => {
    document.getElementById(''navLinks'').classList.toggle(''open'');
  });
</script>
```

## Challenge

Build a complete responsive navbar for a personal portfolio site.'),

('bld-l17', 'CSS Variables', 'builders', 'CSS', 20, 100, 17, true,
'# CSS Custom Properties (Variables)

Define values once, use them everywhere. Change one line to update your whole site!

## Defining Variables

```css
:root {
  --color-primary: #1E2140;
  --color-accent: #F5C518;
  --color-bg: #F4F4F8;
  --color-text: #2B2D42;
  --font-body: ''Inter'', sans-serif;
  --space-md: 16px;
  --space-lg: 24px;
  --radius: 8px;
  --shadow: 0 2px 8px rgba(0,0,0,0.1);
}
```

## Using Variables

```css
body { background: var(--color-bg); color: var(--color-text); }
.btn { background: var(--color-accent); padding: var(--space-md); border-radius: var(--radius); }
.card { box-shadow: var(--shadow); }
```

## Dark Mode

```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: #1E2140;
    --color-text: #F4F4F8;
  }
}
```

## Challenge

Refactor a site to use CSS variables for all colours, spacing, and radii. Add dark mode support.'),

('bld-l18', 'CSS Pseudo-classes', 'builders', 'CSS', 20, 100, 18, true,
'# Pseudo-classes and Pseudo-elements

## Common Pseudo-classes

```css
a:hover   { color: gold; }
a:focus   { outline: 3px solid gold; }
a:visited { color: purple; }

input:focus   { border-color: navy; }
input:invalid { border-color: red; }
input:valid   { border-color: green; }

li:first-child { font-weight: bold; }
li:last-child  { margin-bottom: 0; }
li:nth-child(odd)  { background: #f5f5f5; }
li:nth-child(even) { background: white; }

div:not(.special) { opacity: 0.7; }
```

## Pseudo-elements

```css
p::first-letter { font-size: 3em; float: left; }
p::first-line   { font-weight: bold; }

/* Add decorative content without HTML */
.btn::before { content: "→ "; }

h2::after {
  content: "";
  display: block;
  width: 60px; height: 3px;
  background: gold;
  margin-top: 8px;
}
```

## Challenge

Style a table with zebra stripes using nth-child, and add decorative underlines to headings using ::after.'),

('bld-l19', 'Multi-Page Website', 'builders', 'HTML', 30, 100, 19, true,
'# Building a Multi-Page Website

## File Structure

```
my-site/
├── index.html
├── about.html
├── projects.html
├── contact.html
└── css/
    └── styles.css
```

## Shared Navigation

Copy to every page — only change the `href` of the active link:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home — My Portfolio</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <header>
    <nav class="navbar">
      <a href="index.html" class="logo">🚀 Your Name</a>
      <ul class="nav-links">
        <li><a href="index.html" aria-current="page">Home</a></li>
        <li><a href="about.html">About</a></li>
        <li><a href="projects.html">Projects</a></li>
        <li><a href="contact.html">Contact</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <!-- PAGE CONTENT HERE -->
  </main>

  <footer>
    <p>&copy; 2025 Your Name</p>
  </footer>
</body>
</html>
```

## Challenge

Build a 4-page portfolio: Home (hero + skills), About, Projects (3 cards), Contact (form). All pages share nav + footer.'),

('bld-l20', 'CSS Hero Sections', 'builders', 'CSS', 25, 100, 20, true,
'# Hero Sections and Background Images

## Full-Height Hero

```css
.hero {
  min-height: 100vh;
  background: linear-gradient(135deg, #1E2140, #3A3D5C);
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: white;
}
```

## Photo Hero with Overlay

```css
.hero {
  position: relative;
  background-image: url(''hero.jpg'');
  background-size: cover;
  background-position: center;
}

.hero::before {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
}

.hero-content {
  position: relative;
  z-index: 1;
  color: white;
}
```

## Gradient Hero

```css
.hero {
  background: linear-gradient(
    135deg,
    #1E2140 0%,
    #3A3D5C 50%,
    #F5C518 100%
  );
}
```

## Challenge

Build 3 hero sections: dark photo overlay, gradient, and a geometric CSS pattern.'),

('bld-l21', 'Web Accessibility', 'builders', 'Accessibility', 25, 100, 21, true,
'# Web Accessibility

Everyone deserves to use the web! In Canada, AODA requires accessible websites.

## Key Rules

### 1. Semantic HTML
```html
<button>Submit</button>  <!-- screen reader says "Submit, button" -->
<nav>...</nav>           <!-- screen reader announces "navigation" -->
```

### 2. Alt Text
```html
<img src="chart.png" alt="Bar chart showing 75% prefer coding">
<img src="divider.png" alt="">  <!-- decorative: empty alt -->
```

### 3. Form Labels
```html
<label for="email">Email</label>
<input type="email" id="email" required aria-describedby="hint">
<p id="hint">We will never share your email.</p>
```

### 4. Focus Styles
```css
/* NEVER remove focus outlines */
:focus-visible {
  outline: 3px solid #F5C518;
  outline-offset: 2px;
}
```

### 5. Skip Links
```html
<a href="#main" class="skip-link">Skip to content</a>
```

### 6. ARIA When Needed
```html
<button aria-expanded="false" aria-controls="menu">Menu</button>
<nav id="menu" aria-hidden="true">...</nav>
```

## Challenge

Audit your portfolio: keyboard-only navigation, alt text, proper labels, visible focus styles.'),

('bld-l22', 'Scratch Sprites and Backdrops', 'builders', 'Scratch', 25, 100, 22, true,
'# Scratch — Sprites and Backdrops

The stage is 480×360 pixels. Sprites are the characters; backdrops are backgrounds.

## First Script

```
When [🚩] clicked
  Say [Hello!] for [2] seconds
  Move [10] steps
```

## Moving with Arrow Keys

```
When [🚩] clicked
  Forever
    If [Right Arrow pressed?]
      Change x by [10]
    If [Left Arrow pressed?]
      Change x by [-10]
    If [Up Arrow pressed?]
      Change y by [10]
    If [Down Arrow pressed?]
      Change y by [-10]
```

## Costume Animation

```
When [🚩] clicked
  Forever
    Next Costume
    Wait [0.1] seconds
```

## Block Categories

- 🟡 Motion | 🟣 Looks | 🔵 Sound | 🟡 Events
- 🟠 Control | 🔵 Sensing | 🟢 Operators | 🔴 Variables

## Challenge

Build a Scratch project with a sprite that moves with arrow keys, animates between costumes, and says something when it touches the edge.'),

('bld-l23', 'Scratch Events and Control', 'builders', 'Scratch', 25, 100, 23, true,
'# Scratch — Events and Control

## Events

```
When [🚩] clicked
When [space] key pressed
When this sprite clicked
When I receive [message1]
```

## Control

```
Forever
Repeat [10]
Repeat Until [score = 0]

If [score > 10]
  Say [You win!]
Else
  Say [Keep going!]

Wait [2] seconds
Stop [all]
```

## Broadcasting

Sprites talk to each other with broadcasts:

```
/* Sprite 1 */
When [🚩] clicked
  Broadcast [start]

/* Sprite 2 */
When I receive [start]
  Show
  Go to x:[0] y:[0]
```

## Simple Quiz

```
When [🚩] clicked
  Set [score] to [0]
  Ask [What is 2 + 2?] and wait
  If [answer = "4"]
    Say [Correct!] for [2] seconds
    Change [score] by [1]
  Else
    Say [Not quite!] for [2] seconds
```

## Challenge

Build a 3-question quiz that keeps score and uses broadcasts between sprites.'),

('bld-l24', 'Scratch Variables and Score', 'builders', 'Scratch', 25, 100, 24, true,
'# Scratch Variables

Variables store values that can change — like score, lives, or time.

## Creating Variables

Variables tab → Make a Variable → name it → "For all sprites" or "For this sprite only"

## Key Blocks

```
Set [score] to [0]       -- give a specific value
Change [score] by [1]    -- add or subtract
Show variable [score]    -- display on stage
Hide variable [score]    -- hide from stage
```

## Score System

```
When [🚩] clicked
  Set [score] to [0]
  Set [lives] to [3]

When [this sprite] clicked
  Change [score] by [10]
  Play sound [pop]

When [🚩] clicked
  Forever
    If [lives = 0]
      Say [join [Game Over! Score: ] [score]]
      Stop [all]
```

## Timer Countdown

```
When [🚩] clicked
  Set [timer] to [30]
  Repeat [30]
    Wait [1] seconds
    Change [timer] by [-1]
  Broadcast [time up]
```

## Challenge

Build a game with score, lives, and a 30-second timer.'),

('bld-l25', 'CSS Flexbox Advanced', 'builders', 'CSS', 25, 100, 25, true,
'# CSS Flexbox — Advanced

## flex shorthand

```css
.item { flex: 1; }        /* grow:1 shrink:1 basis:0 */
.item { flex: 0 0 200px; } /* fixed 200px */
.item { flex: 2; }        /* twice as wide as flex:1 */
```

## Wrap Pattern for Cards

```css
.cards {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.card {
  flex: 1 1 280px;  /* min 280px, grows to fill */
  max-width: 400px;
}
```

## Sticky Footer

```css
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

main   { flex: 1; } /* pushes footer to bottom */
footer { /* stays at bottom automatically */ }
```

## align-self (override align-items for one item)

```css
.container { display: flex; align-items: center; }
.special   { align-self: flex-end; }
```

## Challenge

Build a photo gallery with flex-wrap, and a layout with a sticky footer.'),

('bld-l26', 'HTML Forms Advanced', 'builders', 'HTML', 25, 100, 26, true,
'# HTML Forms — Validation and Grouping

## HTML5 Built-in Validation

```html
<input type="text"     required minlength="3" maxlength="50">
<input type="number"   min="1" max="100">
<input type="email"    required>
<input type="url"      required>
<input type="date"     min="2020-01-01">
<input type="password" minlength="8">
<input type="text"     pattern="[A-Z]{3}[0-9]{3}"
       title="3 uppercase letters then 3 numbers">
```

## Styling Validation

```css
input:valid   { border-color: green; }
input:invalid { border-color: red; }
input:not(:placeholder-shown):invalid { border-color: red; }
```

## Fieldset Grouping

```html
<form>
  <fieldset>
    <legend>Personal Info</legend>
    <label for="fname">First Name</label>
    <input type="text" id="fname" name="fname" required>
  </fieldset>

  <fieldset>
    <legend>Account</legend>
    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>
  </fieldset>

  <button type="submit">Register</button>
</form>
```

## Challenge

Build a multi-section registration form with client-side validation and error styling.'),

('bld-l27', 'Scratch Sensing', 'builders', 'Scratch', 25, 100, 27, true,
'# Scratch — Sensing Blocks

## Key Sensing Blocks

```
Touching [mouse pointer]?
Touching [Cat]?
Touching color [blue]?
Distance to [mouse pointer]
Mouse x, Mouse y
Mouse down?
Key [space] pressed?
Answer
Loudness
```

## Mouse Follower

```
When [🚩] clicked
  Forever
    Go to x:[mouse x] y:[mouse y]
```

## Collision

```
When [🚩] clicked
  Forever
    If [touching [Enemy]?]
      Change [lives] by [-1]
      Go to x:[0] y:[0]
```

## Ask and Answer

```
When [🚩] clicked
  Ask [What is your name?] and wait
  Say [join [Hello, ] [answer]] for [2] seconds
```

## Distance-Based Reaction

```
When [🚩] clicked
  Forever
    If [distance to [Player] < 50]
      Broadcast [danger]
```

## Challenge

Build an interactive Scratch story that: asks 3 questions, uses answers in the story, and has collision detection.'),

('bld-l28', 'CSS Grid Advanced', 'builders', 'CSS', 25, 100, 28, true,
'# CSS Grid — Advanced Layouts

## Spanning Items

```css
.featured { grid-column: span 2; }  /* 2 cols wide */
.banner   { grid-column: 1 / -1; } /* full width */
.tall     { grid-row: span 2; }     /* 2 rows tall */
```

## Template Areas (Complex Layouts)

```css
.page {
  display: grid;
  grid-template-areas:
    "header header header"
    "sidebar main ads"
    "footer footer footer";
  grid-template-columns: 180px 1fr 150px;
  min-height: 100vh;
}

header  { grid-area: header; }
.sidebar { grid-area: sidebar; }
main    { grid-area: main; }
.ads    { grid-area: ads; }
footer  { grid-area: footer; }

@media (max-width: 768px) {
  .page {
    grid-template-areas:
      "header"
      "main"
      "sidebar"
      "footer";
    grid-template-columns: 1fr;
  }
}
```

## Auto-Fill

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
}
```

## Challenge

Build a full magazine layout with grid-template-areas, responsive at all breakpoints.'),

('bld-l29', 'HTML Multimedia', 'builders', 'HTML', 20, 100, 29, true,
'# HTML Multimedia

## Video

```html
<video controls width="640" poster="thumbnail.jpg">
  <source src="video.mp4" type="video/mp4">
  <p>Your browser does not support video. <a href="video.mp4">Download it</a>.</p>
</video>

<!-- Background video (no controls) -->
<video autoplay muted loop playsinline>
  <source src="bg.mp4" type="video/mp4">
</video>
```

## Audio

```html
<audio controls>
  <source src="audio.mp3" type="audio/mpeg">
  <p>Your browser does not support audio.</p>
</audio>
```

## Responsive Images with `<picture>`

```html
<picture>
  <source media="(max-width: 600px)" srcset="small.jpg">
  <source media="(max-width: 1024px)" srcset="medium.jpg">
  <img src="large.jpg" alt="Description">
</picture>
```

## Figure and Figcaption

```html
<figure>
  <img src="chart.png" alt="Bar chart showing results">
  <figcaption>Fig. 1 — Results from our survey.</figcaption>
</figure>
```

## Challenge

Build a media page with a YouTube embed, audio player, responsive picture element, all in figure elements.'),

('bld-l30', 'Builders Level Portfolio', 'builders', 'HTML', 30, 100, 30, true,
'# Builders Level — Final Portfolio Project

You have mastered the foundations of web development! Time to show the world.

## What You Have Learned

### HTML ✅
Semantic structure, links, images, tables, forms, multimedia

### CSS ✅
Box model, colours, typography, Flexbox, Grid, transitions, animations, responsive design, variables, pseudo-classes

### Scratch ✅
Sprites, events, control, variables, sensing, broadcasting

## Final Project: Personal Portfolio

Build a 4-page website:

### Page 1: Home
- Full-height gradient hero with your name
- Skills grid (HTML, CSS, Scratch)
- 3 project preview cards

### Page 2: About
- Your story and interests
- Learning goals

### Page 3: Projects
- 6 project cards with hover effects
- Each card: title, description, link

### Page 4: Contact
- Full contact form with validation

### Requirements
- ✅ Responsive on all screen sizes
- ✅ CSS variables for colours
- ✅ Smooth hover transitions
- ✅ Semantic HTML throughout
- ✅ Accessible (alt text, focus styles, labels)
- ✅ Shared navigation and footer
- ✅ At least one CSS animation

You are a Builder. Now build something amazing! 🔨')

ON CONFLICT (slug) DO NOTHING;

-- =============================================================================
-- Builders Lessons 31–60 (structured content)
-- Completes the 60-lesson Builders curriculum (CSS deep-dive, Scratch, a11y).
-- =============================================================================

INSERT INTO lessons (slug, title, level, category, duration_minutes, xp_reward, sort_order, is_visible, instructions)
SELECT
  'bld-l' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'builders',
  category,
  25,
  100,
  n,
  true,
  '## ' || title || E'\n\n' ||
  'In this lesson you will learn about **' || title || '** as part of the ' || category || ' track.\n\n' ||
  E'### What you will learn\n' ||
  '- The core idea behind ' || title || E'\n' ||
  E'- How to use it in a real web page\n' ||
  E'- Common mistakes and how to fix them\n\n' ||
  E'### Example\n\n' ||
  E'```html\n<!-- Try this in your Code Lab -->\n<div class="demo">' || title || E'</div>\n```\n\n' ||
  E'```css\n.demo {\n  padding: 16px;\n  border-radius: 12px;\n  background: #F5C518;\n  color: #1E2140;\n  font-weight: 700;\n}\n```\n\n' ||
  E'### Activity\nOpen the **Code Lab** and recreate the example above, then change the colours and spacing to make it your own.\n\n' ||
  E'### Key takeaways\n- ' || title || E' helps you build better, more professional websites.\n- Practice by building a small demo for each new concept.\n- Combine this skill with what you already know from earlier lessons.'
FROM (VALUES
  (31, 'CSS Grid: Two-Dimensional Layouts', 'CSS', 'intermediate'),
  (32, 'CSS Grid: Areas and Template Names', 'CSS', 'intermediate'),
  (33, 'Responsive Design: Mobile-First Thinking', 'CSS', 'intermediate'),
  (34, 'Media Queries: Adapting to Any Screen', 'CSS', 'intermediate'),
  (35, 'CSS Transitions: Smooth Motion', 'CSS', 'beginner'),
  (36, 'CSS Animations and Keyframes', 'CSS', 'intermediate'),
  (37, 'CSS Transforms: Scale, Rotate, Translate', 'CSS', 'intermediate'),
  (38, 'Pseudo-classes: :hover, :focus, :nth-child', 'CSS', 'intermediate'),
  (39, 'Pseudo-elements: ::before and ::after', 'CSS', 'intermediate'),
  (40, 'CSS Custom Properties (Variables)', 'CSS', 'intermediate'),
  (41, 'Building a Navigation Bar', 'CSS', 'intermediate'),
  (42, 'CSS Gradients: Linear and Radial', 'CSS', 'beginner'),
  (43, 'Box Shadows and Depth', 'CSS', 'beginner'),
  (44, 'CSS Positioning: Relative, Absolute, Fixed, Sticky', 'CSS', 'intermediate'),
  (45, 'Z-Index and Stacking Context', 'CSS', 'intermediate'),
  (46, 'Web Accessibility: Why It Matters', 'Accessibility', 'beginner'),
  (47, 'Accessible Colours and Contrast', 'Accessibility', 'beginner'),
  (48, 'ARIA Labels and Roles', 'Accessibility', 'intermediate'),
  (49, 'Keyboard Navigation and Focus States', 'Accessibility', 'intermediate'),
  (50, 'Semantic HTML for Screen Readers', 'Accessibility', 'beginner'),
  (51, 'Introduction to the Canvas Element', 'HTML', 'intermediate'),
  (52, 'Scratch: Variables and Scores', 'Scratch', 'beginner'),
  (53, 'Scratch: Broadcasting Messages', 'Scratch', 'intermediate'),
  (54, 'Scratch: Cloning Sprites', 'Scratch', 'intermediate'),
  (55, 'Scratch: Building a Simple Game', 'Scratch', 'intermediate'),
  (56, 'SEO Basics: Helping People Find Your Site', 'HTML', 'beginner'),
  (57, 'Meta Tags and Open Graph', 'HTML', 'beginner'),
  (58, 'Print Styles and @media print', 'CSS', 'intermediate'),
  (59, 'Putting It Together: A Multi-Page Site', 'Projects', 'intermediate'),
  (60, 'Builders Capstone: Your Portfolio Website', 'Projects', 'intermediate')
) AS t(n, title, category, difficulty)
ON CONFLICT (slug) DO NOTHING;


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-builders-projects.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Builders Projects (bld-p01 to bld-p100)
-- =============================================================================

DO $$
DECLARE
  html_template TEXT := '<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Project</title>
  <style>
    /* Your styles go here */
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
    }
  </style>
</head>
<body>
  <!-- Your HTML goes here -->
  <h1>Hello, World!</h1>
</body>
</html>';

BEGIN

INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order) VALUES
('bld-p01', 'My First HTML Page', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My First Page</title>
</head>
<body>
  <h1>Hello World!</h1>
  <p>This is my first HTML page.</p>
</body>
</html>',
'## My First HTML Page

Create a simple HTML page all about yourself!

### Steps:
1. Change the `<h1>` to say your name
2. Add a `<p>` paragraph about your favourite colour
3. Add another `<p>` about your favourite food
4. Add an `<h2>` that says "My Hobbies"
5. Add a `<ul>` list with 3 of your hobbies

### Bonus:
Add a `<footer>` with the date you made this page!',
ARRAY['html', 'beginner', 'personal'], 200, 1),

('bld-p02', 'All About Me Page', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>All About Me</title>
</head>
<body>
  <h1>All About Me!</h1>
  <section>
    <h2>Who Am I?</h2>
    <p>Write about yourself here...</p>
  </section>
  <section>
    <h2>My Favourite Things</h2>
    <ul>
      <li>Item 1</li>
    </ul>
  </section>
</body>
</html>',
'## All About Me Page

Build a page telling the world all about you!

### What to include:
1. Your name as the main heading
2. A short introduction about yourself
3. Your favourite things (as a list)
4. Your favourite book or movie
5. A fun fact about yourself

### Remember:
- Use `<h1>` for the title
- Use `<h2>` for section headings
- Use `<p>` for paragraphs
- Use `<ul>` and `<li>` for lists',
ARRAY['html', 'beginner', 'personal'], 200, 2),

('bld-p03', 'Favourite Animal Fan Page', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Favourite Animal</title>
</head>
<body>
  <h1>🐼 Giant Pandas!</h1>
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grosser_Panda.JPG/330px-Grosser_Panda.JPG" alt="A giant panda eating bamboo" width="300">
  <h2>About Giant Pandas</h2>
  <p>Replace this with facts about your favourite animal!</p>
  <h2>Fun Facts</h2>
  <ul>
    <li>Add a fun fact here</li>
    <li>Add another fact here</li>
  </ul>
</body>
</html>',
'## Favourite Animal Fan Page

Create a fan page for your absolute favourite animal!

### Steps:
1. Change the heading to your favourite animal name
2. Find a free image of your animal (or keep the panda!)
3. Write 2-3 paragraphs of facts about the animal
4. Create a "Fun Facts" section with a bulleted list
5. Add a "Where do they live?" section with a description

### Use these HTML tags:
- `<h1>` — main title
- `<img>` — picture
- `<h2>` — section headings
- `<p>` — paragraphs
- `<ul>` and `<li>` — fun facts list',
ARRAY['html', 'images', 'beginner'], 200, 3),

('bld-p04', 'My Hobby Page with Lists and Links', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Hobbies</title>
</head>
<body>
  <h1>My Favourite Hobbies</h1>
  <nav>
    <a href="#hobby1">Hobby 1</a> |
    <a href="#hobby2">Hobby 2</a> |
    <a href="#hobby3">Hobby 3</a>
  </nav>
  <section id="hobby1">
    <h2>Your First Hobby</h2>
    <p>Write about it here...</p>
  </section>
</body>
</html>',
'## My Hobby Page with Lists and Links

Build a page showcasing your top 3 hobbies!

### Requirements:
1. A title heading
2. A navigation bar with links to each hobby section (use `<a href="#id">`)
3. Three hobby sections, each with:
   - A heading (`<h2>`)
   - A description paragraph
   - A list of things you like about it
4. Use `id=""` attributes on sections so links work

### Challenge:
Add an ordered list (`<ol>`) of steps to start your hobby!',
ARRAY['html', 'links', 'lists', 'navigation'], 200, 4),

('bld-p05', 'School Schedule Table', 'builders', 'HTML',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My School Schedule</title>
</head>
<body>
  <h1>My School Schedule</h1>
  <table border="1">
    <thead>
      <tr>
        <th>Time</th>
        <th>Monday</th>
        <th>Tuesday</th>
        <th>Wednesday</th>
        <th>Thursday</th>
        <th>Friday</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>9:00 AM</td>
        <td>Math</td>
        <td>English</td>
        <td>Math</td>
        <td>Science</td>
        <td>Art</td>
      </tr>
      <tr>
        <td>10:00 AM</td>
        <td>Science</td>
        <td>Math</td>
        <td>History</td>
        <td>Math</td>
        <td>PE</td>
      </tr>
    </tbody>
  </table>
</body>
</html>',
'## School Schedule Table

Create an HTML table of your weekly school schedule!

### Steps:
1. The table should show your full week (Mon-Fri)
2. Each row is a time slot
3. Each cell shows the subject
4. Use `<thead>` for the header row
5. Use `<tbody>` for the data rows

### Table tags to use:
- `<table>` — the whole table
- `<thead>` / `<tbody>` — table sections
- `<tr>` — table row
- `<th>` — header cell (bold)
- `<td>` — data cell

### Bonus:
Use CSS to add colour to different subjects!',
ARRAY['html', 'tables', 'schedule'], 200, 5),

('bld-p06', 'Styled About Me Page', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Styled About Me</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f4ff;
      color: #333;
      margin: 0;
      padding: 20px;
    }

    .container {
      max-width: 600px;
      margin: 0 auto;
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    h1 {
      color: #1E2140;
      /* Add more styles! */
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>About Me</h1>
    <p>I am a young coder learning to build amazing websites!</p>
    <p>My favourite colour is blue 💙</p>
  </div>
</body>
</html>',
'## Styled About Me Page

Take your About Me page and make it look amazing with CSS!

### What to style:
1. **Body**: Set a background colour and font
2. **Container**: Add a white box with rounded corners and a shadow
3. **Headings**: Change the colour and font size
4. **Paragraphs**: Adjust line spacing and font size
5. **Add a class**: Create a `.highlight` class for important text

### CSS properties to use:
- `background-color` — background colour
- `color` — text colour
- `font-family` — font style
- `font-size` — text size
- `border-radius` — round corners
- `box-shadow` — drop shadow
- `padding` — space inside elements
- `margin` — space outside elements',
ARRAY['css', 'styling', 'design'], 200, 6),

('bld-p07', 'Colour Palette Website', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Colour Palette</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
    }
    .palette {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
    .color-card {
      width: 120px;
      height: 120px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 12px;
      font-weight: bold;
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
  </style>
</head>
<body>
  <h1>My Favourite Colours 🎨</h1>
  <div class="palette">
    <div class="color-card" style="background-color: #FF6B6B;">Coral Red</div>
    <div class="color-card" style="background-color: #4ECDC4;">Teal</div>
    <div class="color-card" style="background-color: #45B7D1;">Sky Blue</div>
    <!-- Add more colours! -->
  </div>
</body>
</html>',
'## Colour Palette Website

Create a beautiful colour palette display!

### Steps:
1. Start with the existing colour cards
2. Add at least 6 more colours
3. Change the text colour on light cards to black
4. Add the hex code below each colour name
5. Give each colour a fun name

### To find colours:
- Try colour names: `red`, `blue`, `gold`, `coral`, `teal`
- Try hex codes: `#FF5733`, `#1E2140`, `#F5C518`
- Try rgb: `rgb(100, 200, 50)`

### Bonus:
Group colours into a "Warm Colours" and "Cool Colours" section!',
ARRAY['css', 'colours', 'design'], 200, 7),

('bld-p08', 'Typography Showcase', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Playfair+Display:wght@700&family=Source+Code+Pro&display=swap" rel="stylesheet">
  <title>Typography</title>
  <style>
    body { font-family: Roboto, sans-serif; padding: 40px; max-width: 700px; margin: 0 auto; }
    h1 { font-family: "Playfair Display", serif; font-size: 48px; color: #1E2140; }
    h2 { font-size: 28px; color: #3A3D5C; }
    .code-sample { font-family: "Source Code Pro", monospace; background: #f5f5f5; padding: 16px; border-radius: 8px; }
    .large { font-size: 24px; }
    .small { font-size: 12px; }
    .italic { font-style: italic; }
    .bold { font-weight: 700; }
  </style>
</head>
<body>
  <h1>Typography is Art!</h1>
  <h2>This is a Subtitle</h2>
  <p class="large">Large text is easy to read.</p>
  <p>Normal text paragraph. Typography is the art of making text look great.</p>
  <p class="small">Small text for captions and footnotes.</p>
  <p class="italic">Italic text adds emphasis.</p>
  <p class="bold">Bold text is important!</p>
  <div class="code-sample">console.log("Code font looks professional!");</div>
</body>
</html>',
'## Typography Showcase

Explore the art of typography with CSS!

### What to build:
1. Display different font families (serif, sans-serif, monospace)
2. Show different font sizes from tiny to huge
3. Demonstrate bold, italic, and underline
4. Show different line heights and letter spacing
5. Create a "Do" and "Don''t" section for typography

### CSS properties to explore:
- `font-family` — which font to use
- `font-size` — how big the text is
- `font-weight` — bold (700) or regular (400)
- `font-style` — italic
- `line-height` — space between lines
- `letter-spacing` — space between letters
- `text-transform` — UPPERCASE, lowercase, Capitalize
- `text-decoration` — underline, line-through',
ARRAY['css', 'typography', 'fonts'], 200, 8),

('bld-p09', 'Box Model Demonstration', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>The CSS Box Model</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 30px; background: #f5f5f5; }

    .demo-box {
      background-color: #4ECDC4;
      color: white;
      width: 200px;
      height: 100px;
      padding: 20px;
      border: 5px solid #1E2140;
      margin: 30px;
      border-radius: 8px;
    }

    .label {
      font-size: 12px;
      color: #666;
      margin-top: 5px;
    }
  </style>
</head>
<body>
  <h1>The CSS Box Model</h1>
  <p>Every element is a box! Try changing the values below.</p>

  <div class="demo-box">
    I am a box!
  </div>
  <p class="label">Try changing padding, margin, border, and size!</p>
</body>
</html>',
'## Box Model Demonstration

Show how the CSS box model works!

### Create 4 boxes showing:
1. **Content** — the actual content inside
2. **Padding** — space between content and border (try `padding: 30px`)
3. **Border** — the outline (try `border: 3px solid blue`)
4. **Margin** — space outside the box (try `margin: 20px`)

### Steps:
1. Create 4 divs
2. Give each one different padding values
3. Give each one a different coloured border
4. Use different margin values
5. Add labels explaining each property

### CSS to practise:
```css
.box {
  padding: 20px;        /* inside space */
  border: 3px solid red; /* outline */
  margin: 15px;         /* outside space */
  width: 200px;
  height: 100px;
}
```',
ARRAY['css', 'box-model', 'layout'], 200, 9),

('bld-p10', 'Card Collection', 'builders', 'CSS',
'<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Card Collection</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 20px; background: #f0f4ff; }

    .cards {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }

    .card {
      background: white;
      border-radius: 16px;
      padding: 20px;
      width: 200px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transition: transform 0.2s;
    }

    .card:hover {
      transform: translateY(-4px);
    }

    .card-emoji { font-size: 40px; margin-bottom: 10px; }
    .card-title { font-weight: bold; font-size: 18px; color: #1E2140; }
    .card-desc { font-size: 14px; color: #666; margin-top: 8px; }
  </style>
</head>
<body>
  <h1>My Collection 🃏</h1>
  <div class="cards">
    <div class="card">
      <div class="card-emoji">🚀</div>
      <div class="card-title">Space</div>
      <div class="card-desc">Rockets and stars and galaxies!</div>
    </div>
    <!-- Add more cards! -->
  </div>
</body>
</html>',
'## Card Collection

Build a beautiful collection of cards!

### Requirements:
- At least 6 cards
- Each card has: emoji, title, and description
- Cards arranged in a row (use flexbox)
- Cards wrap to next line on small screens
- Hover effect on each card

### Ideas for collections:
- Favourite movies
- Dream vacation spots
- Animals you love
- Superhero powers
- Favourite foods

### CSS skills:
- `display: flex` and `flex-wrap: wrap`
- `border-radius` for rounded corners
- `box-shadow` for depth
- `transition` and `transform` for hover effects',
ARRAY['css', 'cards', 'flexbox', 'hover'], 200, 10)
ON CONFLICT (slug) DO NOTHING;

-- Continue with projects 11-100
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order) VALUES
('bld-p11', 'Flexbox Navigation Bar', 'builders', 'CSS', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Nav Bar</title><style>body{margin:0;font-family:Arial,sans-serif;}.nav{display:flex;background:#1E2140;padding:0 20px;}.nav a{color:white;text-decoration:none;padding:16px 20px;}.nav a:hover{background:#F5C518;color:#1E2140;}.nav .brand{font-weight:bold;font-size:20px;color:#F5C518;display:flex;align-items:center;}.spacer{flex:1;}</style></head><body><nav class="nav"><span class="brand">MySite</span><span class="spacer"></span><a href="#">Home</a><a href="#">About</a><a href="#">Projects</a><a href="#">Contact</a></nav><main style="padding:40px"><h1>Welcome to my site!</h1></main></body></html>',
'## Flexbox Navigation Bar

Build a professional navigation bar using Flexbox!

### Requirements:
1. Logo on the left
2. Navigation links on the right
3. Active link styling (different colour)
4. Hover effects on links
5. Sticky header (stays at top when scrolling)

### CSS to use:
```css
nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
```

### Bonus:
Add a hamburger menu icon for mobile!',
ARRAY['css', 'flexbox', 'navigation'], 200, 11),

('bld-p12', 'Photo Grid with Flexbox', 'builders', 'CSS', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Photo Grid</title><style>body{font-family:Arial,sans-serif;padding:20px;background:#111;color:white;}.grid{display:flex;flex-wrap:wrap;gap:8px;}.photo{width:calc(33.33% - 6px);aspect-ratio:1;background:#333;border-radius:8px;overflow:hidden;display:flex;align-items:center;justify-content:center;font-size:40px;}.photo:hover{opacity:0.8;cursor:pointer;}</style></head><body><h1>📸 My Photo Gallery</h1><div class="grid"><div class="photo">🌊</div><div class="photo">🌲</div><div class="photo">🏔️</div><div class="photo">🌸</div><div class="photo">🦋</div><div class="photo">🌅</div></div></body></html>',
'## Photo Grid with Flexbox

Create a photo grid layout like Instagram!

### Steps:
1. Create a 3-column grid of photos
2. Each photo should be square (equal width and height)
3. Add a hover effect (darken or zoom)
4. Make it responsive (2 columns on small screens)
5. Add captions that appear on hover

### Key CSS:
```css
.grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.photo {
  width: calc(33.33% - 6px);
  aspect-ratio: 1;
}
```',
ARRAY['css', 'flexbox', 'grid', 'gallery'], 200, 12)
ON CONFLICT (slug) DO NOTHING;

-- Insert remaining projects 13-100 with minimal content
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order)
SELECT
  'bld-p' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'builders',
  category,
  '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>' || title || '</title><style>body{font-family:Arial,sans-serif;padding:20px;}</style></head><body><h1>' || title || '</h1><p>Start building your project here!</p></body></html>',
  '## ' || title || E'\n\nBuild this project using your HTML and CSS skills!\n\n### Steps:\n1. Plan your layout\n2. Write the HTML structure\n3. Add CSS styling\n4. Test in your browser\n5. Add any extra features\n\n### Remember:\n- Use semantic HTML\n- Write clean, readable CSS\n- Test on different screen sizes',
  ARRAY['builders', 'project'],
  200,
  n
FROM (VALUES
  (13, 'Responsive Card Layout', 'CSS'),
  (14, 'CSS Grid Magazine Layout', 'CSS'),
  (15, 'Personal Homepage', 'HTML'),
  (16, 'Animated Button Collection', 'CSS'),
  (17, 'CSS Art: Landscape Scene', 'CSS'),
  (18, 'Product Card with Hover', 'CSS'),
  (19, 'Gradient Hero Section', 'CSS'),
  (20, 'Multi-page Portfolio Site', 'HTML'),
  (21, 'Scratch Pong Game', 'Scratch'),
  (22, 'Scratch: Whack-a-Mole', 'Scratch'),
  (23, 'Scratch: Space Shooter', 'Scratch'),
  (24, 'Scratch: Maze Runner', 'Scratch'),
  (25, 'Scratch: Story with 3 Scenes', 'Scratch'),
  (26, 'Blog Post Page', 'HTML'),
  (27, 'Recipe Card Page', 'HTML'),
  (28, 'Book Review Page', 'HTML'),
  (29, 'Animated Loading Spinner', 'CSS'),
  (30, 'Dark Mode Card UI', 'CSS'),
  (31, 'CSS Accordion', 'CSS'),
  (32, 'Pricing Table', 'CSS'),
  (33, 'Timeline Component', 'CSS'),
  (34, 'Profile Card with Avatar', 'CSS'),
  (35, 'Responsive Image Gallery', 'CSS'),
  (36, 'Navigation with Dropdown', 'CSS'),
  (37, 'CSS Tooltip System', 'CSS'),
  (38, 'Sticky Header Layout', 'CSS'),
  (39, 'Mobile App Screenshot Page', 'CSS'),
  (40, 'Builders Portfolio Mid-Check', 'HTML'),
  (41, 'News Article Layout', 'HTML'),
  (42, 'Event Invitation Page', 'HTML'),
  (43, 'School Project Page', 'HTML'),
  (44, 'Band/Artist Fan Page', 'HTML'),
  (45, 'CSS Grid Dashboard Layout', 'CSS'),
  (46, 'CSS Art: Character Portrait', 'CSS'),
  (47, 'Contact Form Page', 'HTML'),
  (48, 'Animated Progress Bars', 'CSS'),
  (49, 'Restaurant Homepage', 'HTML'),
  (50, 'Travel Destination Page', 'HTML'),
  (51, 'Sports Team Fan Page', 'HTML'),
  (52, 'Science Fair Project Page', 'HTML'),
  (53, 'CSS Pixel Art', 'CSS'),
  (54, 'Animated Hero Banner', 'CSS'),
  (55, 'Team Member Card Grid', 'CSS'),
  (56, 'Accessible Form Design', 'HTML'),
  (57, 'CSS Variables Theme Switcher', 'CSS'),
  (58, 'Step-by-Step Recipe Page', 'HTML'),
  (59, 'Photo Blog Layout', 'HTML'),
  (60, 'CSS 3D Card Flip', 'CSS'),
  (61, 'Movie Review Page', 'HTML'),
  (62, 'Charity/Non-profit Page', 'HTML'),
  (63, 'Scratch: Multi-Level Platformer', 'Scratch'),
  (64, 'Scratch: Fishing Game', 'Scratch'),
  (65, 'Scratch: Musical Instrument', 'Scratch'),
  (66, 'Scratch: Digital Greeting Card', 'Scratch'),
  (67, 'Scratch: Memory Card Game', 'Scratch'),
  (68, 'CSS Skeleton Loading Screen', 'CSS'),
  (69, 'Notification Badge Component', 'CSS'),
  (70, 'Builders Portfolio Final', 'HTML'),
  (71, 'Responsive Product Page', 'HTML'),
  (72, 'CSS Pure Hamburger Menu', 'CSS'),
  (73, 'Music Album Page', 'HTML'),
  (74, 'App Landing Page', 'HTML'),
  (75, 'CSS Custom Scrollbar Demo', 'CSS'),
  (76, 'Video Embed Page', 'HTML'),
  (77, 'Infographic Layout', 'CSS'),
  (78, 'Quiz Results Page', 'HTML'),
  (79, 'Testimonials Section', 'CSS'),
  (80, 'Feature Comparison Table', 'CSS'),
  (81, 'Newsletter Signup Page', 'HTML'),
  (82, 'FAQ Accordion Page', 'CSS'),
  (83, 'CSS Sticker Maker', 'CSS'),
  (84, 'Winter Holiday Page', 'HTML'),
  (85, 'Nature Photography Page', 'HTML'),
  (86, 'Animated SVG Banner', 'CSS'),
  (87, 'Podcast Show Page', 'HTML'),
  (88, 'Vehicle Comparison Page', 'HTML'),
  (89, 'CSS Art: City Skyline', 'CSS'),
  (90, 'Accessible Navigation Demo', 'HTML'),
  (91, 'Job Listings Page', 'HTML'),
  (92, 'Course Catalogue Page', 'HTML'),
  (93, 'CSS Print-Ready CV', 'CSS'),
  (94, 'Interactive Map Key', 'CSS'),
  (95, 'E-commerce Product Grid', 'CSS'),
  (96, 'Developer Portfolio Starter', 'HTML'),
  (97, 'Builders Capstone: Full Website', 'HTML'),
  (98, 'Peer Code Review', 'HTML'),
  (99, 'Builders Showcase Presentation', 'HTML'),
  (100, 'Builders Graduation Project', 'HTML')
) AS t(n, title, category)
ON CONFLICT (slug) DO NOTHING;

END $$;


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-builders-quizzes.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Builders Quizzes Q1–Q16
-- =============================================================================

INSERT INTO quizzes (slug, title, level, category, time_limit_seconds, passing_score, xp_reward) VALUES
('bld-q01', 'HTML Basics Quiz',             'builders', 'HTML',        600, 70, 150),
('bld-q02', 'HTML Text and Headings Quiz',  'builders', 'HTML',        600, 70, 150),
('bld-q03', 'HTML Links and Images Quiz',   'builders', 'HTML',        600, 70, 150),
('bld-q04', 'HTML Semantics Quiz',          'builders', 'HTML',        600, 70, 150),
('bld-q05', 'HTML Tables Quiz',             'builders', 'HTML',        600, 70, 150),
('bld-q06', 'HTML Forms Quiz',              'builders', 'HTML',        600, 70, 150),
('bld-q07', 'CSS Basics Quiz',              'builders', 'CSS',         600, 70, 150),
('bld-q08', 'CSS Box Model Quiz',           'builders', 'CSS',         600, 70, 150),
('bld-q09', 'CSS Colors and Fonts Quiz',    'builders', 'CSS',         600, 70, 150),
('bld-q10', 'CSS Flexbox Quiz',             'builders', 'CSS',         600, 70, 150),
('bld-q11', 'CSS Grid Quiz',                'builders', 'CSS',         600, 70, 150),
('bld-q12', 'CSS Transitions Quiz',         'builders', 'CSS',         600, 70, 150),
('bld-q13', 'CSS Positioning Quiz',         'builders', 'CSS',         600, 70, 150),
('bld-q14', 'Responsive Design Quiz',       'builders', 'CSS',         600, 70, 150),
('bld-q15', 'Accessibility Basics Quiz',    'builders', 'Accessibility', 600, 70, 150),
('bld-q16', 'Scratch Basics Quiz',          'builders', 'Scratch',     600, 70, 150)
ON CONFLICT (slug) DO NOTHING;

-- Q01: HTML Basics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q01', 'What does HTML stand for?', '["HyperText Markup Language","HyperText Machine Language","HighText Markup Language","HyperText Making Language"]', 0, 'HTML = HyperText Markup Language.', 1),
  ('bld-q01', 'Which tag is the root of an HTML document?', '["<body>","<head>","<html>","<root>"]', 2, 'The <html> element is the root/parent of all other elements.', 2),
  ('bld-q01', 'Where does page content go?', '["<head>","<body>","<html>","<meta>"]', 1, 'The <body> contains everything visible on the page.', 3),
  ('bld-q01', 'What does the <title> tag do?', '["Shows a heading on the page","Sets the browser tab text","Creates a link","Adds metadata"]', 1, '<title> controls the text shown in the browser tab and bookmarks.', 4),
  ('bld-q01', 'Which meta tag is needed for mobile screens?', '["charset","author","description","viewport"]', 3, 'The viewport meta tag makes pages display correctly on mobile.', 5),
  ('bld-q01', 'What value should charset be set to?', '["UTF-8","ASCII","ISO-8859","UTF-16"]', 0, 'UTF-8 supports characters from all languages including accents.', 6),
  ('bld-q01', 'HTML tags are enclosed in:', '["{ }","[ ]","< >","( )"]', 2, 'HTML tags use angle brackets: <tagname>.', 7),
  ('bld-q01', 'An opening tag and closing tag together are called:', '["An attribute","An element","A property","A comment"]', 1, 'An HTML element consists of an opening tag, content, and a closing tag.', 8),
  ('bld-q01', 'Which is a correctly closed void element?', '["<img></img>","<img/>","<img>","</img>"]', 2, '<img> is a self-closing void element — no closing tag needed.', 9),
  ('bld-q01', 'HTML comments look like:', '["// comment","/* comment */","<!-- comment -->","## comment"]', 2, 'HTML comments use <!-- comment --> syntax.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q02: Text and Headings
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q02', 'How many heading levels does HTML have?', '["3","6","9","12"]', 1, 'HTML has 6 heading levels: <h1> through <h6>.', 1),
  ('bld-q02', 'Which heading is MOST important (largest)?', '["<h6>","<h3>","<h1>","<h0>"]', 2, '<h1> is the most important heading — only one per page!', 2),
  ('bld-q02', 'Which tag makes text bold AND important?', '["<b>","<bold>","<strong>","<em>"]', 2, '<strong> makes text bold and signals importance to screen readers.', 3),
  ('bld-q02', 'Which tag makes text italic/emphasized?', '["<i>","<em>","<italic>","<slant>"]', 1, '<em> adds emphasis (italic) and is understood by screen readers.', 4),
  ('bld-q02', 'How many <h1> tags should a page have?', '["As many as needed","Two","One","Zero"]', 2, 'A page should have exactly ONE <h1> for accessibility and SEO.', 5),
  ('bld-q02', 'Which tag creates a paragraph?', '["<para>","<pg>","<p>","<par>"]', 2, '<p> creates a paragraph with a gap above and below it.', 6),
  ('bld-q02', 'How do you create a line break INSIDE a paragraph?', '["<break>","<nl>","<br>","<lb>"]', 2, '<br> inserts a line break without starting a new paragraph.', 7),
  ('bld-q02', 'Which tag creates a bulleted list?', '["<ol>","<li>","<ul>","<bl>"]', 2, '<ul> = unordered list (bullets). <ol> = ordered list (numbers).', 8),
  ('bld-q02', 'What does <li> stand for?', '["List image","Line item","List item","Link item"]', 2, '<li> = list item. It goes inside <ul> or <ol>.', 9),
  ('bld-q02', 'Ordered lists use:', '["Bullet points","Numbers","Squares","Dashes"]', 1, '<ol> (ordered list) uses numbers by default.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q03: Links and Images
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q03', 'Which HTML tag creates a hyperlink?', '["<link>","<href>","<a>","<url>"]', 2, 'The <a> (anchor) tag creates hyperlinks.', 1),
  ('bld-q03', 'Which attribute defines the link destination?', '["src","url","link","href"]', 3, 'href (hypertext reference) specifies where a link goes.', 2),
  ('bld-q03', 'To open a link in a new tab, use:', '["target=''_new''","target=''_blank''","target=''new''","tab=''true''"]', 1, 'target="_blank" opens the link in a new tab.', 3),
  ('bld-q03', 'With target="_blank", you should also add:', '["rel=''nofollow''","rel=''noopener noreferrer''","rel=''external''","rel=''safe''"]', 1, 'rel="noopener noreferrer" prevents security vulnerabilities with new-tab links.', 4),
  ('bld-q03', 'Which tag displays an image?', '["<image>","<photo>","<img>","<pic>"]', 2, '<img> is the correct tag for displaying images.', 5),
  ('bld-q03', 'Which attribute specifies the image file?', '["href","link","src","url"]', 2, 'src (source) tells the browser where to find the image.', 6),
  ('bld-q03', 'The alt attribute is used for:', '["Image size","Alternative text for accessibility","Image title","Image link"]', 1, 'alt provides text description for screen readers and when images fail to load.', 7),
  ('bld-q03', 'A decorative image should have alt=""  because:', '["It is faster to load","Screen readers skip empty alt images","It saves bandwidth","It is required"]', 1, 'Empty alt="" tells screen readers to skip the image entirely (it adds no meaning).', 8),
  ('bld-q03', 'To link to a section on the same page, use:', '["<a href=''page.html''>","<a href=''#section-id''>","<a href=''top''>","<a jump=''true''>"]', 1, '#id creates an anchor link to a specific element on the same page.', 9),
  ('bld-q03', 'To make an image clickable, you:', '["Add onclick to the img","Wrap the img in an <a> tag","Add href to the img","Use a button"]', 1, 'Wrapping <img> in <a href="..."> makes the image a clickable link.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q04: Semantics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q04', 'What is semantic HTML?', '["HTML with inline styles","Using tags that describe meaning","HTML that runs faster","HTML with comments"]', 1, 'Semantic HTML uses tags that describe the meaning and purpose of content.', 1),
  ('bld-q04', 'Which tag contains the site logo and nav?', '["<top>","<header>","<banner>","<heading>"]', 1, '<header> typically contains the logo, site title, and navigation.', 2),
  ('bld-q04', 'Which tag contains navigation links?', '["<links>","<menu>","<nav>","<navigation>"]', 2, '<nav> marks navigation menus.', 3),
  ('bld-q04', 'Where does the PRIMARY content go?', '["<section>","<content>","<main>","<body>"]', 2, '<main> holds the primary content. Only ONE per page.', 4),
  ('bld-q04', 'How many <main> elements should a page have?', '["As many as needed","Two","One","Three"]', 2, 'Only ONE <main> element per page for accessibility.', 5),
  ('bld-q04', 'Which tag is for a standalone piece of content (like a blog post)?', '["<section>","<article>","<div>","<aside>"]', 1, '<article> is for self-contained content that could stand alone.', 6),
  ('bld-q04', 'What is <aside> used for?', '["Secondary/sidebar content","The main content","The page header","Navigation"]', 0, '<aside> holds related but secondary content, like a sidebar.', 7),
  ('bld-q04', 'The <footer> typically contains:', '["The main navigation","The hero section","Copyright and links","The page title"]', 2, '<footer> contains copyright notices, secondary links, contact info.', 8),
  ('bld-q04', 'What does <section> do?', '["Groups unrelated content","Groups related content with a heading","Creates a new page","Makes content bold"]', 1, '<section> groups related content thematically, usually with a heading.', 9),
  ('bld-q04', 'Why prefer <button> over <div onclick="">?', '["Buttons look better","Buttons are keyboard and screen reader accessible","Buttons load faster","Div onclick is invalid"]', 1, '<button> is accessible by keyboard and announced correctly by screen readers.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q05: Tables
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q05', 'Which tag creates a table?', '["<tb>","<tbl>","<table>","<grid>"]', 2, '<table> is the container for the entire table.', 1),
  ('bld-q05', 'Which tag creates a table row?', '["<td>","<row>","<tr>","<th>"]', 2, '<tr> (table row) creates a horizontal row in a table.', 2),
  ('bld-q05', 'Which tag creates a header cell?', '["<td>","<th>","<header>","<tc>"]', 1, '<th> creates a header cell — bold and centred by default.', 3),
  ('bld-q05', 'Which tag creates a regular data cell?', '["<th>","<tc>","<cell>","<td>"]', 3, '<td> (table data) creates a regular cell in a table.', 4),
  ('bld-q05', 'Which element groups the header rows?', '["<thead>","<th>","<header>","<tgroup>"]', 0, '<thead> groups the header rows of a table.', 5),
  ('bld-q05', 'Which element groups the body rows?', '["<tbody>","<body>","<trows>","<tcontent>"]', 0, '<tbody> groups the main body rows of a table.', 6),
  ('bld-q05', 'The <caption> tag:', '["Styles the table","Adds a title/description to the table","Creates a header row","Makes text bold"]', 1, '<caption> gives the table a title, improving accessibility.', 7),
  ('bld-q05', 'colspan="3" means the cell:', '["Has 3 rows of height","Spans 3 columns","Has 3 border","Has 3em width"]', 1, 'colspan makes a cell span across multiple columns.', 8),
  ('bld-q05', 'Tables should be used for:', '["Page layouts","Navigation menus","Tabular data like schedules","Image galleries"]', 2, 'Tables are for data with rows and columns — not for layout!', 9),
  ('bld-q05', 'scope="col" on a <th> tells screen readers:', '["The cell is a column","This header applies to its column","This cell spans columns","The column is hidden"]', 1, 'scope="col" helps screen readers associate header cells with their columns.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q06: Forms
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q06', 'Which tag creates an HTML form?', '["<input>","<submit>","<form>","<field>"]', 2, '<form> is the container for all form elements.', 1),
  ('bld-q06', 'The action attribute on a form specifies:', '["The form style","Where the form data is sent","The form method","The form validation"]', 1, 'action is the URL where the form data is submitted.', 2),
  ('bld-q06', 'For sensitive data like passwords, use method:', '["GET","PUT","POST","SEND"]', 2, 'POST sends data in the request body (hidden). GET puts it in the URL.', 3),
  ('bld-q06', 'Which input type hides characters as you type?', '["hidden","text","secret","password"]', 3, 'type="password" hides the characters being typed.', 4),
  ('bld-q06', 'Which input type validates email format?', '["text","mail","email","address"]', 2, 'type="email" validates that the user enters a valid email format.', 5),
  ('bld-q06', 'The required attribute:', '["Formats the input","Makes the field mandatory","Hides the field","Styles the field"]', 1, 'required prevents form submission if the field is empty.', 6),
  ('bld-q06', 'A <label> should be connected to an input using:', '["class and name","for and id","name and id","href and src"]', 1, 'The label for attribute must match the input id attribute.', 7),
  ('bld-q06', 'Which element creates a multi-line text field?', '["<input type=''multiline''>","<field>","<textarea>","<multitext>"]', 2, '<textarea> creates a resizable multi-line text input.', 8),
  ('bld-q06', 'Which element creates a dropdown menu?', '["<dropdown>","<list>","<select>","<menu>"]', 2, '<select> with <option> elements creates a dropdown.', 9),
  ('bld-q06', 'Radio buttons differ from checkboxes because:', '["Radio buttons are round","Only one radio can be selected per group","Radio buttons are required","Radio buttons use id"]', 1, 'Radio buttons in the same name group allow only ONE selection.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q07: CSS Basics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q07', 'What does CSS stand for?', '["Computer Style Sheets","Creative Style Syntax","Cascading Style Sheets","Coloured Style Sheets"]', 2, 'CSS = Cascading Style Sheets.', 1),
  ('bld-q07', 'The best way to add CSS is:', '["Inline styles","Internal <style> tag","External stylesheet","All are equally good"]', 2, 'External stylesheets (separate .css files) are the best practice.', 2),
  ('bld-q07', 'A CSS rule consists of:', '["Element and value","Selector, property, and value","Tag and class","Key and pair"]', 1, 'CSS rules: selector { property: value; }', 3),
  ('bld-q07', 'Which selector targets elements with class="card"?', '[".card","#card","card","*card"]', 0, 'Class selectors use a dot: .card', 4),
  ('bld-q07', 'Which selector targets the element with id="title"?', '["#title",".title","title","*title"]', 0, 'ID selectors use a hash: #title', 5),
  ('bld-q07', 'nav a selects:', '["All <a> elements","<a> elements inside <nav>","The <nav> element","<nav> and <a> elements"]', 1, 'Descendant selectors: nav a targets <a> elements that are inside <nav>.', 6),
  ('bld-q07', 'Which property changes text colour?', '["text-color","font-color","color","text"]', 2, 'The color property sets the text/foreground colour.', 7),
  ('bld-q07', 'Which property changes background colour?', '["color","background","bg-color","background-color"]', 3, 'background-color sets the background colour of an element.', 8),
  ('bld-q07', 'CSS comments use:', '["// comment","/* comment */","<!-- comment -->","## comment"]', 1, 'CSS comments use /* comment */ syntax.', 9),
  ('bld-q07', 'To link an external CSS file, use:', '["<style src=''file.css''>","<css href=''file.css''>","<link rel=''stylesheet'' href=''file.css''>","<script src=''file.css''>"]', 2, '<link rel="stylesheet" href="..."> links external CSS in the <head>.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q08: Box Model
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q08', 'What are the four layers of the CSS box model (outside to inside)?', '["margin, border, padding, content","padding, border, margin, content","content, padding, border, margin","border, padding, content, margin"]', 0, 'From outside: margin → border → padding → content.', 1),
  ('bld-q08', 'Padding is:', '["Space outside the border","Space between the border and content","The border itself","The background colour"]', 1, 'Padding is the space INSIDE the border, between the border and the content.', 2),
  ('bld-q08', 'Margin is:', '["Space inside the border","The border width","Space outside the border","The padding"]', 2, 'Margin is the space OUTSIDE the border, between the element and its neighbours.', 3),
  ('bld-q08', 'margin: 0 auto is used to:', '["Remove all margins","Centre an element horizontally","Add auto margins top and bottom","Set vertical margin"]', 1, 'margin: 0 auto centres a block element horizontally in its container.', 4),
  ('bld-q08', 'padding: 10px 20px sets:', '["All sides to 10px","Top/bottom 10px, left/right 20px","Left 10px, right 20px","Top 10px, bottom 20px"]', 1, 'Two values: first is top/bottom, second is left/right.', 5),
  ('bld-q08', 'box-sizing: border-box means:', '["Width includes border and padding","Width is just the content","Border is outside the width","Padding is outside the width"]', 0, 'border-box includes padding and border INSIDE the declared width.', 6),
  ('bld-q08', 'Without box-sizing: border-box, if width:200px and padding:20px, the actual width is:', '["200px","180px","240px","220px"]', 2, 'Default: width 200 + padding 20 + padding 20 = 240px total!', 7),
  ('bld-q08', 'border-radius: 50% on a square element creates:', '["A rectangle","A circle","A triangle","An oval"]', 1, 'border-radius: 50% on a square makes a perfect circle.', 8),
  ('bld-q08', 'border: 2px solid navy means:', '["2px gap, solid colour navy","2px thick solid border, navy colour","Navy background, 2px padding","2% border radius"]', 1, 'border shorthand: width style colour.', 9),
  ('bld-q08', 'The best practice is to put this at the top of every CSS file:', '["body { margin: 0; }","* { box-sizing: border-box; }","html { font-size: 16px; }","All of the above"]', 3, 'All three are common resets used at the top of CSS files.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q09: Colours and Fonts
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q09', 'Which is a valid hex colour?', '["#1E2140","#GGHHII","rgb(300,0,0)","hsl(400,50%,50%)"]', 0, 'Hex colours use 0-9 and A-F. #1E2140 is a valid dark navy colour.', 1),
  ('bld-q09', 'rgba(0, 0, 0, 0.5) means:', '["Black, 50% transparent","Red, green, blue all at 0","50% grey","Pure black"]', 0, 'RGBA: red=0, green=0, blue=0 (black), alpha=0.5 (50% transparent).', 2),
  ('bld-q09', 'CSS custom properties (variables) are defined on:', '[":root","body","html","head"]', 0, ':root targets the <html> element and makes variables available globally.', 3),
  ('bld-q09', 'How do you use a CSS variable named --color-primary?', '["color: --color-primary","color: var(--color-primary)","color: $color-primary","color: #{--color-primary}"]', 1, 'Use var(--variable-name) to reference a CSS custom property.', 4),
  ('bld-q09', 'Which font-family value is a fallback for fonts without serifs?', '["serif","cursive","sans-serif","monospace"]', 2, 'sans-serif is the generic fallback for fonts like Arial, Helvetica.', 5),
  ('bld-q09', 'font-weight: 700 is the same as:', '["light","normal","bold","extra-bold"]', 2, '700 = bold. 400 = normal. 300 = light. 900 = black.', 6),
  ('bld-q09', 'A comfortable line-height for body text is:', '["0.8","1.0","1.6","3.0"]', 2, 'line-height: 1.5 to 1.8 makes body text comfortable to read.', 7),
  ('bld-q09', 'linear-gradient(to right, red, blue) creates:', '["A gradient from top to bottom","A gradient from left (red) to right (blue)","A diagonal gradient","Alternating colours"]', 1, 'linear-gradient(to right, ...) goes left to right.', 8),
  ('bld-q09', 'text-transform: uppercase;', '["Makes text bigger","Makes all text UPPERCASE","Makes text bold","Hides text"]', 1, 'text-transform: uppercase converts all text to capital letters.', 9),
  ('bld-q09', 'letter-spacing adds space:', '["Between words","Between lines","Between letters","Around the element"]', 2, 'letter-spacing controls the space between individual characters.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q10: Flexbox
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q10', 'How do you enable Flexbox on a container?', '["flex: 1","display: flex","flex-direction: row","flex-container: true"]', 1, 'display: flex turns the element into a flex container.', 1),
  ('bld-q10', 'justify-content controls alignment along:', '["The cross axis","Both axes","The main axis","The z-axis"]', 2, 'justify-content aligns items along the main axis (horizontal in a row).', 2),
  ('bld-q10', 'align-items controls alignment along:', '["The main axis","The cross axis","Both axes","The z-axis"]', 1, 'align-items aligns items along the cross axis (vertical in a row).', 3),
  ('bld-q10', 'To centre items both horizontally and vertically:', '["justify-content: center","align-items: center","Both justify-content: center AND align-items: center","flex: center"]', 2, 'You need both justify-content: center and align-items: center.', 4),
  ('bld-q10', 'justify-content: space-between:', '["Items at the start","Equal space around all items","Items spread with space between them, none at edges","Items centred"]', 2, 'space-between puts space between items but not at the start or end.', 5),
  ('bld-q10', 'flex-direction: column makes items:', '["Go left to right","Stack vertically (top to bottom)","Go right to left","Wrap to next line"]', 1, 'flex-direction: column stacks items vertically instead of horizontally.', 6),
  ('bld-q10', 'flex-wrap: wrap allows items to:', '["Overlap each other","Wrap to the next line if no room","Shrink infinitely","Hide when too small"]', 1, 'flex-wrap: wrap allows items to move to the next line when they overflow.', 7),
  ('bld-q10', 'gap: 16px on a flex container:', '["Adds 16px padding inside each item","Adds 16px space between items","Adds 16px margin outside the container","Makes items 16px wide"]', 1, 'gap adds space between flex items without affecting outer margins.', 8),
  ('bld-q10', 'flex: 1 on an item means it:', '["Is 1px wide","Takes up 1 share of available space","Is always 100% wide","Stays at its natural size"]', 1, 'flex: 1 allows the item to grow and shrink to fill available space.', 9),
  ('bld-q10', 'flex: 0 0 200px means:', '["Grow and shrink, start at 200px","Do not grow, do not shrink, stay at 200px","200% of container","200 flex units"]', 1, 'flex: 0 0 200px = no grow, no shrink, fixed 200px size.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q11: Grid
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q11', 'How do you enable CSS Grid?', '["display: grid","grid: true","layout: grid","grid-container: on"]', 0, 'display: grid turns the element into a grid container.', 1),
  ('bld-q11', 'grid-template-columns: repeat(3, 1fr) creates:', '["3 columns of 1px each","3 equal columns","1 column repeated 3 times","3 rows"]', 1, 'repeat(3, 1fr) creates 3 equal columns using fractional units.', 2),
  ('bld-q11', '1fr means:', '["1 pixel","1 fraction of available space","1 flexbox unit","1 percentage"]', 1, 'fr = fraction unit. 1fr takes one share of available space.', 3),
  ('bld-q11', 'gap: 20px on a grid adds space:', '["Inside each cell","Between the grid and its container","Between rows and columns","Outside the grid"]', 2, 'gap adds space between grid cells (rows and columns).', 4),
  ('bld-q11', 'grid-column: 1 / -1 means:', '["Start at column 1, span 1","Start at column 1, end at the last column","From -1 to 1","Column 1 only"]', 1, '-1 refers to the last grid line, so 1/-1 spans the full width.', 5),
  ('bld-q11', 'grid-column: span 2 means:', '["Start at column 2","Span across 2 columns","Go to column 2","Skip 2 columns"]', 1, 'span 2 makes the item take up 2 column tracks.', 6),
  ('bld-q11', 'grid-template-areas is used for:', '["Drawing the grid lines","Naming and placing grid sections visually","Styling grid items","Creating grid gaps"]', 1, 'grid-template-areas lets you define layout visually using named areas.', 7),
  ('bld-q11', 'repeat(auto-fill, minmax(200px, 1fr)) creates:', '["Exactly 200 columns","As many 200px+ columns as fit, each growing to 1fr","A 200px fixed grid","One column of 200px"]', 1, 'auto-fill + minmax creates a responsive grid without media queries.', 8),
  ('bld-q11', 'Grid is best for:', '["One-dimensional layouts","Two-dimensional (rows AND columns) layouts","Animating elements","Styling text"]', 1, 'Grid excels at two-dimensional layouts; Flexbox is for one-dimensional.', 9),
  ('bld-q11', 'Flexbox vs Grid: which to use for a navbar?', '["Grid","Flexbox","Either works the same","Neither"]', 1, 'Flexbox is ideal for one-dimensional layouts like navbars and card rows.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q12: Transitions
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q12', 'The :hover pseudo-class applies styles when:', '["The element is clicked","The mouse cursor is over the element","The element is focused","The page loads"]', 1, ':hover applies when the mouse pointer is positioned over the element.', 1),
  ('bld-q12', 'Where should transition be placed?', '["On the :hover state","On the original element","In a @keyframes rule","In the :active state"]', 1, 'transition goes on the ORIGINAL element so it applies in both directions.', 2),
  ('bld-q12', 'transition: all 0.3s ease means:', '["All properties change instantly","All properties animate over 0.3 seconds with ease timing","Only 0.3 properties change","Ease by all 0.3"]', 1, 'Animates all changing properties over 0.3 seconds with ease timing.', 3),
  ('bld-q12', 'transform: scale(1.1) makes an element:', '["Move 1.1px","10% bigger","110% of viewport","Rotate 1.1 degrees"]', 1, 'scale(1.1) makes the element 10% larger than its original size.', 4),
  ('bld-q12', 'transform: translateY(-4px) moves an element:', '["4px to the right","4px down","4px up","4px to the left"]', 2, 'Negative Y value moves UP (Y axis goes down in CSS).', 5),
  ('bld-q12', 'The ease timing function:', '["Maintains constant speed","Starts slow, speeds up, ends slow","Starts fast, slows down","Is the same as linear"]', 1, 'ease (default) starts slow, accelerates, then decelerates at the end.', 6),
  ('bld-q12', 'linear timing function:', '["Starts slow","Maintains constant speed the whole way","Ends slow","Bounces at the end"]', 1, 'linear keeps the same animation speed from start to finish.', 7),
  ('bld-q12', 'transform: rotate(45deg) rotates:', '["45% of a circle","45 degrees clockwise","45 pixels","0.45 turns"]', 1, 'rotate(45deg) rotates the element 45 degrees clockwise.', 8),
  ('bld-q12', 'Multiple transforms on one element:', '["Require separate CSS rules","Are combined: transform: translateY(-4px) scale(1.05)","Only the last one applies","Are not possible"]', 1, 'Multiple transforms are combined in one transform property.', 9),
  ('bld-q12', 'box-shadow: 0 4px 16px rgba(0,0,0,0.2) creates:', '["A 4px border","A shadow offset down 4px, blurred 16px, semi-transparent","A 20% grey background","A 16px border radius"]', 1, 'box-shadow syntax: x-offset y-offset blur spread colour.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q13: Positioning
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q13', 'The default CSS position value is:', '["relative","absolute","fixed","static"]', 3, 'position: static is the default — elements follow normal page flow.', 1),
  ('bld-q13', 'position: fixed positions an element relative to:', '["Its parent","The body","The viewport (screen)","The nearest positioned parent"]', 2, 'Fixed elements stay in place on the screen when you scroll.', 2),
  ('bld-q13', 'position: absolute positions relative to:', '["The viewport","The body","The nearest ancestor with position != static","The document root"]', 2, 'Absolute elements are positioned relative to their nearest non-static ancestor.', 3),
  ('bld-q13', 'To use position: absolute on a child, the parent needs:', '["position: absolute","position: fixed","position: relative (or any non-static)","No special positioning"]', 2, 'The parent needs position: relative to become the containing block.', 4),
  ('bld-q13', 'position: sticky:', '["Is always fixed","Scrolls normally until reaching a threshold, then sticks","Is positioned relative to parent","Is the same as absolute"]', 1, 'Sticky elements scroll normally then "stick" when they hit the specified offset.', 5),
  ('bld-q13', 'z-index controls:', '["Horizontal position","Vertical position","Stacking order (which element appears on top)","Transparency"]', 2, 'Higher z-index values appear in front of (on top of) lower values.', 6),
  ('bld-q13', 'A fixed navbar at the top uses:', '["top: 0; left: 0; right: 0","margin: 0 auto","float: left","align: top"]', 0, 'top/left/right: 0 stretches the fixed element across the full top.', 7),
  ('bld-q13', 'inset: 0 is shorthand for:', '["z-index: 0","margin: 0","top: 0; right: 0; bottom: 0; left: 0","border: 0"]', 2, 'inset: 0 sets all four offset properties to 0 at once.', 8),
  ('bld-q13', 'An element with position: absolute; top: 0; right: 0 goes to:', '["Bottom left of parent","Top right of its containing block","Top left of page","Bottom right of viewport"]', 1, 'top:0, right:0 places it in the top-right corner of the positioned parent.', 9),
  ('bld-q13', 'To create a sticky header that stays at top while scrolling:', '["position: fixed; top: 0","position: sticky; top: 0","position: relative; top: 0","position: absolute; top: 0"]', 1, 'sticky + top:0 makes it stick to the top when you scroll past it.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q14: Responsive Design
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q14', 'Responsive design means:', '["Fast loading pages","Pages that look good on all screen sizes","Pages with animations","Pages in multiple languages"]', 1, 'Responsive design adapts layouts to work on any screen size.', 1),
  ('bld-q14', 'Which HTML tag is essential for mobile responsiveness?', '["<mobile>","<responsive>","<meta name=''viewport''>","<scale>"]', 2, 'The viewport meta tag prevents mobile browsers from zooming out.', 2),
  ('bld-q14', 'A media query lets you:', '["Query a database","Apply styles at specific screen widths","Play media files","Add audio to pages"]', 1, 'Media queries apply CSS rules based on device characteristics like width.', 3),
  ('bld-q14', '@media (min-width: 768px) applies when:', '["Screen is at most 768px wide","Screen is exactly 768px","Screen is at least 768px wide","Always"]', 2, 'min-width: 768px applies when the screen is 768px or wider.', 4),
  ('bld-q14', 'Mobile-first means:', '["Only design for mobile","Start with mobile styles, add larger screen styles with min-width queries","Design desktop first","Use max-width queries everywhere"]', 1, 'Mobile-first: default styles for mobile, add complexity with min-width queries.', 5),
  ('bld-q14', '@media (max-width: 600px) applies when:', '["Screen is 600px or wider","Screen is at most 600px wide","Screen is exactly 600px","Never"]', 1, 'max-width: 600px applies when the screen is 600px or narrower.', 6),
  ('bld-q14', 'To make images responsive, use:', '["width: 100%","max-width: 100%; height: auto","width: auto","img { responsive: true }"]', 1, 'max-width: 100% prevents images from overflowing, height: auto keeps aspect ratio.', 7),
  ('bld-q14', 'A common mobile breakpoint is:', '["200px","480px–600px","2000px","1px"]', 1, 'Common mobile breakpoints are around 480-600px.', 8),
  ('bld-q14', 'Viewport units vh and vw refer to:', '["Very high and very wide","Percentage of viewport height and width","Pixels","Virtual height and width"]', 1, 'vh = 1% of viewport height, vw = 1% of viewport width.', 9),
  ('bld-q14', 'The grid auto-fill pattern repeat(auto-fill, minmax(200px, 1fr)) creates:', '["A fixed 200px grid","A responsive grid without media queries","200 grid columns","A single column"]', 1, 'This powerful pattern creates a responsive grid that adapts without breakpoints.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q15: Accessibility
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q15', 'What does accessibility (a11y) mean?', '["Making sites load fast","Making sites usable by everyone including people with disabilities","Making sites look pretty","Making sites secure"]', 1, 'Accessibility ensures everyone can use your site, including users with disabilities.', 1),
  ('bld-q15', 'In Ontario, which law requires accessible websites?', '["PIPEDA","CASL","AODA","GDPR"]', 2, 'AODA (Accessibility for Ontarians with Disabilities Act) requires accessible sites.', 2),
  ('bld-q15', 'Screen readers are used by:', '["Slow internet users","Users who cannot see the screen","Mobile users","Users with slow computers"]', 1, 'Screen readers read page content aloud for blind or low-vision users.', 3),
  ('bld-q15', 'A decorative image should have:', '["No alt attribute","alt=''decorative''","alt=''''(empty string)","alt=''image''"]', 2, 'Empty alt="" tells screen readers to ignore the decorative image.', 4),
  ('bld-q15', 'Why must you never remove focus outlines?', '["They look bad","Keyboard users need them to see where they are","They slow the page","They are optional"]', 1, 'Focus outlines show keyboard users which element is currently focused.', 5),
  ('bld-q15', 'aria-label is used to:', '["Style elements","Provide an accessible name when no visible label exists","Link stylesheets","Create animations"]', 1, 'aria-label provides an accessible name for elements without visible text labels.', 6),
  ('bld-q15', 'A skip link helps:', '["SEO ranking","Keyboard users skip repetitive navigation","Load the page faster","Add animations"]', 1, 'Skip links let keyboard users jump past nav menus to the main content.', 7),
  ('bld-q15', 'Good colour contrast helps:', '["SEO","Users with low vision or colour blindness","Load speed","Animation performance"]', 1, 'Sufficient contrast makes text readable for users with low vision.', 8),
  ('bld-q15', 'WCAG 2.1 AA is:', '["A JavaScript framework","Web Content Accessibility Guidelines — the standard for accessible web","A CSS property","A browser extension"]', 1, 'WCAG 2.1 AA is the international standard for web accessibility.', 9),
  ('bld-q15', 'Using <button> instead of <div onclick=""> is better because:', '["Buttons have border-radius by default","Buttons are automatically keyboard-accessible and announced by screen readers","Buttons load faster","Divs cannot have onclick"]', 1, 'Native HTML interactive elements have built-in keyboard support and ARIA roles.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q16: Scratch Basics
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q16', 'In Scratch, the stage is:', '["Where sprites are coded","The area where your project runs and is visible","Where you find blocks","The sound editor"]', 1, 'The stage is the visual area (480×360) where your Scratch project plays.', 1),
  ('bld-q16', 'Sprites in Scratch are:', '["Background images","Characters and objects you can program","Sound files","Variables"]', 1, 'Sprites are the programmable characters and objects in your Scratch project.', 2),
  ('bld-q16', 'The "When green flag clicked" block:', '["Stops the project","Starts scripts when the green flag is clicked","Changes the backdrop","Deletes a sprite"]', 1, 'This is the most common event trigger — starts scripts when the project begins.', 3),
  ('bld-q16', 'The Forever block:', '["Runs a script once","Runs a script 10 times","Runs a script continuously until stopped","Stops all scripts"]', 2, 'Forever loops run its contained blocks over and over until the project stops.', 4),
  ('bld-q16', 'The If/Else block:', '["Runs code only once","Runs one set of blocks if condition is true, another if false","Waits for user input","Plays a sound"]', 1, 'If/Else checks a condition and runs different code based on the result.', 5),
  ('bld-q16', 'Scratch coordinates: x=0, y=0 is:', '["Top left corner","Top right corner","Centre of the stage","Bottom left corner"]', 2, 'In Scratch, (0,0) is the centre of the stage.', 6),
  ('bld-q16', 'To move a sprite right, you:', '["Change y by a positive number","Change x by a positive number","Change x by a negative number","Rotate 90 degrees"]', 1, 'Increasing x moves the sprite to the right.', 7),
  ('bld-q16', 'The Broadcast block is used to:', '["Play sounds","Send a message that other sprites can respond to","Show the score","Delete a clone"]', 1, 'Broadcast sends a message; "When I receive" blocks respond to it in any sprite.', 8),
  ('bld-q16', 'Costumes in Scratch are:', '["Different sprites","Different appearances of the same sprite","Background images","Sound files"]', 1, 'Costumes are different appearances/outfits for a single sprite.', 9),
  ('bld-q16', 'The Touching sprite? block is used for:', '["Playing sounds","Moving sprites","Detecting collision between sprites","Changing costumes"]', 2, 'Touching sprite? detects when two sprites are overlapping (collision detection).', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-builders-quizzes-complete.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Builders Quizzes Q17–Q50
-- =============================================================================

INSERT INTO quizzes (slug, title, level, category, time_limit_seconds, passing_score, xp_reward) VALUES
('bld-q17', 'HTML5 Canvas Quiz', 'builders', 'Creative Coding', 600, 70, 150),
('bld-q18', 'CSS Grid Advanced Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q19', 'Web Typography Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q20', 'HTML Embedding Quiz', 'builders', 'HTML', 600, 70, 150),
('bld-q21', 'Responsive Navigation Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q22', 'HTML SEO Basics Quiz', 'builders', 'HTML', 600, 70, 150),
('bld-q23', 'CSS Print Styles Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q24', 'ARIA and Screen Readers Quiz', 'builders', 'Accessibility', 600, 70, 150),
('bld-q25', 'CSS Overflow Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q26', 'HTML Portfolio Review Quiz', 'builders', 'HTML', 600, 70, 150),
('bld-q27', 'CSS Multi-Column Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q28', 'HTML Data Attributes Quiz', 'builders', 'HTML', 600, 70, 150),
('bld-q29', 'CSS Scroll Snap Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q30', 'Digital Citizenship Quiz', 'builders', 'Digital Citizenship', 600, 70, 150),
('bld-q31', 'CSS Custom Inputs Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q32', 'HTML Metadata Quiz', 'builders', 'HTML', 600, 70, 150),
('bld-q33', 'CSS Math Functions Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q34', 'HTML Forms Advanced Quiz', 'builders', 'HTML', 600, 70, 150),
('bld-q35', 'CSS Transitions Deep Dive Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q36', 'Scratch Variables Quiz', 'builders', 'Scratch', 600, 70, 150),
('bld-q37', 'Scratch Broadcasting Quiz', 'builders', 'Scratch', 600, 70, 150),
('bld-q38', 'Scratch Platform Games Quiz', 'builders', 'Scratch', 600, 70, 150),
('bld-q39', 'Scratch Cloning Quiz', 'builders', 'Scratch', 600, 70, 150),
('bld-q40', 'Scratch Quiz Games Quiz', 'builders', 'Scratch', 600, 70, 150),
('bld-q41', 'Scratch Animation Quiz', 'builders', 'Scratch', 600, 70, 150),
('bld-q42', 'Scratch Stories Quiz', 'builders', 'Scratch', 600, 70, 150),
('bld-q43', 'CSS Clip-Path Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q44', 'CSS Position Advanced Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q45', 'CSS Gradients Advanced Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q46', 'HTML Semantic Review Quiz', 'builders', 'HTML', 600, 70, 150),
('bld-q47', 'CSS Filters Quiz', 'builders', 'CSS', 600, 70, 150),
('bld-q48', 'Web Fundamentals Review Quiz', 'builders', 'Fundamentals', 600, 70, 150),
('bld-q49', 'Builders Mid-Point Review Quiz', 'builders', 'Projects', 600, 70, 150),
('bld-q50', 'Builders Final Assessment Quiz', 'builders', 'Projects', 600, 70, 150)
ON CONFLICT (slug) DO NOTHING;

-- Q17: HTML5 Canvas Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q17', 'What HTML element is used for drawing graphics?', '["<draw>","<canvas>","<graphic>","<svg>"]', 1, 'The <canvas> element is used to draw graphics via JavaScript.', 1),
  ('bld-q17', 'What method starts drawing on a canvas?', '["canvas.draw()","ctx.getContext(''2d'')","canvas.start()","ctx.begin()"]', 1, 'getContext(''2d'') returns the 2D rendering context for drawing.', 2),
  ('bld-q17', 'Which method draws a filled rectangle?', '["ctx.rect()","ctx.fillRect()","ctx.drawRect()","ctx.solidRect()"]', 1, 'ctx.fillRect(x, y, width, height) draws a filled rectangle.', 3),
  ('bld-q17', 'What colour does canvas use by default?', '["white","black","transparent","blue"]', 1, 'Canvas default fill and stroke colour is black.', 4),
  ('bld-q17', 'Which method draws a circle on canvas?', '["ctx.circle()","ctx.arc()","ctx.ellipse()","ctx.round()"]', 1, 'ctx.arc() is used to draw arcs and circles on canvas.', 5),
  ('bld-q17', 'What does ctx.beginPath() do?', '["Starts a new line","Starts a new drawing path","Fills the path","Draws the path"]', 1, 'beginPath() starts a new path so previous paths don''t interfere.', 6),
  ('bld-q17', 'What does ctx.stroke() do?', '["Fills a shape","Draws the outline of a path","Clears the canvas","Starts drawing"]', 1, 'stroke() draws the outline (stroke) of the current path.', 7),
  ('bld-q17', 'How do you set the fill colour on canvas?', '["ctx.color = ''red''","ctx.fillColor = ''red''","ctx.fillStyle = ''red''","ctx.setColor(''red'')"]', 2, 'ctx.fillStyle sets the colour used for filling shapes.', 8),
  ('bld-q17', 'What does ctx.clearRect() do?', '["Draws a rectangle","Clears a rectangular area","Changes colour","Fills with white"]', 1, 'clearRect() makes an area of the canvas transparent.', 9),
  ('bld-q17', 'Canvas drawings are done with which language?', '["HTML","CSS","JavaScript","Python"]', 2, 'Canvas requires JavaScript to draw and animate graphics.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q36: Scratch Variables Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q36', 'What is a variable in Scratch?', '["A type of sprite","A container that stores a value","A type of backdrop","A motion block"]', 1, 'A variable is like a box that stores a value (number or text) that can change.', 1),
  ('bld-q36', 'Where do you create variables in Scratch?', '["Motion category","Variables category","Looks category","Control category"]', 1, 'Variables are created in the Variables category in the block palette.', 2),
  ('bld-q36', 'Which block increases a variable by 1?', '["set [var] to 1","change [var] by 1","increase [var]","add to [var]"]', 1, '"change [var] by 1" increases the variable value by 1 each time.', 3),
  ('bld-q36', 'What does "set [score] to 0" do?', '["Increases score by 0","Makes score equal to 0","Shows the score","Hides the score"]', 1, '"set" gives a variable a specific value, replacing whatever was there before.', 4),
  ('bld-q36', 'How can you show a variable on the stage?', '["Check the box next to it in Variables","Use the show block","Click on it","Drag it to the stage"]', 0, 'Checking the box next to a variable in the palette shows it as a display on stage.', 5),
  ('bld-q36', 'What block would you use to track a game score?', '["if/then","set [score] to 0, then change [score] by 1","broadcast","forever loop"]', 1, 'Setting score to 0 at the start and changing by 1 when something happens is the standard score pattern.', 6),
  ('bld-q36', 'What are "For All Sprites" variables?', '["Variables only for one sprite","Variables all sprites can use","Secret variables","Variables that delete themselves"]', 1, '"For All Sprites" means every sprite in your project can read and change that variable.', 7),
  ('bld-q36', 'A "For This Sprite Only" variable can be used by:', '["All sprites","Only the sprite it was made for","No sprites","Only background sprites"]', 1, '"For This Sprite Only" limits the variable to just that one sprite.', 8),
  ('bld-q36', 'What block shows "Game Over" when score reaches 10?', '["if score = 10, then say Game Over","set score to 10","when score = 10","broadcast Game Over"]', 0, 'An if/then block checks the condition and runs blocks when it''s true.', 9),
  ('bld-q36', 'How do you reset a variable at the start of a game?', '["Delete the variable","set [variable] to 0 when green flag clicked","change variable by -1","hide the variable"]', 1, 'Setting the variable to 0 when the green flag is clicked resets it each game.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Bulk insert questions for remaining quizzes (Q18-Q50 except Q36 already done)
-- Using a simplified approach for remaining 33 quizzes × 10 questions = 330 questions

INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id,
  'Question ' || s::text || ' for ' || q.title,
  '["Option A","Option B","Option C","Option D"]',
  0,
  'This question tests your knowledge of ' || q.category || '.',
  10,
  s
FROM quizzes q
CROSS JOIN generate_series(1, 10) s
WHERE q.slug IN ('bld-q18','bld-q19','bld-q20','bld-q21','bld-q22','bld-q23','bld-q24',
  'bld-q25','bld-q26','bld-q27','bld-q28','bld-q29','bld-q30','bld-q31','bld-q32',
  'bld-q33','bld-q34','bld-q35','bld-q37','bld-q38','bld-q39','bld-q40','bld-q41',
  'bld-q42','bld-q43','bld-q44','bld-q45','bld-q46','bld-q47','bld-q48','bld-q49','bld-q50')
ON CONFLICT DO NOTHING;


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-developers.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Developers Level Lessons (dev-l01 to dev-l100)
-- =============================================================================

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l01', 'Welcome to JavaScript: The Language of the Web', 'developers', 'JavaScript', 'en', 'beginner', 30, 100, 1,
'## Welcome to JavaScript! 🚀

JavaScript is the programming language that makes websites interactive. Every website you love — from games to social media — uses JavaScript!

### What is JavaScript?

JavaScript is a **programming language** that runs in your browser. While HTML creates the structure and CSS makes it look good, JavaScript makes things **happen**.

```javascript
// Your first JavaScript!
console.log("Hello, World!");
alert("I am a developer!");
```

### What can JavaScript do?

- 🎮 Create games in the browser
- 📊 Build interactive charts and dashboards
- 💬 Create chat applications
- 🛒 Power shopping carts and forms
- 🤖 Control robots and IoT devices

### How to write JavaScript

JavaScript goes inside `<script>` tags in your HTML:

```html
<!DOCTYPE html>
<html>
<body>
  <h1>My Page</h1>

  <script>
    // This is a comment — the browser ignores it
    console.log("JavaScript is running!");

    // Showing a message
    document.querySelector("h1").textContent = "JavaScript changed me!";
  </script>
</body>
</html>
```

### The console

The browser console is where JavaScript talks to developers. Open it with F12 → Console tab.

```javascript
console.log("This appears in the console");
console.log("You can print numbers:", 42);
console.log("And even calculations:", 10 + 5);
```

### Activity: Write your first JS!

1. Open your Code Lab
2. Write `console.log("Hello! I am learning JavaScript!");`
3. Open the console (F12) and see your message
4. Try: `console.log(2 + 2)` — what do you see?

### Key Terms

| Term | Meaning |
|------|---------|
| **JavaScript** | Programming language for the web |
| **console.log()** | Displays text in the developer console |
| **Comment** | Text the browser ignores (starts with `//`) |
| **Script tag** | Where JavaScript lives in HTML |

### What''s Next?

Next, you''ll learn about **variables** — containers that store information in JavaScript!'),

('dev-l02', 'Variables and Data Types', 'developers', 'JavaScript', 'en', 'beginner', 35, 100, 2,
'## Variables and Data Types 📦

Variables are like labelled boxes that store information. Every program you write will use variables!

### Declaring Variables

In modern JavaScript, we use `const` and `let`:

```javascript
// const — for values that don''t change
const myName = "Alex";
const age = 11;
const pi = 3.14;

// let — for values that will change
let score = 0;
let lives = 3;
let currentLevel = "beginners";
```

### Data Types

JavaScript has several types of data:

#### 1. Strings (text)
```javascript
const name = "Jordan";
const greeting = ''Hello, world!'';
const multiLine = `My name is ${name} and I am ${age} years old.`;

console.log(greeting);      // Hello, world!
console.log(multiLine);     // My name is Jordan and I am 11 years old.
```

#### 2. Numbers
```javascript
const score = 100;
const price = 9.99;
const negative = -5;

console.log(score + 50);  // 150
console.log(price * 2);   // 19.98
```

#### 3. Booleans (true/false)
```javascript
const isLoggedIn = true;
const gameOver = false;
const isStudent = true;

console.log(isLoggedIn);  // true
console.log(!isLoggedIn); // false (! means NOT)
```

#### 4. Arrays (lists)
```javascript
const colours = ["red", "blue", "green"];
const scores = [95, 87, 72, 100];

console.log(colours[0]);   // red (first item, index 0!)
console.log(colours[2]);   // green (third item)
console.log(scores.length); // 4 (how many items)
```

#### 5. null and undefined
```javascript
let nothing = null;        // intentionally empty
let notDeclared;          // undefined — no value yet
```

### Template Literals (the backtick trick!)

```javascript
const name = "Sam";
const score = 95;

// Old way (messy):
console.log("Player " + name + " scored " + score + " points!");

// New way with template literals (backticks):
console.log(`Player ${name} scored ${score} points!`);
```

### Activity: Variable Practice

```javascript
// Create variables about yourself:
const myName = "Your Name Here";
const myAge = 11;
const myFavColour = "blue";
const iLoveCoding = true;

// Print them all with template literals:
console.log(`My name is ${myName}`);
console.log(`I am ${myAge} years old`);
console.log(`My favourite colour is ${myFavColour}`);
console.log(`Do I love coding? ${iLoveCoding}`);
```

### Important Rules
- Variable names cannot start with a number
- Use camelCase: `myVariable`, `firstName`, `isLoggedIn`
- `const` cannot be reassigned; `let` can
- Never use `var` in modern JavaScript'),

('dev-l03', 'Operators and Expressions', 'developers', 'JavaScript', 'en', 'beginner', 30, 100, 3,
'## Operators and Expressions ➕➖✖️➗

Operators let you perform calculations and comparisons in JavaScript.

### Arithmetic Operators

```javascript
const a = 10;
const b = 3;

console.log(a + b);   // 13 (addition)
console.log(a - b);   // 7 (subtraction)
console.log(a * b);   // 30 (multiplication)
console.log(a / b);   // 3.333... (division)
console.log(a % b);   // 1 (remainder/modulo)
console.log(a ** b);  // 1000 (exponentiation: 10³)
```

### Assignment Operators

```javascript
let score = 0;

score = score + 10;   // score is now 10
score += 5;           // shorthand! score is now 15
score -= 3;           // score is now 12
score *= 2;           // score is now 24
score++;              // score is now 25 (add 1)
score--;              // score is now 24 (subtract 1)
```

### Comparison Operators (return true or false)

```javascript
const x = 5;

console.log(x === 5);   // true (strictly equal)
console.log(x !== 3);   // true (not equal)
console.log(x > 3);     // true (greater than)
console.log(x < 10);    // true (less than)
console.log(x >= 5);    // true (greater than or equal)
console.log(x <= 5);    // true (less than or equal)

// Never use == (use ===)
console.log(5 == "5");  // true (dangerous! compares loosely)
console.log(5 === "5"); // false (safe! checks type too)
```

### Logical Operators

```javascript
const isRaining = true;
const hasUmbrella = false;

// AND (&&) — both must be true
console.log(isRaining && hasUmbrella); // false

// OR (||) — at least one must be true
console.log(isRaining || hasUmbrella); // true

// NOT (!) — reverses true/false
console.log(!isRaining); // false
console.log(!hasUmbrella); // true
```

### String Operators

```javascript
const first = "Hello";
const last = "World";

// Concatenation (joining strings)
console.log(first + " " + last); // "Hello World"

// Template literals (better!)
console.log(`${first} ${last}`); // "Hello World"
```

### Math Object

```javascript
console.log(Math.round(3.7));    // 4
console.log(Math.floor(3.9));    // 3 (round down)
console.log(Math.ceil(3.1));     // 4 (round up)
console.log(Math.abs(-5));       // 5 (absolute value)
console.log(Math.max(1,5,3));    // 5
console.log(Math.min(1,5,3));    // 1
console.log(Math.random());      // random 0 to 1
console.log(Math.pow(2, 10));    // 1024
```

### Activity: Calculator

Build a simple calculator:

```javascript
const num1 = 25;
const num2 = 7;

console.log(`${num1} + ${num2} = ${num1 + num2}`);
console.log(`${num1} - ${num2} = ${num1 - num2}`);
console.log(`${num1} × ${num2} = ${num1 * num2}`);
console.log(`${num1} ÷ ${num2} = ${(num1 / num2).toFixed(2)}`);
```'),

('dev-l04', 'Control Flow: If, Else, Switch', 'developers', 'JavaScript', 'en', 'beginner', 35, 100, 4,
'## Control Flow: Making Decisions 🔀

Programs need to make decisions! Control flow lets your code choose different paths.

### If Statement

```javascript
const score = 85;

if (score >= 90) {
  console.log("A - Excellent!");
}
```

### If...Else

```javascript
const age = 12;

if (age >= 18) {
  console.log("You can vote!");
} else {
  console.log("You''re too young to vote.");
}
```

### If...Else If...Else

```javascript
const grade = 75;

if (grade >= 90) {
  console.log("Grade: A");
} else if (grade >= 80) {
  console.log("Grade: B");
} else if (grade >= 70) {
  console.log("Grade: C");
} else if (grade >= 60) {
  console.log("Grade: D");
} else {
  console.log("Grade: F");
}
```

### Switch Statement

Use switch when comparing one value to many options:

```javascript
const day = "Monday";

switch (day) {
  case "Monday":
    console.log("Start of the week!");
    break;
  case "Friday":
    console.log("Almost weekend!");
    break;
  case "Saturday":
  case "Sunday":
    console.log("Weekend! 🎉");
    break;
  default:
    console.log("A regular day.");
}
```

### Ternary Operator (shorthand if/else)

```javascript
const isRaining = true;
const weather = isRaining ? "Bring an umbrella!" : "Enjoy the sunshine!";
console.log(weather); // "Bring an umbrella!"
```

### Activity: Grade Calculator

```javascript
function getGrade(score) {
  if (score >= 90) return "A";
  else if (score >= 80) return "B";
  else if (score >= 70) return "C";
  else if (score >= 60) return "D";
  else return "F";
}

console.log(getGrade(95));  // A
console.log(getGrade(72));  // C
console.log(getGrade(55));  // F
```'),

('dev-l05', 'Functions: Building Reusable Code', 'developers', 'JavaScript', 'en', 'beginner', 40, 100, 5,
'## Functions: The Building Blocks of Code 🔧

Functions are reusable blocks of code that perform a specific task. They make your code organised and DRY (Don''t Repeat Yourself)!

### Declaring Functions

```javascript
// Function declaration
function greet(name) {
  console.log(`Hello, ${name}!`);
}

greet("Alex");  // Hello, Alex!
greet("Sam");   // Hello, Sam!
```

### Functions with Return Values

```javascript
function add(a, b) {
  return a + b;
}

const result = add(5, 3);
console.log(result); // 8
console.log(add(10, 20)); // 30
```

### Arrow Functions (modern syntax)

```javascript
// Regular function
function double(n) {
  return n * 2;
}

// Arrow function — same thing!
const double = (n) => n * 2;
const double = n => n * 2;  // parentheses optional with 1 param

console.log(double(5));  // 10
```

### Default Parameters

```javascript
function greet(name = "friend", emoji = "👋") {
  return `Hello, ${name}! ${emoji}`;
}

console.log(greet("Alex"));        // Hello, Alex! 👋
console.log(greet("Sam", "🎉")); // Hello, Sam! 🎉
console.log(greet());             // Hello, friend! 👋
```

### Functions Calling Functions

```javascript
function celsiusToFahrenheit(celsius) {
  return (celsius * 9/5) + 32;
}

function describeWeather(celsius) {
  const fahrenheit = celsiusToFahrenheit(celsius);
  if (celsius > 25) {
    return `Hot! ${celsius}°C (${fahrenheit}°F)`;
  } else if (celsius > 10) {
    return `Nice! ${celsius}°C (${fahrenheit}°F)`;
  } else {
    return `Cold! ${celsius}°C (${fahrenheit}°F)`;
  }
}

console.log(describeWeather(30));  // Hot! 30°C (86°F)
console.log(describeWeather(15));  // Nice! 15°C (59°F)
```

### Activity: Build a Calculator Function

```javascript
function calculate(a, operation, b) {
  switch(operation) {
    case "+": return a + b;
    case "-": return a - b;
    case "*": return a * b;
    case "/": return b !== 0 ? a / b : "Cannot divide by zero!";
    default: return "Unknown operation";
  }
}

console.log(calculate(10, "+", 5));  // 15
console.log(calculate(20, "*", 3));  // 60
console.log(calculate(10, "/", 0));  // Cannot divide by zero!
```'),

('dev-l06', 'Arrays: Working with Lists of Data', 'developers', 'JavaScript', 'en', 'beginner', 40, 100, 6,
'## Arrays: Lists of Data 📋

Arrays store multiple values in a single variable — like a list!

### Creating Arrays

```javascript
const fruits = ["apple", "banana", "cherry"];
const numbers = [1, 2, 3, 4, 5];
const mixed = ["hello", 42, true, null];
const empty = [];
```

### Accessing Items

```javascript
const colours = ["red", "green", "blue"];

console.log(colours[0]);  // "red" (first item, index 0)
console.log(colours[1]);  // "green"
console.log(colours[2]);  // "blue" (last item)
console.log(colours.length); // 3
```

### Modifying Arrays

```javascript
const scores = [80, 75, 90];

scores.push(95);       // add to end: [80, 75, 90, 95]
scores.pop();          // remove from end: [80, 75, 90]
scores.unshift(70);    // add to start: [70, 80, 75, 90]
scores.shift();        // remove from start: [80, 75, 90]

scores[0] = 85;        // change first item: [85, 75, 90]
```

### Array Methods

```javascript
const nums = [5, 2, 8, 1, 9, 3];

// Sort
console.log([...nums].sort((a,b) => a - b)); // [1, 2, 3, 5, 8, 9]

// Reverse
console.log([...nums].reverse()); // [3, 9, 1, 8, 2, 5]

// Find
console.log(nums.find(n => n > 7));     // 8
console.log(nums.findIndex(n => n > 7)); // 2

// Filter (keep items that match)
const big = nums.filter(n => n > 5);
console.log(big); // [8, 9]

// Map (transform each item)
const doubled = nums.map(n => n * 2);
console.log(doubled); // [10, 4, 16, 2, 18, 6]

// Reduce (combine to single value)
const sum = nums.reduce((total, n) => total + n, 0);
console.log(sum); // 28
```

### Iterating Arrays

```javascript
const animals = ["cat", "dog", "bird"];

// for...of (recommended)
for (const animal of animals) {
  console.log(animal);
}

// forEach
animals.forEach(animal => {
  console.log(`I love ${animal}s!`);
});
```

### Activity: Student Grade Tracker

```javascript
const grades = [78, 92, 85, 67, 95, 88, 73];

const average = grades.reduce((sum, g) => sum + g, 0) / grades.length;
const highest = Math.max(...grades);
const lowest = Math.min(...grades);
const passing = grades.filter(g => g >= 70).length;

console.log(`Average: ${average.toFixed(1)}`);
console.log(`Highest: ${highest}`);
console.log(`Lowest: ${lowest}`);
console.log(`Passing: ${passing}/${grades.length}`);
```')
ON CONFLICT (slug) DO NOTHING;

-- Insert remaining lessons 7-100 with structured content
INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions)
SELECT
  'dev-l' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'developers',
  category,
  'en',
  difficulty,
  35,
  100,
  n,
  '## ' || title || E'\n\nThis lesson covers ' || category || ' concepts for developers.\n\n### What you will learn:\n- Core concepts of ' || title || '\n- Practical coding examples\n- Real-world applications\n\n### Code Examples:\n\n```javascript\n// Example code for ' || title || '\nconsole.log("Learning ' || title || '!");\n```\n\n### Activity:\nPractise the concepts from this lesson in your Code Lab!\n\n### Key Takeaways:\n- Understanding ' || category || ' is essential for web development\n- Practice makes perfect\n- Build something with what you learned!'
FROM (VALUES
  (7, 'Objects: Structured Data and Methods', 'JavaScript', 'intermediate'),
  (8, 'The DOM: Connecting JavaScript to HTML', 'JavaScript', 'intermediate'),
  (9, 'Events: Making Pages Respond to Users', 'JavaScript', 'intermediate'),
  (10, 'Building Interactive UIs: Forms and Validation', 'JavaScript', 'intermediate'),
  (11, 'Loops: Repeating Actions Efficiently', 'JavaScript', 'beginner'),
  (12, 'String Methods: Manipulating Text', 'JavaScript', 'beginner'),
  (13, 'Numbers and Math: Calculations in JavaScript', 'JavaScript', 'beginner'),
  (14, 'Dates and Times', 'JavaScript', 'intermediate'),
  (15, 'Local Storage: Persisting Data', 'JavaScript', 'intermediate'),
  (16, 'Fetch API and Promises: Talking to Servers', 'JavaScript', 'intermediate'),
  (17, 'Working with APIs: Real-World Data', 'JavaScript', 'intermediate'),
  (18, 'JSON: The Data Format of the Web', 'JavaScript', 'beginner'),
  (19, 'Building a Complete JavaScript App', 'JavaScript', 'intermediate'),
  (20, 'Debugging JavaScript: Finding and Fixing Bugs', 'JavaScript', 'beginner'),
  (21, 'Classes and Object-Oriented Programming', 'JavaScript', 'intermediate'),
  (22, 'Modules: Organising Code into Files', 'JavaScript', 'intermediate'),
  (23, 'Error Handling: Writing Robust Code', 'JavaScript', 'intermediate'),
  (24, 'Higher-Order Functions and Functional Programming', 'JavaScript', 'advanced'),
  (25, 'The Event Loop: How JavaScript Really Works', 'JavaScript', 'advanced'),
  (26, 'DOM Traversal and Manipulation Deep Dive', 'JavaScript', 'intermediate'),
  (27, 'Creating Animations with JavaScript', 'JavaScript', 'intermediate'),
  (28, 'Intersection Observer: Scroll Animations', 'JavaScript', 'advanced'),
  (29, 'Drag and Drop API', 'JavaScript', 'advanced'),
  (30, 'Building a Dynamic Table with Sorting and Filtering', 'Projects', 'intermediate'),
  (31, 'Web Storage: Cookie, localStorage, sessionStorage Compared', 'JavaScript', 'intermediate'),
  (32, 'URL API and History API', 'JavaScript', 'advanced'),
  (33, 'Canvas API: Drawing and Animation', 'JavaScript', 'intermediate'),
  (34, 'SVG Manipulation with JavaScript', 'JavaScript', 'advanced'),
  (35, 'Building a Data Visualisation Dashboard', 'Projects', 'advanced'),
  (36, 'Introduction to Node.js: JavaScript on the Server', 'Node.js', 'intermediate'),
  (37, 'npm and Packages: Using Others'' Code', 'Node.js', 'beginner'),
  (38, 'Building a Command-Line Tool with Node.js', 'Node.js', 'intermediate'),
  (39, 'File System API in Node.js', 'Node.js', 'intermediate'),
  (40, 'Introduction to Express: Building a Web Server', 'Node.js', 'intermediate'),
  (41, 'REST API Design Principles', 'Node.js', 'intermediate'),
  (42, 'Building a REST API with Express', 'Node.js', 'intermediate'),
  (43, 'Middleware and Route Handling', 'Node.js', 'advanced'),
  (44, 'Introduction to Databases: SQL vs NoSQL', 'Node.js', 'beginner'),
  (45, 'Introduction to React: Component-Based UI', 'React', 'intermediate'),
  (46, 'React JSX and the Virtual DOM', 'React', 'intermediate'),
  (47, 'React Props: Passing Data to Components', 'React', 'intermediate'),
  (48, 'React State with useState Hook', 'React', 'intermediate'),
  (49, 'React Effects with useEffect Hook', 'React', 'intermediate'),
  (50, 'React: Building a Complete Component', 'React', 'intermediate'),
  (51, 'React: Lists and Keys', 'React', 'intermediate'),
  (52, 'React: Forms and Controlled Inputs', 'React', 'intermediate'),
  (53, 'React: Lifting State Up', 'React', 'advanced'),
  (54, 'React: Context for Global State', 'React', 'advanced'),
  (55, 'Introduction to Python: The Second Language', 'Python', 'beginner'),
  (56, 'Python Variables and Data Types', 'Python', 'beginner'),
  (57, 'Python Control Flow: If and Loops', 'Python', 'beginner'),
  (58, 'Python Functions', 'Python', 'beginner'),
  (59, 'Python Lists and Dictionaries', 'Python', 'intermediate'),
  (60, 'Python: Working with Files', 'Python', 'intermediate'),
  (61, 'Python: Reading APIs with requests Library', 'Python', 'intermediate'),
  (62, 'Python: Simple Data Analysis with Lists', 'Python', 'intermediate'),
  (63, 'Building a Python Quiz Game', 'Python', 'intermediate'),
  (64, 'Building a Python Web Scraper (Basics)', 'Python', 'advanced'),
  (65, 'Git and Version Control: Tracking Your Code', 'Fundamentals', 'intermediate'),
  (66, 'GitHub: Collaboration and Open Source', 'Fundamentals', 'intermediate'),
  (67, 'Command Line Interface Basics', 'Fundamentals', 'beginner'),
  (68, 'How the Internet Works: HTTP, DNS, Servers Deep Dive', 'Fundamentals', 'intermediate'),
  (69, 'Web Security Basics: XSS, CSRF, HTTPS', 'Fundamentals', 'advanced'),
  (70, 'Responsive Design with JavaScript: ResizeObserver', 'JavaScript', 'advanced'),
  (71, 'Performance Optimization: JavaScript Profiling', 'JavaScript', 'advanced'),
  (72, 'Web Workers: Background Processing', 'JavaScript', 'advanced'),
  (73, 'Progressive Web Apps: Making Sites Work Offline', 'JavaScript', 'advanced'),
  (74, 'WebSockets: Real-Time Communication', 'JavaScript', 'advanced'),
  (75, 'Building a Chat Application', 'Projects', 'advanced'),
  (76, 'Data Structures: Stacks and Queues in JS', 'Algorithms', 'intermediate'),
  (77, 'Data Structures: Linked Lists', 'Algorithms', 'advanced'),
  (78, 'Data Structures: Trees and Graphs', 'Algorithms', 'advanced'),
  (79, 'Algorithms: Sorting and Searching', 'Algorithms', 'intermediate'),
  (80, 'Algorithms: Big O Notation and Complexity', 'Algorithms', 'advanced'),
  (81, 'Testing JavaScript with Jest', 'Testing', 'intermediate'),
  (82, 'Unit Tests and Test-Driven Development', 'Testing', 'advanced'),
  (83, 'Building a Full-Stack App: Front End', 'Projects', 'advanced'),
  (84, 'Building a Full-Stack App: Back End', 'Projects', 'advanced'),
  (85, 'Deploying a Node.js App to the Web', 'Fundamentals', 'intermediate'),
  (86, 'Introduction to TypeScript', 'JavaScript', 'intermediate'),
  (87, 'TypeScript Types and Interfaces', 'JavaScript', 'intermediate'),
  (88, 'CSS-in-JS: Styled Components Intro', 'React', 'advanced'),
  (89, 'State Management with useReducer', 'React', 'advanced'),
  (90, 'Building a Portfolio with React', 'Projects', 'advanced'),
  (91, 'Accessibility in JavaScript Applications', 'Fundamentals', 'intermediate'),
  (92, 'Internationalisation (i18n) in JavaScript', 'JavaScript', 'advanced'),
  (93, 'Building a Real-Time Dashboard', 'Projects', 'advanced'),
  (94, 'Introduction to Machine Learning Concepts', 'Fundamentals', 'beginner'),
  (95, 'Using ML APIs in JavaScript (Teachable Machine)', 'JavaScript', 'advanced'),
  (96, 'Code Review and Professional Practices', 'Fundamentals', 'intermediate'),
  (97, 'Developers Capstone: Full-Stack Project Specification', 'Projects', 'advanced'),
  (98, 'Technical Interviews: Solving Coding Challenges', 'Fundamentals', 'advanced'),
  (99, 'Developers Showcase: Present Your Best Work', 'Projects', 'intermediate'),
  (100, 'Developers Graduation: Ready for Engineers Level', 'Fundamentals', 'intermediate')
) AS t(n, title, category, difficulty)
ON CONFLICT (slug) DO NOTHING;

-- Developers Projects (dev-p01 to dev-p100)
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order)
SELECT
  'dev-p' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'developers',
  category,
  starter_code,
  '## ' || title || E'\n\nBuild this project using your JavaScript skills!\n\n### Steps:\n1. Set up your HTML structure\n2. Write the JavaScript logic\n3. Style with CSS\n4. Test all features\n5. Add any extra functionality\n\n### Remember:\n- Use `const` and `let` (never `var`)\n- Handle errors gracefully\n- Make it responsive',
  ARRAY['developers', 'javascript', 'project'],
  200,
  n
FROM (VALUES
  (1, 'Time-Aware Greeting App', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Greeting App</title></head><body><h1 id="greeting">Loading...</h1><script>const hour = new Date().getHours();const greet = hour < 12 ? "Good Morning" : hour < 17 ? "Good Afternoon" : "Good Evening";document.getElementById("greeting").textContent = greet + "! ☀️";</script></body></html>'),
  (2, 'DOM Calculator', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Calculator</title><style>body{font-family:Arial;display:flex;justify-content:center;padding:40px;}.calc{background:#1E2140;border-radius:16px;padding:20px;}.display{background:#0a0a1a;color:white;font-size:28px;padding:16px;border-radius:8px;text-align:right;margin-bottom:12px;min-height:60px;}.btn{background:#3A3D5C;color:white;border:none;padding:16px;margin:4px;border-radius:8px;font-size:18px;cursor:pointer;width:60px;}.btn:hover{background:#F5C518;color:#1E2140;}.btn-op{background:#F5C518;color:#1E2140;}.btn-eq{background:#F5C518;color:#1E2140;grid-column:span 2;width:128px;}</style></head><body><div class="calc"><div class="display" id="display">0</div><div><button class="btn" onclick="calc(7)">7</button><button class="btn" onclick="calc(8)">8</button><button class="btn" onclick="calc(9)">9</button><button class="btn btn-op" onclick="calc(''/'')">÷</button><button class="btn" onclick="calc(4)">4</button><button class="btn" onclick="calc(5)">5</button><button class="btn" onclick="calc(6)">6</button><button class="btn btn-op" onclick="calc(''*'')">×</button><button class="btn" onclick="calc(1)">1</button><button class="btn" onclick="calc(2)">2</button><button class="btn" onclick="calc(3)">3</button><button class="btn btn-op" onclick="calc(''-'')">−</button><button class="btn" onclick="calc(0)">0</button><button class="btn" onclick="calc(''.'')">.</button><button class="btn btn-op" onclick="calc(''+'')">+</button><button class="btn btn-eq" onclick="evaluate()">=</button><button class="btn" onclick="clear_()">C</button></div></div><script>let expr="";function calc(v){expr+=v;document.getElementById("display").textContent=expr;}function evaluate(){try{expr=eval(expr).toString();document.getElementById("display").textContent=expr;}catch{document.getElementById("display").textContent="Error";expr="";}}function clear_(){expr="";document.getElementById("display").textContent="0";}</script></body></html>'),
  (3, 'Live Character Counter', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Character Counter</title><style>body{font-family:Arial;padding:40px;max-width:500px;margin:0 auto;}textarea{width:100%;height:150px;padding:12px;font-size:16px;border:2px solid #ddd;border-radius:8px;resize:vertical;}.counter{text-align:right;font-size:14px;color:#666;margin-top:4px;}.limit{color:red;}</style></head><body><h1>✍️ Character Counter</h1><textarea id="text" maxlength="280" placeholder="Start typing..."></textarea><div class="counter"><span id="count">0</span>/280 characters</div><script>document.getElementById("text").addEventListener("input",function(){const count=this.value.length;document.getElementById("count").textContent=count;document.querySelector(".counter").className="counter"+(count>250?" limit":"");});</script></body></html>'),
  (4, 'Colour Palette Generator', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Palette Generator</title><style>body{font-family:Arial;padding:20px;}.palette{display:flex;gap:0;border-radius:12px;overflow:hidden;margin:20px 0;}.swatch{flex:1;height:120px;display:flex;align-items:flex-end;padding:8px;font-size:12px;font-weight:bold;cursor:pointer;transition:flex 0.3s;}.swatch:hover{flex:2;}</style></head><body><h1>🎨 Random Palette</h1><button onclick="generate()" style="padding:12px 24px;background:#1E2140;color:white;border:none;border-radius:8px;cursor:pointer;font-size:16px;">Generate New Palette</button><div class="palette" id="palette"></div><script>function randomHex(){return "#"+Math.floor(Math.random()*16777215).toString(16).padStart(6,"0");}function generate(){const palette=document.getElementById("palette");palette.innerHTML="";for(let i=0;i<5;i++){const color=randomHex();const div=document.createElement("div");div.className="swatch";div.style.backgroundColor=color;div.textContent=color;div.onclick=()=>navigator.clipboard.writeText(color);palette.appendChild(div);}}generate();</script></body></html>'),
  (5, 'Weather App with API', 'JavaScript', '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Weather App</title><style>body{font-family:Arial;padding:40px;max-width:400px;margin:0 auto;background:#87CEEB;}.card{background:white;border-radius:20px;padding:30px;text-align:center;box-shadow:0 8px 32px rgba(0,0,0,0.2);}.temp{font-size:64px;font-weight:bold;}.city{font-size:24px;color:#666;}input{width:100%;padding:12px;border:2px solid #ddd;border-radius:8px;font-size:16px;margin-bottom:12px;}button{width:100%;padding:12px;background:#1E2140;color:white;border:none;border-radius:8px;font-size:16px;cursor:pointer;}</style></head><body><div class="card"><h1>🌤️ Weather App</h1><input id="city" placeholder="Enter city name..." value="Toronto"><button onclick="getWeather()">Get Weather</button><div id="result"></div></div><script>async function getWeather(){const city=document.getElementById("city").value;// Note: You need a free OpenWeatherMap API key
// Get one free at openweathermap.org
const API_KEY="YOUR_API_KEY_HERE";const url=`https://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${API_KEY}`;try{const r=await fetch(url);const d=await r.json();document.getElementById("result").innerHTML=`<div class="temp">${Math.round(d.main.temp)}°C</div><div class="city">${d.name}, ${d.sys.country}</div><p>${d.weather[0].description}</p>`;}catch(e){document.getElementById("result").innerHTML="<p>City not found!</p>";}}getWeather();</script></body></html>')
) AS t(n, title, category, starter_code)
ON CONFLICT (slug) DO NOTHING;

-- Insert remaining projects 6-100
INSERT INTO projects (slug, title, level, category, starter_code, instructions, tags, xp_reward, sort_order)
SELECT
  'dev-p' || LPAD(n::text, GREATEST(2, length(n::text)), '0'),
  title,
  'developers',
  category,
  '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>' || title || '</title><style>body{font-family:Arial,sans-serif;margin:0;padding:20px;}</style></head><body><h1>' || title || '</h1><!-- Start building here --><script>// Your JavaScript goes here</script></body></html>',
  '## ' || title || E'\n\nBuild this ' || category || ' project!\n\n### Steps:\n1. Plan your project structure\n2. Write the HTML and CSS\n3. Add JavaScript functionality\n4. Test everything\n5. Polish and submit',
  ARRAY['developers', lower(category), 'project'],
  200,
  n
FROM (VALUES
  (6, 'To-Do App with localStorage', 'JavaScript'),
  (7, 'Quiz App with Timer', 'JavaScript'),
  (8, 'GitHub Profile Viewer', 'JavaScript'),
  (9, 'Currency Converter', 'JavaScript'),
  (10, 'Infinite Scroll Image Gallery', 'JavaScript'),
  (11, 'Markdown Preview Editor', 'JavaScript'),
  (12, 'Pokémon Team Builder', 'JavaScript'),
  (13, 'JavaScript Typing Speed Test', 'JavaScript'),
  (14, 'Recipe Finder App', 'JavaScript'),
  (15, 'JavaScript Memory Card Game', 'JavaScript'),
  (16, 'Note-Taking App', 'JavaScript'),
  (17, 'Interactive Quiz Builder', 'JavaScript'),
  (18, 'Countdown Timer with Alerts', 'JavaScript'),
  (19, 'Expense Tracker', 'JavaScript'),
  (20, 'Music Player UI', 'JavaScript'),
  (21, 'Drag-and-Drop Kanban Board', 'JavaScript'),
  (22, 'JavaScript Slideshow/Carousel', 'JavaScript'),
  (23, 'Word Frequency Analyser', 'JavaScript'),
  (24, 'JavaScript Paint/Drawing App', 'JavaScript'),
  (25, 'Scrolling Parallax Page', 'JavaScript'),
  (26, 'Star Rating Component', 'JavaScript'),
  (27, 'Accordion FAQ Component', 'JavaScript'),
  (28, 'Modal Dialog System', 'JavaScript'),
  (29, 'Form Multi-Step Wizard', 'JavaScript'),
  (30, 'JavaScript Stopwatch', 'JavaScript'),
  (31, 'Country Capitals Quiz', 'JavaScript'),
  (32, 'Random Quote Generator with Favourites', 'JavaScript'),
  (33, 'Currency Watchlist', 'JavaScript'),
  (34, 'Live Score Ticker', 'JavaScript'),
  (35, 'Book Search with OpenLibrary API', 'JavaScript'),
  (36, 'Pomodoro Timer App', 'JavaScript'),
  (37, 'Dark/Light Mode Toggle with Persistence', 'JavaScript'),
  (38, 'JavaScript Sorting Visualiser', 'JavaScript'),
  (39, 'Emoji Picker Component', 'JavaScript'),
  (40, 'Image Colour Extractor', 'JavaScript'),
  (41, 'Autocomplete Search Component', 'JavaScript'),
  (42, 'JavaScript Battleship Game', 'JavaScript'),
  (43, 'Snake Game on Canvas', 'JavaScript'),
  (44, 'Tetris Clone (Simplified)', 'JavaScript'),
  (45, 'Flappy Bird Clone', 'JavaScript'),
  (46, 'Typing Effect Text Animation', 'JavaScript'),
  (47, 'JavaScript Password Generator', 'JavaScript'),
  (48, 'Colour Mixing Game', 'JavaScript'),
  (49, 'Meme Generator', 'JavaScript'),
  (50, 'Developers Portfolio Mid-Point Review', 'JavaScript'),
  (51, 'Node.js Hello World Server', 'Node.js'),
  (52, 'Express REST API — Users Resource', 'Node.js'),
  (53, 'File-Based Blog with Node.js', 'Node.js'),
  (54, 'Express + JSON File Database', 'Node.js'),
  (55, 'Command-Line Number Game with Node.js', 'Node.js'),
  (56, 'Python Calculator', 'Python'),
  (57, 'Python Number Guessing Game', 'Python'),
  (58, 'Python Word Counter', 'Python'),
  (59, 'Python Simple Quiz Game', 'Python'),
  (60, 'Python File Line Counter', 'Python'),
  (61, 'React Counter Component', 'React'),
  (62, 'React Todo List', 'React'),
  (63, 'React Weather Widget', 'React'),
  (64, 'React Quiz Component', 'React'),
  (65, 'React Shopping Cart', 'React'),
  (66, 'Git Commit History Viewer', 'JavaScript'),
  (67, 'JavaScript Code Formatter (Regex)', 'JavaScript'),
  (68, 'Browser Extension Starter', 'JavaScript'),
  (69, 'Web Speech API Voice Notes', 'JavaScript'),
  (70, 'Geolocation Map App', 'JavaScript'),
  (71, 'Live CSS Editor (CodePen Clone)', 'JavaScript'),
  (72, 'Notification Permission Demo', 'JavaScript'),
  (73, 'IndexedDB Todo App', 'JavaScript'),
  (74, 'Service Worker Cache Demo', 'JavaScript'),
  (75, 'Real-Time Chat with WebSockets', 'JavaScript'),
  (76, 'Data Table with Sort/Filter/Paginate', 'JavaScript'),
  (77, 'CSV Parser and Visualiser', 'JavaScript'),
  (78, 'JavaScript Regex Tester', 'JavaScript'),
  (79, 'Infinite Scroll News Feed', 'JavaScript'),
  (80, 'User Authentication UI Flow', 'JavaScript'),
  (81, 'Jest Unit Test Suite', 'Testing'),
  (82, 'Accessibility Audit Tool', 'JavaScript'),
  (83, 'Performance Monitor Widget', 'JavaScript'),
  (84, 'Internationalised (i18n) App', 'JavaScript'),
  (85, 'JavaScript Animation Library', 'JavaScript'),
  (86, 'TypeScript To-Do App', 'JavaScript'),
  (87, 'Graph Data Visualisation', 'JavaScript'),
  (88, 'WebGL Simple Demo', 'JavaScript'),
  (89, 'Progressive Web App (PWA)', 'JavaScript'),
  (90, 'Full-Stack: React Front End', 'React'),
  (91, 'Full-Stack: Express Back End', 'Node.js'),
  (92, 'Full-Stack: Connect Front and Back', 'JavaScript'),
  (93, 'Deploy a Full-Stack App', 'JavaScript'),
  (94, 'Technical Interview Practice Problems', 'JavaScript'),
  (95, 'Code Review: Review a Peer Project', 'JavaScript'),
  (96, 'Open Project: Build Your Own Tool', 'JavaScript'),
  (97, 'Developers Capstone: Full-Stack App', 'JavaScript'),
  (98, 'Video Demo of Your Best Project', 'JavaScript'),
  (99, 'Developers Showcase Presentation', 'JavaScript'),
  (100, 'Developers Graduation: Ready for Engineers', 'JavaScript')
) AS t(n, title, category)
ON CONFLICT (slug) DO NOTHING;


-- >>>>>>>>>>>>>>>>>>>>>>>> curriculum-developers-quizzes.sql >>>>>>>>>>>>>>>>>>>>>>>>

-- =============================================================================
-- CODEship Academy — Developers Quizzes (dev-q01 to dev-q50)
-- Target: Ages 11–14 | JavaScript, Python, Web Dev
-- =============================================================================

INSERT INTO quizzes (slug, title, level, category, time_limit_seconds, passing_score, xp_reward) VALUES
('dev-q01', 'JavaScript Fundamentals Quiz',     'developers', 'JavaScript', 600, 70, 200),
('dev-q02', 'Variables and Data Types Quiz',     'developers', 'JavaScript', 600, 70, 200),
('dev-q03', 'Operators and Expressions Quiz',    'developers', 'JavaScript', 600, 70, 200),
('dev-q04', 'Conditionals Quiz',                 'developers', 'JavaScript', 600, 70, 200),
('dev-q05', 'Loops Quiz',                        'developers', 'JavaScript', 600, 70, 200),
('dev-q06', 'Functions Quiz',                    'developers', 'JavaScript', 600, 70, 200),
('dev-q07', 'Arrays Quiz',                       'developers', 'JavaScript', 600, 70, 200),
('dev-q08', 'Objects Quiz',                      'developers', 'JavaScript', 600, 70, 200),
('dev-q09', 'DOM Manipulation Quiz',             'developers', 'JavaScript', 600, 70, 200),
('dev-q10', 'Events and Listeners Quiz',         'developers', 'JavaScript', 600, 70, 200),
('dev-q11', 'String Methods Quiz',               'developers', 'JavaScript', 600, 70, 200),
('dev-q12', 'Array Methods Quiz',                'developers', 'JavaScript', 600, 70, 200),
('dev-q13', 'Math and Numbers Quiz',             'developers', 'JavaScript', 600, 70, 200),
('dev-q14', 'Error Handling Quiz',               'developers', 'JavaScript', 600, 70, 200),
('dev-q15', 'Scope and Closures Quiz',           'developers', 'JavaScript', 600, 70, 200),
('dev-q16', 'ES6+ Features Quiz',                'developers', 'JavaScript', 600, 70, 200),
('dev-q17', 'Async JavaScript Quiz',             'developers', 'JavaScript', 600, 70, 200),
('dev-q18', 'Fetch API Quiz',                    'developers', 'JavaScript', 600, 70, 200),
('dev-q19', 'Local Storage Quiz',                'developers', 'JavaScript', 600, 70, 200),
('dev-q20', 'JSON Quiz',                         'developers', 'JavaScript', 600, 70, 200),
('dev-q21', 'Python Basics Quiz',                'developers', 'Python',     600, 70, 200),
('dev-q22', 'Python Variables Quiz',             'developers', 'Python',     600, 70, 200),
('dev-q23', 'Python Lists Quiz',                 'developers', 'Python',     600, 70, 200),
('dev-q24', 'Python Dictionaries Quiz',          'developers', 'Python',     600, 70, 200),
('dev-q25', 'Python Functions Quiz',             'developers', 'Python',     600, 70, 200),
('dev-q26', 'Python Loops Quiz',                 'developers', 'Python',     600, 70, 200),
('dev-q27', 'Python Strings Quiz',               'developers', 'Python',     600, 70, 200),
('dev-q28', 'Python File I/O Quiz',              'developers', 'Python',     600, 70, 200),
('dev-q29', 'Python Classes Quiz',               'developers', 'Python',     600, 70, 200),
('dev-q30', 'Python Libraries Quiz',             'developers', 'Python',     600, 70, 200),
('dev-q31', 'Algorithms Basics Quiz',            'developers', 'CS Theory',  600, 70, 200),
('dev-q32', 'Sorting Algorithms Quiz',           'developers', 'CS Theory',  600, 70, 200),
('dev-q33', 'Data Structures Quiz',              'developers', 'CS Theory',  600, 70, 200),
('dev-q34', 'Binary and Number Systems Quiz',    'developers', 'CS Theory',  600, 70, 200),
('dev-q35', 'Web APIs Quiz',                     'developers', 'Web Dev',    600, 70, 200),
('dev-q36', 'CSS Animations Advanced Quiz',      'developers', 'CSS',        600, 70, 200),
('dev-q37', 'Git and Version Control Quiz',      'developers', 'Tools',      600, 70, 200),
('dev-q38', 'Command Line Basics Quiz',          'developers', 'Tools',      600, 70, 200),
('dev-q39', 'Debugging Techniques Quiz',         'developers', 'Tools',      600, 70, 200),
('dev-q40', 'Web Security Basics Quiz',          'developers', 'Security',   600, 70, 200),
('dev-q41', 'Database Concepts Quiz',            'developers', 'Databases',  600, 70, 200),
('dev-q42', 'SQL Basics Quiz',                   'developers', 'Databases',  600, 70, 200),
('dev-q43', 'APIs and REST Quiz',                'developers', 'Web Dev',    600, 70, 200),
('dev-q44', 'TypeScript Basics Quiz',            'developers', 'JavaScript', 600, 70, 200),
('dev-q45', 'React Basics Quiz',                 'developers', 'Frameworks', 600, 70, 200),
('dev-q46', 'Testing Basics Quiz',               'developers', 'Tools',      600, 70, 200),
('dev-q47', 'Performance Optimization Quiz',     'developers', 'Web Dev',    600, 70, 200),
('dev-q48', 'Accessibility Advanced Quiz',       'developers', 'Accessibility', 600, 70, 200),
('dev-q49', 'Developers Mid-Point Review Quiz',  'developers', 'Review',     600, 70, 200),
('dev-q50', 'Developers Final Assessment Quiz',  'developers', 'Assessment', 600, 70, 200)
ON CONFLICT (slug) DO NOTHING;

-- Q01: JavaScript Fundamentals
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q01', 'JavaScript is primarily used for:', '["Styling web pages","Structuring web pages","Making web pages interactive","Storing data in databases"]', 2, 'JavaScript adds interactivity and dynamic behaviour to web pages.', 1),
  ('dev-q01', 'How do you write a comment in JavaScript?', '["<!-- comment -->","/* comment */","// comment","# comment"]', 2, '// is for single-line comments. /* */ is for multi-line comments.', 2),
  ('dev-q01', 'Which tag links a JavaScript file in HTML?', '["<javascript>","<js>","<script>","<code>"]', 2, '<script src="file.js"></script> links an external JavaScript file.', 3),
  ('dev-q01', 'Where should you put <script> tags in HTML?', '["In <head>","In <body>","Just before </body>","In <meta>"]', 2, 'Best practice: just before </body> so HTML loads before JavaScript runs.', 4),
  ('dev-q01', 'console.log() is used to:', '["Show an alert box","Print to the browser console","Save data","Send a network request"]', 1, 'console.log() outputs values to the browser developer console.', 5),
  ('dev-q01', 'Which is NOT a JavaScript data type?', '["string","number","boolean","character"]', 3, 'JS has: string, number, boolean, null, undefined, object, symbol. Not "character".', 6),
  ('dev-q01', 'JavaScript was created by:', '["Tim Berners-Lee","Brendan Eich","Linus Torvalds","James Gosling"]', 1, 'Brendan Eich created JavaScript in 1995 in just 10 days!', 7),
  ('dev-q01', 'JavaScript runs in:', '["Only servers","Only browsers","Both browsers and servers (via Node.js)","Only mobile apps"]', 2, 'JavaScript originally ran in browsers, now also on servers via Node.js.', 8),
  ('dev-q01', 'The strict mode declaration is:', '["\"use strict\";","strict mode;","#strict","enable strict;"]', 0, '"use strict"; enables strict mode at the top of a file or function.', 9),
  ('dev-q01', 'Which statement is correct about JavaScript?', '["It is the same as Java","It is case-sensitive","It uses indentation for code blocks","It requires semicolons always"]', 1, 'JavaScript is case-sensitive: myVar and myvar are different variables.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q02: Variables
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q02', 'Which keyword declares a block-scoped variable that CAN be reassigned?', '["var","let","const","def"]', 1, 'let declares block-scoped variables that can be reassigned.', 1),
  ('dev-q02', 'Which keyword declares a variable that CANNOT be reassigned?', '["var","let","const","fixed"]', 2, 'const declares constants — the binding cannot be reassigned after declaration.', 2),
  ('dev-q02', 'What is the value of an uninitialized variable?', '["null","0","undefined","false"]', 2, 'Declared but uninitialized variables have the value undefined.', 3),
  ('dev-q02', 'typeof "hello" returns:', '["text","string","str","char"]', 1, 'typeof returns a string. typeof "hello" returns the string "string".', 4),
  ('dev-q02', 'typeof 42 returns:', '["integer","int","number","num"]', 2, 'typeof 42 returns "number". JS uses one type for all numbers.', 5),
  ('dev-q02', 'Naming convention for variables in JavaScript:', '["snake_case","PascalCase","camelCase","kebab-case"]', 2, 'camelCase is the standard JS naming convention: myVariableName.', 6),
  ('dev-q02', 'Which variable name is NOT valid in JavaScript?', '["myVar","_private","2coolForSchool","$price"]', 2, 'Variable names cannot start with a number. 2coolForSchool is invalid.', 7),
  ('dev-q02', 'What does null mean?', '["Variable not declared","Variable declared but empty","An intentional absence of value","Zero"]', 2, 'null is an intentional empty value — you deliberately set it to "nothing".', 8),
  ('dev-q02', 'Why is var considered outdated?', '["It is slower","It has function scope, not block scope, causing bugs","It cannot store strings","It is not supported anymore"]', 1, 'var has function scope — it leaks out of if/for blocks, causing tricky bugs.', 9),
  ('dev-q02', 'const with an object means:', '["The object cannot change at all","The variable cannot be reassigned, but object properties can change","The object is frozen","The object becomes immutable"]', 1, 'const prevents reassignment of the variable itself, not mutation of object contents.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q03: Operators
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q03', 'What does === do?', '["Assigns a value","Checks value equality only","Checks value AND type equality","Checks type only"]', 2, '=== (strict equality) checks that value AND type are the same.', 1),
  ('dev-q03', '"5" == 5 in JavaScript returns:', '["false (type mismatch)","true (loose equality coerces type)","Error","undefined"]', 1, '== uses type coercion: "5" is coerced to 5, so "5" == 5 is true.', 2),
  ('dev-q03', '"5" === 5 in JavaScript returns:', '["true","false","Error","undefined"]', 1, '=== requires same type: string "5" !== number 5.', 3),
  ('dev-q03', 'What does % do?', '["Division","Power","Remainder (modulo)","Percentage"]', 2, '% is the modulo operator: 10 % 3 = 1 (the remainder after division).', 4),
  ('dev-q03', 'What does ** do?', '["Multiply by 2","Exponentiation (power)","Bitwise AND","String repeat"]', 1, '** is the exponentiation operator: 2 ** 3 = 8 (2 to the power 3).', 5),
  ('dev-q03', 'x++ is:', '["Decrement x by 1","Add 1 to x and return NEW value","Return x then add 1","Multiply x by 2"]', 2, 'x++ (post-increment) returns x''s current value, then increments it.', 6),
  ('dev-q03', 'What does the && operator mean?', '["OR — true if either is true","AND — true only if both are true","NOT — inverts the value","XOR"]', 1, '&& is logical AND: both conditions must be true for the result to be true.', 7),
  ('dev-q03', 'What does ! (exclamation) do in JavaScript?', '["String concatenation","Logical NOT — inverts boolean","Factorial","Strict comparison"]', 1, '! is the logical NOT operator: !true === false, !false === true.', 8),
  ('dev-q03', 'The ternary operator syntax is:', '["if ? then : else","condition ? valueIfTrue : valueIfFalse","value if condition else other","(condition) => value"]', 1, 'Ternary: condition ? trueValue : falseValue. A compact if/else.', 9),
  ('dev-q03', 'What does += do?', '["Add then compare","Assign and increment: x += 5 means x = x + 5","Check if greater or equal","Concatenate strings only"]', 1, '+= is shorthand: x += 5 is the same as x = x + 5.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q04: Conditionals
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q04', 'Which values are "falsy" in JavaScript?', '["0, false, null, undefined, NaN, ''''","0, false, null","false and null only","Empty string only"]', 0, 'Falsy values: 0, false, null, undefined, NaN, "" (empty string). All others are truthy.', 1),
  ('dev-q04', 'What is the correct if/else syntax?', '["if condition { } else { }","if (condition) { } else { }","if [condition] { } else { }","if condition then { } else { }"]', 1, 'if (condition) { } else { } is the correct JavaScript syntax.', 2),
  ('dev-q04', 'else if allows you to:', '["Nest else blocks","Check multiple conditions in sequence","Use else without if","Combine loops and conditions"]', 1, 'else if chains multiple conditions, checked in order.', 3),
  ('dev-q04', 'A switch statement is useful when:', '["You need loops","You have many comparisons against the same variable","You need to compare two variables","You have nested conditions"]', 1, 'switch is clean when comparing one variable against many possible values.', 4),
  ('dev-q04', 'What does break do in a switch?', '["Exits the loop","Skips to next case","Exits the switch block","Causes an error"]', 2, 'break exits the switch block; without it, code "falls through" to the next case.', 5),
  ('dev-q04', 'A default case in switch:', '["Is required","Runs if no other case matches","Replaces else","Runs first"]', 1, 'default is like else — it runs when no other case matches.', 6),
  ('dev-q04', 'What does this return: 10 > 5 ? "yes" : "no"', '["yes","no","true","10"]', 0, '10 > 5 is true, so the ternary returns "yes".', 7),
  ('dev-q04', 'Short-circuit evaluation in: false && doSomething()', '["doSomething() is called","doSomething() is NOT called","Causes an error","Returns true"]', 1, 'With &&, if the left side is false, the right side is never evaluated.', 8),
  ('dev-q04', 'The nullish coalescing operator ?? returns:', '["The left side always","The right side if left is null or undefined, otherwise left","The right side always","Left side if right is truthy"]', 1, '?? returns the right side only when the left side is null or undefined.', 9),
  ('dev-q04', 'Optional chaining ?. is used to:', '["Create optional parameters","Safely access nested properties that might not exist","Check if a value is null","Compare with null"]', 1, 'user?.address?.city safely returns undefined instead of throwing an error.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q05: Loops
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q05', 'A for loop syntax is:', '["for (init; condition; update) {}","for init to end {}","loop (condition) {}","repeat (n) {}"]', 0, 'for (let i = 0; i < 10; i++) { } is the standard for loop.', 1),
  ('dev-q05', 'What does break do in a loop?', '["Pauses the loop","Skips current iteration","Exits the loop immediately","Restarts the loop"]', 2, 'break exits the entire loop immediately.', 2),
  ('dev-q05', 'What does continue do in a loop?', '["Exits the loop","Pauses for 1 second","Skips the rest of the current iteration and goes to next","Restarts the loop"]', 2, 'continue skips the rest of the current iteration and moves to the next one.', 3),
  ('dev-q05', 'A while loop runs:', '["A fixed number of times","As long as the condition is true","Once","Forever always"]', 1, 'while (condition) { } keeps looping as long as the condition is true.', 4),
  ('dev-q05', 'A do...while loop:', '["Runs at least once before checking the condition","Checks condition first","Is the same as while","Runs exactly twice"]', 0, 'do { } while (condition) runs the body ONCE before checking the condition.', 5),
  ('dev-q05', 'for...of is used to:', '["Loop over object keys","Loop over iterable values (arrays, strings)","Create a new array","Loop a fixed number of times"]', 1, 'for (const item of array) iterates over the values of an iterable.', 6),
  ('dev-q05', 'for...in is used to:', '["Loop over array values","Loop over object keys","Filter arrays","Loop over characters"]', 1, 'for (const key in object) iterates over the enumerable properties (keys) of an object.', 7),
  ('dev-q05', 'An infinite loop occurs when:', '["The loop runs 1000 times","The condition never becomes false","break is used","continue is used"]', 1, 'If the loop condition never becomes false, the loop runs forever (infinite loop).', 8),
  ('dev-q05', 'forEach() method on an array:', '["Returns a new array","Runs a function for each element, returns undefined","Filters elements","Sorts the array"]', 1, 'forEach runs a callback for each element; it doesn''t return anything.', 9),
  ('dev-q05', 'for (let i = 0; i < 5; i++) runs the loop body:', '["4 times","5 times","6 times","0 times"]', 1, 'i starts at 0, runs while i < 5 (0,1,2,3,4), so 5 iterations.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q06: Functions
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q06', 'A function declaration syntax is:', '["function name() {}","def name() {}","fn name() {}","func name() {}"]', 0, 'function name() { } is the function declaration syntax in JavaScript.', 1),
  ('dev-q06', 'Parameters are:', '["The values returned by a function","Variables listed in the function definition","The function name","The function body"]', 1, 'Parameters are the named variables in the function definition (placeholders).', 2),
  ('dev-q06', 'Arguments are:', '["Variables in function definition","The actual values passed when calling the function","The return value","The function body"]', 1, 'Arguments are the actual values you pass when calling the function.', 3),
  ('dev-q06', 'The return statement:', '["Prints a value","Exits the function and optionally sends a value back","Starts the function","Repeats the function"]', 1, 'return exits the function and sends a value back to the caller.', 4),
  ('dev-q06', 'Arrow function syntax:', '["(params) => {}","function => {}","params -> {}","=> (params) {}"]', 0, 'Arrow functions: (params) => { body } or params => expression', 5),
  ('dev-q06', 'A pure function:', '["Uses global variables","Has side effects","Given the same input, always returns the same output with no side effects","Changes the DOM"]', 2, 'Pure functions are predictable, testable, and have no side effects.', 6),
  ('dev-q06', 'Default parameters allow:', '["Multiple return values","Parameters with fallback values if not provided","Functions without parameters","Infinite parameters"]', 1, 'function greet(name = "World") { } uses "World" if name is not provided.', 7),
  ('dev-q06', 'The rest parameter (...args) collects:', '["The first argument","The last argument","All remaining arguments into an array","A fixed number of arguments"]', 2, '...args collects all remaining arguments passed after defined parameters.', 8),
  ('dev-q06', 'Function hoisting means:', '["Functions are moved to the bottom","Function declarations are moved to top of scope at runtime","Functions become available only after declaration","Functions are deleted after use"]', 1, 'Function declarations are hoisted — you can call them before they appear in code.', 9),
  ('dev-q06', 'A callback function is:', '["A function that calls itself","A function passed as an argument to another function","A function that returns a function","A named function"]', 1, 'Callbacks are functions passed as arguments to be called later (e.g., in setTimeout).', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q07: Arrays
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q07', 'Arrays in JavaScript are:', '["Fixed size","Zero-indexed (first element is index 0)","One-indexed (first element is index 1)","All the same type"]', 1, 'JavaScript arrays start at index 0: arr[0] is the first element.', 1),
  ('dev-q07', 'arr.push(item) does:', '["Removes the last item","Adds item to the beginning","Adds item to the end, returns new length","Returns the array"]', 2, 'push() adds to the END of an array and returns the new length.', 2),
  ('dev-q07', 'arr.pop() does:', '["Removes and returns the first item","Removes and returns the last item","Adds to the end","Clears the array"]', 1, 'pop() removes and returns the LAST element of an array.', 3),
  ('dev-q07', 'arr.shift() does:', '["Removes last item","Adds to start","Removes and returns first item","Sorts the array"]', 2, 'shift() removes and returns the FIRST element (opposite of pop).', 4),
  ('dev-q07', 'arr.length gives:', '["Index of last element","Number of elements in the array","The first element","The last element"]', 1, 'arr.length returns the count of elements. Last index = arr.length - 1.', 5),
  ('dev-q07', 'arr.slice(1, 3) returns:', '["Elements at index 1 and 3","Elements from index 1 to 2 (not including 3)","Elements from index 1 to 3","Elements before index 1"]', 1, 'slice(start, end) returns elements from start UP TO BUT NOT INCLUDING end.', 6),
  ('dev-q07', 'arr.splice(1, 2) does:', '["Splits into 2 arrays","Removes 2 elements starting at index 1, modifying original","Returns elements 1 and 2","Inserts at index 1"]', 1, 'splice(index, count) removes count elements at index from the original array.', 7),
  ('dev-q07', 'The spread operator [...arr] is used to:', '["Delete an array","Create a shallow copy or spread elements","Reverse an array","Sort an array"]', 1, '...arr spreads elements. [...arr] creates a shallow copy. [...a, ...b] merges arrays.', 8),
  ('dev-q07', 'Array destructuring: const [a, b] = [1, 2, 3] gives:', '["a=1, b=2","a=[1,2], b=[3]","a=1, b=[2,3]","Error"]', 0, 'Destructuring unpacks: a gets 1, b gets 2. The 3 is ignored.', 9),
  ('dev-q07', 'arr.includes(value) returns:', '["The index of value","true if value is in array, false otherwise","The count of value","A new array"]', 1, 'includes() returns a boolean: true if the value exists in the array.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q08: Objects
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q08', 'JavaScript objects store:', '["Only strings","Only numbers","Key-value pairs","Ordered lists"]', 2, 'Objects store key-value pairs: { name: "Alex", age: 10 }', 1),
  ('dev-q08', 'To access obj.name, you can also use:', '["obj(name)","obj[''name'']","obj->name","obj::name"]', 1, 'Bracket notation obj["name"] works like dot notation obj.name.', 2),
  ('dev-q08', 'Object.keys(obj) returns:', '["All values","All key-value pairs","All keys as an array","The number of keys"]', 2, 'Object.keys() returns an array of the object''s own enumerable property names.', 3),
  ('dev-q08', 'Object destructuring: const { name, age } = person gives:', '["An array of name and age","Variables name and age from person object","A copy of person","name and age as strings"]', 1, 'Destructuring extracts properties into variables: name = person.name, age = person.age.', 4),
  ('dev-q08', 'Spread syntax with objects: { ...obj1, ...obj2 } creates:', '["An array","A merged object combining both","A reference to obj1","An error if keys overlap"]', 1, 'Object spread merges properties. Later keys overwrite earlier ones if they match.', 5),
  ('dev-q08', 'The this keyword inside a method refers to:', '["The global object","The function","The object the method belongs to","The parent object"]', 2, 'Inside an object method, this refers to the object the method is called on.', 6),
  ('dev-q08', 'To add a new property to obj:', '["obj.newProp = value","obj.add(''newProp'', value)","obj[''newProp''].create()","obj.create(''newProp'', value)"]', 0, 'Simply assign: obj.newProp = value or obj["newProp"] = value.', 7),
  ('dev-q08', 'delete obj.property:', '["Hides the property","Removes the property from the object","Sets it to null","Sets it to undefined"]', 1, 'delete removes the property entirely from the object.', 8),
  ('dev-q08', '"key" in obj returns:', '["The value of key","true if key exists in obj","The index of key","An error if key does not exist"]', 1, 'The in operator returns true if the property exists in the object (or prototype chain).', 9),
  ('dev-q08', 'Object.freeze(obj) means:', '["The object is deleted","No new properties can be added and existing ones cannot change","The object becomes null","Properties become undefined"]', 1, 'Object.freeze() prevents any changes to the object — adding, removing, or modifying.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q09: DOM
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q09', 'DOM stands for:', '["Document Object Model","Document Orientation Management","Dynamic Object Model","Data Object Mapping"]', 0, 'DOM = Document Object Model — the tree representation of an HTML page in JavaScript.', 1),
  ('dev-q09', 'document.getElementById("id") returns:', '["All elements with that id","The first element with that id","An array of elements","null always"]', 1, 'getElementById returns the single element matching that id (or null if not found).', 2),
  ('dev-q09', 'document.querySelector(".card") returns:', '["All elements with class card","The first element matching the selector","An array","All elements"]', 1, 'querySelector returns the FIRST element matching the CSS selector.', 3),
  ('dev-q09', 'document.querySelectorAll("p") returns:', '["The first paragraph","A NodeList of all matching elements","An array","The last paragraph"]', 1, 'querySelectorAll returns a NodeList of ALL matching elements.', 4),
  ('dev-q09', 'To change text content of an element:', '["el.text = ''new''","el.innerHTML = ''new''","el.textContent = ''new''","el.change(''new'')"]', 2, 'textContent sets text safely (no HTML parsing). innerHTML parses HTML.', 5),
  ('dev-q09', 'Why use textContent instead of innerHTML for user input?', '["textContent is faster","innerHTML can execute malicious scripts (XSS risk)","textContent supports HTML tags","There is no difference"]', 1, 'innerHTML treats content as HTML, risking XSS attacks with user-supplied data.', 6),
  ('dev-q09', 'el.classList.add("active") does:', '["Removes all classes","Adds active class to element","Checks if class exists","Removes active class"]', 1, 'classList.add() adds a CSS class to the element without removing existing classes.', 7),
  ('dev-q09', 'el.classList.toggle("open") does:', '["Always adds open","Always removes open","Adds open if absent, removes if present","Checks if open exists"]', 2, 'toggle() adds the class if it''s not there, removes it if it is.', 8),
  ('dev-q09', 'To create a new element:', '["new Element(''div'')","document.createElement(''div'')","document.new(''div'')","createElement(''div'')"]', 1, 'document.createElement(tagName) creates a new DOM element.', 9),
  ('dev-q09', 'el.appendChild(child) does:', '["Removes child from el","Inserts child as the first child of el","Appends child as the last child of el","Replaces el with child"]', 2, 'appendChild adds the new element as the last child of the parent.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q10: Events
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q10', 'addEventListener() is used to:', '["Create HTML elements","Listen for and respond to events","Remove event listeners","Create CSS animations"]', 1, 'addEventListener(event, callback) attaches an event handler to an element.', 1),
  ('dev-q10', 'The first argument to addEventListener is:', '["The callback function","The event type (e.g., ''click'')","The element","The event object"]', 1, 'First arg is the event type as a string: "click", "submit", "keydown", etc.', 2),
  ('dev-q10', 'event.preventDefault() is used to:', '["Stop event bubbling","Prevent the default browser behaviour (like form submission)","Remove the event listener","Stop all events"]', 1, 'e.preventDefault() stops the browser''s default action, like form submission or link navigation.', 3),
  ('dev-q10', 'Event bubbling means:', '["Events go from child to parent up the DOM","Events go from parent to child","Events are cancelled","Events repeat"]', 0, 'When an event fires, it bubbles up through parent elements unless stopped.', 4),
  ('dev-q10', 'event.stopPropagation() does:', '["Prevents default browser action","Stops event from bubbling to parent elements","Removes the listener","Logs the event"]', 1, 'stopPropagation() stops the event from bubbling up to parent elements.', 5),
  ('dev-q10', 'Which event fires when a form is submitted?', '["click","submit","change","input"]', 1, 'The "submit" event fires when a form is submitted.', 6),
  ('dev-q10', 'Which event fires when a key is pressed down?', '["keypress","keyup","keydown","keystroke"]', 2, '"keydown" fires as soon as a key is pressed down.', 7),
  ('dev-q10', 'The event.target property refers to:', '["The element the listener is on","The element that actually triggered the event","The parent element","The document"]', 1, 'event.target is the element that was actually interacted with (may be a child).', 8),
  ('dev-q10', 'DOMContentLoaded event fires when:', '["The page fully loads including images","The HTML is parsed and DOM is ready","JavaScript executes","CSS is loaded"]', 1, 'DOMContentLoaded fires when HTML is parsed, without waiting for images/styles.', 9),
  ('dev-q10', 'Event delegation means:', '["Each element gets its own listener","Adding a listener to a parent to handle events from children","Removing all event listeners","Preventing event bubbling"]', 1, 'Event delegation uses bubbling: add one listener to parent instead of many to children.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Bulk insert for remaining quizzes (Q11-Q50) with placeholder questions
-- Each gets 10 structured questions
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id,
  'Question ' || s::text || ' for ' || q.title,
  '["Option A (correct)","Option B","Option C","Option D"]',
  0,
  'This question tests your knowledge of ' || q.category || '. Study the ' || q.category || ' lessons to master this topic.',
  10,
  s
FROM quizzes q
CROSS JOIN generate_series(1, 10) s
WHERE q.slug IN (
  'dev-q11','dev-q12','dev-q13','dev-q14','dev-q15','dev-q16','dev-q17','dev-q18','dev-q19','dev-q20',
  'dev-q21','dev-q22','dev-q23','dev-q24','dev-q25','dev-q26','dev-q27','dev-q28','dev-q29','dev-q30',
  'dev-q31','dev-q32','dev-q33','dev-q34','dev-q35','dev-q36','dev-q37','dev-q38','dev-q39','dev-q40',
  'dev-q41','dev-q42','dev-q43','dev-q44','dev-q45','dev-q46','dev-q47','dev-q48','dev-q49','dev-q50'
)
ON CONFLICT DO NOTHING;

