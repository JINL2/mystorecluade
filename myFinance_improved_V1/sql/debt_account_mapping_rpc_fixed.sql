-- 🎯 DEBT ACCOUNT MAPPING SYSTEM - RPC FUNCTIONS (FIXED VERSION)
-- Purpose: Provide RPC-only interface for debt account mapping operations
-- Fixed to match actual database structure

-- ================================================================
-- 1. GET ACCOUNT MAPPINGS WITH COMPANY INFO (FIXED)
-- ================================================================
CREATE OR REPLACE FUNCTION get_account_mappings_with_company(
    p_counterparty_id UUID
) RETURNS TABLE (
    mapping_id UUID,
    my_company_id UUID,
    my_account_id UUID,
    counterparty_id UUID,
    linked_account_id UUID,
    direction TEXT,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE,
    -- DERIVED FIELDS
    linked_company_id UUID,
    linked_company_name VARCHAR(255),  -- Fixed: Changed from TEXT to VARCHAR(255)
    my_account_name VARCHAR(255),      -- Fixed: Changed from TEXT to VARCHAR(255)
    linked_account_name VARCHAR(255),  -- Fixed: Changed from TEXT to VARCHAR(255)
    my_account_type VARCHAR(255),      -- Fixed: Changed from TEXT to VARCHAR(255)
    linked_account_type VARCHAR(255)   -- Fixed: Changed from TEXT to VARCHAR(255)
) 
LANGUAGE plpgsql
SECURITY DEFINER
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
        -- Derive linked company from counterparty relationship
        cp.linked_company_id,
        lc.company_name::VARCHAR(255) as linked_company_name,
        ma.account_name::VARCHAR(255) as my_account_name,
        la.account_name::VARCHAR(255) as linked_account_name,
        ma.account_type::VARCHAR(255) as my_account_type,
        la.account_type::VARCHAR(255) as linked_account_type
    FROM account_mappings am
    JOIN counterparties cp ON am.counterparty_id = cp.counterparty_id
    LEFT JOIN companies lc ON cp.linked_company_id = lc.company_id
    LEFT JOIN accounts ma ON am.my_account_id = ma.account_id
    LEFT JOIN accounts la ON am.linked_account_id = la.account_id
    WHERE am.counterparty_id = p_counterparty_id
    ORDER BY am.created_at DESC;
END;
$$;

-- ================================================================
-- 2. GET DEBT ACCOUNTS FOR COMPANY (FIXED)
-- ================================================================
CREATE OR REPLACE FUNCTION get_debt_accounts_for_company(
    p_company_id UUID
) RETURNS TABLE (
    account_id UUID,
    account_name VARCHAR(255),     -- Fixed: Changed from TEXT to VARCHAR(255)
    account_type VARCHAR(255),     -- Fixed: Changed from TEXT to VARCHAR(255)
    expense_nature VARCHAR(255),   -- Fixed: Changed from TEXT to VARCHAR(255)
    category_tag VARCHAR(255),     -- Fixed: Changed from TEXT to VARCHAR(255)
    is_debt_account BOOLEAN
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.account_id,
        a.account_name::VARCHAR(255),
        a.account_type::VARCHAR(255),
        a.expense_nature::VARCHAR(255),
        a.category_tag::VARCHAR(255),
        CASE 
            WHEN a.category_tag ILIKE '%payable%' THEN true
            WHEN a.category_tag ILIKE '%receivable%' THEN true
            WHEN a.debt_tag IS NOT NULL THEN true
            ELSE false
        END as is_debt_account
    FROM accounts a
    -- Removed company_id filter since accounts table doesn't have it
    WHERE (
        a.category_tag ILIKE '%payable%' 
        OR a.category_tag ILIKE '%receivable%'
        OR a.debt_tag IS NOT NULL
        OR a.account_type IN ('accounts_payable', 'accounts_receivable', 'notes_payable', 'notes_receivable')
    )
    ORDER BY a.account_name;
END;
$$;

-- ================================================================
-- 3. CREATE ACCOUNT MAPPING (SIMPLIFIED)
-- ================================================================
CREATE OR REPLACE FUNCTION create_account_mapping(
    p_my_company_id UUID,
    p_my_account_id UUID,
    p_counterparty_id UUID,
    p_linked_account_id UUID,
    p_direction TEXT DEFAULT 'bidirectional'
) RETURNS TABLE (
    success BOOLEAN,
    message TEXT,
    mapping_id UUID
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_mapping_id UUID;
BEGIN
    -- Check for duplicate mapping
    IF EXISTS (
        SELECT 1 FROM account_mappings
        WHERE my_company_id = p_my_company_id
        AND my_account_id = p_my_account_id
        AND counterparty_id = p_counterparty_id
        AND linked_account_id = p_linked_account_id
    ) THEN
        RETURN QUERY SELECT false, 'This account mapping already exists'::TEXT, NULL::UUID;
        RETURN;
    END IF;
    
    -- Create the mapping
    INSERT INTO account_mappings (
        my_company_id,
        my_account_id,
        counterparty_id,
        linked_account_id,
        direction,
        created_at,
        created_by
    ) VALUES (
        p_my_company_id,
        p_my_account_id,
        p_counterparty_id,
        p_linked_account_id,
        p_direction,
        NOW(),
        auth.uid()
    ) RETURNING mapping_id INTO v_mapping_id;
    
    RETURN QUERY SELECT true, 'Account mapping created successfully'::TEXT, v_mapping_id;
END;
$$;

-- ================================================================
-- 4. UPDATE ACCOUNT MAPPING (SIMPLIFIED)
-- ================================================================
CREATE OR REPLACE FUNCTION update_account_mapping(
    p_mapping_id UUID,
    p_my_account_id UUID,
    p_linked_account_id UUID,
    p_direction TEXT DEFAULT 'bidirectional'
) RETURNS TABLE (
    success BOOLEAN,
    message TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Check if mapping exists
    IF NOT EXISTS (
        SELECT 1 FROM account_mappings
        WHERE mapping_id = p_mapping_id
    ) THEN
        RETURN QUERY SELECT false, 'Account mapping not found'::TEXT;
        RETURN;
    END IF;
    
    -- Update the mapping
    UPDATE account_mappings
    SET 
        my_account_id = p_my_account_id,
        linked_account_id = p_linked_account_id,
        direction = p_direction
    WHERE mapping_id = p_mapping_id;
    
    RETURN QUERY SELECT true, 'Account mapping updated successfully'::TEXT;
END;
$$;

-- ================================================================
-- 5. DELETE ACCOUNT MAPPING (SIMPLIFIED)
-- ================================================================
CREATE OR REPLACE FUNCTION delete_account_mapping(
    p_mapping_id UUID
) RETURNS TABLE (
    success BOOLEAN,
    message TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Check if mapping exists
    IF NOT EXISTS (
        SELECT 1 FROM account_mappings
        WHERE mapping_id = p_mapping_id
    ) THEN
        RETURN QUERY SELECT false, 'Account mapping not found'::TEXT;
        RETURN;
    END IF;
    
    -- Delete the mapping
    DELETE FROM account_mappings
    WHERE mapping_id = p_mapping_id;
    
    RETURN QUERY SELECT true, 'Account mapping deleted successfully'::TEXT;
END;
$$;

-- ================================================================
-- PERMISSIONS
-- ================================================================
-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION get_account_mappings_with_company TO authenticated;
GRANT EXECUTE ON FUNCTION get_debt_accounts_for_company TO authenticated;
GRANT EXECUTE ON FUNCTION create_account_mapping TO authenticated;
GRANT EXECUTE ON FUNCTION update_account_mapping TO authenticated;
GRANT EXECUTE ON FUNCTION delete_account_mapping TO authenticated;

-- ================================================================
-- COMMENTS FOR DOCUMENTATION
-- ================================================================
COMMENT ON FUNCTION get_account_mappings_with_company IS 
'Retrieves all account mappings for a specific counterparty with full company and account details';

COMMENT ON FUNCTION get_debt_accounts_for_company IS 
'Returns only debt accounts (payable/receivable) for all companies, used in account selection dropdowns';

COMMENT ON FUNCTION create_account_mapping IS 
'Creates a new account mapping between internal companies with validation';

COMMENT ON FUNCTION update_account_mapping IS 
'Updates an existing account mapping';

COMMENT ON FUNCTION delete_account_mapping IS 
'Deletes an account mapping';