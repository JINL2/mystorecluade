-- Fix: is_report_solved showing "Rejected" instead of "Pending"
--
-- Problem: COALESCE(NEW.is_reported_solved_v2, false) converts null to false
-- Solution: Remove COALESCE to preserve null (pending status)
--
-- Deploy via Supabase Dashboard SQL Editor

-- 1. Fix the function (only change line 159)
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

    IF NEW.confirm_end_time_utc IS NOT NULL THEN
        v_confirm_end := NEW.confirm_end_time_utc;
    ELSIF NEW.actual_end_time_utc IS NOT NULL THEN
        IF NEW.actual_end_time_utc <= NEW.end_time_utc THEN
            v_confirm_end := NEW.actual_end_time_utc;
        ELSE
            v_confirm_end := NEW.end_time_utc +
                (GREATEST(0, CEIL(EXTRACT(EPOCH FROM (NEW.actual_end_time_utc - NEW.end_time_utc)) / 60.0 / v_payment_time) - 1) * v_huddle_time) * INTERVAL '1 minute';
        END IF;
    ELSE
        v_confirm_end := NULL;
    END IF;

    IF (NEW.start_time_utc + INTERVAL '2 hours') < NOW()
       AND NEW.actual_start_time_utc IS NULL THEN
        v_problem := jsonb_build_object('type', 'absence');
        v_problems := v_problems || v_problem;
    END IF;

    IF (NEW.end_time_utc + INTERVAL '2 hours') < NOW()
       AND NEW.actual_start_time_utc IS NOT NULL
       AND NEW.actual_end_time_utc IS NULL THEN
        v_problem := jsonb_build_object('type', 'no_checkout');
        v_problems := v_problems || v_problem;
    END IF;

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

    IF NEW.actual_end_time_utc IS NOT NULL AND NEW.actual_end_time_utc < NEW.end_time_utc THEN
        v_actual_early_minutes := EXTRACT(EPOCH FROM (NEW.end_time_utc - NEW.actual_end_time_utc)) / 60;

        IF v_confirm_end IS NOT NULL AND v_confirm_end < NEW.end_time_utc THEN
            v_payroll_early_minutes := GREATEST(1, EXTRACT(EPOCH FROM (NEW.end_time_utc - v_confirm_end)) / 60);
        ELSE
            v_payroll_early_minutes := GREATEST(1, v_actual_early_minutes);
        END IF;

        v_problem := jsonb_build_object(
            'type', 'early_leave',
            'actual_minutes', GREATEST(1, ROUND(v_actual_early_minutes)),
            'payroll_minutes', ROUND(v_payroll_early_minutes)
        );
        v_problems := v_problems || v_problem;
    END IF;

    IF NEW.actual_end_time_utc IS NOT NULL AND NEW.actual_end_time_utc > NEW.end_time_utc THEN
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

    IF NEW.is_valid_checkin_location_v2 = FALSE THEN
        v_problem := jsonb_build_object(
            'type', 'invalid_checkin',
            'distance', COALESCE(NEW.checkin_distance_from_store_v2, 0)
        );
        v_problems := v_problems || v_problem;
    END IF;

    IF NEW.is_valid_checkout_location_v2 = FALSE THEN
        v_problem := jsonb_build_object(
            'type', 'invalid_checkout',
            'distance', COALESCE(NEW.checkout_distance_from_store_v2, 0)
        );
        v_problems := v_problems || v_problem;
    END IF;

    -- FIX: Remove COALESCE to preserve null (pending status)
    IF NEW.is_reported_v2 = TRUE THEN
        v_problem := jsonb_build_object(
            'type', 'reported',
            'reason', COALESCE(NEW.report_reason_v2, ''),
            'reported_at', NEW.report_time_utc,
            'is_report_solved', NEW.is_reported_solved_v2  -- was: COALESCE(..., false)
        );
        v_problems := v_problems || v_problem;
    END IF;

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
            'has_reported', EXISTS (SELECT 1 FROM jsonb_array_elements(v_problems) p WHERE p->>'type' = 'reported')
        );
    ELSE
        NEW.problem_details_v2 := NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Fix existing pending reports data
UPDATE shift_requests
SET problem_details_v2 = jsonb_set(
    problem_details_v2,
    '{problems,0,is_report_solved}',
    'null'::jsonb
)
WHERE is_reported_v2 = true
  AND is_reported_solved_v2 IS NULL
  AND problem_details_v2->'problems'->0->>'is_report_solved' = 'false';
