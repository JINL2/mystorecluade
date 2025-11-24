-- ============================================================================
-- MIGRATION: Rename total_amount to net_cash_flow
-- ============================================================================
-- File: RENAME_TOTAL_AMOUNT_TO_NET_CASH_FLOW_2025-11-23.sql
-- Date: 2025-11-23
--
-- PURPOSE:
--   The column 'total_amount' in cash_amount_entries was misnamed.
--   It actually stores the NET CASH FLOW (change in balance), not total amount.
--
-- STOCK vs FLOW:
--   - STOCK method: balance_after = current stock (입력한 현재 잔액)
--   - net_cash_flow = balance_after - balance_before (증감분)
--
-- EXAMPLE:
--   Day 1: Cash = 14,667,398
--     balance_before: 0
--     balance_after: 14,667,398
--     net_cash_flow: 14,667,398 (증가)
--
--   Day 2: Cash = 14,667,398 (same amount)
--     balance_before: 14,667,398
--     balance_after: 14,667,398
--     net_cash_flow: 0 (변동 없음)
--
--   Day 3: Cash = 20,000,000
--     balance_before: 14,667,398
--     balance_after: 20,000,000
--     net_cash_flow: 5,332,602 (증가)
--
-- DEPLOYMENT:
--   Supabase Dashboard → SQL Editor → Paste and Run
-- ============================================================================

-- Rename the column
ALTER TABLE cash_amount_entries
RENAME COLUMN total_amount TO net_cash_flow;

-- Add a comment to the column
COMMENT ON COLUMN cash_amount_entries.net_cash_flow IS
'Net cash flow (증감분): balance_after - balance_before. For STOCK method, this is calculated. For FLOW method, this is the input amount.';

-- Verify the change
SELECT
  column_name,
  data_type,
  is_nullable,
  column_default,
  col_description('cash_amount_entries'::regclass, ordinal_position) as column_comment
FROM information_schema.columns
WHERE table_name = 'cash_amount_entries'
  AND column_name = 'net_cash_flow';
