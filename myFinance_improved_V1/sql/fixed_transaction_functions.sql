-- Drop existing functions first
DROP FUNCTION IF EXISTS get_transaction_history CASCADE;
DROP FUNCTION IF EXISTS get_transaction_filter_options CASCADE;

-- =====================================================
-- CREATE TRANSACTION HISTORY FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION get_transaction_history(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL,  -- NULL means show all stores
    p_date_from DATE DEFAULT NULL,
    p_date_to DATE DEFAULT NULL,
    p_account_id UUID DEFAULT NULL,
    p_account_ids TEXT DEFAULT NULL,
    p_cash_location_id UUID DEFAULT NULL,
    p_counterparty_id UUID DEFAULT NULL,
    p_journal_type TEXT DEFAULT NULL,
    p_created_by UUID DEFAULT NULL,
    p_limit INT DEFAULT 50,
    p_offset INT DEFAULT 0
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
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
            je.entry_date,
            je.created_at,
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
            AND (p_date_from IS NULL OR je.entry_date >= p_date_from)
            AND (p_date_to IS NULL OR je.entry_date <= p_date_to)
            AND (p_journal_type IS NULL OR je.journal_type = p_journal_type)
            AND (p_counterparty_id IS NULL OR je.counterparty_id = p_counterparty_id)
            AND (p_created_by IS NULL OR je.created_by = p_created_by)
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
            je.journal_id, je.entry_date, je.created_at, je.description,
            je.journal_type, je.is_draft, je.store_id, s.store_name, s.store_code,
            je.created_by, u.first_name, u.last_name, u.email, ct.currency_code, ct.symbol
        ORDER BY je.created_at DESC
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
            'attachments', '[]'::json  -- Always return empty array for attachments
        )
    ) INTO v_result
    FROM entries_with_lines;

    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

-- =====================================================
-- CREATE FILTER OPTIONS FUNCTION (FIXED VERSION)
-- =====================================================
CREATE OR REPLACE FUNCTION get_transaction_filter_options(
    p_company_id UUID,
    p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_result JSON;
BEGIN
    WITH store_counts AS (
        SELECT
            s.store_id,
            s.store_name,
            s.store_code,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM stores s
        LEFT JOIN journal_entries je ON s.store_id = je.store_id
            AND je.company_id = p_company_id
            AND je.is_deleted = false
        WHERE s.company_id = p_company_id
            AND (s.is_deleted = false OR s.is_deleted IS NULL)
        GROUP BY s.store_id, s.store_name, s.store_code
    ),
    account_counts AS (
        SELECT
            a.account_id,
            a.account_name,
            a.account_type,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM accounts a
        LEFT JOIN journal_lines jl ON a.account_id = jl.account_id AND jl.is_deleted = false
        LEFT JOIN journal_entries je ON jl.journal_id = je.journal_id
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE EXISTS (
            SELECT 1 FROM journal_entries je2
            JOIN journal_lines jl2 ON je2.journal_id = jl2.journal_id
            WHERE je2.company_id = p_company_id
            AND jl2.account_id = a.account_id
            AND je2.is_deleted = false
            AND jl2.is_deleted = false
        )
        GROUP BY a.account_id, a.account_name, a.account_type
        HAVING COUNT(DISTINCT je.journal_id) > 0
    ),
    cash_location_counts AS (
        SELECT
            cl.cash_location_id,
            cl.location_name,
            cl.location_type,
            cl.store_id,
            COALESCE(cl.is_company_wide, false) as is_company_wide,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM cash_locations cl
        LEFT JOIN journal_lines jl ON cl.cash_location_id = jl.cash_location_id AND jl.is_deleted = false
        LEFT JOIN journal_entries je ON jl.journal_id = je.journal_id
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE cl.company_id = p_company_id
            AND (p_store_id IS NULL OR cl.store_id = p_store_id)
            AND cl.deleted_at IS NULL
        GROUP BY cl.cash_location_id, cl.location_name, cl.location_type, cl.store_id, cl.is_company_wide
        HAVING COUNT(DISTINCT je.journal_id) > 0
    ),
    counterparty_counts AS (
        SELECT
            cp.counterparty_id,
            cp.name,
            cp.type,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM counterparties cp
        LEFT JOIN journal_entries je ON cp.counterparty_id = je.counterparty_id
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE cp.company_id = p_company_id
            AND cp.is_deleted = false
        GROUP BY cp.counterparty_id, cp.name, cp.type
        HAVING COUNT(DISTINCT je.journal_id) > 0
    ),
    journal_type_counts AS (
        SELECT
            journal_type,
            COUNT(*) as transaction_count
        FROM journal_entries
        WHERE company_id = p_company_id
            AND (p_store_id IS NULL OR store_id = p_store_id)
            AND is_deleted = false
            AND journal_type IS NOT NULL
        GROUP BY journal_type
    ),
    user_counts AS (
        SELECT
            u.user_id,
            u.first_name,
            u.last_name,
            u.email,
            COUNT(DISTINCT je.journal_id) as transaction_count
        FROM users u
        INNER JOIN journal_entries je ON u.user_id = je.created_by
            AND je.company_id = p_company_id
            AND (p_store_id IS NULL OR je.store_id = p_store_id)
            AND je.is_deleted = false
        WHERE u.is_deleted = false
        GROUP BY u.user_id, u.first_name, u.last_name, u.email
        HAVING COUNT(DISTINCT je.journal_id) > 0
    )
    SELECT json_build_object(
        'stores', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', sc.store_id::text,
                    'name', sc.store_name,
                    'code', sc.store_code,
                    'transaction_count', sc.transaction_count
                ) ORDER BY sc.store_name
            ), '[]'::json)
            FROM store_counts sc
        ),
        'accounts', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', ac.account_id::text,
                    'name', ac.account_name,
                    'type', ac.account_type,
                    'transaction_count', ac.transaction_count
                ) ORDER BY ac.account_name
            ), '[]'::json)
            FROM account_counts ac
        ),
        'cash_locations', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', cc.cash_location_id::text,
                    'name', cc.location_name,
                    'type', cc.location_type,
                    'store_id', CASE WHEN cc.store_id IS NOT NULL THEN cc.store_id::text ELSE NULL END,
                    'is_company_wide', cc.is_company_wide,
                    'transaction_count', cc.transaction_count
                ) ORDER BY cc.location_name
            ), '[]'::json)
            FROM cash_location_counts cc
        ),
        'counterparties', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', cpc.counterparty_id::text,
                    'name', cpc.name,
                    'type', cpc.type,
                    'transaction_count', cpc.transaction_count
                ) ORDER BY cpc.name
            ), '[]'::json)
            FROM counterparty_counts cpc
        ),
        'journal_types', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', jtc.journal_type,
                    'name', INITCAP(REPLACE(jtc.journal_type, '_', ' ')),
                    'transaction_count', jtc.transaction_count
                ) ORDER BY jtc.journal_type
            ), '[]'::json)
            FROM journal_type_counts jtc
        ),
        'users', (
            SELECT COALESCE(json_agg(
                json_build_object(
                    'id', uc.user_id::text,
                    'name', COALESCE(
                        NULLIF(TRIM(uc.first_name || ' ' || uc.last_name), ''),
                        uc.email
                    ),
                    'email', uc.email,
                    'transaction_count', uc.transaction_count
                ) ORDER BY uc.first_name, uc.last_name
            ), '[]'::json)
            FROM user_counts uc
        )
    ) INTO v_result;

    RETURN v_result;
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_transaction_history TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_transaction_filter_options TO anon, authenticated;

-- Verify function creation
SELECT 
    p.proname as function_name,
    p.pronargs as num_args,
    pg_get_function_result(p.oid) as return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
AND p.proname IN ('get_transaction_history', 'get_transaction_filter_options')
ORDER BY p.proname;