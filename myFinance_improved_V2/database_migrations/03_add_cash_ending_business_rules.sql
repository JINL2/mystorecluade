-- ============================================================================
-- Migration: Add Business Rules for Cash Ending Tables
-- Description: Define table-level business logic and fraud detection patterns
-- Date: 2025-01-14
-- ============================================================================

-- Delete existing business rules for cash ending tables (if any)
DELETE FROM table_business_rules
WHERE table_name IN (
  'cash_control',
  'cash_amount_stock_flow',
  'bank_amount',
  'vault_amount_line',
  'cashier_amount_lines'
);

-- ============================================================================
-- 1. cash_control (Daily Cash Ending Control)
-- ============================================================================

INSERT INTO table_business_rules (table_name, description, workflow, calculation_logic, fraud_rules) VALUES (
  'cash_control',

  'Daily cash ending control records. Stores the aggregated cash count for each location at end of day.',

  '1. User selects location and date
2. User counts denominations (recorded in cashier_amount_lines)
3. System calculates actual_amount from denomination totals
4. Record saved to cash_control
5. Stock flow updated automatically (cash_amount_stock_flow)',

  'actual_amount = SUM(denomination_value × quantity) from cashier_amount_lines
where location_id matches and record_date matches',

  '🚨 FRAUD DETECTION PATTERNS:

1. **Missing Cash Ending Records:**
   - Check for days without cash_control entries
   - Alert if store has no records for consecutive days

2. **Negative Actual Amount:**
   - actual_amount < 0 (CRITICAL)
   - This should never happen

3. **Unusually Low Cash:**
   - actual_amount significantly lower than historical average
   - May indicate cash theft or incomplete count

4. **Unusually High Cash:**
   - actual_amount significantly higher than historical average
   - May indicate unreported deposits or external cash source

5. **Same-Day Multiple Entries:**
   - Multiple cash_control records for same location and date
   - Should typically be one per day per location

QUERY EXAMPLE:
```sql
-- Find negative amounts (CRITICAL)
SELECT * FROM cash_control
WHERE actual_amount < 0
AND store_id = $store_id;

-- Find missing days (last 30 days)
SELECT generate_series(
  CURRENT_DATE - INTERVAL ''30 days'',
  CURRENT_DATE,
  ''1 day''::interval
)::date AS missing_date
WHERE NOT EXISTS (
  SELECT 1 FROM cash_control
  WHERE record_date = missing_date
  AND store_id = $store_id
);
```'
);

-- ============================================================================
-- 2. cashier_amount_lines (Denomination Details)
-- ============================================================================

INSERT INTO table_business_rules (table_name, description, workflow, calculation_logic, fraud_rules) VALUES (
  'cashier_amount_lines',

  'Individual denomination counts for cash ending. Each row represents one denomination type.',

  '1. For each denomination in the selected currency
2. User enters quantity (how many pieces)
3. System calculates: line_amount = denomination_value × quantity
4. All lines saved together
5. Sum feeds into cash_control.actual_amount',

  'line_amount = currency_denominations.value × cashier_amount_lines.quantity

Total for location/date = SUM(line_amount) across all denominations',

  '🚨 FRAUD DETECTION PATTERNS:

1. **Negative Quantities:**
   - quantity < 0 (CRITICAL)
   - Should never occur

2. **Missing Denominations:**
   - Expected denominations not present in the count
   - May indicate incomplete cash ending

3. **Unusual Quantity Patterns:**
   - Extremely high quantity of large denominations
   - Very low quantity of change denominations (unusual)

4. **Orphaned Lines:**
   - cashier_amount_lines without corresponding cash_control record
   - Data integrity issue

5. **Duplicate Entries:**
   - Same denomination_id appears twice for same location/date
   - Should be unique per denomination per ending

QUERY EXAMPLE:
```sql
-- Find negative quantities
SELECT * FROM cashier_amount_lines
WHERE quantity < 0;

-- Find missing denominations (expected but not recorded)
SELECT cd.denomination_id, cd.value
FROM currency_denominations cd
WHERE cd.currency_id = $currency_id
AND cd.is_deleted = false
AND NOT EXISTS (
  SELECT 1 FROM cashier_amount_lines cal
  WHERE cal.denomination_id = cd.denomination_id
  AND cal.location_id = $location_id
  AND cal.record_date = $record_date
);
```'
);

-- ============================================================================
-- 3. bank_amount (Bank Account Balances)
-- ============================================================================

INSERT INTO table_business_rules (table_name, description, workflow, calculation_logic, fraud_rules) VALUES (
  'bank_amount',

  'Bank account balance snapshots. Typically recorded daily or when deposits/withdrawals occur.',

  '1. User selects bank location
2. User enters current bank balance
3. Record saved with record_date (typically end-of-day)
4. Historical balances preserved for trend analysis',

  'No calculation - direct entry of bank balance.

Balance change = current_total_amount - previous_total_amount
(from previous record_date)',

  '🚨 FRAUD DETECTION PATTERNS:

1. **Extreme Negative Balance:**
   - total_amount < -1,000,000 (or company-defined threshold)
   - May indicate serious overdraft or data entry error

2. **Sudden Large Changes:**
   - Balance change > 50% from previous day
   - May indicate large unrecorded transaction

3. **Missing Bank Records:**
   - No bank_amount records for consecutive days
   - Bank balances should be monitored regularly

4. **Duplicate Entries:**
   - Multiple records for same bank location and date
   - Should typically be one per day

5. **Balance Inconsistency:**
   - Bank balance does not align with expected deposits from cash
   - Compare with cash_control deposits

QUERY EXAMPLE:
```sql
-- Find sudden large changes (>50%)
WITH balance_changes AS (
  SELECT
    bank_amount_id,
    location_id,
    record_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY location_id ORDER BY record_date) as prev_amount
  FROM bank_amount
  WHERE store_id = $store_id
)
SELECT *,
  total_amount - prev_amount as change_amount,
  ROUND((total_amount - prev_amount) * 100.0 / NULLIF(prev_amount, 0), 2) as change_pct
FROM balance_changes
WHERE ABS((total_amount - prev_amount) * 100.0 / NULLIF(prev_amount, 0)) > 50;
```'
);

-- ============================================================================
-- 4. vault_amount_line (Vault Transactions)
-- ============================================================================

INSERT INTO table_business_rules (table_name, description, workflow, calculation_logic, fraud_rules) VALUES (
  'vault_amount_line',

  'Vault deposit and withdrawal transactions. Each row is one transaction (either debit OR credit, not both).',

  '1. User initiates vault transaction (deposit or withdrawal)
2. User selects denomination (optional)
3. User enters amount:
   - debit (deposit INTO vault)
   - credit (withdrawal FROM vault)
4. Transaction recorded with record_date
5. Running balance updated in stock flow',

  'Transaction net effect:
- Deposit (debit > 0, credit = 0): Vault balance increases
- Withdrawal (credit > 0, debit = 0): Vault balance decreases

Running vault balance = previous_balance + SUM(debit) - SUM(credit)',

  '🚨 FRAUD DETECTION PATTERNS:

1. **Negative Amounts:**
   - debit < 0 OR credit < 0 (CRITICAL)
   - Should never occur

2. **Both Debit and Credit:**
   - debit > 0 AND credit > 0 in same record
   - Logic error - should be one or the other

3. **Large Withdrawals Without Deposits:**
   - High credit amounts without recent debits
   - May deplete vault balance

4. **Frequent Small Withdrawals:**
   - Many small credit transactions in short period
   - Unusual pattern, may indicate unauthorized access

5. **Vault Imbalance:**
   - Calculated vault balance becomes negative
   - Physical vault cannot have negative cash

6. **Duplicate Transactions:**
   - Same user, same amount, same time
   - May indicate accidental double-entry

QUERY EXAMPLE:
```sql
-- Find invalid records (both debit and credit)
SELECT * FROM vault_amount_line
WHERE debit > 0 AND credit > 0;

-- Find negative vault balance
WITH vault_balance AS (
  SELECT
    location_id,
    record_date,
    SUM(debit) OVER (PARTITION BY location_id ORDER BY record_date, created_at) as total_debit,
    SUM(credit) OVER (PARTITION BY location_id ORDER BY record_date, created_at) as total_credit
  FROM vault_amount_line
  WHERE store_id = $store_id
)
SELECT *, (total_debit - total_credit) as balance
FROM vault_balance
WHERE (total_debit - total_credit) < 0;
```'
);

-- ============================================================================
-- 5. cash_amount_stock_flow (Historical Cash Flow)
-- ============================================================================

INSERT INTO table_business_rules (table_name, description, workflow, calculation_logic, fraud_rules) VALUES (
  'cash_amount_stock_flow',

  'Historical cash flow records. Each row represents a cash movement at a location, showing before/after balance.',

  '1. Cash transaction occurs (cash ending, bank deposit, vault operation)
2. System automatically creates flow record:
   - Captures balance_before
   - Records flow_amount (+ for inflow, - for outflow)
   - Calculates balance_after
3. Denomination details saved as JSONB (optional)
4. Record immutable for audit trail',

  'balance_after = balance_before + flow_amount

This MUST always hold true. Any discrepancy is a data integrity issue.

Aggregate balance at any point in time:
current_balance = initial_balance + SUM(flow_amount)
where created_at <= target_datetime',

  '🚨 FRAUD DETECTION PATTERNS:

1. **Balance Calculation Mismatch (CRITICAL):**
   - balance_after ≠ balance_before + flow_amount
   - Data corruption or tampering

2. **Extreme Flow Amounts:**
   - ABS(flow_amount) > 100,000,000 (or company threshold)
   - Unusual large transaction, possible error

3. **Negative Balance After:**
   - balance_after < 0
   - Indicates overdraft or calculation error

4. **Missing Flow Records:**
   - Gaps in flow sequence
   - Compare with cash_control dates

5. **Duplicate Flows:**
   - Same flow_amount, same timestamp, same location
   - May indicate accidental duplication

6. **Balance Inconsistency Over Time:**
   - balance_before of record N ≠ balance_after of record N-1
   - Flow chain is broken

QUERY EXAMPLE:
```sql
-- Find balance calculation errors (CRITICAL)
SELECT * FROM cash_amount_stock_flow
WHERE balance_after != balance_before + flow_amount;

-- Find broken flow chain
WITH flow_chain AS (
  SELECT
    flow_id,
    cash_location_id,
    created_at,
    balance_after,
    LEAD(balance_before) OVER (PARTITION BY cash_location_id ORDER BY created_at) as next_balance_before
  FROM cash_amount_stock_flow
  WHERE store_id = $store_id
)
SELECT * FROM flow_chain
WHERE balance_after != next_balance_before
AND next_balance_before IS NOT NULL;
```'
);

-- Verify inserts
SELECT table_name, LENGTH(description) as desc_len, LENGTH(fraud_rules) as fraud_rules_len
FROM table_business_rules
WHERE table_name IN (
  'cash_control',
  'cash_amount_stock_flow',
  'bank_amount',
  'vault_amount_line',
  'cashier_amount_lines'
)
ORDER BY table_name;
