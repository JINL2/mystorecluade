# 🚀 Deployment Guide - Universal Multi-Currency RPC

**Date**: 2025-11-23
**Status**: ✅ Ready for Deployment

---

## ✅ Pre-Deployment Checklist

### 1. Database Schema Verification

Run these queries to verify required tables and columns exist:

```sql
-- ✅ Check companies.base_currency_id exists
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'companies'
  AND column_name = 'base_currency_id';
-- Expected: 1 row (uuid)

-- ✅ Check book_exchange_rates table exists
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'book_exchange_rates'
ORDER BY ordinal_position;
-- Expected: rate_id, company_id, from_currency_id, to_currency_id, rate, rate_date, created_by, created_at

-- ✅ Check cash_amount_entries JSONB fields
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'cash_amount_entries'
  AND column_name IN ('denomination_summary', 'exchange_rates', 'base_currency_id');
-- Expected: 3 rows (all jsonb or uuid)
```

### 2. Sample Data Verification

Verify you have test data:

```sql
-- Check if you have exchange rates
SELECT
  c.company_name,
  ct1.currency_code AS from_currency,
  ct2.currency_code AS to_currency,
  ber.rate,
  ber.rate_date
FROM book_exchange_rates ber
JOIN companies c ON c.company_id = ber.company_id
JOIN currency_types ct1 ON ct1.currency_id = ber.from_currency_id
JOIN currency_types ct2 ON ct2.currency_id = ber.to_currency_id
ORDER BY ber.rate_date DESC
LIMIT 5;

-- Check company base currency
SELECT
  c.company_name,
  ct.currency_code AS base_currency
FROM companies c
LEFT JOIN currency_types ct ON ct.currency_id = c.base_currency_id
WHERE c.is_deleted IS NOT TRUE
LIMIT 5;
```

---

## 📝 Deployment Steps

### Step 1: Deploy RPC Function

1. Open Supabase SQL Editor
2. Copy entire content from [INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql](INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql)
3. Execute the SQL
4. Verify no errors

### Step 2: Verify Function Exists

```sql
-- Check function was created
SELECT
  p.proname AS function_name,
  pg_get_function_arguments(p.oid) AS arguments,
  pg_get_function_result(p.oid) AS return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname = 'insert_amount_multi_currency'
  AND n.nspname = 'public';
```

Expected output:
```
function_name: insert_amount_multi_currency
arguments: p_entry_type character varying, p_company_id uuid, ...
return_type: TABLE(entry_id uuid, balance_before numeric, ...)
```

---

## 🧪 Testing

### Test 1: Cash - Single Currency (VND only)

```sql
-- Get test data IDs first
SELECT
  company_id,
  base_currency_id
FROM companies
WHERE is_deleted IS NOT TRUE
LIMIT 1;

-- Get VND denominations
SELECT
  d.denomination_id,
  ct.currency_code,
  d.value
FROM currency_denominations d
JOIN currency_types ct ON ct.currency_id = d.currency_id
WHERE ct.currency_code = 'VND'
ORDER BY d.value DESC
LIMIT 3;

-- Test cash ending with VND
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'cash',
  p_company_id := '<your-company-id>',
  p_location_id := '<your-location-id>',
  p_record_date := CURRENT_DATE,
  p_created_by := '<your-user-id>',
  p_currencies := '[
    {
      "currency_id": "<vnd-currency-id>",
      "denominations": [
        {"denomination_id": "<500k-denom-id>", "quantity": 10},
        {"denomination_id": "<200k-denom-id>", "quantity": 5}
      ]
    }
  ]'::JSONB
);
```

**Expected Result**:
- Returns: entry_id, balance_before (0), balance_after (6,000,000), total_amount_base_currency (6,000,000)
- Check `cash_amount_entries`: 1 new row with VND as currency_id
- Check `cashier_amount_lines`: 2 new rows (500k × 10, 200k × 5)

### Test 2: Cash - Multi-Currency (VND + USD)

```sql
-- Get USD denominations
SELECT
  d.denomination_id,
  ct.currency_code,
  d.value
FROM currency_denominations d
JOIN currency_types ct ON ct.currency_id = d.currency_id
WHERE ct.currency_code = 'USD'
ORDER BY d.value DESC
LIMIT 2;

-- Verify exchange rate exists
SELECT rate
FROM book_exchange_rates
WHERE company_id = '<your-company-id>'
  AND from_currency_id = '<usd-currency-id>'
  AND to_currency_id = '<vnd-currency-id>'
  AND rate_date <= CURRENT_DATE
ORDER BY rate_date DESC
LIMIT 1;

-- Test multi-currency cash ending
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'cash',
  p_company_id := '<your-company-id>',
  p_location_id := '<your-location-id>',
  p_record_date := CURRENT_DATE,
  p_created_by := '<your-user-id>',
  p_currencies := '[
    {
      "currency_id": "<vnd-currency-id>",
      "denominations": [
        {"denomination_id": "<500k-denom-id>", "quantity": 10}
      ]
    },
    {
      "currency_id": "<usd-currency-id>",
      "denominations": [
        {"denomination_id": "<100-usd-denom-id>", "quantity": 2}
      ]
    }
  ]'::JSONB
);
```

**Expected Result**:
- Returns: entry_id, balance_before, balance_after = (VND total + USD total × exchange_rate)
- Check `cash_amount_entries`:
  - 1 new row (not 2!)
  - `currency_id` = VND (base currency)
  - `denomination_summary` JSONB contains both VND and USD
  - `exchange_rates` JSONB contains rates used
- Check `cashier_amount_lines`: 2 new rows (VND + USD, same entry_id)

### Test 3: Vault - IN (Multi-Currency Deposit)

```sql
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'vault',
  p_vault_transaction_type := 'in',
  p_company_id := '<your-company-id>',
  p_location_id := '<vault-location-id>',
  p_record_date := CURRENT_DATE,
  p_created_by := '<your-user-id>',
  p_currencies := '[
    {
      "currency_id": "<vnd-currency-id>",
      "denominations": [
        {"denomination_id": "<500k-denom-id>", "debit": 5000000}
      ]
    },
    {
      "currency_id": "<usd-currency-id>",
      "denominations": [
        {"denomination_id": "<100-usd-denom-id>", "debit": 200}
      ]
    }
  ]'::JSONB
);
```

**Expected Result**:
- Single entry with combined deposit amount in base currency
- Check `vault_amount_line`: 2 rows with debit values (VND + USD)

### Test 4: Vault - OUT (Multi-Currency Withdrawal)

```sql
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'vault',
  p_vault_transaction_type := 'out',
  p_company_id := '<your-company-id>',
  p_location_id := '<vault-location-id>',
  p_record_date := CURRENT_DATE,
  p_created_by := '<your-user-id>',
  p_currencies := '[
    {
      "currency_id": "<vnd-currency-id>",
      "denominations": [
        {"denomination_id": "<200k-denom-id>", "credit": 2000000}
      ]
    }
  ]'::JSONB
);
```

**Expected Result**:
- Single entry with withdrawal amount (negative) in base currency
- Check `vault_amount_line`: 1 row with credit value

### Test 5: Vault - RECOUNT (Multi-Currency Adjustment)

```sql
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'vault',
  p_vault_transaction_type := 'recount',
  p_company_id := '<your-company-id>',
  p_location_id := '<vault-location-id>',
  p_record_date := CURRENT_DATE,
  p_created_by := '<your-user-id>',
  p_currencies := '[
    {
      "currency_id": "<vnd-currency-id>",
      "denominations": [
        {"denomination_id": "<500k-denom-id>", "quantity": 12}
      ]
    }
  ]'::JSONB
);
```

**Expected Result**:
- Calculates difference between system stock and actual stock
- Single entry with adjustment amount (debit if surplus, credit if shortage)
- Check `vault_amount_line`: adjustment rows

---

## 🔍 Verification Queries

### Check Created Entry

```sql
-- Get latest entry
SELECT
  entry_id,
  entry_type,
  currency_id,
  balance_before,
  balance_after,
  total_amount,
  denomination_summary,
  exchange_rates,
  created_at
FROM cash_amount_entries
ORDER BY created_at DESC
LIMIT 1;
```

### Check Denomination Lines

```sql
-- For Cash
SELECT
  cl.line_id,
  cl.entry_id,
  d.value AS denomination_value,
  ct.currency_code,
  cl.quantity,
  (d.value * cl.quantity) AS line_total
FROM cashier_amount_lines cl
JOIN currency_denominations d ON d.denomination_id = cl.denomination_id
JOIN currency_types ct ON ct.currency_id = d.currency_id
WHERE cl.entry_id = '<entry-id-from-above>'
ORDER BY ct.currency_code, d.value DESC;

-- For Vault
SELECT
  vl.line_id,
  vl.entry_id,
  d.value AS denomination_value,
  ct.currency_code,
  vl.debit,
  vl.credit,
  vl.transaction_type
FROM vault_amount_line vl
JOIN currency_denominations d ON d.denomination_id = vl.denomination_id
JOIN currency_types ct ON ct.currency_id = d.currency_id
WHERE vl.entry_id = '<entry-id-from-above>'
ORDER BY ct.currency_code, d.value DESC;
```

### Verify Multi-Currency Totals Match

```sql
-- For a multi-currency entry, verify the math
WITH entry_data AS (
  SELECT
    entry_id,
    balance_after - balance_before AS total_change,
    denomination_summary,
    exchange_rates
  FROM cash_amount_entries
  WHERE entry_id = '<entry-id-from-test>'
)
SELECT
  entry_id,
  total_change,
  denomination_summary,
  exchange_rates,
  -- Verify: total_change should equal sum of (amount × exchange_rate) from denomination_summary
  (
    SELECT SUM(
      (item->>'amount')::NUMERIC *
      COALESCE((exchange_rates->(item->>'currency_id'))::TEXT::NUMERIC, 1.0)
    )
    FROM jsonb_array_elements(denomination_summary) AS item
  ) AS calculated_total
FROM entry_data;
```

---

## ⚠️ Common Issues

### Issue 1: Base Currency Not Found
**Error**: `Base currency not found for company: <uuid>`

**Solution**:
```sql
-- Check if company has base_currency_id set
SELECT company_id, company_name, base_currency_id
FROM companies
WHERE company_id = '<your-company-id>';

-- If NULL, set base currency
UPDATE companies
SET base_currency_id = '<vnd-currency-id>'
WHERE company_id = '<your-company-id>';
```

### Issue 2: Exchange Rate Not Found
**Error**: `Exchange rate not found for currency <uuid> to base currency <uuid> on date <date>`

**Solution**:
```sql
-- Insert missing exchange rate
INSERT INTO book_exchange_rates (
  rate_id,
  company_id,
  from_currency_id,
  to_currency_id,
  rate,
  rate_date,
  created_by,
  created_at
) VALUES (
  gen_random_uuid(),
  '<company-id>',
  '<usd-currency-id>',
  '<vnd-currency-id>',
  25000,
  CURRENT_DATE,
  '<user-id>',
  NOW()
);
```

### Issue 3: Denomination Not Found
**Error**: Query returns NULL for denomination value

**Solution**:
```sql
-- Verify denomination exists
SELECT denomination_id, currency_id, value
FROM currency_denominations
WHERE denomination_id = '<denom-id>';
```

---

## ✅ Post-Deployment Checklist

- [ ] RPC function deployed successfully
- [ ] Test 1 passed (Single currency Cash)
- [ ] Test 2 passed (Multi-currency Cash)
- [ ] Test 3 passed (Vault IN)
- [ ] Test 4 passed (Vault OUT)
- [ ] Test 5 passed (Vault RECOUNT)
- [ ] Verified entry created with correct base currency
- [ ] Verified denomination_summary JSONB populated
- [ ] Verified exchange_rates JSONB populated
- [ ] Verified all denomination lines linked to single entry_id
- [ ] Balance calculation correct (matches manual calculation)

---

## 📚 Next Steps After Deployment

1. **Update Flutter Code**
   - Follow [RPC_MIGRATION_PLAN_2025-11-23.md](RPC_MIGRATION_PLAN_2025-11-23.md)
   - Update DTOs to use new RPC
   - Add Vault multi-currency support

2. **Deprecate Old RPCs**
   - Mark old RPCs as deprecated in Flutter constants
   - Keep old RPCs for rollback safety
   - Remove after successful migration

3. **Monitor Production**
   - Watch for errors in logs
   - Verify balance summary still works
   - Check performance with multi-currency data

---

## 🔄 Rollback Plan

If issues occur after deployment:

1. **Flutter Side**: Revert to old RPC constants in `constants.dart`
2. **Database Side**: Keep both old and new RPCs (no need to drop)
3. **Data**: New entries are compatible, old entries remain unchanged

---

**Need Help?** Check:
- [SINGLE_ENTRY_ARCHITECTURE_SUMMARY_2025-11-23.md](SINGLE_ENTRY_ARCHITECTURE_SUMMARY_2025-11-23.md)
- [RPC_MIGRATION_PLAN_2025-11-23.md](RPC_MIGRATION_PLAN_2025-11-23.md)
