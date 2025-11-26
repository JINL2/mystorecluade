-- Create RPC function to get account mappings with enriched details
CREATE OR REPLACE FUNCTION get_account_mappings_with_details(p_counterparty_id UUID)
RETURNS TABLE (
  mapping_id UUID,
  my_company_id UUID,
  my_account_id UUID,
  counterparty_id UUID,
  linked_account_id UUID,
  direction TEXT,
  created_by UUID,
  created_at TIMESTAMPTZ,
  is_deleted BOOLEAN,
  my_company_name TEXT,
  my_account_name TEXT,
  counterparty_name TEXT,
  linked_company_name TEXT,
  linked_account_name TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    am.mapping_id,
    am.my_company_id,
    am.my_account_id,
    am.counterparty_id,
    am.linked_account_id,
    am.direction,
    am.created_by,
    am.created_at,
    am.is_deleted,
    c1.company_name AS my_company_name,
    a1.account_name AS my_account_name,
    cp.counterparty_name AS counterparty_name,
    c2.company_name AS linked_company_name,
    a2.account_name AS linked_account_name
  FROM account_mappings am
  LEFT JOIN companies c1 ON c1.company_id = am.my_company_id
  LEFT JOIN accounts a1 ON a1.account_id = am.my_account_id
  LEFT JOIN counterparties cp ON cp.counterparty_id = am.counterparty_id
  LEFT JOIN companies c2 ON c2.company_id = cp.linked_company_id
  LEFT JOIN accounts a2 ON a2.account_id = am.linked_account_id
  WHERE am.counterparty_id = p_counterparty_id
    AND am.is_deleted = false
  ORDER BY am.created_at DESC;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_account_mappings_with_details(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_account_mappings_with_details(UUID) TO service_role;
