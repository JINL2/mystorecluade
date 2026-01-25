-- ============================================================================
-- Migration: Fix create_store_shift UTC conversion
-- Date: 2026-01-25
-- Description: Fix incorrect UTC time conversion in create_store_shift function
--
-- Problem:
--   1. CREATE 방식: p_start_time::time AT TIME ZONE ... → 변환 안됨 (14:00 → 14:00+00)
--   2. p_timezone 하드코딩 기본값 사용 → company timezone을 DB에서 조회해야 함
--
-- Solution:
--   1. UTC 변환 로직을 edit_store_shift와 동일하게 수정
--   2. p_store_id → stores → companies → timezone 조회하여 사용
-- ============================================================================

CREATE OR REPLACE FUNCTION public.create_store_shift(
  p_store_id uuid,
  p_shift_name text,
  p_start_time text,
  p_end_time text,
  p_number_shift integer DEFAULT NULL::integer,
  p_is_can_overtime boolean DEFAULT NULL::boolean,
  p_shift_bonus numeric DEFAULT NULL::numeric,
  p_time text DEFAULT NULL::text,
  p_timezone text DEFAULT NULL::text  -- NULL이면 company timezone 자동 조회
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
/*
=============================================================================
FUNCTION: create_store_shift
DESCRIPTION: Create a new store shift.
=============================================================================

PARAMETERS:
---------------------------------------------------------------------------
| Parameter         | Type    | Required | Example                         |
---------------------------------------------------------------------------
| p_store_id        | uuid    | YES      | 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' |
| p_shift_name      | text    | YES      | 'Morning Shift'                 |
| p_start_time      | text    | YES      | '09:00' (local time, HH:MM)     |
| p_end_time        | text    | YES      | '18:00' (local time, HH:MM)     |
| p_number_shift    | integer | NO       | 3 (default: 1)                  |
| p_is_can_overtime | boolean | NO       | true / false (default: true)    |
| p_shift_bonus     | numeric | NO       | 50000 (default: 0)              |
| p_time            | text    | NO       | '2025-08-30 14:30:00' (local time, default: NOW()) |
| p_timezone        | text    | NO       | NULL → company timezone 자동 조회 |
---------------------------------------------------------------------------

TIME CONVERSION (FIXED - 2026-01-25):
---------------------------------------------------------------------------
- p_timezone이 NULL이면 store → company → timezone 조회하여 사용
- p_start_time, p_end_time: Local time → UTC
  변환 방식: ('2000-01-01 ' || p_start_time)::timestamp AT TIME ZONE v_timezone
  예시: '14:00' (베트남 +7) → '07:00:00+00' (UTC)
- p_time: Local timestamp → UTC (stored in created_at_utc, updated_at_utc)
---------------------------------------------------------------------------
*/
DECLARE
  v_new_shift_id uuid;
  v_timezone text;
BEGIN
  -- Validate required parameters
  IF p_store_id IS NULL OR p_shift_name IS NULL OR p_start_time IS NULL OR p_end_time IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Invalid parameters: store_id, shift_name, start_time, end_time are required',
      'error_code', 'INVALID_PARAM'
    );
  END IF;

  -- Get timezone: use p_timezone if provided, otherwise get from company
  IF p_timezone IS NOT NULL THEN
    v_timezone := p_timezone;
  ELSE
    SELECT COALESCE(c.timezone, 'UTC')
    INTO v_timezone
    FROM stores s
    JOIN companies c ON s.company_id = c.company_id
    WHERE s.store_id = p_store_id;

    -- Fallback if store not found
    IF v_timezone IS NULL THEN
      v_timezone := 'UTC';
    END IF;
  END IF;

  -- Insert new shift
  INSERT INTO store_shifts (
    store_id,
    shift_name,
    start_time,
    end_time,
    start_time_utc,
    end_time_utc,
    number_shift,
    is_can_overtime,
    shift_bonus,
    is_active,
    created_at_utc,
    updated_at_utc
  ) VALUES (
    p_store_id,
    p_shift_name,
    p_start_time::time,
    p_end_time::time,
    -- FIXED: 올바른 UTC 변환 (timestamp 사용) + company timezone 사용
    (('2000-01-01 ' || p_start_time)::timestamp AT TIME ZONE v_timezone)::timetz,
    (('2000-01-01 ' || p_end_time)::timestamp AT TIME ZONE v_timezone)::timetz,
    COALESCE(p_number_shift, 1),
    COALESCE(p_is_can_overtime, true),
    COALESCE(p_shift_bonus, 0),
    true,
    CASE
      WHEN p_time IS NOT NULL THEN (p_time::timestamp AT TIME ZONE v_timezone)
      ELSE NOW() AT TIME ZONE 'UTC'
    END,
    CASE
      WHEN p_time IS NOT NULL THEN (p_time::timestamp AT TIME ZONE v_timezone)
      ELSE NOW() AT TIME ZONE 'UTC'
    END
  )
  RETURNING shift_id INTO v_new_shift_id;

  -- Success
  RETURN json_build_object(
    'success', true,
    'message', 'Shift created successfully',
    'shift_id', v_new_shift_id
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'message', SQLERRM,
      'error_code', SQLSTATE
    );
END;
$function$;

-- ============================================================================
-- Also fix edit_store_shift to use company timezone when p_timezone is NULL
-- ============================================================================

CREATE OR REPLACE FUNCTION public.edit_store_shift(
  p_shift_id uuid,
  p_shift_name text DEFAULT NULL::text,
  p_start_time text DEFAULT NULL::text,
  p_end_time text DEFAULT NULL::text,
  p_number_shift integer DEFAULT NULL::integer,
  p_is_can_overtime boolean DEFAULT NULL::boolean,
  p_shift_bonus numeric DEFAULT NULL::numeric,
  p_time text DEFAULT NULL::text,
  p_timezone text DEFAULT NULL::text  -- NULL이면 company timezone 자동 조회
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
/*
=============================================================================
FUNCTION: edit_store_shift
DESCRIPTION: Edit store shift settings. Only updates fields that are provided (non-NULL).
=============================================================================

PARAMETERS:
---------------------------------------------------------------------------
| Parameter         | Type    | Required | Example                         |
---------------------------------------------------------------------------
| p_shift_id        | uuid    | YES      | 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' |
| p_shift_name      | text    | NO       | 'Morning Shift'                 |
| p_start_time      | text    | NO       | '09:00' (local time, HH:MM)     |
| p_end_time        | text    | NO       | '18:00' (local time, HH:MM)     |
| p_number_shift    | integer | NO       | 3 (required employees)          |
| p_is_can_overtime | boolean | NO       | true / false                    |
| p_shift_bonus     | numeric | NO       | 50000 (bonus amount)            |
| p_time            | text    | NO       | '2025-08-30 14:30:00' (local time) |
| p_timezone        | text    | NO       | NULL → company timezone 자동 조회 |
---------------------------------------------------------------------------

TIME CONVERSION (FIXED - 2026-01-25):
---------------------------------------------------------------------------
- p_timezone이 NULL이면 shift → store → company → timezone 조회하여 사용
- p_start_time, p_end_time: Local time → UTC
  변환 방식: ('2000-01-01 ' || p_start_time)::timestamp AT TIME ZONE v_timezone
  예시: '14:00' (베트남 +7) → '07:00:00+00' (UTC)
---------------------------------------------------------------------------
*/
DECLARE
  v_affected_rows int;
  v_timezone text;
BEGIN
  -- Validate shift_id
  IF p_shift_id IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Invalid shift_id',
      'error_code', 'INVALID_PARAM'
    );
  END IF;

  -- Get timezone: use p_timezone if provided, otherwise get from company
  IF p_timezone IS NOT NULL THEN
    v_timezone := p_timezone;
  ELSE
    SELECT COALESCE(c.timezone, 'UTC')
    INTO v_timezone
    FROM store_shifts ss
    JOIN stores s ON ss.store_id = s.store_id
    JOIN companies c ON s.company_id = c.company_id
    WHERE ss.shift_id = p_shift_id;

    -- Fallback if shift not found
    IF v_timezone IS NULL THEN
      v_timezone := 'UTC';
    END IF;
  END IF;

  -- Update store_shifts (only non-NULL parameters)
  UPDATE store_shifts
  SET
    shift_name = COALESCE(p_shift_name, shift_name),
    -- 올바른 UTC 변환 + company timezone 사용
    start_time_utc = CASE
      WHEN p_start_time IS NOT NULL THEN (('2000-01-01 ' || p_start_time)::timestamp AT TIME ZONE v_timezone)::timetz
      ELSE start_time_utc
    END,
    end_time_utc = CASE
      WHEN p_end_time IS NOT NULL THEN (('2000-01-01 ' || p_end_time)::timestamp AT TIME ZONE v_timezone)::timetz
      ELSE end_time_utc
    END,
    number_shift = COALESCE(p_number_shift, number_shift),
    is_can_overtime = COALESCE(p_is_can_overtime, is_can_overtime),
    shift_bonus = COALESCE(p_shift_bonus, shift_bonus),
    updated_at_utc = CASE
      WHEN p_time IS NOT NULL THEN (p_time::timestamp AT TIME ZONE v_timezone)
      ELSE NOW() AT TIME ZONE 'UTC'
    END
  WHERE shift_id = p_shift_id;

  GET DIAGNOSTICS v_affected_rows = ROW_COUNT;

  -- Check if any row was updated
  IF v_affected_rows = 0 THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Shift not found',
      'error_code', 'NOT_FOUND'
    );
  END IF;

  -- Success
  RETURN json_build_object(
    'success', true,
    'message', 'Shift updated successfully'
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'message', SQLERRM,
      'error_code', SQLSTATE
    );
END;
$function$;
