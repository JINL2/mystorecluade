-- Fix get_employee_monthly_detail_log RPC to use v_shift_request view for correct salary calculation
-- Previously: Used shift_requests table directly with raw actual_start/end times (caused 426h bug)
-- Now: Uses v_shift_request view with properly calculated paid_hours_v2, total_salary_pay_v2, etc.
-- Also: Uses company timezone from companies table instead of parameter

CREATE OR REPLACE FUNCTION get_employee_monthly_detail_log(
    p_user_id uuid,
    p_company_id uuid,
    p_year_month text,
    p_timezone text DEFAULT 'Asia/Ho_Chi_Minh'::text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_company_timezone TEXT;
    v_start_date DATE;
    v_end_date DATE;
    v_start_timestamp TIMESTAMPTZ;
    v_end_timestamp TIMESTAMPTZ;
    v_shifts JSONB;
    v_audit_logs JSONB;
    v_summary JSONB;
    v_salary_info JSONB;
    v_user_info JSONB;
    v_result JSONB;
BEGIN
    -- Get company timezone (fallback to parameter if not set)
    SELECT COALESCE(c.timezone, p_timezone) INTO v_company_timezone
    FROM companies c
    WHERE c.company_id = p_company_id;

    IF v_company_timezone IS NULL THEN
        v_company_timezone := p_timezone;
    END IF;

    -- Parse year-month to date range
    v_start_date := (p_year_month || '-01')::DATE;
    v_end_date := (v_start_date + INTERVAL '1 month' - INTERVAL '1 day')::DATE;

    -- Convert to timestamps with company timezone
    v_start_timestamp := (v_start_date::TEXT || ' 00:00:00')::TIMESTAMP AT TIME ZONE v_company_timezone;
    v_end_timestamp := (v_end_date::TEXT || ' 23:59:59')::TIMESTAMP AT TIME ZONE v_company_timezone;

    -- =========================================
    -- 1. Get User Info
    -- =========================================
    SELECT jsonb_build_object(
        'user_id', u.user_id,
        'full_name', COALESCE(u.last_name || ' ' || u.first_name, u.first_name, 'Unknown'),
        'email', u.email,
        'profile_image', u.profile_image
    ) INTO v_user_info
    FROM users u
    WHERE u.user_id = p_user_id;

    -- =========================================
    -- 2. Get Shifts for the month (from v_shift_request view)
    -- Filter by start_time_utc converted to local timezone date
    -- Night shifts starting in Dec but ending in Jan should be included in Dec
    -- =========================================
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'shift_request_id', vsr.shift_request_id,
            'shift_id', vsr.shift_id,
            'store_id', vsr.store_id,
            'store_name', vsr.store_name,
            'shift_name', vsr.shift_name,
            -- Date info (converted to company timezone)
            'request_date', vsr.request_date,
            'work_date', (vsr.start_time_utc AT TIME ZONE v_company_timezone)::DATE,
            'day_of_month', EXTRACT(DAY FROM (vsr.start_time_utc AT TIME ZONE v_company_timezone)),
            -- Scheduled times (local)
            'scheduled_start', TO_CHAR(vsr.start_time_utc AT TIME ZONE v_company_timezone, 'HH24:MI'),
            'scheduled_end', TO_CHAR(vsr.end_time_utc AT TIME ZONE v_company_timezone, 'HH24:MI'),
            -- Actual times (local)
            'actual_start', CASE
                WHEN vsr.actual_start_time_utc IS NOT NULL
                THEN TO_CHAR(vsr.actual_start_time_utc AT TIME ZONE v_company_timezone, 'HH24:MI')
                ELSE NULL
            END,
            'actual_end', CASE
                WHEN vsr.actual_end_time_utc IS NOT NULL
                THEN TO_CHAR(vsr.actual_end_time_utc AT TIME ZONE v_company_timezone, 'HH24:MI')
                ELSE NULL
            END,
            -- Confirmed times (from view - properly calculated)
            'confirm_start', CASE
                WHEN vsr.confirm_start_time_v2 IS NOT NULL
                THEN TO_CHAR(vsr.confirm_start_time_v2 AT TIME ZONE v_company_timezone, 'HH24:MI')
                ELSE NULL
            END,
            'confirm_end', CASE
                WHEN vsr.confirm_end_time_v2 IS NOT NULL
                THEN TO_CHAR(vsr.confirm_end_time_v2 AT TIME ZONE v_company_timezone, 'HH24:MI')
                ELSE NULL
            END,
            -- Status flags
            'is_approved', COALESCE(vsr.is_approved, false),
            'is_late', COALESCE(vsr.is_late_v2, false),
            'is_overtime', COALESCE(vsr.is_extratime_v2, false),
            'is_problem', COALESCE(vsr.is_problem_v2, false),
            'is_problem_solved', COALESCE(vsr.is_problem_solved_v2, false),
            'is_reported', COALESCE(vsr.is_reported_v2, false),
            'is_reported_solved', COALESCE(vsr.is_reported_solved_v2, false),
            -- Problem details
            'problem_type', vsr.problem_type_v2,
            'report_reason', vsr.report_reason_v2,
            -- Financial (from view - properly calculated)
            'paid_hours', COALESCE(vsr.paid_hours_v2, 0),
            'salary_amount', COALESCE(vsr.salary_amount, 0),
            'base_pay', COALESCE(vsr.total_salary_pay_v2, 0),
            'bonus_amount', COALESCE(vsr.bonus_amount_v2, 0),
            'total_pay', COALESCE(vsr.total_pay_with_bonus_v2, 0),
            -- Issue type for UI badge
            'issue_type', CASE
                WHEN vsr.actual_start_time_utc IS NULL AND vsr.actual_end_time_utc IS NOT NULL THEN 'no_check_in'
                WHEN vsr.actual_start_time_utc IS NOT NULL AND vsr.actual_end_time_utc IS NULL THEN 'no_check_out'
                WHEN COALESCE(vsr.is_late_v2, false) THEN 'late'
                WHEN COALESCE(vsr.is_extratime_v2, false) THEN 'overtime'
                ELSE NULL
            END,
            -- Tags and memos
            'notice_tag', vsr.notice_tag_v2,
            'manager_memo', vsr.manager_memo_v2,
            -- Timestamps
            'created_at', vsr.created_at_utc,
            'updated_at', vsr.updated_at_utc
        ) ORDER BY vsr.start_time_utc DESC
    ), '[]'::JSONB) INTO v_shifts
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id
      AND vsr.company_id = p_company_id
      -- Filter by local date (start_time_utc converted to company timezone)
      -- This ensures night shifts are counted in the month they started
      AND (vsr.start_time_utc AT TIME ZONE v_company_timezone)::DATE >= v_start_date
      AND (vsr.start_time_utc AT TIME ZONE v_company_timezone)::DATE <= v_end_date;

    -- =========================================
    -- 3. Get Audit Logs for the month
    -- Filter by local date (same logic as shifts)
    -- =========================================
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'audit_id', sal.audit_id,
            'shift_request_id', sal.shift_request_id,
            'operation', sal.operation,
            'action_type', CASE
                WHEN sal.operation = 'INSERT' THEN 'SCHEDULE_CREATED'
                WHEN sal.operation = 'DELETE' THEN 'SCHEDULE_DELETED'
                WHEN 'is_approved' = ANY(sal.changed_columns) THEN 'APPROVAL_CHANGED'
                WHEN 'actual_start_time_utc' = ANY(sal.changed_columns) THEN 'CHECK_IN'
                WHEN 'actual_end_time_utc' = ANY(sal.changed_columns) THEN 'CHECK_OUT'
                WHEN 'confirm_start_time_utc' = ANY(sal.changed_columns) OR 'confirm_end_time_utc' = ANY(sal.changed_columns) THEN 'TIME_CONFIRMED'
                WHEN 'is_problem_solved_v2' = ANY(sal.changed_columns) THEN 'PROBLEM_RESOLVED'
                WHEN 'is_reported_solved_v2' = ANY(sal.changed_columns) THEN 'REPORT_RESOLVED'
                WHEN 'bonus_amount_v2' = ANY(sal.changed_columns) THEN 'BONUS_UPDATED'
                WHEN 'manager_memo_v2' = ANY(sal.changed_columns) THEN 'MEMO_ADDED'
                ELSE 'UPDATED'
            END,
            'changed_columns', sal.changed_columns,
            'changed_by', sal.changed_by,
            'changed_by_name', COALESCE(
                (SELECT COALESCE(uu.last_name || ' ' || uu.first_name, uu.first_name)
                 FROM users uu WHERE uu.user_id = sal.changed_by),
                'System'
            ),
            'changed_at', sal.changed_at,
            'reason', sal.reason,
            -- Include store info from shift_request
            'store_name', (
                SELECT st.store_name
                FROM shift_requests sr2
                JOIN stores st ON st.store_id = sr2.store_id
                WHERE sr2.shift_request_id = sal.shift_request_id
                LIMIT 1
            ),
            'work_date', (
                SELECT (sr2.start_time_utc AT TIME ZONE v_company_timezone)::DATE
                FROM shift_requests sr2
                WHERE sr2.shift_request_id = sal.shift_request_id
                LIMIT 1
            )
        ) ORDER BY sal.changed_at DESC
    ), '[]'::JSONB) INTO v_audit_logs
    FROM shift_request_audit_log sal
    WHERE sal.shift_request_id IN (
        SELECT vsr.shift_request_id
        FROM v_shift_request vsr
        WHERE vsr.user_id = p_user_id
          AND vsr.company_id = p_company_id
          AND (vsr.start_time_utc AT TIME ZONE v_company_timezone)::DATE >= v_start_date
          AND (vsr.start_time_utc AT TIME ZONE v_company_timezone)::DATE <= v_end_date
    )
    AND (sal.changed_at AT TIME ZONE v_company_timezone)::DATE >= v_start_date
    AND (sal.changed_at AT TIME ZONE v_company_timezone)::DATE <= v_end_date;

    -- =========================================
    -- 4. Calculate Summary Statistics (from v_shift_request view)
    -- Filter by local date (same logic as shifts)
    -- =========================================
    SELECT jsonb_build_object(
        'total_shifts', COUNT(*),
        'unresolved_count', COUNT(*) FILTER (
            WHERE COALESCE(vsr.is_problem_v2, false) = true
            AND COALESCE(vsr.is_problem_solved_v2, false) = false
        ),
        'resolved_count', COUNT(*) FILTER (
            WHERE COALESCE(vsr.is_problem_solved_v2, false) = true
        ),
        'approved_count', COUNT(*) FILTER (WHERE COALESCE(vsr.is_approved, false) = true),
        'pending_approval_count', COUNT(*) FILTER (WHERE COALESCE(vsr.is_approved, false) = false),
        'late_count', COUNT(*) FILTER (WHERE COALESCE(vsr.is_late_v2, false) = true),
        'overtime_count', COUNT(*) FILTER (WHERE COALESCE(vsr.is_extratime_v2, false) = true),
        'no_check_in_count', COUNT(*) FILTER (
            WHERE vsr.actual_start_time_utc IS NULL AND vsr.actual_end_time_utc IS NOT NULL
        ),
        'no_check_out_count', COUNT(*) FILTER (
            WHERE vsr.actual_start_time_utc IS NOT NULL AND vsr.actual_end_time_utc IS NULL
        ),
        -- Use view's calculated values
        'total_worked_hours', COALESCE(ROUND(SUM(COALESCE(vsr.paid_hours_v2, 0))::NUMERIC, 2), 0),
        'total_base_pay', COALESCE(ROUND(SUM(COALESCE(vsr.total_salary_pay_v2, 0))::NUMERIC, 0), 0),
        'total_bonus', COALESCE(SUM(COALESCE(vsr.bonus_amount_v2, 0)), 0),
        'total_payment', COALESCE(ROUND(SUM(COALESCE(vsr.total_pay_with_bonus_v2, 0))::NUMERIC, 0), 0)
    ) INTO v_summary
    FROM v_shift_request vsr
    WHERE vsr.user_id = p_user_id
      AND vsr.company_id = p_company_id
      AND (vsr.start_time_utc AT TIME ZONE v_company_timezone)::DATE >= v_start_date
      AND (vsr.start_time_utc AT TIME ZONE v_company_timezone)::DATE <= v_end_date;

    -- =========================================
    -- 5. Get Salary Info
    -- =========================================
    SELECT jsonb_build_object(
        'salary_type', us.salary_type,
        'salary_amount', us.salary_amount,
        'bonus_amount', COALESCE(us.bonus_amount, 0),
        'currency_code', ct.currency_code,
        'currency_symbol', ct.symbol
    ) INTO v_salary_info
    FROM user_salaries us
    LEFT JOIN currency_types ct ON ct.currency_id = us.currency_id
    WHERE us.user_id = p_user_id
      AND us.company_id = p_company_id
    LIMIT 1;

    -- =========================================
    -- 6. Build Final Result
    -- =========================================
    v_result := jsonb_build_object(
        'success', true,
        'user', v_user_info,
        'period', jsonb_build_object(
            'year_month', p_year_month,
            'start_date', v_start_date,
            'end_date', v_end_date,
            'timezone', v_company_timezone
        ),
        'shifts', v_shifts,
        'audit_logs', v_audit_logs,
        'summary', v_summary,
        'salary', v_salary_info
    );

    RETURN v_result;
END;
$$;

COMMENT ON FUNCTION get_employee_monthly_detail_log IS 'Get employee monthly detail log with correct salary calculation using v_shift_request view. Uses company timezone for date filtering.';
