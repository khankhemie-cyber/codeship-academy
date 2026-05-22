-- =============================================================================
-- CODEship Academy — School Portal
-- Run after schema.sql.
-- Tables: schools, school_sessions, session_attendance, certificates,
--         share_tokens
-- =============================================================================

-- =============================================================================
-- TABLES
-- =============================================================================

-- schools
-- Represents an educational institution with a CODEship license.
CREATE TABLE IF NOT EXISTS public.schools (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name            text NOT NULL,
  board           text,
  address         text,
  contact_name    text,
  contact_email   text,
  contact_phone   text,
  license_type    text,
  license_count   int NOT NULL DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- school_sessions
-- Individual workshop or class sessions run at a school.
CREATE TABLE IF NOT EXISTS public.school_sessions (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  school_id        uuid NOT NULL REFERENCES public.schools(id) ON DELETE CASCADE,
  date             date NOT NULL,
  start_time       time,
  duration_minutes int NOT NULL DEFAULT 90,
  topic            text,
  instructor       text,
  student_count    int,
  status           text NOT NULL DEFAULT 'scheduled',
  notes            text,
  created_at       timestamptz NOT NULL DEFAULT now()
);

-- session_attendance
-- Per-student attendance and engagement record for a school session.
CREATE TABLE IF NOT EXISTS public.session_attendance (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id       uuid NOT NULL REFERENCES public.school_sessions(id) ON DELETE CASCADE,
  student_name     text NOT NULL,
  grade            text,
  engagement_score int,
  notes            text
);

-- certificates
-- Completion certificates issued when a student finishes a level.
-- share_token allows public access to a rendered PDF without auth.
CREATE TABLE IF NOT EXISTS public.certificates (
  id           uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id   uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  level        text NOT NULL,
  pdf_url      text,
  share_token  text UNIQUE NOT NULL DEFAULT encode(gen_random_bytes(16), 'hex'),
  issued_at    timestamptz NOT NULL DEFAULT now()
);

-- share_tokens
-- Generic short-lived tokens for sharing any content publicly.
-- type: 'certificate' | 'project' | 'invite' etc.
CREATE TABLE IF NOT EXISTS public.share_tokens (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  token       text UNIQUE NOT NULL DEFAULT encode(gen_random_bytes(16), 'hex'),
  type        text NOT NULL,
  target_id   uuid NOT NULL,
  created_by  uuid REFERENCES public.users(id) ON DELETE SET NULL,
  expires_at  timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_schools_name              ON public.schools(name);
CREATE INDEX IF NOT EXISTS idx_school_sessions_school    ON public.school_sessions(school_id);
CREATE INDEX IF NOT EXISTS idx_school_sessions_date      ON public.school_sessions(date);
CREATE INDEX IF NOT EXISTS idx_school_sessions_status    ON public.school_sessions(status);
CREATE INDEX IF NOT EXISTS idx_session_attendance_session ON public.session_attendance(session_id);
CREATE INDEX IF NOT EXISTS idx_certificates_student      ON public.certificates(student_id);
CREATE INDEX IF NOT EXISTS idx_certificates_share_token  ON public.certificates(share_token);
CREATE INDEX IF NOT EXISTS idx_share_tokens_token        ON public.share_tokens(token);
CREATE INDEX IF NOT EXISTS idx_share_tokens_type_target  ON public.share_tokens(type, target_id);
CREATE INDEX IF NOT EXISTS idx_share_tokens_expires      ON public.share_tokens(expires_at);

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE public.schools             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.school_sessions     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_attendance  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.certificates        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.share_tokens        ENABLE ROW LEVEL SECURITY;

-- ---- schools ----
-- Only admins can manage school records.
CREATE POLICY "schools: admin full access"
  ON public.schools FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- Teachers can view schools (for their profile reference).
CREATE POLICY "schools: teacher read"
  ON public.schools FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role IN ('teacher', 'admin')
    )
  );

-- ---- school_sessions ----
CREATE POLICY "school_sessions: admin full access"
  ON public.school_sessions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

CREATE POLICY "school_sessions: teacher read"
  ON public.school_sessions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role IN ('teacher', 'admin')
    )
  );

-- ---- session_attendance ----
CREATE POLICY "session_attendance: admin full access"
  ON public.session_attendance FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

CREATE POLICY "session_attendance: teacher read"
  ON public.session_attendance FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role IN ('teacher', 'admin')
    )
  );

-- ---- certificates ----
-- Parents can view certificates for their children.
CREATE POLICY "certificates: parent sees children"
  ON public.certificates FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles sp
      WHERE sp.id = student_id AND sp.parent_id = auth.uid()
    )
  );

-- Public read via share_token is handled by a separate anon policy.
-- (Edge function / API route validates token and fetches record directly
-- using service role; no anon RLS policy required for security.)

CREATE POLICY "certificates: admin full access"
  ON public.certificates FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- share_tokens ----
-- Creators can manage their own tokens.
CREATE POLICY "share_tokens: creator manages"
  ON public.share_tokens FOR ALL
  USING (created_by = auth.uid());

CREATE POLICY "share_tokens: admin full access"
  ON public.share_tokens FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- Authenticated users can read any non-expired token (needed to validate
-- share links without hitting service role from the client).
CREATE POLICY "share_tokens: authenticated read non-expired"
  ON public.share_tokens FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND (expires_at IS NULL OR expires_at > now())
  );

-- =============================================================================
-- HELPER FUNCTION: resolve_share_token
-- Given a raw token string, returns the target type and target_id,
-- or NULL if expired / not found.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.resolve_share_token(p_token text)
RETURNS TABLE (token_type text, target_id uuid)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT st.type, st.target_id
  FROM   public.share_tokens st
  WHERE  st.token = p_token
    AND  (st.expires_at IS NULL OR st.expires_at > now());
END;
$$;
