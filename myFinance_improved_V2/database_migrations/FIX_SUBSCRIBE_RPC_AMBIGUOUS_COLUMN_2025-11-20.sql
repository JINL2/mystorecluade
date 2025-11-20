-- Migration: Fix ambiguous column reference in report_subscribe_to_template
-- Date: 2025-11-20
-- Purpose: Fix "column reference template_name is ambiguous" error by adding table alias

-- Step 1: Drop existing function
DROP FUNCTION IF EXISTS public.report_subscribe_to_template(uuid, uuid, uuid, uuid, varchar, time, jsonb, int, varchar, jsonb);

-- Step 2: Create function with table alias to avoid ambiguity
CREATE OR REPLACE FUNCTION report_subscribe_to_template(
  p_user_id uuid,
  p_company_id uuid,
  p_store_id uuid,
  p_template_id uuid,
  p_subscription_name varchar DEFAULT NULL,
  p_schedule_time time DEFAULT NULL,
  p_schedule_days jsonb DEFAULT NULL,
  p_monthly_send_day int DEFAULT NULL,
  p_timezone varchar DEFAULT 'UTC',
  p_notification_channels jsonb DEFAULT '["push"]'::jsonb
)
RETURNS TABLE (
  subscription_id uuid,
  template_name varchar,
  enabled boolean,
  created_at timestamptz
) AS $$
DECLARE
  v_subscription_id uuid;
  v_template_name varchar;
  v_default_schedule_time time;
  v_default_schedule_days jsonb;
  v_default_monthly_day int;
BEGIN
  -- Generate subscription ID
  v_subscription_id := gen_random_uuid();

  -- Get template defaults (✅ Added 'rt' alias to avoid ambiguity)
  SELECT
    rt.template_name,  -- ✅ Fixed: added rt. prefix
    rt.default_schedule_time,
    rt.default_schedule_days,
    rt.default_monthly_day
  INTO
    v_template_name,
    v_default_schedule_time,
    v_default_schedule_days,
    v_default_monthly_day
  FROM report_templates rt  -- ✅ Fixed: added alias
  WHERE rt.template_id = p_template_id
    AND rt.is_active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Template not found or not active';
  END IF;

  -- Insert subscription
  INSERT INTO report_users_subscription (
    subscription_id,
    user_id,
    company_id,
    store_id,
    template_id,
    subscription_name,
    schedule_time,
    timezone,
    schedule_days,
    monthly_send_day,
    notification_channels,
    enabled,
    created_at,
    updated_at
  ) VALUES (
    v_subscription_id,
    p_user_id,
    p_company_id,
    p_store_id,
    p_template_id,
    COALESCE(p_subscription_name, v_template_name),
    COALESCE(p_schedule_time, v_default_schedule_time),
    p_timezone,
    COALESCE(p_schedule_days, v_default_schedule_days),
    COALESCE(p_monthly_send_day, v_default_monthly_day),
    p_notification_channels,
    true,
    NOW(),
    NOW()
  );

  RETURN QUERY
  SELECT
    v_subscription_id,
    v_template_name,
    true,
    NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION report_subscribe_to_template(uuid, uuid, uuid, uuid, varchar, time, jsonb, int, varchar, jsonb) TO authenticated;

-- Add comment
COMMENT ON FUNCTION report_subscribe_to_template IS 'Create a new report subscription';
