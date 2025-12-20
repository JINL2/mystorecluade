-- Add closes_next_day column to store_business_hours
-- This flag indicates if the closing time is on the next day (overnight business)
-- e.g., open 10:00, close 01:00 (next day) -> closes_next_day = true

ALTER TABLE store_business_hours
ADD COLUMN IF NOT EXISTS closes_next_day BOOLEAN DEFAULT FALSE;

-- Add comment for documentation
COMMENT ON COLUMN store_business_hours.closes_next_day IS 'True if close_time is on the next calendar day (overnight operation)';

-- Drop existing functions first to allow signature changes
DROP FUNCTION IF EXISTS upsert_store_business_hours(UUID, JSONB);
DROP FUNCTION IF EXISTS get_store_business_hours(UUID);

-- Update the upsert RPC to handle closes_next_day
CREATE OR REPLACE FUNCTION upsert_store_business_hours(
  p_store_id UUID,
  p_hours JSONB
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_hour JSONB;
BEGIN
  -- Validate store access
  IF NOT EXISTS (
    SELECT 1 FROM stores
    WHERE store_id = p_store_id
    AND company_id IN (
      SELECT company_id FROM user_companies
      WHERE user_id = auth.uid()
    )
  ) THEN
    RAISE EXCEPTION 'Access denied to store';
  END IF;

  -- Upsert each day's hours
  FOR v_hour IN SELECT * FROM jsonb_array_elements(p_hours)
  LOOP
    INSERT INTO store_business_hours (
      store_id,
      day_of_week,
      is_open,
      open_time,
      close_time,
      closes_next_day,
      updated_at
    ) VALUES (
      p_store_id,
      (v_hour->>'day_of_week')::INTEGER,
      COALESCE((v_hour->>'is_open')::BOOLEAN, true),
      (v_hour->>'open_time')::TIME,
      (v_hour->>'close_time')::TIME,
      COALESCE((v_hour->>'closes_next_day')::BOOLEAN, false),
      NOW()
    )
    ON CONFLICT (store_id, day_of_week)
    DO UPDATE SET
      is_open = COALESCE((v_hour->>'is_open')::BOOLEAN, true),
      open_time = (v_hour->>'open_time')::TIME,
      close_time = (v_hour->>'close_time')::TIME,
      closes_next_day = COALESCE((v_hour->>'closes_next_day')::BOOLEAN, false),
      updated_at = NOW();
  END LOOP;

  RETURN TRUE;
END;
$$;

-- Update the get RPC to return closes_next_day
CREATE OR REPLACE FUNCTION get_store_business_hours(p_store_id UUID)
RETURNS TABLE (
  day_of_week INTEGER,
  is_open BOOLEAN,
  open_time TIME,
  close_time TIME,
  closes_next_day BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Validate store access
  IF NOT EXISTS (
    SELECT 1 FROM stores
    WHERE store_id = p_store_id
    AND company_id IN (
      SELECT company_id FROM user_companies
      WHERE user_id = auth.uid()
    )
  ) THEN
    RAISE EXCEPTION 'Access denied to store';
  END IF;

  RETURN QUERY
  SELECT
    sbh.day_of_week,
    sbh.is_open,
    sbh.open_time,
    sbh.close_time,
    COALESCE(sbh.closes_next_day, false) as closes_next_day
  FROM store_business_hours sbh
  WHERE sbh.store_id = p_store_id
  ORDER BY sbh.day_of_week;
END;
$$;
