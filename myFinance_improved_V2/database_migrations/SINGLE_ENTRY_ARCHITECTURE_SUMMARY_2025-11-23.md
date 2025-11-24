# 🎯 Single Entry Architecture - Summary

**Date**: 2025-11-23
**Status**: ✅ RPC Redesigned - Ready for Review & Deployment

---

## 📌 What Changed?

### Previous Design (WRONG ❌)
- Created **separate entry for each currency**
- Example: VND + USD → 2 entries in `cash_amount_entries`
- Balance tracking was per currency
- No currency conversion

### New Design (CORRECT ✅)
- Creates **SINGLE entry per transaction**
- Example: VND + USD → 1 entry in `cash_amount_entries`
- Balance tracking in **base currency only**
- All currencies converted to base currency for balance calculation
- Original currency details stored in **JSONB fields**

---

## 🔍 How It Works

### Architecture Flow

```
Input: Multi-Currency Transaction (VND + USD)
    ↓
1. Get Base Currency (e.g., VND)
    ↓
2. Convert All Currencies to Base Currency
   - VND 5,000,000 → 5,000,000 (no conversion)
   - USD $200 × 25,000 → 5,000,000 VND
   - Total: 10,000,000 VND (base currency)
    ↓
3. Get Previous Balance (in base currency)
   - balance_before: 0 VND
    ↓
4. Calculate New Balance (in base currency)
   - balance_after: 0 + 10,000,000 = 10,000,000 VND
    ↓
5. Create SINGLE Entry
   - entry_id: uuid-xxx
   - currency_id: vnd-uuid (base currency)
   - balance_before: 0
   - balance_after: 10,000,000
   - denomination_summary: [
       {"currency_id": "vnd", "amount": 5000000, "denominations": [...]},
       {"currency_id": "usd", "amount": 200, "denominations": [...]}
     ]
   - exchange_rates: {"vnd": 1.0, "usd": 25000}
    ↓
6. Create Denomination Lines (linked to single entry_id)
   - VND lines → entry_id: uuid-xxx
   - USD lines → entry_id: uuid-xxx (same entry!)
```

---

## 📊 Database Schema Verification

### ✅ Confirmed Fields in `cash_amount_entries`:
- `entry_id` (UUID) - Primary key
- `currency_id` (UUID) - **Base currency**
- `balance_before` (NUMERIC) - **In base currency**
- `balance_after` (NUMERIC) - **In base currency**
- `base_currency_id` (UUID) - Reference to base currency
- `exchange_rates` (JSONB) - **Exchange rates used** ✅
- `denomination_summary` (JSONB) - **Multi-currency details** ✅

---

## 🆕 New RPC Function

**File**: [INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql](INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql)

### Function Signature
```sql
CREATE OR REPLACE FUNCTION insert_amount_multi_currency(
  p_entry_type VARCHAR(20),              -- 'cash', 'vault', or 'bank'
  p_company_id UUID,
  p_location_id UUID,
  p_record_date DATE,
  p_created_by UUID,
  p_store_id UUID DEFAULT NULL,
  p_description TEXT DEFAULT NULL,
  p_currencies JSONB DEFAULT '[]'::JSONB,
  p_vault_transaction_type VARCHAR(20) DEFAULT NULL  -- 'in', 'out', 'recount'
)
RETURNS TABLE(
  entry_id UUID,
  balance_before NUMERIC,
  balance_after NUMERIC,
  total_amount_base_currency NUMERIC
)
```

### Key Features
1. ✅ **Multi-Currency Support**: Cash, Vault, Bank all support multiple currencies
2. ✅ **Single Entry**: Creates one `cash_amount_entries` record per transaction
3. ✅ **Base Currency Conversion**: Auto-converts all amounts
4. ✅ **JSONB Storage**: Preserves original currency details
5. ✅ **Vault Transaction Types**: Supports IN (debit), OUT (credit), RECOUNT (adjustment)
6. ✅ **Balance Tracking**: Always in base currency

---

## 📝 Example: Multi-Currency Cash Ending

### Input (VND + USD)
```json
{
  "p_entry_type": "cash",
  "p_company_id": "company-uuid",
  "p_location_id": "location-uuid",
  "p_record_date": "2025-11-23",
  "p_created_by": "user-uuid",
  "p_currencies": [
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-vnd-uuid", "quantity": 10},
        {"denomination_id": "200k-vnd-uuid", "quantity": 5}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "quantity": 2}
      ]
    }
  ]
}
```

### Output: Database Records

**cash_amount_entries** (1 entry):
```
entry_id          | entry_type | currency_id | balance_before | balance_after | denomination_summary (JSONB)
uuid-cash-entry-1 | cash       | vnd-uuid    | 0              | 6000000       | [{"currency_id": "vnd", ...}, {"currency_id": "usd", ...}]
```

**cashier_amount_lines** (3 lines - all linked to same entry_id):
```
line_id  | entry_id           | denomination_id  | quantity
uuid-1   | uuid-cash-entry-1  | 500k-vnd-uuid    | 10       ← VND
uuid-2   | uuid-cash-entry-1  | 200k-vnd-uuid    | 5        ← VND
uuid-3   | uuid-cash-entry-1  | 100-usd-uuid     | 2        ← USD (same entry!)
```

---

## 🚀 Benefits

### 1. Simplified Balance Tracking
- **Before**: Balance per currency (complex, multiple records)
- **After**: Single balance in base currency (simple, one record)

### 2. Multi-Currency Support for Vault
- **Before**: Vault only single currency per call
- **After**: Vault can handle VND + USD + ... in one transaction

### 3. Unified Data Model
- **Before**: Different workflows for Cash/Vault/Bank
- **After**: One RPC handles all types consistently

### 4. Easy Balance Summary
- **Before**: Sum across multiple entries per currency
- **After**: Single entry with base currency total

### 5. Currency Details Preserved
- All original currency data stored in JSONB
- Can reconstruct multi-currency breakdown anytime
- Exchange rates used are recorded

---

## ⚠️ TODO Before Deployment

### 1. Base Currency Lookup
**Current**: Uses first currency from input as fallback
**Needed**: Implement actual base currency lookup

```sql
-- Example implementation needed:
SELECT currency_id
INTO v_base_currency_id
FROM company_currency cc
JOIN currency_types ct ON ct.currency_id = cc.currency_id
WHERE cc.company_id = p_company_id
  AND ct.is_base = true
LIMIT 1;
```

### 2. Exchange Rate Lookup
**Current**: Defaults to 1.0 for all currencies
**Needed**: Implement actual exchange rate lookup

```sql
-- Example implementation needed:
SELECT exchange_rate
INTO v_exchange_rate
FROM exchange_rates
WHERE from_currency_id = v_currency_id
  AND to_currency_id = v_base_currency_id
  AND effective_date <= p_record_date
ORDER BY effective_date DESC
LIMIT 1;
```

---

## 📋 Next Steps

1. **Review RPC Function**
   - Check [INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql](INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql)
   - Verify logic matches business requirements

2. **Implement TODOs**
   - Add base currency lookup
   - Add exchange rate lookup

3. **Deploy to Supabase**
   - Copy SQL to Supabase SQL Editor
   - Execute function creation
   - Verify with `SELECT * FROM pg_proc WHERE proname = 'insert_amount_multi_currency'`

4. **Update Flutter Code**
   - Follow [RPC_MIGRATION_PLAN_2025-11-23.md](RPC_MIGRATION_PLAN_2025-11-23.md)
   - Update DTOs to use new RPC
   - Update Vault to support multi-currency

5. **Testing**
   - Test Cash with VND only
   - Test Cash with VND + USD
   - Test Vault IN with multi-currency
   - Test Vault OUT with multi-currency
   - Test Vault RECOUNT with multi-currency
   - Test Bank with multi-currency
   - Verify balance summary still works

---

## 🔗 Related Files

- ✅ [INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql](INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_2025-11-23.sql) - New RPC function
- ✅ [RPC_MIGRATION_PLAN_2025-11-23.md](RPC_MIGRATION_PLAN_2025-11-23.md) - Updated migration plan
- 📂 Flutter code updates pending (see migration plan)

---

## 💡 Key Takeaway

**"One transaction, one entry, one balance in base currency - with full multi-currency support!"**

The new architecture simplifies balance tracking while supporting complex multi-currency scenarios. All original currency details are preserved in JSONB for full traceability.
