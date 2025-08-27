# Recent Activity Validation Guide

## Issue Identified
The Recent Activity section in the Debt Relationship page was showing incorrect transaction amounts because it wasn't properly handling Company vs Store perspectives.

## Root Causes Found

1. **Store ID Always Passed**: The original code always passed `selectedStore?['store_id']` to the RPC function, even in Company view
2. **Perspective Mismatch**: The debt summary showed Company view data, but transactions were fetched with Store filter
3. **Amount Calculation**: The transaction amount calculation wasn't properly handling the counterparty relationship

## Fixes Applied

### 1. Perspective Detection
```dart
// Determine perspective based on storeChoosen
final isStoreView = appState.storeChoosen.isNotEmpty;

// Pass store_id ONLY in Store view, NULL for Company view
'p_store_id': isStoreView ? appState.storeChoosen : null,
```

### 2. Debug Logging Added
The system now logs:
- Current perspective (Company/Store)
- Company ID being used
- Store ID (or NULL for Company-wide)
- Counterparty ID
- Transaction details as they're loaded

### 3. Amount Display Logic
- Uses the total transaction amount (since transactions are pre-filtered by counterparty)
- Determines receivable/payable based on which side the counterparty appears in journal lines
- Falls back to debit/credit comparison if counterparty not found in specific lines

## Testing Checklist

### Company View Test
1. Navigate to Debt Control page
2. Ensure NO store is selected (Company view)
3. Open a counterparty's debt relationship page
4. Check Recent Activity section
5. Verify in console logs:
   - `Perspective: Company`
   - `Store ID: NULL (Company-wide)`
6. Amounts should reflect ALL transactions across ALL stores

### Store View Test
1. Navigate to Debt Control page
2. Select a specific store
3. Open a counterparty's debt relationship page
4. Check Recent Activity section
5. Verify in console logs:
   - `Perspective: Store`
   - `Store ID: {actual-store-id}`
6. Amounts should reflect ONLY transactions for that specific store

### Validation Points
- [ ] Transaction amounts match the perspective (Company/Store)
- [ ] Green/Red indicators correctly show receivable/payable
- [ ] Date formatting is correct
- [ ] "View All" navigates to filtered transaction history
- [ ] Transaction history page shows same perspective filter

## Console Output Example
```
=== Recent Activity Loading ===
Perspective: Company
Company ID: 7a2545e0-e112-4b0c-9c59-221a530c4602
Store ID: NULL (Company-wide)
Counterparty ID: b6b24d9f-d8e8-4b76-87f9-35b8c5a05b9a
RPC Response received: Success
Transaction: test | Date: 2025-01-23 | Total: 213123.0
Transaction: test | Date: 2025-01-23 | Total: 20000.0
Transaction: test | Date: 2025-01-23 | Total: 1234234.0
Total transactions loaded: 3
```

## Expected Behavior

### Company View
- Shows transactions from ALL stores with the counterparty
- Amounts are company-wide totals
- No store filtering applied

### Store View  
- Shows transactions ONLY from the selected store
- Amounts are store-specific
- Store filter is applied to the query

## SQL Query Validation
You can validate the data by running this SQL directly:

```sql
-- Company View (all stores)
SELECT * FROM get_transaction_history(
  p_company_id := '7a2545e0-e112-4b0c-9c59-221a530c4602',
  p_store_id := NULL,  -- NULL for company-wide
  p_counterparty_id := 'b6b24d9f-d8e8-4b76-87f9-35b8c5a05b9a',
  p_limit := 5
);

-- Store View (specific store)
SELECT * FROM get_transaction_history(
  p_company_id := '7a2545e0-e112-4b0c-9c59-221a530c4602',
  p_store_id := 'd3dfa42c-9c18-46ed-8dbc-a6d67a2ab7ff',  -- Specific store
  p_counterparty_id := 'b6b24d9f-d8e8-4b76-87f9-35b8c5a05b9a',
  p_limit := 5
);
```

## Common Issues & Solutions

### Issue: Still showing wrong perspective
**Solution**: Check that `appState.storeChoosen` is properly cleared when switching to Company view

### Issue: No transactions showing
**Solution**: Verify the counterparty has transactions in the selected perspective

### Issue: Amounts don't match
**Solution**: Check the transaction's journal lines to understand the debit/credit flow