-- =============================================
-- Cash Balance Page - RPC Functions
-- =============================================
-- 1. get_cash_entries_by_local_date: Daily change calculation
-- 2. get_real_balance_ledger: Ledger format (Yesterday → Change → Today)
-- 3. get_denomination_changes: Denomination detail changes by currency
--
-- Run this in Supabase SQL Editor
-- =============================================

DROP FUNCTION IF EXISTS get_cash_entries_by_local_date(uuid, date, date);

CREATE OR REPLACE FUNCTION get_cash_entries_by_local_date(
  p_company_id uuid,
  p_start_date date,
  p_end_date date
)
RETURNS TABLE(
  local_date date,
  location_id uuid,
  net_cash_flow numeric,
  original_change numeric,
  original_currency_id uuid
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_timezone text;
  v_base_currency_id uuid;
BEGIN
  -- Get company timezone and base currency
  SELECT COALESCE(c.timezone, 'Asia/Ho_Chi_Minh'), c.base_currency_id
  INTO v_timezone, v_base_currency_id
  FROM companies c
  WHERE c.company_id = p_company_id;

  RETURN QUERY
  WITH entries_with_date AS (
    SELECT
      (cae.created_at_utc AT TIME ZONE v_timezone)::date AS entry_local_date,
      cae.location_id AS entry_location_id,
      cl.location_type AS entry_location_type,
      -- Use balance_after for stock-based calculation (always VND converted)
      cae.balance_after AS base_balance,
      -- Check if multi-currency: count distinct currency_ids in snapshot
      (
        SELECT COUNT(DISTINCT d->>'currency_id')
        FROM jsonb_array_elements(cae.current_stock_snapshot->'denominations') AS d
      ) AS currency_count,
      -- For bank: use denomination_summary[0].amount
      -- For single-currency vault/cash: use snapshot sum
      -- For multi-currency vault/cash: use balance_after (VND)
      CASE
        WHEN cl.location_type = 'bank' THEN
          COALESCE((cae.denomination_summary->0->>'amount')::numeric, 0)
        ELSE
          (
            SELECT COALESCE(SUM((d->>'value')::numeric * (d->>'quantity')::numeric), 0)
            FROM jsonb_array_elements(cae.current_stock_snapshot->'denominations') AS d
          )
      END AS original_balance,
      -- For bank: get currency_id from denomination_summary
      -- For vault/cash: get the single currency or base currency if multi
      CASE
        WHEN cl.location_type = 'bank' THEN
          COALESCE((cae.denomination_summary->0->>'currency_id')::uuid, cae.currency_id)
        ELSE
          COALESCE(
            (
              SELECT DISTINCT (d->>'currency_id')::uuid
              FROM jsonb_array_elements(cae.current_stock_snapshot->'denominations') AS d
              LIMIT 1
            ),
            cae.currency_id
          )
      END AS entry_currency_id,
      cae.created_at_utc,
      -- Get the last entry per day per location
      ROW_NUMBER() OVER (
        PARTITION BY cae.location_id, (cae.created_at_utc AT TIME ZONE v_timezone)::date
        ORDER BY cae.created_at_utc DESC
      ) AS rn
    FROM cash_amount_entries cae
    JOIN cash_locations cl ON cae.location_id = cl.cash_location_id
    WHERE cl.company_id = p_company_id
  ),
  -- Get only the last entry of each day
  daily_last AS (
    SELECT
      entry_local_date,
      entry_location_id,
      base_balance,
      original_balance,
      entry_currency_id
    FROM entries_with_date
    WHERE rn = 1
  ),
  -- Calculate daily change: today's balance_after - yesterday's balance_after
  daily_change AS (
    SELECT
      d.entry_local_date,
      d.entry_location_id,
      d.base_balance,
      d.original_balance,
      LAG(d.base_balance) OVER (
        PARTITION BY d.entry_location_id ORDER BY d.entry_local_date
      ) AS prev_base_balance,
      LAG(d.original_balance) OVER (
        PARTITION BY d.entry_location_id ORDER BY d.entry_local_date
      ) AS prev_original_balance,
      d.entry_currency_id
    FROM daily_last d
  )
  SELECT
    dc.entry_local_date AS local_date,
    dc.entry_location_id AS location_id,
    -- Base currency (VND) daily change
    COALESCE(dc.base_balance - dc.prev_base_balance, dc.base_balance) AS net_cash_flow,
    -- Original currency daily change
    COALESCE(dc.original_balance - dc.prev_original_balance, dc.original_balance) AS original_change,
    dc.entry_currency_id AS original_currency_id
  FROM daily_change dc
  WHERE dc.entry_local_date BETWEEN p_start_date AND p_end_date;
END;
$$;

-- =============================================
-- RPC: Get real balance in ledger format
-- Returns yesterday balance, today balance, and change for each currency
-- =============================================
DROP FUNCTION IF EXISTS get_real_balance_ledger(uuid, uuid, date);

CREATE OR REPLACE FUNCTION get_real_balance_ledger(
  p_company_id uuid,
  p_location_id uuid,
  p_local_date date
)
RETURNS TABLE(
  currency_id uuid,
  yesterday_balance numeric,
  today_balance numeric,
  balance_change numeric,
  is_multi_currency boolean
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_timezone text;
  v_today_snapshot jsonb;
  v_yesterday_snapshot jsonb;
  v_location_type text;
  v_today_bank_amount numeric;
  v_today_bank_currency uuid;
  v_yesterday_bank_amount numeric;
  v_yesterday_bank_currency uuid;
BEGIN
  -- Get company timezone
  SELECT COALESCE(c.timezone, 'Asia/Ho_Chi_Minh')
  INTO v_timezone
  FROM companies c
  WHERE c.company_id = p_company_id;

  -- Get location type
  SELECT cl.location_type
  INTO v_location_type
  FROM cash_locations cl
  WHERE cl.cash_location_id = p_location_id;

  -- Get today's last entry
  SELECT
    cae.current_stock_snapshot,
    COALESCE((cae.denomination_summary->0->>'amount')::numeric, 0),
    COALESCE((cae.denomination_summary->0->>'currency_id')::uuid, cae.currency_id)
  INTO v_today_snapshot, v_today_bank_amount, v_today_bank_currency
  FROM cash_amount_entries cae
  WHERE cae.location_id = p_location_id
    AND (cae.created_at_utc AT TIME ZONE v_timezone)::date = p_local_date
  ORDER BY cae.created_at_utc DESC
  LIMIT 1;

  -- Get yesterday's last entry
  SELECT
    cae.current_stock_snapshot,
    COALESCE((cae.denomination_summary->0->>'amount')::numeric, 0),
    COALESCE((cae.denomination_summary->0->>'currency_id')::uuid, cae.currency_id)
  INTO v_yesterday_snapshot, v_yesterday_bank_amount, v_yesterday_bank_currency
  FROM cash_amount_entries cae
  WHERE cae.location_id = p_location_id
    AND (cae.created_at_utc AT TIME ZONE v_timezone)::date = p_local_date - 1
  ORDER BY cae.created_at_utc DESC
  LIMIT 1;

  -- For bank: simple single currency
  IF v_location_type = 'bank' THEN
    RETURN QUERY
    SELECT
      COALESCE(v_today_bank_currency, v_yesterday_bank_currency) AS currency_id,
      COALESCE(v_yesterday_bank_amount, 0::numeric) AS yesterday_balance,
      COALESCE(v_today_bank_amount, 0::numeric) AS today_balance,
      COALESCE(v_today_bank_amount, 0::numeric) - COALESCE(v_yesterday_bank_amount, 0::numeric) AS balance_change,
      false AS is_multi_currency;
    RETURN;
  END IF;

  -- For vault/cash: group by currency
  RETURN QUERY
  WITH today_by_currency AS (
    SELECT
      (d->>'currency_id')::uuid AS curr_id,
      SUM((d->>'value')::numeric * (d->>'quantity')::numeric) AS total
    FROM jsonb_array_elements(COALESCE(v_today_snapshot->'denominations', '[]'::jsonb)) AS d
    GROUP BY (d->>'currency_id')::uuid
  ),
  yesterday_by_currency AS (
    SELECT
      (d->>'currency_id')::uuid AS curr_id,
      SUM((d->>'value')::numeric * (d->>'quantity')::numeric) AS total
    FROM jsonb_array_elements(COALESCE(v_yesterday_snapshot->'denominations', '[]'::jsonb)) AS d
    GROUP BY (d->>'currency_id')::uuid
  ),
  all_currencies AS (
    SELECT curr_id FROM today_by_currency
    UNION
    SELECT curr_id FROM yesterday_by_currency
  ),
  currency_count AS (
    SELECT COUNT(*) AS cnt FROM all_currencies
  )
  SELECT
    ac.curr_id AS currency_id,
    COALESCE(y.total, 0::numeric) AS yesterday_balance,
    COALESCE(t.total, 0::numeric) AS today_balance,
    COALESCE(t.total, 0::numeric) - COALESCE(y.total, 0::numeric) AS balance_change,
    (SELECT cnt > 1 FROM currency_count) AS is_multi_currency
  FROM all_currencies ac
  LEFT JOIN today_by_currency t ON ac.curr_id = t.curr_id
  LEFT JOIN yesterday_by_currency y ON ac.curr_id = y.curr_id
  ORDER BY ac.curr_id;
END;
$$;

-- =============================================
-- RPC: Get denomination changes with currency grouping
-- For vault/cash locations only (bank has no denominations)
-- Now includes currency_code and supports multi-currency
-- =============================================
DROP FUNCTION IF EXISTS get_denomination_changes(uuid, uuid, date);

CREATE OR REPLACE FUNCTION get_denomination_changes(
  p_company_id uuid,
  p_location_id uuid,
  p_local_date date
)
RETURNS TABLE(
  denomination_id uuid,
  currency_id uuid,
  denomination_value numeric,
  today_quantity integer,
  yesterday_quantity integer,
  quantity_change integer,
  today_amount numeric,
  yesterday_amount numeric,
  amount_change numeric
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_timezone text;
  v_today_snapshot jsonb;
  v_yesterday_snapshot jsonb;
BEGIN
  -- Get company timezone
  SELECT COALESCE(c.timezone, 'Asia/Ho_Chi_Minh')
  INTO v_timezone
  FROM companies c
  WHERE c.company_id = p_company_id;

  -- Get today's last entry snapshot
  SELECT cae.current_stock_snapshot
  INTO v_today_snapshot
  FROM cash_amount_entries cae
  WHERE cae.location_id = p_location_id
    AND (cae.created_at_utc AT TIME ZONE v_timezone)::date = p_local_date
  ORDER BY cae.created_at_utc DESC
  LIMIT 1;

  -- Get yesterday's last entry snapshot
  SELECT cae.current_stock_snapshot
  INTO v_yesterday_snapshot
  FROM cash_amount_entries cae
  WHERE cae.location_id = p_location_id
    AND (cae.created_at_utc AT TIME ZONE v_timezone)::date = p_local_date - 1
  ORDER BY cae.created_at_utc DESC
  LIMIT 1;

  RETURN QUERY
  WITH today_denoms AS (
    SELECT
      (d->>'denomination_id')::uuid AS denom_id,
      (d->>'currency_id')::uuid AS curr_id,
      (d->>'value')::numeric AS denom_value,
      (d->>'quantity')::integer AS qty
    FROM jsonb_array_elements(COALESCE(v_today_snapshot->'denominations', '[]'::jsonb)) AS d
  ),
  yesterday_denoms AS (
    SELECT
      (d->>'denomination_id')::uuid AS denom_id,
      (d->>'currency_id')::uuid AS curr_id,
      (d->>'value')::numeric AS denom_value,
      (d->>'quantity')::integer AS qty
    FROM jsonb_array_elements(COALESCE(v_yesterday_snapshot->'denominations', '[]'::jsonb)) AS d
  ),
  all_denoms AS (
    SELECT DISTINCT denom_id, curr_id, denom_value FROM today_denoms
    UNION
    SELECT DISTINCT denom_id, curr_id, denom_value FROM yesterday_denoms
  )
  SELECT
    ad.denom_id AS denomination_id,
    ad.curr_id AS currency_id,
    ad.denom_value AS denomination_value,
    COALESCE(t.qty, 0) AS today_quantity,
    COALESCE(y.qty, 0) AS yesterday_quantity,
    COALESCE(t.qty, 0) - COALESCE(y.qty, 0) AS quantity_change,
    COALESCE(t.qty, 0)::numeric * ad.denom_value AS today_amount,
    COALESCE(y.qty, 0)::numeric * ad.denom_value AS yesterday_amount,
    (COALESCE(t.qty, 0) - COALESCE(y.qty, 0))::numeric * ad.denom_value AS amount_change
  FROM all_denoms ad
  LEFT JOIN today_denoms t ON ad.denom_id = t.denom_id
  LEFT JOIN yesterday_denoms y ON ad.denom_id = y.denom_id
  WHERE COALESCE(t.qty, 0) - COALESCE(y.qty, 0) != 0
  ORDER BY ad.curr_id, ad.denom_value DESC;
END;
$$;

-- =============================================
-- RPC: Get journal details by local date
-- Returns journal entries and lines for a specific cash location and date
-- =============================================
DROP FUNCTION IF EXISTS get_journal_details_by_local_date(uuid, uuid, date);

CREATE OR REPLACE FUNCTION get_journal_details_by_local_date(
  p_company_id uuid,
  p_cash_location_id uuid,
  p_local_date date
)
RETURNS TABLE(
  journal_id uuid,
  line_id uuid,
  local_date date,
  journal_description text,
  journal_type text,
  line_description text,
  debit numeric,
  credit numeric,
  account_name text
)
LANGUAGE plpgsql
AS $$
DECLARE
  v_timezone text;
BEGIN
  -- Get company timezone
  SELECT COALESCE(c.timezone, 'Asia/Ho_Chi_Minh')
  INTO v_timezone
  FROM companies c
  WHERE c.company_id = p_company_id;

  RETURN QUERY
  SELECT
    je.journal_id,
    jl.line_id,
    (je.entry_date_utc AT TIME ZONE v_timezone)::date AS local_date,
    je.description AS journal_description,
    je.journal_type,
    jl.description AS line_description,
    COALESCE(jl.debit, 0::numeric) AS debit,
    COALESCE(jl.credit, 0::numeric) AS credit,
    a.account_name
  FROM journal_entries je
  JOIN journal_lines jl ON je.journal_id = jl.journal_id
  JOIN accounts a ON jl.account_id = a.account_id
  WHERE je.company_id = p_company_id
    AND jl.cash_location_id = p_cash_location_id
    AND (je.entry_date_utc AT TIME ZONE v_timezone)::date = p_local_date
    AND (je.is_deleted IS NULL OR je.is_deleted = false)
    AND (jl.is_deleted IS NULL OR jl.is_deleted = false)
  ORDER BY je.created_at_utc, jl.line_id;
END;
$$;

