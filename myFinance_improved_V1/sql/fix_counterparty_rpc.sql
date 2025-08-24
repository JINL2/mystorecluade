-- =====================================================
-- FINAL FIX: Case-insensitive RPC function
-- =====================================================

-- Drop existing function if it exists
DROP FUNCTION IF EXISTS get_counterparties(UUID, UUID, TEXT);

-- Create improved function with case-insensitive matching
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
      -- Case-insensitive comparison
      OR LOWER(cp.type) = LOWER(p_counterparty_type)
      -- Handle variations
      OR (LOWER(p_counterparty_type) = 'suppliers' AND LOWER(cp.type) IN ('suppliers', 'supplier', 'vendor'))
      OR (LOWER(p_counterparty_type) = 'customers' AND LOWER(cp.type) IN ('customers', 'customer', 'client'))
      OR (LOWER(p_counterparty_type) = 'internal' AND cp.is_internal = true)
    )
  ORDER BY cp.name ASC;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_counterparties(UUID, UUID, TEXT) TO authenticated;

-- Test with your data
SELECT * FROM get_counterparties(
    '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,
    NULL,
    NULL  -- Get all first
);