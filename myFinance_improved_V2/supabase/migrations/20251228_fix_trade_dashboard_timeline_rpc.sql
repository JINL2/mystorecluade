-- Fix trade_dashboard_timeline RPC function with correct column names
-- trade_activity_logs 테이블 컬럼: log_id (not id), action (not action_type),
-- action_detail (not action_description), created_by (not performed_by), created_at_utc (not performed_at)

CREATE OR REPLACE FUNCTION trade_dashboard_timeline(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_entity_type VARCHAR DEFAULT NULL,
  p_entity_id UUID DEFAULT NULL,
  p_limit INT DEFAULT 20
) RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER
AS $$
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
      AND (p_store_id IS NULL OR store_id = p_store_id)
      AND (p_entity_type IS NULL OR entity_type = p_entity_type)
      AND (p_entity_id IS NULL OR entity_id = p_entity_id)
    ORDER BY created_at_utc DESC
    LIMIT p_limit
  ) sub;

  RETURN jsonb_build_object('success', true, 'data', v_timeline);
END;
$$;
