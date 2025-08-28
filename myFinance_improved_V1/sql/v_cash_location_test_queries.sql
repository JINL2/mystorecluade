-- =============================================================================
-- TEST QUERIES FOR v_cash_location VIEW
-- =============================================================================
-- Use these queries to validate that the v_cash_location view is working correctly
-- after applying the fix for vault integration
-- =============================================================================

-- Test 1: Check all cash locations and their balances
-- This should show all locations with their journal and real amounts
SELECT 
  cash_location_id,
  location_name,
  location_type,
  total_journal_cash_amount,
  total_real_cash_amount,
  cash_difference,
  primary_currency_symbol,
  primary_currency_code
FROM v_cash_location
WHERE is_deleted IS NOT TRUE
ORDER BY location_type, location_name;

-- Test 2: Check vault locations specifically
-- This should show vault locations with proper calculations
SELECT 
  cl.cash_location_id,
  cl.location_name,
  cl.location_type,
  vcl.total_journal_cash_amount,
  vcl.total_real_cash_amount,
  vcl.cash_difference,
  -- Additional vault details
  (SELECT COUNT(DISTINCT val.denomination_id) 
   FROM vault_amount_line val 
   WHERE val.location_id = cl.cash_location_id) as denomination_count,
  (SELECT SUM(COALESCE(val.debit, 0) - COALESCE(val.credit, 0))
   FROM vault_amount_line val 
   WHERE val.location_id = cl.cash_location_id) as raw_vault_balance
FROM cash_locations cl
JOIN v_cash_location vcl ON cl.cash_location_id = vcl.cash_location_id
WHERE cl.location_type = 'vault'
  AND cl.is_deleted IS NOT TRUE;

-- Test 3: Check cash locations specifically
-- This should show cashier locations with proper calculations
SELECT 
  cl.cash_location_id,
  cl.location_name,
  cl.location_type,
  vcl.total_journal_cash_amount,
  vcl.total_real_cash_amount,
  vcl.cash_difference,
  -- Additional cash details
  (SELECT MAX(cal.record_date) 
   FROM cashier_amount_lines cal 
   WHERE cal.location_id = cl.cash_location_id) as last_count_date
FROM cash_locations cl
JOIN v_cash_location vcl ON cl.cash_location_id = vcl.cash_location_id
WHERE cl.location_type = 'cash'
  AND cl.is_deleted IS NOT TRUE;

-- Test 4: Check bank locations specifically
-- This should show bank locations with proper calculations
SELECT 
  cl.cash_location_id,
  cl.location_name,
  cl.bank_name,
  cl.bank_account,
  vcl.total_journal_cash_amount,
  vcl.total_real_cash_amount,
  vcl.cash_difference,
  -- Additional bank details
  (SELECT MAX(ba.created_at) 
   FROM bank_amount ba 
   WHERE ba.location_id = cl.cash_location_id) as last_update
FROM cash_locations cl
JOIN v_cash_location vcl ON cl.cash_location_id = vcl.cash_location_id
WHERE cl.location_type = 'bank'
  AND cl.is_deleted IS NOT TRUE;

-- Test 5: Validate vault amount line calculations
-- This query shows the detailed breakdown for vault locations
SELECT 
  cl.location_name,
  val.denomination_id,
  cd.value as denomination_value,
  ct.currency_code,
  val.debit,
  val.credit,
  (val.debit - val.credit) as net_quantity,
  ((val.debit - val.credit) * cd.value) as amount_in_currency,
  val.created_at
FROM vault_amount_line val
JOIN cash_locations cl ON val.location_id = cl.cash_location_id
JOIN currency_denominations cd ON val.denomination_id = cd.denomination_id
JOIN currency_types ct ON cd.currency_id = ct.currency_id
WHERE cl.location_type = 'vault'
  AND cl.is_deleted IS NOT TRUE
  AND (val.is_deleted IS NULL OR val.is_deleted = FALSE)
ORDER BY cl.location_name, ct.currency_code, cd.value DESC;

-- Test 6: Check for locations with discrepancies
-- This helps identify locations where real and journal amounts don't match
SELECT 
  location_name,
  location_type,
  total_journal_cash_amount,
  total_real_cash_amount,
  cash_difference,
  ABS(cash_difference) as absolute_difference,
  CASE 
    WHEN ABS(cash_difference) > 100 THEN 'HIGH'
    WHEN ABS(cash_difference) > 10 THEN 'MEDIUM'
    WHEN ABS(cash_difference) > 0 THEN 'LOW'
    ELSE 'NONE'
  END as discrepancy_level
FROM v_cash_location
WHERE is_deleted IS NOT TRUE
  AND ABS(cash_difference) > 0
ORDER BY ABS(cash_difference) DESC;

-- Test 7: Verify exchange rate conversions
-- Check if exchange rates are being applied correctly for non-base currencies
SELECT 
  cl.location_name,
  cl.location_type,
  ct.currency_code as location_currency,
  base_ct.currency_code as base_currency,
  ber.rate as exchange_rate,
  ber.rate_date,
  vcl.total_real_cash_amount
FROM cash_locations cl
JOIN companies comp ON cl.company_id = comp.company_id
LEFT JOIN currency_types ct ON cl.currency_id = ct.currency_id
LEFT JOIN currency_types base_ct ON comp.base_currency_id = base_ct.currency_id
LEFT JOIN LATERAL (
  SELECT rate, rate_date
  FROM book_exchange_rates
  WHERE company_id = cl.company_id
    AND from_currency_id = cl.currency_id
    AND to_currency_id = comp.base_currency_id
  ORDER BY rate_date DESC, created_at DESC
  LIMIT 1
) ber ON cl.currency_id IS NOT NULL
JOIN v_cash_location vcl ON cl.cash_location_id = vcl.cash_location_id
WHERE cl.is_deleted IS NOT TRUE
  AND cl.currency_id IS NOT NULL
  AND cl.currency_id != comp.base_currency_id;

-- Test 8: Summary by location type
-- Get totals grouped by location type
SELECT 
  location_type,
  COUNT(*) as location_count,
  SUM(total_journal_cash_amount) as total_journal,
  SUM(total_real_cash_amount) as total_real,
  SUM(cash_difference) as total_difference,
  primary_currency_symbol
FROM v_cash_location
WHERE is_deleted IS NOT TRUE
GROUP BY location_type, primary_currency_symbol
ORDER BY location_type;