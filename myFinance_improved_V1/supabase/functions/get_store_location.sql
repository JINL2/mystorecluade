-- Function to get store location coordinates
-- This function returns the latitude and longitude from the store_location field

CREATE OR REPLACE FUNCTION get_store_location(p_store_id UUID)
RETURNS TABLE(
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ST_Y(store_location::geometry) AS latitude,
    ST_X(store_location::geometry) AS longitude
  FROM stores
  WHERE store_id = p_store_id
    AND store_location IS NOT NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_store_location(UUID) TO authenticated;

-- Add comment for documentation
COMMENT ON FUNCTION get_store_location IS 'Returns the latitude and longitude of a store location';

-- Alternative: Create a view that includes parsed location data
CREATE OR REPLACE VIEW stores_with_location AS
SELECT 
  s.*,
  CASE 
    WHEN s.store_location IS NOT NULL THEN ST_Y(s.store_location::geometry)
    ELSE NULL
  END AS store_latitude,
  CASE 
    WHEN s.store_location IS NOT NULL THEN ST_X(s.store_location::geometry)
    ELSE NULL
  END AS store_longitude
FROM stores s;

-- Grant select permission to authenticated users
GRANT SELECT ON stores_with_location TO authenticated;

-- Add comment for documentation
COMMENT ON VIEW stores_with_location IS 'View of stores table with parsed latitude and longitude coordinates';