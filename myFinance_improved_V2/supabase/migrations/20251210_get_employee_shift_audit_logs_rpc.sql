-- Create RPC function to get employee shift audit logs
-- Used in: Employee Detail Sheet > Attendance Tab > Recent Activity section
-- Returns the most recent shift audit logs for an employee within a company
-- Supports pagination with p_offset for lazy loading

-- Drop existing functions to avoid signature conflicts
DROP FUNCTION IF EXISTS get_employee_shift_audit_logs(UUID, UUID, INT);
DROP FUNCTION IF EXISTS get_employee_shift_audit_logs(UUID, UUID, INT, INT);

CREATE OR REPLACE FUNCTION get_employee_shift_audit_logs(
    p_user_id UUID,
    p_company_id UUID,
    p_limit INT DEFAULT 20,
    p_offset INT DEFAULT 0
)
RETURNS TABLE (
    audit_id UUID,
    shift_request_id UUID,
    user_id UUID,
    store_id UUID,
    store_name TEXT,
    request_date DATE,
    operation TEXT,
    action_type TEXT,
    changed_columns TEXT[],
    changed_by UUID,
    changed_by_name TEXT,
    changed_at TIMESTAMPTZ,
    reason TEXT,
    total_count BIGINT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_total_count BIGINT;
BEGIN
    -- Get total count for pagination info
    SELECT COUNT(*) INTO v_total_count
    FROM shift_request_audit_log sal
    WHERE sal.user_id = p_user_id
      AND sal.store_id IN (
          SELECT ss.store_id
          FROM stores ss
          WHERE ss.company_id = p_company_id
      );

    RETURN QUERY
    SELECT
        sal.audit_id,
        sal.shift_request_id,
        sal.user_id,
        sal.store_id,
        s.store_name::TEXT,
        sal.request_date,
        sal.operation,
        sal.action_type,
        sal.changed_columns,
        sal.changed_by,
        COALESCE(concat(u.last_name, ' ', u.first_name), 'System')::TEXT as changed_by_name,
        sal.changed_at,
        sal.reason,
        v_total_count
    FROM shift_request_audit_log sal
    LEFT JOIN stores s ON s.store_id = sal.store_id
    LEFT JOIN users u ON u.user_id = sal.changed_by
    WHERE sal.user_id = p_user_id
      AND sal.store_id IN (
          SELECT ss.store_id
          FROM stores ss
          WHERE ss.company_id = p_company_id
      )
    ORDER BY sal.changed_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;

COMMENT ON FUNCTION get_employee_shift_audit_logs IS 'Get recent shift audit logs for an employee within a company. Supports lazy loading with p_limit and p_offset. Returns total_count for pagination UI.';
