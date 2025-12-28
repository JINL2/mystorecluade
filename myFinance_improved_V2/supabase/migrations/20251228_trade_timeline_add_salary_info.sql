-- Add user salary_type and currency info to trade_dashboard_timeline
-- This migration updates the function to include salary and currency details

-- Drop existing versions
DROP FUNCTION IF EXISTS trade_dashboard_timeline(uuid, uuid, character varying, uuid, integer);
DROP FUNCTION IF EXISTS trade_dashboard_timeline(uuid, uuid, text, uuid, integer);

-- Create updated function with salary_type and currency info
CREATE OR REPLACE FUNCTION trade_dashboard_timeline(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_entity_type TEXT DEFAULT NULL,
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
      'created_at', created_at_utc,
      'salary_type', salary_type,
      'currency_code', currency_code,
      'currency_symbol', currency_symbol
    ) ORDER BY created_at_utc DESC
  ), '[]'::jsonb)
  INTO v_timeline
  FROM (
    SELECT
      tal.log_id,
      tal.entity_type,
      tal.entity_id,
      tal.entity_number,
      tal.action,
      tal.action_detail,
      tal.previous_status,
      tal.new_status,
      tal.created_by,
      tal.created_at_utc,
      us.salary_type,
      ct.currency_code,
      ct.symbol AS currency_symbol
    FROM trade_activity_logs tal
    LEFT JOIN user_salaries us
      ON us.user_id = tal.created_by
      AND us.company_id = tal.company_id
    LEFT JOIN currency_types ct
      ON ct.currency_id = us.currency_id
    WHERE tal.company_id = p_company_id
      AND (p_store_id IS NULL OR tal.store_id = p_store_id)
      AND (p_entity_type IS NULL OR tal.entity_type = p_entity_type)
      AND (p_entity_id IS NULL OR tal.entity_id = p_entity_id)
    ORDER BY tal.created_at_utc DESC
    LIMIT p_limit
  ) sub;

  RETURN jsonb_build_object('success', true, 'data', v_timeline);
END;
$$;
