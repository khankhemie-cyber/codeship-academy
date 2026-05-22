-- =============================================================================
-- CODEship Academy — Classes
-- Run after schema.sql.
-- Tables: classes, class_memberships, class_invites
-- Also adds teacher-scoped RLS policies on student_profiles and
-- lesson_progress that depend on class_memberships existing.
-- =============================================================================

-- =============================================================================
-- TABLES
-- =============================================================================

-- classes
-- A teacher's virtual classroom; students join via code or invite link.
CREATE TABLE IF NOT EXISTS public.classes (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name       text NOT NULL,
  code       char(6) UNIQUE NOT NULL,
  grade      text,
  is_active  bool NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- class_memberships
-- Association between a class and a student profile.
CREATE TABLE IF NOT EXISTS public.class_memberships (
  id         uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id   uuid NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
  student_id uuid NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  joined_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (class_id, student_id)
);

-- class_invites
-- Token-based invite links that parents use to add a student to a class.
CREATE TABLE IF NOT EXISTS public.class_invites (
  id        uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id  uuid NOT NULL REFERENCES public.classes(id) ON DELETE CASCADE,
  token     text UNIQUE NOT NULL DEFAULT encode(gen_random_bytes(12), 'hex'),
  max_uses  int NOT NULL DEFAULT 30,
  use_count int NOT NULL DEFAULT 0,
  expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_classes_teacher      ON public.classes(teacher_id);
CREATE INDEX IF NOT EXISTS idx_classes_code         ON public.classes(code);
CREATE INDEX IF NOT EXISTS idx_classes_active       ON public.classes(teacher_id, is_active);
CREATE INDEX IF NOT EXISTS idx_class_memberships_class   ON public.class_memberships(class_id);
CREATE INDEX IF NOT EXISTS idx_class_memberships_student ON public.class_memberships(student_id);
CREATE INDEX IF NOT EXISTS idx_class_invites_class  ON public.class_invites(class_id);
CREATE INDEX IF NOT EXISTS idx_class_invites_token  ON public.class_invites(token);

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE public.classes           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_invites     ENABLE ROW LEVEL SECURITY;

-- ---- classes ----
-- Teachers manage their own classes.
CREATE POLICY "classes: teacher manages own"
  ON public.classes FOR ALL
  USING (teacher_id = auth.uid());

-- Parents can view classes that contain their children.
CREATE POLICY "classes: parent sees children's classes"
  ON public.classes FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM   public.class_memberships cm
      JOIN   public.student_profiles  sp ON sp.id = cm.student_id
      WHERE  cm.class_id = classes.id
        AND  sp.parent_id = auth.uid()
    )
  );

CREATE POLICY "classes: admin full access"
  ON public.classes FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- class_memberships ----
-- Teachers see memberships for their own classes.
CREATE POLICY "class_memberships: teacher sees own class"
  ON public.class_memberships FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.classes c
      WHERE c.id = class_id AND c.teacher_id = auth.uid()
    )
  );

-- Parents see memberships that include their children.
CREATE POLICY "class_memberships: parent sees children"
  ON public.class_memberships FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.student_profiles sp
      WHERE sp.id = student_id AND sp.parent_id = auth.uid()
    )
  );

CREATE POLICY "class_memberships: admin full access"
  ON public.class_memberships FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- ---- class_invites ----
-- Only the owning teacher can manage invite tokens.
CREATE POLICY "class_invites: teacher manages own"
  ON public.class_invites FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.classes c
      WHERE c.id = class_id AND c.teacher_id = auth.uid()
    )
  );

-- Authenticated users (parents) can read a valid, non-expired token
-- to verify it before calling join_class_by_token.
CREATE POLICY "class_invites: authenticated read valid"
  ON public.class_invites FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND use_count < max_uses
    AND (expires_at IS NULL OR expires_at > now())
  );

CREATE POLICY "class_invites: admin full access"
  ON public.class_invites FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.users u
      WHERE u.id = auth.uid() AND u.role = 'admin'
    )
  );

-- =============================================================================
-- CROSS-TABLE RLS: teacher access to student_profiles and lesson_progress
-- These policies depend on class_memberships and are therefore defined here
-- rather than in schema.sql.
-- =============================================================================

-- Teachers can view (but not modify) student profiles for students in their classes.
CREATE POLICY "student_profiles: teacher sees class students"
  ON public.student_profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM   public.class_memberships cm
      JOIN   public.classes c ON c.id = cm.class_id
      WHERE  cm.student_id  = student_profiles.id
        AND  c.teacher_id   = auth.uid()
        AND  c.is_active    = true
    )
  );

-- Teachers can view lesson progress for students in their active classes.
CREATE POLICY "lesson_progress: teacher sees class students"
  ON public.lesson_progress FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM   public.class_memberships cm
      JOIN   public.classes c ON c.id = cm.class_id
      WHERE  cm.student_id = lesson_progress.student_id
        AND  c.teacher_id  = auth.uid()
        AND  c.is_active   = true
    )
  );

-- =============================================================================
-- FUNCTION: join_class_by_code
-- Adds a student to a class identified by its 6-character join code.
-- Raises an exception if the code is invalid or the class is inactive.
-- Returns the class_memberships row id on success.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.join_class_by_code(
  p_code       text,
  p_student_id uuid
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_class_id uuid;
  v_member_id uuid;
BEGIN
  -- Resolve the class.
  SELECT id INTO v_class_id
  FROM   public.classes
  WHERE  code      = upper(p_code)
    AND  is_active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Class code % is invalid or inactive', p_code;
  END IF;

  -- Insert or silently skip if already a member.
  INSERT INTO public.class_memberships (class_id, student_id)
  VALUES (v_class_id, p_student_id)
  ON CONFLICT (class_id, student_id) DO NOTHING
  RETURNING id INTO v_member_id;

  -- If already a member, fetch the existing row id.
  IF v_member_id IS NULL THEN
    SELECT id INTO v_member_id
    FROM   public.class_memberships
    WHERE  class_id   = v_class_id
      AND  student_id = p_student_id;
  END IF;

  RETURN v_member_id;
END;
$$;

-- =============================================================================
-- FUNCTION: join_class_by_token
-- Adds a student to a class using an invite link token.
-- Validates token expiry and usage limits, then increments use_count.
-- Returns the class_memberships row id on success.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.join_class_by_token(
  p_token      text,
  p_student_id uuid
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_invite   public.class_invites%ROWTYPE;
  v_class    public.classes%ROWTYPE;
  v_member_id uuid;
BEGIN
  -- Validate token.
  SELECT * INTO v_invite
  FROM   public.class_invites
  WHERE  token = p_token;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invite token % not found', p_token;
  END IF;

  IF v_invite.expires_at IS NOT NULL AND v_invite.expires_at <= now() THEN
    RAISE EXCEPTION 'Invite token % has expired', p_token;
  END IF;

  IF v_invite.use_count >= v_invite.max_uses THEN
    RAISE EXCEPTION 'Invite token % has reached its maximum use limit', p_token;
  END IF;

  -- Verify the class is still active.
  SELECT * INTO v_class
  FROM   public.classes
  WHERE  id = v_invite.class_id AND is_active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Class for token % is no longer active', p_token;
  END IF;

  -- Add student to class.
  INSERT INTO public.class_memberships (class_id, student_id)
  VALUES (v_class.id, p_student_id)
  ON CONFLICT (class_id, student_id) DO NOTHING
  RETURNING id INTO v_member_id;

  -- Increment use_count regardless of whether it was a new membership.
  -- This ensures the counter reflects link clicks for analytics.
  UPDATE public.class_invites
  SET    use_count = use_count + 1
  WHERE  id = v_invite.id;

  -- If already a member, fetch the existing row id.
  IF v_member_id IS NULL THEN
    SELECT id INTO v_member_id
    FROM   public.class_memberships
    WHERE  class_id   = v_class.id
      AND  student_id = p_student_id;
  END IF;

  RETURN v_member_id;
END;
$$;

-- =============================================================================
-- FUNCTION: generate_class_code
-- Generates a unique, uppercase 6-character alphanumeric class code.
-- Called internally when creating a new class.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.generate_class_code()
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  v_code   text;
  v_exists bool;
BEGIN
  LOOP
    -- Draw 6 random alphanumeric characters (A-Z, 0-9).
    v_code := upper(
      substring(
        encode(gen_random_bytes(6), 'base64')
        FROM '[A-Za-z0-9]{6}'
      )
    );

    SELECT EXISTS(SELECT 1 FROM public.classes WHERE code = v_code)
    INTO   v_exists;

    EXIT WHEN NOT v_exists;
  END LOOP;

  RETURN v_code;
END;
$$;
