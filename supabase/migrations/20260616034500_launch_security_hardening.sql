-- CODEship Academy launch security hardening.
-- Restrict exposed SECURITY DEFINER functions and remove broad write policies.

REVOKE ALL ON FUNCTION public.current_profile_id() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.is_admin() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.is_parent_of(uuid) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.is_teacher_of(uuid) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.award_xp(uuid, integer) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.award_xp(uuid, integer, text, uuid) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.update_streak(uuid) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.check_level_completion(uuid) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.join_class_by_code(text) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.join_class_by_token(text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.current_profile_id() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_parent_of(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_teacher_of(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.join_class_by_code(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.join_class_by_token(text) TO authenticated;

GRANT EXECUTE ON FUNCTION public.award_xp(uuid, integer) TO service_role;
GRANT EXECUTE ON FUNCTION public.award_xp(uuid, integer, text, uuid) TO service_role;
GRANT EXECUTE ON FUNCTION public.update_streak(uuid) TO service_role;
GRANT EXECUTE ON FUNCTION public.check_level_completion(uuid) TO service_role;

DROP POLICY IF EXISTS audit_insert ON public.audit_logs;
CREATE POLICY audit_insert ON public.audit_logs FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL AND user_id = auth.uid());

DROP POLICY IF EXISTS email_log_insert ON public.email_log;
DROP POLICY IF EXISTS rate_limit_all ON public.rate_limit_log;
