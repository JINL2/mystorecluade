-- ============================================================================
-- get_location_stock_flow_v2 RPC Function - CORRECT VERSION
-- ============================================================================
-- Date: 2025-11-23
-- Purpose: Replace get_location_stock_flow with correct table joins
--
-- Key Understanding:
--   Cash  → cashier_amount_lines (Stock, has denomination)
--   Bank  → bank_amount          (Stock, NO denomination)
--   Vault → vault_amount_line    (Flow, has denomination)
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
    -- 1. Cash Location Summary
    location_info AS (
        SELECT
            cl.cash_location_id,
            cl.location_name,
            cl.location_type,
            cl.bank_name,
            cl.bank_account,
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
            (
                SELECT json_build_object(
                    'account_id', jl2.account_id,
                    'account_name', a2.account_name,
                    'amount', COALESCE(jl2.debit, jl2.credit, 0)
                )
                FROM journal_lines jl2
                LEFT JOIN accounts a2 ON jl2.account_id = a2.account_id
                WHERE jl2.journal_id = j.journal_id
                AND jl2.account_id != j.account_id
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

    -- 3. Actual Flows - UNION of Cash, Bank, Vault
    actual_flows_data AS (
        -- ========================================
        -- CASH: cashier_amount_lines (Stock Method, has denomination)
        -- ========================================
        SELECT
            cae.entry_id as flow_id,
            cae.created_at,
            cae.created_at as system_time,
            cae.balance_before,
            cae.net_cash_flow as flow_amount,
            cae.balance_after,
            cae.currency_id,
            ct.currency_code,
            ct.currency_name,
            ct.symbol as currency_symbol,
            cae.created_by,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name,
            'cash' as location_type,

            -- Cash: Build denomination details (Stock Method)
            (
                SELECT json_agg(
                    json_build_object(
                        'denomination_id', cal.denomination_id,
                        'denomination_value', cd.value,
                        'denomination_type', cd.type,
                        'current_quantity', cal.quantity,
                        'previous_quantity', COALESCE(prev.prev_quantity, 0),
                        'quantity_change', cal.quantity - COALESCE(prev.prev_quantity, 0),
                        'subtotal', cal.quantity * cd.value,
                        'currency_id', cal.currency_id,
                        'currency_code', ct2.currency_code,
                        'currency_name', ct2.currency_name,
                        'currency_symbol', ct2.symbol
                    )
                    ORDER BY cd.value DESC
                )
                FROM cashier_amount_lines cal
                LEFT JOIN currency_denominations cd ON cal.denomination_id = cd.denomination_id
                LEFT JOIN currency_types ct2 ON cal.currency_id = ct2.currency_id
                LEFT JOIN LATERAL (
                    SELECT prev_cal.quantity as prev_quantity
                    FROM cashier_amount_lines prev_cal
                    JOIN cash_amount_entries prev_cae ON prev_cal.entry_id = prev_cae.entry_id
                    WHERE prev_cal.denomination_id = cal.denomination_id
                      AND prev_cal.location_id = cal.location_id
                      AND prev_cae.created_at < cae.created_at
                      AND prev_cae.company_id = p_company_id
                      AND prev_cae.entry_type = 'cash'
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
          AND cae.entry_type = 'cash'

        UNION ALL

        -- ========================================
        -- BANK: bank_amount (Stock Method, NO denomination)
        -- ========================================
        SELECT
            cae.entry_id as flow_id,
            cae.created_at,
            cae.created_at as system_time,
            cae.balance_before,
            cae.net_cash_flow as flow_amount,
            cae.balance_after,
            cae.currency_id,
            ct.currency_code,
            ct.currency_name,
            ct.symbol as currency_symbol,
            cae.created_by,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name,
            'bank' as location_type,

            -- Bank: Build multi-currency details from denomination_summary
            COALESCE(
                (
                    SELECT json_agg(
                        json_build_object(
                            'currency_id', (curr_detail->>'currency_id')::UUID,
                            'currency_code', ct2.currency_code,
                            'currency_name', ct2.currency_name,
                            'currency_symbol', ct2.symbol,
                            'amount', (curr_detail->>'amount')::NUMERIC,
                            'exchange_rate', (cae.exchange_rates->(curr_detail->>'currency_id'))::NUMERIC,
                            'amount_in_base_currency',
                                (curr_detail->>'amount')::NUMERIC *
                                (cae.exchange_rates->(curr_detail->>'currency_id'))::NUMERIC
                        )
                    )
                    FROM jsonb_array_elements(cae.denomination_summary) AS curr_detail
                    LEFT JOIN currency_types ct2 ON (curr_detail->>'currency_id')::UUID = ct2.currency_id
                ),
                '[]'::json
            ) as denomination_details

        FROM cash_amount_entries cae
        LEFT JOIN currency_types ct ON cae.currency_id = ct.currency_id
        LEFT JOIN users u ON cae.created_by = u.user_id
        WHERE cae.company_id = p_company_id
          AND (p_store_id IS NULL OR cae.store_id = p_store_id OR cae.store_id IS NULL)
          AND cae.location_id = p_cash_location_id
          AND cae.entry_type = 'bank'

        UNION ALL

        -- ========================================
        -- VAULT: vault_amount_line (Flow Concept, has denomination)
        -- Current = debit - credit
        -- Previous = 이전 row의 (debit - credit)
        -- Change = Current - Previous
        -- ========================================
        SELECT
            cae.entry_id as flow_id,
            cae.created_at,
            cae.created_at as system_time,
            cae.balance_before,
            cae.net_cash_flow as flow_amount,
            cae.balance_after,
            cae.currency_id,
            ct.currency_code,
            ct.currency_name,
            ct.symbol as currency_symbol,
            cae.created_by,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name,
            'vault' as location_type,

            -- Vault: Build denomination details
            (
                SELECT json_agg(
                    json_build_object(
                        'denomination_id', val.denomination_id,
                        'denomination_value', cd.value,
                        'denomination_type', cd.type,
                        'current_quantity', COALESCE(val.debit, 0) - COALESCE(val.credit, 0),
                        'previous_quantity', COALESCE(prev.prev_quantity, 0),
                        'quantity_change', (COALESCE(val.debit, 0) - COALESCE(val.credit, 0)) - COALESCE(prev.prev_quantity, 0),
                        'subtotal', (COALESCE(val.debit, 0) - COALESCE(val.credit, 0)) * cd.value,
                        'currency_id', val.currency_id,
                        'currency_code', ct2.currency_code,
                        'currency_name', ct2.currency_name,
                        'currency_symbol', ct2.symbol
                    )
                    ORDER BY cd.value DESC
                )
                FROM vault_amount_line val
                LEFT JOIN currency_denominations cd ON val.denomination_id = cd.denomination_id
                LEFT JOIN currency_types ct2 ON val.currency_id = ct2.currency_id
                LEFT JOIN LATERAL (
                    SELECT COALESCE(prev_val.debit, 0) - COALESCE(prev_val.credit, 0) as prev_quantity
                    FROM vault_amount_line prev_val
                    JOIN cash_amount_entries prev_cae ON prev_val.entry_id = prev_cae.entry_id
                    WHERE prev_val.denomination_id = val.denomination_id
                      AND prev_val.location_id = val.location_id
                      AND prev_cae.created_at < cae.created_at
                      AND prev_cae.company_id = p_company_id
                      AND prev_cae.entry_type = 'vault'
                    ORDER BY prev_cae.created_at DESC
                    LIMIT 1
                ) prev ON true
                WHERE val.entry_id = cae.entry_id
            ) as denomination_details

        FROM cash_amount_entries cae
        LEFT JOIN currency_types ct ON cae.currency_id = ct.currency_id
        LEFT JOIN users u ON cae.created_by = u.user_id
        WHERE cae.company_id = p_company_id
          AND (p_store_id IS NULL OR cae.store_id = p_store_id OR cae.store_id IS NULL)
          AND cae.location_id = p_cash_location_id
          AND cae.entry_type = 'vault'

        ORDER BY created_at DESC
        OFFSET p_offset
        LIMIT p_limit
    ),

    -- Count total records
    total_counts AS (
        SELECT
            (SELECT COUNT(*) FROM journal_amount_stock_flow
             WHERE company_id = p_company_id
             AND (p_store_id IS NULL OR store_id = p_store_id OR store_id IS NULL)
             AND cash_location_id = p_cash_location_id
            ) as total_journal,
            (SELECT COUNT(*) FROM cash_amount_entries
             WHERE company_id = p_company_id
             AND (p_store_id IS NULL OR store_id = p_store_id OR store_id IS NULL)
             AND location_id = p_cash_location_id
            ) as total_actual
    )

    -- Build final JSON response
    SELECT json_build_object(
        'location', (SELECT row_to_json(li.*) FROM location_info li),
        'journal_flows', (SELECT COALESCE(json_agg(jf.*), '[]'::json) FROM journal_flows_data jf),
        'actual_flows', (SELECT COALESCE(json_agg(af.*), '[]'::json) FROM actual_flows_data af),
        'pagination', json_build_object(
            'offset', p_offset,
            'limit', p_limit,
            'total_journal', (SELECT total_journal FROM total_counts),
            'total_actual', (SELECT total_actual FROM total_counts)
        )
    ) INTO result;

    RETURN result;
END;
$$;

-- ============================================================================
-- COMMENT
-- ============================================================================
COMMENT ON FUNCTION get_location_stock_flow_v2(uuid, uuid, uuid, integer, integer) IS
'Get stock flow data for a cash location with correct table joins:
- Cash: cashier_amount_lines (Stock, has denomination)
- Bank: bank_amount (Stock, NO denomination)
- Vault: vault_amount_line (Flow/Stock, has denomination)';
