-- Migration: Fix report_get_user_received_reports to include category fields
-- Date: 2025-11-20
-- Issue: categoryId is null in all reports, causing filter functionality to fail
-- Solution: Add category_id and category_name to RPC return columns and JOIN with categories table

-- Step 1: Drop existing function (needed because we're changing return type)
DROP FUNCTION IF EXISTS public.report_get_user_received_reports(uuid, uuid, integer, integer);

-- Step 2: Create function with category fields
CREATE OR REPLACE FUNCTION public.report_get_user_received_reports(
  p_user_id uuid,
  p_company_id uuid DEFAULT NULL::uuid,
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
  category_id uuid,  -- ✅ Added
  category_name character varying,  -- ✅ Added
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
AS $function$
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
    (n.data->>'session_id')::uuid as session_id,
    (n.data->>'template_id')::uuid as template_id,
    (n.data->>'subscription_id')::uuid as subscription_id,
    rt.template_name,
    rt.template_code,
    rt.icon as template_icon,
    rt.frequency as template_frequency,
    rt.category_id,  -- ✅ Added from report_templates
    c.name as category_name,  -- ✅ Added from categories
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
  LEFT JOIN report_templates rt ON rt.template_id = (n.data->>'template_id')::uuid
  LEFT JOIN categories c ON c.category_id = rt.category_id  -- ✅ Added JOIN
  LEFT JOIN report_generation_sessions rgs ON rgs.session_id = (n.data->>'session_id')::uuid
  LEFT JOIN report_users_subscription rus ON rus.subscription_id = (n.data->>'subscription_id')::uuid
  LEFT JOIN stores s ON s.store_id = COALESCE(rgs.store_id, rus.store_id)
  WHERE n.user_id = p_user_id
    AND n.category = 'report'
    AND (p_company_id IS NULL OR rgs.company_id = p_company_id OR rus.company_id = p_company_id)
  ORDER BY n.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$function$;

-- Verification query to test the fix
-- SELECT category_id, category_name, template_name, COUNT(*)
-- FROM report_get_user_received_reports('YOUR_USER_ID'::uuid, 'YOUR_COMPANY_ID'::uuid)
-- GROUP BY category_id, category_name, template_name;
