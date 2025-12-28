-- Fix get_monthly_attendance_stats RPC to properly return today data
-- The issue is that "v_today_attendance IS NOT NULL" doesn't work correctly
-- for RECORD types in PostgreSQL. Use FOUND variable instead.
--
-- NOTE: late_minutes, early_leave_minutes 컬럼은 테이블에 없으므로 제외

CREATE OR REPLACE FUNCTION public.get_monthly_attendance_stats(
  p_user_id uuid,
  p_company_id uuid,
  p_year integer DEFAULT NULL::integer,
  p_month integer DEFAULT NULL::integer
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_company_timezone TEXT;
  v_start_date DATE;
  v_end_date DATE;
  v_today DATE;
  v_stats RECORD;
  v_today_attendance RECORD;
  v_today_found BOOLEAN := false;
BEGIN
  -- 회사 timezone 조회
  SELECT timezone INTO v_company_timezone
  FROM companies WHERE company_id = p_company_id;
  v_company_timezone := COALESCE(v_company_timezone, 'UTC');

  v_today := (NOW() AT TIME ZONE v_company_timezone)::DATE;

  -- 기본값: 현재 월
  IF p_year IS NULL THEN
    p_year := EXTRACT(YEAR FROM v_today);
  END IF;
  IF p_month IS NULL THEN
    p_month := EXTRACT(MONTH FROM v_today);
  END IF;

  v_start_date := make_date(p_year, p_month, 1);
  v_end_date := (v_start_date + INTERVAL '1 month' - INTERVAL '1 day')::DATE;

  -- 월간 통계 (단순화)
  SELECT
    COUNT(*) FILTER (WHERE status = 'completed') AS completed_days,
    COUNT(*) FILTER (WHERE status IN ('checked_in', 'completed')) AS worked_days,
    COUNT(*) FILTER (WHERE status = 'absent') AS absent_days,
    COUNT(*) FILTER (WHERE is_late = true) AS late_days,
    COUNT(*) FILTER (WHERE is_early_leave = true) AS early_leave_days
  INTO v_stats
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date BETWEEN v_start_date AND v_end_date;

  -- 오늘 출석 상태 (FOUND 변수 사용)
  SELECT * INTO v_today_attendance
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date = v_today;

  v_today_found := FOUND;

  RETURN jsonb_build_object(
    'success', true,
    'period', jsonb_build_object(
      'year', p_year,
      'month', p_month,
      'start_date', v_start_date,
      'end_date', v_end_date
    ),
    'today', CASE
      WHEN v_today_found THEN
        jsonb_build_object(
          'attendance_id', v_today_attendance.attendance_id,
          'status', v_today_attendance.status,
          'check_in_time_utc', v_today_attendance.check_in_time_utc,
          'check_out_time_utc', v_today_attendance.check_out_time_utc,
          'scheduled_start_time', v_today_attendance.scheduled_start_time,
          'scheduled_end_time', v_today_attendance.scheduled_end_time,
          'is_late', v_today_attendance.is_late,
          'is_early_leave', v_today_attendance.is_early_leave
        )
      ELSE NULL
    END,
    'stats', jsonb_build_object(
      'completed_days', COALESCE(v_stats.completed_days, 0),
      'worked_days', COALESCE(v_stats.worked_days, 0),
      'absent_days', COALESCE(v_stats.absent_days, 0),
      'late_days', COALESCE(v_stats.late_days, 0),
      'early_leave_days', COALESCE(v_stats.early_leave_days, 0)
    )
  );
END;
$function$;
