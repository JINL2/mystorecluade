-- ============================================================================
-- DEPLOYMENT READY: Universal Multi-Currency RPC Function V13 FINAL
-- ============================================================================
-- File: DEPLOY_INSERT_AMOUNT_MULTI_CURRENCY_V13_RECOUNT_ZERO_FIX_2025-11-23.sql
-- Date: 2025-11-23
-- Version: V13 FINAL (Production Ready)
--
-- CRITICAL FIX IN V13:
--   🔥 Fixed RECOUNT with ZERO input (모든 기존 재고 초기화)
--   ✅ When user inputs 0 (no denominations), credit ALL existing stock
--   ✅ Fetch ALL existing denominations from system, not just user input
--
-- RECOUNT LOGIC:
--   입력 0원 → 모든 기존 denomination을 credit으로 차감
--   입력 > 시스템 → debit으로 추가
--   입력 < 시스템 → credit으로 차감
--
-- DEPLOYMENT INSTRUCTIONS:
--   Supabase Dashboard → SQL Editor → Paste this entire file → Run
--
-- ============================================================================

CREATE OR REPLACE FUNCTION insert_amount_multi_currency(
  p_entry_type VARCHAR(20),      -- 'cash', 'vault', or 'bank'
  p_company_id UUID,
  p_location_id UUID,
  p_record_date DATE,
  p_created_by UUID,
  p_store_id UUID DEFAULT NULL,
  p_description TEXT DEFAULT NULL,
  p_currencies JSONB DEFAULT '[]'::JSONB,
  p_vault_transaction_type VARCHAR(20) DEFAULT NULL  -- 'in', 'out', 'recount' (vault only)
)
RETURNS TABLE(
  entry_id UUID,
  balance_before NUMERIC,
  balance_after NUMERIC,
  net_cash_flow NUMERIC,
  total_amount_base_currency NUMERIC
) AS $$
DECLARE
  v_entry_id UUID;
  v_balance_before NUMERIC;
  v_balance_after NUMERIC;
  v_net_cash_flow NUMERIC;
  v_base_currency_id UUID;
  v_base_currency_code VARCHAR(10);
  v_total_amount_base NUMERIC := 0;
  v_currency_record JSONB;
  v_currency_id UUID;
  v_exchange_rate NUMERIC;
  v_currency_total NUMERIC;
  v_denomination_summary JSONB := '[]'::JSONB;
  v_exchange_rates JSONB := '{}'::JSONB;
  v_transaction_type VARCHAR(20);
  v_method_type VARCHAR(10);
  v_denom_record JSONB;
  v_denom_id UUID;
  v_quantity INTEGER;
  v_denom_value NUMERIC;
  v_debit NUMERIC;
  v_credit NUMERIC;
  v_system_stock NUMERIC;
  v_actual_stock NUMERIC;
  v_adjustment_amount NUMERIC;
  v_existing_denom RECORD;
BEGIN
  -- ============================================================================
  -- Step 1: Get Base Currency for Company
  -- ============================================================================

  SELECT base_currency_id
  INTO v_base_currency_id
  FROM companies
  WHERE company_id = p_company_id
    AND is_deleted IS NOT TRUE;

  IF v_base_currency_id IS NULL THEN
    RAISE EXCEPTION 'Base currency not found for company: %', p_company_id;
  END IF;

  -- ============================================================================
  -- Step 2: Calculate Total Amount in Base Currency
  -- ============================================================================

  FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
  LOOP
    v_currency_id := (v_currency_record->>'currency_id')::UUID;

    -- Get exchange rate to base currency
    IF v_currency_id = v_base_currency_id THEN
      v_exchange_rate := 1.0;
    ELSE
      SELECT rate
      INTO v_exchange_rate
      FROM book_exchange_rates
      WHERE company_id = p_company_id
        AND from_currency_id = v_currency_id
        AND to_currency_id = v_base_currency_id
        AND rate_date <= p_record_date
      ORDER BY rate_date DESC
      LIMIT 1;

      IF v_exchange_rate IS NULL THEN
        RAISE EXCEPTION 'Exchange rate not found for currency % to base currency % on date %',
          v_currency_id, v_base_currency_id, p_record_date;
      END IF;
    END IF;

    -- Calculate currency total based on entry type
    v_currency_total := 0;

    CASE p_entry_type
      WHEN 'cash' THEN
        SELECT COALESCE(SUM(
          (denom->>'quantity')::INTEGER *
          (SELECT value FROM currency_denominations WHERE denomination_id = (denom->>'denomination_id')::UUID)
        ), 0)
        INTO v_currency_total
        FROM jsonb_array_elements(v_currency_record->'denominations') AS denom;

      WHEN 'vault' THEN
        CASE p_vault_transaction_type
          WHEN 'in' THEN
            SELECT COALESCE(SUM(
              (denom->>'quantity')::INTEGER *
              (SELECT value FROM currency_denominations WHERE denomination_id = (denom->>'denomination_id')::UUID)
            ), 0)
            INTO v_currency_total
            FROM jsonb_array_elements(v_currency_record->'denominations') AS denom;

          WHEN 'out' THEN
            SELECT COALESCE(SUM(
              (denom->>'quantity')::INTEGER *
              (SELECT value FROM currency_denominations WHERE denomination_id = (denom->>'denomination_id')::UUID)
            ), 0) * -1
            INTO v_currency_total
            FROM jsonb_array_elements(v_currency_record->'denominations') AS denom;

          WHEN 'recount' THEN
            SELECT COALESCE(SUM(
              (denom->>'quantity')::INTEGER *
              (SELECT value FROM currency_denominations WHERE denomination_id = (denom->>'denomination_id')::UUID)
            ), 0)
            INTO v_currency_total
            FROM jsonb_array_elements(v_currency_record->'denominations') AS denom;

          ELSE
            RAISE EXCEPTION 'Invalid vault transaction type: %', p_vault_transaction_type;
        END CASE;

      WHEN 'bank' THEN
        v_currency_total := (v_currency_record->>'total_amount')::NUMERIC;

      ELSE
        RAISE EXCEPTION 'Invalid entry type: %', p_entry_type;
    END CASE;

    v_total_amount_base := v_total_amount_base + (v_currency_total * v_exchange_rate);

    v_denomination_summary := v_denomination_summary || jsonb_build_object(
      'currency_id', v_currency_id,
      'amount', v_currency_total,
      'denominations', v_currency_record->'denominations'
    );

    v_exchange_rates := v_exchange_rates || jsonb_build_object(
      v_currency_id::TEXT, v_exchange_rate
    );
  END LOOP;

  -- ============================================================================
  -- Step 3: Determine method_type
  -- ============================================================================

  CASE p_entry_type
    WHEN 'cash' THEN
      v_method_type := 'stock';
    WHEN 'bank' THEN
      v_method_type := 'stock';
    WHEN 'vault' THEN
      CASE p_vault_transaction_type
        WHEN 'recount' THEN
          v_method_type := 'stock';
        WHEN 'in', 'out' THEN
          v_method_type := 'flow';
        ELSE
          v_method_type := 'stock';
      END CASE;
    ELSE
      v_method_type := 'stock';
  END CASE;

  -- ============================================================================
  -- Step 4: Handle Vault Recount Adjustment
  -- ============================================================================

  IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
    SELECT COALESCE(cash_amount_entries.balance_after, 0)
    INTO v_system_stock
    FROM cash_amount_entries
    WHERE company_id = p_company_id
      AND location_id = p_location_id
      AND currency_id = v_base_currency_id
      AND entry_type = 'vault'
    ORDER BY record_date DESC, created_at DESC
    LIMIT 1;

    v_actual_stock := v_total_amount_base;
    v_adjustment_amount := v_actual_stock - v_system_stock;
    v_total_amount_base := v_adjustment_amount;
    v_transaction_type := 'recount_adj';
  ELSE
    v_transaction_type := 'normal';
  END IF;

  -- ============================================================================
  -- Step 5: Get Previous Balance (in Base Currency)
  -- ============================================================================

  SELECT COALESCE(cash_amount_entries.balance_after, 0)
  INTO v_balance_before
  FROM cash_amount_entries
  WHERE company_id = p_company_id
    AND location_id = p_location_id
    AND currency_id = v_base_currency_id
    AND entry_type = p_entry_type
  ORDER BY record_date DESC, created_at DESC
  LIMIT 1;

  IF v_balance_before IS NULL OR v_balance_before = 0 THEN
    v_balance_before := 0;
  END IF;

  -- ============================================================================
  -- Step 6: Calculate Balance Based on method_type
  -- ============================================================================

  IF v_method_type = 'stock' THEN
    -- STOCK 방식 - 입력한 현재 잔액이 곧 balance_after
    v_balance_after := v_total_amount_base;
    v_net_cash_flow := v_balance_after - v_balance_before;

  ELSIF v_method_type = 'flow' THEN
    -- FLOW 방식 - 증감분을 누적
    v_net_cash_flow := v_total_amount_base;
    v_balance_after := v_balance_before + v_net_cash_flow;

  ELSE
    -- Default to stock
    v_balance_after := v_total_amount_base;
    v_net_cash_flow := v_balance_after - v_balance_before;
  END IF;

  -- ============================================================================
  -- Step 7: Create SINGLE Entry (Base Currency)
  -- ============================================================================

  v_entry_id := gen_random_uuid();

  INSERT INTO cash_amount_entries (
    entry_id,
    company_id,
    store_id,
    location_id,
    entry_type,
    transaction_type,
    method_type,
    currency_id,
    balance_before,
    balance_after,
    base_currency_id,
    exchange_rates,
    denomination_summary,
    record_date,
    description,
    created_by,
    created_at
  ) VALUES (
    v_entry_id,
    p_company_id,
    p_store_id,
    p_location_id,
    p_entry_type,
    v_transaction_type,
    v_method_type,
    v_base_currency_id,
    v_balance_before,
    v_balance_after,
    v_base_currency_id,
    v_exchange_rates,
    v_denomination_summary,
    p_record_date,
    p_description,
    p_created_by,
    NOW()
  );

  -- ============================================================================
  -- Step 8: Create Denomination Lines (Type-Specific)
  -- ============================================================================

  FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
  LOOP
    v_currency_id := (v_currency_record->>'currency_id')::UUID;

    CASE p_entry_type
      WHEN 'cash' THEN
        FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
        LOOP
          v_denom_id := (v_denom_record->>'denomination_id')::UUID;
          v_quantity := (v_denom_record->>'quantity')::INTEGER;

          IF v_quantity > 0 THEN
            INSERT INTO cashier_amount_lines (
              line_id,
              company_id,
              store_id,
              location_id,
              currency_id,
              record_date,
              denomination_id,
              quantity,
              created_by,
              created_at,
              entry_id
            ) VALUES (
              gen_random_uuid(),
              p_company_id,
              p_store_id,
              p_location_id,
              v_currency_id,
              p_record_date,
              v_denom_id,
              v_quantity,
              p_created_by,
              NOW(),
              v_entry_id
            );
          END IF;
        END LOOP;

      WHEN 'vault' THEN
        IF p_vault_transaction_type = 'recount' THEN
          -- 🔥 V13 FIX: RECOUNT - Process ALL existing denominations
          -- Get all unique denominations that exist in the system for this location
          FOR v_existing_denom IN
            SELECT DISTINCT val.denomination_id, val.currency_id
            FROM vault_amount_line val
            JOIN cash_amount_entries cae ON val.entry_id = cae.entry_id
            WHERE cae.company_id = p_company_id
              AND cae.location_id = p_location_id
              AND cae.entry_type = 'vault'
          LOOP
            v_denom_id := v_existing_denom.denomination_id;
            v_currency_id := v_existing_denom.currency_id;

            -- Get current system stock for this denomination (QUANTITY)
            SELECT COALESCE(SUM(
              CASE
                WHEN transaction_type = 'normal' THEN COALESCE(debit, 0) - COALESCE(credit, 0)
                ELSE 0
              END
            ), 0)
            INTO v_system_stock
            FROM vault_amount_line
            WHERE denomination_id = v_denom_id
              AND entry_id IN (
                SELECT entry_id FROM cash_amount_entries
                WHERE company_id = p_company_id
                  AND location_id = p_location_id
                  AND entry_type = 'vault'
              );

            -- Get user input quantity for this denomination (if provided)
            v_actual_stock := 0;
            FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
            LOOP
              IF (v_currency_record->>'currency_id')::UUID = v_currency_id THEN
                FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
                LOOP
                  IF (v_denom_record->>'denomination_id')::UUID = v_denom_id THEN
                    v_actual_stock := (v_denom_record->>'quantity')::INTEGER;
                    EXIT;
                  END IF;
                END LOOP;
              END IF;
            END LOOP;

            -- Calculate adjustment
            v_adjustment_amount := v_actual_stock - v_system_stock;

            IF v_adjustment_amount > 0 THEN
              v_debit := v_adjustment_amount;
              v_credit := NULL;
            ELSIF v_adjustment_amount < 0 THEN
              v_debit := NULL;
              v_credit := ABS(v_adjustment_amount);
            ELSE
              -- No change needed for this denomination
              CONTINUE;
            END IF;

            -- Insert adjustment
            INSERT INTO vault_amount_line (
              vault_amount_id,
              company_id,
              store_id,
              location_id,
              currency_id,
              debit,
              credit,
              created_at,
              record_date,
              created_by,
              denomination_id,
              transaction_type,
              entry_id
            ) VALUES (
              gen_random_uuid(),
              p_company_id,
              p_store_id,
              p_location_id,
              v_currency_id,
              v_debit,
              v_credit,
              NOW(),
              p_record_date,
              p_created_by,
              v_denom_id,
              'recount',
              v_entry_id
            );
          END LOOP;

        ELSE
          -- IN/OUT transactions - original logic
          FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
          LOOP
            v_denom_id := (v_denom_record->>'denomination_id')::UUID;
            v_quantity := (v_denom_record->>'quantity')::INTEGER;

            CASE p_vault_transaction_type
              WHEN 'in' THEN
                v_debit := v_quantity;
                v_credit := NULL;

              WHEN 'out' THEN
                v_debit := NULL;
                v_credit := v_quantity;
            END CASE;

            IF v_debit IS NOT NULL OR v_credit IS NOT NULL THEN
              INSERT INTO vault_amount_line (
                vault_amount_id,
                company_id,
                store_id,
                location_id,
                currency_id,
                debit,
                credit,
                created_at,
                record_date,
                created_by,
                denomination_id,
                transaction_type,
                entry_id
              ) VALUES (
                gen_random_uuid(),
                p_company_id,
                p_store_id,
                p_location_id,
                v_currency_id,
                v_debit,
                v_credit,
                NOW(),
                p_record_date,
                p_created_by,
                v_denom_id,
                p_vault_transaction_type,
                v_entry_id
              );
            END IF;
          END LOOP;
        END IF;

      WHEN 'bank' THEN
        v_currency_total := (v_currency_record->>'total_amount')::NUMERIC;

        INSERT INTO bank_amount (
          bank_amount_id,
          company_id,
          store_id,
          location_id,
          currency_id,
          record_date,
          total_amount,
          created_by,
          created_at,
          entry_id
        ) VALUES (
          gen_random_uuid(),
          p_company_id,
          p_store_id,
          p_location_id,
          v_currency_id,
          p_record_date,
          v_currency_total,
          p_created_by,
          NOW(),
          v_entry_id
        );
    END CASE;
  END LOOP;

  -- ============================================================================
  -- Step 9: Return Result
  -- ============================================================================

  RETURN QUERY SELECT
    v_entry_id,
    v_balance_before,
    v_balance_after,
    v_net_cash_flow,
    v_total_amount_base;

END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- DEPLOYMENT VERIFICATION
-- ============================================================================
-- After deployment, test RECOUNT with 0 input:
-- 1. System has: VND 500,000 × 3 = 1,500,000
-- 2. User inputs: 0 (no denominations)
-- 3. Expected: Credit 3 from VND 500,000, balance_after = 0
-- ============================================================================
