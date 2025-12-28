-- ============================================================================
-- Migration: Fix trade_dashboard_timeline store_id filter
-- Version: 1.0
-- Created: 2025-12-28
-- Problem: Records with store_id = NULL are excluded when p_store_id is provided
-- Solution: Include records where store_id matches OR store_id IS NULL
-- ============================================================================

CREATE OR REPLACE FUNCTION public.trade_dashboard_timeline(
  p_company_id uuid,
  p_store_id uuid DEFAULT NULL::uuid,
  p_entity_type text DEFAULT NULL::text,
  p_entity_id uuid DEFAULT NULL::uuid,
  p_limit integer DEFAULT 20
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_timeline JSONB;
BEGIN
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', log_id,
      'entity_type', entity_type,
      'entity_id', entity_id,
      'entity_number', entity_number,
      'action', action,
      'action_detail', action_detail,
      'previous_status', previous_status,
      'new_status', new_status,
      'user_id', created_by,
      'created_at', created_at_utc
    ) ORDER BY created_at_utc DESC
  ), '[]'::jsonb)
  INTO v_timeline
  FROM (
    SELECT log_id, entity_type, entity_id, entity_number, action, action_detail,
           previous_status, new_status, created_by, created_at_utc
    FROM trade_activity_logs
    WHERE company_id = p_company_id
      -- Include records that match store_id OR have NULL store_id
      AND (p_store_id IS NULL OR store_id = p_store_id OR store_id IS NULL)
      AND (p_entity_type IS NULL OR entity_type = p_entity_type)
      AND (p_entity_id IS NULL OR entity_id = p_entity_id)
    ORDER BY created_at_utc DESC
    LIMIT p_limit
  ) sub;

  RETURN jsonb_build_object('success', true, 'data', v_timeline);
END;
$function$;

-- Also fix trade_activity_log_list if it exists
CREATE OR REPLACE FUNCTION public.trade_activity_log_list(
  p_company_id uuid,
  p_store_id uuid DEFAULT NULL::uuid,
  p_entity_type text DEFAULT NULL::text,
  p_entity_id uuid DEFAULT NULL::uuid,
  p_action text DEFAULT NULL::text,
  p_page integer DEFAULT 1,
  p_page_size integer DEFAULT 20
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
  v_offset INTEGER;
  v_logs JSONB;
  v_total_count INTEGER;
BEGIN
  v_offset := (p_page - 1) * p_page_size;

  -- Get total count
  SELECT COUNT(*)
  INTO v_total_count
  FROM trade_activity_logs
  WHERE company_id = p_company_id
    AND (p_store_id IS NULL OR store_id = p_store_id OR store_id IS NULL)
    AND (p_entity_type IS NULL OR entity_type = p_entity_type)
    AND (p_entity_id IS NULL OR entity_id = p_entity_id)
    AND (p_action IS NULL OR action = p_action);

  -- Get paginated logs
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', log_id,
      'entity_type', entity_type,
      'entity_id', entity_id,
      'entity_number', entity_number,
      'action', action,
      'action_detail', action_detail,
      'previous_status', previous_status,
      'new_status', new_status,
      'user_id', created_by,
      'created_at', created_at_utc
    ) ORDER BY created_at_utc DESC
  ), '[]'::jsonb)
  INTO v_logs
  FROM (
    SELECT log_id, entity_type, entity_id, entity_number, action, action_detail,
           previous_status, new_status, created_by, created_at_utc
    FROM trade_activity_logs
    WHERE company_id = p_company_id
      AND (p_store_id IS NULL OR store_id = p_store_id OR store_id IS NULL)
      AND (p_entity_type IS NULL OR entity_type = p_entity_type)
      AND (p_entity_id IS NULL OR entity_id = p_entity_id)
      AND (p_action IS NULL OR action = p_action)
    ORDER BY created_at_utc DESC
    LIMIT p_page_size
    OFFSET v_offset
  ) sub;

  RETURN jsonb_build_object(
    'success', true,
    'data', v_logs,
    'pagination', jsonb_build_object(
      'page', p_page,
      'page_size', p_page_size,
      'total_count', v_total_count,
      'total_pages', CEIL(v_total_count::DECIMAL / p_page_size)
    )
  );
END;
$function$;
