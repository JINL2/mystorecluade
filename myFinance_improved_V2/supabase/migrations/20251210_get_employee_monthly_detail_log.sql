-- =====================================================
-- get_employee_monthly_detail_log RPC
--
-- 직원의 월별 상세 데이터를 한번에 가져오는 RPC
-- - shifts: 해당 월의 모든 shift 기록 (Attendance History용)
-- - audit_logs: 해당 월의 모든 변경 로그 (Recent Activity용)
-- - summary: 통계 요약 (Unresolved/Resolved 카운트 등)
-- - salary: 급여 계산 데이터
--
-- Used in: Employee Detail Page
-- =====================================================

-- Drop existing function to avoid signature conflicts
DROP FUNCTION IF EXISTS get_employee_monthly_detail_log(UUID, UUID, TEXT, TEXT);

CREATE OR REPLACE FUNCTION get_employee_monthly_detail_log(
    p_user_id UUID,
    p_company_id UUID,
    p_year_month TEXT,  -- Format: 'YYYY-MM' (e.g., '2024-12')
    p_timezone TEXT DEFAULT 'Asia/Ho_Chi_Minh'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
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
    -- Parse year-month to date range
    v_start_date := (p_year_month || '-01')::DATE;
    v_end_date := (v_start_date + INTERVAL '1 month' - INTERVAL '1 day')::DATE;

    -- Convert to timestamps with timezone
    v_start_timestamp := (v_start_date::TEXT || ' 00:00:00')::TIMESTAMP AT TIME ZONE p_timezone;
    v_end_timestamp := (v_end_date::TEXT || ' 23:59:59')::TIMESTAMP AT TIME ZONE p_timezone;

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
    -- 2. Get Shifts for the month
    -- =========================================
    SELECT COALESCE(jsonb_agg(
        jsonb_build_object(
            'shift_request_id', sr.shift_request_id,
            'shift_id', sr.shift_id,
            'store_id', sr.store_id,
            'store_name', s.store_name,
            'shift_name', ss.shift_name,
            -- Date info (converted to local timezone)
            'request_date', sr.request_date,
            'work_date', (sr.start_time_utc AT TIME ZONE p_timezone)::DATE,
            'day_of_month', EXTRACT(DAY FROM (sr.start_time_utc AT TIME ZONE p_timezone)),
            -- Scheduled times (local)
            'scheduled_start', TO_CHAR(sr.start_time_utc AT TIME ZONE p_timezone, 'HH24:MI'),
            'scheduled_end', TO_CHAR(sr.end_time_utc AT TIME ZONE p_timezone, 'HH24:MI'),
            -- Actual times (local)
            'actual_start', CASE
                WHEN sr.actual_start_time_utc IS NOT NULL
                THEN TO_CHAR(sr.actual_start_time_utc AT TIME ZONE p_timezone, 'HH24:MI')
                ELSE NULL
            END,
            'actual_end', CASE
                WHEN sr.actual_end_time_utc IS NOT NULL
                THEN TO_CHAR(sr.actual_end_time_utc AT TIME ZONE p_timezone, 'HH24:MI')
                ELSE NULL
            END,
            -- Confirmed times (local)
            'confirm_start', CASE
                WHEN sr.confirm_start_time_utc IS NOT NULL
                THEN TO_CHAR(sr.confirm_start_time_utc AT TIME ZONE p_timezone, 'HH24:MI')
                ELSE NULL
            END,
            'confirm_end', CASE
                WHEN sr.confirm_end_time_utc IS NOT NULL
                THEN TO_CHAR(sr.confirm_end_time_utc AT TIME ZONE p_timezone, 'HH24:MI')
                ELSE NULL
            END,
            -- Status flags
            'is_approved', COALESCE(sr.is_approved, false),
            'is_late', COALESCE(sr.is_late_v2, false),
            'is_overtime', COALESCE(sr.is_extratime_v2, false),
            'is_problem', COALESCE(sr.is_problem_v2, false),
            'is_problem_solved', COALESCE(sr.is_problem_solved_v2, false),
            'is_reported', COALESCE(sr.is_reported_v2, false),
            'is_reported_solved', COALESCE(sr.is_reported_solved_v2, false),
            -- Problem details
            'problem_type', sr.problem_type_v2,
            'report_reason', sr.report_reason_v2,
            -- Financial
            'bonus_amount', COALESCE(sr.bonus_amount_v2, 0),
            'overtime_amount', COALESCE(sr.overtime_amount_v2, 0),
            'late_deduct_amount', COALESCE(sr.late_deducut_amount_v2, 0),
            -- Calculated fields
            'worked_hours', CASE
                WHEN sr.confirm_start_time_utc IS NOT NULL AND sr.confirm_end_time_utc IS NOT NULL
                THEN ROUND(EXTRACT(EPOCH FROM (sr.confirm_end_time_utc - sr.confirm_start_time_utc)) / 3600.0, 2)
                WHEN sr.actual_start_time_utc IS NOT NULL AND sr.actual_end_time_utc IS NOT NULL
                THEN ROUND(EXTRACT(EPOCH FROM (sr.actual_end_time_utc - sr.actual_start_time_utc)) / 3600.0, 2)
                ELSE NULL
            END,
            -- Issue type for UI badge
            'issue_type', CASE
                WHEN sr.actual_start_time_utc IS NULL AND sr.actual_end_time_utc IS NOT NULL THEN 'no_check_in'
                WHEN sr.actual_start_time_utc IS NOT NULL AND sr.actual_end_time_utc IS NULL THEN 'no_check_out'
                WHEN COALESCE(sr.is_late_v2, false) THEN 'late'
                WHEN COALESCE(sr.is_extratime_v2, false) THEN 'overtime'
                WHEN sr.actual_end_time_utc IS NOT NULL AND sr.end_time_utc IS NOT NULL
                     AND sr.actual_end_time_utc < sr.end_time_utc - INTERVAL '10 minutes' THEN 'early_check_out'
                ELSE NULL
            END,
            -- Tags and memos
            'notice_tag', sr.notice_tag_v2,
            'manager_memo', sr.manager_memo_v2,
            -- Timestamps
            'created_at', sr.created_at_utc,
            'updated_at', sr.updated_at_utc
        ) ORDER BY sr.start_time_utc DESC
    ), '[]'::JSONB) INTO v_shifts
    FROM shift_requests sr
    LEFT JOIN stores s ON s.store_id = sr.store_id
    LEFT JOIN store_shifts ss ON ss.shift_id = sr.shift_id
    WHERE sr.user_id = p_user_id
      AND sr.store_id IN (
          SELECT st.store_id
          FROM stores st
          WHERE st.company_id = p_company_id
      )
      AND sr.start_time_utc >= v_start_timestamp
      AND sr.start_time_utc < v_end_timestamp + INTERVAL '1 day';

    -- =========================================
    -- 3. Get Audit Logs for the month
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
                SELECT (sr2.start_time_utc AT TIME ZONE p_timezone)::DATE
                FROM shift_requests sr2
                WHERE sr2.shift_request_id = sal.shift_request_id
                LIMIT 1
            )
        ) ORDER BY sal.changed_at DESC
    ), '[]'::JSONB) INTO v_audit_logs
    FROM shift_request_audit_log sal
    WHERE sal.shift_request_id IN (
        SELECT sr.shift_request_id
        FROM shift_requests sr
        WHERE sr.user_id = p_user_id
          AND sr.store_id IN (
              SELECT st.store_id
              FROM stores st
              WHERE st.company_id = p_company_id
          )
          AND sr.start_time_utc >= v_start_timestamp
          AND sr.start_time_utc < v_end_timestamp + INTERVAL '1 day'
    )
    AND sal.changed_at >= v_start_timestamp
    AND sal.changed_at < v_end_timestamp + INTERVAL '1 day';

    -- =========================================
    -- 4. Calculate Summary Statistics
    -- =========================================
    SELECT jsonb_build_object(
        'total_shifts', COUNT(*),
        'unresolved_count', COUNT(*) FILTER (
            WHERE COALESCE(sr.is_problem_v2, false) = true
            AND COALESCE(sr.is_problem_solved_v2, false) = false
        ),
        'resolved_count', COUNT(*) FILTER (
            WHERE COALESCE(sr.is_problem_solved_v2, false) = true
        ),
        'approved_count', COUNT(*) FILTER (WHERE COALESCE(sr.is_approved, false) = true),
        'pending_approval_count', COUNT(*) FILTER (WHERE COALESCE(sr.is_approved, false) = false),
        'late_count', COUNT(*) FILTER (WHERE COALESCE(sr.is_late_v2, false) = true),
        'overtime_count', COUNT(*) FILTER (WHERE COALESCE(sr.is_extratime_v2, false) = true),
        'no_check_in_count', COUNT(*) FILTER (
            WHERE sr.actual_start_time_utc IS NULL AND sr.actual_end_time_utc IS NOT NULL
        ),
        'no_check_out_count', COUNT(*) FILTER (
            WHERE sr.actual_start_time_utc IS NOT NULL AND sr.actual_end_time_utc IS NULL
        ),
        'total_worked_hours', COALESCE(
            ROUND(SUM(
                CASE
                    WHEN sr.confirm_start_time_utc IS NOT NULL AND sr.confirm_end_time_utc IS NOT NULL
                    THEN EXTRACT(EPOCH FROM (sr.confirm_end_time_utc - sr.confirm_start_time_utc)) / 3600.0
                    WHEN sr.actual_start_time_utc IS NOT NULL AND sr.actual_end_time_utc IS NOT NULL
                    THEN EXTRACT(EPOCH FROM (sr.actual_end_time_utc - sr.actual_start_time_utc)) / 3600.0
                    ELSE 0
                END
            )::NUMERIC, 2),
            0
        ),
        'total_bonus', COALESCE(SUM(COALESCE(sr.bonus_amount_v2, 0)), 0),
        'total_overtime_pay', COALESCE(SUM(COALESCE(sr.overtime_amount_v2, 0)), 0),
        'total_late_deduction', COALESCE(SUM(COALESCE(sr.late_deducut_amount_v2, 0)), 0)
    ) INTO v_summary
    FROM shift_requests sr
    WHERE sr.user_id = p_user_id
      AND sr.store_id IN (
          SELECT st.store_id
          FROM stores st
          WHERE st.company_id = p_company_id
      )
      AND sr.start_time_utc >= v_start_timestamp
      AND sr.start_time_utc < v_end_timestamp + INTERVAL '1 day';

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
            'timezone', p_timezone
        ),
        'shifts', v_shifts,
        'audit_logs', v_audit_logs,
        'summary', v_summary,
        'salary', v_salary_info
    );

    RETURN v_result;
END;
$$;

-- Add comment
COMMENT ON FUNCTION get_employee_monthly_detail_log IS
'Get comprehensive monthly data for an employee including:
- All shift records for the month (Attendance History)
- All audit logs for changes made during the month
- Summary statistics (unresolved, resolved, late counts, etc.)
- Salary information for calculating pay

Parameters:
- p_user_id: Employee user ID
- p_company_id: Company ID for filtering stores
- p_year_month: Year and month in YYYY-MM format (e.g., 2024-12)
- p_timezone: Timezone for date conversions (default: Asia/Ho_Chi_Minh)

Returns: JSONB object with user, period, shifts, audit_logs, summary, and salary';
