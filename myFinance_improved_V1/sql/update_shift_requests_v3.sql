-- ============================================================================
-- RPC Function: update_shift_requests_v3
-- Purpose: Update shift request check-in/check-out via QR scan
-- Parameters:
--   p_user_id: UUID of the user
--   p_store_id: UUID of the store
--   p_request_date: Date in YYYY-MM-DD format
--   p_time: Timestamp of the scan
--   p_lat: Latitude of scan location
--   p_lng: Longitude of scan location
-- ============================================================================

CREATE OR REPLACE FUNCTION public.update_shift_requests_v3(
  p_user_id UUID,
  p_store_id UUID,
  p_request_date DATE,
  p_time TIMESTAMP,
  p_lat DOUBLE PRECISION,
  p_lng DOUBLE PRECISION
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_shift_request RECORD;
  v_result JSON;
  v_action TEXT;
  v_location_point GEOGRAPHY;
BEGIN
  -- Create a geography point from lat/lng
  v_location_point := ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)::geography;
  
  -- Find the shift request for this user, store, and date
  SELECT 
    sr.shift_request_id,
    sr.actual_start_time,
    sr.actual_end_time,
    sr.status,
    ss.start_time as scheduled_start,
    ss.end_time as scheduled_end
  INTO v_shift_request
  FROM shift_requests sr
  JOIN store_shifts ss ON sr.store_shift_id = ss.store_shift_id
  WHERE sr.user_id = p_user_id
    AND sr.store_id = p_store_id
    AND sr.request_date = p_request_date
    AND sr.status = 'approved'
  ORDER BY ss.start_time
  LIMIT 1;
  
  -- Check if shift request exists
  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'No approved shift found for this date',
      'action', null
    );
  END IF;
  
  -- Determine if this is check-in or check-out
  IF v_shift_request.actual_start_time IS NULL THEN
    -- This is a check-in
    v_action := 'check_in';
    
    -- Update the shift request with check-in time and location
    UPDATE shift_requests
    SET 
      actual_start_time = p_time,
      checkin_location = v_location_point,
      updated_at = NOW()
    WHERE shift_request_id = v_shift_request.shift_request_id;
    
  ELSIF v_shift_request.actual_end_time IS NULL THEN
    -- This is a check-out
    v_action := 'check_out';
    
    -- Update the shift request with check-out time and location
    UPDATE shift_requests
    SET 
      actual_end_time = p_time,
      checkout_location = v_location_point,
      updated_at = NOW()
    WHERE shift_request_id = v_shift_request.shift_request_id;
    
  ELSE
    -- Both check-in and check-out already done
    RETURN json_build_object(
      'success', false,
      'error', 'Shift already completed',
      'action', null,
      'actual_start_time', v_shift_request.actual_start_time,
      'actual_end_time', v_shift_request.actual_end_time
    );
  END IF;
  
  -- Return success response
  RETURN json_build_object(
    'success', true,
    'action', v_action,
    'shift_request_id', v_shift_request.shift_request_id,
    'timestamp', p_time,
    'location', json_build_object(
      'lat', p_lat,
      'lng', p_lng
    )
  );
  
EXCEPTION
  WHEN OTHERS THEN
    -- Log error and return error response
    RAISE WARNING 'Error in update_shift_requests_v3: %', SQLERRM;
    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'action', null
    );
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.update_shift_requests_v3(UUID, UUID, DATE, TIMESTAMP, DOUBLE PRECISION, DOUBLE PRECISION) TO authenticated;

-- Add comment
COMMENT ON FUNCTION public.update_shift_requests_v3(UUID, UUID, DATE, TIMESTAMP, DOUBLE PRECISION, DOUBLE PRECISION) IS 
'Updates shift request check-in or check-out based on QR code scan. Automatically determines whether to check in or check out based on current shift status.';