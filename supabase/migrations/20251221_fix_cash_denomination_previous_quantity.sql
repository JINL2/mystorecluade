-- Migration: Fix CASH denomination previous_quantity calculation
-- Issue: When a denomination quantity is 0, no row exists in cashier_amount_lines
--        This causes the LATERAL subquery to find an older entry instead of the immediately previous one
-- Solution: Use current_stock_snapshot (like Vault) which stores ALL denominations including 0 quantity
--
-- Tested Edge Cases:
-- 1. First entry (no previous) - previous_qty = 0 ✅
-- 2. NULL snapshot - 0 records affected ✅
-- 3. Empty denominations array - 0 records affected ✅
-- 4. Duplicate timestamps - 0 records affected ✅
-- 5. Entry with 0→N quantity change - correctly shows change ✅

CREATE OR REPLACE FUNCTION public.get_location_stock_flow_v2_utc(
    p_company_id uuid,
    p_store_id uuid DEFAULT NULL::uuid,
    p_cash_location_id uuid DEFAULT NULL::uuid,
    p_offset integer DEFAULT 0,
    p_limit integer DEFAULT 20
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
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
                 ORDER BY created_at_utc DESC
                 LIMIT 1)
            ) as currency_id,
            COALESCE(ct.currency_code,
                (SELECT ct2.currency_code FROM cash_amount_entries cae
                 JOIN currency_types ct2 ON cae.currency_id = ct2.currency_id
                 WHERE cae.location_id = cl.cash_location_id
                 AND cae.company_id = p_company_id
                 ORDER BY cae.created_at_utc DESC
                 LIMIT 1)
            ) as currency_code,
            COALESCE(ct.currency_name,
                (SELECT ct2.currency_name FROM cash_amount_entries cae
                 JOIN currency_types ct2 ON cae.currency_id = ct2.currency_id
                 WHERE cae.location_id = cl.cash_location_id
                 AND cae.company_id = p_company_id
                 ORDER BY cae.created_at_utc DESC
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

    -- 2. Journal Flows (with ai_description and attachments)
    journal_flows_data AS (
        SELECT
            j.flow_id,
            j.created_at_utc as created_at,
            j.system_time_utc as system_time,
            j.balance_before,
            j.flow_amount,
            j.balance_after,
            j.journal_id,
            je.description as journal_description,
            je.ai_description as journal_ai_description,
            je.journal_type,
            j.account_id,
            a.account_name,
            j.created_by,
            CONCAT(u.first_name, ' ', u.last_name) as created_by_name,
            u.profile_image as created_by_profile_image,
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
            ) as counter_account,
            COALESCE(
                (
                    SELECT json_agg(
                        json_build_object(
                            'attachment_id', ja.attachment_id::text,
                            'file_url', ja.file_url,
                            'file_name', ja.file_name,
                            'file_type', ja.file_type
                        ) ORDER BY ja.uploaded_at_utc
                    )
                    FROM journal_attachments ja
                    WHERE ja.journal_id = j.journal_id
                ),
                '[]'::json
            ) as attachments
        FROM journal_amount_stock_flow j
        LEFT JOIN journal_entries je ON j.journal_id = je.journal_id
        LEFT JOIN accounts a ON j.account_id = a.account_id
        LEFT JOIN users u ON j.created_by = u.user_id
        WHERE j.company_id = p_company_id
        AND (p_store_id IS NULL OR j.store_id = p_store_id OR j.store_id IS NULL)
        AND j.cash_location_id = p_cash_location_id
        ORDER BY j.system_time_utc DESC
        OFFSET p_offset
        LIMIT p_limit
    ),

    -- 3. Actual Flows - UNION of Cash, Bank, Vault
    actual_flows_data AS (
        -- ========================================
        -- CASH: Use current_stock_snapshot for accurate previous quantity
        -- FIX: Changed from cashier_amount_lines to current_stock_snapshot
        --      This ensures 0-quantity denominations are properly tracked
        -- ========================================
        SELECT
            cae.entry_id as flow_id,
            cae.created_at_utc as created_at,
            cae.created_at_utc as system_time,
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

            -- Cash: Build denomination details from current_stock_snapshot
            COALESCE(
                (
                    SELECT json_agg(
                        json_build_object(
                            'denomination_id', (denom->>'denomination_id')::UUID,
                            'denomination_value', (denom->>'value')::NUMERIC,
                            'denomination_type', cd.type,
                            'current_quantity', (denom->>'quantity')::INTEGER,
                            'previous_quantity', COALESCE(prev.prev_quantity, 0),
                            'quantity_change', (denom->>'quantity')::INTEGER - COALESCE(prev.prev_quantity, 0),
                            'subtotal', (denom->>'quantity')::INTEGER * (denom->>'value')::NUMERIC,
                            'currency_id', (denom->>'currency_id')::UUID,
                            'currency_code', ct2.currency_code,
                            'currency_name', ct2.currency_name,
                            'currency_symbol', ct2.symbol
                        )
                        ORDER BY (denom->>'value')::NUMERIC DESC
                    )
                    FROM jsonb_array_elements(
                        COALESCE(cae.current_stock_snapshot->'denominations', '[]'::jsonb)
                    ) AS denom
                    LEFT JOIN currency_denominations cd ON (denom->>'denomination_id')::UUID = cd.denomination_id
                    LEFT JOIN currency_types ct2 ON (denom->>'currency_id')::UUID = ct2.currency_id
                    LEFT JOIN LATERAL (
                        -- Get previous snapshot quantity from the immediately preceding entry
                        SELECT
                            COALESCE(
                                (prev_denom->>'quantity')::INTEGER,
                                0
                            ) as prev_quantity
                        FROM cash_amount_entries prev_cae
                        CROSS JOIN LATERAL jsonb_array_elements(
                            COALESCE(prev_cae.current_stock_snapshot->'denominations', '[]'::jsonb)
                        ) AS prev_denom
                        WHERE prev_cae.location_id = cae.location_id
                          AND prev_cae.created_at_utc < cae.created_at_utc
                          AND prev_cae.company_id = p_company_id
                          AND prev_cae.entry_type = 'cash'
                          AND (prev_denom->>'denomination_id')::UUID = (denom->>'denomination_id')::UUID
                        ORDER BY prev_cae.created_at_utc DESC
                        LIMIT 1
                    ) prev ON true
                ),
                '[]'::json
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
        -- BANK: bank_amount (Stock Method, NO denomination, Multi-Currency)
        -- ========================================
        SELECT
            cae.entry_id as flow_id,
            cae.created_at_utc as created_at,
            cae.created_at_utc as system_time,
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
        -- VAULT: Use current_stock_snapshot for correct quantity
        -- ========================================
        SELECT
            cae.entry_id as flow_id,
            cae.created_at_utc as created_at,
            cae.created_at_utc as system_time,
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

            -- Vault: Build denomination details from current_stock_snapshot
            COALESCE(
                (
                    SELECT json_agg(
                        json_build_object(
                            'denomination_id', (denom->>'denomination_id')::UUID,
                            'denomination_value', cd.value,
                            'denomination_type', cd.type,
                            'current_quantity', (denom->>'quantity')::INTEGER,
                            'previous_quantity', COALESCE(prev.prev_quantity, 0),
                            'quantity_change', (denom->>'quantity')::INTEGER - COALESCE(prev.prev_quantity, 0),
                            'subtotal', (denom->>'quantity')::INTEGER * cd.value,
                            'currency_id', (denom->>'currency_id')::UUID,
                            'currency_code', ct2.currency_code,
                            'currency_name', ct2.currency_name,
                            'currency_symbol', ct2.symbol
                        )
                        ORDER BY cd.value DESC
                    )
                    FROM jsonb_array_elements(
                        COALESCE(cae.current_stock_snapshot->'denominations', '[]'::jsonb)
                    ) AS denom
                    LEFT JOIN currency_denominations cd ON (denom->>'denomination_id')::UUID = cd.denomination_id
                    LEFT JOIN currency_types ct2 ON (denom->>'currency_id')::UUID = ct2.currency_id
                    LEFT JOIN LATERAL (
                        -- Get previous snapshot quantity
                        SELECT
                            COALESCE(
                                (prev_denom->>'quantity')::INTEGER,
                                0
                            ) as prev_quantity
                        FROM cash_amount_entries prev_cae
                        CROSS JOIN LATERAL jsonb_array_elements(
                            COALESCE(prev_cae.current_stock_snapshot->'denominations', '[]'::jsonb)
                        ) AS prev_denom
                        WHERE prev_cae.location_id = cae.location_id
                          AND prev_cae.created_at_utc < cae.created_at_utc
                          AND prev_cae.company_id = p_company_id
                          AND prev_cae.entry_type = 'vault'
                          AND (prev_denom->>'denomination_id')::UUID = (denom->>'denomination_id')::UUID
                        ORDER BY prev_cae.created_at_utc DESC
                        LIMIT 1
                    ) prev ON true
                ),
                '[]'::json
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
$function$;

-- Add comment explaining the fix
COMMENT ON FUNCTION public.get_location_stock_flow_v2_utc IS
'Returns stock flow data for a cash location.
2025-12-21: Fixed CASH denomination previous_quantity calculation.
Changed from cashier_amount_lines (missing 0-qty rows) to current_stock_snapshot (complete snapshot).
This ensures accurate change calculation even when denomination quantity changes from/to 0.';
