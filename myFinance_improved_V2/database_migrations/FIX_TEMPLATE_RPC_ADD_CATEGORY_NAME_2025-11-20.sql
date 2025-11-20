-- Migration: Add category_name to report_get_available_templates_with_status RPC function
-- Date: 2025-11-20
-- Purpose: Add category_name field to templates RPC for UI display (matching received reports)

-- Step 1: Drop existing function (needed because we're changing return type)
DROP FUNCTION IF EXISTS public.report_get_available_templates_with_status(uuid, uuid);

-- Step 2: Create function with category_name field
CREATE OR REPLACE FUNCTION report_get_available_templates_with_status(
  p_user_id uuid,
  p_company_id uuid
)
RETURNS TABLE (
  -- Template fields
  template_id uuid,
  template_name varchar,
  template_code varchar,
  description text,
  frequency varchar,
  icon varchar,
  display_order int,
  default_schedule_time time,
  default_schedule_days jsonb,
  default_monthly_day int,
  category_id uuid,
  category_name varchar,  -- ✅ Added

  -- Subscription status
  is_subscribed boolean,
  subscription_id uuid,
  subscription_enabled boolean,
  subscription_schedule_time time,
  subscription_schedule_days jsonb,
  subscription_monthly_send_day int,
  subscription_timezone varchar,
  subscription_last_sent_at timestamptz,
  subscription_next_scheduled_at timestamptz,
  subscription_created_at timestamptz,

  -- Store information (if subscription is store-specific)
  store_id uuid,
  store_name varchar,

  -- Recent report stats (last 30 days)
  recent_reports_count int,
  last_report_date date,
  last_report_status varchar
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    -- Template fields
    rt.template_id,
    rt.template_name,
    rt.template_code,
    rt.description,
    rt.frequency,
    rt.icon,
    rt.display_order,
    rt.default_schedule_time,
    rt.default_schedule_days,
    rt.default_monthly_day,
    rt.category_id,
    c.name as category_name,  -- ✅ Added from categories table

    -- Subscription status
    (rus.subscription_id IS NOT NULL) as is_subscribed,
    rus.subscription_id,
    rus.enabled as subscription_enabled,
    rus.schedule_time as subscription_schedule_time,
    rus.schedule_days as subscription_schedule_days,
    rus.monthly_send_day as subscription_monthly_send_day,
    rus.timezone as subscription_timezone,
    rus.last_sent_at as subscription_last_sent_at,
    rus.next_scheduled_at as subscription_next_scheduled_at,
    rus.created_at as subscription_created_at,

    -- Store information
    rus.store_id,
    s.store_name,

    -- Recent report stats
    COALESCE(recent_stats.report_count, 0)::int as recent_reports_count,
    recent_stats.last_report_date,
    recent_stats.last_report_status

  FROM report_templates rt

  -- ✅ Added JOIN with categories table
  LEFT JOIN categories c
    ON c.category_id = rt.category_id

  -- Left join with user subscriptions
  LEFT JOIN report_users_subscription rus
    ON rus.template_id = rt.template_id
    AND rus.user_id = p_user_id
    AND rus.company_id = p_company_id

  -- Left join with stores
  LEFT JOIN stores s
    ON s.store_id = rus.store_id

  -- Subquery for recent report statistics (last 30 days)
  LEFT JOIN LATERAL (
    SELECT
      COUNT(*)::int as report_count,
      MAX((n.data->>'report_date')::date) as last_report_date,
      (SELECT rgs.status
       FROM report_generation_sessions rgs
       WHERE rgs.session_id = (
         SELECT (data->>'session_id')::uuid
         FROM notifications
         WHERE user_id = p_user_id
           AND category = 'report'
           AND (data->>'template_id')::uuid = rt.template_id
         ORDER BY created_at DESC
         LIMIT 1
       )
       LIMIT 1
      ) as last_report_status
    FROM notifications n
    WHERE n.user_id = p_user_id
      AND n.category = 'report'
      AND (n.data->>'template_id')::uuid = rt.template_id
      AND n.created_at >= NOW() - INTERVAL '30 days'
  ) recent_stats ON true

  WHERE rt.is_active = true

  ORDER BY rt.display_order, rt.template_name;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION report_get_available_templates_with_status(uuid, uuid) TO authenticated;

-- Add comment
COMMENT ON FUNCTION report_get_available_templates_with_status(uuid, uuid) IS
'Get all available report templates with user subscription status and category_name for UI display';
