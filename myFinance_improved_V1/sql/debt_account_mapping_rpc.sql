-- 🎯 DEBT ACCOUNT MAPPING SYSTEM - RPC FUNCTIONS
-- Purpose: Provide RPC-only interface for debt account mapping operations
-- No database schema changes required - works with existing structure

-- ================================================================
-- 1. GET ACCOUNT MAPPINGS WITH COMPANY INFO
-- ================================================================
-- Retrieves account mappings for a counterparty with company and account details
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
    linked_company_name TEXT,
    my_account_name TEXT,
    linked_account_name TEXT,
    my_account_type TEXT,
    linked_account_type TEXT
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
        lc.company_name as linked_company_name,
        ma.account_name as my_account_name,
        la.account_name as linked_account_name,
        ma.account_type as my_account_type,
        la.account_type as linked_account_type
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
-- 2. GET DEBT ACCOUNTS FOR COMPANY
-- ================================================================
-- Returns only debt accounts (payable/receivable) for account selection
CREATE OR REPLACE FUNCTION get_debt_accounts_for_company(
    p_company_id UUID
) RETURNS TABLE (
    account_id UUID,
    account_name TEXT,
    account_type TEXT,
    expense_nature TEXT,
    category_tag TEXT,
    is_debt_account BOOLEAN
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.account_id,
        a.account_name,
        a.account_type,
        a.expense_nature,
        a.category_tag,
        CASE 
            WHEN a.category_tag ILIKE '%payable%' THEN true
            WHEN a.category_tag ILIKE '%receivable%' THEN true
            WHEN a.debt_tag IS NOT NULL THEN true
            ELSE false
        END as is_debt_account
    FROM accounts a
    WHERE a.company_id = p_company_id
    AND (
        a.category_tag ILIKE '%payable%' 
        OR a.category_tag ILIKE '%receivable%'
        OR a.debt_tag IS NOT NULL
        OR a.account_type IN ('accounts_payable', 'accounts_receivable', 'notes_payable', 'notes_receivable')
    )
    ORDER BY a.account_name;
END;
$$;

-- ================================================================
-- 3. FIND INTER-COMPANY JOURNALS
-- ================================================================
-- Finds journals from other companies that need corresponding entries
CREATE OR REPLACE FUNCTION find_inter_company_journals(
    p_target_company_id UUID,
    p_days_back INTEGER DEFAULT 30
) RETURNS TABLE (
    source_entry_id UUID,
    source_company_id UUID,
    counterparty_id UUID,
    reference_number TEXT,
    transaction_date DATE,
    amount DECIMAL,
    account_mappings JSONB
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        je.entry_id as source_entry_id,
        je.company_id as source_company_id,
        je.counterparty_id,
        je.reference_number,
        je.transaction_date,
        je.amount,
        COALESCE(
            JSON_AGG(
                JSON_BUILD_OBJECT(
                    'mapping_id', am.mapping_id,
                    'my_account_id', am.my_account_id,
                    'linked_account_id', am.linked_account_id,
                    'direction', am.direction
                )
            ) FILTER (WHERE am.mapping_id IS NOT NULL),
            '[]'::jsonb
        ) as account_mappings
    FROM journal_entries je
    JOIN counterparties cp ON je.counterparty_id = cp.counterparty_id
    LEFT JOIN account_mappings am ON am.counterparty_id = cp.counterparty_id
    WHERE cp.is_internal = true
    AND cp.linked_company_id = p_target_company_id
    AND je.transaction_date >= CURRENT_DATE - INTERVAL '1 day' * p_days_back
    AND NOT EXISTS (
        -- Check if corresponding entry already exists
        SELECT 1 FROM journal_entries existing
        WHERE existing.reference_number = je.reference_number
        AND existing.company_id = p_target_company_id
    )
    GROUP BY je.entry_id, je.company_id, je.counterparty_id, 
             je.reference_number, je.transaction_date, je.amount;
END;
$$;

-- ================================================================
-- 4. CREATE ACCOUNT MAPPING
-- ================================================================
-- Creates a new account mapping with validation
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
    v_linked_company_id UUID;
    v_my_account_type TEXT;
    v_linked_account_type TEXT;
BEGIN
    -- Get linked company from counterparty
    SELECT linked_company_id INTO v_linked_company_id
    FROM counterparties
    WHERE counterparty_id = p_counterparty_id;
    
    IF v_linked_company_id IS NULL THEN
        RETURN QUERY SELECT false, 'Counterparty is not linked to an internal company', NULL::UUID;
        RETURN;
    END IF;
    
    -- Verify both accounts are debt accounts
    SELECT account_type INTO v_my_account_type
    FROM accounts
    WHERE account_id = p_my_account_id;
    
    SELECT account_type INTO v_linked_account_type
    FROM accounts
    WHERE account_id = p_linked_account_id;
    
    -- Check for duplicate mapping
    IF EXISTS (
        SELECT 1 FROM account_mappings
        WHERE my_company_id = p_my_company_id
        AND my_account_id = p_my_account_id
        AND counterparty_id = p_counterparty_id
        AND linked_account_id = p_linked_account_id
    ) THEN
        RETURN QUERY SELECT false, 'This account mapping already exists', NULL::UUID;
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
    
    RETURN QUERY SELECT true, 'Account mapping created successfully', v_mapping_id;
END;
$$;

-- ================================================================
-- 5. UPDATE ACCOUNT MAPPING
-- ================================================================
-- Updates an existing account mapping
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
        RETURN QUERY SELECT false, 'Account mapping not found';
        RETURN;
    END IF;
    
    -- Update the mapping
    UPDATE account_mappings
    SET 
        my_account_id = p_my_account_id,
        linked_account_id = p_linked_account_id,
        direction = p_direction
    WHERE mapping_id = p_mapping_id;
    
    RETURN QUERY SELECT true, 'Account mapping updated successfully';
END;
$$;

-- ================================================================
-- 6. DELETE ACCOUNT MAPPING
-- ================================================================
-- Soft deletes an account mapping (actually removes it since no is_active field)
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
        RETURN QUERY SELECT false, 'Account mapping not found';
        RETURN;
    END IF;
    
    -- Delete the mapping
    DELETE FROM account_mappings
    WHERE mapping_id = p_mapping_id;
    
    RETURN QUERY SELECT true, 'Account mapping deleted successfully';
END;
$$;

-- ================================================================
-- 7. CREATE CORRESPONDING JOURNAL ENTRY
-- ================================================================
-- Creates the corresponding journal entry in the linked company
CREATE OR REPLACE FUNCTION create_corresponding_journal(
    p_source_entry_id UUID,
    p_mapping_id UUID
) RETURNS TABLE (
    success BOOLEAN,
    message TEXT,
    new_entry_id UUID
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_source_entry RECORD;
    v_mapping RECORD;
    v_new_entry_id UUID;
    v_reverse_debit_credit BOOLEAN;
BEGIN
    -- Get source journal entry
    SELECT * INTO v_source_entry
    FROM journal_entries
    WHERE entry_id = p_source_entry_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT false, 'Source journal entry not found', NULL::UUID;
        RETURN;
    END IF;
    
    -- Get account mapping
    SELECT 
        am.*,
        cp.linked_company_id
    INTO v_mapping
    FROM account_mappings am
    JOIN counterparties cp ON am.counterparty_id = cp.counterparty_id
    WHERE am.mapping_id = p_mapping_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT false, 'Account mapping not found', NULL::UUID;
        RETURN;
    END IF;
    
    -- Check if corresponding entry already exists
    IF EXISTS (
        SELECT 1 FROM journal_entries
        WHERE reference_number = v_source_entry.reference_number
        AND company_id = v_mapping.linked_company_id
    ) THEN
        RETURN QUERY SELECT false, 'Corresponding entry already exists', NULL::UUID;
        RETURN;
    END IF;
    
    -- Determine if we need to reverse debit/credit
    -- When Company A debits receivable, Company B should credit payable
    v_reverse_debit_credit := true;
    
    -- Create corresponding entry
    INSERT INTO journal_entries (
        company_id,
        account_id,
        counterparty_id,
        reference_number,
        transaction_date,
        amount,
        debit_amount,
        credit_amount,
        description,
        created_at,
        created_by
    ) VALUES (
        v_mapping.linked_company_id,
        v_mapping.linked_account_id,
        v_source_entry.counterparty_id,
        v_source_entry.reference_number,
        v_source_entry.transaction_date,
        v_source_entry.amount,
        CASE WHEN v_reverse_debit_credit THEN 
            v_source_entry.credit_amount 
        ELSE 
            v_source_entry.debit_amount 
        END,
        CASE WHEN v_reverse_debit_credit THEN 
            v_source_entry.debit_amount 
        ELSE 
            v_source_entry.credit_amount 
        END,
        COALESCE(v_source_entry.description, '') || ' [Auto-generated from ' || v_source_entry.company_id::text || ']',
        NOW(),
        auth.uid()
    ) RETURNING entry_id INTO v_new_entry_id;
    
    RETURN QUERY SELECT true, 'Corresponding journal entry created successfully', v_new_entry_id;
END;
$$;

-- ================================================================
-- 8. GET INTERNAL COUNTERPARTIES WITH COMPANIES
-- ================================================================
-- Gets internal counterparties with their linked company information
CREATE OR REPLACE FUNCTION get_internal_counterparties_with_companies(
    p_company_id UUID
) RETURNS TABLE (
    counterparty_id UUID,
    counterparty_name TEXT,
    linked_company_id UUID,
    linked_company_name TEXT,
    is_internal BOOLEAN
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cp.counterparty_id,
        cp.counterparty_name,
        cp.linked_company_id,
        lc.company_name as linked_company_name,
        cp.is_internal
    FROM counterparties cp
    LEFT JOIN companies lc ON cp.linked_company_id = lc.company_id
    WHERE cp.company_id = p_company_id
    AND cp.is_internal = true
    AND cp.linked_company_id IS NOT NULL
    ORDER BY cp.counterparty_name;
END;
$$;

-- ================================================================
-- PERMISSIONS
-- ================================================================
-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION get_account_mappings_with_company TO authenticated;
GRANT EXECUTE ON FUNCTION get_debt_accounts_for_company TO authenticated;
GRANT EXECUTE ON FUNCTION find_inter_company_journals TO authenticated;
GRANT EXECUTE ON FUNCTION create_account_mapping TO authenticated;
GRANT EXECUTE ON FUNCTION update_account_mapping TO authenticated;
GRANT EXECUTE ON FUNCTION delete_account_mapping TO authenticated;
GRANT EXECUTE ON FUNCTION create_corresponding_journal TO authenticated;
GRANT EXECUTE ON FUNCTION get_internal_counterparties_with_companies TO authenticated;

-- ================================================================
-- COMMENTS FOR DOCUMENTATION
-- ================================================================
COMMENT ON FUNCTION get_account_mappings_with_company IS 
'Retrieves all account mappings for a specific counterparty with full company and account details';

COMMENT ON FUNCTION get_debt_accounts_for_company IS 
'Returns only debt accounts (payable/receivable) for a company, used in account selection dropdowns';

COMMENT ON FUNCTION find_inter_company_journals IS 
'Finds journal entries from other companies that need corresponding entries in the target company';

COMMENT ON FUNCTION create_account_mapping IS 
'Creates a new account mapping between internal companies with validation';

COMMENT ON FUNCTION update_account_mapping IS 
'Updates an existing account mapping';

COMMENT ON FUNCTION delete_account_mapping IS 
'Deletes an account mapping';

COMMENT ON FUNCTION create_corresponding_journal IS 
'Creates the corresponding journal entry in the linked company based on account mapping';

COMMENT ON FUNCTION get_internal_counterparties_with_companies IS 
'Gets internal counterparties with their linked company information for selection';