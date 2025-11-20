-- ============================================================================
-- Report Control - Category & Date Filtering
-- Created: 2025-11-20
-- Description: Enhanced RPC functions for filtering reports by category and date
-- ============================================================================

-- ============================================================================
-- 1. Get Report Categories with Statistics
-- ============================================================================
-- Purpose: Get all categories with report counts for the current user
-- Returns: Category list with count of reports in each
-- ============================================================================

CREATE OR REPLACE FUNCTION report_get_categories_with_stats(
  p_user_id uuid,
  p_company_id uuid,
  p_start_date date DEFAULT NULL,
  p_end_date date DEFAULT NULL
)
RETURNS TABLE (
  category_id uuid,
  category_name varchar,
  category_icon varchar,
  template_count int,
  report_count bigint,
  unread_count bigint,
  latest_report_date timestamptz
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.category_id,
    c.name as category_name,
    c.icon as category_icon,
    COUNT(DISTINCT rt.template_id)::int as template_count,
    COUNT(n.id) as report_count,
    COUNT(n.id) FILTER (WHERE n.is_read = false) as unread_count,
    MAX(n.created_at) as latest_report_date
  FROM categories c
  INNER JOIN report_templates rt ON rt.category_id = c.category_id AND rt.is_active = true
  LEFT JOIN notifications n ON
    n.category = 'report'
    AND (n.data->>'template_id')::uuid = rt.template_id
    AND n.user_id = p_user_id
    AND (p_start_date IS NULL OR (n.data->>'report_date')::date >= p_start_date)
    AND (p_end_date IS NULL OR (n.data->>'report_date')::date <= p_end_date)
  GROUP BY c.category_id, c.name, c.icon
  HAVING COUNT(n.id) > 0
  ORDER BY c.name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_get_categories_with_stats IS 'Get report categories with statistics for filtering';

-- ============================================================================
-- 2. Enhanced Get User Received Reports with Category & Date Filtering
-- ============================================================================
-- Purpose: Filter reports by category and date range
-- Returns: Filtered report list
-- ============================================================================

CREATE OR REPLACE FUNCTION report_get_user_received_reports_filtered(
  p_user_id uuid,
  p_company_id uuid DEFAULT NULL,
  p_category_id uuid DEFAULT NULL,
  p_start_date date DEFAULT NULL,
  p_end_date date DEFAULT NULL,
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

  -- Category information
  category_id uuid,
  category_name varchar,

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

    -- Category information
    rt.category_id,
    c.name as category_name,

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

  -- Join with categories
  LEFT JOIN categories c
    ON c.category_id = rt.category_id

  -- Join with generation sessions for status AND full content
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
    -- ✅ Category filter
    AND (p_category_id IS NULL OR rt.category_id = p_category_id)
    -- ✅ Date range filter
    AND (p_start_date IS NULL OR (n.data->>'report_date')::date >= p_start_date)
    AND (p_end_date IS NULL OR (n.data->>'report_date')::date <= p_end_date)

  ORDER BY n.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION report_get_user_received_reports_filtered IS 'Get filtered reports by category and date range with full content';

-- ============================================================================
-- Grant Permissions
-- ============================================================================

GRANT EXECUTE ON FUNCTION report_get_categories_with_stats TO authenticated;
GRANT EXECUTE ON FUNCTION report_get_user_received_reports_filtered TO authenticated;

-- ============================================================================
-- END OF FILE
-- ============================================================================
