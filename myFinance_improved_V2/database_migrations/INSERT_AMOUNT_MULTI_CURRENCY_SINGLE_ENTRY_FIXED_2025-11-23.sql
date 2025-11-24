-- ============================================================================
-- Universal Multi-Currency RPC Function (SINGLE ENTRY PER TRANSACTION)
-- ============================================================================
-- File: INSERT_AMOUNT_MULTI_CURRENCY_SINGLE_ENTRY_FIXED_2025-11-23.sql
-- Date: 2025-11-23
-- Version: V6 (Added method_type support - Stock vs Flow)
--
-- Purpose:
--   Universal RPC function that handles Cash, Vault, and Bank transactions
--   with multi-currency support in a single call.
--
-- CRITICAL FIX:
--   ✅ Fixed vault RECOUNT logic - vault_amount_line.debit/credit already contain AMOUNTS
--   ✅ System stock calculation no longer multiplies by denomination_value
--   ✅ Direct comparison: actual_stock (quantity × value) vs system_stock (SUM debit - credit)
--   ✅ Added method_type column: 'stock' for Cash/Bank/Vault RECOUNT, 'flow' for Vault IN/OUT
--
-- Key Changes from Previous Version:
--   ✅ Creates SINGLE entry per transaction (not per currency)
--   ✅ Converts all currencies to base currency for balance tracking
--   ✅ Stores multi-currency details in JSONB fields
--   ✅ Vault supports multi-currency transactions
--   ✅ Fixed RECOUNT bug where system_stock was incorrectly treated as quantity
--   ✅ Tracks method_type to distinguish Stock vs Flow methods
--
-- Architecture:
--   1. Get base currency for the company
--   2. Calculate total amount in base currency across all input currencies
--   3. Get previous balance (in base currency)
--   4. Create SINGLE entry with base currency balance_before/balance_after
--   5. Store multi-currency details in denomination_summary JSONB
--   6. Store exchange rates in exchange_rates JSONB
--   7. Create denomination lines for each currency (linked to single entry)
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
  total_amount_base_currency NUMERIC
) AS $$
DECLARE
  v_entry_id UUID;
  v_balance_before NUMERIC;
  v_balance_after NUMERIC;
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

  -- Get base currency from companies table
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
  -- Loop through all input currencies and convert to base currency

  FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
  LOOP
    v_currency_id := (v_currency_record->>'currency_id')::UUID;

    -- Get exchange rate to base currency
    IF v_currency_id = v_base_currency_id THEN
      -- Same currency, no conversion needed
      v_exchange_rate := 1.0;
    ELSE
      -- Lookup exchange rate from book_exchange_rates
      SELECT rate
      INTO v_exchange_rate
      FROM book_exchange_rates
      WHERE company_id = p_company_id
        AND from_currency_id = v_currency_id
        AND to_currency_id = v_base_currency_id
        AND rate_date <= p_record_date
      ORDER BY rate_date DESC
      LIMIT 1;

      -- If no rate found, raise exception
      IF v_exchange_rate IS NULL THEN
        RAISE EXCEPTION 'Exchange rate not found for currency % to base currency % on date %',
          v_currency_id, v_base_currency_id, p_record_date;
      END IF;
    END IF;

    -- Calculate currency total based on entry type
    v_currency_total := 0;

    CASE p_entry_type
      WHEN 'cash' THEN
        -- Cash: Stock method - sum(quantity * denomination_value)
        SELECT COALESCE(SUM(
          (denom->>'quantity')::INTEGER *
          (SELECT value FROM currency_denominations WHERE denomination_id = (denom->>'denomination_id')::UUID)
        ), 0)
        INTO v_currency_total
        FROM jsonb_array_elements(v_currency_record->'denominations') AS denom;

      WHEN 'vault' THEN
        -- Vault: ALL transaction types use quantity (Stock method)
        CASE p_vault_transaction_type
          WHEN 'in' THEN
            -- IN: quantity * denomination_value (positive)
            SELECT COALESCE(SUM(
              (denom->>'quantity')::INTEGER *
              (SELECT value FROM currency_denominations WHERE denomination_id = (denom->>'denomination_id')::UUID)
            ), 0)
            INTO v_currency_total
            FROM jsonb_array_elements(v_currency_record->'denominations') AS denom;

          WHEN 'out' THEN
            -- OUT: quantity * denomination_value (negative)
            SELECT COALESCE(SUM(
              (denom->>'quantity')::INTEGER *
              (SELECT value FROM currency_denominations WHERE denomination_id = (denom->>'denomination_id')::UUID)
            ), 0) * -1
            INTO v_currency_total
            FROM jsonb_array_elements(v_currency_record->'denominations') AS denom;

          WHEN 'recount' THEN
            -- RECOUNT: quantity * denomination_value
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
        -- Bank: Direct amount
        v_currency_total := (v_currency_record->>'total_amount')::NUMERIC;

      ELSE
        RAISE EXCEPTION 'Invalid entry type: %', p_entry_type;
    END CASE;

    -- Convert to base currency and add to total
    v_total_amount_base := v_total_amount_base + (v_currency_total * v_exchange_rate);

    -- Build denomination summary JSONB
    v_denomination_summary := v_denomination_summary || jsonb_build_object(
      'currency_id', v_currency_id,
      'amount', v_currency_total,
      'denominations', v_currency_record->'denominations'
    );

    -- Store exchange rate used
    v_exchange_rates := v_exchange_rates || jsonb_build_object(
      v_currency_id::TEXT, v_exchange_rate
    );
  END LOOP;

  -- ============================================================================
  -- Step 3: Determine method_type
  -- ============================================================================
  -- Stock Method: Cash, Bank, Vault RECOUNT (current quantity)
  -- Flow Method: Vault IN, Vault OUT (transaction amount)

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
          v_method_type := 'stock'; -- Default
      END CASE;
    ELSE
      v_method_type := 'stock'; -- Default
  END CASE;

  -- ============================================================================
  -- Step 4: Handle Vault Recount Adjustment
  -- ============================================================================
  -- For vault recount, we need to calculate the difference between system and actual

  IF p_entry_type = 'vault' AND p_vault_transaction_type = 'recount' THEN
    -- Get current system stock (previous balance_after)
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

    -- Use adjustment amount for balance calculation
    v_total_amount_base := v_adjustment_amount;
    v_transaction_type := 'recount_adj';
  ELSE
    v_transaction_type := 'normal';
  END IF;

  -- ============================================================================
  -- Step 4: Get Previous Balance (in Base Currency)
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

  -- If no previous balance, check legacy tables (fallback)
  IF v_balance_before IS NULL OR v_balance_before = 0 THEN
    -- TODO: Implement legacy fallback if needed
    v_balance_before := 0;
  END IF;

  -- ============================================================================
  -- Step 5: Calculate New Balance
  -- ============================================================================

  v_balance_after := v_balance_before + v_total_amount_base;

  -- ============================================================================
  -- Step 6: Create SINGLE Entry (Base Currency)
  -- ============================================================================

  v_entry_id := gen_random_uuid();

  INSERT INTO cash_amount_entries (
    entry_id,
    company_id,
    store_id,
    location_id,
    entry_type,
    transaction_type,
    method_type,           -- Stock or Flow
    currency_id,           -- Base currency
    balance_before,        -- In base currency
    balance_after,         -- In base currency
    total_amount,          -- Total in base currency
    base_currency_id,      -- Same as currency_id
    exchange_rates,        -- JSONB with exchange rates used
    denomination_summary,  -- JSONB with multi-currency details
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
    v_total_amount_base,
    v_base_currency_id,
    v_exchange_rates,
    v_denomination_summary,
    p_record_date,
    p_description,
    p_created_by,
    NOW()
  );

  -- ============================================================================
  -- Step 7: Create Denomination Lines (Type-Specific)
  -- ============================================================================
  -- Each currency's denominations are stored in their respective detail tables
  -- All linked to the SINGLE entry_id created above

  FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
  LOOP
    v_currency_id := (v_currency_record->>'currency_id')::UUID;

    CASE p_entry_type
      WHEN 'cash' THEN
        -- Insert into cashier_amount_lines (Stock method - quantity)
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
        -- Insert into vault_amount_line (Quantity-based method)
        FOR v_denom_record IN SELECT * FROM jsonb_array_elements(v_currency_record->'denominations')
        LOOP
          v_denom_id := (v_denom_record->>'denomination_id')::UUID;
          v_quantity := (v_denom_record->>'quantity')::INTEGER;

          -- Get denomination value
          SELECT value INTO v_denom_value
          FROM currency_denominations
          WHERE denomination_id = v_denom_id;

          CASE p_vault_transaction_type
            WHEN 'in' THEN
              -- IN: Calculate debit from quantity
              v_debit := v_quantity * v_denom_value;
              v_credit := NULL;

            WHEN 'out' THEN
              -- OUT: Calculate credit from quantity
              v_debit := NULL;
              v_credit := v_quantity * v_denom_value;

            WHEN 'recount' THEN
              -- ✅ FIXED RECOUNT LOGIC
              -- vault_amount_line stores AMOUNTS in debit/credit, not quantities!

              -- Get actual stock (quantity × value)
              v_quantity := (v_denom_record->>'quantity')::INTEGER;

              SELECT value INTO v_denom_value
              FROM currency_denominations
              WHERE denomination_id = v_denom_id;

              v_actual_stock := v_quantity * v_denom_value;

              -- Get system stock for this denomination
              -- ✅ This SUM already returns an AMOUNT (not a quantity)
              -- ✅ Do NOT multiply by denomination_value!
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

              -- ✅ Direct comparison: both are amounts
              v_adjustment_amount := v_actual_stock - v_system_stock;

              IF v_adjustment_amount > 0 THEN
                v_debit := v_adjustment_amount;
                v_credit := NULL;
              ELSIF v_adjustment_amount < 0 THEN
                v_debit := NULL;
                v_credit := ABS(v_adjustment_amount);
              ELSE
                -- No change
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
        -- Insert into bank_amount (Total amount only)
        FOR v_currency_record IN SELECT * FROM jsonb_array_elements(p_currencies)
        LOOP
          v_currency_id := (v_currency_record->>'currency_id')::UUID;
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
        END LOOP;
    END CASE;
  END LOOP;

  -- ============================================================================
  -- Step 8: Return Result
  -- ============================================================================

  RETURN QUERY SELECT
    v_entry_id,
    v_balance_before,
    v_balance_after,
    v_total_amount_base;

END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Usage Examples
-- ============================================================================

-- Example 1: Cash (Multi-Currency - VND + USD)
/*
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'cash',
  p_company_id := 'company-uuid',
  p_location_id := 'location-uuid',
  p_record_date := '2025-11-23',
  p_created_by := 'user-uuid',
  p_store_id := NULL,
  p_description := 'Cash ending - VND + USD',
  p_currencies := '[
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-uuid", "quantity": 10},
        {"denomination_id": "200k-uuid", "quantity": 5}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "quantity": 2}
      ]
    }
  ]'::JSONB
);

Result:
- Single entry created with entry_id
- balance_before/balance_after in VND (base currency)
- denomination_summary stores both VND and USD details
- cashier_amount_lines created for both VND and USD denominations
*/

-- Example 2: Vault IN (Multi-Currency) - QUANTITY-BASED
/*
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'vault',
  p_company_id := 'company-uuid',
  p_location_id := 'vault-location-uuid',
  p_record_date := '2025-11-23',
  p_created_by := 'user-uuid',
  p_description := 'Vault deposit - VND + USD',
  p_vault_transaction_type := 'in',
  p_currencies := '[
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-uuid", "quantity": 10}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "quantity": 2}
      ]
    }
  ]'::JSONB
);

✅ RPC calculates: 10 × 500,000 = 5,000,000 VND (debit)
✅ RPC calculates: 2 × 100 = 200 USD → converted to VND (debit)
*/

-- Example 3: Vault OUT (Multi-Currency) - QUANTITY-BASED
/*
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'vault',
  p_company_id := 'company-uuid',
  p_location_id := 'vault-location-uuid',
  p_record_date := '2025-11-23',
  p_created_by := 'user-uuid',
  p_description := 'Vault withdrawal - VND + USD',
  p_vault_transaction_type := 'out',
  p_currencies := '[
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-uuid", "quantity": 5}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "quantity": 1}
      ]
    }
  ]'::JSONB
);

✅ RPC calculates: 5 × 500,000 = 2,500,000 VND (credit)
✅ RPC calculates: 1 × 100 = 100 USD → converted to VND (credit)
*/

-- Example 4: Vault RECOUNT (Multi-Currency) - FIXED!
/*
SELECT * FROM insert_amount_multi_currency(
  p_entry_type := 'vault',
  p_company_id := 'company-uuid',
  p_location_id := 'vault-location-uuid',
  p_record_date := '2025-11-23',
  p_created_by := 'user-uuid',
  p_description := 'Vault recount - VND + USD',
  p_vault_transaction_type := 'recount',
  p_currencies := '[
    {
      "currency_id": "vnd-uuid",
      "denominations": [
        {"denomination_id": "500k-uuid", "quantity": 12}
      ]
    },
    {
      "currency_id": "usd-uuid",
      "denominations": [
        {"denomination_id": "100-usd-uuid", "quantity": 3}
      ]
    }
  ]'::JSONB
);

✅ RECOUNT LOGIC FIX:
- actual_stock = quantity × denomination_value (e.g., 3 × 500,000 = 1,500,000)
- system_stock = SUM(debit - credit) from vault_amount_line (e.g., 1,500,000)
- adjustment = 1,500,000 - 1,500,000 = 0
- NO MORE astronomical numbers!
*/

-- ============================================================================
-- Migration Notes
-- ============================================================================
--
-- 1. This RPC creates SINGLE entry per transaction (not per currency)
-- 2. All amounts are converted to base currency for balance tracking
-- 3. Original currency details stored in denomination_summary JSONB
-- 4. Exchange rates used stored in exchange_rates JSONB
-- 5. Denomination lines created for all currencies (linked to single entry)
-- 6. Supports Cash, Vault (IN/OUT/RECOUNT), and Bank
-- 7. Vault can handle multi-currency transactions
-- 8. Balance tracking always in base currency
-- 9. ✅ FIXED: vault_amount_line stores amounts, not quantities
--
-- ============================================================================
