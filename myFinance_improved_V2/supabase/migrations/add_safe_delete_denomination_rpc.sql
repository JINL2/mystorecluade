-- RPC function to safely delete a denomination
-- Checks all locations where money might exist before allowing deletion
--
-- Uses cash_amount_entries table which contains:
--   - current_stock_snapshot: JSONB with denominations array for cashier/vault
--
-- Logic:
--   1. Find the latest entry per location from cash_amount_entries
--   2. For cashier/vault: check current_stock_snapshot->denominations for quantity > 0
--   3. Bank locations are SKIPPED (they don't track denominations)
CREATE OR REPLACE FUNCTION safe_delete_denomination(
  p_denomination_id UUID,
  p_company_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_denomination RECORD;
  v_currency_id UUID;
  v_blocking_locations JSONB := '[]'::JSONB;
  v_location RECORD;
  v_latest_entry RECORD;
  v_denom_quantity NUMERIC;
BEGIN
  -- 1. Check if denomination exists
  SELECT * INTO v_denomination
  FROM currency_denominations
  WHERE denomination_id = p_denomination_id
    AND company_id = p_company_id
    AND is_deleted = false;

  IF v_denomination IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Denomination not found or already deleted'
    );
  END IF;

  v_currency_id := v_denomination.currency_id;

  -- 2. Check each cashier/vault location that uses this currency
  -- Bank locations are skipped - they don't track denominations
  FOR v_location IN
    SELECT cl.cash_location_id, cl.location_name, cl.location_type
    FROM cash_locations cl
    WHERE cl.company_id = p_company_id
      AND cl.currency_id = v_currency_id
      AND cl.is_deleted = false
      AND cl.location_type IN ('cashier', 'vault')  -- Only check cashier/vault
  LOOP
    -- Get the latest entry for this location from cash_amount_entries
    SELECT * INTO v_latest_entry
    FROM cash_amount_entries
    WHERE location_id = v_location.cash_location_id
      AND company_id = p_company_id
    ORDER BY record_date DESC, created_at DESC
    LIMIT 1;

    -- Skip if no entries exist for this location
    IF v_latest_entry IS NULL THEN
      CONTINUE;
    END IF;

    -- For cashier/vault: check current_stock_snapshot for this denomination
    -- Extract quantity for the specific denomination_id from JSONB array
    SELECT COALESCE((elem->>'quantity')::NUMERIC, 0) INTO v_denom_quantity
    FROM jsonb_array_elements(v_latest_entry.current_stock_snapshot->'denominations') AS elem
    WHERE elem->>'denomination_id' = p_denomination_id::TEXT;

    IF v_denom_quantity IS NOT NULL AND v_denom_quantity <> 0 THEN
      v_blocking_locations := v_blocking_locations || jsonb_build_object(
        'location_id', v_location.cash_location_id,
        'location_name', v_location.location_name,
        'location_type', v_location.location_type,
        'quantity', v_denom_quantity,
        'reason', CASE
          WHEN v_location.location_type = 'cashier' THEN 'Cashier has '
          ELSE 'Vault has '
        END || v_denom_quantity::TEXT || ' units of this denomination'
      );
    END IF;
  END LOOP;

  -- 3. If any blocking locations found, return error with details
  IF jsonb_array_length(v_blocking_locations) > 0 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Cannot delete denomination: money exists in some locations',
      'blocking_locations', v_blocking_locations,
      'denomination_value', v_denomination.value
    );
  END IF;

  -- 4. Safe to delete - perform soft delete
  UPDATE currency_denominations
  SET is_deleted = true
  WHERE denomination_id = p_denomination_id
    AND company_id = p_company_id;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Denomination deleted successfully',
    'denomination_id', p_denomination_id
  );
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION safe_delete_denomination(UUID, UUID) TO authenticated;

COMMENT ON FUNCTION safe_delete_denomination IS 'Safely deletes a denomination after checking all cash locations for existing money. Returns blocking locations if deletion is not allowed.';
