-- =====================================================
-- TEST AND SETUP COUNTERPARTY DATA
-- Run this in Supabase SQL Editor to diagnose and fix issues
-- =====================================================

-- Step 1: Check if the RPC function exists
SELECT 
    proname as function_name,
    pg_get_function_result(oid) as return_type,
    pg_get_function_arguments(oid) as arguments
FROM pg_proc 
WHERE proname = 'get_counterparties';

-- Step 2: Check if counterparties table has data for your company
-- Replace with your actual company_id from the logs: 7a2545e0-e112-4b0c-9c59-221a530c4602
SELECT 
    counterparty_id,
    name,
    type,
    company_id,
    is_internal,
    is_deleted
FROM counterparties 
WHERE company_id = '7a2545e0-e112-4b0c-9c59-221a530c4602';

-- Step 3: If no data exists, insert test counterparties
-- This will create sample counterparties for testing
INSERT INTO counterparties (
    counterparty_id,
    name, 
    type, 
    company_id,
    email,
    phone,
    is_internal,
    is_deleted
) VALUES 
    (gen_random_uuid(), 'ABC Corporation', 'customer', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'contact@abc.com', '555-0101', false, false),
    (gen_random_uuid(), 'XYZ Suppliers', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'sales@xyz.com', '555-0102', false, false),
    (gen_random_uuid(), 'Tech Solutions Inc', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'info@techsolutions.com', '555-0103', false, false),
    (gen_random_uuid(), 'Office Supplies Co', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'orders@officesupplies.com', '555-0104', false, false),
    (gen_random_uuid(), 'Premium Services Ltd', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'support@premium.com', '555-0105', false, false),
    (gen_random_uuid(), 'Internal Transfer', 'internal', '7a2545e0-e112-4b0c-9c59-221a530c4602', null, null, true, false),
    (gen_random_uuid(), 'Main Office', 'internal', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'office@company.com', '555-0100', true, false),
    (gen_random_uuid(), 'John Doe', 'customer', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'john@example.com', '555-0106', false, false),
    (gen_random_uuid(), 'Jane Smith', 'customer', '7a2545e0-e112-4b0c-9c59-221a530c4602', 'jane@example.com', '555-0107', false, false)
ON CONFLICT DO NOTHING;

-- Step 4: Test the RPC function directly
-- This should return data if the function exists and data is present
SELECT * FROM get_counterparties(
    '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,  -- company_id
    NULL,  -- store_id (optional)
    'vendor'  -- counterparty_type
);

-- Step 5: If the function doesn't exist, create it
-- (Copy the full function from get_counterparties.sql)