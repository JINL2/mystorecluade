-- Daily P&L Trend RPC for Charts
-- Returns daily revenue, cogs, opex, and net_income

CREATE OR REPLACE FUNCTION get_pnl_daily(
    p_company_id UUID,
    p_start_date DATE,
    p_end_date DATE,
    p_store_id UUID DEFAULT NULL
)
RETURNS TABLE (
    date DATE,
    revenue NUMERIC,
    cogs NUMERIC,
    opex NUMERIC,
    net_income NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT
        je.entry_date as date,
        COALESCE(SUM(CASE
            WHEN a.account_code::integer >= 4000 AND a.account_code::integer < 5000
            THEN jl.credit - jl.debit
            ELSE 0
        END), 0) as revenue,
        COALESCE(SUM(CASE
            WHEN a.account_code::integer >= 5000 AND a.account_code::integer < 6000
            THEN jl.debit - jl.credit
            ELSE 0
        END), 0) as cogs,
        COALESCE(SUM(CASE
            WHEN a.account_code::integer >= 6000 AND a.account_code::integer < 8000
            THEN jl.debit - jl.credit
            ELSE 0
        END), 0) as opex,
        -- Net Income = Revenue - COGS - OpEx
        COALESCE(SUM(CASE
            WHEN a.account_code::integer >= 4000 AND a.account_code::integer < 5000
            THEN jl.credit - jl.debit
            ELSE 0
        END), 0) -
        COALESCE(SUM(CASE
            WHEN a.account_code::integer >= 5000 AND a.account_code::integer < 6000
            THEN jl.debit - jl.credit
            ELSE 0
        END), 0) -
        COALESCE(SUM(CASE
            WHEN a.account_code::integer >= 6000 AND a.account_code::integer < 8000
            THEN jl.debit - jl.credit
            ELSE 0
        END), 0) as net_income
    FROM journal_entries je
    JOIN journal_lines jl ON je.journal_id = jl.journal_id
    JOIN accounts a ON jl.account_id = a.account_id
    WHERE je.company_id = p_company_id
      AND je.entry_date >= p_start_date
      AND je.entry_date <= p_end_date
      AND je.is_deleted = false
      AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
      AND (p_store_id IS NULL OR jl.store_id = p_store_id)
    GROUP BY je.entry_date
    ORDER BY je.entry_date;
END;
$$;

-- Grant access to authenticated users
GRANT EXECUTE ON FUNCTION get_pnl_daily(UUID, DATE, DATE, UUID) TO authenticated;
