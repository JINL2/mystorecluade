-- =====================================================
-- DEBUG: Check what's actually in your counterparties table
-- =====================================================

-- 1. Check what types exist in your database (case-sensitive check)
SELECT 
    type,
    COUNT(*) as count,
    ARRAY_AGG(name ORDER BY name LIMIT 3) as sample_names
FROM counterparties 
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602'
  AND (is_deleted = false OR is_deleted IS NULL)
GROUP BY type
ORDER BY count DESC;

-- 2. Check if RPC function exists
SELECT 
    proname as function_name,
    pg_get_function_result(oid) as return_type
FROM pg_proc 
WHERE proname = 'get_counterparties';

-- 3. Test RPC with exact parameters from Flutter
SELECT * FROM get_counterparties(
    '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,
    'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff'::UUID,
    'Suppliers'
);

-- 4. Test without type filter to see all data
SELECT * FROM get_counterparties(
    '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,
    'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff'::UUID,
    NULL
);

-- 5. If no data, check raw table
SELECT 
    counterparty_id,
    name,
    type,
    is_internal,
    is_deleted
FROM counterparties 
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602'
LIMIT 10;