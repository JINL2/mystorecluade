-- Update the get_debt_control_data RPC function to support showing all counterparties
-- This includes counterparties with zero balances (no transactions yet)

CREATE OR REPLACE FUNCTION get_debt_control_data(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_perspective VARCHAR DEFAULT 'company',
    p_filter VARCHAR DEFAULT 'all',
    p_show_all BOOLEAN DEFAULT FALSE  -- New parameter to show all counterparties
)
RETURNS JSONB AS $$
DECLARE
    v_result JSONB;
BEGIN
    -- Your existing RPC function logic here
    -- But with modifications to the WHERE clause:
    
    -- When building the records array, modify the query to:
    -- 1. If p_show_all = TRUE: Include ALL counterparties from the counterparties table
    --    LEFT JOIN with transactions to get balance data (will be 0 for no transactions)
    -- 2. If p_show_all = FALSE: Only include counterparties with actual transactions (current behavior)
    
    -- Example modification for the records query:
    /*
    WITH counterparty_balances AS (
        SELECT 
            c.id as counterparty_id,
            c.name as counterparty_name,
            c.is_internal,
            COALESCE(SUM(CASE WHEN t.type = 'receivable' THEN t.amount ELSE 0 END), 0) as receivable_amount,
            COALESCE(SUM(CASE WHEN t.type = 'payable' THEN t.amount ELSE 0 END), 0) as payable_amount,
            COALESCE(MAX(t.created_at), NULL) as last_activity,
            COUNT(t.id) as transaction_count
        FROM counterparties c
        LEFT JOIN transactions t ON c.id = t.counterparty_id 
            AND t.company_id = p_company_id
            AND (p_store_id IS NULL OR t.store_id = p_store_id)
        WHERE c.company_id = p_company_id
        GROUP BY c.id, c.name, c.is_internal
        HAVING 
            -- If p_show_all is TRUE, show all counterparties
            -- If FALSE, only show those with transactions
            p_show_all = TRUE OR COUNT(t.id) > 0
    )
    */
    
    -- The rest of your function logic remains the same
    -- Just ensure the records include zero-balance counterparties when p_show_all = TRUE
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_debt_control_data TO anon, authenticated;