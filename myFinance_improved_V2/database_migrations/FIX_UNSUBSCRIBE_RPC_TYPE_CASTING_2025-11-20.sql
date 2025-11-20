-- Migration: Fix variable type in report_unsubscribe_from_template
-- Date: 2025-11-20
-- Purpose: Fix "operator does not exist: boolean > integer" error by using correct variable type for ROW_COUNT

-- Step 1: Drop existing function
DROP FUNCTION IF EXISTS public.report_unsubscribe_from_template(uuid, uuid);

-- Step 2: Create function with correct variable type
CREATE OR REPLACE FUNCTION report_unsubscribe_from_template(
  p_subscription_id uuid,
  p_user_id uuid
)
RETURNS boolean AS $$
DECLARE
  v_row_count integer;  -- ✅ Changed from boolean to integer (ROW_COUNT returns integer)
BEGIN
  DELETE FROM report_users_subscription
  WHERE subscription_id = p_subscription_id
    AND user_id = p_user_id;

  GET DIAGNOSTICS v_row_count = ROW_COUNT;  -- ✅ Store ROW_COUNT as integer

  RETURN v_row_count > 0;  -- ✅ Compare integer > integer (returns boolean)
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION report_unsubscribe_from_template(uuid, uuid) TO authenticated;

-- Add comment
COMMENT ON FUNCTION report_unsubscribe_from_template IS 'Delete a report subscription with explicit UUID type casting';
