-- Update get_expense_accounts to include usage_count and sort by most used
-- This shows frequently used expense accounts at the top for quick selection

CREATE OR REPLACE FUNCTION get_expense_accounts(
    p_company_id UUID,
    p_search_query TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 50
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(account_row ORDER BY usage_count DESC, account_code ASC) INTO v_result
    FROM (
        SELECT
            jsonb_build_object(
                'account_id', a.account_id,
                'account_name', a.account_name,
                'account_type', a.account_type,
                'account_code', a.account_code,
                'expense_nature', a.expense_nature,
                'category_tag', a.category_tag,
                'description', a.description,
                'is_default', a.is_default,
                'usage_count', COALESCE(usage.cnt, 0)
            ) as account_row,
            COALESCE(usage.cnt, 0) as usage_count,
            a.account_code
        FROM accounts a
        -- Left join to count usage from journal_lines for this company
        LEFT JOIN (
            SELECT
                jl.account_id,
                COUNT(*) as cnt
            FROM journal_lines jl
            INNER JOIN journal_entries je ON je.journal_id = jl.journal_id
            WHERE je.company_id = p_company_id
              AND jl.is_deleted = FALSE
            GROUP BY jl.account_id
        ) usage ON usage.account_id = a.account_id
        WHERE
            -- Company filter: either company-specific or default accounts
            (a.company_id = p_company_id OR a.is_default = TRUE)
            -- Expense accounts only
            AND a.account_type = 'expense'
            -- Search filter (optional)
            AND (
                p_search_query IS NULL
                OR a.account_name ILIKE '%' || p_search_query || '%'
                OR a.account_code ILIKE '%' || p_search_query || '%'
            )
        LIMIT p_limit
    ) t;

    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

COMMENT ON FUNCTION get_expense_accounts(UUID, TEXT, INTEGER) IS
'Returns expense accounts with usage_count, sorted by most used first.
Used for expense entry account selection in cash_transaction feature.';
