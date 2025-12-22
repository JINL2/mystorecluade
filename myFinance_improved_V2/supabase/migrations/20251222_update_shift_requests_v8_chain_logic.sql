-- ============================================================================
-- Migration: update_shift_requests_v8 - Improved Chain Checkout Logic
-- ============================================================================
--
-- Changes from v7:
-- 1. Backward chain detection no longer stops at shifts without check-in
-- 2. Finds the first checked-in shift in the chain
-- 3. Processes from checked-in shift to requested shift
--
-- Chain Logic:
-- - Receive shift_request_id (e.g., S5)
-- - Backward trace: S5 → S4 → S3 → S2 → S1 (by end_time = start_time, 1 min tolerance)
-- - Find first shift with actual_start_time (e.g., S3)
-- - Checkout S3 to S5 only
--
-- Edge Cases:
-- - No check-in found → error
-- - Already checked out → error
-- - Non-continuous shifts → single shift processing
-- ============================================================================

CREATE OR REPLACE FUNCTION update_shift_requests_v8(
  p_shift_request_id uuid,
  p_user_id uuid,
  p_store_id uuid,
  p_time timestamp,
  p_lat double precision,
  p_lng double precision,
  p_timezone text
) RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_current_shift RECORD;
  v_prev_shift RECORD;
  v_chain_shift RECORD;
  v_continuous_chain uuid[];
  v_checkin_shift RECORD;
  v_checkin_index int;
  v_location geography;
  v_chain_length int;
  v_time_utc timestamptz;
  v_shift_bonus numeric;
  i int;
BEGIN
  -- Convert local time to UTC
  v_time_utc := (p_time AT TIME ZONE p_timezone);

  -- Create location geography
  IF p_lat IS NOT NULL AND p_lng IS NOT NULL THEN
    v_location := ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography;
  END IF;

  -- Step 1: Get requested shift info
  SELECT * INTO v_current_shift
  FROM shift_requests
  WHERE shift_request_id = p_shift_request_id
    AND user_id = p_user_id
    AND store_id = p_store_id
    AND is_approved = TRUE;

  IF v_current_shift.shift_request_id IS NULL THEN
    RETURN json_build_object('status', 'error', 'message', 'shift_not_found');
  END IF;

  -- Step 2: Build FULL continuous shift chain (backward direction)
  -- Do NOT stop at shifts without check-in - trace the entire chain
  v_continuous_chain := ARRAY[p_shift_request_id];

  LOOP
    SELECT * INTO v_prev_shift
    FROM shift_requests
    WHERE user_id = p_user_id
      AND store_id = p_store_id
      AND is_approved = TRUE
      AND shift_request_id != ALL(v_continuous_chain)
      -- Match end_time = start_time with 1 minute tolerance
      AND ABS(EXTRACT(EPOCH FROM (
        end_time_utc - (
          SELECT start_time_utc
          FROM shift_requests
          WHERE shift_request_id = v_continuous_chain[1]
        )
      ))) <= 60;

    IF v_prev_shift.shift_request_id IS NULL THEN
      EXIT; -- No more continuous shifts
    END IF;

    -- Prepend to chain (oldest first)
    v_continuous_chain := v_prev_shift.shift_request_id || v_continuous_chain;
  END LOOP;

  v_chain_length := array_length(v_continuous_chain, 1);

  -- Step 3: Find the first shift with check-in record in the chain
  v_checkin_index := NULL;

  FOR i IN 1..v_chain_length LOOP
    SELECT * INTO v_chain_shift
    FROM shift_requests
    WHERE shift_request_id = v_continuous_chain[i];

    IF v_chain_shift.actual_start_time_utc IS NOT NULL OR v_chain_shift.confirm_start_time_utc IS NOT NULL THEN
      -- Found checked-in shift
      v_checkin_shift := v_chain_shift;
      v_checkin_index := i;
      EXIT;
    END IF;
  END LOOP;

  -- Step 4: Determine action based on chain and check-in status

  -- Case A: Chain with check-in found (continuous checkout)
  IF v_chain_length >= 2 AND v_checkin_index IS NOT NULL THEN

    -- Validation: Check-in shift must not have checkout
    IF v_checkin_shift.actual_end_time_utc IS NOT NULL OR v_checkin_shift.confirm_end_time_utc IS NOT NULL THEN
      RETURN json_build_object('status', 'error', 'message', 'checkin_shift_already_completed');
    END IF;

    -- Validation: Shifts between checkin and requested must not have individual check-in
    FOR i IN (v_checkin_index + 1)..v_chain_length LOOP
      SELECT * INTO v_chain_shift
      FROM shift_requests
      WHERE shift_request_id = v_continuous_chain[i];

      IF v_chain_shift.actual_start_time_utc IS NOT NULL OR v_chain_shift.confirm_start_time_utc IS NOT NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'chain_shift_has_separate_checkin');
      END IF;
    END LOOP;

    -- Process checkout for checkin_shift to requested_shift

    -- First shift (checkin_shift): actual_end_time = shift's end_time
    SELECT shift_bonus INTO v_shift_bonus
    FROM store_shifts
    WHERE shift_id = v_checkin_shift.shift_id;

    UPDATE shift_requests SET
      actual_end_time_utc = end_time_utc,
      checkout_location_v2 = v_location,
      bonus_amount_v2 = COALESCE(bonus_amount_v2, 0) + COALESCE(v_shift_bonus, 0)
    WHERE shift_request_id = v_continuous_chain[v_checkin_index];

    -- Middle shifts: actual_start = start_time, actual_end = end_time
    FOR i IN (v_checkin_index + 1)..(v_chain_length - 1) LOOP
      SELECT * INTO v_chain_shift
      FROM shift_requests
      WHERE shift_request_id = v_continuous_chain[i];

      SELECT shift_bonus INTO v_shift_bonus
      FROM store_shifts
      WHERE shift_id = v_chain_shift.shift_id;

      UPDATE shift_requests SET
        actual_start_time_utc = start_time_utc,
        actual_end_time_utc = end_time_utc,
        checkout_location_v2 = v_location,
        bonus_amount_v2 = COALESCE(bonus_amount_v2, 0) + COALESCE(v_shift_bonus, 0)
      WHERE shift_request_id = v_continuous_chain[i];
    END LOOP;

    -- Last shift (requested): actual_start = start_time, actual_end = actual scan time
    IF v_checkin_index < v_chain_length THEN
      SELECT shift_bonus INTO v_shift_bonus
      FROM store_shifts
      WHERE shift_id = v_current_shift.shift_id;

      UPDATE shift_requests SET
        actual_start_time_utc = start_time_utc,
        actual_end_time_utc = v_time_utc,
        checkout_location_v2 = v_location,
        bonus_amount_v2 = COALESCE(bonus_amount_v2, 0) + COALESCE(v_shift_bonus, 0)
      WHERE shift_request_id = v_continuous_chain[v_chain_length];
    END IF;

    RETURN json_build_object(
      'status', 'check_out',
      'message', 'chain_checkout_completed',
      'chain_length', v_chain_length,
      'processed_from_index', v_checkin_index,
      'processed_count', v_chain_length - v_checkin_index + 1
    );

  -- Case B: Single shift processing
  ELSE
    -- Check for check-in record on current shift
    IF v_current_shift.actual_start_time_utc IS NULL AND v_current_shift.confirm_start_time_utc IS NULL THEN
      -- Check-in process
      UPDATE shift_requests SET
        actual_start_time_utc = v_time_utc,
        checkin_location_v2 = v_location
      WHERE shift_request_id = p_shift_request_id;

      RETURN json_build_object('status', 'attend', 'message', 'checkin_completed');

    ELSE
      -- Check for check-out record
      IF v_current_shift.actual_end_time_utc IS NOT NULL OR v_current_shift.confirm_end_time_utc IS NOT NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'shift_already_completed');
      ELSE
        -- Check-out process (with bonus)
        SELECT shift_bonus INTO v_shift_bonus
        FROM store_shifts
        WHERE shift_id = v_current_shift.shift_id;

        UPDATE shift_requests SET
          actual_end_time_utc = v_time_utc,
          checkout_location_v2 = v_location,
          bonus_amount_v2 = COALESCE(bonus_amount_v2, 0) + COALESCE(v_shift_bonus, 0)
        WHERE shift_request_id = p_shift_request_id;

        RETURN json_build_object('status', 'check_out', 'message', 'checkout_completed');
      END IF;
    END IF;
  END IF;

END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION update_shift_requests_v8(uuid, uuid, uuid, timestamp, double precision, double precision, text) TO authenticated;

-- Add comment
COMMENT ON FUNCTION update_shift_requests_v8 IS 'v8: Improved chain checkout - traces full chain backward, finds first checked-in shift, processes from there to requested shift';
