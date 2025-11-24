-- ============================================================================
-- DEPLOYMENT READY: Universal Multi-Currency RPC Function V11 FINAL
-- ============================================================================
-- File: DEPLOY_INSERT_AMOUNT_MULTI_CURRENCY_V11_FINAL_2025-11-23.sql
-- Date: 2025-11-23
-- Version: V11 FINAL (Production Ready)
--
-- CRITICAL FIX IN V11:
--   🔥 Removed net_cash_flow from INSERT statement
--   ✅ net_cash_flow is GENERATED ALWAYS column (balance_after - balance_before)
--   ✅ PostgreSQL calculates it automatically - we CANNOT insert into it!
--
-- FIXES FROM V10:
--   ✅ Removed net_cash_flow from INSERT column list
--   ✅ Removed v_net_cash_flow from INSERT VALUES
--   ✅ Let PostgreSQL generate net_cash_flow automatically
--
-- FIXES FROM V9:
--   ✅ Fixed STOCK balance calculation logic
--   ✅ STOCK: balance_after = total_amount (현재 잔액 그대로)
--   ✅ FLOW: balance_after = balance_before + net_flow (증감 누적)
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

  -- 🔥 V11 FIX: Removed net_cash_flow from INSERT
  -- It's a GENERATED ALWAYS column - PostgreSQL calculates it automatically!
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
        FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
        LOOP
          v_denom_id := (v_denom_record->>'denomination_id')::UUID;
          v_quantity := (v_denom_record->>'quantity')::INTEGER;

          SELECT value INTO v_denom_value
          FROM currency_denominations
          WHERE denomination_id = v_denom_id;

          CASE p_vault_transaction_type
            WHEN 'in' THEN
              v_debit := v_quantity * v_denom_value;
              v_credit := NULL;

            WHEN 'out' THEN
              v_debit := NULL;
              v_credit := v_quantity * v_denom_value;

            WHEN 'recount' THEN
              v_quantity := (v_denom_record->>'quantity')::INTEGER;

              SELECT value INTO v_denom_value
              FROM currency_denominations
              WHERE denomination_id = v_denom_id;

              v_actual_stock := v_quantity * v_denom_value;

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

              v_adjustment_amount := v_actual_stock - v_system_stock;

              IF v_adjustment_amount > 0 THEN
                v_debit := v_adjustment_amount;
                v_credit := NULL;
              ELSIF v_adjustment_amount < 0 THEN
                v_debit := NULL;
                v_credit := ABS(v_adjustment_amount);
              ELSE
                CONTINUE;
              END IF;
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
              v_transaction_type,
              v_entry_id
            );
          END IF;
        END LOOP;

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
-- After deployment, verify the function exists:
-- SELECT routine_name FROM information_schema.routines
-- WHERE routine_name = 'insert_amount_multi_currency';
--
-- Test with a simple query to ensure it compiles correctly:
-- SELECT * FROM insert_amount_multi_currency(
--   p_entry_type := 'cash',
--   p_company_id := 'your-company-id',
--   p_location_id := 'your-location-id',
--   p_record_date := CURRENT_DATE,
--   p_created_by := 'your-user-id',
--   p_currencies := '[]'::JSONB
-- );
-- ============================================================================
