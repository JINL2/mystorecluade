-- ============================================================================
-- Report Control RPC Functions
-- Created: 2025-11-20
-- Description: Efficient RPC functions for Report Control feature
-- Feature ID: 982fe5d5-d4d6-42bb-b8a7-cc653aa67a48
-- ============================================================================

-- ============================================================================
-- 1. Get User's Received Reports with Full Details
-- ============================================================================
-- Purpose: Fetch all reports received by a user with template info and generation status
-- Returns: Complete report list with filtering support on client side
-- ============================================================================

CREATE OR REPLACE FUNCTION report_get_user_received_reports(
  p_user_id uuid,
  p_company_id uuid DEFAULT NULL,
  p_limit int DEFAULT 50,
  p_offset int DEFAULT 0
)
RETURNS TABLE (
  -- Notification fields
  notification_id uuid,
  title text,
  body text,
  is_read boolean,
  sent_at timestamptz,
  created_at timestamptz,

  -- Report details from data jsonb
  report_date date,
  session_id uuid,
  template_id uuid,
  subscription_id uuid,

  -- Template information
  template_name varchar,
  template_code varchar,
  template_icon varchar,
  template_frequency varchar,

  -- Generation session status
  session_status varchar,
  session_started_at timestamptz,
  session_completed_at timestamptz,
  session_error_message text,
  processing_time_ms int,

  -- Subscription information
  subscription_enabled boolean,
  subscription_schedule_time time,
  subscription_schedule_days jsonb,

  -- Store information (if applicable)
  store_id uuid,
  store_name varchar
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    -- Notification fields
    n.id as notification_id,
    n.title,
    -- ✅ Use full report content from report_generation_sessions instead of truncated notifications.body
    COALESCE(rgs.content, n.body) as body,
    n.is_read,
    n.sent_at,
    n.created_at,

    -- Report details
    (n.data->>'report_date')::date as report_date,
    (n.data->>'session_id')::uuid as session_id,
    (n.data->>'template_id')::uuid as template_id,
    (n.data->>'subscription_id')::uuid as subscription_id,

    -- Template information
    rt.template_name,
    rt.template_code,
    rt.icon as template_icon,
    rt.frequency as template_frequency,

    -- Generation session status
    rgs.status as session_status,
    rgs.started_at as session_started_at,
    rgs.completed_at as session_completed_at,
    rgs.error_message as session_error_message,
    rgs.processing_time_ms,

    -- Subscription information
    rus.enabled as subscription_enabled,
    rus.schedule_time as subscription_schedule_time,
    rus.schedule_days as subscription_schedule_days,

    -- Store information
    COALESCE(rgs.store_id, rus.store_id) as store_id,
    s.store_name

  FROM notifications n

  -- Join with report templates
  LEFT JOIN report_templates rt
    ON rt.template_id = (n.data->>'template_id')::uuid

  -- Join with generation sessions for status
  LEFT JOIN report_generation_sessions rgs
    ON rgs.session_id = (n.data->>'session_id')::uuid

  -- Join with subscriptions for settings
  LEFT JOIN report_users_subscription rus
    ON rus.subscription_id = (n.data->>'subscription_id')::uuid

  -- Join with stores for store names
  LEFT JOIN stores s
    ON s.store_id = COALESCE(rgs.store_id, rus.store_id)

  WHERE n.user_id = p_user_id
    AND n.category = 'report'
    AND (p_company_id IS NULL OR rgs.company_id = p_company_id OR rus.company_id = p_company_id)

  ORDER BY n.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_get_user_received_reports IS 'Get all reports received by a user with complete details for filtering';


-- ============================================================================
-- 2. Get Available Report Templates with User Subscription Status
-- ============================================================================
-- Purpose: Fetch all active report templates and show which ones user is subscribed to
-- Returns: Complete template list with subscription status for UI filtering
-- ============================================================================

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

COMMENT ON FUNCTION report_get_available_templates_with_status IS 'Get all active report templates with user subscription status and recent stats';


-- ============================================================================
-- 3. Get Report Statistics for User Dashboard
-- ============================================================================
-- Purpose: Provide summary statistics for user's report activity
-- Returns: Counts and stats for dashboard widgets
-- ============================================================================

CREATE OR REPLACE FUNCTION report_get_user_statistics(
  p_user_id uuid,
  p_company_id uuid
)
RETURNS TABLE (
  total_subscriptions int,
  active_subscriptions int,
  total_reports_received int,
  unread_reports int,
  reports_last_7_days int,
  reports_last_30_days int,
  failed_reports_count int,
  pending_reports_count int
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    -- Subscription counts
    COUNT(DISTINCT rus.subscription_id)::int as total_subscriptions,
    COUNT(DISTINCT CASE WHEN rus.enabled = true THEN rus.subscription_id END)::int as active_subscriptions,

    -- Report counts
    COUNT(DISTINCT n.id)::int as total_reports_received,
    COUNT(DISTINCT CASE WHEN n.is_read = false THEN n.id END)::int as unread_reports,
    COUNT(DISTINCT CASE WHEN n.created_at >= NOW() - INTERVAL '7 days' THEN n.id END)::int as reports_last_7_days,
    COUNT(DISTINCT CASE WHEN n.created_at >= NOW() - INTERVAL '30 days' THEN n.id END)::int as reports_last_30_days,

    -- Status counts
    COUNT(DISTINCT CASE
      WHEN rgs.status = 'failed' AND rgs.created_at >= NOW() - INTERVAL '30 days'
      THEN rgs.session_id
    END)::int as failed_reports_count,
    COUNT(DISTINCT CASE
      WHEN rgs.status IN ('pending', 'processing')
      THEN rgs.session_id
    END)::int as pending_reports_count

  FROM report_users_subscription rus

  LEFT JOIN notifications n
    ON n.user_id = p_user_id
    AND n.category = 'report'
    AND (n.data->>'subscription_id')::uuid = rus.subscription_id

  LEFT JOIN report_generation_sessions rgs
    ON rgs.session_id = (n.data->>'session_id')::uuid

  WHERE rus.user_id = p_user_id
    AND rus.company_id = p_company_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_get_user_statistics IS 'Get summary statistics for user report dashboard';


-- ============================================================================
-- 4. Mark Report as Read
-- ============================================================================
-- Purpose: Update notification read status
-- Returns: Success boolean
-- ============================================================================

CREATE OR REPLACE FUNCTION report_mark_as_read(
  p_notification_id uuid,
  p_user_id uuid
)
RETURNS boolean AS $$
DECLARE
  v_row_count int;
BEGIN
  UPDATE notifications
  SET
    is_read = true,
    read_at = NOW(),
    updated_at = NOW()
  WHERE id = p_notification_id
    AND user_id = p_user_id
    AND category = 'report';

  GET DIAGNOSTICS v_row_count = ROW_COUNT;

  RETURN v_row_count > 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_mark_as_read IS 'Mark a report notification as read';


-- ============================================================================
-- 5. Subscribe to Report Template
-- ============================================================================
-- Purpose: Create a new subscription for a user
-- Returns: The created subscription
-- ============================================================================

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

  -- Get template defaults
  SELECT
    template_name,
    default_schedule_time,
    default_schedule_days,
    default_monthly_day
  INTO
    v_template_name,
    v_default_schedule_time,
    v_default_schedule_days,
    v_default_monthly_day
  FROM report_templates
  WHERE template_id = p_template_id
    AND is_active = true;

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

COMMENT ON FUNCTION report_subscribe_to_template IS 'Create a new report subscription';


-- ============================================================================
-- 6. Update Report Subscription
-- ============================================================================
-- Purpose: Update subscription settings
-- Returns: Success boolean
-- ============================================================================

CREATE OR REPLACE FUNCTION report_update_subscription(
  p_subscription_id uuid,
  p_user_id uuid,
  p_enabled boolean DEFAULT NULL,
  p_schedule_time time DEFAULT NULL,
  p_schedule_days jsonb DEFAULT NULL,
  p_monthly_send_day int DEFAULT NULL,
  p_timezone varchar DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
  v_updated boolean;
BEGIN
  UPDATE report_users_subscription
  SET
    enabled = COALESCE(p_enabled, enabled),
    schedule_time = COALESCE(p_schedule_time, schedule_time),
    schedule_days = COALESCE(p_schedule_days, schedule_days),
    monthly_send_day = COALESCE(p_monthly_send_day, monthly_send_day),
    timezone = COALESCE(p_timezone, timezone),
    updated_at = NOW()
  WHERE subscription_id = p_subscription_id
    AND user_id = p_user_id;

  GET DIAGNOSTICS v_updated = ROW_COUNT;

  RETURN v_updated > 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_update_subscription IS 'Update report subscription settings';


-- ============================================================================
-- 7. Unsubscribe from Report
-- ============================================================================
-- Purpose: Delete a subscription
-- Returns: Success boolean
-- ============================================================================

CREATE OR REPLACE FUNCTION report_unsubscribe_from_template(
  p_subscription_id uuid,
  p_user_id uuid
)
RETURNS boolean AS $$
DECLARE
  v_deleted boolean;
BEGIN
  DELETE FROM report_users_subscription
  WHERE subscription_id = p_subscription_id
    AND user_id = p_user_id;

  GET DIAGNOSTICS v_deleted = ROW_COUNT;

  RETURN v_deleted > 0;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_unsubscribe_from_template IS 'Delete a report subscription';


-- ============================================================================
-- 8. Get Report Template Categories (for filtering)
-- ============================================================================
-- Purpose: Get all report categories for filter dropdown
-- Returns: Category list
-- ============================================================================

CREATE OR REPLACE FUNCTION report_get_template_categories()
RETURNS TABLE (
  category_id uuid,
  category_name varchar,
  template_count int
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.category_id,
    c.category_name,
    COUNT(rt.template_id)::int as template_count
  FROM categories c
  INNER JOIN report_templates rt ON rt.category_id = c.category_id
  WHERE rt.is_active = true
  GROUP BY c.category_id, c.category_name
  ORDER BY c.category_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_get_template_categories IS 'Get all report template categories for filtering';


-- ============================================================================
-- Grant Permissions
-- ============================================================================

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION report_get_user_received_reports TO authenticated;
GRANT EXECUTE ON FUNCTION report_get_available_templates_with_status TO authenticated;
GRANT EXECUTE ON FUNCTION report_get_user_statistics TO authenticated;
GRANT EXECUTE ON FUNCTION report_mark_as_read TO authenticated;
GRANT EXECUTE ON FUNCTION report_subscribe_to_template TO authenticated;
GRANT EXECUTE ON FUNCTION report_update_subscription TO authenticated;
GRANT EXECUTE ON FUNCTION report_unsubscribe_from_template TO authenticated;
GRANT EXECUTE ON FUNCTION report_get_template_categories TO authenticated;


-- ============================================================================
-- END OF FILE
-- ============================================================================
