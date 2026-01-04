-- RPC to get shift audit logs with changer's display name and profile image
-- Returns audit history for a shift request with who made the change
--
-- IMPORTANT: Different action types show different names:
--   - Employee actions (REQUEST, CHECKIN, CHECKOUT, REPORT): Show employee name
--   - Manager actions (APPROVAL, REQUEST_CANCEL, MANAGER_EDIT, REPORT_SOLVED, PROBLEM_SOLVED, etc.): Show manager name
--
-- Usage:
-- SELECT * FROM get_shift_audit_logs('28a51d78-0ab0-40ba-959d-cc0845fa807b');
--
CREATE OR REPLACE FUNCTION get_shift_audit_logs(
  p_shift_request_id UUID
)
RETURNS TABLE (
  audit_id UUID,
  shift_request_id UUID,
  operation TEXT,
  action_type TEXT,
  event_type TEXT,
  changed_columns TEXT[],
  change_details JSONB,
  changed_by UUID,
  changed_by_name TEXT,
  changed_by_profile_image TEXT,
  changed_at TIMESTAMPTZ,
  reason TEXT,
  new_data JSONB,
  old_data JSONB,
  event_data JSONB
)
LANGUAGE sql
SECURITY INVOKER
AS $$
  SELECT
    sal.audit_id,
    sal.shift_request_id,
    sal.operation,
    sal.action_type,
    sal.event_type,
    sal.changed_columns,
    sal.change_details,
    sal.changed_by,
    -- Employee vs Manager action distinction
    CASE
      -- Employee actions: show employee name from event_data
      WHEN sal.action_type IN ('REQUEST', 'CHECKIN', 'CHECKOUT', 'REPORT') THEN
        COALESCE(sal.event_data->>'employee_name', emp.first_name || ' ' || emp.last_name, 'Unknown')
      -- Manager actions: show manager (changed_by) name
      ELSE
        COALESCE(mgr.first_name || ' ' || mgr.last_name, 'System')
    END::TEXT as changed_by_name,
    -- Profile image follows same logic
    CASE
      WHEN sal.action_type IN ('REQUEST', 'CHECKIN', 'CHECKOUT', 'REPORT') THEN
        emp.profile_image
      ELSE
        mgr.profile_image
    END as changed_by_profile_image,
    sal.changed_at,
    sal.reason,
    sal.new_data,
    sal.old_data,
    sal.event_data
  FROM shift_request_audit_log sal
  -- Employee info (based on event_data.employee_id)
  LEFT JOIN users emp ON emp.user_id = (sal.event_data->>'employee_id')::UUID
  -- Manager info (based on changed_by)
  LEFT JOIN users mgr ON mgr.user_id = sal.changed_by
  WHERE sal.shift_request_id = p_shift_request_id
  ORDER BY sal.changed_at ASC;
$$;
