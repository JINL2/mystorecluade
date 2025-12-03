-- ============================================================================
-- Migration: Optimize Report Content Loading
-- Date: 2025-12-03
-- Description:
--   1. 목록 조회 시 content 제외 (가벼운 쿼리)
--   2. 상세 조회용 RPC 추가 (session_id로 content만 가져오기)
-- ============================================================================

-- ============================================================================
-- 1. 기존 RPC 수정: content 제외
-- ============================================================================
CREATE OR REPLACE FUNCTION public.report_get_user_received_reports(
  p_user_id uuid,
  p_company_id uuid DEFAULT NULL::uuid,
  p_limit integer DEFAULT 50,
  p_offset integer DEFAULT 0
)
RETURNS TABLE(
  notification_id uuid,
  title text,
  body text,  -- body는 빈 문자열로 반환 (호환성 유지)
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
AS $function$
BEGIN
  RETURN QUERY
  SELECT
    n.id as notification_id,
    n.title,
    ''::text as body,  -- ✅ content를 제외하고 빈 문자열 반환 (목록용)
    n.is_read,
    n.sent_at,
    n.created_at,
    (n.data->>'report_date')::date as report_date,
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
$function$;

-- ============================================================================
-- 2. 새 RPC 생성: session_id로 content 가져오기
-- ============================================================================
CREATE OR REPLACE FUNCTION public.report_get_session_content(
  p_session_id uuid,
  p_user_id uuid  -- 보안: 해당 유저만 접근 가능하도록
)
RETURNS TABLE(
  session_id uuid,
  template_id uuid,
  template_code character varying,
  report_date date,
  content text,
  status character varying,
  error_message text
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
  -- 보안 체크: 해당 유저가 접근 권한이 있는지 확인
  -- (notification을 통해 session에 접근 권한이 있는지 확인)
  IF NOT EXISTS (
    SELECT 1
    FROM notifications n
    WHERE n.user_id = p_user_id
      AND n.category = 'report'
      AND n.data->>'session_id' = p_session_id::text
  ) THEN
    RAISE EXCEPTION 'Access denied: User does not have permission to access this session';
  END IF;

  RETURN QUERY
  SELECT
    rgs.session_id,
    rgs.template_id,
    rt.template_code,
    rgs.report_date,
    rgs.content,
    rgs.status,
    rgs.error_message
  FROM report_generation_sessions rgs
  LEFT JOIN report_templates rt ON rt.template_id = rgs.template_id
  WHERE rgs.session_id = p_session_id;
END;
$function$;

-- ============================================================================
-- 주석
-- ============================================================================
COMMENT ON FUNCTION public.report_get_user_received_reports IS
'리포트 목록 조회용 - content를 제외하고 메타데이터만 반환 (성능 최적화)';

COMMENT ON FUNCTION public.report_get_session_content IS
'리포트 상세 조회용 - session_id로 content만 가져오기 (보안 체크 포함)';
