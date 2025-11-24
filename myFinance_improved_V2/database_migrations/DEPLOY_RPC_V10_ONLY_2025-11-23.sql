-- ============================================================================
-- DEPLOYMENT: RPC V10 ONLY (Column already renamed to net_cash_flow)
-- ============================================================================
-- File: DEPLOY_RPC_V10_ONLY_2025-11-23.sql
-- Date: 2025-11-23
--
-- PREREQUISITE:
--   ✅ Column already renamed: total_amount → net_cash_flow
--
-- CRITICAL FIX IN V10:
--   🔥 Fixed Vault RECOUNT logic - convert flow (debit/credit) to stock
--   ✅ System Stock = SUM(debit - credit) WHERE transaction_type = 'normal'
--   ✅ Balance After = Actual Stock (입력값)
--   ✅ Net Cash Flow = Adjustment (차이)
--
-- DEPLOYMENT:
--   Supabase Dashboard → SQL Editor → Paste entire file → Run
-- ============================================================================

-- ============================================================================
-- STEP 1: Drop Existing Function
-- ============================================================================

DROP FUNCTION IF EXISTS insert_amount_multi_currency(
  VARCHAR(20),
  UUID,
  UUID,
  DATE,
  UUID,
  UUID,
  TEXT,
  JSONB,
  VARCHAR(20)
);

-- ============================================================================
-- STEP 2: Create V10 RPC Function
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
  -- Step 4: Handle Vault Recount - Calculate System Stock from FLOW data
  -- ============================================================================

  IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
    -- 🔥 V10 FIX: Calculate System Stock from vault_amount_line (debit - credit)
    -- Vault stores FLOW data, need to convert to STOCK for comparison
    SELECT COALESCE(SUM(
      COALESCE(debit, 0) - COALESCE(credit, 0)
    ), 0)
    INTO v_system_stock
    FROM vault_amount_line
    WHERE location_id = p_location_id
      AND company_id = p_company_id
      AND transaction_type = 'normal';  -- Exclude previous recount_adj

    -- Actual Stock = user input (v_total_amount_base remains unchanged!)
    v_actual_stock := v_total_amount_base;

    -- Calculate adjustment
    v_adjustment_amount := v_actual_stock - v_system_stock;

    v_transaction_type := 'recount_adj';

    -- ✅ DO NOT overwrite v_total_amount_base!
    -- It will be used as balance_after in Step 6

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

  IF v_balance_before IS NULL THEN
    v_balance_before := 0;
  END IF;

  -- ============================================================================
  -- Step 6: Calculate Balance Based on method_type and transaction
  -- ============================================================================

  IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
    -- 🔥 V10 FIX: Vault RECOUNT special logic
    v_balance_after := v_total_amount_base;  -- Actual Stock (user input)
    v_net_cash_flow := v_adjustment_amount;  -- Adjustment (difference)

  ELSIF v_method_type = 'stock' THEN
    -- Regular STOCK method (Cash, Bank)
    v_balance_after := v_total_amount_base;
    v_net_cash_flow := v_balance_after - v_balance_before;

  ELSIF v_method_type = 'flow' THEN
    -- FLOW method (Vault IN/OUT)
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
    net_cash_flow,
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
    v_net_cash_flow,
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
              -- 🔥 V10 FIX: Calculate per-denomination adjustment
              v_quantity := (v_denom_record->>'quantity')::INTEGER;

              SELECT value INTO v_denom_value
              FROM currency_denominations
              WHERE denomination_id = v_denom_id;

              -- Actual stock for this denomination
              v_actual_stock := v_quantity * v_denom_value;

              -- System stock for this denomination (SUM of debit - credit)
              SELECT COALESCE(SUM(
                COALESCE(debit, 0) - COALESCE(credit, 0)
              ), 0)
              INTO v_system_stock
              FROM vault_amount_line
              WHERE denomination_id = v_denom_id
                AND location_id = p_location_id
                AND company_id = p_company_id
                AND transaction_type = 'normal';  -- Exclude recount_adj

              -- Calculate adjustment for this denomination
              v_adjustment_amount := v_actual_stock - v_system_stock;

              IF v_adjustment_amount > 0 THEN
                v_debit := v_adjustment_amount;
                v_credit := NULL;
              ELSIF v_adjustment_amount < 0 THEN
                v_debit := NULL;
                v_credit := ABS(v_adjustment_amount);
              ELSE
                CONTINUE;  -- No adjustment needed
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
SELECT
  routine_name,
  routine_type
FROM information_schema.routines
WHERE routine_name = 'insert_amount_multi_currency';
-- ============================================================================
