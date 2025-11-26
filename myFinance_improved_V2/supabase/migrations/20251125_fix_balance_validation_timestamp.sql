-- ============================================================================
-- Fix Balance Validation Timestamp Inconsistency
-- ============================================================================
-- Author: Claude
-- Date: 2025-11-25
--
-- Problem:
--   1. process_journal_amount_stock_flow_safe() uses system_time to calculate balance_before
--   2. validate_balance_before_insert() uses created_at to validate balance_before
--   3. When created_at != system_time (timezone bugs), validation fails
--
-- Example:
--   - Transaction A: created_at=19:38:41, system_time=12:38:44, balance_after=57,117,000
--   - Transaction B: created_at=15:34:44, system_time=15:34:44, balance_after=2,117,000
--   - New Transaction C: created_at=21:03:00
--     * Calculation uses system_time → finds B as last → balance_before=2,117,000 ✓
--     * Validation uses created_at → finds A as last → expects 57,117,000 ✗
--     * ERROR: Expected 57,117,000, got 2,117,000!
--
-- Solution:
--   Change validate_balance_before_insert() to use system_time (match calculation logic)
--
-- ============================================================================

CREATE OR REPLACE FUNCTION public.validate_balance_before_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
DECLARE
    v_last_balance NUMERIC;
BEGIN
    -- ✅ FIX: Use system_time instead of created_at to match process_journal_amount_stock_flow_safe()
    -- This ensures both triggers use the same ordering for balance continuity
    SELECT balance_after INTO v_last_balance
    FROM journal_amount_stock_flow
    WHERE cash_location_id = NEW.cash_location_id
    ORDER BY system_time DESC  -- ✅ CHANGED: created_at → system_time
    LIMIT 1
    FOR UPDATE; -- 동시성 문제 방지를 위한 락

    -- 첫 번째 트랜잭션이 아닌 경우 balance 검증
    IF v_last_balance IS NOT NULL THEN
        IF NEW.balance_before != v_last_balance THEN
            RAISE EXCEPTION 'Balance continuity error: Expected balance_before=%, got=%',
                v_last_balance, NEW.balance_before;
        END IF;
    END IF;

    -- balance_after 계산 검증
    IF NEW.balance_after != NEW.balance_before + NEW.flow_amount THEN
        RAISE EXCEPTION 'Balance calculation error: % + % should equal %, got=%',
            NEW.balance_before, NEW.flow_amount,
            NEW.balance_before + NEW.flow_amount, NEW.balance_after;
    END IF;

    RETURN NEW;
END;
$function$;

-- ============================================================================
-- Verification
-- ============================================================================
-- Run this to verify the fix works:
--
-- SELECT
--   jasf.cash_location_id,
--   cl.location_name,
--   jasf.balance_after as last_balance_by_system_time,
--   jasf.system_time
-- FROM journal_amount_stock_flow jasf
-- JOIN cash_locations cl ON jasf.cash_location_id = cl.cash_location_id
-- WHERE jasf.cash_location_id = '5da0f3bd-6384-4986-8be7-26d13a1cb9dd'
-- ORDER BY jasf.system_time DESC
-- LIMIT 1;
--
-- Expected: balance_after = 2117000 (the actual current balance)
-- ============================================================================
