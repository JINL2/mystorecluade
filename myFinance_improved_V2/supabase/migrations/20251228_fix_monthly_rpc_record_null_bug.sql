-- Fix RECORD IS NULL bug in monthly_check_in and monthly_check_out RPCs
-- PostgreSQL RECORD type doesn't work with IS NULL check correctly
-- Solution: Use FOUND variable after SELECT INTO
--
-- Also ensures all RPCs return scheduled_start_time_utc / scheduled_end_time_utc (V3 spec)

-- =============================================
-- 1. Fix monthly_check_in RPC
-- =============================================
CREATE OR REPLACE FUNCTION public.monthly_check_in(
  p_user_id uuid,
  p_company_id uuid,
  p_store_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_template RECORD;
  v_template_found BOOLEAN := false;
  v_company_timezone TEXT;
  v_today DATE;
  v_now_utc TIMESTAMPTZ;
  v_is_workday BOOLEAN;
  v_day_of_week INTEGER;
  v_existing RECORD;
  v_existing_found BOOLEAN := false;
  v_is_late BOOLEAN := false;
  v_result RECORD;
  v_scheduled_start_utc TIMESTAMPTZ;
  v_scheduled_end_utc TIMESTAMPTZ;
BEGIN
  v_now_utc := NOW();

  -- 1. 회사 timezone 조회
  SELECT timezone INTO v_company_timezone
  FROM companies WHERE company_id = p_company_id;
  v_company_timezone := COALESCE(v_company_timezone, 'UTC');

  -- 2. 로컬 날짜 계산
  v_today := (v_now_utc AT TIME ZONE v_company_timezone)::DATE;
  v_day_of_week := EXTRACT(DOW FROM v_today);

  -- 3. 템플릿 조회 (FOUND 변수 사용)
  SELECT wst.* INTO v_template
  FROM user_salaries us
  JOIN work_schedule_templates wst ON us.work_schedule_template_id = wst.template_id
  WHERE us.user_id = p_user_id
    AND us.company_id = p_company_id
    AND us.salary_type = 'monthly';

  v_template_found := FOUND;

  IF NOT v_template_found THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NO_TEMPLATE',
      'message', 'Monthly 직원이 아니거나 근무 스케줄 템플릿이 없습니다.'
    );
  END IF;

  -- 4. 오늘이 근무일인지 확인
  v_is_workday := CASE v_day_of_week
    WHEN 0 THEN v_template.sunday
    WHEN 1 THEN v_template.monday
    WHEN 2 THEN v_template.tuesday
    WHEN 3 THEN v_template.wednesday
    WHEN 4 THEN v_template.thursday
    WHEN 5 THEN v_template.friday
    WHEN 6 THEN v_template.saturday
  END;

  IF NOT v_is_workday THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'NOT_WORKDAY',
      'message', '오늘은 근무일이 아닙니다.',
      'template_name', v_template.template_name
    );
  END IF;

  -- 5. 이미 체크인했는지 확인 (FOUND 변수 사용)
  SELECT * INTO v_existing
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date = v_today;

  v_existing_found := FOUND;

  IF v_existing_found AND v_existing.status IN ('checked_in', 'completed') THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'ALREADY_CHECKED_IN',
      'message', '이미 출근 체크인을 했습니다.',
      'check_in_time', v_existing.check_in_time_utc
    );
  END IF;

  -- 6. 예정 시간을 UTC로 변환
  v_scheduled_start_utc := (v_today || ' ' || v_template.work_start_time)::TIMESTAMP
                           AT TIME ZONE v_company_timezone;
  v_scheduled_end_utc := (v_today || ' ' || v_template.work_end_time)::TIMESTAMP
                         AT TIME ZONE v_company_timezone;

  -- 7. 지각 여부 판정
  IF v_now_utc > v_scheduled_start_utc THEN
    v_is_late := true;
  END IF;

  -- 8. INSERT 또는 UPDATE
  INSERT INTO monthly_attendance (
    user_id,
    company_id,
    store_id,
    work_schedule_template_id,
    attendance_date,
    scheduled_start_time_utc,
    scheduled_end_time_utc,
    check_in_time_utc,
    status,
    is_late
  ) VALUES (
    p_user_id,
    p_company_id,
    p_store_id,
    v_template.template_id,
    v_today,
    v_scheduled_start_utc,
    v_scheduled_end_utc,
    v_now_utc,
    'checked_in',
    v_is_late
  )
  ON CONFLICT (user_id, company_id, attendance_date)
  DO UPDATE SET
    check_in_time_utc = v_now_utc,
    scheduled_start_time_utc = v_scheduled_start_utc,
    scheduled_end_time_utc = v_scheduled_end_time_utc,
    status = 'checked_in',
    is_late = v_is_late,
    updated_at_utc = NOW()
  RETURNING * INTO v_result;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'attendance_id', v_result.attendance_id,
      'attendance_date', v_result.attendance_date,
      'check_in_time_utc', v_result.check_in_time_utc,
      'scheduled_start_time_utc', v_result.scheduled_start_time_utc,
      'scheduled_end_time_utc', v_result.scheduled_end_time_utc,
      'is_late', v_result.is_late,
      'template_name', v_template.template_name,
      'timezone', v_company_timezone
    )
  );
END;
$function$;

-- =============================================
-- 2. Fix monthly_check_out RPC (CRITICAL BUG FIX)
-- =============================================
CREATE OR REPLACE FUNCTION public.monthly_check_out(
  p_user_id uuid,
  p_company_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_company_timezone TEXT;
  v_today DATE;
  v_now_utc TIMESTAMPTZ;
  v_attendance RECORD;
  v_attendance_found BOOLEAN := false;
  v_is_early_leave BOOLEAN := false;
  v_result RECORD;
BEGIN
  v_now_utc := NOW();

  -- 1. 회사 timezone 조회
  SELECT timezone INTO v_company_timezone
  FROM companies WHERE company_id = p_company_id;
  v_company_timezone := COALESCE(v_company_timezone, 'UTC');

  v_today := (v_now_utc AT TIME ZONE v_company_timezone)::DATE;

  -- 2. 오늘 체크인 기록 조회 (FOUND 변수 사용!)
  SELECT * INTO v_attendance
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date = v_today
    AND status = 'checked_in';

  v_attendance_found := FOUND;

  IF NOT v_attendance_found THEN
    -- 체크인 안 했거나 이미 체크아웃 완료 - 다시 조회
    SELECT * INTO v_attendance
    FROM monthly_attendance
    WHERE user_id = p_user_id
      AND company_id = p_company_id
      AND attendance_date = v_today;

    v_attendance_found := FOUND;

    IF NOT v_attendance_found THEN
      RETURN jsonb_build_object(
        'success', false,
        'error', 'NOT_CHECKED_IN',
        'message', '오늘 출근 체크인 기록이 없습니다.'
      );
    ELSIF v_attendance.status = 'completed' THEN
      RETURN jsonb_build_object(
        'success', false,
        'error', 'ALREADY_CHECKED_OUT',
        'message', '이미 퇴근 체크아웃을 했습니다.',
        'check_out_time', v_attendance.check_out_time_utc
      );
    END IF;
  END IF;

  -- 3. 조퇴 여부 판정 (scheduled_end_time_utc와 비교)
  IF v_attendance.scheduled_end_time_utc IS NOT NULL
     AND v_now_utc < v_attendance.scheduled_end_time_utc THEN
    v_is_early_leave := true;
  END IF;

  -- 4. UPDATE
  UPDATE monthly_attendance
  SET
    check_out_time_utc = v_now_utc,
    status = 'completed',
    is_early_leave = v_is_early_leave,
    updated_at_utc = NOW()
  WHERE attendance_id = v_attendance.attendance_id
  RETURNING * INTO v_result;

  RETURN jsonb_build_object(
    'success', true,
    'data', jsonb_build_object(
      'attendance_id', v_result.attendance_id,
      'attendance_date', v_result.attendance_date,
      'check_in_time_utc', v_result.check_in_time_utc,
      'check_out_time_utc', v_result.check_out_time_utc,
      'scheduled_start_time_utc', v_result.scheduled_start_time_utc,
      'scheduled_end_time_utc', v_result.scheduled_end_time_utc,
      'is_late', v_result.is_late,
      'is_early_leave', v_result.is_early_leave,
      'timezone', v_company_timezone
    )
  );
END;
$function$;

-- =============================================
-- 3. Fix get_monthly_attendance_list RPC (V3 컬럼명)
-- =============================================
CREATE OR REPLACE FUNCTION public.get_monthly_attendance_list(
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
  v_data jsonb;
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

  -- 월간 출석 목록 (V3: _utc suffix 사용)
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'attendance_id', attendance_id,
      'attendance_date', attendance_date,
      'day_of_week', EXTRACT(DOW FROM attendance_date),
      'scheduled_start_time_utc', scheduled_start_time_utc,
      'scheduled_end_time_utc', scheduled_end_time_utc,
      'check_in_time_utc', check_in_time_utc,
      'check_out_time_utc', check_out_time_utc,
      'status', status,
      'is_late', is_late,
      'is_early_leave', is_early_leave,
      'notes', notes
    ) ORDER BY attendance_date
  ), '[]'::jsonb) INTO v_data
  FROM monthly_attendance
  WHERE user_id = p_user_id
    AND company_id = p_company_id
    AND attendance_date BETWEEN v_start_date AND v_end_date;

  RETURN jsonb_build_object(
    'success', true,
    'timezone', v_company_timezone,
    'period', jsonb_build_object(
      'year', p_year,
      'month', p_month,
      'start_date', v_start_date,
      'end_date', v_end_date
    ),
    'count', jsonb_array_length(v_data),
    'data', v_data
  );
END;
$function$;
