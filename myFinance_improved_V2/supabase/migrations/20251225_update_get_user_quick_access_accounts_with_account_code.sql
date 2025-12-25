-- Update get_user_quick_access_accounts to include account_code from accounts table
-- This allows Flutter to filter accounts by account_code (e.g., 5000+ for expense accounts)

CREATE OR REPLACE FUNCTION get_user_quick_access_accounts(
    p_user_id UUID,
    p_company_id UUID,
    p_limit INTEGER DEFAULT 10
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_top_accounts JSON;
    v_enriched_accounts JSON;
BEGIN
    -- Get user's top accounts for the specific company
    SELECT top_accounts INTO v_top_accounts
    FROM top_accounts_by_user
    WHERE user_id = p_user_id
      AND company_id = p_company_id;

    -- If user has accounts, enrich with account_code from accounts table
    IF v_top_accounts IS NOT NULL THEN
        SELECT json_agg(enriched_account) INTO v_enriched_accounts
        FROM (
            SELECT
                jsonb_build_object(
                    'account_id', (account_data->>'account_id')::UUID,
                    'account_name', account_data->>'account_name',
                    'account_type', COALESCE(a.account_type, account_data->>'account_type'),
                    'account_code', a.account_code,
                    'usage_count', (account_data->>'usage_count')::INTEGER,
                    'usage_score', (account_data->>'usage_score')::NUMERIC,
                    'last_used', account_data->>'last_used',
                    'exists_in_system', (account_data->>'exists_in_system')::BOOLEAN
                ) as enriched_account
            FROM json_array_elements(v_top_accounts) AS account_data
            LEFT JOIN accounts a ON a.account_id = (account_data->>'account_id')::UUID
            LIMIT p_limit
        ) t;

        v_top_accounts := v_enriched_accounts;
    END IF;

    RETURN COALESCE(v_top_accounts, '[]'::json);
END;
$$;

COMMENT ON FUNCTION get_user_quick_access_accounts(UUID, UUID, INTEGER) IS
'Returns user quick access accounts enriched with account_code for filtering. Used in cash_control expense entry.';
