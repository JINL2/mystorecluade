-- ============================================================================
-- Perfect Account Mapping Logic with Data Cleanup
-- ============================================================================
-- Author: Claude
-- Date: 2025-11-25
--
-- Purpose:
--   1. Clean up duplicate counterparties
--   2. Ensure counterparties are unique per company pair
--   3. Fix duplicate detection to match database UNIQUE constraint
--   4. Handle both same-company and cross-company mappings correctly
--   5. Maintain bidirectional mapping consistency
--
-- ============================================================================

-- ============================================================================
-- STEP 0: Analyze existing duplicates
-- ============================================================================
-- Find duplicate counterparties (same company_id + linked_company_id pairs)

DO $$
DECLARE
  v_duplicate_count INT;
BEGIN
  SELECT COUNT(*) INTO v_duplicate_count
  FROM (
    SELECT company_id, linked_company_id, COUNT(*) as cnt
    FROM counterparties
    GROUP BY company_id, linked_company_id
    HAVING COUNT(*) > 1
  ) dups;

  RAISE NOTICE '📊 Found % duplicate counterparty pairs', v_duplicate_count;
END $$;


-- ============================================================================
-- STEP 1: Clean up duplicate counterparties
-- ============================================================================
-- Strategy: Keep the oldest counterparty_id, merge all mappings to it

DO $$
DECLARE
  v_dup_record RECORD;
  v_keep_id UUID;
  v_delete_ids UUID[];
  v_total_merged INT := 0;
BEGIN
  -- For each duplicate pair
  FOR v_dup_record IN
    SELECT company_id, linked_company_id, COUNT(*) as cnt
    FROM counterparties
    WHERE linked_company_id IS NOT NULL  -- Only internal counterparties
    GROUP BY company_id, linked_company_id
    HAVING COUNT(*) > 1
  LOOP
    RAISE NOTICE '🔧 Processing duplicate: company_id=%, linked_company_id=%, count=%',
      v_dup_record.company_id, v_dup_record.linked_company_id, v_dup_record.cnt;

    -- Get the oldest counterparty (keep this one)
    SELECT counterparty_id INTO v_keep_id
    FROM counterparties
    WHERE company_id = v_dup_record.company_id
      AND linked_company_id = v_dup_record.linked_company_id
    ORDER BY created_at ASC NULLS LAST, counterparty_id ASC
    LIMIT 1;

    -- Get IDs of duplicates to delete
    SELECT ARRAY_AGG(counterparty_id) INTO v_delete_ids
    FROM counterparties
    WHERE company_id = v_dup_record.company_id
      AND linked_company_id = v_dup_record.linked_company_id
      AND counterparty_id != v_keep_id;

    -- Update all account_mappings to point to the kept counterparty
    UPDATE account_mappings
    SET counterparty_id = v_keep_id
    WHERE counterparty_id = ANY(v_delete_ids);

    -- Delete duplicate counterparties
    DELETE FROM counterparties
    WHERE counterparty_id = ANY(v_delete_ids);

    v_total_merged := v_total_merged + ARRAY_LENGTH(v_delete_ids, 1);

    RAISE NOTICE '  ✅ Kept counterparty_id=%, deleted % duplicates',
      v_keep_id, ARRAY_LENGTH(v_delete_ids, 1);
  END LOOP;

  RAISE NOTICE '🎉 Total duplicates cleaned: %', v_total_merged;
END $$;


-- ============================================================================
-- STEP 2: Add UNIQUE constraint to counterparties
-- ============================================================================
-- Now that duplicates are cleaned, we can add the constraint

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

        RAISE NOTICE '✅ Added UNIQUE constraint: counterparties_company_linked_unique';
    ELSE
        RAISE NOTICE 'ℹ️  UNIQUE constraint already exists: counterparties_company_linked_unique';
    END IF;
END $$;


-- ============================================================================
-- STEP 3: Fix insert_account_mapping_with_company RPC
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
-- STEP 4: Add helper function to check mapping symmetry
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
-- STEP 5: Add index for performance
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

        RAISE NOTICE '✅ Added index: idx_counterparties_company_linked';
    ELSE
        RAISE NOTICE 'ℹ️  Index already exists: idx_counterparties_company_linked';
    END IF;
END $$;


-- ============================================================================
-- STEP 6: Add index for account_mappings lookups
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

        RAISE NOTICE '✅ Added index: idx_account_mappings_lookup';
    ELSE
        RAISE NOTICE 'ℹ️  Index already exists: idx_account_mappings_lookup';
    END IF;
END $$;


-- ============================================================================
-- STEP 7: Final verification
-- ============================================================================

DO $$
DECLARE
  v_constraint_count INT;
  v_index_count INT;
BEGIN
  -- Count constraints
  SELECT COUNT(*) INTO v_constraint_count
  FROM pg_constraint
  WHERE conname IN (
    'counterparties_company_linked_unique',
    'account_mappings_my_company_id_my_account_id_counterparty_i_key'
  );

  -- Count indexes
  SELECT COUNT(*) INTO v_index_count
  FROM pg_indexes
  WHERE indexname IN (
    'idx_counterparties_company_linked',
    'idx_account_mappings_lookup'
  );

  RAISE NOTICE '📊 Final Status:';
  RAISE NOTICE '  Constraints: % / 2', v_constraint_count;
  RAISE NOTICE '  Indexes: % / 2', v_index_count;

  IF v_constraint_count = 2 AND v_index_count = 2 THEN
    RAISE NOTICE '🎉 Migration completed successfully!';
  ELSE
    RAISE WARNING '⚠️  Some constraints or indexes may be missing';
  END IF;
END $$;


-- ============================================================================
-- VERIFICATION QUERIES (Run these manually to verify)
-- ============================================================================

-- 1. Check all constraints are in place
-- SELECT conname, pg_get_constraintdef(oid)
-- FROM pg_constraint
-- WHERE conrelid IN ('account_mappings'::regclass, 'counterparties'::regclass)
-- ORDER BY conname;

-- 2. Verify no duplicate counterparties remain
-- SELECT company_id, linked_company_id, COUNT(*) as count
-- FROM counterparties
-- WHERE linked_company_id IS NOT NULL
-- GROUP BY company_id, linked_company_id
-- HAVING COUNT(*) > 1;
-- Expected: 0 rows

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
-- Expected: Ideally 0 rows (all mappings are symmetric)
