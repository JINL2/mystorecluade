-- =====================================================
-- FIXED GROUP BY SELECTOR RPC FUNCTIONS
-- Removes json_agg() to avoid GROUP BY requirements
-- =====================================================

-- =====================================================
-- DROP EXISTING FUNCTIONS FIRST
-- =====================================================
DROP FUNCTION IF EXISTS get_accounts(TEXT);
DROP FUNCTION IF EXISTS get_cash_locations(UUID, TEXT, UUID);
DROP FUNCTION IF EXISTS get_cash_locations(UUID, UUID, TEXT);
DROP FUNCTION IF EXISTS get_counterparties(UUID, UUID, TEXT);

-- =====================================================
-- GET ACCOUNTS FUNCTION (GLOBAL - NO COMPANY/STORE FILTER)
-- Fixed: Using array_to_json(array_agg()) instead of json_agg()
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
    WITH account_data AS (
        SELECT json_build_object(
            'id', account_id,
            'name', account_name,
            'type', account_type,
            'categoryTag', category_tag,
            'expenseNature', expense_nature,
            'description', description,
            'transactionCount', 0,
            'additionalData', json_build_object(
                'account_id', account_id,
                'account_name', account_name,
                'account_type', account_type,
                'expense_nature', expense_nature,
                'category_tag', category_tag,
                'description', description,
                'debt_tag', debt_tag,
                'statement_category', statement_category,
                'statement_detail_category', statement_detail_category,
                'created_at', created_at,
                'updated_at', updated_at
            )
        ) as account_json
        FROM accounts
        WHERE (p_account_type IS NULL OR account_type = p_account_type)
        ORDER BY account_name
    )
    SELECT COALESCE(array_to_json(array_agg(account_json)), '[]'::json)
    INTO result
    FROM account_data;
    
    RETURN result;
END;
$$;

-- =====================================================
-- GET CASH LOCATIONS FUNCTION
-- Fixed: Using array_to_json(array_agg()) instead of json_agg()
-- =====================================================
CREATE OR REPLACE FUNCTION get_cash_locations(
    p_company_id UUID,
    p_location_type TEXT DEFAULT NULL,
    p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    WITH location_data AS (
        SELECT json_build_object(
            'id', cash_location_id,
            'name', location_name,
            'type', location_type,
            'storeId', store_id,
            'isCompanyWide', CASE 
                WHEN store_id IS NULL THEN true 
                ELSE false 
            END,
            'currencyCode', currency_code,
            'bankAccount', bank_account,
            'bankName', bank_name,
            'locationInfo', location_info,
            'transactionCount', 0,
            'additionalData', json_build_object(
                'cash_location_id', cash_location_id,
                'company_id', company_id,
                'store_id', store_id,
                'location_name', location_name,
                'location_type', location_type,
                'location_info', location_info,
                'currency_code', currency_code,
                'bank_account', bank_account,
                'bank_name', bank_name,
                'deleted_at', deleted_at,
                'created_at', created_at
            )
        ) as location_json
        FROM cash_locations
        WHERE 
            company_id = p_company_id
            AND deleted_at IS NULL
            AND (
                p_store_id IS NULL 
                OR store_id = p_store_id 
                OR store_id IS NULL
            )
            AND (p_location_type IS NULL OR location_type = p_location_type)
        ORDER BY 
            store_id NULLS FIRST,
            location_name
    )
    SELECT COALESCE(array_to_json(array_agg(location_json)), '[]'::json)
    INTO result
    FROM location_data;
    
    RETURN result;
END;
$$;

-- =====================================================
-- GET COUNTERPARTIES FUNCTION
-- Fixed: Using array_to_json(array_agg()) instead of json_agg()
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
    WITH counterparty_data AS (
        SELECT json_build_object(
            'id', counterparty_id,
            'name', name,
            'type', type,
            'email', email,
            'phone', phone,
            'address', address,
            'notes', notes,
            'isInternal', is_internal,
            'transactionCount', 0,
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
                'is_deleted', is_deleted,
                'linked_company_id', linked_company_id,
                'created_by', created_by,
                'created_at', created_at
            )
        ) as counterparty_json
        FROM counterparties
        WHERE 
            company_id = p_company_id
            AND is_deleted = FALSE
            AND (p_counterparty_type IS NULL OR type = p_counterparty_type)
        ORDER BY 
            is_internal DESC,
            name
    )
    SELECT COALESCE(array_to_json(array_agg(counterparty_json)), '[]'::json)
    INTO result
    FROM counterparty_data;
    
    RETURN result;
END;
$$;

-- =====================================================
-- GRANT PERMISSIONS TO AUTHENTICATED USERS
-- =====================================================
GRANT EXECUTE ON FUNCTION get_accounts(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_cash_locations(UUID, TEXT, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_counterparties(UUID, UUID, TEXT) TO authenticated;

-- =====================================================
-- TEST QUERIES
-- =====================================================
-- SELECT get_accounts();
-- SELECT get_accounts('asset');
-- SELECT get_cash_locations('your-company-uuid', NULL, NULL);
-- SELECT get_counterparties('your-company-uuid', NULL, NULL);