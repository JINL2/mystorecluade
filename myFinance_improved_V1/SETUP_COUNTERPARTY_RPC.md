# Setup Counterparty RPC Function

## Issue Found
The counterparty selector wasn't loading data because:
1. The required RPC function `get_counterparties` was missing from Supabase
2. The provider was incorrectly reading company/store IDs from app state
3. The journal input dialog wasn't properly getting counterparty details when selected

## Solution

### 1. Fixed Provider Code
Updated `/lib/presentation/providers/entities/counterparty_provider.dart` to correctly read from app state:
- Changed from `selectedCompany?['company_id']` to `appState.companyChoosen`
- Changed from `selectedStore?['store_id']` to `appState.storeChoosen`

### 2. Fixed Journal Input Dialog
Updated `/lib/presentation/pages/journal_input/widgets/add_transaction_dialog.dart`:
- Now uses `counterpartyByIdProvider` to get full counterparty details
- Properly sets `_selectedCounterpartyName`, `_isInternal`, and `_linkedCompanyId`
- Falls back to old method if new provider fails

### 3. Created RPC Function
Created SQL function at `/supabase/functions/get_counterparties.sql` with `additional_data` field for linked_company_id

### 4. Deploy to Supabase

Run this SQL in your Supabase SQL Editor:

```sql
-- =====================================================
-- RPC FUNCTION: get_counterparties
-- Returns counterparties for a given company and optional store
-- =====================================================

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

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_counterparties(UUID, UUID, TEXT) TO authenticated;

-- Add comment for documentation
COMMENT ON FUNCTION get_counterparties IS 'Returns counterparties for a given company with optional store and type filtering, including transaction counts';
```

### 4. Test Data (Optional)
If you need test data, run this SQL to create sample counterparties:

```sql
-- Insert sample counterparties (replace company_id with your actual company ID)
INSERT INTO counterparties (name, type, company_id, email, phone, is_internal) VALUES
  ('ABC Corporation', 'customer', 'YOUR_COMPANY_ID', 'contact@abc.com', '555-0101', false),
  ('XYZ Suppliers', 'vendor', 'YOUR_COMPANY_ID', 'sales@xyz.com', '555-0102', false),
  ('Internal Transfer', 'internal', 'YOUR_COMPANY_ID', null, null, true),
  ('Main Office', 'internal', 'YOUR_COMPANY_ID', 'office@company.com', '555-0100', true),
  ('John Doe', 'customer', 'YOUR_COMPANY_ID', 'john@example.com', '555-0103', false);
```

### 5. Verify
After deploying the function:
1. Run the app
2. Make sure you have a company selected
3. Open the counterparty selector
4. Check the console logs - you should see:
   - `🔍 currentCounterparties provider:`
   - `📦 RPC Response: [...]`
   - `✅ Found X counterparties`

## Debug Information Added
The following debug logs have been added to help troubleshoot:
- `autonomous_counterparty_selector.dart`: Logs provider selection and data state
- `counterparty_provider.dart`: Logs RPC parameters, response, and data mapping

## Summary of Changes
1. ✅ Changed "Vendor" to "Counterparty" in all UI labels
2. ✅ Fixed provider to correctly read company/store from app state
3. ✅ Created RPC function for fetching counterparties
4. ✅ Added comprehensive debugging logs
5. ✅ Created deployment instructions