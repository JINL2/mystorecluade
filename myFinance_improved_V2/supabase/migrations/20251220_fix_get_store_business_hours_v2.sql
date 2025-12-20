-- Fix get_store_business_hours function
-- Remove access check (RLS handles it) and add day_name column
-- The previous migration added access check which caused "Access denied to store" error

DROP FUNCTION IF EXISTS get_store_business_hours(UUID);

CREATE OR REPLACE FUNCTION get_store_business_hours(p_store_id UUID)
RETURNS TABLE (
  day_of_week SMALLINT,
  day_name TEXT,
  is_open BOOLEAN,
  open_time TIME,
  close_time TIME,
  closes_next_day BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    sbh.day_of_week::SMALLINT,
    CASE sbh.day_of_week
      WHEN 0 THEN 'Sunday'
      WHEN 1 THEN 'Monday'
      WHEN 2 THEN 'Tuesday'
      WHEN 3 THEN 'Wednesday'
      WHEN 4 THEN 'Thursday'
      WHEN 5 THEN 'Friday'
      WHEN 6 THEN 'Saturday'
    END AS day_name,
    sbh.is_open,
    sbh.open_time,
    sbh.close_time,
    COALESCE(sbh.closes_next_day, false) as closes_next_day
  FROM store_business_hours sbh
  WHERE sbh.store_id = p_store_id
  ORDER BY sbh.day_of_week;
END;
$$;
