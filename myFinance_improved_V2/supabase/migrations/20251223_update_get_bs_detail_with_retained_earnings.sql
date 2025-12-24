-- Update get_bs_detail to include Retained Earnings (calculated from P&L accounts)
-- This fixes the issue where Equity shows 0 because Retained Earnings wasn't calculated
-- Fixed: account_code is VARCHAR(20), account_name is TEXT in accounts table

-- Drop existing functions first (return type changed)
DROP FUNCTION IF EXISTS get_bs_detail(UUID, DATE, UUID);
DROP FUNCTION IF EXISTS get_bs(UUID, DATE, UUID, DATE);

CREATE OR REPLACE FUNCTION get_bs_detail(
    p_company_id UUID,
    p_as_of_date DATE,
    p_store_id UUID DEFAULT NULL
)
RETURNS TABLE (
    section TEXT,
    section_order INTEGER,
    account_code VARCHAR(20),
    account_name TEXT,
    balance NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_retained_earnings NUMERIC;
BEGIN
    -- Calculate Retained Earnings from P&L accounts (4000+)
    -- Simple formula: SUM(credit - debit) for all P&L accounts
    -- Revenue (4000-4999): credit balance → positive contribution
    -- Expenses (5000+): debit balance → negative contribution
    -- Result = Net Income (positive = profit, negative = loss)
    SELECT COALESCE(SUM(jl.credit - jl.debit), 0)
    INTO v_retained_earnings
    FROM journal_entries je
    JOIN journal_lines jl ON je.journal_id = jl.journal_id
    JOIN accounts a ON jl.account_id = a.account_id
    WHERE je.company_id = p_company_id
      AND je.entry_date <= p_as_of_date
      AND (je.is_deleted = false OR je.is_deleted IS NULL)
      AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
      AND a.account_code >= '4000'
      AND (p_store_id IS NULL OR jl.store_id = p_store_id);

    -- Return B/S accounts (1000-3999) plus Retained Earnings
    RETURN QUERY
    -- Regular B/S accounts
    SELECT
        CASE
            WHEN a.account_code >= '1000' AND a.account_code < '1500' THEN 'Current Assets'
            WHEN a.account_code >= '1500' AND a.account_code < '2000' THEN 'Non-Current Assets'
            WHEN a.account_code >= '2000' AND a.account_code < '2500' THEN 'Current Liabilities'
            WHEN a.account_code >= '2500' AND a.account_code < '3000' THEN 'Non-Current Liabilities'
            WHEN a.account_code >= '3000' AND a.account_code < '4000' THEN 'Equity'
        END::TEXT as section,
        CASE
            WHEN a.account_code >= '1000' AND a.account_code < '1500' THEN 1
            WHEN a.account_code >= '1500' AND a.account_code < '2000' THEN 2
            WHEN a.account_code >= '2000' AND a.account_code < '2500' THEN 3
            WHEN a.account_code >= '2500' AND a.account_code < '3000' THEN 4
            WHEN a.account_code >= '3000' AND a.account_code < '4000' THEN 5
        END as section_order,
        a.account_code,
        a.account_name,
        SUM(
            CASE
                WHEN a.account_code >= '1000' AND a.account_code < '2000' THEN jl.debit - jl.credit
                ELSE jl.credit - jl.debit
            END
        ) as balance
    FROM journal_entries je
    JOIN journal_lines jl ON je.journal_id = jl.journal_id
    JOIN accounts a ON jl.account_id = a.account_id
    WHERE je.company_id = p_company_id
      AND je.entry_date <= p_as_of_date
      AND (je.is_deleted = false OR je.is_deleted IS NULL)
      AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
      AND a.account_code >= '1000' AND a.account_code < '4000'
      AND (p_store_id IS NULL OR jl.store_id = p_store_id)
    GROUP BY a.account_code, a.account_name
    HAVING SUM(
        CASE
            WHEN a.account_code >= '1000' AND a.account_code < '2000' THEN jl.debit - jl.credit
            ELSE jl.credit - jl.debit
        END
    ) != 0

    UNION ALL

    -- Add Retained Earnings row (only if non-zero)
    SELECT
        'Equity'::TEXT as section,
        5 as section_order,
        '3900'::VARCHAR(20) as account_code,
        'Retained Earnings'::TEXT as account_name,
        v_retained_earnings as balance
    WHERE v_retained_earnings != 0

    ORDER BY section_order, account_code;
END;
$$;

-- Also update get_bs to include Retained Earnings in total_equity
CREATE OR REPLACE FUNCTION get_bs(
    p_company_id UUID,
    p_as_of_date DATE,
    p_store_id UUID DEFAULT NULL,
    p_compare_date DATE DEFAULT NULL
)
RETURNS TABLE (
    total_assets NUMERIC,
    total_liabilities NUMERIC,
    total_equity NUMERIC,
    current_assets NUMERIC,
    non_current_assets NUMERIC,
    current_liabilities NUMERIC,
    non_current_liabilities NUMERIC,
    prev_total_assets NUMERIC,
    prev_total_liabilities NUMERIC,
    prev_total_equity NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_current_assets NUMERIC := 0;
    v_non_current_assets NUMERIC := 0;
    v_current_liabilities NUMERIC := 0;
    v_non_current_liabilities NUMERIC := 0;
    v_equity NUMERIC := 0;
    v_retained_earnings NUMERIC := 0;
    v_prev_current_assets NUMERIC := 0;
    v_prev_non_current_assets NUMERIC := 0;
    v_prev_current_liabilities NUMERIC := 0;
    v_prev_non_current_liabilities NUMERIC := 0;
    v_prev_equity NUMERIC := 0;
    v_prev_retained_earnings NUMERIC := 0;
BEGIN
    -- Calculate current period balances for B/S accounts (1000-3999)
    SELECT
        COALESCE(SUM(CASE WHEN a.account_code >= '1000' AND a.account_code < '1500' THEN jl.debit - jl.credit ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN a.account_code >= '1500' AND a.account_code < '2000' THEN jl.debit - jl.credit ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN a.account_code >= '2000' AND a.account_code < '2500' THEN jl.credit - jl.debit ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN a.account_code >= '2500' AND a.account_code < '3000' THEN jl.credit - jl.debit ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN a.account_code >= '3000' AND a.account_code < '4000' THEN jl.credit - jl.debit ELSE 0 END), 0)
    INTO v_current_assets, v_non_current_assets, v_current_liabilities, v_non_current_liabilities, v_equity
    FROM journal_entries je
    JOIN journal_lines jl ON je.journal_id = jl.journal_id
    JOIN accounts a ON jl.account_id = a.account_id
    WHERE je.company_id = p_company_id
      AND je.entry_date <= p_as_of_date
      AND (je.is_deleted = false OR je.is_deleted IS NULL)
      AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
      AND (p_store_id IS NULL OR jl.store_id = p_store_id);

    -- Calculate Retained Earnings (from P&L accounts 4000+)
    -- Simple: SUM(credit - debit) = Net Income
    SELECT COALESCE(SUM(jl.credit - jl.debit), 0)
    INTO v_retained_earnings
    FROM journal_entries je
    JOIN journal_lines jl ON je.journal_id = jl.journal_id
    JOIN accounts a ON jl.account_id = a.account_id
    WHERE je.company_id = p_company_id
      AND je.entry_date <= p_as_of_date
      AND (je.is_deleted = false OR je.is_deleted IS NULL)
      AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
      AND a.account_code >= '4000'
      AND (p_store_id IS NULL OR jl.store_id = p_store_id);

    -- Add Retained Earnings to Equity
    v_equity := v_equity + v_retained_earnings;

    -- Calculate previous period if requested
    IF p_compare_date IS NOT NULL THEN
        SELECT
            COALESCE(SUM(CASE WHEN a.account_code >= '1000' AND a.account_code < '1500' THEN jl.debit - jl.credit ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN a.account_code >= '1500' AND a.account_code < '2000' THEN jl.debit - jl.credit ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN a.account_code >= '2000' AND a.account_code < '2500' THEN jl.credit - jl.debit ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN a.account_code >= '2500' AND a.account_code < '3000' THEN jl.credit - jl.debit ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN a.account_code >= '3000' AND a.account_code < '4000' THEN jl.credit - jl.debit ELSE 0 END), 0)
        INTO v_prev_current_assets, v_prev_non_current_assets, v_prev_current_liabilities, v_prev_non_current_liabilities, v_prev_equity
        FROM journal_entries je
        JOIN journal_lines jl ON je.journal_id = jl.journal_id
        JOIN accounts a ON jl.account_id = a.account_id
        WHERE je.company_id = p_company_id
          AND je.entry_date <= p_compare_date
          AND (je.is_deleted = false OR je.is_deleted IS NULL)
          AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
          AND (p_store_id IS NULL OR jl.store_id = p_store_id);

        -- Calculate previous Retained Earnings
        SELECT COALESCE(SUM(jl.credit - jl.debit), 0)
        INTO v_prev_retained_earnings
        FROM journal_entries je
        JOIN journal_lines jl ON je.journal_id = jl.journal_id
        JOIN accounts a ON jl.account_id = a.account_id
        WHERE je.company_id = p_company_id
          AND je.entry_date <= p_compare_date
          AND (je.is_deleted = false OR je.is_deleted IS NULL)
          AND (jl.is_deleted = false OR jl.is_deleted IS NULL)
          AND a.account_code >= '4000'
          AND (p_store_id IS NULL OR jl.store_id = p_store_id);

        v_prev_equity := v_prev_equity + v_prev_retained_earnings;
    END IF;

    RETURN QUERY SELECT
        v_current_assets + v_non_current_assets as total_assets,
        v_current_liabilities + v_non_current_liabilities as total_liabilities,
        v_equity as total_equity,
        v_current_assets,
        v_non_current_assets,
        v_current_liabilities,
        v_non_current_liabilities,
        v_prev_current_assets + v_prev_non_current_assets as prev_total_assets,
        v_prev_current_liabilities + v_prev_non_current_liabilities as prev_total_liabilities,
        v_prev_equity as prev_total_equity;
END;
$$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_bs_detail(UUID, DATE, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_bs(UUID, DATE, UUID, DATE) TO authenticated;
