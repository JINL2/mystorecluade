# Method Type Verification - How Change Data is Fetched

## Overview
`get_location_stock_flow_v2` RPC uses the `method_type` column to distinguish between two calculation methods:

### Stock Method (재고 방식)
- **Used for**: Cash, Bank, Vault Recount
- **Logic**: Previous quantity matters - calculates difference from last entry
- **Formula**: `Change = Current Quantity - Previous Quantity`
- **Example**: Cash Ending - you count 10 bills now, previously had 5 → Change = +5

### Flow Method (흐름 방식)
- **Used for**: Vault IN/OUT transactions
- **Logic**: Previous quantity doesn't matter - transaction itself is the change
- **Formula**: `Change = Transaction Amount (Current Quantity)`
- **Example**: Vault IN - deposited 3 bills → Change = +3 (previous quantity irrelevant)

---

## Implementation in get_location_stock_flow_v2

### Key Code Section (Lines 157-172)

```sql
-- ✅ METHOD-AWARE previous quantity
'previous_quantity', CASE
    -- Stock Method: Get previous stock quantity
    WHEN COALESCE(cae.method_type, 'stock') = 'stock'
    THEN COALESCE(prev.prev_quantity, 0)
    -- Flow Method: Previous is always 0 (transaction-based)
    ELSE 0
END,

-- ✅ METHOD-AWARE quantity change
'quantity_change', CASE
    -- Stock Method: Current - Previous
    WHEN COALESCE(cae.method_type, 'stock') = 'stock'
    THEN cal.quantity - COALESCE(prev.prev_quantity, 0)
    -- Flow Method: Change = Current (the transaction itself)
    ELSE cal.quantity
END,
```

---

## How It Works

### 1. Stock Method Example (Cash Ending)

**Database State:**
```sql
-- Entry 1 (Previous)
entry_id: 'e001'
method_type: 'stock'
entry_type: 'cash'
denomination_id: '10000-bill'
quantity: 5
created_at: '2025-11-22 10:00:00'

-- Entry 2 (Current)
entry_id: 'e002'
method_type: 'stock'
entry_type: 'cash'
denomination_id: '10000-bill'
quantity: 10
created_at: '2025-11-23 10:00:00'
```

**What RPC Returns for Entry 2:**
```json
{
  "denomination_id": "10000-bill",
  "denomination_value": 10000,
  "current_quantity": 10,
  "previous_quantity": 5,      // ← LATERAL JOIN found Entry 1
  "quantity_change": 5,         // ← 10 - 5 = 5
  "subtotal": 100000
}
```

**LATERAL JOIN Logic:**
```sql
LEFT JOIN LATERAL (
    SELECT prev_cal.quantity as prev_quantity
    FROM cashier_amount_lines prev_cal
    JOIN cash_amount_entries prev_cae ON prev_cal.entry_id = prev_cae.entry_id
    WHERE prev_cal.denomination_id = cal.denomination_id  -- Same denomination
      AND prev_cal.location_id = cal.location_id          -- Same location
      AND prev_cae.created_at < cae.created_at            -- Before current entry
      AND prev_cae.company_id = p_company_id
    ORDER BY prev_cae.created_at DESC
    LIMIT 1                                                -- Get most recent previous
) prev ON true
```

---

### 2. Flow Method Example (Vault IN)

**Database State:**
```sql
-- Entry 1 (Previous Vault Entry - doesn't matter)
entry_id: 'v001'
method_type: 'stock'
entry_type: 'vault'
denomination_id: '10000-bill'
quantity: 20
created_at: '2025-11-22 10:00:00'

-- Entry 2 (Current - Vault IN Transaction)
entry_id: 'v002'
method_type: 'flow'            -- ← Flow method!
entry_type: 'vault'
denomination_id: '10000-bill'
quantity: 3                     -- ← Deposited 3 bills
created_at: '2025-11-23 10:00:00'
```

**What RPC Returns for Entry 2:**
```json
{
  "denomination_id": "10000-bill",
  "denomination_value": 10000,
  "current_quantity": 3,         // ← Transaction amount
  "previous_quantity": 0,        // ← Always 0 for flow method
  "quantity_change": 3,          // ← Same as current_quantity (the deposit itself)
  "subtotal": 30000
}
```

**Why Previous = 0?**
- For transactions, we don't care about previous stock level
- The quantity field represents the transaction amount itself
- Change = the transaction amount (3 bills IN = +3 change)

---

### 3. Flow Method Example (Vault OUT)

**Database State:**
```sql
-- Entry (Vault OUT Transaction)
entry_id: 'v003'
method_type: 'flow'
entry_type: 'vault'
denomination_id: '10000-bill'
quantity: -2                    -- ← Withdrew 2 bills (negative)
created_at: '2025-11-23 12:00:00'
```

**What RPC Returns:**
```json
{
  "denomination_id": "10000-bill",
  "denomination_value": 10000,
  "current_quantity": -2,        // ← Withdrawal amount (negative)
  "previous_quantity": 0,        // ← Always 0 for flow method
  "quantity_change": -2,         // ← Same as current_quantity (the withdrawal)
  "subtotal": -20000
}
```

---

## COALESCE Safety

```sql
COALESCE(cae.method_type, 'stock') = 'stock'
```

**Why COALESCE?**
- If `method_type` column doesn't exist yet, defaults to 'stock'
- Backward compatibility during migration
- Safety: treats unknown entries as Stock Method

---

## How method_type Gets Populated

From `ADD_METHOD_TYPE_COLUMN_2025-11-23.sql`:

```sql
-- Step 3: Cash and Bank are always Stock
UPDATE cash_amount_entries
SET method_type = 'stock'
WHERE entry_type IN ('cash', 'bank');

-- Step 4: Vault entries depend on transaction_type in denomination_summary
UPDATE cash_amount_entries
SET method_type = CASE
  WHEN denomination_summary IS NOT NULL
    AND denomination_summary->0->>'transaction_type' = 'recount'
  THEN 'stock'                  -- Vault Recount = Stock method
  WHEN denomination_summary IS NOT NULL
    AND denomination_summary->0->>'transaction_type' IN ('in', 'out')
  THEN 'flow'                   -- Vault IN/OUT = Flow method
  ELSE 'stock'
END
WHERE entry_type = 'vault';
```

---

## Summary Table

| Entry Type | Method Type | Previous Qty | Change Calculation |
|------------|-------------|--------------|-------------------|
| Cash | Stock | LATERAL JOIN | Current - Previous |
| Bank | Stock | LATERAL JOIN | Current - Previous |
| Vault Recount | Stock | LATERAL JOIN | Current - Previous |
| Vault IN | Flow | Always 0 | Current (transaction amount) |
| Vault OUT | Flow | Always 0 | Current (negative transaction) |

---

## Deployment Sequence

1. **First**: Deploy `ADD_METHOD_TYPE_COLUMN_2025-11-23.sql`
   - Adds `method_type` column
   - Populates existing data
   - Creates indexes

2. **Second**: Deploy `CREATE_GET_LOCATION_STOCK_FLOW_V2_2025-11-23.sql`
   - Creates RPC function that uses `method_type`
   - Implements METHOD-AWARE logic

---

## Verification Query

After deployment, verify the logic works:

```sql
-- Check a Stock Method entry (Cash)
SELECT
  entry_id,
  entry_type,
  method_type,
  denomination_summary->0->>'denomination_value' as value,
  denomination_summary->0->>'quantity' as current_qty,
  denomination_summary->0->>'previous_quantity' as prev_qty,
  denomination_summary->0->>'quantity_change' as change
FROM cash_amount_entries
WHERE entry_type = 'cash'
  AND method_type = 'stock'
ORDER BY created_at DESC
LIMIT 5;

-- Check a Flow Method entry (Vault IN/OUT)
SELECT
  entry_id,
  entry_type,
  method_type,
  denomination_summary->0->>'transaction_type' as transaction_type,
  denomination_summary->0->>'denomination_value' as value,
  denomination_summary->0->>'quantity' as current_qty,
  denomination_summary->0->>'previous_quantity' as prev_qty,  -- Should be 0
  denomination_summary->0->>'quantity_change' as change       -- Should = current_qty
FROM cash_amount_entries
WHERE entry_type = 'vault'
  AND method_type = 'flow'
ORDER BY created_at DESC
LIMIT 5;
```

---

## ✅ Conclusion

The METHOD-AWARE logic correctly uses `method_type` to:

1. **Determine if Previous Quantity is needed**:
   - Stock: Yes, fetch via LATERAL JOIN
   - Flow: No, always 0

2. **Calculate Change correctly**:
   - Stock: Difference from previous (Current - Previous)
   - Flow: Transaction amount itself (Current)

This makes the `get_location_stock_flow_v2` RPC accurate for all entry types.
