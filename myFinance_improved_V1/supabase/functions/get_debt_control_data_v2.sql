-- ================================================================
-- FINALIZED: get_debt_control_data_v2
-- Version: 2.0
-- Purpose: Returns both Company and Store perspectives in one call
--          Fixes math display issues and supports all counterparties
-- ================================================================

CREATE OR REPLACE FUNCTION get_debt_control_data_v2(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_filter VARCHAR DEFAULT 'all',      -- 'all', 'internal', 'external'
    p_show_all BOOLEAN DEFAULT FALSE     -- Show counterparties with no transactions
)
RETURNS JSONB AS $$
DECLARE
    v_result JSONB;
    v_company_data JSONB;
    v_store_data JSONB;
BEGIN
    -- ==================================
    -- PART 1: Company Perspective Data
    -- ==================================
    WITH company_transactions AS (
        SELECT 
            t.counterparty_id,
            c.name as counterparty_name,
            c.is_internal,
            -- Use absolute values for clear display
            COALESCE(SUM(CASE 
                WHEN t.transaction_type = 'sale' OR t.transaction_type = 'receivable' 
                THEN ABS(t.amount) 
                ELSE 0 
            END), 0) as receivable_amount,
            COALESCE(SUM(CASE 
                WHEN t.transaction_type = 'purchase' OR t.transaction_type = 'payable' 
                THEN ABS(t.amount) 
                ELSE 0 
            END), 0) as payable_amount,
            MAX(t.transaction_date) as last_activity,
            COUNT(t.id) as transaction_count
        FROM counterparties c
        LEFT JOIN transactions t ON c.id = t.counterparty_id 
            AND t.company_id = p_company_id
            AND t.is_deleted = FALSE
        WHERE c.company_id = p_company_id
            AND c.is_deleted = FALSE
            -- Apply filter
            AND (p_filter = 'all' 
                OR (p_filter = 'internal' AND c.is_internal = TRUE)
                OR (p_filter = 'external' AND c.is_internal = FALSE))
        GROUP BY t.counterparty_id, c.name, c.is_internal
        HAVING 
            -- Show all if requested, otherwise only with transactions
            p_show_all = TRUE OR COUNT(t.id) > 0
    ),
    company_summary AS (
        SELECT 
            -- Total positions (always positive for display)
            SUM(receivable_amount) as total_receivable,
            SUM(payable_amount) as total_payable,
            SUM(receivable_amount) - SUM(payable_amount) as net_position,
            -- Internal breakdown
            SUM(CASE WHEN is_internal THEN receivable_amount ELSE 0 END) as internal_receivable,
            SUM(CASE WHEN is_internal THEN payable_amount ELSE 0 END) as internal_payable,
            -- External breakdown  
            SUM(CASE WHEN NOT is_internal THEN receivable_amount ELSE 0 END) as external_receivable,
            SUM(CASE WHEN NOT is_internal THEN payable_amount ELSE 0 END) as external_payable,
            -- Counts
            COUNT(DISTINCT counterparty_id) as counterparty_count,
            SUM(transaction_count) as transaction_count
        FROM company_transactions
    ),
    store_aggregates AS (
        SELECT 
            s.id as store_id,
            s.name as store_name,
            COALESCE(SUM(CASE 
                WHEN t.transaction_type IN ('sale', 'receivable') 
                THEN ABS(t.amount) 
                ELSE 0 
            END), 0) as receivable,
            COALESCE(SUM(CASE 
                WHEN t.transaction_type IN ('purchase', 'payable') 
                THEN ABS(t.amount) 
                ELSE 0 
            END), 0) as payable,
            COUNT(DISTINCT t.counterparty_id) as counterparty_count
        FROM stores s
        LEFT JOIN transactions t ON s.id = t.store_id
            AND t.company_id = p_company_id
            AND t.is_deleted = FALSE
        WHERE s.company_id = p_company_id
            AND s.is_deleted = FALSE
        GROUP BY s.id, s.name
    )
    SELECT jsonb_build_object(
        'metadata', jsonb_build_object(
            'company_id', p_company_id,
            'perspective', 'company',
            'filter', p_filter,
            'generated_at', now(),
            'currency', '₫'
        ),
        'summary', (SELECT row_to_json(company_summary) FROM company_summary),
        'store_aggregates', (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'store_id', store_id,
                    'store_name', store_name,
                    'receivable', receivable,
                    'payable', payable,
                    'net_position', receivable - payable,
                    'counterparty_count', counterparty_count
                )
            ) FROM store_aggregates
        ),
        'records', (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'counterparty_id', counterparty_id,
                    'counterparty_name', counterparty_name,
                    'is_internal', is_internal,
                    'receivable_amount', receivable_amount,
                    'payable_amount', payable_amount,
                    'net_amount', receivable_amount - payable_amount,
                    'last_activity', last_activity,
                    'transaction_count', transaction_count
                )
            ) FROM company_transactions
        )
    ) INTO v_company_data;

    -- ==================================
    -- PART 2: Store Perspective Data (if store_id provided)
    -- ==================================
    IF p_store_id IS NOT NULL THEN
        WITH store_transactions AS (
            SELECT 
                t.counterparty_id,
                c.name as counterparty_name,
                c.is_internal,
                COALESCE(SUM(CASE 
                    WHEN t.transaction_type IN ('sale', 'receivable') 
                    THEN ABS(t.amount) 
                    ELSE 0 
                END), 0) as receivable_amount,
                COALESCE(SUM(CASE 
                    WHEN t.transaction_type IN ('purchase', 'payable') 
                    THEN ABS(t.amount) 
                    ELSE 0 
                END), 0) as payable_amount,
                MAX(t.transaction_date) as last_activity,
                COUNT(t.id) as transaction_count
            FROM counterparties c
            LEFT JOIN transactions t ON c.id = t.counterparty_id 
                AND t.company_id = p_company_id
                AND t.store_id = p_store_id
                AND t.is_deleted = FALSE
            WHERE c.company_id = p_company_id
                AND c.is_deleted = FALSE
                -- Apply filter
                AND (p_filter = 'all' 
                    OR (p_filter = 'internal' AND c.is_internal = TRUE)
                    OR (p_filter = 'external' AND c.is_internal = FALSE))
            GROUP BY t.counterparty_id, c.name, c.is_internal
            HAVING p_show_all = TRUE OR COUNT(t.id) > 0
        ),
        store_summary AS (
            SELECT 
                SUM(receivable_amount) as total_receivable,
                SUM(payable_amount) as total_payable,
                SUM(receivable_amount) - SUM(payable_amount) as net_position,
                SUM(CASE WHEN is_internal THEN receivable_amount ELSE 0 END) as internal_receivable,
                SUM(CASE WHEN is_internal THEN payable_amount ELSE 0 END) as internal_payable,
                SUM(CASE WHEN NOT is_internal THEN receivable_amount ELSE 0 END) as external_receivable,
                SUM(CASE WHEN NOT is_internal THEN payable_amount ELSE 0 END) as external_payable,
                COUNT(DISTINCT counterparty_id) as counterparty_count,
                SUM(transaction_count) as transaction_count
            FROM store_transactions
        )
        SELECT jsonb_build_object(
            'metadata', jsonb_build_object(
                'company_id', p_company_id,
                'store_id', p_store_id,
                'perspective', 'store',
                'filter', p_filter,
                'generated_at', now(),
                'currency', '₫'
            ),
            'summary', (SELECT row_to_json(store_summary) FROM store_summary),
            'store_aggregates', '[]'::jsonb, -- Empty for store perspective
            'records', (
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'counterparty_id', counterparty_id,
                        'counterparty_name', counterparty_name,
                        'is_internal', is_internal,
                        'receivable_amount', receivable_amount,
                        'payable_amount', payable_amount,
                        'net_amount', receivable_amount - payable_amount,
                        'last_activity', last_activity,
                        'transaction_count', transaction_count
                    )
                ) FROM store_transactions
            )
        ) INTO v_store_data;
    END IF;

    -- ==================================
    -- PART 3: Return Combined Result
    -- ==================================
    v_result := jsonb_build_object(
        'company', v_company_data,
        'store', v_store_data,
        'metadata', jsonb_build_object(
            'version', '2.0',
            'generated_at', now(),
            'has_both_perspectives', (p_store_id IS NOT NULL)
        )
    );

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_debt_control_data_v2 TO anon, authenticated;

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_transactions_debt_control 
ON transactions(company_id, store_id, counterparty_id, transaction_type, is_deleted)
WHERE is_deleted = FALSE;

-- Comment
COMMENT ON FUNCTION get_debt_control_data_v2 IS 
'Optimized debt control function v2.0 - Returns both company and store perspectives in one call with proper math handling';