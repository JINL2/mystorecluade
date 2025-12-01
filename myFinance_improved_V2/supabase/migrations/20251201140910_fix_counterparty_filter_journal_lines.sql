-- Fix counterparty filter to include journal_line level filtering
-- This allows filtering transactions where counterparty appears in journal lines,
-- not just at the journal entry level
--
-- Problem: When filtering by counterparty (e.g., "JC"), the RPC only checked
-- journal_entries.counterparty_id, missing transactions where the counterparty
-- appears in journal_lines (e.g., Note Receivable from JC, Notes Payable to JC)
--
-- Solution: Check both entry-level AND line-level counterparty_id

CREATE OR REPLACE FUNCTION public.get_transaction_history_utc(
    p_company_id uuid,
    p_store_id uuid DEFAULT NULL::uuid,
    p_date_from date DEFAULT NULL::date,
    p_date_to date DEFAULT NULL::date,
    p_account_id uuid DEFAULT NULL::uuid,
    p_account_ids text DEFAULT NULL::text,
    p_cash_location_id uuid DEFAULT NULL::uuid,
    p_counterparty_id uuid DEFAULT NULL::uuid,
    p_journal_type text DEFAULT NULL::text,
    p_created_by uuid DEFAULT NULL::uuid,
    p_limit integer DEFAULT 50,
    p_offset integer DEFAULT 0
)
RETURNS json
LANGUAGE plpgsql
AS $function$
DECLARE
    v_result JSON;
    v_account_ids_array UUID[];
BEGIN
    -- Parse comma-separated account IDs
    IF p_account_ids IS NOT NULL AND LENGTH(TRIM(p_account_ids)) > 0 THEN
        SELECT array_agg(uuid_val)
        INTO v_account_ids_array
        FROM (
            SELECT TRIM(id_str)::UUID as uuid_val
            FROM unnest(string_to_array(p_account_ids, ',')) as id_str
            WHERE TRIM(id_str) != ''
        ) parsed_ids;
    END IF;

    WITH filtered_entries AS (
        SELECT
            je.journal_id,
            je.journal_id::text as journal_number,
            je.entry_date_utc as entry_date,
            je.created_at_utc as created_at,
            je.description,
            je.journal_type,
            je.is_draft,
            je.store_id,
            s.store_name,
            s.store_code,
            je.created_by,
            COALESCE(u.first_name || ' ' || u.last_name, u.email, 'System') as created_by_name,
            ct.currency_code,
            ct.symbol as currency_symbol,
            COALESCE(SUM(jl.debit), 0) as total_debit,
            COALESCE(SUM(jl.credit), 0) as total_credit,
            GREATEST(COALESCE(SUM(jl.debit), 0), COALESCE(SUM(jl.credit), 0)) as total_amount
        FROM journal_entries je
        LEFT JOIN stores s ON je.store_id = s.store_id
        LEFT JOIN journal_lines jl ON je.journal_id = jl.journal_id AND jl.is_deleted = false
        LEFT JOIN currency_types ct ON je.currency_id = ct.currency_id
        LEFT JOIN users u ON je.created_by = u.user_id
        WHERE
            je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND (p_date_from IS NULL OR je.entry_date_utc >= p_date_from)
            AND (p_date_to IS NULL OR je.entry_date_utc <= p_date_to)
            AND (p_journal_type IS NULL OR je.journal_type = p_journal_type)
            AND (p_created_by IS NULL OR je.created_by = p_created_by)
            -- ✅ FIXED: Check counterparty in both entry level AND line level
            AND (
                p_counterparty_id IS NULL 
                OR je.counterparty_id = p_counterparty_id
                OR EXISTS (
                    SELECT 1 FROM journal_lines jl_cp
                    WHERE jl_cp.journal_id = je.journal_id
                    AND jl_cp.is_deleted = false
                    AND jl_cp.counterparty_id = p_counterparty_id
                )
            )
            AND (
                (p_account_id IS NULL AND v_account_ids_array IS NULL) OR
                EXISTS (
                    SELECT 1 FROM journal_lines jl2
                    WHERE jl2.journal_id = je.journal_id
                    AND jl2.is_deleted = false
                    AND (
                        (p_account_id IS NOT NULL AND jl2.account_id = p_account_id)
                        OR (v_account_ids_array IS NOT NULL AND jl2.account_id = ANY(v_account_ids_array))
                    )
                )
            )
            AND (
                p_cash_location_id IS NULL OR
                EXISTS (
                    SELECT 1 FROM journal_lines jl3
                    WHERE jl3.journal_id = je.journal_id
                    AND jl3.is_deleted = false
                    AND jl3.cash_location_id = p_cash_location_id
                )
            )
            AND je.is_deleted = false
        GROUP BY
            je.journal_id, je.entry_date_utc, je.created_at_utc, je.description,
            je.journal_type, je.is_draft, je.store_id, s.store_name, s.store_code,
            je.created_by, u.first_name, u.last_name, u.email, ct.currency_code, ct.symbol
        ORDER BY je.created_at_utc DESC NULLS LAST
        LIMIT p_limit
        OFFSET p_offset
    ),
    entries_with_lines AS (
        SELECT
            fe.*,
            COALESCE(
                json_agg(
                    json_build_object(
                        'line_id', jl.line_id::text,
                        'account_id', jl.account_id::text,
                        'account_name', a.account_name,
                        'account_type', a.account_type,
                        'debit', jl.debit,
                        'credit', jl.credit,
                        'is_debit', jl.debit > 0,
                        'description', jl.description,
                        'counterparty', CASE
                            WHEN cp.counterparty_id IS NOT NULL THEN
                                json_build_object(
                                    'id', cp.counterparty_id::text,
                                    'name', cp.name,
                                    'type', cp.type
                                )
                            ELSE NULL
                        END,
                        'cash_location', CASE
                            WHEN cl.cash_location_id IS NOT NULL THEN
                                json_build_object(
                                    'id', cl.cash_location_id::text,
                                    'name', cl.location_name,
                                    'type', cl.location_type
                                )
                            ELSE NULL
                        END,
                        'display_location', COALESCE(cl.location_name, ''),
                        'display_counterparty', COALESCE(cp.name, '')
                    ) ORDER BY jl.line_id
                ) FILTER (WHERE jl.line_id IS NOT NULL),
                '[]'::json
            ) as lines
        FROM filtered_entries fe
        LEFT JOIN journal_lines jl ON fe.journal_id = jl.journal_id AND jl.is_deleted = false
        LEFT JOIN accounts a ON jl.account_id = a.account_id
        LEFT JOIN counterparties cp ON jl.counterparty_id = cp.counterparty_id
        LEFT JOIN cash_locations cl ON jl.cash_location_id = cl.cash_location_id
        GROUP BY
            fe.journal_id, fe.journal_number, fe.entry_date, fe.created_at,
            fe.description, fe.journal_type, fe.is_draft, fe.store_id,
            fe.store_name, fe.store_code, fe.created_by,
            fe.created_by_name, fe.currency_code, fe.currency_symbol,
            fe.total_debit, fe.total_credit, fe.total_amount
    )
    SELECT json_agg(
        json_build_object(
            'journal_id', journal_id::text,
            'journal_number', journal_number,
            'entry_date', entry_date,
            'created_at', created_at,
            'description', description,
            'journal_type', journal_type,
            'is_draft', is_draft,
            'store_id', store_id::text,
            'store_name', store_name,
            'store_code', store_code,
            'created_by', created_by::text,
            'created_by_name', created_by_name,
            'currency_code', currency_code,
            'currency_symbol', currency_symbol,
            'total_debit', total_debit,
            'total_credit', total_credit,
            'total_amount', total_amount,
            'lines', lines,
            'attachments', '[]'::json
        ) ORDER BY created_at DESC NULLS LAST
    ) INTO v_result
    FROM entries_with_lines;

    RETURN COALESCE(v_result, '[]'::json);
END;
$function$;
