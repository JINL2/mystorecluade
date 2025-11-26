-- ============================================================================
-- Perfect Account Mapping Logic with Full Data Integrity
-- ============================================================================
-- Author: Claude
-- Date: 2025-11-25
--
-- Purpose:
--   1. Ensure counterparties are unique per company pair
--   2. Fix duplicate detection to match database UNIQUE constraint
--   3. Handle both same-company and cross-company mappings correctly
--   4. Maintain bidirectional mapping consistency
--
-- ============================================================================

-- ============================================================================
-- STEP 1: Add UNIQUE constraint to counterparties (if not exists)
-- ============================================================================
-- This prevents duplicate counterparty relationships between same companies
-- Example: Company A cannot have multiple counterparty records pointing to Company B

DO $$
BEGIN
    -- Check if constraint already exists
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'counterparties_company_linked_unique'
    ) THEN
        ALTER TABLE counterparties
        ADD CONSTRAINT counterparties_company_linked_unique
        UNIQUE (company_id, linked_company_id);

        RAISE NOTICE 'Added UNIQUE constraint: counterparties_company_linked_unique';
    ELSE
        RAISE NOTICE 'UNIQUE constraint already exists: counterparties_company_linked_unique';
    END IF;
END $$;


-- ============================================================================
-- STEP 2: Fix insert_account_mapping_with_company RPC
-- ============================================================================
-- Problem: Duplicate check was too broad and didn't match DB UNIQUE constraint
-- Solution: Check exact columns that match the UNIQUE constraint

CREATE OR REPLACE FUNCTION public.insert_account_mapping_with_company(
  p_my_company_id uuid,
  p_my_account_id uuid,
  p_counterparty_company_id uuid,
  p_linked_account_id uuid,
  p_direction text,
  p_created_by uuid
)
RETURNS text
LANGUAGE plpgsql
AS $function$
DECLARE
  v_counterparty_id UUID;
  v_reverse_counterparty_id UUID;
  v_my_company_name TEXT;
  v_counterparty_company_name TEXT;
BEGIN
  -- ========================================================================
  -- 0. Get company names for counterparty creation
  -- ========================================================================
  SELECT company_name INTO v_my_company_name
  FROM companies
  WHERE company_id = p_my_company_id;

  SELECT company_name INTO v_counterparty_company_name
  FROM companies
  WHERE company_id = p_counterparty_company_id;

  -- Validate companies exist
  IF v_my_company_name IS NULL THEN
    RAISE EXCEPTION 'Company % not found', p_my_company_id;
  END IF;

  IF v_counterparty_company_name IS NULL THEN
    RAISE EXCEPTION 'Company % not found', p_counterparty_company_id;
  END IF;

  -- ========================================================================
  -- 1. Get or create counterparty: My Company → Counterparty Company
  -- ========================================================================
  -- Due to UNIQUE constraint, this will either find existing or create new
  SELECT counterparty_id INTO v_counterparty_id
  FROM counterparties
  WHERE company_id = p_my_company_id
    AND linked_company_id = p_counterparty_company_id;

  IF v_counterparty_id IS NULL THEN
    INSERT INTO counterparties (
      company_id,
      linked_company_id,
      name,
      is_internal,
      created_at,
      created_by
    ) VALUES (
      p_my_company_id,
      p_counterparty_company_id,
      v_counterparty_company_name,
      TRUE,
      NOW(),
      p_created_by
    ) RETURNING counterparty_id INTO v_counterparty_id;
  END IF;

  -- ========================================================================
  -- 2. Get or create reverse counterparty: Counterparty Company → My Company
  -- ========================================================================
  SELECT counterparty_id INTO v_reverse_counterparty_id
  FROM counterparties
  WHERE company_id = p_counterparty_company_id
    AND linked_company_id = p_my_company_id;

  IF v_reverse_counterparty_id IS NULL THEN
    INSERT INTO counterparties (
      company_id,
      linked_company_id,
      name,
      is_internal,
      created_at,
      created_by
    ) VALUES (
      p_counterparty_company_id,
      p_my_company_id,
      v_my_company_name,
      TRUE,
      NOW(),
      p_created_by
    ) RETURNING counterparty_id INTO v_reverse_counterparty_id;
  END IF;

  -- ========================================================================
  -- 3. Check if mapping already exists (matches DB UNIQUE constraint)
  -- ========================================================================
  -- Database UNIQUE: (my_company_id, my_account_id, counterparty_id, direction)
  -- We check if THIS EXACT mapping already exists

  IF EXISTS (
    SELECT 1
    FROM account_mappings
    WHERE my_company_id = p_my_company_id
      AND my_account_id = p_my_account_id
      AND counterparty_id = v_counterparty_id
      AND direction = p_direction
  ) THEN
    RETURN 'already_exists';
  END IF;

  -- ========================================================================
  -- 4. Insert bidirectional mappings
  -- ========================================================================

  -- 4-1. Forward mapping: My Company → Counterparty Company
  INSERT INTO account_mappings (
    mapping_id,
    my_company_id,
    my_account_id,
    counterparty_id,
    linked_account_id,
    direction,
    created_at,
    created_by
  ) VALUES (
    gen_random_uuid(),
    p_my_company_id,
    p_my_account_id,
    v_counterparty_id,
    p_linked_account_id,
    p_direction,
    NOW(),
    p_created_by
  );

  -- 4-2. Reverse mapping: Counterparty Company → My Company
  -- Direction is reversed: receivable ↔ payable
  INSERT INTO account_mappings (
    mapping_id,
    my_company_id,
    my_account_id,
    counterparty_id,
    linked_account_id,
    direction,
    created_at,
    created_by
  ) VALUES (
    gen_random_uuid(),
    p_counterparty_company_id,
    p_linked_account_id,
    v_reverse_counterparty_id,
    p_my_account_id,
    CASE
      WHEN p_direction = 'payable' THEN 'receivable'
      WHEN p_direction = 'receivable' THEN 'payable'
      ELSE p_direction
    END,
    NOW(),
    p_created_by
  );

  RETURN 'inserted';

EXCEPTION
  WHEN unique_violation THEN
    -- This handles race conditions or if mapping was created between our check and insert
    RETURN 'already_exists';
  WHEN OTHERS THEN
    RAISE;
END;
$function$;


-- ============================================================================
-- STEP 3: Add helper function to check mapping symmetry
-- ============================================================================
-- This function verifies bidirectional mappings are correct
-- Useful for debugging and data validation

CREATE OR REPLACE FUNCTION public.validate_account_mapping_symmetry(
  p_mapping_id uuid
)
RETURNS TABLE (
  is_valid boolean,
  message text,
  forward_mapping jsonb,
  reverse_mapping jsonb
)
LANGUAGE plpgsql
AS $function$
DECLARE
  v_forward record;
  v_reverse record;
  v_expected_reverse_company_id uuid;
  v_expected_reverse_counterparty_id uuid;
  v_expected_reverse_direction text;
BEGIN
  -- Get forward mapping
  SELECT * INTO v_forward
  FROM account_mappings
  WHERE mapping_id = p_mapping_id;

  IF NOT FOUND THEN
    RETURN QUERY SELECT
      false,
      'Mapping not found'::text,
      NULL::jsonb,
      NULL::jsonb;
    RETURN;
  END IF;

  -- Get the linked company from counterparty
  SELECT linked_company_id INTO v_expected_reverse_company_id
  FROM counterparties
  WHERE counterparty_id = v_forward.counterparty_id;

  -- Get the reverse counterparty
  SELECT counterparty_id INTO v_expected_reverse_counterparty_id
  FROM counterparties
  WHERE company_id = v_expected_reverse_company_id
    AND linked_company_id = v_forward.my_company_id;

  -- Calculate expected reverse direction
  v_expected_reverse_direction := CASE
    WHEN v_forward.direction = 'payable' THEN 'receivable'
    WHEN v_forward.direction = 'receivable' THEN 'payable'
    ELSE v_forward.direction
  END;

  -- Find reverse mapping
  SELECT * INTO v_reverse
  FROM account_mappings
  WHERE my_company_id = v_expected_reverse_company_id
    AND my_account_id = v_forward.linked_account_id
    AND counterparty_id = v_expected_reverse_counterparty_id
    AND linked_account_id = v_forward.my_account_id
    AND direction = v_expected_reverse_direction;

  IF FOUND THEN
    RETURN QUERY SELECT
      true,
      'Bidirectional mapping is valid'::text,
      row_to_json(v_forward)::jsonb,
      row_to_json(v_reverse)::jsonb;
  ELSE
    RETURN QUERY SELECT
      false,
      'Reverse mapping not found or incorrect'::text,
      row_to_json(v_forward)::jsonb,
      NULL::jsonb;
  END IF;
END;
$function$;


-- ============================================================================
-- STEP 4: Add index for performance
-- ============================================================================
-- Speed up counterparty lookups

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_counterparties_company_linked'
    ) THEN
        CREATE INDEX idx_counterparties_company_linked
        ON counterparties(company_id, linked_company_id);

        RAISE NOTICE 'Added index: idx_counterparties_company_linked';
    ELSE
        RAISE NOTICE 'Index already exists: idx_counterparties_company_linked';
    END IF;
END $$;


-- ============================================================================
-- STEP 5: Add index for account_mappings lookups
-- ============================================================================
-- Speed up mapping existence checks

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'idx_account_mappings_lookup'
    ) THEN
        CREATE INDEX idx_account_mappings_lookup
        ON account_mappings(my_company_id, counterparty_id, my_account_id, direction);

        RAISE NOTICE 'Added index: idx_account_mappings_lookup';
    ELSE
        RAISE NOTICE 'Index already exists: idx_account_mappings_lookup';
    END IF;
END $$;


-- ============================================================================
-- VERIFICATION QUERIES (Run these manually to verify)
-- ============================================================================

-- 1. Check all constraints are in place
-- SELECT conname, pg_get_constraintdef(oid)
-- FROM pg_constraint
-- WHERE conrelid = 'account_mappings'::regclass;

-- 2. Verify no orphaned mappings
-- SELECT COUNT(*) as orphaned_mappings
-- FROM account_mappings am
-- WHERE NOT EXISTS (
--   SELECT 1 FROM account_mappings reverse
--   WHERE reverse.my_company_id IN (
--     SELECT linked_company_id FROM counterparties WHERE counterparty_id = am.counterparty_id
--   )
-- );

-- 3. Check mapping symmetry for all mappings
-- SELECT
--   am.mapping_id,
--   am.my_company_id,
--   c.linked_company_id,
--   v.*
-- FROM account_mappings am
-- JOIN counterparties c ON c.counterparty_id = am.counterparty_id
-- CROSS JOIN LATERAL validate_account_mapping_symmetry(am.mapping_id) v
-- WHERE v.is_valid = false
-- LIMIT 10;
