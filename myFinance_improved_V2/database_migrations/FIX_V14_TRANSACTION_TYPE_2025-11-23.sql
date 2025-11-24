-- ============================================================================
-- FIX V14: Change transaction_type from 'recount' to 'normal'
-- ============================================================================
-- Date: 2025-11-23
--
-- ISSUE: Check constraint only allows: 'normal', 'recount_adjustment', 'opening_balance'
-- V14 was setting transaction_type = 'recount' which violates the constraint
--
-- FIX: Use 'normal' for RECOUNT entries
-- RECOUNT can still be identified by:
--   - method_type = 'stock'
--   - p_vault_transaction_type = 'recount' (stored in description or metadata)
--   - vault_amount_line.transaction_type = 'recount' (this is allowed)
--
-- DEPLOYMENT: Supabase Dashboard → SQL Editor → Run this query
-- ============================================================================

-- Just update the one line that sets v_transaction_type
-- Find line 312-316 in V14 and change to:

-- OLD:
--   IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
--     v_transaction_type := 'recount';
--   ELSE
--     v_transaction_type := 'normal';
--   END IF;

-- NEW:
--   -- ✅ Always use 'normal' to satisfy check constraint
--   -- RECOUNT is identified by method_type='stock' and vault_amount_line.transaction_type='recount'
--   v_transaction_type := 'normal';

-- Copy the ENTIRE V14 function from DEPLOY_INSERT_AMOUNT_MULTI_CURRENCY_V14_FIX_JSONB_ARRAY_2025-11-23.sql
-- And change ONLY line 313 from:
--   v_transaction_type := 'recount';
-- To:
--   -- transaction_type must be 'normal' (check constraint requirement)
-- And remove lines 312, 314-316 (the IF block)

-- Then run the modified function in Supabase SQL Editor
