-- Migration: Change schedule_time column to time with time zone
-- Date: 2025-11-20
-- Purpose: Store time with timezone information for proper UTC/Local conversion

-- Step 1: Alter report_templates table
ALTER TABLE report_templates
ALTER COLUMN default_schedule_time TYPE time with time zone
USING default_schedule_time::time with time zone;

-- Step 2: Alter report_users_subscription table
ALTER TABLE report_users_subscription
ALTER COLUMN schedule_time TYPE time with time zone
USING schedule_time::time with time zone;

-- Step 3: Update the subscribe function to use time with time zone
DROP FUNCTION IF EXISTS public.report_subscribe_to_template CASCADE;

CREATE OR REPLACE FUNCTION report_subscribe_to_template(
  p_user_id uuid,
  p_company_id uuid,
  p_store_id uuid DEFAULT NULL,
  p_template_id uuid,
  p_subscription_name varchar DEFAULT NULL,
  p_schedule_time time with time zone DEFAULT NULL,
  p_schedule_days integer[] DEFAULT NULL,
  p_monthly_send_day integer DEFAULT NULL,
  p_timezone varchar DEFAULT 'UTC',
  p_notification_channels varchar[] DEFAULT ARRAY['in_app']
)
RETURNS TABLE (
  subscription_id uuid,
  template_id uuid,
  template_name varchar,
  schedule_time time with time zone,
  schedule_days integer[],
  monthly_send_day integer,
  next_scheduled_at timestamptz,
  created_at timestamptz
) AS $$
DECLARE
  v_subscription_id uuid;
  v_template_name varchar;
  v_default_schedule_time time with time zone;
  v_default_schedule_days integer[];
  v_default_monthly_day integer;
BEGIN
  -- Get template defaults
  SELECT
    rt.template_name,
    rt.default_schedule_time,
    rt.default_schedule_days,
    rt.default_monthly_day
  INTO
    v_template_name,
    v_default_schedule_time,
    v_default_schedule_days,
    v_default_monthly_day
  FROM report_templates rt
  WHERE rt.template_id = p_template_id
    AND rt.is_active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Template not found or inactive: %', p_template_id;
  END IF;

  -- Insert subscription
  INSERT INTO report_users_subscription (
    user_id,
    company_id,
    store_id,
    template_id,
    subscription_name,
    schedule_time,
    schedule_days,
    monthly_send_day,
    timezone,
    notification_channels,
    enabled
  ) VALUES (
    p_user_id,
    p_company_id,
    p_store_id,
    p_template_id,
    COALESCE(p_subscription_name, v_template_name),
    COALESCE(p_schedule_time, v_default_schedule_time),
    COALESCE(p_schedule_days, v_default_schedule_days),
    COALESCE(p_monthly_send_day, v_default_monthly_day),
    p_timezone,
    p_notification_channels,
    true
  )
  RETURNING report_users_subscription.subscription_id INTO v_subscription_id;

  -- Return subscription details
  RETURN QUERY
  SELECT
    rus.subscription_id,
    rus.template_id,
    v_template_name as template_name,
    rus.schedule_time,
    rus.schedule_days,
    rus.monthly_send_day,
    rus.next_scheduled_at,
    rus.created_at
  FROM report_users_subscription rus
  WHERE rus.subscription_id = v_subscription_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION report_subscribe_to_template TO authenticated;

-- Step 4: Update the update subscription function
DROP FUNCTION IF EXISTS public.report_update_subscription CASCADE;

CREATE OR REPLACE FUNCTION report_update_subscription(
  p_subscription_id uuid,
  p_user_id uuid,
  p_enabled boolean DEFAULT NULL,
  p_schedule_time time with time zone DEFAULT NULL,
  p_schedule_days integer[] DEFAULT NULL,
  p_monthly_send_day integer DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
  v_row_count integer;
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

  GET DIAGNOSTICS v_row_count = ROW_COUNT;

  RETURN v_row_count > 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION report_update_subscription TO authenticated;

COMMENT ON FUNCTION report_update_subscription IS 'Update report subscription settings with time zone support';
