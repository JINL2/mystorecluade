-- Migration: Fix UUID validation in report_get_user_received_reports
-- Date: 2025-11-24
-- Issue: Invalid subscription_id values like "test-cash-location-001" cause UUID conversion errors

-- Drop old function if exists
DROP FUNCTION IF EXISTS public.report_get_user_received_reports(uuid, uuid, integer, integer);

-- Create updated function with UUID validation
CREATE OR REPLACE FUNCTION public.report_get_user_received_reports(
  p_user_id uuid,
  p_company_id uuid DEFAULT NULL,
  p_limit integer DEFAULT 50,
  p_offset integer DEFAULT 0
)
RETURNS TABLE(
  notification_id uuid,
  title text,
  body text,
  is_read boolean,
  sent_at timestamp with time zone,
  created_at timestamp with time zone,
  report_date date,
  session_id uuid,
  template_id uuid,
  subscription_id uuid,
  template_name character varying,
  template_code character varying,
  template_icon character varying,
  template_frequency character varying,
  category_id uuid,
  category_name character varying,
  session_status character varying,
  session_started_at timestamp with time zone,
  session_completed_at timestamp with time zone,
  session_error_message text,
  processing_time_ms integer,
  subscription_enabled boolean,
  subscription_schedule_time time without time zone,
  subscription_schedule_days jsonb,
  store_id uuid,
  store_name character varying
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    n.id as notification_id,
    n.title,
    COALESCE(rgs.content, n.body) as body,
    n.is_read,
    n.sent_at,
    n.created_at,
    (n.data->>'report_date')::date as report_date,
    -- ✅ UUID 변환 실패 시 NULL 반환 (정규식으로 UUID 형식 검증)
    CASE
      WHEN n.data->>'session_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
      THEN (n.data->>'session_id')::uuid
      ELSE NULL
    END as session_id,
    CASE
      WHEN n.data->>'template_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
      THEN (n.data->>'template_id')::uuid
      ELSE NULL
    END as template_id,
    CASE
      WHEN n.data->>'subscription_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
      THEN (n.data->>'subscription_id')::uuid
      ELSE NULL
    END as subscription_id,
    rt.template_name,
    rt.template_code,
    rt.icon as template_icon,
    rt.frequency as template_frequency,
    rt.category_id,
    c.name as category_name,
    rgs.status as session_status,
    rgs.started_at as session_started_at,
    rgs.completed_at as session_completed_at,
    rgs.error_message as session_error_message,
    rgs.processing_time_ms,
    rus.enabled as subscription_enabled,
    rus.schedule_time as subscription_schedule_time,
    rus.schedule_days as subscription_schedule_days,
    COALESCE(rgs.store_id, rus.store_id) as store_id,
    s.store_name
  FROM notifications n
  LEFT JOIN report_templates rt ON rt.template_id = (
    CASE
      WHEN n.data->>'template_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
      THEN (n.data->>'template_id')::uuid
      ELSE NULL
    END
  )
  LEFT JOIN categories c ON c.category_id = rt.category_id
  LEFT JOIN report_generation_sessions rgs ON rgs.session_id = (
    CASE
      WHEN n.data->>'session_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
      THEN (n.data->>'session_id')::uuid
      ELSE NULL
    END
  )
  LEFT JOIN report_users_subscription rus ON rus.subscription_id = (
    CASE
      WHEN n.data->>'subscription_id' ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
      THEN (n.data->>'subscription_id')::uuid
      ELSE NULL
    END
  )
  LEFT JOIN stores s ON s.store_id = COALESCE(rgs.store_id, rus.store_id)
  WHERE n.user_id = p_user_id
    AND n.category = 'report'
    AND (p_company_id IS NULL OR rgs.company_id = p_company_id OR rus.company_id = p_company_id)
  ORDER BY n.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.report_get_user_received_reports(uuid, uuid, integer, integer) TO authenticated;

COMMENT ON FUNCTION public.report_get_user_received_reports IS 'Get user received reports with UUID validation to handle invalid test data';
