-- ============================================================================
-- Migration: get_template_for_usage RPC
-- Purpose: Analyze template and return UI configuration for template usage modal
-- Date: 2025-12-19
-- Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md Section 3.1
-- ============================================================================

-- Drop existing function if exists
DROP FUNCTION IF EXISTS get_template_for_usage(UUID, UUID, UUID);

-- Create the function
CREATE OR REPLACE FUNCTION get_template_for_usage(
  p_template_id UUID,
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_template RECORD;
  v_data JSONB;
  v_tags JSONB;
  v_entry JSONB;

  -- Analysis variables
  v_has_expense_account BOOLEAN := FALSE;
  v_has_cash_account BOOLEAN := FALSE;
  v_has_receivable_payable BOOLEAN := FALSE;
  v_is_internal_counterparty BOOLEAN := FALSE;
  v_has_counterparty BOOLEAN := FALSE;
  v_has_counterparty_store BOOLEAN := FALSE;
  v_has_counterparty_cash_location BOOLEAN := FALSE;

  -- UI config
  v_show_cash_location BOOLEAN := FALSE;
  v_show_counterparty BOOLEAN := FALSE;
  v_show_counterparty_store BOOLEAN := FALSE;
  v_show_counterparty_cash_location BOOLEAN := FALSE;
  v_counterparty_locked BOOLEAN := FALSE;

  -- Defaults
  v_default_cash_location_id UUID;
  v_default_cash_location_name TEXT;
  v_default_counterparty_id UUID;
  v_default_counterparty_name TEXT;
  v_default_counterparty_store_id UUID;
  v_default_counterparty_store_name TEXT;
  v_default_counterparty_cash_location_id UUID;
  v_linked_company_id UUID;

  -- Display
  v_debit_category TEXT;
  v_credit_category TEXT;

  -- Result
  v_missing_items TEXT[] := ARRAY[]::TEXT[];
  v_complexity TEXT := 'simple';
BEGIN
  -- ═══════════════════════════════════════════════════════
  -- 1. GET TEMPLATE
  -- ═══════════════════════════════════════════════════════
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
  v_tags := COALESCE(v_template.tags, '{}'::JSONB);

  -- ═══════════════════════════════════════════════════════
  -- 2. ANALYZE EACH ENTRY IN DATA ARRAY
  -- ═══════════════════════════════════════════════════════
  FOR v_entry IN SELECT * FROM jsonb_array_elements(v_data)
  LOOP
    -- Check category_tag
    CASE v_entry->>'category_tag'
      WHEN 'cash', 'bank' THEN
        v_has_cash_account := TRUE;
        -- Get default cash location
        IF v_default_cash_location_id IS NULL AND v_entry->>'cash_location_id' IS NOT NULL THEN
          v_default_cash_location_id := NULLIF(v_entry->>'cash_location_id', '')::UUID;
          v_default_cash_location_name := v_entry->>'cash_location_name';
        END IF;

      WHEN 'receivable', 'payable' THEN
        v_has_receivable_payable := TRUE;

        -- Check counterparty (entry > template level priority)
        IF v_default_counterparty_id IS NULL THEN
          v_default_counterparty_id := COALESCE(
            NULLIF(v_entry->>'counterparty_id', '')::UUID,
            v_template.counterparty_id
          );
          v_default_counterparty_name := v_entry->>'counterparty_name';
          IF v_default_counterparty_id IS NOT NULL THEN
            v_has_counterparty := TRUE;
          END IF;
        END IF;

        -- Check if internal (entry level first)
        IF v_entry->>'linked_company_id' IS NOT NULL AND v_entry->>'linked_company_id' != '' THEN
          v_is_internal_counterparty := TRUE;
          v_linked_company_id := (v_entry->>'linked_company_id')::UUID;
        END IF;

        -- If not found in entry, check counterparties table
        IF NOT v_is_internal_counterparty AND v_default_counterparty_id IS NOT NULL THEN
          SELECT c.linked_company_id INTO v_linked_company_id
          FROM counterparties c
          WHERE c.counterparty_id = v_default_counterparty_id
            AND c.is_deleted = FALSE;

          IF v_linked_company_id IS NOT NULL THEN
            v_is_internal_counterparty := TRUE;
          END IF;
        END IF;

        -- Check counterparty_store (entry > tags priority)
        IF v_default_counterparty_store_id IS NULL THEN
          v_default_counterparty_store_id := COALESCE(
            NULLIF(v_entry->>'counterparty_store_id', '')::UUID,
            NULLIF(v_tags->>'counterparty_store_id', '')::UUID
          );
          v_default_counterparty_store_name := COALESCE(
            NULLIF(v_entry->>'counterparty_store_name', ''),
            v_tags->>'counterparty_store_name'
          );
          IF v_default_counterparty_store_id IS NOT NULL THEN
            v_has_counterparty_store := TRUE;
          END IF;
        END IF;

        -- Check counterparty_cash_location (entry > template level priority)
        IF v_default_counterparty_cash_location_id IS NULL THEN
          v_default_counterparty_cash_location_id := COALESCE(
            NULLIF(v_entry->>'counterparty_cash_location_id', '')::UUID,
            v_template.counterparty_cash_location_id
          );
          IF v_default_counterparty_cash_location_id IS NOT NULL THEN
            v_has_counterparty_cash_location := TRUE;
          END IF;
        END IF;

        -- Set display category
        IF v_entry->>'type' = 'debit' THEN
          v_debit_category := INITCAP(v_entry->>'category_tag');
        ELSE
          v_credit_category := INITCAP(v_entry->>'category_tag');
        END IF;

      ELSE
        -- Other category types
        NULL;
    END CASE;

    -- Check account_code for expense (5000-9999)
    IF v_entry->>'account_code' IS NOT NULL THEN
      DECLARE
        v_code INT;
      BEGIN
        v_code := (v_entry->>'account_code')::INT;
        IF v_code >= 5000 AND v_code <= 9999 THEN
          v_has_expense_account := TRUE;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        -- Ignore non-numeric codes
        NULL;
      END;
    END IF;

    -- Set display categories (fallback)
    IF v_entry->>'type' = 'debit' AND v_debit_category IS NULL THEN
      v_debit_category := COALESCE(INITCAP(v_entry->>'category_tag'), 'Other');
    ELSIF v_entry->>'type' = 'credit' AND v_credit_category IS NULL THEN
      v_credit_category := COALESCE(INITCAP(v_entry->>'category_tag'), 'Other');
    END IF;
  END LOOP;

  -- ═══════════════════════════════════════════════════════
  -- 3. DETERMINE UI CONFIGURATION
  -- ═══════════════════════════════════════════════════════

  -- Cash location selector: expense + cash → always show
  IF v_has_expense_account AND v_has_cash_account THEN
    v_show_cash_location := TRUE;
    v_missing_items := array_append(v_missing_items, 'cash_location');
  -- Cash account without preset location
  ELSIF v_has_cash_account AND v_default_cash_location_id IS NULL THEN
    v_show_cash_location := TRUE;
    v_missing_items := array_append(v_missing_items, 'cash_location');
  END IF;

  -- Counterparty selector
  IF v_has_receivable_payable THEN
    IF v_is_internal_counterparty THEN
      -- Internal: locked, may need store and cash location
      v_counterparty_locked := TRUE;

      -- Check counterparty store
      IF NOT v_has_counterparty_store THEN
        v_show_counterparty_store := TRUE;
        v_missing_items := array_append(v_missing_items, 'counterparty_store');
      END IF;

      -- Check counterparty cash location
      IF NOT v_has_counterparty_cash_location THEN
        v_show_counterparty_cash_location := TRUE;
        v_missing_items := array_append(v_missing_items, 'counterparty_cash_location');
      END IF;
    ELSE
      -- External: always show selector (user can change)
      v_show_counterparty := TRUE;
      v_missing_items := array_append(v_missing_items, 'counterparty');
    END IF;
  END IF;

  -- ═══════════════════════════════════════════════════════
  -- 4. DETERMINE COMPLEXITY
  -- ═══════════════════════════════════════════════════════
  IF array_length(v_missing_items, 1) IS NULL OR array_length(v_missing_items, 1) = 0 THEN
    v_complexity := 'simple';
  ELSIF 'counterparty' = ANY(v_missing_items) OR 'counterparty_cash_location' = ANY(v_missing_items) OR 'counterparty_store' = ANY(v_missing_items) THEN
    v_complexity := 'withCounterparty';
  ELSIF 'cash_location' = ANY(v_missing_items) THEN
    v_complexity := 'withCash';
  ELSE
    v_complexity := 'complex';
  END IF;

  -- ═══════════════════════════════════════════════════════
  -- 5. BUILD AND RETURN RESULT
  -- ═══════════════════════════════════════════════════════
  RETURN json_build_object(
    'success', TRUE,
    'template', json_build_object(
      'template_id', v_template.template_id,
      'name', v_template.name,
      'description', v_template.template_description,
      'required_attachment', COALESCE(v_template.required_attachment, FALSE),
      'data', v_data,
      'tags', v_tags
    ),
    'analysis', json_build_object(
      'complexity', v_complexity,
      'missing_items', v_missing_items,
      'is_ready', array_length(v_missing_items, 1) IS NULL OR array_length(v_missing_items, 1) = 0,
      'completeness_score', CASE
        WHEN array_length(v_missing_items, 1) IS NULL THEN 100
        ELSE GREATEST(0, 100 - (array_length(v_missing_items, 1) * 25))
      END
    ),
    'ui_config', json_build_object(
      'show_cash_location_selector', v_show_cash_location,
      'show_counterparty_selector', v_show_counterparty,
      'show_counterparty_store_selector', v_show_counterparty_store,
      'show_counterparty_cash_location_selector', v_show_counterparty_cash_location,
      'counterparty_is_locked', v_counterparty_locked,
      'locked_counterparty_name', CASE WHEN v_counterparty_locked THEN v_default_counterparty_name ELSE NULL END,
      'linked_company_id', v_linked_company_id
    ),
    'defaults', json_build_object(
      'cash_location_id', v_default_cash_location_id,
      'cash_location_name', v_default_cash_location_name,
      'counterparty_id', v_default_counterparty_id,
      'counterparty_name', v_default_counterparty_name,
      'counterparty_store_id', v_default_counterparty_store_id,
      'counterparty_store_name', v_default_counterparty_store_name,
      'counterparty_cash_location_id', v_default_counterparty_cash_location_id,
      'is_internal_counterparty', v_is_internal_counterparty
    ),
    'display_info', json_build_object(
      'debit_category', COALESCE(v_debit_category, 'Other'),
      'credit_category', COALESCE(v_credit_category, 'Other'),
      'transaction_type', COALESCE(v_debit_category, 'Other') || ' → ' || COALESCE(v_credit_category, 'Other')
    )
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
GRANT EXECUTE ON FUNCTION get_template_for_usage(UUID, UUID, UUID) TO authenticated;

-- Add comment
COMMENT ON FUNCTION get_template_for_usage IS
'Analyzes a transaction template and returns UI configuration for the template usage modal.
Returns: template data, analysis (complexity, missing items), UI config (which selectors to show), defaults, and display info.
Reference: docs/TEMPLATE_RPC_REFACTORING_PLAN.md';
