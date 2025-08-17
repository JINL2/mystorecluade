-- =====================================================
-- AUTONOMOUS SELECTOR RPC FUNCTIONS
-- Dedicated functions for autonomous selector components
-- =====================================================

-- =====================================================
-- GET ACCOUNTS FUNCTION (GLOBAL - NO COMPANY/STORE FILTER)
-- Returns all accounts since accounts are global
-- =====================================================
CREATE OR REPLACE FUNCTION get_accounts(
    p_account_type TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', account_id,
            'name', account_name,
            'type', account_type,
            'categoryTag', category_tag,
            'transactionCount', COALESCE(transaction_count, 0),
            'balance', COALESCE(current_balance, 0),
            'additionalData', json_build_object(
                'account_id', account_id,
                'account_name', account_name,
                'account_type', account_type,
                'category_tag', category_tag,
                'is_active', is_active,
                'created_at', created_at
            )
        )
    )
    INTO result
    FROM accounts
    WHERE 
        is_deleted = FALSE
        AND is_active = TRUE
        AND (p_account_type IS NULL OR account_type = p_account_type)
    ORDER BY account_name;
    
    RETURN COALESCE(result, '[]'::json);
END;
$$;

-- =====================================================
-- GET CASH LOCATIONS FUNCTION
-- Returns cash locations filtered by company/store
-- =====================================================
CREATE OR REPLACE FUNCTION get_cash_locations(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_location_type TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', cash_location_id,
            'name', location_name,
            'type', location_type,
            'storeId', store_id,
            'isCompanyWide', is_company_wide,
            'currencyCode', currency_code,
            'bankAccount', bank_account,
            'bankName', bank_name,
            'locationInfo', location_info,
            'transactionCount', COALESCE(transaction_count, 0),
            'currentBalance', COALESCE(current_balance, 0),
            'additionalData', json_build_object(
                'cash_location_id', cash_location_id,
                'location_name', location_name,
                'location_type', location_type,
                'company_id', company_id,
                'store_id', store_id,
                'is_company_wide', is_company_wide,
                'currency_code', currency_code,
                'bank_account', bank_account,
                'bank_name', bank_name,
                'location_info', location_info,
                'is_active', is_active,
                'created_at', created_at
            )
        )
    )
    INTO result
    FROM cash_locations
    WHERE 
        company_id = p_company_id
        AND is_deleted = FALSE
        AND is_active = TRUE
        AND (
            p_store_id IS NULL 
            OR store_id = p_store_id 
            OR is_company_wide = TRUE
        )
        AND (p_location_type IS NULL OR location_type = p_location_type)
    ORDER BY 
        is_company_wide DESC,  -- Company-wide locations first
        location_name;
    
    RETURN COALESCE(result, '[]'::json);
END;
$$;

-- =====================================================
-- GET COUNTERPARTIES FUNCTION
-- Returns counterparties filtered by company/store
-- =====================================================
CREATE OR REPLACE FUNCTION get_counterparties(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_counterparty_type TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'id', counterparty_id,
            'name', name,
            'type', type,
            'email', email,
            'phone', phone,
            'isInternal', is_internal,
            'transactionCount', COALESCE(transaction_count, 0),
            'balance', COALESCE(balance, 0),
            'lastTransactionDate', last_transaction_date,
            'additionalData', json_build_object(
                'counterparty_id', counterparty_id,
                'company_id', company_id,
                'name', name,
                'type', type,
                'email', email,
                'phone', phone,
                'address', address,
                'notes', notes,
                'is_internal', is_internal,
                'linked_company_id', linked_company_id,
                'created_by', created_by,
                'created_at', created_at,
                'updated_at', updated_at,
                'is_deleted', is_deleted
            )
        )
    )
    INTO result
    FROM counterparties
    WHERE 
        company_id = p_company_id
        AND is_deleted = FALSE
        AND (
            p_store_id IS NULL 
            OR linked_company_id IS NULL  -- No store restriction for global counterparties
            OR EXISTS (
                SELECT 1 FROM stores 
                WHERE store_id = p_store_id 
                AND company_id = p_company_id
            )
        )
        AND (p_counterparty_type IS NULL OR type = p_counterparty_type)
    ORDER BY 
        is_internal DESC,  -- Internal counterparties first
        name;
    
    RETURN COALESCE(result, '[]'::json);
END;
$$;

-- =====================================================
-- GRANT PERMISSIONS
-- =====================================================
GRANT EXECUTE ON FUNCTION get_accounts(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_cash_locations(UUID, UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_counterparties(UUID, UUID, TEXT) TO authenticated;

-- =====================================================
-- TEST QUERIES (Remove these after testing)
-- =====================================================
-- Test accounts (global)
-- SELECT get_accounts();
-- SELECT get_accounts('asset');

-- Test cash locations (replace with actual UUIDs)
-- SELECT get_cash_locations('your-company-id');
-- SELECT get_cash_locations('your-company-id', 'your-store-id');
-- SELECT get_cash_locations('your-company-id', NULL, 'bank');

-- Test counterparties (replace with actual UUIDs)
-- SELECT get_counterparties('your-company-id');
-- SELECT get_counterparties('your-company-id', 'your-store-id');
-- SELECT get_counterparties('your-company-id', NULL, 'customer');