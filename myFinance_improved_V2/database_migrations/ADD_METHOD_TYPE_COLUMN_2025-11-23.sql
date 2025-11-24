-- ============================================================================
-- Add method_type Column to cash_amount_entries
-- ============================================================================
-- File: ADD_METHOD_TYPE_COLUMN_2025-11-23.sql
-- Date: 2025-11-23
-- Purpose: Add method_type column to distinguish Stock vs Flow entries
--
-- Why:
--   Stock Method: Current quantity (Cash, Bank, Vault Recount)
--   Flow Method: Transaction amount (Vault IN/OUT)
--
-- This makes previous_quantity and quantity_change calculations accurate
-- ============================================================================

-- Step 1: Add column with default value
ALTER TABLE cash_amount_entries
ADD COLUMN IF NOT EXISTS method_type VARCHAR(10) DEFAULT 'stock';

-- Step 2: Add constraint
ALTER TABLE cash_amount_entries
ADD CONSTRAINT check_method_type
CHECK (method_type IN ('stock', 'flow'));

-- Step 3: Update existing data based on entry_type
UPDATE cash_amount_entries
SET method_type = 'stock'
WHERE entry_type IN ('cash', 'bank');

-- Step 4: Update vault entries based on denomination_summary
UPDATE cash_amount_entries
SET method_type = CASE
  WHEN denomination_summary IS NOT NULL
    AND denomination_summary->0->>'transaction_type' = 'recount'
  THEN 'stock'
  WHEN denomination_summary IS NOT NULL
    AND denomination_summary->0->>'transaction_type' IN ('in', 'out')
  THEN 'flow'
  ELSE 'stock'  -- Default to stock for safety
END
WHERE entry_type = 'vault';

-- Step 5: Create index for better performance (optional but recommended)
CREATE INDEX IF NOT EXISTS idx_cash_amount_entries_method_type
ON cash_amount_entries(method_type);

-- Step 6: Create composite index for common queries
CREATE INDEX IF NOT EXISTS idx_cash_amount_entries_location_method
ON cash_amount_entries(location_id, method_type, created_at DESC);

-- ============================================================================
-- Verification
-- ============================================================================

-- Check distribution of method_type
SELECT
  entry_type,
  method_type,
  COUNT(*) as count
FROM cash_amount_entries
GROUP BY entry_type, method_type
ORDER BY entry_type, method_type;

-- Sample records to verify
SELECT
  entry_id,
  entry_type,
  method_type,
  denomination_summary->0->>'transaction_type' as transaction_type,
  created_at
FROM cash_amount_entries
ORDER BY created_at DESC
LIMIT 10;

-- ============================================================================
-- Notes
-- ============================================================================
/*
Stock Method (재고 방식):
  - Cash Ending: 현재 있는 수량 입력 (10개, 5개...)
  - Bank Balance: 현재 잔액
  - Vault Recount: 재고 재확인
  - Change = Current - Previous

Flow Method (흐름 방식):
  - Vault IN: 입금 거래
  - Vault OUT: 출금 거래
  - Change = Transaction Amount (IN이면 +, OUT이면 -)
  - Previous Quantity는 의미 없음 (거래 자체가 변화량)
*/
