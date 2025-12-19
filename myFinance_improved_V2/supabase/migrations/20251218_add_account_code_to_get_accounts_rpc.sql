-- Migration: Add account_code to get_accounts RPC
-- Purpose: Include account_code in RPC response for expense account identification in templates
-- Date: 2025-12-18

-- Update get_accounts RPC to include account_code for expense account identification
CREATE OR REPLACE FUNCTION get_accounts(p_account_type text DEFAULT NULL)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSON;
BEGIN
    WITH account_data AS (
        SELECT json_build_object(
            'id', account_id,
            'name', account_name,
            'type', account_type,
            'categoryTag', category_tag,
            'expenseNature', expense_nature,
            'accountCode', account_code,
            'description', description,
            'transactionCount', 0,
            'additionalData', json_build_object(
                'account_id', account_id,
                'account_name', account_name,
                'account_type', account_type,
                'account_code', account_code,
                'expense_nature', expense_nature,
                'category_tag', category_tag,
                'description', description,
                'debt_tag', debt_tag,
                'statement_category', statement_category,
                'statement_detail_category', statement_detail_category,
                'created_at', created_at,
                'updated_at', updated_at
            )
        ) as account_json
        FROM accounts
        WHERE (p_account_type IS NULL OR account_type = p_account_type)
        ORDER BY account_name
    )
    SELECT COALESCE(array_to_json(array_agg(account_json)), '[]'::json)
    INTO result
    FROM account_data;

    RETURN result;
END;
$$;
