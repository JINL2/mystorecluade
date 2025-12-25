-- Create RPC to get all accounts with optional filtering by account_type or account_code range
-- Used for searching/selecting accounts in cash_control feature

CREATE OR REPLACE FUNCTION get_accounts_by_type(
    p_company_id UUID,
    p_account_type TEXT DEFAULT NULL,        -- Optional: 'asset', 'liability', 'equity', 'income', 'expense'
    p_code_from TEXT DEFAULT NULL,           -- Optional: Filter accounts with code >= this value
    p_code_to TEXT DEFAULT NULL,             -- Optional: Filter accounts with code <= this value
    p_search_query TEXT DEFAULT NULL,        -- Optional: Search by account_name or account_code
    p_limit INTEGER DEFAULT 50
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(account_row) INTO v_result
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
                'is_default', a.is_default
            ) as account_row
        FROM accounts a
        WHERE
            -- Company filter: either company-specific or default accounts
            (a.company_id = p_company_id OR a.is_default = TRUE)
            -- Account type filter (optional)
            AND (p_account_type IS NULL OR a.account_type = p_account_type)
            -- Account code range filter (optional)
            AND (p_code_from IS NULL OR a.account_code >= p_code_from)
            AND (p_code_to IS NULL OR a.account_code <= p_code_to)
            -- Search filter (optional)
            AND (
                p_search_query IS NULL
                OR a.account_name ILIKE '%' || p_search_query || '%'
                OR a.account_code ILIKE '%' || p_search_query || '%'
            )
        ORDER BY a.account_code, a.account_name
        LIMIT p_limit
    ) t;

    RETURN COALESCE(v_result, '[]'::json);
END;
$$;

COMMENT ON FUNCTION get_accounts_by_type(UUID, TEXT, TEXT, TEXT, TEXT, INTEGER) IS
'Returns accounts filtered by type, code range, or search query. Used for account selection in cash_control.
Examples:
- Expense accounts: get_accounts_by_type(company_id, ''expense'')
- Expense by code: get_accounts_by_type(company_id, NULL, ''5000'', ''9999'')
- Search: get_accounts_by_type(company_id, NULL, NULL, NULL, ''salary'')';

-- Create a simplified version specifically for expense accounts
CREATE OR REPLACE FUNCTION get_expense_accounts(
    p_company_id UUID,
    p_search_query TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 50
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Use get_accounts_by_type with expense filter
    -- Expense accounts have code 5000-9999 or account_type = 'expense'
    RETURN get_accounts_by_type(
        p_company_id,
        'expense',      -- account_type
        NULL,           -- code_from (using account_type instead)
        NULL,           -- code_to
        p_search_query,
        p_limit
    );
END;
$$;

COMMENT ON FUNCTION get_expense_accounts(UUID, TEXT, INTEGER) IS
'Shortcut to get expense accounts only. Used for expense entry account selection.';
