# Debt Account Mapping System - Deployment Guide

## Prerequisites
- Supabase project with existing tables: `account_mappings`, `counterparties`, `accounts`, `journal_entries`, `companies`
- Admin access to run SQL functions
- No database schema changes required (RPC-only implementation)

## Deployment Steps

### Step 1: Deploy RPC Functions
1. Open Supabase SQL Editor
2. Copy the entire contents of `debt_account_mapping_rpc.sql`
3. Execute the SQL script
4. Verify all 8 functions are created successfully

### Step 2: Verify Function Permissions
Run this query to confirm permissions:
```sql
SELECT 
    p.proname as function_name,
    pg_catalog.has_function_privilege('authenticated', p.oid, 'EXECUTE') as has_execute
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
AND p.proname IN (
    'get_account_mappings_with_company',
    'get_debt_accounts_for_company',
    'find_inter_company_journals',
    'create_account_mapping',
    'update_account_mapping',
    'delete_account_mapping',
    'create_corresponding_journal',
    'get_internal_counterparties_with_companies'
);
```

All functions should show `has_execute = true`.

### Step 3: Test Basic Functionality
Test each RPC function:

```sql
-- Test 1: Get debt accounts
SELECT * FROM get_debt_accounts_for_company('your-company-id-here');

-- Test 2: Get internal counterparties
SELECT * FROM get_internal_counterparties_with_companies('your-company-id-here');

-- Test 3: Get account mappings (use a valid counterparty_id)
SELECT * FROM get_account_mappings_with_company('your-counterparty-id-here');
```

### Step 4: Verify Data Prerequisites

#### Check counterparties have linked_company_id:
```sql
SELECT 
    counterparty_id,
    counterparty_name,
    is_internal,
    linked_company_id
FROM counterparties
WHERE is_internal = true;
```

If `linked_company_id` is NULL for internal counterparties, update them:
```sql
UPDATE counterparties
SET linked_company_id = 'target-company-id'
WHERE counterparty_id = 'counterparty-id'
AND is_internal = true;
```

#### Check accounts have debt identification:
```sql
SELECT 
    account_id,
    account_name,
    category_tag,
    debt_tag,
    account_type
FROM accounts
WHERE category_tag ILIKE '%payable%'
   OR category_tag ILIKE '%receivable%'
   OR debt_tag IS NOT NULL;
```

### Step 5: Understanding the Direction Field
The `direction` field in `account_mappings` table indicates:
- `'bidirectional'` (default): Mapping works both ways
- `'unidirectional'`: Mapping works one way only
- NULL: Treated as bidirectional

### Step 6: Initial Testing
1. Create a test mapping between two internal companies
2. Create a journal entry in Company A
3. Run the journal recognition function for Company B
4. Verify the corresponding entry is identified

### Step 7: Production Checklist
- [ ] All RPC functions deployed
- [ ] Permissions verified
- [ ] Internal counterparties have linked_company_id
- [ ] Debt accounts properly tagged
- [ ] Test mapping created and verified
- [ ] Journal recognition tested

## Troubleshooting

### Function Not Found Error
```sql
-- Check if function exists
SELECT proname 
FROM pg_proc 
WHERE proname = 'function_name_here';
```

### Permission Denied Error
```sql
-- Grant execute permission
GRANT EXECUTE ON FUNCTION function_name TO authenticated;
```

### No Debt Accounts Found
```sql
-- Update account tags
UPDATE accounts
SET category_tag = 'accounts_payable'
WHERE account_name ILIKE '%payable%'
AND category_tag IS NULL;
```

### Linked Company Not Set
```sql
-- Set linked company for internal counterparties
UPDATE counterparties
SET linked_company_id = (
    SELECT company_id 
    FROM companies 
    WHERE company_name = 'Target Company Name'
)
WHERE counterparty_name = 'Counterparty Name'
AND is_internal = true;
```

## Rollback Procedure
If needed, remove all functions:
```sql
DROP FUNCTION IF EXISTS get_account_mappings_with_company CASCADE;
DROP FUNCTION IF EXISTS get_debt_accounts_for_company CASCADE;
DROP FUNCTION IF EXISTS find_inter_company_journals CASCADE;
DROP FUNCTION IF EXISTS create_account_mapping CASCADE;
DROP FUNCTION IF EXISTS update_account_mapping CASCADE;
DROP FUNCTION IF EXISTS delete_account_mapping CASCADE;
DROP FUNCTION IF EXISTS create_corresponding_journal CASCADE;
DROP FUNCTION IF EXISTS get_internal_counterparties_with_companies CASCADE;
```

## Performance Monitoring
Monitor RPC performance:
```sql
SELECT 
    query,
    calls,
    mean_exec_time,
    max_exec_time
FROM pg_stat_user_functions
WHERE schemaname = 'public'
AND funcname LIKE '%account_mapping%'
ORDER BY mean_exec_time DESC;
```

Target: All functions should execute in <500ms.