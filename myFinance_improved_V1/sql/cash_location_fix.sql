-- =====================================================
-- CASH LOCATION COMPONENT FIX
-- Drop old function and create new dedicated function
-- =====================================================

-- Drop the old get_transaction_filter_options function if it exists
DROP FUNCTION IF EXISTS get_transaction_filter_options(UUID, UUID) CASCADE;

-- =====================================================
-- CREATE DEDICATED GET CASH LOCATIONS FUNCTION
-- This function is specifically for the reusable cash location component
-- =====================================================
CREATE OR REPLACE FUNCTION get_cash_locations(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', cl.cash_location_id::text,
            'name', cl.location_name,
            'type', cl.location_type,
            'store_id', CASE WHEN cl.store_id IS NOT NULL THEN cl.store_id::text ELSE NULL END,
            'is_company_wide', COALESCE(cl.is_company_wide, false),
            'transaction_count', COALESCE(tx_count.count, 0)
        ) ORDER BY cl.location_name
    ) INTO v_result
    FROM cash_locations cl
    LEFT JOIN (
        SELECT 
            jl.cash_location_id,
            COUNT(DISTINCT je.journal_id) as count
        FROM journal_lines jl
        JOIN journal_entries je ON jl.journal_id = je.journal_id
        WHERE je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
            AND jl.is_deleted = false
        GROUP BY jl.cash_location_id
    ) tx_count ON cl.cash_location_id = tx_count.cash_location_id
    WHERE cl.company_id = p_company_id
        AND cl.deleted_at IS NULL;
    
    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- Grant permissions for the new function
GRANT EXECUTE ON FUNCTION get_cash_locations TO anon, authenticated;

-- =====================================================
-- RECREATE TRANSACTION FILTER OPTIONS FUNCTION
-- This is the updated version with proper cash_locations data
-- =====================================================
CREATE OR REPLACE FUNCTION get_transaction_filter_options(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    WITH store_counts AS (
        SELECT
            s.store_id,
            s.store_name,
            s.store_code,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM stores s
        LEFT JOIN journal_entries je ON s.store_id = je.store_id
            AND je.company_id = p_company_id
            AND je.is_deleted = false
        WHERE s.company_id = p_company_id
            AND (s.is_deleted = false OR s.is_deleted IS NULL)
        GROUP BY s.store_id, s.store_name, s.store_code
    ),
    account_counts AS (
        SELECT
            a.account_id,
            a.account_name,
            a.account_type,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM accounts a
        LEFT JOIN journal_lines jl ON a.account_id = jl.account_id AND jl.is_deleted = false
        LEFT JOIN journal_entries je ON jl.journal_id = je.journal_id
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE EXISTS (
            SELECT 1 FROM journal_entries je2
            JOIN journal_lines jl2 ON je2.journal_id = jl2.journal_id
            WHERE je2.company_id = p_company_id
            AND jl2.account_id = a.account_id
            AND je2.is_deleted = false
            AND jl2.is_deleted = false
        )
        GROUP BY a.account_id, a.account_name, a.account_type
        HAVING COUNT(DISTINCT je.journal_id) > 0
    ),
    cash_location_counts AS (
        SELECT
            cl.cash_location_id,
            cl.location_name,
            cl.location_type,
            cl.store_id,
            COALESCE(cl.is_company_wide, false) as is_company_wide,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM cash_locations cl
        LEFT JOIN journal_lines jl ON cl.cash_location_id = jl.cash_location_id AND jl.is_deleted = false
        LEFT JOIN journal_entries je ON jl.journal_id = je.journal_id
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE cl.company_id = p_company_id
            AND (p_store_id IS NULL OR cl.store_id = p_store_id)
            AND cl.deleted_at IS NULL
        GROUP BY cl.cash_location_id, cl.location_name, cl.location_type, cl.store_id, cl.is_company_wide
        HAVING COUNT(DISTINCT je.journal_id) > 0
    ),
    counterparty_counts AS (
        SELECT
            cp.counterparty_id,
            cp.name,
            cp.type,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM counterparties cp
        LEFT JOIN journal_entries je ON cp.counterparty_id = je.counterparty_id
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE cp.company_id = p_company_id
            AND cp.is_deleted = false
        GROUP BY cp.counterparty_id, cp.name, cp.type
        HAVING COUNT(DISTINCT je.journal_id) > 0
    ),
    journal_type_counts AS (
        SELECT
            journal_type,
            COUNT(*) as transaction_count
        FROM journal_entries
        WHERE company_id = p_company_id
            AND (p_store_id IS NULL OR store_id = p_store_id)
            AND is_deleted = false
        GROUP BY journal_type
    ),
    user_counts AS (
        SELECT
            u.user_id,
            u.full_name,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM users u
        LEFT JOIN journal_entries je ON u.user_id = je.created_by
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE EXISTS (
            SELECT 1 FROM journal_entries je2
            WHERE je2.company_id = p_company_id
            AND je2.created_by = u.user_id
            AND je2.is_deleted = false
        )
        GROUP BY u.user_id, u.full_name
        HAVING COUNT(DISTINCT je.journal_id) > 0
    )
    
    SELECT json_build_object(
        'stores', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', sc.store_id::text,
                    'name', sc.store_name,
                    'code', sc.store_code,
                    'transaction_count', sc.transaction_count
                ) ORDER BY sc.store_name
            ), '[]'::json)
            FROM store_counts sc
        ),
        'accounts', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', ac.account_id::text,
                    'name', ac.account_name,
                    'type', ac.account_type,
                    'transaction_count', ac.transaction_count
                ) ORDER BY ac.account_name
            ), '[]'::json)
            FROM account_counts ac
        ),
        'cash_locations', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', cc.cash_location_id::text,
                    'name', cc.location_name,
                    'type', cc.location_type,
                    'store_id', CASE WHEN cc.store_id IS NOT NULL THEN cc.store_id::text ELSE NULL END,
                    'is_company_wide', cc.is_company_wide,
                    'transaction_count', cc.transaction_count
                ) ORDER BY cc.location_name
            ), '[]'::json)
            FROM cash_location_counts cc
        ),
        'counterparties', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', cpc.counterparty_id::text,
                    'name', cpc.name,
                    'type', cpc.type,
                    'transaction_count', cpc.transaction_count
                ) ORDER BY cpc.name
            ), '[]'::json)
            FROM counterparty_counts cpc
        ),
        'journal_types', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', jtc.journal_type,
                    'name', jtc.journal_type,
                    'transaction_count', jtc.transaction_count
                ) ORDER BY jtc.journal_type
            ), '[]'::json)
            FROM journal_type_counts jtc
        ),
        'users', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', uc.user_id::text,
                    'name', uc.full_name,
                    'transaction_count', uc.transaction_count
                ) ORDER BY uc.full_name
            ), '[]'::json)
            FROM user_counts uc
        )
    ) INTO v_result;
    
    RETURN v_result;
END;
$$;

-- Grant permissions for the updated filter function
GRANT EXECUTE ON FUNCTION get_transaction_filter_options TO anon, authenticated;

-- =====================================================
-- VERIFY FUNCTION CREATION
-- =====================================================
SELECT 
    p.proname as function_name,
    p.pronargs as num_args,
    pg_get_function_result(p.oid) as return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
AND p.proname IN ('get_cash_locations', 'get_transaction_filter_options')
ORDER BY p.proname;