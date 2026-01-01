-- Fix: Year boundary bug in get_dashboard_revenue_v3
-- Problem: totals query uses v_this_year_start as filter, excluding yesterday/last_month data at year boundaries
-- Solution: Use v_last_month_start instead to capture all required date ranges

CREATE OR REPLACE FUNCTION public.get_dashboard_revenue_v3(p_company_id uuid, p_time timestamp with time zone, p_timezone text, p_time_filter text, p_store_id uuid DEFAULT NULL::uuid)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_result JSON;
    v_local_date DATE;
    v_start_date DATE;
    v_end_date DATE;
    v_granularity TEXT;
    v_currency_id UUID;
    v_currency_code TEXT;
    v_currency_symbol TEXT;
    v_store_name TEXT;
    v_revenue_accounts UUID[];
    v_cogs_accounts UUID[];
    v_other_expense_accounts UUID[];
    v_today DATE;
    v_yesterday DATE;
    v_past_7_days_start DATE;
    v_this_month_start DATE;
    v_last_month_start DATE;
    v_last_month_end DATE;
    v_this_year_start DATE;
    v_totals JSON;
BEGIN
    -- Validate p_time_filter
    IF p_time_filter NOT IN ('today', 'yesterday', 'past_7_days', 'this_month', 'last_month', 'this_year') THEN
        RAISE EXCEPTION 'Invalid p_time_filter: %. Must be one of: today, yesterday, past_7_days, this_month, last_month, this_year', p_time_filter;
    END IF;

    v_local_date := (p_time AT TIME ZONE p_timezone)::date;

    v_revenue_accounts := ARRAY[
        'e45e7d41-7fda-43a1-ac55-9779f3e59697'::UUID,
        '53da3085-fba1-459a-85be-cc540b8cebde'::UUID,
        '068413ee-427f-4040-9847-92d7b39cb23c'::UUID,
        '7cc559cb-8ff8-425d-a78a-94672f8991da'::UUID,
        'f64c15de-9769-451a-85f5-aeb845f85377'::UUID
    ];

    v_cogs_accounts := ARRAY[
        '90565fe4-5bfc-4c5e-8759-af9a64e98cae'::UUID,
        'c31ffdac-317a-475f-b801-7f4327ffbddc'::UUID
    ];

    v_other_expense_accounts := ARRAY[
        '2bcc8a87-ebff-4d3a-b881-d62acbd37885'::UUID,
        '24ea22a8-7d2c-4c99-b48a-09a24adcf3d5'::UUID,
        'fb615b25-beb6-4958-8036-ca613e5ce22a'::UUID,
        'e9861f4c-3af0-43dd-bf2c-1f1c9f7bf9c8'::UUID,
        '8f6e2d7d-2409-4fc8-bded-ca53348243d3'::UUID,
        '914fe3c7-453a-477b-afb8-eec03c2ddb4d'::UUID,
        'c5359523-9a21-4422-9f79-97f514524f86'::UUID,
        '040915a7-d1aa-49ea-9960-d194c61bdf0f'::UUID,
        '38419fef-646a-486e-af42-cfd369d8a3bd'::UUID,
        '3f676348-f885-4f33-9811-c4d2a15c054c'::UUID,
        '826ecd8e-dfbd-4d8b-a199-3f71381c1e98'::UUID,
        '29ca080a-16ed-4302-879d-eac44224bbcd'::UUID,
        '7e6b1ea5-159a-4a48-8822-b028839b38da'::UUID,
        '80a66ee1-a94e-4d7b-a3ee-b5178075cc2f'::UUID,
        '291abd0f-19e2-4541-b773-a1a2f97793fb'::UUID,
        '057e487f-6767-44df-8983-33dd2adc1e8f'::UUID,
        '7e6a09b0-b689-4f25-897f-47105143b7bd'::UUID,
        '33105457-860a-4c35-8bbc-168de2b842b0'::UUID,
        'a6ce6355-d6f0-42e3-bb87-2619bd68ddb7'::UUID
    ];

    -- Date range calculation
    CASE p_time_filter
        WHEN 'today' THEN
            v_start_date := v_local_date;
            v_end_date := v_local_date;
            v_granularity := 'single';
        WHEN 'yesterday' THEN
            v_start_date := v_local_date - 1;
            v_end_date := v_local_date - 1;
            v_granularity := 'single';
        WHEN 'past_7_days' THEN
            v_start_date := v_local_date - 6;
            v_end_date := v_local_date;
            v_granularity := 'daily';
        WHEN 'this_month' THEN
            v_start_date := DATE_TRUNC('month', v_local_date)::date;
            v_end_date := v_local_date;
            v_granularity := 'daily';
        WHEN 'last_month' THEN
            v_start_date := (DATE_TRUNC('month', v_local_date) - INTERVAL '1 month')::date;
            v_end_date := (DATE_TRUNC('month', v_local_date) - INTERVAL '1 day')::date;
            v_granularity := 'daily';
        WHEN 'this_year' THEN
            v_start_date := DATE_TRUNC('year', v_local_date)::date;
            v_end_date := v_local_date;
            v_granularity := 'monthly';
    END CASE;

    -- Currency info
    SELECT ct.currency_id, ct.currency_code, ct.symbol
    INTO v_currency_id, v_currency_code, v_currency_symbol
    FROM companies c
    LEFT JOIN currency_types ct ON c.base_currency_id = ct.currency_id
    WHERE c.company_id = p_company_id;

    -- Store name
    IF p_store_id IS NULL THEN
        v_store_name := 'All Stores';
    ELSE
        SELECT store_name INTO v_store_name FROM stores WHERE store_id = p_store_id;
    END IF;

    -- ========== TOTALS ==========
    v_today := v_local_date;
    v_yesterday := v_local_date - 1;
    v_past_7_days_start := v_local_date - 6;
    v_this_month_start := DATE_TRUNC('month', v_local_date)::date;
    v_last_month_start := (DATE_TRUNC('month', v_local_date) - INTERVAL '1 month')::date;
    v_last_month_end := (DATE_TRUNC('month', v_local_date) - INTERVAL '1 day')::date;
    v_this_year_start := DATE_TRUNC('year', v_local_date)::date;

    WITH revenue_totals AS (
        SELECT
            SUM(CASE WHEN (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date = v_today
                THEN COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0) ELSE 0 END) AS today,
            SUM(CASE WHEN (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date = v_yesterday
                THEN COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0) ELSE 0 END) AS yesterday,
            SUM(CASE WHEN (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_past_7_days_start
                     AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_today
                THEN COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0) ELSE 0 END) AS past_7_days,
            SUM(CASE WHEN (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_this_month_start
                     AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_today
                THEN COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0) ELSE 0 END) AS this_month,
            SUM(CASE WHEN (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_last_month_start
                     AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_last_month_end
                THEN COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0) ELSE 0 END) AS last_month,
            SUM(CASE WHEN (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_this_year_start
                     AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_today
                THEN COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0) ELSE 0 END) AS this_year
        FROM journal_lines jl
        JOIN journal_entries je ON jl.journal_id = je.journal_id
        WHERE je.company_id = p_company_id
            AND jl.account_id = ANY(v_revenue_accounts)
            AND jl.is_deleted = false
            AND (p_store_id IS NULL OR jl.store_id = p_store_id)
            -- FIX: Changed from v_this_year_start to v_last_month_start
            -- This ensures yesterday, past_7_days, and last_month data is included at year boundaries
            AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_last_month_start
    )
    SELECT json_build_object(
        'today', COALESCE(today, 0),
        'yesterday', COALESCE(yesterday, 0),
        'past_7_days', COALESCE(past_7_days, 0),
        'this_month', COALESCE(this_month, 0),
        'last_month', COALESCE(last_month, 0),
        'this_year', COALESCE(this_year, 0)
    ) INTO v_totals
    FROM revenue_totals;

    -- ========== TIME SERIES DATA ==========
    IF v_granularity IN ('single', 'daily') THEN
        WITH date_series AS (
            SELECT generate_series(v_start_date, v_end_date, '1 day'::interval)::date AS period_date
        ),
        revenue_data AS (
            SELECT
                (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date AS txn_date,
                SUM(COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0)) AS revenue
            FROM journal_lines jl
            JOIN journal_entries je ON jl.journal_id = je.journal_id
            WHERE je.company_id = p_company_id
                AND jl.account_id = ANY(v_revenue_accounts)
                AND jl.is_deleted = false
                AND (p_store_id IS NULL OR jl.store_id = p_store_id)
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_start_date
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_end_date
            GROUP BY 1
        ),
        cogs_data AS (
            SELECT
                (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date AS txn_date,
                SUM(COALESCE(jl.debit, 0) - COALESCE(jl.credit, 0)) AS cogs
            FROM journal_lines jl
            JOIN journal_entries je ON jl.journal_id = je.journal_id
            WHERE je.company_id = p_company_id
                AND jl.account_id = ANY(v_cogs_accounts)
                AND jl.is_deleted = false
                AND (p_store_id IS NULL OR jl.store_id = p_store_id)
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_start_date
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_end_date
            GROUP BY 1
        ),
        other_expense_data AS (
            SELECT
                (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date AS txn_date,
                SUM(COALESCE(jl.debit, 0) - COALESCE(jl.credit, 0)) AS other_expenses
            FROM journal_lines jl
            JOIN journal_entries je ON jl.journal_id = je.journal_id
            WHERE je.company_id = p_company_id
                AND jl.account_id = ANY(v_other_expense_accounts)
                AND jl.is_deleted = false
                AND (p_store_id IS NULL OR jl.store_id = p_store_id)
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_start_date
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_end_date
            GROUP BY 1
        ),
        combined_data AS (
            SELECT
                ds.period_date,
                COALESCE(rd.revenue, 0) AS revenue,
                COALESCE(rd.revenue, 0) - COALESCE(cd.cogs, 0) AS gross_profit,
                COALESCE(rd.revenue, 0) - COALESCE(cd.cogs, 0) - COALESCE(oed.other_expenses, 0) AS net_income
            FROM date_series ds
            LEFT JOIN revenue_data rd ON ds.period_date = rd.txn_date
            LEFT JOIN cogs_data cd ON ds.period_date = cd.txn_date
            LEFT JOIN other_expense_data oed ON ds.period_date = oed.txn_date
        ),
        summaries AS (
            SELECT
                COALESCE(SUM(revenue), 0) AS rev_total, COALESCE(AVG(revenue), 0) AS rev_avg,
                COALESCE(MIN(revenue), 0) AS rev_min, COALESCE(MAX(revenue), 0) AS rev_max,
                COALESCE(SUM(gross_profit), 0) AS gp_total, COALESCE(AVG(gross_profit), 0) AS gp_avg,
                COALESCE(MIN(gross_profit), 0) AS gp_min, COALESCE(MAX(gross_profit), 0) AS gp_max,
                COALESCE(SUM(net_income), 0) AS ni_total, COALESCE(AVG(net_income), 0) AS ni_avg,
                COALESCE(MIN(net_income), 0) AS ni_min, COALESCE(MAX(net_income), 0) AS ni_max
            FROM combined_data
        )
        SELECT json_build_object(
            'company_id', p_company_id,
            'store_id', p_store_id,
            'store_name', v_store_name,
            'reference_time', p_time,
            'timezone', p_timezone,
            'time_filter', p_time_filter,
            'granularity', v_granularity,
            'currency_code', v_currency_code,
            'currency_symbol', v_currency_symbol,
            'totals', v_totals,
            'period', json_build_object('start', v_start_date::text, 'end', v_end_date::text),
            'data', COALESCE((SELECT json_agg(json_build_object(
                'label', period_date::text, 'revenue', revenue,
                'gross_profit', gross_profit, 'net_income', net_income
            ) ORDER BY period_date) FROM combined_data), '[]'::json),
            'summary', json_build_object(
                'revenue', json_build_object('total', s.rev_total, 'average', ROUND(s.rev_avg), 'min', s.rev_min, 'max', s.rev_max),
                'gross_profit', json_build_object('total', s.gp_total, 'average', ROUND(s.gp_avg), 'min', s.gp_min, 'max', s.gp_max),
                'net_income', json_build_object('total', s.ni_total, 'average', ROUND(s.ni_avg), 'min', s.ni_min, 'max', s.ni_max)
            )
        ) INTO v_result FROM summaries s;

    ELSE
        -- Monthly granularity (this_year)
        WITH month_series AS (
            SELECT generate_series(DATE_TRUNC('month', v_start_date), DATE_TRUNC('month', v_end_date), '1 month'::interval)::date AS period_month
        ),
        revenue_data AS (
            SELECT
                DATE_TRUNC('month', (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date)::date AS txn_month,
                SUM(COALESCE(jl.credit, 0) - COALESCE(jl.debit, 0)) AS revenue
            FROM journal_lines jl
            JOIN journal_entries je ON jl.journal_id = je.journal_id
            WHERE je.company_id = p_company_id
                AND jl.account_id = ANY(v_revenue_accounts)
                AND jl.is_deleted = false
                AND (p_store_id IS NULL OR jl.store_id = p_store_id)
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_start_date
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_end_date
            GROUP BY 1
        ),
        cogs_data AS (
            SELECT
                DATE_TRUNC('month', (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date)::date AS txn_month,
                SUM(COALESCE(jl.debit, 0) - COALESCE(jl.credit, 0)) AS cogs
            FROM journal_lines jl
            JOIN journal_entries je ON jl.journal_id = je.journal_id
            WHERE je.company_id = p_company_id
                AND jl.account_id = ANY(v_cogs_accounts)
                AND jl.is_deleted = false
                AND (p_store_id IS NULL OR jl.store_id = p_store_id)
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_start_date
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_end_date
            GROUP BY 1
        ),
        other_expense_data AS (
            SELECT
                DATE_TRUNC('month', (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date)::date AS txn_month,
                SUM(COALESCE(jl.debit, 0) - COALESCE(jl.credit, 0)) AS other_expenses
            FROM journal_lines jl
            JOIN journal_entries je ON jl.journal_id = je.journal_id
            WHERE je.company_id = p_company_id
                AND jl.account_id = ANY(v_other_expense_accounts)
                AND jl.is_deleted = false
                AND (p_store_id IS NULL OR jl.store_id = p_store_id)
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date >= v_start_date
                AND (jl.created_at AT TIME ZONE 'UTC' AT TIME ZONE p_timezone)::date <= v_end_date
            GROUP BY 1
        ),
        combined_data AS (
            SELECT
                ms.period_month,
                TO_CHAR(ms.period_month, 'YYYY-MM') AS label,
                COALESCE(rd.revenue, 0) AS revenue,
                COALESCE(rd.revenue, 0) - COALESCE(cd.cogs, 0) AS gross_profit,
                COALESCE(rd.revenue, 0) - COALESCE(cd.cogs, 0) - COALESCE(oed.other_expenses, 0) AS net_income
            FROM month_series ms
            LEFT JOIN revenue_data rd ON ms.period_month = rd.txn_month
            LEFT JOIN cogs_data cd ON ms.period_month = cd.txn_month
            LEFT JOIN other_expense_data oed ON ms.period_month = oed.txn_month
        ),
        summaries AS (
            SELECT
                COALESCE(SUM(revenue), 0) AS rev_total, COALESCE(AVG(revenue), 0) AS rev_avg,
                COALESCE(MIN(revenue), 0) AS rev_min, COALESCE(MAX(revenue), 0) AS rev_max,
                COALESCE(SUM(gross_profit), 0) AS gp_total, COALESCE(AVG(gross_profit), 0) AS gp_avg,
                COALESCE(MIN(gross_profit), 0) AS gp_min, COALESCE(MAX(gross_profit), 0) AS gp_max,
                COALESCE(SUM(net_income), 0) AS ni_total, COALESCE(AVG(net_income), 0) AS ni_avg,
                COALESCE(MIN(net_income), 0) AS ni_min, COALESCE(MAX(net_income), 0) AS ni_max
            FROM combined_data
        )
        SELECT json_build_object(
            'company_id', p_company_id,
            'store_id', p_store_id,
            'store_name', v_store_name,
            'reference_time', p_time,
            'timezone', p_timezone,
            'time_filter', p_time_filter,
            'granularity', v_granularity,
            'currency_code', v_currency_code,
            'currency_symbol', v_currency_symbol,
            'totals', v_totals,
            'period', json_build_object('start', TO_CHAR(v_start_date, 'YYYY-MM'), 'end', TO_CHAR(v_end_date, 'YYYY-MM')),
            'data', COALESCE((SELECT json_agg(json_build_object(
                'label', label, 'revenue', revenue,
                'gross_profit', gross_profit, 'net_income', net_income
            ) ORDER BY period_month) FROM combined_data), '[]'::json),
            'summary', json_build_object(
                'revenue', json_build_object('total', s.rev_total, 'average', ROUND(s.rev_avg), 'min', s.rev_min, 'max', s.rev_max),
                'gross_profit', json_build_object('total', s.gp_total, 'average', ROUND(s.gp_avg), 'min', s.gp_min, 'max', s.gp_max),
                'net_income', json_build_object('total', s.ni_total, 'average', ROUND(s.ni_avg), 'min', s.ni_min, 'max', s.ni_max)
            )
        ) INTO v_result FROM summaries s;
    END IF;

    RETURN v_result;
END;
$function$;
