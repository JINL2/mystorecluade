-- Fix determine_event_type function to handle CHAIN_CHECKIN and CHAIN_CHECKOUT
CREATE OR REPLACE FUNCTION determine_event_type(
  p_action_type TEXT,
  p_old_data JSONB,
  p_new_data JSONB
) RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
  CASE p_action_type
    -- CHECKIN: 지각 여부에 따라 분류
    WHEN 'CHECKIN' THEN
      IF (p_new_data->>'is_late_v2')::boolean = true THEN
        RETURN 'employee_late';
      ELSE
        RETURN 'employee_checked_in';
      END IF;

    -- CHAIN_CHECKIN: CHECKIN과 동일하게 처리
    WHEN 'CHAIN_CHECKIN' THEN
      IF (p_new_data->>'is_late_v2')::boolean = true THEN
        RETURN 'employee_late';
      ELSE
        RETURN 'employee_checked_in';
      END IF;

    -- CHECKOUT: 초과근무/조기퇴근/정상 분류
    WHEN 'CHECKOUT' THEN
      IF (p_new_data->>'is_extratime_v2')::boolean = true THEN
        RETURN 'employee_overtime';
      ELSIF p_new_data->>'actual_end_time_utc' IS NOT NULL
            AND p_new_data->>'end_time_utc' IS NOT NULL
            AND (p_new_data->>'actual_end_time_utc')::timestamptz < (p_new_data->>'end_time_utc')::timestamptz THEN
        RETURN 'employee_early_leave';
      ELSE
        RETURN 'employee_checked_out';
      END IF;

    -- CHAIN_CHECKOUT: CHECKOUT과 동일하게 처리
    WHEN 'CHAIN_CHECKOUT' THEN
      IF (p_new_data->>'is_extratime_v2')::boolean = true THEN
        RETURN 'employee_overtime';
      ELSIF p_new_data->>'actual_end_time_utc' IS NOT NULL
            AND p_new_data->>'end_time_utc' IS NOT NULL
            AND (p_new_data->>'actual_end_time_utc')::timestamptz < (p_new_data->>'end_time_utc')::timestamptz THEN
        RETURN 'employee_early_leave';
      ELSE
        RETURN 'employee_checked_out';
      END IF;

    -- 기타 action_type은 그대로 매핑
    WHEN 'APPROVAL' THEN
      RETURN 'shift_approved';

    WHEN 'REQUEST' THEN
      RETURN 'shift_requested';

    WHEN 'REQUEST_CANCEL' THEN
      RETURN 'shift_cancelled';

    WHEN 'DELETE' THEN
      RETURN 'shift_deleted';

    WHEN 'REPORT' THEN
      RETURN 'shift_reported';

    WHEN 'REPORT_SOLVED' THEN
      RETURN 'shift_report_solved';

    WHEN 'MANAGER_EDIT' THEN
      RETURN 'shift_manager_edited';

    WHEN 'PROBLEM_SOLVED' THEN
      RETURN 'shift_problem_solved';

    ELSE
      RETURN 'shift_updated';
  END CASE;
END;
$$;
