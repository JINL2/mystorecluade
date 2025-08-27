-- =====================================================
-- Debt Control Migration Script to V2
-- =====================================================
-- This script ensures compatibility while migrating to v2
-- 
-- Author: System
-- Version: 2.0
-- Date: 2025-01-26
-- =====================================================

-- First, ensure v2 function exists (if not already created)
-- Drop and recreate to ensure latest version
DROP FUNCTION IF EXISTS get_debt_control_data_v2;

CREATE OR REPLACE FUNCTION get_debt_control_data_v2(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,
    p_filter TEXT DEFAULT 'all',
    p_show_all BOOLEAN DEFAULT FALSE
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_company_data JSONB;
    v_store_data JSONB;
    v_metadata JSONB;
    v_currency TEXT := 'VND';
BEGIN
    -- Company perspective calculation
    WITH company_transactions AS (
        SELECT 
            t.id,
            t.transaction_date,
            t.due_date,
            CASE 
                WHEN t.buyer = p_company_id THEN t.supplier
                ELSE t.buyer
            END AS counterparty_id,
            CASE 
                WHEN t.buyer = p_company_id THEN -t.final_amount
                ELSE t.final_amount
            END AS amount,
            CASE 
                WHEN t.buyer = p_company_id THEN 0
                ELSE t.final_amount
            END AS receivable_amount,
            CASE 
                WHEN t.buyer = p_company_id THEN t.final_amount
                ELSE 0
            END AS payable_amount,
            t.store_id,
            t.payment_status,
            t.created_at
        FROM transactions t
        WHERE (t.buyer = p_company_id OR t.supplier = p_company_id)
            AND t.transaction_type IN ('purchase', 'sale')
            AND t.is_deleted = false
            AND t.payment_status IN ('pending', 'partial')
    ),
    company_counterparties AS (
        SELECT 
            ct.counterparty_id,
            c.company_name AS counterparty_name,
            c.is_internal,
            SUM(ct.amount) AS net_amount,
            SUM(ct.receivable_amount) AS receivable_amount,
            SUM(ct.payable_amount) AS payable_amount,
            MAX(ct.transaction_date) AS last_activity,
            COUNT(ct.id) AS transaction_count
        FROM company_transactions ct
        LEFT JOIN company c ON c.id = ct.counterparty_id
        WHERE c.id IS NOT NULL
        GROUP BY ct.counterparty_id, c.company_name, c.is_internal
    ),
    all_counterparties AS (
        SELECT 
            c.id AS counterparty_id,
            c.company_name AS counterparty_name,
            c.is_internal,
            COALESCE(cc.net_amount, 0) AS net_amount,
            COALESCE(cc.receivable_amount, 0) AS receivable_amount,
            COALESCE(cc.payable_amount, 0) AS payable_amount,
            cc.last_activity,
            COALESCE(cc.transaction_count, 0) AS transaction_count
        FROM company c
        LEFT JOIN company_counterparties cc ON c.id = cc.counterparty_id
        WHERE c.id != p_company_id
            AND c.is_deleted = false
            AND (
                p_show_all = true
                OR cc.counterparty_id IS NOT NULL
            )
    ),
    filtered_company_data AS (
        SELECT * FROM all_counterparties
        WHERE (p_filter = 'all')
            OR (p_filter = 'internal' AND is_internal = true)
            OR (p_filter = 'external' AND is_internal = false)
    ),
    company_summary AS (
        SELECT 
            COALESCE(SUM(receivable_amount), 0) AS total_receivable,
            COALESCE(SUM(payable_amount), 0) AS total_payable,
            COALESCE(SUM(net_amount), 0) AS net_position,
            COALESCE(SUM(CASE WHEN is_internal THEN receivable_amount ELSE 0 END), 0) AS internal_receivable,
            COALESCE(SUM(CASE WHEN is_internal THEN payable_amount ELSE 0 END), 0) AS internal_payable,
            COALESCE(SUM(CASE WHEN NOT is_internal THEN receivable_amount ELSE 0 END), 0) AS external_receivable,
            COALESCE(SUM(CASE WHEN NOT is_internal THEN payable_amount ELSE 0 END), 0) AS external_payable,
            COUNT(DISTINCT counterparty_id) AS counterparty_count,
            COALESCE(SUM(transaction_count), 0)::INT AS transaction_count
        FROM filtered_company_data
    ),
    store_aggregates AS (
        SELECT 
            s.id AS store_id,
            s.store_name,
            COALESCE(SUM(CASE 
                WHEN t.buyer = p_company_id THEN 0
                ELSE t.final_amount
            END), 0) AS receivable,
            COALESCE(SUM(CASE 
                WHEN t.buyer = p_company_id THEN t.final_amount
                ELSE 0
            END), 0) AS payable,
            COALESCE(SUM(CASE 
                WHEN t.buyer = p_company_id THEN -t.final_amount
                ELSE t.final_amount
            END), 0) AS net_position,
            COUNT(DISTINCT CASE 
                WHEN t.buyer = p_company_id THEN t.supplier
                ELSE t.buyer
            END) AS counterparty_count
        FROM store s
        LEFT JOIN transactions t ON t.store_id = s.id 
            AND (t.buyer = p_company_id OR t.supplier = p_company_id)
            AND t.transaction_type IN ('purchase', 'sale')
            AND t.is_deleted = false
            AND t.payment_status IN ('pending', 'partial')
        WHERE s.company_id = p_company_id
            AND s.is_deleted = false
        GROUP BY s.id, s.store_name
        HAVING COALESCE(SUM(CASE 
            WHEN t.buyer = p_company_id THEN -t.final_amount
            ELSE t.final_amount
        END), 0) != 0
    )
    SELECT jsonb_build_object(
        'metadata', jsonb_build_object(
            'company_id', p_company_id,
            'store_id', NULL,
            'store_name', NULL,
            'perspective', 'company',
            'filter', p_filter,
            'generated_at', NOW(),
            'currency', v_currency
        ),
        'summary', (SELECT row_to_json(company_summary) FROM company_summary),
        'store_aggregates', COALESCE(
            (SELECT jsonb_agg(row_to_json(sa)) FROM store_aggregates sa),
            '[]'::jsonb
        ),
        'records', COALESCE(
            (SELECT jsonb_agg(
                jsonb_build_object(
                    'counterparty_id', counterparty_id,
                    'counterparty_name', counterparty_name,
                    'is_internal', is_internal,
                    'receivable_amount', receivable_amount,
                    'payable_amount', payable_amount,
                    'net_amount', net_amount,
                    'last_activity', last_activity,
                    'transaction_count', transaction_count
                ) ORDER BY ABS(net_amount) DESC
            ) FROM filtered_company_data),
            '[]'::jsonb
        )
    ) INTO v_company_data;

    -- Store perspective (if requested)
    IF p_store_id IS NOT NULL THEN
        WITH store_transactions AS (
            SELECT 
                t.id,
                t.transaction_date,
                t.due_date,
                CASE 
                    WHEN t.buyer = p_company_id THEN t.supplier
                    ELSE t.buyer
                END AS counterparty_id,
                CASE 
                    WHEN t.buyer = p_company_id THEN -t.final_amount
                    ELSE t.final_amount
                END AS amount,
                CASE 
                    WHEN t.buyer = p_company_id THEN 0
                    ELSE t.final_amount
                END AS receivable_amount,
                CASE 
                    WHEN t.buyer = p_company_id THEN t.final_amount
                    ELSE 0
                END AS payable_amount,
                t.payment_status,
                t.created_at
            FROM transactions t
            WHERE (t.buyer = p_company_id OR t.supplier = p_company_id)
                AND t.store_id = p_store_id
                AND t.transaction_type IN ('purchase', 'sale')
                AND t.is_deleted = false
                AND t.payment_status IN ('pending', 'partial')
        ),
        store_counterparties AS (
            SELECT 
                st.counterparty_id,
                c.company_name AS counterparty_name,
                c.is_internal,
                SUM(st.amount) AS net_amount,
                SUM(st.receivable_amount) AS receivable_amount,
                SUM(st.payable_amount) AS payable_amount,
                MAX(st.transaction_date) AS last_activity,
                COUNT(st.id) AS transaction_count
            FROM store_transactions st
            LEFT JOIN company c ON c.id = st.counterparty_id
            WHERE c.id IS NOT NULL
            GROUP BY st.counterparty_id, c.company_name, c.is_internal
        ),
        all_store_counterparties AS (
            SELECT 
                c.id AS counterparty_id,
                c.company_name AS counterparty_name,
                c.is_internal,
                COALESCE(sc.net_amount, 0) AS net_amount,
                COALESCE(sc.receivable_amount, 0) AS receivable_amount,
                COALESCE(sc.payable_amount, 0) AS payable_amount,
                sc.last_activity,
                COALESCE(sc.transaction_count, 0) AS transaction_count
            FROM company c
            LEFT JOIN store_counterparties sc ON c.id = sc.counterparty_id
            WHERE c.id != p_company_id
                AND c.is_deleted = false
                AND (
                    p_show_all = true
                    OR sc.counterparty_id IS NOT NULL
                )
        ),
        filtered_store_data AS (
            SELECT * FROM all_store_counterparties
            WHERE (p_filter = 'all')
                OR (p_filter = 'internal' AND is_internal = true)
                OR (p_filter = 'external' AND is_internal = false)
        ),
        store_summary AS (
            SELECT 
                COALESCE(SUM(receivable_amount), 0) AS total_receivable,
                COALESCE(SUM(payable_amount), 0) AS total_payable,
                COALESCE(SUM(net_amount), 0) AS net_position,
                COALESCE(SUM(CASE WHEN is_internal THEN receivable_amount ELSE 0 END), 0) AS internal_receivable,
                COALESCE(SUM(CASE WHEN is_internal THEN payable_amount ELSE 0 END), 0) AS internal_payable,
                COALESCE(SUM(CASE WHEN NOT is_internal THEN receivable_amount ELSE 0 END), 0) AS external_receivable,
                COALESCE(SUM(CASE WHEN NOT is_internal THEN payable_amount ELSE 0 END), 0) AS external_payable,
                COUNT(DISTINCT counterparty_id) AS counterparty_count,
                COALESCE(SUM(transaction_count), 0)::INT AS transaction_count
            FROM filtered_store_data
        )
        SELECT jsonb_build_object(
            'metadata', jsonb_build_object(
                'company_id', p_company_id,
                'store_id', p_store_id,
                'store_name', (SELECT store_name FROM store WHERE id = p_store_id),
                'perspective', 'store',
                'filter', p_filter,
                'generated_at', NOW(),
                'currency', v_currency
            ),
            'summary', (SELECT row_to_json(store_summary) FROM store_summary),
            'store_aggregates', '[]'::jsonb,
            'records', COALESCE(
                (SELECT jsonb_agg(
                    jsonb_build_object(
                        'counterparty_id', counterparty_id,
                        'counterparty_name', counterparty_name,
                        'is_internal', is_internal,
                        'receivable_amount', receivable_amount,
                        'payable_amount', payable_amount,
                        'net_amount', net_amount,
                        'last_activity', last_activity,
                        'transaction_count', transaction_count
                    ) ORDER BY ABS(net_amount) DESC
                ) FROM filtered_store_data),
                '[]'::jsonb
            )
        ) INTO v_store_data;
    ELSE
        v_store_data := NULL;
    END IF;

    -- Build final response
    v_metadata := jsonb_build_object(
        'version', '2.0',
        'generated_at', NOW(),
        'has_both_perspectives', (p_store_id IS NOT NULL)
    );

    RETURN jsonb_build_object(
        'company', v_company_data,
        'store', v_store_data,
        'metadata', v_metadata
    );
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_debt_control_data_v2(UUID, UUID, TEXT, BOOLEAN) TO authenticated;
GRANT EXECUTE ON FUNCTION get_debt_control_data_v2(UUID, UUID, TEXT, BOOLEAN) TO anon;

-- Add comment
COMMENT ON FUNCTION get_debt_control_data_v2 IS 'V2 Debt Control function that returns both company and store perspectives in a single call for optimal performance';

-- =====================================================
-- Create indexes if they don't exist
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_transactions_buyer_payment_status 
ON transactions(buyer, payment_status) 
WHERE is_deleted = false;

CREATE INDEX IF NOT EXISTS idx_transactions_supplier_payment_status 
ON transactions(supplier, payment_status) 
WHERE is_deleted = false;

CREATE INDEX IF NOT EXISTS idx_transactions_store_payment 
ON transactions(store_id, payment_status) 
WHERE is_deleted = false;

CREATE INDEX IF NOT EXISTS idx_company_internal 
ON company(is_internal) 
WHERE is_deleted = false;

-- =====================================================
-- Test the function
-- =====================================================
DO $$
DECLARE
    v_result JSONB;
BEGIN
    -- Test the function
    SELECT get_debt_control_data_v2(
        '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,
        'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff'::UUID,
        'all',
        false
    ) INTO v_result;
    
    -- Check if result has expected structure
    IF v_result IS NOT NULL AND 
       v_result ? 'company' AND 
       v_result ? 'metadata' THEN
        RAISE NOTICE 'V2 function test successful!';
        RAISE NOTICE 'Company net position: %', 
            v_result->'company'->'summary'->>'net_position';
        IF v_result ? 'store' AND v_result->'store' IS NOT NULL THEN
            RAISE NOTICE 'Store net position: %', 
                v_result->'store'->'summary'->>'net_position';
        END IF;
    ELSE
        RAISE WARNING 'V2 function test failed - unexpected structure';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'V2 function test error: %', SQLERRM;
END $$;