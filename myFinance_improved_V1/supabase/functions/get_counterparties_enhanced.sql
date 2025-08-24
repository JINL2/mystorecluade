-- =====================================================
-- ENHANCED RPC FUNCTION: get_counterparties
-- Works with your actual counterparty types
-- =====================================================

CREATE OR REPLACE FUNCTION get_counterparties(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_counterparty_type TEXT DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  type TEXT,
  email TEXT,
  phone TEXT,
  is_internal BOOLEAN,
  transaction_count INTEGER,
  additional_data JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    cp.counterparty_id AS id,
    cp.name AS name,
    cp.type AS type,
    cp.email AS email,
    cp.phone AS phone,
    cp.is_internal AS is_internal,
    COALESCE(
      (
        SELECT COUNT(*)::INTEGER
        FROM journal_lines jl
        JOIN journal_entries je ON jl.journal_id = je.journal_id
        WHERE jl.counterparty_id = cp.counterparty_id
          AND je.company_id = p_company_id
          AND (p_store_id IS NULL OR je.store_id = p_store_id)
          AND je.status = 'posted'
      ), 
      0
    ) AS transaction_count,
    jsonb_build_object(
      'linked_company_id', cp.linked_company_id,
      'address', cp.address,
      'notes', cp.notes
    ) AS additional_data
  FROM counterparties cp
  WHERE cp.company_id = p_company_id
    AND (cp.is_deleted = false OR cp.is_deleted IS NULL)
    AND (
      p_counterparty_type IS NULL 
      OR cp.type = p_counterparty_type
      -- Handle mapping of logical types to actual types
      OR (p_counterparty_type = 'vendor' AND cp.type IN ('Suppliers', 'Others', 'My Company', 'Team Member'))
      OR (p_counterparty_type = 'customer' AND cp.type = 'Customers')
      OR (p_counterparty_type = 'internal' AND cp.is_internal = true)
    )
  ORDER BY cp.name ASC;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_counterparties(UUID, UUID, TEXT) TO authenticated;

-- Test the function with your actual company
SELECT * FROM get_counterparties(
    '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,
    NULL,
    'Suppliers'  -- Use actual type
);