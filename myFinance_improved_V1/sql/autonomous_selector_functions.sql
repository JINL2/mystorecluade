-- =====================================================
-- AUTONOMOUS SELECTOR RPC FUNCTIONS
-- Each selector gets its own dedicated RPC function
-- =====================================================

-- Drop existing functions to avoid conflicts
DROP FUNCTION IF EXISTS get_accounts CASCADE;
DROP FUNCTION IF EXISTS get_counterparties CASCADE;
DROP FUNCTION IF EXISTS get_stores CASCADE;
DROP FUNCTION IF EXISTS get_company_users CASCADE;

-- =====================================================
-- GET ACCOUNTS FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION get_accounts(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_account_type TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', a.account_id::text,
            'name', a.account_name,
            'type', a.account_type,
            'category_tag', a.category_tag,
            'expense_nature', a.expense_nature,
            'transaction_count', COALESCE(tx_count.count, 0)
        ) ORDER BY a.account_name
    ) INTO v_result
    FROM accounts a
    LEFT JOIN (
        SELECT 
            jl.account_id,
            COUNT(DISTINCT je.journal_id) as count
        FROM journal_lines jl
        JOIN journal_entries je ON jl.journal_id = je.journal_id
        WHERE je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
            AND jl.is_deleted = false
        GROUP BY jl.account_id
    ) tx_count ON a.account_id = tx_count.account_id
    WHERE (p_account_type IS NULL OR a.account_type = p_account_type)
        AND EXISTS (
            SELECT 1 FROM journal_entries je2
            JOIN journal_lines jl2 ON je2.journal_id = jl2.journal_id
            WHERE je2.company_id = p_company_id
            AND jl2.account_id = a.account_id
            AND je2.is_deleted = false
            AND jl2.is_deleted = false
        );
    
    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- =====================================================
-- GET COUNTERPARTIES FUNCTION  
-- =====================================================
CREATE OR REPLACE FUNCTION get_counterparties(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_counterparty_type TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', cp.counterparty_id::text,
            'name', cp.name,
            'type', cp.type,
            'email', cp.email,
            'phone', cp.phone,
            'is_internal', COALESCE(cp.is_internal, false),
            'transaction_count', COALESCE(tx_count.count, 0)
        ) ORDER BY cp.name
    ) INTO v_result
    FROM counterparties cp
    LEFT JOIN (
        SELECT 
            je.counterparty_id,
            COUNT(DISTINCT je.journal_id) as count
        FROM journal_entries je
        WHERE je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
            AND je.counterparty_id IS NOT NULL
        GROUP BY je.counterparty_id
    ) tx_count ON cp.counterparty_id = tx_count.counterparty_id
    WHERE cp.company_id = p_company_id
        AND cp.is_deleted = false
        AND (p_counterparty_type IS NULL OR cp.type = p_counterparty_type);
    
    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- =====================================================
-- GET STORES FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION get_stores(
    p_company_id UUID
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', s.store_id::text,
            'name', s.store_name,
            'code', s.store_code,
            'address', s.store_address,
            'phone', s.store_phone,
            'transaction_count', COALESCE(tx_count.count, 0)
        ) ORDER BY s.store_name
    ) INTO v_result
    FROM stores s
    LEFT JOIN (
        SELECT 
            je.store_id,
            COUNT(DISTINCT je.journal_id) as count
        FROM journal_entries je
        WHERE je.company_id = p_company_id
            AND je.is_deleted = false
        GROUP BY je.store_id
    ) tx_count ON s.store_id = tx_count.store_id
    WHERE s.company_id = p_company_id
        AND (s.is_deleted = false OR s.is_deleted IS NULL);
    
    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- =====================================================
-- GET COMPANY USERS FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION get_company_users(
    p_company_id UUID
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', u.user_id::text,
            'name', COALESCE(
                NULLIF(TRIM(u.first_name || ' ' || u.last_name), ''),
                u.email
            ),
            'first_name', u.first_name,
            'last_name', u.last_name,
            'email', u.email,
            'transaction_count', COALESCE(tx_count.count, 0)
        ) ORDER BY u.first_name, u.last_name, u.email
    ) INTO v_result
    FROM users u
    INNER JOIN user_companies uc ON u.user_id = uc.user_id
    LEFT JOIN (
        SELECT 
            je.created_by,
            COUNT(DISTINCT je.journal_id) as count
        FROM journal_entries je
        WHERE je.company_id = p_company_id
            AND je.is_deleted = false
        GROUP BY je.created_by
    ) tx_count ON u.user_id = tx_count.created_by
    WHERE uc.company_id = p_company_id
        AND u.is_deleted = false
        AND (uc.is_deleted = false OR uc.is_deleted IS NULL);
    
    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- =====================================================
-- ENHANCED GET CASH LOCATIONS FUNCTION (Update existing)
-- =====================================================
CREATE OR REPLACE FUNCTION get_cash_locations(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_location_type TEXT DEFAULT NULL
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
            'currency_code', cl.currency_code,
            'bank_account', cl.bank_account,
            'bank_name', cl.bank_name,
            'location_info', cl.location_info,
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
        AND cl.deleted_at IS NULL
        AND (p_location_type IS NULL OR cl.location_type = p_location_type);
    
    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- =====================================================
-- GRANT PERMISSIONS
-- =====================================================
GRANT EXECUTE ON FUNCTION get_accounts TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_counterparties TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_stores TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_company_users TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_cash_locations TO anon, authenticated;

-- =====================================================
-- VERIFY FUNCTION CREATION
-- =====================================================
SELECT 
    p.proname as function_name,
    pg_get_function_arguments(p.oid) as arguments,
    pg_get_function_result(p.oid) as return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' 
AND p.proname IN (
    'get_accounts', 
    'get_counterparties', 
    'get_stores', 
    'get_company_users', 
    'get_cash_locations'
)
ORDER BY p.proname;