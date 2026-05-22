-- =============================================================================
-- CODEship Academy — Main Schema
-- PostgreSQL / Supabase compatible
-- Run this file first before any other SQL files.
-- =============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- ENUMS
-- =============================================================================

CREATE TYPE user_role AS ENUM ('parent', 'teacher', 'student', 'admin');

CREATE TYPE lesson_status AS ENUM (
  'not_started',
  'in_progress',
  'completed',
  'needs_review'
);

CREATE TYPE subscription_plan AS ENUM (
  'trial',
  'monthly',
  'annual',
  'family',
  'teacher',
  'school_monthly',
  'school_annual'
);

CREATE TYPE subscription_status AS ENUM (
  'active',
  'cancelled',
  'past_due',
  'trial',
  'expired'
);

CREATE TYPE visibility_type AS ENUM (
  'public',
  'class_only',
  'private'
);

CREATE TYPE consent_type AS ENUM (
  'weekly_digest',
  'product_updates',
  'promotions',
  'school_newsletter'
);

CREATE TYPE consent_method AS ENUM (
  'signup_form',
  'settings_update'
);

CREATE TYPE withdraw_method AS ENUM (
  'unsubscribe_link',
  'settings',
  'admin_request'
);

-- =============================================================================
-- TABLES
-- =============================================================================

-- users
-- Mirrors auth.users; auto-populated by handle_new_auth_user trigger.
CREATE TABLE IF NOT EXISTS public.users (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  email            text UNIQUE NOT NULL,
  full_name        text,
  role             user_role NOT NULL DEFAULT 'parent',
  locale           text NOT NULL DEFAULT 'en',
  avatar_url       text,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  deleted_at       timestamptz
);

-- parent_profiles
CREATE TABLE IF NOT EXISTS public.parent_profiles (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  notification_prefs  jsonb,
  timezone            text,
  phone               text,
  created_at          timestamptz NOT NULL DEFAULT now()
);

-- teacher_profiles
CREATE TABLE IF NOT EXISTS public.teacher_profiles (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id          uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  school_name      text,
  classroom_name   text,
  grade_range      text,
  certification    text,
  created_at       timestamptz NOT NULL DEFAULT now()
);

-- student_profiles
-- Children created and managed by a parent (or teacher for school accounts).
CREATE TABLE IF NOT EXISTS public.student_profiles (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  parent_id        uuid REFERENCES public.users(id) ON DELETE SET NULL,
  teacher_id       uuid REFERENCES public.users(id) ON DELETE SET NULL,
  full_name        text NOT NULL,
  age              int,
  grade            text,
  level            text NOT NULL DEFAULT 'explorers',
  xp_points        int NOT NULL DEFAULT 0,
  streak_days      int NOT NULL DEFAULT 0,
  xp_multiplier    numeric NOT NULL DEFAULT 1.0,
  visibility       visibility_type NOT NULL DEFAULT 'public',
  avatar_emoji     text,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

-- assessments
-- Placement assessments completed before a student profile is created.
CREATE TABLE IF NOT EXISTS public.assessments (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  parent_id           uuid REFERENCES public.users(id) ON DELETE SET NULL,
  student_name        text,
  age                 int,
  grade               text,
  experience          text,
  skills              jsonb,
  recommended_level   text,
  saved_at            timestamptz,
  created_at          timestamptz NOT NULL DEFAULT now()
);

-- learning_plans
-- AI-generated weekly learning plans for each student.
CREATE TABLE IF NOT EXISTS public.learning_plans (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id  uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  parent_id   uuid REFERENCES public.users(id) ON DELETE SET NULL,
  plan        jsonb,
  week_start  date,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- lessons
-- Core curriculum lesson records. Content (MDX etc.) lives in the codebase.
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
  is_visible        bool NOT NULL DEFAULT true,
  sort_order        int,
  created_at        timestamptz NOT NULL DEFAULT now()
);

-- projects
-- Coding projects students can work on and submit.
CREATE TABLE IF NOT EXISTS public.projects (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug          text UNIQUE NOT NULL,
  title         text NOT NULL,
  level         text,
  category      text,
  starter_code  text,
  instructions  text,
  tags          text[],
  xp_reward     int NOT NULL DEFAULT 200,
  is_visible    bool NOT NULL DEFAULT true,
  sort_order    int,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- quizzes
CREATE TABLE IF NOT EXISTS public.quizzes (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug                text UNIQUE NOT NULL,
  title               text NOT NULL,
  level               text,
  category            text,
  time_limit_seconds  int NOT NULL DEFAULT 600,
  passing_score       int NOT NULL DEFAULT 70,
  xp_reward           int NOT NULL DEFAULT 150,
  is_visible          bool NOT NULL DEFAULT true,
  created_at          timestamptz NOT NULL DEFAULT now()
);

-- quiz_questions
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

-- lesson_progress
-- One row per student per lesson; upserted as a student progresses.
CREATE TABLE IF NOT EXISTS public.lesson_progress (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id       uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  lesson_id        uuid NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  status           lesson_status NOT NULL DEFAULT 'not_started',
  score            int,
  hearts_remaining int NOT NULL DEFAULT 5,
  completed_at     timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, lesson_id)
);

-- quiz_attempts
-- Each attempt at a quiz is stored independently (students may retry).
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id           uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id   uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  quiz_id      uuid NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  score        int,
  answers      jsonb,
  passed       bool,
  completed_at timestamptz,
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- project_submissions
CREATE TABLE IF NOT EXISTS public.project_submissions (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id    uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  project_id    uuid NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  code_snapshot text,
  notes         text,
  status        text NOT NULL DEFAULT 'submitted',
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

-- achievements
-- Achievement definitions; instances awarded to students go in student_achievements.
CREATE TABLE IF NOT EXISTS public.achievements (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug            text UNIQUE NOT NULL,
  name            text NOT NULL,
  description     text,
  icon_emoji      text,
  xp_reward       int NOT NULL DEFAULT 0,
  condition_type  text,
  is_active       bool NOT NULL DEFAULT true
);

-- student_achievements
CREATE TABLE IF NOT EXISTS public.student_achievements (
  id             uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id     uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  achievement_id uuid NOT NULL REFERENCES public.achievements(id) ON DELETE CASCADE,
  awarded_at     timestamptz NOT NULL DEFAULT now(),
  UNIQUE (student_id, achievement_id)
);

-- topic_mastery
-- Rolling mastery score per topic per student; updated after each quiz/lesson.
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

-- notifications
CREATE TABLE IF NOT EXISTS public.notifications (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  type       text NOT NULL,
  title      text NOT NULL,
  message    text,
  read       bool NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- subscriptions
-- One row per user; managed by Stripe webhook handlers.
CREATE TABLE IF NOT EXISTS public.subscriptions (
  id                     uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  stripe_customer_id     text,
  stripe_subscription_id text,
  plan                   subscription_plan NOT NULL DEFAULT 'trial',
  status                 subscription_status NOT NULL DEFAULT 'trial',
  trial_ends_at          timestamptz,
  current_period_end     timestamptz,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now()
);

-- email_consents
-- GDPR/CASL-compliant email marketing consent records.
-- One row per user per consent type; withdrawn_at/withdrawn_method set on opt-out.
CREATE TABLE IF NOT EXISTS public.email_consents (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  consent_type      consent_type NOT NULL,
  consent_given_at  timestamptz NOT NULL DEFAULT now(),
  consent_method    consent_method NOT NULL,
  ip_address        text,
  withdrawn_at      timestamptz,
  withdrawn_method  withdraw_method,
  UNIQUE (user_id, consent_type)
);

-- parental_consents
-- COPPA/PIPEDA parental consent records; one row per child account created.
CREATE TABLE IF NOT EXISTS public.parental_consents (
  id                           uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  parent_user_id               uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  student_name                 text NOT NULL,
  student_age                  int NOT NULL,
  consent_given_at             timestamptz NOT NULL DEFAULT now(),
  consent_method               text NOT NULL DEFAULT 'checkbox_with_policy_link',
  ip_address                   text,
  user_agent                   text,
  privacy_policy_version       text,
  data_retention_acknowledged  bool NOT NULL DEFAULT false,
  ai_processing_acknowledged   bool NOT NULL DEFAULT false,
  marketing_opt_in             bool NOT NULL DEFAULT false
);

-- audit_logs
-- Immutable event log; written by service role only.
CREATE TABLE IF NOT EXISTS public.audit_logs (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     uuid REFERENCES public.users(id) ON DELETE SET NULL,
  action      text NOT NULL,
  target_id   text,
  target_type text,
  metadata    jsonb,
  ip_address  text,
  user_agent  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_users_email              ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role               ON public.users(role);
CREATE INDEX IF NOT EXISTS idx_parent_profiles_user     ON public.parent_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_profiles_user    ON public.teacher_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_parent  ON public.student_profiles(parent_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_teacher ON public.student_profiles(teacher_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_student  ON public.lesson_progress(student_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_lesson   ON public.lesson_progress(lesson_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_status   ON public.lesson_progress(student_id, status);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_student    ON public.quiz_attempts(student_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_quiz       ON public.quiz_attempts(quiz_id);
CREATE INDEX IF NOT EXISTS idx_project_submissions_student ON public.project_submissions(student_id);
CREATE INDEX IF NOT EXISTS idx_project_submissions_project ON public.project_submissions(project_id);
CREATE INDEX IF NOT EXISTS idx_student_achievements_student ON public.student_achievements(student_id);
CREATE INDEX IF NOT EXISTS idx_topic_mastery_student    ON public.topic_mastery(student_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user       ON public.notifications(user_id, read);
CREATE INDEX IF NOT EXISTS idx_subscriptions_user       ON public.subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_stripe_cust ON public.subscriptions(stripe_customer_id);
CREATE INDEX IF NOT EXISTS idx_email_consents_user      ON public.email_consents(user_id);
CREATE INDEX IF NOT EXISTS idx_parental_consents_parent ON public.parental_consents(parent_user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user          ON public.audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created       ON public.audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action        ON public.audit_logs(action);

-- =============================================================================
-- UPDATED_AT TRIGGER FUNCTION
-- =============================================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_student_profiles_updated_at
  BEFORE UPDATE ON public.student_profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_lesson_progress_updated_at
  BEFORE UPDATE ON public.lesson_progress
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_project_submissions_updated_at
  BEFORE UPDATE ON public.project_submissions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_subscriptions_updated_at
  BEFORE UPDATE ON public.subscriptions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- =============================================================================
-- AUTH TRIGGER: auto-create public.users on sign-up
-- =============================================================================

CREATE OR REPLACE FUNCTION public.handle_new_auth_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE((NEW.raw_user_meta_data->>'role')::user_role, 'parent')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

-- Fires on Supabase's internal auth.users table after every new sign-up.
CREATE OR REPLACE TRIGGER trg_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_auth_user();

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE public.users               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_profiles     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teacher_profiles    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_profiles    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assessments         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_plans      ENABLE ROW LEVEL SECURITY;
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
ALTER TABLE public.notifications       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_consents      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parental_consents   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs          ENABLE ROW LEVEL SECURITY;

-- ---- users ----
CREATE POLICY "users: read own record"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "users: update own record"
  ON public.users FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "users: admin full access"
  ON public.users FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- parent_profiles ----
CREATE POLICY "parent_profiles: own record"
  ON public.parent_profiles FOR ALL
  USING (user_id = auth.uid());

-- ---- teacher_profiles ----
CREATE POLICY "teacher_profiles: own record"
  ON public.teacher_profiles FOR ALL
  USING (user_id = auth.uid());

-- ---- student_profiles ----
-- Parents manage their own children's profiles.
CREATE POLICY "student_profiles: parent manages children"
  ON public.student_profiles FOR ALL
  USING (parent_id = auth.uid());

-- Teachers see students in their classes.
-- Depends on class_memberships table defined in classes.sql.
-- Policy created in classes.sql after that table exists.

-- Admins have unrestricted access.
CREATE POLICY "student_profiles: admin full access"
  ON public.student_profiles FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- assessments ----
CREATE POLICY "assessments: parent owns"
  ON public.assessments FOR ALL
  USING (parent_id = auth.uid());

-- ---- learning_plans ----
CREATE POLICY "learning_plans: parent owns"
  ON public.learning_plans FOR ALL
  USING (parent_id = auth.uid());

-- ---- lessons (public read for authenticated users) ----
CREATE POLICY "lessons: visible to authenticated"
  ON public.lessons FOR SELECT
  USING (is_visible = true AND auth.uid() IS NOT NULL);

CREATE POLICY "lessons: admin manages"
  ON public.lessons FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- projects ----
CREATE POLICY "projects: visible to authenticated"
  ON public.projects FOR SELECT
  USING (is_visible = true AND auth.uid() IS NOT NULL);

CREATE POLICY "projects: admin manages"
  ON public.projects FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- quizzes ----
CREATE POLICY "quizzes: visible to authenticated"
  ON public.quizzes FOR SELECT
  USING (is_visible = true AND auth.uid() IS NOT NULL);

CREATE POLICY "quizzes: admin manages"
  ON public.quizzes FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- quiz_questions ----
CREATE POLICY "quiz_questions: readable by authenticated"
  ON public.quiz_questions FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "quiz_questions: admin manages"
  ON public.quiz_questions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- lesson_progress ----
-- Parents access their children's progress data.
CREATE POLICY "lesson_progress: parent sees children"
  ON public.lesson_progress FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles sp
      WHERE sp.id = student_id AND sp.parent_id = auth.uid()
    )
  );

-- Teachers see progress for students in their classes.
-- Depends on class_memberships; policy created in classes.sql.

CREATE POLICY "lesson_progress: admin full"
  ON public.lesson_progress FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- quiz_attempts ----
CREATE POLICY "quiz_attempts: parent sees children"
  ON public.quiz_attempts FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles sp
      WHERE sp.id = student_id AND sp.parent_id = auth.uid()
    )
  );

CREATE POLICY "quiz_attempts: admin full"
  ON public.quiz_attempts FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- project_submissions ----
CREATE POLICY "project_submissions: parent sees children"
  ON public.project_submissions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles sp
      WHERE sp.id = student_id AND sp.parent_id = auth.uid()
    )
  );

CREATE POLICY "project_submissions: admin full"
  ON public.project_submissions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- achievements ----
CREATE POLICY "achievements: read all active"
  ON public.achievements FOR SELECT
  USING (is_active = true);

CREATE POLICY "achievements: admin manages"
  ON public.achievements FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- student_achievements ----
CREATE POLICY "student_achievements: parent sees children"
  ON public.student_achievements FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles sp
      WHERE sp.id = student_id AND sp.parent_id = auth.uid()
    )
  );

CREATE POLICY "student_achievements: admin manages"
  ON public.student_achievements FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- topic_mastery ----
CREATE POLICY "topic_mastery: parent sees children"
  ON public.topic_mastery FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles sp
      WHERE sp.id = student_id AND sp.parent_id = auth.uid()
    )
  );

CREATE POLICY "topic_mastery: admin full"
  ON public.topic_mastery FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- notifications ----
CREATE POLICY "notifications: own"
  ON public.notifications FOR ALL
  USING (user_id = auth.uid());

-- ---- subscriptions ----
CREATE POLICY "subscriptions: own"
  ON public.subscriptions FOR ALL
  USING (user_id = auth.uid());

CREATE POLICY "subscriptions: admin full"
  ON public.subscriptions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- email_consents ----
CREATE POLICY "email_consents: own"
  ON public.email_consents FOR ALL
  USING (user_id = auth.uid());

-- ---- parental_consents ----
CREATE POLICY "parental_consents: own"
  ON public.parental_consents FOR ALL
  USING (parent_user_id = auth.uid());

-- ---- audit_logs ----
-- Only admins may read audit logs.
CREATE POLICY "audit_logs: admin read"
  ON public.audit_logs FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- Service role (backend / edge functions) can always insert audit events.
CREATE POLICY "audit_logs: service insert"
  ON public.audit_logs FOR INSERT
  WITH CHECK (true);

-- =============================================================================
-- ACHIEVEMENT SEEDS (15 achievements)
-- =============================================================================

INSERT INTO public.achievements (slug, name, description, icon_emoji, xp_reward, condition_type, is_active)
VALUES
  ('first_lesson',              'First Lesson!',           'Completed your very first lesson',                        '🎓', 50,   'lesson_complete',        true),
  ('first_quiz',                'Quiz Starter',            'Completed your first quiz',                               '📝', 50,   'quiz_complete',          true),
  ('first_project',             'Builder Begins',          'Submitted your first project',                            '🔨', 50,   'project_submit',         true),
  ('streak_7',                  '7-Day Streak',            'Learned every day for 7 days in a row',                   '🔥', 100,  'streak_days',            true),
  ('streak_14',                 '14-Day Streak',           'Kept the momentum going for 14 days straight',            '⚡', 200,  'streak_days',            true),
  ('streak_30',                 '30-Day Streak',           'An unstoppable 30-day learning streak',                   '🏆', 500,  'streak_days',            true),
  ('level_complete_explorers',  'Explorer Graduate',       'Completed the Explorers level',                           '🚀', 300,  'level_complete',         true),
  ('level_complete_builders',   'Builder Graduate',        'Completed the Builders level',                            '🏗️', 400,  'level_complete',         true),
  ('level_complete_developers', 'Developer Graduate',      'Completed the Developers level',                          '💻', 500,  'level_complete',         true),
  ('level_complete_engineers',  'Engineer Graduate',       'Completed the Engineers level',                           '⚙️', 750,  'level_complete',         true),
  ('quiz_perfect',              'Perfect Score',           'Got 100% on any quiz',                                    '⭐', 150,  'quiz_perfect_score',     true),
  ('xp_1000',                   'XP Milestone: 1,000',    'Earned 1,000 total XP points',                            '💎', 100,  'total_xp',               true),
  ('xp_5000',                   'XP Milestone: 5,000',    'Earned 5,000 total XP points',                            '👑', 500,  'total_xp',               true),
  ('share_project',             'Show and Tell',           'Shared a project with others',                            '📢', 75,   'project_share',          true),
  ('night_owl',                 'Night Owl',               'Completed a lesson after 9 PM',                           '🦉', 50,   'time_of_day',            true)
ON CONFLICT (slug) DO NOTHING;
