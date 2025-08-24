-- Function to update store location
-- This function updates the store_location field in the stores table
-- It accepts latitude and longitude and creates a PostGIS GEOGRAPHY point

CREATE OR REPLACE FUNCTION update_store_location(
  p_store_id UUID,
  p_store_lat DOUBLE PRECISION,
  p_store_lng DOUBLE PRECISION
) RETURNS VOID AS $$
BEGIN
  -- Update the store location using PostGIS ST_MakePoint
  -- PostGIS stores coordinates as (longitude, latitude) in GEOGRAPHY type
  UPDATE stores
  SET 
    store_location = ST_SetSRID(ST_MakePoint(p_store_lng, p_store_lat), 4326)::geography,
    updated_at = NOW()
  WHERE store_id = p_store_id;
  
  -- Check if the update was successful
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Store with ID % not found', p_store_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION update_store_location(UUID, DOUBLE PRECISION, DOUBLE PRECISION) TO authenticated;

-- Add comment for documentation
COMMENT ON FUNCTION update_store_location IS 'Updates the GPS location of a store for use in employee check-in/out validation';