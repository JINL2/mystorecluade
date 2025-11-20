-- Migration: Fix variable type in report_update_subscription
-- Date: 2025-11-20
-- Purpose: Fix "operator does not exist: boolean > integer" error by using correct variable type for ROW_COUNT

-- Step 1: Drop ALL existing overloads of the function
-- We need to drop all possible signature variations
DROP FUNCTION IF EXISTS public.report_update_subscription(uuid, uuid, boolean, varchar, integer[], integer) CASCADE;
DROP FUNCTION IF EXISTS public.report_update_subscription(uuid, uuid, boolean, varchar, integer[]) CASCADE;
DROP FUNCTION IF EXISTS public.report_update_subscription(uuid, uuid, boolean) CASCADE;
DROP FUNCTION IF EXISTS public.report_update_subscription(uuid, uuid) CASCADE;

-- Alternative: Drop by name (removes ALL overloads)
-- Uncomment this line if the above doesn't work:
-- DROP FUNCTION IF EXISTS public.report_update_subscription CASCADE;

-- Step 2: Create function with correct variable type
CREATE OR REPLACE FUNCTION report_update_subscription(
  p_subscription_id uuid,
  p_user_id uuid,
  p_enabled boolean DEFAULT NULL,
  p_schedule_time varchar DEFAULT NULL,
  p_schedule_days integer[] DEFAULT NULL,
  p_monthly_send_day integer DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
  v_row_count integer;  -- ✅ Changed from boolean to integer (ROW_COUNT returns integer)
BEGIN
  UPDATE report_users_subscription
  SET
    enabled = COALESCE(p_enabled, enabled),
    schedule_time = COALESCE(p_schedule_time, schedule_time),
    schedule_days = COALESCE(p_schedule_days, schedule_days),
    monthly_send_day = COALESCE(p_monthly_send_day, monthly_send_day),
    updated_at = NOW()
  WHERE subscription_id = p_subscription_id
    AND user_id = p_user_id;

  GET DIAGNOSTICS v_row_count = ROW_COUNT;  -- ✅ Store ROW_COUNT as integer

  RETURN v_row_count > 0;  -- ✅ Compare integer > integer (returns boolean)
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION report_update_subscription(uuid, uuid, boolean, varchar, integer[], integer) TO authenticated;

-- Add comment
COMMENT ON FUNCTION report_update_subscription IS 'Update report subscription settings (time, days, enabled status)';
