-- Create update_shift_requests_v6_original_logic function
-- This is the core check-in/check-out logic called by update_shift_requests_v6
--
-- Purpose: Handle simple same-day check-in/check-out operations
-- Called when user scans QR within safe zone of today's shift

CREATE OR REPLACE FUNCTION update_shift_requests_v6_original_logic(
  p_user_id uuid,
  p_store_id uuid,
  p_time text,
  p_lat double precision,
  p_lng double precision,
  p_timezone text
)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  v_request_date date;
  v_shift RECORD;
  v_shift_bonus numeric;
  v_action text;
BEGIN
  -- Extract date from p_time using timezone
  v_request_date := DATE((p_time::timestamptz) AT TIME ZONE p_timezone);

  -- Find today's shifts in order of start_time
  FOR v_shift IN
    SELECT * FROM shift_requests
    WHERE user_id = p_user_id
      AND store_id = p_store_id
      AND DATE(request_time AT TIME ZONE p_timezone) = v_request_date
      AND is_approved = TRUE
    ORDER BY start_time ASC
  LOOP
    -- Case 1: Shift not started yet → Check-in
    IF v_shift.actual_start_time_utc IS NULL THEN
      UPDATE shift_requests SET
        actual_start_time_utc = p_time::timestamptz,
        checkin_location_v2 = CASE WHEN p_lat IS NOT NULL AND p_lng IS NOT NULL THEN
          ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography
          ELSE checkin_location_v2 END
      WHERE shift_request_id = v_shift.shift_request_id;

      v_action := 'check_in';
      RETURN v_action;

    -- Case 2: Shift started but not ended → Check-out
    ELSIF v_shift.actual_end_time_utc IS NULL THEN
      UPDATE shift_requests SET
        actual_end_time_utc = p_time::timestamptz,
        checkout_location_v2 = CASE WHEN p_lat IS NOT NULL AND p_lng IS NOT NULL THEN
          ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography
          ELSE checkout_location_v2 END
      WHERE shift_request_id = v_shift.shift_request_id;

      -- Apply shift bonus on checkout
      SELECT shift_bonus INTO v_shift_bonus
      FROM store_shifts
      WHERE shift_id = v_shift.shift_id;

      UPDATE shift_requests SET
        bonus_amount_v2 = COALESCE(bonus_amount_v2, 0) + COALESCE(v_shift_bonus, 0)
      WHERE shift_request_id = v_shift.shift_request_id;

      v_action := 'check_out';
      RETURN v_action;
    END IF;

    -- If this shift is complete, continue to next shift
  END LOOP;

  -- If all shifts are complete, return check_out
  -- (user might be scanning after completing all shifts)
  RETURN 'check_out';

END;
$$;

-- Add comment
COMMENT ON FUNCTION update_shift_requests_v6_original_logic IS
'Core check-in/check-out logic for same-day shift operations. Called by update_shift_requests_v6 when user scans within safe zone.';
