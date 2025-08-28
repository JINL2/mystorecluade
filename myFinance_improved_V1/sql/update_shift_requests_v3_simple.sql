-- ============================================================================
-- RPC Function: update_shift_requests_v3 (Simplified Version)
-- Purpose: Update shift request check-in/check-out via QR scan
-- This version stores location as simple lat/lng instead of geography type
-- ============================================================================

CREATE OR REPLACE FUNCTION public.update_shift_requests_v3(
  p_user_id UUID,
  p_store_id UUID,
  p_request_date DATE,
  p_time TEXT,  -- Accept as TEXT to handle various timestamp formats
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
  v_timestamp TIMESTAMP;
BEGIN
  -- Convert text timestamp to proper timestamp
  BEGIN
    v_timestamp := p_time::TIMESTAMP;
  EXCEPTION WHEN OTHERS THEN
    -- Try parsing as ISO 8601
    v_timestamp := p_time::TIMESTAMP WITH TIME ZONE AT TIME ZONE 'UTC';
  END;
  
  -- Find the shift request for this user, store, and date
  SELECT 
    sr.shift_request_id,
    sr.actual_start_time,
    sr.actual_end_time,
    sr.status
  INTO v_shift_request
  FROM shift_requests sr
  WHERE sr.user_id = p_user_id
    AND sr.store_id = p_store_id
    AND sr.request_date = p_request_date
    AND sr.status = 'approved'
  LIMIT 1;
  
  -- Check if shift request exists
  IF NOT FOUND THEN
    -- Try to find any shift request for debugging
    SELECT COUNT(*) INTO v_shift_request 
    FROM shift_requests 
    WHERE user_id = p_user_id 
      AND store_id = p_store_id 
      AND request_date = p_request_date;
      
    IF v_shift_request.count > 0 THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Shift exists but not approved',
        'action', null
      );
    ELSE
      RETURN json_build_object(
        'success', false,
        'error', 'No shift found for this date',
        'action', null
      );
    END IF;
  END IF;
  
  -- Determine if this is check-in or check-out
  IF v_shift_request.actual_start_time IS NULL THEN
    -- This is a check-in
    v_action := 'check_in';
    
    -- Update the shift request with check-in time
    UPDATE shift_requests
    SET 
      actual_start_time = v_timestamp,
      checkin_lat = p_lat,
      checkin_lng = p_lng,
      updated_at = NOW()
    WHERE shift_request_id = v_shift_request.shift_request_id;
    
  ELSIF v_shift_request.actual_end_time IS NULL THEN
    -- This is a check-out
    v_action := 'check_out';
    
    -- Update the shift request with check-out time
    UPDATE shift_requests
    SET 
      actual_end_time = v_timestamp,
      checkout_lat = p_lat,
      checkout_lng = p_lng,
      updated_at = NOW()
    WHERE shift_request_id = v_shift_request.shift_request_id;
    
  ELSE
    -- Both check-in and check-out already done
    RETURN json_build_object(
      'success', true,
      'error', 'Shift already completed',
      'action', 'already_completed',
      'actual_start_time', v_shift_request.actual_start_time,
      'actual_end_time', v_shift_request.actual_end_time
    );
  END IF;
  
  -- Return success response
  RETURN json_build_object(
    'success', true,
    'action', v_action,
    'shift_request_id', v_shift_request.shift_request_id,
    'timestamp', v_timestamp,
    'location', json_build_object(
      'lat', p_lat,
      'lng', p_lng
    )
  );
  
EXCEPTION
  WHEN OTHERS THEN
    -- Return detailed error for debugging
    RETURN json_build_object(
      'success', false,
      'error', 'Database error: ' || SQLERRM,
      'action', null,
      'detail', SQLSTATE
    );
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.update_shift_requests_v3 TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_shift_requests_v3 TO anon;

-- Add helpful comment
COMMENT ON FUNCTION public.update_shift_requests_v3 IS 
'QR scan attendance function. Automatically handles check-in/check-out based on shift status. Returns JSON with action performed.';