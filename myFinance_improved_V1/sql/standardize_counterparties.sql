-- =====================================================
-- STANDARDIZE COUNTERPARTY TYPES
-- Run this once to clean up your counterparty data
-- =====================================================

-- Step 1: View current types (run this first to see what you have)
SELECT type, COUNT(*) as count 
FROM counterparties 
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602'
  AND (is_deleted = false OR is_deleted IS NULL)
GROUP BY type
ORDER BY count DESC;

-- Step 2: Standardize all counterparty types
UPDATE counterparties 
SET type = CASE
    -- Vendor variations
    WHEN LOWER(type) IN ('vendor', 'supplier', 'suppliers', 'vendedor', 'proveedor') THEN 'vendor'
    WHEN type IS NULL OR type = '' THEN 'vendor'  -- Default empty to vendor
    
    -- Customer variations
    WHEN LOWER(type) IN ('customer', 'client', 'cliente', 'buyer') THEN 'customer'
    
    -- Internal variations
    WHEN LOWER(type) IN ('internal', 'interno', 'inter-company', 'intercompany') THEN 'internal'
    
    -- Employee variations
    WHEN LOWER(type) IN ('employee', 'staff', 'empleado', 'worker') THEN 'employee'
    
    -- Keep original if not matched
    ELSE LOWER(type)
END
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602';

-- Step 3: Verify the standardization
SELECT type, COUNT(*) as count 
FROM counterparties 
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602'
  AND (is_deleted = false OR is_deleted IS NULL)
GROUP BY type
ORDER BY count DESC;

-- Step 4: Add some test data if needed
INSERT INTO counterparties (
    name, 
    type, 
    company_id,
    email,
    phone,
    is_internal,
    is_deleted
) VALUES 
    ('Sample Vendor 1', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'vendor1@example.com', '555-0001', false, false),
    ('Sample Vendor 2', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'vendor2@example.com', '555-0002', false, false),
    ('Sample Customer 1', 'customer', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'customer1@example.com', '555-0003', false, false),
    ('Sample Customer 2', 'customer', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'customer2@example.com', '555-0004', false, false),
    ('Internal Transfer', 'internal', '7a2545e0-e112-4b0c-9c59-221a530c4602', null, null, true, false)
ON CONFLICT DO NOTHING;