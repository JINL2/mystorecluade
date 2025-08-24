# Quick Fix for Counterparty Loading Issue

## The Problem
The counterparty selector shows "No counterparty available" because:
1. The RPC function `get_counterparties` likely doesn't exist in your Supabase database yet
2. OR there are no counterparties in the database for your company

## Quick Solution

### Option 1: Run the Complete Setup (Recommended)

Run this SQL in your Supabase SQL Editor:

```sql
-- 1. Create the RPC function
CREATE OR REPLACE FUNCTION get_counterparties(
  p_company_id UUID,
  p_store_id UUID DEFAULT NULL,
  p_counterparty_type TEXT DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  type TEXT,
  email TEXT,
  phone TEXT,
  is_internal BOOLEAN,
  transaction_count INTEGER,
  additional_data JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    cp.counterparty_id AS id,
    cp.name AS name,
    cp.type AS type,
    cp.email AS email,
    cp.phone AS phone,
    cp.is_internal AS is_internal,
    COALESCE(
      (
        SELECT COUNT(*)::INTEGER
        FROM journal_lines jl
        JOIN journal_entries je ON jl.journal_id = je.journal_id
        WHERE jl.counterparty_id = cp.counterparty_id
          AND je.company_id = p_company_id
          AND (p_store_id IS NULL OR je.store_id = p_store_id)
          AND je.status = 'posted'
      ), 
      0
    ) AS transaction_count,
    jsonb_build_object(
      'linked_company_id', cp.linked_company_id,
      'address', cp.address,
      'notes', cp.notes
    ) AS additional_data
  FROM counterparties cp
  WHERE cp.company_id = p_company_id
    AND (cp.is_deleted = false OR cp.is_deleted IS NULL)
    AND (p_counterparty_type IS NULL OR cp.type = p_counterparty_type)
  ORDER BY cp.name ASC;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_counterparties(UUID, UUID, TEXT) TO authenticated;

-- 2. Insert test counterparties for your company
-- Using your company_id: 7a2545e0-e112-4b0c-9c59-221a530c4602
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

-- 3. Test the function
SELECT * FROM get_counterparties(
    '7a2545e0-e112-4b0c-9c59-221a530c4602'::UUID,
    NULL,
    'vendor'
);
```

### Option 2: Quick Test (Just Add Data)

If you want to test quickly without creating the function, just add counterparties:

```sql
-- Quick insert for testing
INSERT INTO counterparties (name, type, company_id, is_internal, is_deleted) 
VALUES 
    ('Test Vendor 1', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', false, false),
    ('Test Vendor 2', 'vendor', '7a2545e0-e112-4b0c-9c59-221a530c4602', false, false),
    ('Test Customer', 'customer', '7a2545e0-e112-4b0c-9c59-221a530c4602', false, false);
```

## Verification Steps

1. After running the SQL, restart your Flutter app
2. Go to Journal Entry page
3. Select an account with category "payable" or "receivable"
4. The counterparty selector should now show the test vendors/customers

## Debug Information

From your logs:
- Company ID: `7a2545e0-e112-4b0c-9c59-221a530c4602`
- Store ID: `d3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff`
- The RPC is being called correctly
- The response is empty `[]` - meaning no data found

## Why Transaction Filter Works

The transaction filter sheet (`transaction_filter_sheet.dart`) is also using the same `AutonomousCounterpartySelector`, so if it's working there, it means:
1. The RPC function exists
2. There's data for that context

Check if the transaction filter is actually showing counterparties or if it's also empty.