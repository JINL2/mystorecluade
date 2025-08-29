-- =============================================================================
-- VIEW: v_cash_location (FINAL CORRECTED VERSION)
-- Purpose: Comprehensive cash location view with proper vault integration
-- Date: 2025-01-28
-- =============================================================================
-- IMPORTANT: This view has been corrected to properly handle the vault_amount_line
-- table structure. The vault_amount_line table does NOT have an is_deleted column.
-- =============================================================================

-- Drop existing view if it exists
DROP VIEW IF EXISTS public.v_cash_location;

-- Create the corrected view
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
  
  -- Journal cash amount (book value from accounting entries)
  COALESCE(SUM(jl.debit), 0::numeric) - COALESCE(SUM(jl.credit), 0::numeric) AS total_journal_cash_amount,
  
  -- Real cash amount (physical count or actual balance)
  COALESCE("real".total_real_cash_amount, 0::numeric) AS total_real_cash_amount,
  
  -- Cash difference (real minus journal - positive means excess cash)
  COALESCE("real".total_real_cash_amount, 0::numeric) - (
    COALESCE(SUM(jl.debit), 0::numeric) - COALESCE(SUM(jl.credit), 0::numeric)
  ) AS cash_difference,
  
  -- Company's primary currency information
  COALESCE(company_currency.symbol, '$'::text) AS primary_currency_symbol,
  COALESCE(company_currency.currency_code, 'USD'::text) AS primary_currency_code
  
FROM
  cash_locations cl
  
  -- Join with journal lines for book value calculation
  LEFT JOIN journal_lines jl ON cl.cash_location_id = jl.cash_location_id
    AND jl.is_deleted IS NOT TRUE
  
  -- Join with companies to get base currency
  LEFT JOIN companies comp ON cl.company_id = comp.company_id
  
  -- Join with currency types for currency symbol and code
  LEFT JOIN currency_types company_currency ON comp.base_currency_id = company_currency.currency_id
  
  -- Lateral join for calculating real cash amounts based on location type
  LEFT JOIN LATERAL (
    SELECT
      CASE
        -- ===================================================================
        -- CASH LOCATION TYPE (Cashier drawer)
        -- ===================================================================
        WHEN cl.location_type = 'cash'::text THEN (
          SELECT
            SUM(
              l.quantity::numeric * d.value * 
              -- Convert to base currency if needed
              COALESCE(
                CASE
                  WHEN d.currency_id = comp.base_currency_id THEN 1::numeric
                  ELSE (
                    -- Get the most recent exchange rate
                    SELECT ber.rate
                    FROM book_exchange_rates ber
                    WHERE ber.company_id = cl.company_id
                      AND ber.from_currency_id = d.currency_id
                      AND ber.to_currency_id = comp.base_currency_id
                    ORDER BY 
                      ber.rate_date DESC,
                      ber.created_at DESC
                    LIMIT 1
                  )
                END,
                1::numeric -- Default to 1 if no exchange rate found
              )
            ) AS sum
          FROM cashier_amount_lines l
          JOIN currency_denominations d ON l.denomination_id = d.denomination_id
          WHERE l.location_id = cl.cash_location_id
            -- Get the most recent record date
            AND l.record_date = (
              SELECT MAX(l2.record_date)
              FROM cashier_amount_lines l2
              WHERE l2.location_id = l.location_id
            )
            -- For the most recent date, get the latest created_at
            AND l.created_at = (
              SELECT MAX(l3.created_at)
              FROM cashier_amount_lines l3
              WHERE l3.location_id = l.location_id
                AND l3.record_date = l.record_date
            )
        )
        
        -- ===================================================================
        -- VAULT LOCATION TYPE (Safe/Vault storage)
        -- ===================================================================
        WHEN cl.location_type = 'vault'::text THEN (
          SELECT
            SUM(
              -- Net amount (debit minus credit) per denomination
              (COALESCE(val.debit, 0::numeric) - COALESCE(val.credit, 0::numeric)) * 
              cd.value * 
              -- Convert to base currency if needed
              COALESCE(
                CASE
                  WHEN cd.currency_id = comp.base_currency_id THEN 1::numeric
                  ELSE (
                    -- Get the most recent exchange rate
                    SELECT ber.rate
                    FROM book_exchange_rates ber
                    WHERE ber.company_id = cl.company_id
                      AND ber.from_currency_id = cd.currency_id
                      AND ber.to_currency_id = comp.base_currency_id
                    ORDER BY 
                      ber.rate_date DESC,
                      ber.created_at DESC
                    LIMIT 1
                  )
                END,
                1::numeric -- Default to 1 if no exchange rate found
              )
            ) AS sum
          FROM vault_amount_line val
          JOIN currency_denominations cd ON val.denomination_id = cd.denomination_id
          WHERE val.location_id = cl.cash_location_id
          -- Note: vault_amount_line table does NOT have is_deleted column
          -- All vault records are permanent for audit trail
        )
        
        -- ===================================================================
        -- BANK LOCATION TYPE (Bank account)
        -- ===================================================================
        WHEN cl.location_type = 'bank'::text THEN (
          SELECT
            ba.total_amount * 
            -- Convert to base currency if needed
            COALESCE(
              CASE
                WHEN ba.currency_id = comp.base_currency_id THEN 1::numeric
                ELSE (
                  -- Get the most recent exchange rate
                  SELECT ber.rate
                  FROM book_exchange_rates ber
                  WHERE ber.company_id = cl.company_id
                    AND ber.from_currency_id = ba.currency_id
                    AND ber.to_currency_id = comp.base_currency_id
                  ORDER BY 
                    ber.rate_date DESC,
                    ber.created_at DESC
                  LIMIT 1
                )
              END,
              1::numeric -- Default to 1 if no exchange rate found
            )
          FROM bank_amount ba
          WHERE ba.location_id = cl.cash_location_id
          ORDER BY ba.created_at DESC
          LIMIT 1 -- Get the most recent bank amount
        )
        
        -- Default case: return 0 for unknown location types
        ELSE 0::numeric
      END AS total_real_cash_amount
  ) "real" ON true

-- Group by all non-aggregate columns
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

-- Add helpful comments
COMMENT ON VIEW public.v_cash_location IS 
'Comprehensive cash location view that consolidates:
- Journal entries (book value)
- Physical cash counts (cashier_amount_lines)
- Vault transactions (vault_amount_line with debit/credit - NO is_deleted column)
- Bank balances (bank_amount)
All amounts are converted to the company base currency using exchange rates.
Last updated: 2025-01-28 - Fixed vault calculation to match actual table structure.';

-- Grant appropriate permissions (adjust as needed for your security model)
-- GRANT SELECT ON public.v_cash_location TO authenticated;
-- GRANT SELECT ON public.v_cash_location TO service_role;