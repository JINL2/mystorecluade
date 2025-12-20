-- ============================================================================
-- 마이그레이션: fix_overtime_check_is_can_overtime
-- 설명: calculate_problem_details_v2 트리거에서 is_can_overtime 설정 확인 추가
-- 문제: is_can_overtime = false인 시프트에서도 overtime 문제가 기록됨
-- ============================================================================

CREATE OR REPLACE FUNCTION calculate_problem_details_v2()
RETURNS TRIGGER AS $$
DECLARE
    v_problems JSONB := '[]'::JSONB;
    v_problem JSONB;
    v_payment_time INTEGER;
    v_huddle_time INTEGER;

    v_confirm_start TIMESTAMPTZ;
    v_confirm_end TIMESTAMPTZ;

    v_actual_late_minutes NUMERIC;
    v_actual_early_minutes NUMERIC;
    v_actual_overtime_minutes NUMERIC;

    v_payroll_late_minutes NUMERIC;
    v_payroll_early_minutes NUMERIC;
    v_payroll_overtime_minutes NUMERIC;

    -- 추가: is_can_overtime 체크용
    v_is_can_overtime BOOLEAN;
BEGIN
    IF NEW.is_approved != TRUE THEN
        NEW.problem_details_v2 := NULL;
        RETURN NEW;
    END IF;

    SELECT payment_time, huddle_time
    INTO v_payment_time, v_huddle_time
    FROM stores
    WHERE store_id = NEW.store_id;

    v_payment_time := COALESCE(v_payment_time, 20);
    v_huddle_time := COALESCE(v_huddle_time, 15);

    -- 추가: shift의 is_can_overtime 설정 가져오기
    SELECT COALESCE(is_can_overtime, true)
    INTO v_is_can_overtime
    FROM store_shifts
    WHERE shift_id = NEW.shift_id;

    -- 기본값: true (설정이 없으면 overtime 허용)
    v_is_can_overtime := COALESCE(v_is_can_overtime, true);

    -- confirm_start_time 계산
    IF NEW.confirm_start_time_utc IS NOT NULL THEN
        v_confirm_start := NEW.confirm_start_time_utc;
    ELSIF NEW.actual_start_time_utc IS NOT NULL THEN
        IF NEW.actual_start_time_utc <= NEW.start_time_utc THEN
            v_confirm_start := NEW.start_time_utc;
        ELSE
            v_confirm_start := NEW.start_time_utc +
                (CEIL(EXTRACT(EPOCH FROM (NEW.actual_start_time_utc - NEW.start_time_utc)) / 60.0 / v_huddle_time) * v_payment_time) * INTERVAL '1 minute';
        END IF;
    ELSE
        v_confirm_start := NULL;
    END IF;

    -- confirm_end_time 계산
    IF NEW.confirm_end_time_utc IS NOT NULL THEN
        -- 매니저가 명시적으로 설정한 경우 그대로 사용 (의도 존중)
        v_confirm_end := NEW.confirm_end_time_utc;
    ELSIF NEW.actual_end_time_utc IS NOT NULL THEN
        IF NEW.actual_end_time_utc <= NEW.end_time_utc THEN
            v_confirm_end := NEW.actual_end_time_utc;
        ELSE
            -- is_can_overtime = false면 shift_end로 제한
            IF v_is_can_overtime = FALSE THEN
                v_confirm_end := NEW.end_time_utc;
            ELSE
                v_confirm_end := NEW.end_time_utc +
                    (GREATEST(0, CEIL(EXTRACT(EPOCH FROM (NEW.actual_end_time_utc - NEW.end_time_utc)) / 60.0 / v_payment_time) - 1) * v_huddle_time) * INTERVAL '1 minute';
            END IF;
        END IF;
    ELSE
        v_confirm_end := NULL;
    END IF;

    -- ============================================
    -- 1. 결근 (absence) - 시작 시간 + 2시간 후에 감지
    -- ============================================
    IF (NEW.start_time_utc + INTERVAL '2 hours') < NOW()
       AND NEW.actual_start_time_utc IS NULL THEN
        v_problem := jsonb_build_object('type', 'absence');
        v_problems := v_problems || v_problem;
    END IF;

    -- ============================================
    -- 2. 미퇴근 (no_checkout) - 종료 시간 + 2시간 후에 감지
    -- ============================================
    IF (NEW.end_time_utc + INTERVAL '2 hours') < NOW()
       AND NEW.actual_start_time_utc IS NOT NULL
       AND NEW.actual_end_time_utc IS NULL THEN
        v_problem := jsonb_build_object('type', 'no_checkout');
        v_problems := v_problems || v_problem;
    END IF;

    -- ============================================
    -- 3. 지각 (late) - 급여 차감 있을 때만
    -- ============================================
    IF NEW.actual_start_time_utc IS NOT NULL AND NEW.actual_start_time_utc > NEW.start_time_utc THEN
        v_actual_late_minutes := EXTRACT(EPOCH FROM (NEW.actual_start_time_utc - NEW.start_time_utc)) / 60;

        IF v_actual_late_minutes >= 1 THEN
            IF v_confirm_start IS NOT NULL AND v_confirm_start > NEW.start_time_utc THEN
                v_payroll_late_minutes := EXTRACT(EPOCH FROM (v_confirm_start - NEW.start_time_utc)) / 60;
            ELSE
                v_payroll_late_minutes := 0;
            END IF;

            IF v_payroll_late_minutes > 0 THEN
                v_problem := jsonb_build_object(
                    'type', 'late',
                    'actual_minutes', ROUND(v_actual_late_minutes),
                    'payroll_minutes', ROUND(v_payroll_late_minutes)
                );
                v_problems := v_problems || v_problem;
            END IF;
        END IF;
    END IF;

    -- ============================================
    -- 4. 조퇴 (early_leave) - 1초라도 일찍 나가면 problem!
    --    최소 1분 차감
    -- ============================================
    IF NEW.actual_end_time_utc IS NOT NULL AND NEW.actual_end_time_utc < NEW.end_time_utc THEN
        v_actual_early_minutes := EXTRACT(EPOCH FROM (NEW.end_time_utc - NEW.actual_end_time_utc)) / 60;

        -- 급여 차감 계산: 최소 1분
        IF v_confirm_end IS NOT NULL AND v_confirm_end < NEW.end_time_utc THEN
            v_payroll_early_minutes := GREATEST(1, EXTRACT(EPOCH FROM (NEW.end_time_utc - v_confirm_end)) / 60);
        ELSE
            v_payroll_early_minutes := GREATEST(1, v_actual_early_minutes);  -- 최소 1분
        END IF;

        v_problem := jsonb_build_object(
            'type', 'early_leave',
            'actual_minutes', GREATEST(1, ROUND(v_actual_early_minutes)),  -- 최소 1분
            'payroll_minutes', ROUND(v_payroll_early_minutes)
        );
        v_problems := v_problems || v_problem;
    END IF;

    -- ============================================
    -- 5. 초과근무 (overtime) - is_can_overtime이 true이고 급여 추가 있을 때만
    -- ============================================
    IF v_is_can_overtime = TRUE
       AND NEW.actual_end_time_utc IS NOT NULL
       AND NEW.actual_end_time_utc > NEW.end_time_utc THEN
        v_actual_overtime_minutes := EXTRACT(EPOCH FROM (NEW.actual_end_time_utc - NEW.end_time_utc)) / 60;

        IF v_actual_overtime_minutes >= 1 THEN
            IF v_confirm_end IS NOT NULL AND v_confirm_end > NEW.end_time_utc THEN
                v_payroll_overtime_minutes := EXTRACT(EPOCH FROM (v_confirm_end - NEW.end_time_utc)) / 60;
            ELSE
                v_payroll_overtime_minutes := 0;
            END IF;

            IF v_payroll_overtime_minutes > 0 THEN
                v_problem := jsonb_build_object(
                    'type', 'overtime',
                    'actual_minutes', ROUND(v_actual_overtime_minutes),
                    'payroll_minutes', ROUND(v_payroll_overtime_minutes)
                );
                v_problems := v_problems || v_problem;
            END IF;
        END IF;
    END IF;

    -- ============================================
    -- 6. 출근 위치 문제
    -- ============================================
    IF NEW.is_valid_checkin_location_v2 = FALSE THEN
        v_problem := jsonb_build_object(
            'type', 'invalid_checkin',
            'distance', COALESCE(NEW.checkin_distance_from_store_v2, 0)
        );
        v_problems := v_problems || v_problem;
    END IF;

    -- ============================================
    -- 7. 퇴근 위치 문제
    -- ============================================
    IF NEW.is_valid_checkout_location_v2 = FALSE THEN
        v_problem := jsonb_build_object(
            'type', 'invalid_checkout',
            'distance', COALESCE(NEW.checkout_distance_from_store_v2, 0)
        );
        v_problems := v_problems || v_problem;
    END IF;

    -- ============================================
    -- 8. 직원 보고
    -- ============================================
    IF NEW.is_reported_v2 = TRUE THEN
        v_problem := jsonb_build_object(
            'type', 'reported',
            'reason', COALESCE(NEW.report_reason_v2, ''),
            'reported_at', NEW.report_time_utc,
            'is_report_solved', COALESCE(NEW.is_reported_solved_v2, false)
        );
        v_problems := v_problems || v_problem;
    END IF;

    -- ============================================
    -- 결과 저장
    -- ============================================
    IF jsonb_array_length(v_problems) > 0 THEN
        NEW.problem_details_v2 := jsonb_build_object(
            'problems', v_problems,
            'problem_count', jsonb_array_length(v_problems),
            'is_solved', COALESCE(NEW.is_problem_solved_v2, false),
            'detected_at', NOW(),
            'has_late', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'late'),
            'has_early_leave', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'early_leave'),
            'has_overtime', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'overtime'),
            'has_absence', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'absence'),
            'has_no_checkout', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'no_checkout'),
            'has_location_issue', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' IN ('invalid_checkin', 'invalid_checkout')),
            'has_reported', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'reported'),
            -- 추가: payroll 플래그들
            'has_payroll_late', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'late' AND (p->>'payroll_minutes')::numeric > 0),
            'has_payroll_overtime', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'overtime' AND (p->>'payroll_minutes')::numeric > 0),
            'has_payroll_early_leave', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'early_leave' AND (p->>'payroll_minutes')::numeric > 0)
        );
    ELSE
        NEW.problem_details_v2 := NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 코멘트 업데이트
COMMENT ON FUNCTION calculate_problem_details_v2() IS
'problem_details_v2 계산 트리거
v2.1: is_can_overtime 설정 확인 추가 - false인 시프트는 overtime 문제 기록 안함';
