-- Fix trade_alert_list RPC function with correct column names
-- trade_alerts 테이블 컬럼: alert_id (not id), assigned_to (not user_id),
-- dismissed_at_utc (not dismissed_at), created_at_utc (not created_at)

CREATE OR REPLACE FUNCTION trade_alert_list(
  p_company_id UUID,
  p_user_id UUID DEFAULT NULL,
  p_alert_type VARCHAR DEFAULT NULL,
  p_priority VARCHAR DEFAULT NULL,
  p_is_read BOOLEAN DEFAULT NULL,
  p_page INT DEFAULT 1,
  p_page_size INT DEFAULT 20
) RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_offset INT := (p_page - 1) * p_page_size;
  v_total_count INT;
  v_data JSONB;
BEGIN
  SELECT COUNT(*)
  INTO v_total_count
  FROM trade_alerts a
  WHERE a.company_id = p_company_id
    AND (p_user_id IS NULL OR a.assigned_to = p_user_id OR a.assigned_to IS NULL)
    AND (p_alert_type IS NULL OR a.alert_type = p_alert_type)
    AND (p_priority IS NULL OR a.priority = p_priority)
    AND (p_is_read IS NULL OR a.is_read = p_is_read)
    AND a.is_dismissed = false;

  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', a.alert_id,
      'alert_type', a.alert_type,
      'priority', a.priority,
      'title', a.title,
      'message', a.message,
      'entity_type', a.entity_type,
      'entity_id', a.entity_id,
      'is_read', a.is_read,
      'created_at', a.created_at_utc
    ) ORDER BY a.priority DESC, a.created_at_utc DESC
  ), '[]'::jsonb)
  INTO v_data
  FROM trade_alerts a
  WHERE a.company_id = p_company_id
    AND (p_user_id IS NULL OR a.assigned_to = p_user_id OR a.assigned_to IS NULL)
    AND (p_alert_type IS NULL OR a.alert_type = p_alert_type)
    AND (p_priority IS NULL OR a.priority = p_priority)
    AND (p_is_read IS NULL OR a.is_read = p_is_read)
    AND a.is_dismissed = false
  ORDER BY a.priority DESC, a.created_at_utc DESC
  LIMIT p_page_size OFFSET v_offset;

  RETURN jsonb_build_object(
    'success', true,
    'data', v_data,
    'pagination', jsonb_build_object(
      'page', p_page, 'page_size', p_page_size, 'total_count', v_total_count
    )
  );
END;
$$;

-- Fix trade_alert_mark_read RPC function
CREATE OR REPLACE FUNCTION trade_alert_mark_read(
  p_company_id UUID,
  p_alert_id UUID
) RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER
AS $$
BEGIN
  UPDATE trade_alerts SET is_read = true, read_at_utc = NOW()
  WHERE alert_id = p_alert_id AND company_id = p_company_id;

  RETURN jsonb_build_object('success', true, 'data', jsonb_build_object('id', p_alert_id, 'is_read', true));
END;
$$;

-- Fix trade_alert_mark_all_read RPC function
CREATE OR REPLACE FUNCTION trade_alert_mark_all_read(
  p_company_id UUID,
  p_user_id UUID
) RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_count INT;
BEGIN
  WITH updated AS (
    UPDATE trade_alerts SET is_read = true, read_at_utc = NOW()
    WHERE company_id = p_company_id
      AND (assigned_to = p_user_id OR assigned_to IS NULL)
      AND is_read = false
    RETURNING 1
  )
  SELECT COUNT(*) INTO v_count FROM updated;

  RETURN jsonb_build_object('success', true, 'data', jsonb_build_object('marked_count', v_count));
END;
$$;

-- Fix trade_alert_dismiss RPC function
CREATE OR REPLACE FUNCTION trade_alert_dismiss(
  p_company_id UUID,
  p_alert_id UUID
) RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER
AS $$
BEGIN
  UPDATE trade_alerts SET is_dismissed = true, dismissed_at_utc = NOW()
  WHERE alert_id = p_alert_id AND company_id = p_company_id;

  RETURN jsonb_build_object('success', true, 'data', jsonb_build_object('id', p_alert_id, 'dismissed', true));
END;
$$;
