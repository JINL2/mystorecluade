-- =====================================================
-- COUNTERPARTY TYPE STANDARDIZATION
-- Migrates custom types to standard accounting types
-- =====================================================

-- Step 1: Backup current types (create a backup column)
ALTER TABLE counterparties 
ADD COLUMN IF NOT EXISTS original_type TEXT;

UPDATE counterparties 
SET original_type = type 
WHERE original_type IS NULL;

-- Step 2: View current type distribution
SELECT 
    type,
    is_internal,
    COUNT(*) as count,
    STRING_AGG(name, ', ' ORDER BY name) as example_names
FROM counterparties 
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602'
  AND (is_deleted = false OR is_deleted IS NULL)
GROUP BY type, is_internal
ORDER BY count DESC;

-- Step 3: Standardize types based on your business logic
UPDATE counterparties 
SET type = CASE
    -- Internal transfers and inter-company
    WHEN is_internal = true THEN 'internal'
    
    -- Customer types
    WHEN type = 'Customers' THEN 'customer'
    WHEN name LIKE '%고객%' OR name LIKE '%Customer%' THEN 'customer'
    
    -- Vendor/Supplier types (most common for payables)
    WHEN type IN ('My Company', 'Team Member', 'Others') THEN 'vendor'
    WHEN type IS NULL OR type = '' THEN 'vendor'
    
    -- Default to vendor for unknown types
    ELSE 'vendor'
END
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602';

-- Step 4: Verify the migration
SELECT 
    type as new_type,
    original_type,
    is_internal,
    COUNT(*) as count
FROM counterparties 
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602'
  AND (is_deleted = false OR is_deleted IS NULL)
GROUP BY type, original_type, is_internal
ORDER BY type, original_type;

-- Step 5: Test the RPC function
SELECT * FROM get_counterparties(
    '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,
    NULL,
    'vendor'
);

-- Optional: If you want to revert
-- UPDATE counterparties 
-- SET type = original_type 
-- WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602';