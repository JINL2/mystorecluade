-- Fix: Find first shift with check-in when building chain
--
-- Problem: Current logic stops at first shift without check-in.
--          But we need to find the FIRST shift WITH check-in in the continuous chain.
--
-- Example:
--   Morning (no checkin) → Noon (no checkin) → Afternoon (checkin) → Evening (checkout attempt)
--
--   Current wrong behavior:
--     Evening ← Afternoon (has checkin, add) ← Noon (no checkin, STOP)
--     Chain = [Afternoon, Evening] - this is actually correct by accident
--
--   But if user tries to checkout from Afternoon directly:
--     Afternoon ← Noon (no checkin, STOP)
--     Chain = [Afternoon] - single shift, needs check-in validation
--
-- New logic:
--   1. Build full continuous chain backward (regardless of check-in status)
--   2. Find first shift WITH check-in in the chain
--   3. Trim chain to start from that shift
--   4. If no shift has check-in, treat as single shift

CREATE OR REPLACE FUNCTION update_shift_requests_v7(
  p_shift_request_id uuid,
  p_user_id uuid,
  p_store_id uuid,
  p_time timestamp,
  p_lat double precision,
  p_lng double precision,
  p_timezone text
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_current_shift RECORD;
  v_prev_shift RECORD;
  v_chain_shift RECORD;
  v_full_chain uuid[];
  v_continuous_chain uuid[];
  v_first_shift RECORD;
  v_location geography;
  v_chain_length int;
  v_time_utc timestamptz;
  v_shift_bonus numeric;
  v_first_checkin_idx int;
  i int;
BEGIN
  -- Convert local time to UTC
  v_time_utc := (p_time AT TIME ZONE p_timezone);

  -- Create location geography
  IF p_lat IS NOT NULL AND p_lng IS NOT NULL THEN
    v_location := ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography;
  END IF;

  -- Step 1: Get current shift info
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
  -- Include ALL continuous shifts regardless of check-in status
  v_full_chain := ARRAY[p_shift_request_id];

  LOOP
    SELECT * INTO v_prev_shift
    FROM shift_requests
    WHERE user_id = p_user_id
      AND store_id = p_store_id
      AND is_approved = TRUE
      AND end_time_utc = (
        SELECT start_time_utc
        FROM shift_requests
        WHERE shift_request_id = v_full_chain[1]
      )
      AND shift_request_id != ALL(v_full_chain);

    IF v_prev_shift.shift_request_id IS NULL THEN
      EXIT; -- No more continuous shifts
    END IF;

    -- Prepend to chain (include regardless of check-in)
    v_full_chain := v_prev_shift.shift_request_id || v_full_chain;
  END LOOP;

  -- Step 3: Find first shift WITH check-in in the full chain
  v_first_checkin_idx := NULL;

  FOR i IN 1..array_length(v_full_chain, 1) LOOP
    SELECT * INTO v_chain_shift
    FROM shift_requests
    WHERE shift_request_id = v_full_chain[i];

    IF v_chain_shift.actual_start_time_utc IS NOT NULL OR v_chain_shift.confirm_start_time_utc IS NOT NULL THEN
      v_first_checkin_idx := i;
      EXIT; -- Found first shift with check-in
    END IF;
  END LOOP;

  -- Step 4: Trim chain to start from first check-in shift
  IF v_first_checkin_idx IS NULL THEN
    -- No shift has check-in → treat as single shift
    v_continuous_chain := ARRAY[p_shift_request_id];
  ELSE
    -- Build chain from first check-in shift to current shift
    v_continuous_chain := v_full_chain[v_first_checkin_idx:array_length(v_full_chain, 1)];
  END IF;

  v_chain_length := array_length(v_continuous_chain, 1);

  -- Case A: Continuous shifts (chain length >= 2)
  IF v_chain_length >= 2 THEN
    -- Get first shift
    SELECT * INTO v_first_shift
    FROM shift_requests
    WHERE shift_request_id = v_continuous_chain[1];

    -- Validation 1: First shift must have check-in record
    IF v_first_shift.actual_start_time_utc IS NULL AND v_first_shift.confirm_start_time_utc IS NULL THEN
      RETURN json_build_object('status', 'error', 'message', 'first_shift_no_checkin');
    END IF;

    -- Validation 2: First shift must not have check-out record
    IF v_first_shift.actual_end_time_utc IS NOT NULL THEN
      RETURN json_build_object('status', 'error', 'message', 'first_shift_already_checkout');
    END IF;

    -- Validation 3: Remaining shifts must not have check-in record
    FOR i IN 2..v_chain_length LOOP
      SELECT * INTO v_chain_shift
      FROM shift_requests
      WHERE shift_request_id = v_continuous_chain[i];

      IF v_chain_shift.actual_start_time_utc IS NOT NULL OR v_chain_shift.confirm_start_time_utc IS NOT NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'chain_shift_already_checkin');
      END IF;
    END LOOP;

    -- All validations passed → Process check-out

    -- First shift: actual_end_time_utc = end_time_utc
    SELECT shift_bonus INTO v_shift_bonus
    FROM store_shifts
    WHERE shift_id = v_first_shift.shift_id;

    UPDATE shift_requests SET
      actual_end_time_utc = end_time_utc,
      checkout_location_v2 = v_location,
      bonus_amount_v2 = COALESCE(bonus_amount_v2, 0) + COALESCE(v_shift_bonus, 0)
    WHERE shift_request_id = v_continuous_chain[1];

    -- Middle shifts (2 ~ N-1)
    FOR i IN 2..(v_chain_length - 1) LOOP
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

    -- Last shift (requested)
    SELECT shift_bonus INTO v_shift_bonus
    FROM store_shifts
    WHERE shift_id = v_current_shift.shift_id;

    UPDATE shift_requests SET
      actual_start_time_utc = start_time_utc,
      actual_end_time_utc = v_time_utc,
      checkout_location_v2 = v_location,
      bonus_amount_v2 = COALESCE(bonus_amount_v2, 0) + COALESCE(v_shift_bonus, 0)
    WHERE shift_request_id = v_continuous_chain[v_chain_length];

    RETURN json_build_object('status', 'check_out', 'message', 'chain_checkout_completed', 'chain_length', v_chain_length);

  -- Case B: Single shift
  ELSE
    -- Check for check-in record
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
        -- Check-out process
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
