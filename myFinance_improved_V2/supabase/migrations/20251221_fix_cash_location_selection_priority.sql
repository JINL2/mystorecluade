-- ============================================================================
-- Migration: Fix cash location selection priority
-- Purpose: User selection should override template default cash_location_id
--          ONLY for Expense + Cash templates. Other templates (Cash-Cash,
--          Cash-Vault, Debt-Cash, etc.) keep their original values.
-- Date: 2025-12-21
-- Issue: When user selects a different cash location, it was being overridden
--        by the template's saved cash_location_id due to wrong COALESCE priority.
--        Additionally, applying user selection to ALL cash lines broke
--        Cash-Cash and Cash-Vault transfers.
-- Solution: Only apply user selection for Expense + Single Cash templates.
-- ============================================================================

-- Drop existing function
DROP FUNCTION IF EXISTS create_transaction_from_template(UUID, NUMERIC, UUID, UUID, UUID, TEXT, UUID, UUID, UUID, UUID, DATE);

-- Create the function with fixed priority
CREATE OR REPLACE FUNCTION create_transaction_from_template(
  p_template_id UUID,
  p_amount NUMERIC,
  p_company_id UUID,
  p_user_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_description TEXT DEFAULT NULL,
  p_selected_cash_location_id UUID DEFAULT NULL,
  p_selected_counterparty_id UUID DEFAULT NULL,
  p_selected_counterparty_store_id UUID DEFAULT NULL,
  p_selected_counterparty_cash_location_id UUID DEFAULT NULL,
  p_entry_date DATE DEFAULT CURRENT_DATE
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_template RECORD;
  v_data JSONB;
  v_entry JSONB;
  v_lines JSONB := '[]'::JSONB;
  v_line JSONB;

  -- Template defaults (extracted from template data)
  v_template_cash_location_id UUID;
  v_template_counterparty_id UUID;
  v_template_counterparty_store_id UUID;
  v_template_counterparty_cash_location_id UUID;

  -- Final resolved values (user selection > template default)
  v_cash_location_id UUID;
  v_counterparty_id UUID;
  v_counterparty_store_id UUID;
  v_counterparty_cash_location_id UUID;

  v_is_internal BOOLEAN := FALSE;
  v_linked_company_id UUID;
  v_debt_account_id UUID;

  -- Template type detection
  v_has_expense BOOLEAN := FALSE;
  v_cash_entry_count INT := 0;
  v_is_expense_cash_template BOOLEAN := FALSE;

  -- Result
  v_journal_id UUID;
  v_entry_date_utc TIMESTAMPTZ;
BEGIN
  -- ═══════════════════════════════════════════════════════
  -- 1. BASIC VALIDATION
  -- ═══════════════════════════════════════════════════════

  -- Amount validation
  IF p_amount IS NULL OR p_amount <= 0 THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'validation_error',
      'message', 'Amount must be greater than 0',
      'field', 'amount'
    );
  END IF;

  -- Get template
  SELECT * INTO v_template
  FROM transaction_templates
  WHERE template_id = p_template_id
    AND company_id = p_company_id
    AND is_active = TRUE;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'not_found',
      'message', 'Template not found or inactive'
    );
  END IF;

  v_data := v_template.data;
  v_entry_date_utc := p_entry_date::TIMESTAMPTZ;

  -- ═══════════════════════════════════════════════════════
  -- 2. ANALYZE TEMPLATE TYPE & EXTRACT DEFAULTS
  -- ═══════════════════════════════════════════════════════

  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    -- Count cash entries and extract first cash_location_id
    IF v_entry->>'category_tag' IN ('cash', 'bank') THEN
      v_cash_entry_count := v_cash_entry_count + 1;
      IF v_template_cash_location_id IS NULL THEN
        v_template_cash_location_id := NULLIF(v_entry->>'cash_location_id', '')::UUID;
      END IF;
    END IF;

    -- Check for expense account (code 5000-9999)
    IF v_entry->>'account_code' IS NOT NULL THEN
      DECLARE
        v_code INT;
      BEGIN
        v_code := (v_entry->>'account_code')::INT;
        IF v_code >= 5000 AND v_code <= 9999 THEN
          v_has_expense := TRUE;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        NULL;
      END;
    END IF;

    -- Counterparty defaults (receivable/payable)
    IF v_entry->>'category_tag' IN ('receivable', 'payable') THEN
      -- Save debt account_id for account_mapping check
      IF v_debt_account_id IS NULL THEN
        v_debt_account_id := NULLIF(v_entry->>'account_id', '')::UUID;
      END IF;

      IF v_template_counterparty_id IS NULL THEN
        v_template_counterparty_id := COALESCE(
          NULLIF(v_entry->>'counterparty_id', '')::UUID,
          v_template.counterparty_id
        );
      END IF;
      IF v_template_counterparty_store_id IS NULL THEN
        v_template_counterparty_store_id := NULLIF(v_entry->>'counterparty_store_id', '')::UUID;
      END IF;
      IF v_template_counterparty_cash_location_id IS NULL THEN
        v_template_counterparty_cash_location_id := COALESCE(
          NULLIF(v_entry->>'counterparty_cash_location_id', '')::UUID,
          v_template.counterparty_cash_location_id
        );
      END IF;

      -- Check if internal from entry
      IF v_entry->>'linked_company_id' IS NOT NULL AND v_entry->>'linked_company_id' != '' THEN
        v_is_internal := TRUE;
        v_linked_company_id := (v_entry->>'linked_company_id')::UUID;
      END IF;
    END IF;
  END LOOP;

  -- ═══════════════════════════════════════════════════════
  -- 3. DETERMINE TEMPLATE TYPE
  -- ═══════════════════════════════════════════════════════

  -- KEY LOGIC: Only Expense + Single Cash = use user selection
  -- All other cases (Cash-Cash, Cash-Vault, Debt-Cash, etc.) = use template values
  v_is_expense_cash_template := (v_has_expense AND v_cash_entry_count = 1);

  -- ═══════════════════════════════════════════════════════
  -- 4. RESOLVE FINAL VALUES (User Selection > Template Default)
  -- ═══════════════════════════════════════════════════════

  -- Cash location: Only use user selection for Expense+Cash templates
  IF v_is_expense_cash_template THEN
    v_cash_location_id := COALESCE(p_selected_cash_location_id, v_template_cash_location_id);
  ELSE
    -- For other templates, v_cash_location_id is not used (each entry keeps its own)
    v_cash_location_id := v_template_cash_location_id;
  END IF;

  -- Counterparty: User selection takes priority
  v_counterparty_id := COALESCE(p_selected_counterparty_id, v_template_counterparty_id);

  -- Counterparty store: User selection takes priority
  v_counterparty_store_id := COALESCE(p_selected_counterparty_store_id, v_template_counterparty_store_id);

  -- Counterparty cash location: User selection takes priority
  v_counterparty_cash_location_id := COALESCE(p_selected_counterparty_cash_location_id, v_template_counterparty_cash_location_id);

  -- Check internal from counterparties table (if counterparty changed or not yet checked)
  IF v_counterparty_id IS NOT NULL THEN
    SELECT c.linked_company_id INTO v_linked_company_id
    FROM counterparties c
    WHERE c.counterparty_id = v_counterparty_id
      AND c.is_deleted = FALSE;

    v_is_internal := (v_linked_company_id IS NOT NULL);
  END IF;

  -- ═══════════════════════════════════════════════════════
  -- 5. VALIDATION - Required fields based on template type
  -- ═══════════════════════════════════════════════════════

  -- Check cash location for expense + cash templates
  IF v_is_expense_cash_template AND v_cash_location_id IS NULL THEN
    RETURN json_build_object(
      'success', FALSE,
      'error', 'validation_error',
      'message', 'Cash location is required for expense transactions',
      'field', 'cash_location'
    );
  END IF;

  -- Check counterparty for receivable/payable
  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    IF v_entry->>'category_tag' IN ('receivable', 'payable') THEN
      -- External counterparty: need counterparty_id
      IF NOT v_is_internal AND v_counterparty_id IS NULL THEN
        RETURN json_build_object(
          'success', FALSE,
          'error', 'validation_error',
          'message', 'Counterparty is required',
          'field', 'counterparty'
        );
      END IF;

      -- Internal counterparty: Additional validations
      IF v_is_internal THEN
        -- 1. Check counterparty_store_id
        IF v_counterparty_store_id IS NULL THEN
          RETURN json_build_object(
            'success', FALSE,
            'error', 'validation_error',
            'message', 'Counterparty store is required for internal transfers',
            'field', 'counterparty_store'
          );
        END IF;

        -- 2. Check counterparty_cash_location_id
        IF v_counterparty_cash_location_id IS NULL THEN
          RETURN json_build_object(
            'success', FALSE,
            'error', 'validation_error',
            'message', 'Counterparty cash location is required for internal transfers',
            'field', 'counterparty_cash_location'
          );
        END IF;

        -- 3. Check account_mapping exists (CRITICAL for mirror journal!)
        IF NOT EXISTS (
          SELECT 1 FROM account_mappings
          WHERE my_company_id = p_company_id
            AND counterparty_id = v_counterparty_id
            AND my_account_id = v_debt_account_id
            AND is_deleted = FALSE
        ) THEN
          RETURN json_build_object(
            'success', FALSE,
            'error', 'account_mapping_required',
            'message', 'Account mapping is required for internal counterparty. Please set up account mapping in Counter Party > Account Settings.',
            'field', 'account_mapping'
          );
        END IF;
      END IF;
      EXIT; -- Only need to check once
    END IF;
  END LOOP;

  -- ═══════════════════════════════════════════════════════
  -- 6. BUILD TRANSACTION LINES
  -- ═══════════════════════════════════════════════════════

  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    -- Base line structure
    v_line := jsonb_build_object(
      'account_id', v_entry->>'account_id',
      'description', COALESCE(p_description, v_entry->>'description')
    );

    -- Set debit/credit based on type (as STRING - RPC requirement!)
    IF v_entry->>'type' = 'debit' THEN
      v_line := v_line || jsonb_build_object(
        'debit', p_amount::TEXT,
        'credit', '0'
      );
    ELSE
      v_line := v_line || jsonb_build_object(
        'debit', '0',
        'credit', p_amount::TEXT
      );
    END IF;

    -- Add cash object for cash/bank accounts
    IF v_entry->>'category_tag' IN ('cash', 'bank') THEN
      IF v_is_expense_cash_template THEN
        -- Expense + Cash: use user selection (stored in v_cash_location_id)
        IF v_cash_location_id IS NOT NULL THEN
          v_line := v_line || jsonb_build_object(
            'cash', jsonb_build_object('cash_location_id', v_cash_location_id)
          );
        END IF;
      ELSE
        -- All other cases (Cash-Cash, Cash-Vault, Debt-Cash, etc.):
        -- Use each entry's own cash_location_id from template
        DECLARE
          v_entry_cash_location_id UUID;
        BEGIN
          v_entry_cash_location_id := NULLIF(v_entry->>'cash_location_id', '')::UUID;
          IF v_entry_cash_location_id IS NOT NULL THEN
            v_line := v_line || jsonb_build_object(
              'cash', jsonb_build_object('cash_location_id', v_entry_cash_location_id)
            );
          END IF;
        END;
      END IF;
    END IF;

    -- Add debt object for receivable/payable
    IF v_entry->>'category_tag' IN ('receivable', 'payable') AND v_counterparty_id IS NOT NULL THEN
      -- Build debt object with internal counterparty fields if applicable
      IF v_is_internal THEN
        v_line := v_line || jsonb_build_object(
          'debt', jsonb_build_object(
            'counterparty_id', v_counterparty_id,
            'direction', v_entry->>'category_tag',
            'category', COALESCE(v_entry->'debt'->>'category', 'account'),
            'issue_date', TO_CHAR(v_entry_date_utc, 'YYYY-MM-DD'),
            'linkedCounterparty_store_id', v_counterparty_store_id,
            'linkedCounterparty_companyId', v_linked_company_id
          )
        );
      ELSE
        v_line := v_line || jsonb_build_object(
          'debt', jsonb_build_object(
            'counterparty_id', v_counterparty_id,
            'direction', v_entry->>'category_tag',
            'category', COALESCE(v_entry->'debt'->>'category', 'account'),
            'issue_date', TO_CHAR(v_entry_date_utc, 'YYYY-MM-DD')
          )
        );
      END IF;
    END IF;

    v_lines := v_lines || v_line;
  END LOOP;

  -- ═══════════════════════════════════════════════════════
  -- 7. CALL insert_journal_with_everything_utc
  -- ═══════════════════════════════════════════════════════

  v_journal_id := insert_journal_with_everything_utc(
    p_base_amount := p_amount,
    p_company_id := p_company_id,
    p_created_by := p_user_id,
    p_description := p_description,
    p_entry_date_utc := v_entry_date_utc,
    p_lines := v_lines,
    p_counterparty_id := v_counterparty_id::TEXT,
    p_if_cash_location_id := v_counterparty_cash_location_id::TEXT,
    p_store_id := p_store_id::TEXT
  );

  -- ═══════════════════════════════════════════════════════
  -- 8. RETURN SUCCESS
  -- ═══════════════════════════════════════════════════════

  RETURN json_build_object(
    'success', TRUE,
    'journal_id', v_journal_id,
    'message', 'Transaction created successfully'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', FALSE,
    'error', 'database_error',
    'message', SQLERRM
  );
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION create_transaction_from_template(UUID, NUMERIC, UUID, UUID, UUID, TEXT, UUID, UUID, UUID, UUID, DATE) TO authenticated;

-- Add comment
COMMENT ON FUNCTION create_transaction_from_template IS
'Creates a transaction from a template with full validation.

FIXED (2025-12-21): Cash location selection priority
- Expense + Cash templates: User selection overrides template default
- Cash-Cash, Cash-Vault, Debt-Cash, etc.: Each entry keeps its own cash_location_id from template

Validates: amount, counterparty, cash_location, internal counterparty requirements.
Calls insert_journal_with_everything_utc internally for atomic transaction creation.
Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md Section 3.2';
