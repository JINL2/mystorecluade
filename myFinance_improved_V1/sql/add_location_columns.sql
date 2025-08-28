-- ============================================================================
-- Add location columns to shift_requests table if they don't exist
-- ============================================================================

-- Add checkin location columns
ALTER TABLE shift_requests 
ADD COLUMN IF NOT EXISTS checkin_lat DOUBLE PRECISION;

ALTER TABLE shift_requests 
ADD COLUMN IF NOT EXISTS checkin_lng DOUBLE PRECISION;

-- Add checkout location columns  
ALTER TABLE shift_requests
ADD COLUMN IF NOT EXISTS checkout_lat DOUBLE PRECISION;

ALTER TABLE shift_requests
ADD COLUMN IF NOT EXISTS checkout_lng DOUBLE PRECISION;

-- Add location columns for PostGIS (if extension is available)
-- Uncomment these if PostGIS extension is installed
-- ALTER TABLE shift_requests 
-- ADD COLUMN IF NOT EXISTS checkin_location GEOGRAPHY(POINT, 4326);
-- 
-- ALTER TABLE shift_requests
-- ADD COLUMN IF NOT EXISTS checkout_location GEOGRAPHY(POINT, 4326);

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_shift_requests_user_store_date 
ON shift_requests(user_id, store_id, request_date);

CREATE INDEX IF NOT EXISTS idx_shift_requests_status 
ON shift_requests(status) 
WHERE status = 'approved';

-- Add comment
COMMENT ON COLUMN shift_requests.checkin_lat IS 'Latitude of check-in location from QR scan';
COMMENT ON COLUMN shift_requests.checkin_lng IS 'Longitude of check-in location from QR scan';
COMMENT ON COLUMN shift_requests.checkout_lat IS 'Latitude of check-out location from QR scan';
COMMENT ON COLUMN shift_requests.checkout_lng IS 'Longitude of check-out location from QR scan';