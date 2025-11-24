-- ============================================================================
-- get_location_stock_flow_v2 RPC Function
-- ============================================================================
-- File: CREATE_GET_LOCATION_STOCK_FLOW_V2_FIXED_2025-11-23.sql
-- Date: 2025-11-23
-- Purpose: Replace get_location_stock_flow (V1) with new table structure
--
-- Key Changes:
--   ✅ Uses cash_amount_entries + cashier_amount_lines (new architecture)
--   ✅ Same output structure as V1 (100% compatible)
--   ✅ Adds previous_quantity using LATERAL JOIN
--   ✅ Handles store_id NULL cases
--
-- Data Source Changes:
--   OLD: cash_amount_stock_flow table
--   NEW: cash_amount_entries + cashier_amount_lines tables
--
-- ============================================================================

CREATE OR REPLACE FUNCTION get_location_stock_flow_v2(
    p_company_id uuid,
    p_store_id uuid,
    p_cash_location_id uuid,
    p_offset integer DEFAULT 0,
    p_limit integer DEFAULT 20
)
RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
    result JSON;
BEGIN
    WITH
    -- 1. Cash Location Summary with fallback currency
    location_info AS (
        SELECT
            cl.cash_location_id,
            cl.location_name,
            cl.location_type,
            cl.bank_name,
            cl.bank_account,
            -- Use currency from cash_locations or fallback to latest cash_amount_entries
            COALESCE(cl.currency_id,
                (SELECT currency_id FROM cash_amount_entries
                 WHERE location_id = cl.cash_location_id
                 AND company_id = p_company_id
                 ORDER BY created_at DESC
                 LIMIT 1)
            ) as currency_id,
            COALESCE(ct.currency_code,
                (SELECT ct2.currency_code FROM cash_amount_entries cae
                 JOIN currency_types ct2 ON cae.currency_id = ct2.currency_id
                 WHERE cae.location_id = cl.cash_location_id
                 AND cae.company_id = p_company_id
                 ORDER BY cae.created_at DESC
                 LIMIT 1)
            ) as currency_code,
            COALESCE(ct.currency_name,
                (SELECT ct2.currency_name FROM cash_amount_entries cae
                 JOIN currency_types ct2 ON cae.currency_id = ct2.currency_id
                 WHERE cae.location_id = cl.cash_location_id
                 AND cae.company_id = p_company_id
                 ORDER BY cae.created_at DESC
                 LIMIT 1)
            ) as currency_name,
            -- Base currency info
            c.base_currency_id,
            bct.currency_code as base_currency_code,
            bct.currency_name as base_currency_name,
            bct.symbol as base_currency_symbol
        FROM cash_locations cl
        LEFT JOIN currency_types ct ON cl.currency_id = ct.currency_id
        LEFT JOIN companies c ON c.company_id = p_company_id
        LEFT JOIN currency_types bct ON c.base_currency_id = bct.currency_id
        WHERE cl.cash_location_id = p_cash_location_id
        AND cl.company_id = p_company_id
        AND cl.is_deleted = false
        LIMIT 1
    ),

    -- 2. Journal Flows (same as V1)
    journal_flows_data AS (
        SELECT
            j.flow_id,
            j.created_at,
            j.system_time,
            j.balance_before,
            j.flow_amount,
            j.balance_after,
            j.journal_id,
            je.description as journal_description,
            je.journal_type,
            j.account_id,
            a.account_name,
            j.created_by,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name,
            -- Counter account info
            (
                SELECT json_build_object(
                    'account_id', jl2.account_id,
                    'account_name', a2.account_name,
                    'account_type', a2.account_type,
                    'debit', jl2.debit,
                    'credit', jl2.credit,
                    'description', jl2.description,
                    'cash_location_id', jl2.cash_location_id,
                    'cash_location_name', cl2.location_name
                )
                FROM journal_lines jl2
                LEFT JOIN accounts a2 ON jl2.account_id = a2.account_id
                LEFT JOIN cash_locations cl2 ON jl2.cash_location_id = cl2.cash_location_id
                WHERE jl2.journal_id = j.journal_id
                AND (jl2.cash_location_id IS NULL OR jl2.cash_location_id != j.cash_location_id)
                AND jl2.is_deleted = false
                ORDER BY GREATEST(jl2.debit, jl2.credit) DESC
                LIMIT 1
            ) as counter_account
        FROM journal_amount_stock_flow j
        LEFT JOIN journal_entries je ON j.journal_id = je.journal_id
        LEFT JOIN accounts a ON j.account_id = a.account_id
        LEFT JOIN users u ON j.created_by = u.user_id
        WHERE j.company_id = p_company_id
        AND (p_store_id IS NULL OR j.store_id = p_store_id OR j.store_id IS NULL)
        AND j.cash_location_id = p_cash_location_id
        ORDER BY j.system_time DESC
        OFFSET p_offset
        LIMIT p_limit
    ),

    -- 3. Actual (Cash) Flows from NEW TABLES with LATERAL JOIN for previous_quantity
    actual_flows_data AS (
        SELECT
            cae.entry_id as flow_id,
            cae.created_at,
            cae.created_at as system_time,
            cae.balance_before,
            cae.total_amount as flow_amount,
            cae.balance_after,
            cae.currency_id,
            ct.currency_code,
            ct.currency_name,
            ct.symbol as currency_symbol,
            cae.created_by,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name,
            cae.entry_type as location_type,

            -- Build denomination details WITH METHOD-AWARE LOGIC
            (
                SELECT json_agg(
                    json_build_object(
                        'denomination_id', cal.denomination_id,
                        'denomination_value', cd.value,
                        'denomination_type', cd.type,
                        'current_quantity', cal.quantity,

                        -- ✅ METHOD-AWARE previous quantity
                        'previous_quantity', CASE
                            -- Stock Method: Get previous stock quantity
                            WHEN COALESCE(cae.method_type, 'stock') = 'stock'
                            THEN COALESCE(prev.prev_quantity, 0)
                            -- Flow Method: Previous is always 0 (transaction-based)
                            ELSE 0
                        END,

                        -- ✅ METHOD-AWARE quantity change
                        'quantity_change', CASE
                            -- Stock Method: Current - Previous
                            WHEN COALESCE(cae.method_type, 'stock') = 'stock'
                            THEN cal.quantity - COALESCE(prev.prev_quantity, 0)
                            -- Flow Method: Change = Current (the transaction itself)
                            ELSE cal.quantity
                        END,

                        'subtotal', cal.quantity * cd.value,
                        'currency_id', cal.currency_id,
                        'currency_code', ct2.currency_code,
                        'currency_name', ct2.currency_name,
                        'currency_symbol', ct2.symbol
                    )
                    ORDER BY cd.value DESC
                )
                FROM cashier_amount_lines cal
                LEFT JOIN currency_denominations cd
                    ON cal.denomination_id = cd.denomination_id
                LEFT JOIN currency_types ct2
                    ON cal.currency_id = ct2.currency_id

                -- ✅ LATERAL JOIN: Get previous quantity for each denomination
                LEFT JOIN LATERAL (
                    SELECT prev_cal.quantity as prev_quantity
                    FROM cashier_amount_lines prev_cal
                    JOIN cash_amount_entries prev_cae
                        ON prev_cal.entry_id = prev_cae.entry_id
                    WHERE prev_cal.denomination_id = cal.denomination_id
                      AND prev_cal.location_id = cal.location_id
                      AND prev_cae.created_at < cae.created_at
                      AND prev_cae.company_id = p_company_id
                    ORDER BY prev_cae.created_at DESC
                    LIMIT 1
                ) prev ON true

                WHERE cal.entry_id = cae.entry_id
            ) as denomination_details

        FROM cash_amount_entries cae
        LEFT JOIN currency_types ct ON cae.currency_id = ct.currency_id
        LEFT JOIN users u ON cae.created_by = u.user_id
        WHERE cae.company_id = p_company_id
        AND (p_store_id IS NULL OR cae.store_id = p_store_id OR cae.store_id IS NULL)
        AND cae.location_id = p_cash_location_id
        ORDER BY cae.created_at DESC
        OFFSET p_offset
        LIMIT p_limit
    ),

    -- Count total records for pagination
    total_counts AS (
        SELECT
            (SELECT COUNT(*) FROM journal_amount_stock_flow
             WHERE company_id = p_company_id
             AND (p_store_id IS NULL OR store_id = p_store_id OR store_id IS NULL)
             AND cash_location_id = p_cash_location_id) as total_journal_flows,
            (SELECT COUNT(*) FROM cash_amount_entries
             WHERE company_id = p_company_id
             AND (p_store_id IS NULL OR store_id = p_store_id OR store_id IS NULL)
             AND location_id = p_cash_location_id) as total_actual_flows
    )

    -- Build final JSON result (SAME STRUCTURE AS V1)
    SELECT json_build_object(
        'success', true,
        'data', json_build_object(
            -- Location Summary
            'location_summary', (
                SELECT json_build_object(
                    'cash_location_id', cash_location_id,
                    'location_name', location_name,
                    'location_type', location_type,
                    'bank_name', bank_name,
                    'bank_account', bank_account,
                    'currency_id', currency_id,
                    'currency_code', currency_code,
                    'currency_name', currency_name,
                    'base_currency_id', base_currency_id,
                    'base_currency_code', base_currency_code,
                    'base_currency_name', base_currency_name,
                    'base_currency_symbol', base_currency_symbol
                )
                FROM location_info
            ),

            -- Journal Flows with counter account
            'journal_flows', COALESCE(
                (SELECT json_agg(
                    json_build_object(
                        'flow_id', flow_id,
                        'created_at', created_at,
                        'system_time', system_time,
                        'balance_before', balance_before,
                        'flow_amount', flow_amount,
                        'balance_after', balance_after,
                        'journal_id', journal_id,
                        'journal_description', journal_description,
                        'journal_type', journal_type,
                        'account_id', account_id,
                        'account_name', account_name,
                        'created_by', json_build_object(
                            'user_id', created_by,
                            'full_name', created_by_name
                        ),
                        'counter_account', counter_account
                    )
                    ORDER BY system_time DESC
                ) FROM journal_flows_data),
                '[]'::json
            ),

            -- Actual Flows with denominations (SAME FORMAT AS V1, but from NEW TABLES)
            'actual_flows', COALESCE(
                (SELECT json_agg(
                    json_build_object(
                        'flow_id', flow_id,
                        'created_at', created_at,
                        'system_time', system_time,
                        'balance_before', balance_before,
                        'flow_amount', flow_amount,
                        'balance_after', balance_after,
                        'currency', json_build_object(
                            'currency_id', currency_id,
                            'currency_code', currency_code,
                            'currency_name', currency_name,
                            'symbol', currency_symbol
                        ),
                        'created_by', json_build_object(
                            'user_id', created_by,
                            'full_name', created_by_name
                        ),
                        'current_denominations', COALESCE(denomination_details, '[]'::json)
                    )
                    ORDER BY system_time DESC
                ) FROM actual_flows_data),
                '[]'::json
            )
        ),
        'pagination', json_build_object(
            'offset', p_offset,
            'limit', p_limit,
            'total_journal_flows', (SELECT total_journal_flows FROM total_counts),
            'total_actual_flows', (SELECT total_actual_flows FROM total_counts),
            'has_more', (
                (SELECT total_journal_flows FROM total_counts) > (p_offset + p_limit) OR
                (SELECT total_actual_flows FROM total_counts) > (p_offset + p_limit)
            )
        )
    ) INTO result;

    RETURN result;
END;
$$;

-- ============================================================================
-- Test Query
-- ============================================================================
/*
SELECT get_location_stock_flow_v2(
  p_company_id := '7a2545e0-e112-4b0c-9c59-221a530c4602'::uuid,
  p_store_id := 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff'::uuid,
  p_cash_location_id := 'e512d176-a55a-4688-a525-8f02f4a272ee'::uuid,
  p_offset := 0,
  p_limit := 5
);
*/

-- ============================================================================
-- Comparison with V1
-- ============================================================================
/*
V1: get_location_stock_flow
  - Data Source: cash_amount_stock_flow table
  - Problem: Some entries have store_id = NULL, causing filter issues

V2: get_location_stock_flow_v2
  - Data Source: cash_amount_entries + cashier_amount_lines
  - Solution: Handles NULL store_id with OR condition
  - Bonus: Adds previous_quantity + quantity_change

Output Structure: 100% IDENTICAL
*/
