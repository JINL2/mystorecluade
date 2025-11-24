-- ============================================================================
-- DEPLOYMENT READY: Universal Multi-Currency RPC Function V14 FINAL
-- ============================================================================
-- File: DEPLOY_INSERT_AMOUNT_MULTI_CURRENCY_V14_FIX_JSONB_ARRAY_2025-11-23.sql
-- Date: 2025-11-23
-- Version: V14 FINAL (Production Ready)
--
-- CRITICAL FIX IN V14:
--   🔥 Fixed JSONB array manipulation error in FLOW method
--   ❌ Old: v_stock_array := v_stock_array - v_previous_stock_denom;
--   ✅ New: Use jsonb_agg with filtering to rebuild array
--
-- ISSUE FIXED:
--   PostgreSQL error: operator does not exist: jsonb - jsonb
--   The minus operator works for removing keys from objects, NOT array elements
--
-- DEPLOYMENT INSTRUCTIONS:
--   Supabase Dashboard → SQL Editor → Paste this entire file → Run
--
-- ============================================================================

CREATE OR REPLACE FUNCTION insert_amount_multi_currency(
  p_entry_type VARCHAR(20),
  p_company_id UUID,
  p_location_id UUID,
  p_record_date DATE,
  p_created_by UUID,
  p_store_id UUID DEFAULT NULL,
  p_description TEXT DEFAULT NULL,
  p_currencies JSONB DEFAULT '[]'::JSONB,
  p_vault_transaction_type VARCHAR(20) DEFAULT NULL
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
  v_current_stock_snapshot JSONB := '{"denominations": []}'::JSONB;
  v_stock_array JSONB := '[]'::JSONB;
  v_previous_snapshot JSONB;
  v_previous_stock_denom JSONB;
  v_previous_qty INTEGER;
  v_new_qty INTEGER;
  v_diff_qty INTEGER;
  v_temp_array JSONB; -- ✅ NEW: temporary array for filtering
BEGIN
  -- ============================================================================
  -- Step 1: Get Base Currency
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
  -- Step 2: Calculate Total Amount
  -- ============================================================================

  FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
  LOOP
    v_currency_id := (v_currency_record->>'currency_id')::UUID;

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
  -- Step 4: Get Previous Balance and Snapshot
  -- ============================================================================

  SELECT
    COALESCE(cae.balance_after, 0),
    COALESCE(cae.current_stock_snapshot, '{"denominations": []}'::JSONB)
  INTO v_balance_before, v_previous_snapshot
  FROM cash_amount_entries cae
  WHERE cae.company_id = p_company_id
    AND cae.location_id = p_location_id
    AND cae.currency_id = v_base_currency_id
    AND cae.entry_type = p_entry_type
  ORDER BY cae.record_date DESC, cae.created_at DESC
  LIMIT 1;

  IF v_balance_before IS NULL THEN
    v_balance_before := 0;
    v_previous_snapshot := '{"denominations": []}'::JSONB;
  END IF;

  -- ============================================================================
  -- Step 5: Calculate Balance and Build Stock Snapshot
  -- ============================================================================

  IF v_method_type = 'stock' THEN
    -- STOCK 방식 - 입력한 현재 잔액이 곧 balance_after
    v_balance_after := v_total_amount_base;
    v_net_cash_flow := v_balance_after - v_balance_before;

    FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
    LOOP
      v_currency_id := (v_currency_record->>'currency_id')::UUID;

      FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
      LOOP
        v_denom_id := (v_denom_record->>'denomination_id')::UUID;
        v_quantity := (v_denom_record->>'quantity')::INTEGER;

        SELECT value INTO v_denom_value
        FROM currency_denominations
        WHERE denomination_id = v_denom_id;

        v_stock_array := v_stock_array || jsonb_build_object(
          'denomination_id', v_denom_id,
          'currency_id', v_currency_id,
          'quantity', v_quantity,
          'value', v_denom_value
        );
      END LOOP;
    END LOOP;

    v_current_stock_snapshot := jsonb_build_object('denominations', v_stock_array);

  ELSIF v_method_type = 'flow' THEN
    -- FLOW 방식 - 증감분을 누적
    v_net_cash_flow := v_total_amount_base;
    v_balance_after := v_balance_before + v_net_cash_flow;

    v_stock_array := v_previous_snapshot->'denominations';

    FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
    LOOP
      v_currency_id := (v_currency_record->>'currency_id')::UUID;

      FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
      LOOP
        v_denom_id := (v_denom_record->>'denomination_id')::UUID;
        v_quantity := (v_denom_record->>'quantity')::INTEGER;

        -- Find previous quantity for this denomination
        v_previous_qty := 0;
        FOR v_previous_stock_denom IN SELECT * FROM jsonb_array_elements(v_stock_array)
        LOOP
          IF (v_previous_stock_denom->>'denomination_id')::UUID = v_denom_id THEN
            v_previous_qty := (v_previous_stock_denom->>'quantity')::INTEGER;

            -- ✅ FIX: Remove element by filtering and rebuilding array
            SELECT COALESCE(jsonb_agg(elem), '[]'::JSONB)
            INTO v_temp_array
            FROM jsonb_array_elements(v_stock_array) elem
            WHERE (elem->>'denomination_id')::UUID != v_denom_id;

            v_stock_array := v_temp_array;
            EXIT;
          END IF;
        END LOOP;

        -- Calculate new quantity based on transaction type
        IF p_vault_transaction_type = 'in' THEN
          v_new_qty := v_previous_qty + v_quantity;
        ELSIF p_vault_transaction_type = 'out' THEN
          v_new_qty := v_previous_qty - v_quantity;
        ELSE
          v_new_qty := v_previous_qty;
        END IF;

        SELECT value INTO v_denom_value
        FROM currency_denominations
        WHERE denomination_id = v_denom_id;

        -- Add updated denomination back to array
        v_stock_array := v_stock_array || jsonb_build_object(
          'denomination_id', v_denom_id,
          'currency_id', v_currency_id,
          'quantity', v_new_qty,
          'value', v_denom_value
        );
      END LOOP;
    END LOOP;

    v_current_stock_snapshot := jsonb_build_object('denominations', v_stock_array);
  END IF;

  -- ============================================================================
  -- Step 6: Handle Vault RECOUNT
  -- ============================================================================

  IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
    v_transaction_type := 'recount';
  ELSE
    v_transaction_type := 'normal';
  END IF;

  -- ============================================================================
  -- Step 7: Create Entry
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
    current_stock_snapshot,
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
    v_current_stock_snapshot,
    p_record_date,
    p_description,
    p_created_by,
    NOW()
  );

  -- ============================================================================
  -- Step 8: Create Denomination Lines
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
          -- RECOUNT: Calculate difference from previous snapshot
          FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
          LOOP
            v_denom_id := (v_denom_record->>'denomination_id')::UUID;
            v_new_qty := (v_denom_record->>'quantity')::INTEGER;

            -- Find previous quantity
            v_previous_qty := 0;
            FOR v_previous_stock_denom IN SELECT * FROM jsonb_array_elements(v_previous_snapshot->'denominations')
            LOOP
              IF (v_previous_stock_denom->>'denomination_id')::UUID = v_denom_id THEN
                v_previous_qty := (v_previous_stock_denom->>'quantity')::INTEGER;
                EXIT;
              END IF;
            END LOOP;

            v_diff_qty := v_new_qty - v_previous_qty;

            IF v_diff_qty > 0 THEN
              v_debit := v_diff_qty;
              v_credit := NULL;
            ELSIF v_diff_qty < 0 THEN
              v_debit := NULL;
              v_credit := ABS(v_diff_qty);
            ELSE
              CONTINUE;
            END IF;

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
          -- IN/OUT: Direct debit/credit
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
-- After deployment, test:
-- 1. Vault IN transaction (should work now)
-- 2. Vault OUT transaction (should work now)
-- 3. Vault RECOUNT with 0 input (should work)
-- ============================================================================
