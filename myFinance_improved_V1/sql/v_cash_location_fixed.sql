-- Drop existing view if it exists
DROP VIEW IF EXISTS public.v_cash_location;

-- Create corrected view with proper vault integration
CREATE VIEW public.v_cash_location AS
SELECT
  cl.cash_location_id,
  cl.company_id,
  cl.store_id,
  cl.location_name,
  cl.location_type,
  cl.created_at,
  cl.location_info,
  cl.is_deleted,
  -- Journal cash amount (book value)
  COALESCE(SUM(jl.debit), 0::numeric) - COALESCE(SUM(jl.credit), 0::numeric) AS total_journal_cash_amount,
  -- Real cash amount (physical count)
  COALESCE("real".total_real_cash_amount, 0::numeric) AS total_real_cash_amount,
  -- Cash difference (real - journal)
  COALESCE("real".total_real_cash_amount, 0::numeric) - (
    COALESCE(SUM(jl.debit), 0::numeric) - COALESCE(SUM(jl.credit), 0::numeric)
  ) AS cash_difference,
  -- Currency information
  COALESCE(company_currency.symbol, '$'::text) AS primary_currency_symbol,
  COALESCE(company_currency.currency_code, 'USD'::text) AS primary_currency_code
FROM
  cash_locations cl
  -- Join with journal lines for book value
  LEFT JOIN journal_lines jl ON cl.cash_location_id = jl.cash_location_id
    AND jl.is_deleted IS NOT TRUE
  -- Join with companies for base currency
  LEFT JOIN companies comp ON cl.company_id = comp.company_id
  -- Join with currency types for symbol and code
  LEFT JOIN currency_types company_currency ON comp.base_currency_id = company_currency.currency_id
  -- Lateral join for calculating real cash amounts based on location type
  LEFT JOIN LATERAL (
    SELECT
      CASE
        -- CASH location type: sum from cashier_amount_lines (physical cash count)
        WHEN cl.location_type = 'cash'::text THEN (
          SELECT
            SUM(
              l.quantity::numeric * d.value * 
              COALESCE(
                CASE
                  WHEN d.currency_id = comp.base_currency_id THEN 1::numeric
                  ELSE (
                    -- Get exchange rate to base currency
                    SELECT ber.rate
                    FROM book_exchange_rates ber
                    WHERE ber.company_id = cl.company_id
                      AND ber.from_currency_id = d.currency_id
                      AND ber.to_currency_id = comp.base_currency_id
                    ORDER BY ber.rate_date DESC, ber.created_at DESC
                    LIMIT 1
                  )
                END,
                1::numeric
              )
            ) AS sum
          FROM cashier_amount_lines l
          JOIN currency_denominations d ON l.denomination_id = d.denomination_id
          WHERE l.location_id = cl.cash_location_id
            -- Get the most recent record
            AND l.record_date = (
              SELECT MAX(l2.record_date)
              FROM cashier_amount_lines l2
              WHERE l2.location_id = l.location_id
            )
            AND l.created_at = (
              SELECT MAX(l3.created_at)
              FROM cashier_amount_lines l3
              WHERE l3.location_id = l.location_id
                AND l3.record_date = l.record_date
            )
        )
        
        -- VAULT location type: sum from vault_amount_line (vault cash with debit/credit)
        WHEN cl.location_type = 'vault'::text THEN (
          SELECT
            SUM(
              (COALESCE(val.debit, 0::numeric) - COALESCE(val.credit, 0::numeric)) * 
              cd.value * 
              COALESCE(
                CASE
                  WHEN cd.currency_id = comp.base_currency_id THEN 1::numeric
                  ELSE (
                    -- Get exchange rate to base currency
                    SELECT ber.rate
                    FROM book_exchange_rates ber
                    WHERE ber.company_id = cl.company_id
                      AND ber.from_currency_id = cd.currency_id
                      AND ber.to_currency_id = comp.base_currency_id
                    ORDER BY ber.rate_date DESC, ber.created_at DESC
                    LIMIT 1
                  )
                END,
                1::numeric
              )
            ) AS sum
          FROM vault_amount_line val
          JOIN currency_denominations cd ON val.denomination_id = cd.denomination_id
          WHERE val.location_id = cl.cash_location_id
        )
        
        -- BANK location type: get latest bank_amount record
        WHEN cl.location_type = 'bank'::text THEN (
          SELECT
            ba.total_amount * 
            COALESCE(
              CASE
                WHEN ba.currency_id = comp.base_currency_id THEN 1::numeric
                ELSE (
                  -- Get exchange rate to base currency
                  SELECT ber.rate
                  FROM book_exchange_rates ber
                  WHERE ber.company_id = cl.company_id
                    AND ber.from_currency_id = ba.currency_id
                    AND ber.to_currency_id = comp.base_currency_id
                  ORDER BY ber.rate_date DESC, ber.created_at DESC
                  LIMIT 1
                )
              END,
              1::numeric
            )
          FROM bank_amount ba
          WHERE ba.location_id = cl.cash_location_id
          ORDER BY ba.created_at DESC
          LIMIT 1
        )
        
        -- Default case: return 0
        ELSE 0::numeric
      END AS total_real_cash_amount
  ) "real" ON true
GROUP BY
  cl.cash_location_id,
  cl.company_id,
  cl.store_id,
  cl.location_name,
  cl.location_type,
  cl.created_at,
  cl.location_info,
  cl.is_deleted,
  "real".total_real_cash_amount,
  company_currency.symbol,
  company_currency.currency_code;

-- Add comment to the view
COMMENT ON VIEW public.v_cash_location IS 'View for cash location balances including journal (book) amounts and real (physical) amounts for cash, vault, and bank locations';