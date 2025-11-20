-- Migration: Fix variable type in report_update_subscription
-- Date: 2025-11-20
-- Purpose: Fix "operator does not exist: boolean > integer" error by using correct variable type for ROW_COUNT

-- Step 1: Drop ALL existing overloads by OID (using function ID, not name)
DO $$
DECLARE
    func_oid oid;
    func_signature text;
BEGIN
    FOR func_oid, func_signature IN
        SELECT
            p.oid,
            p.proname || '(' || pg_get_function_identity_arguments(p.oid) || ')' as signature
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
          AND p.proname = 'report_update_subscription'
    LOOP
        -- Drop by OID (safer than by name)
        EXECUTE format('DROP FUNCTION %s CASCADE', func_oid::regprocedure);
        RAISE NOTICE 'Dropped function by OID: %s (signature: %s)', func_oid, func_signature;
    END LOOP;
END $$;

-- Step 2: Create function with correct variable type and proper time type
CREATE OR REPLACE FUNCTION report_update_subscription(
  p_subscription_id uuid,
  p_user_id uuid,
  p_enabled boolean DEFAULT NULL,
  p_schedule_time time DEFAULT NULL,  -- ✅ Changed varchar to time
  p_schedule_days jsonb DEFAULT NULL,  -- ✅ Changed integer[] to jsonb to match DB column
  p_monthly_send_day integer DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
  v_row_count integer;  -- ✅ Changed from boolean to integer (ROW_COUNT returns integer)
BEGIN
  UPDATE report_users_subscription
  SET
    enabled = COALESCE(p_enabled, enabled),
    schedule_time = COALESCE(p_schedule_time, schedule_time),  -- ✅ No casting needed
    schedule_days = COALESCE(p_schedule_days, schedule_days),  -- ✅ No casting needed (jsonb = jsonb)
    monthly_send_day = COALESCE(p_monthly_send_day, monthly_send_day),
    updated_at = NOW()
  WHERE subscription_id = p_subscription_id
    AND user_id = p_user_id;

  GET DIAGNOSTICS v_row_count = ROW_COUNT;  -- ✅ Store ROW_COUNT as integer

  RETURN v_row_count > 0;  -- ✅ Compare integer > integer (returns boolean)
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION report_update_subscription(uuid, uuid, boolean, time, jsonb, integer) TO authenticated;

-- Add comment
COMMENT ON FUNCTION report_update_subscription IS 'Update report subscription settings (time, days, enabled status)';
