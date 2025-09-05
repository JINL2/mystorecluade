# Filter Component Storage Fix Summary

## Problem
The store filter in the balance sheet page was not showing stores from the selected company because it was looking for data in the wrong storage location.

## Root Cause
- **TossFilter component** (used in balance sheet) was incorrectly using `sessionStorage` with keys:
  - `selectedCompanyId`
  - `userData`
  
- **TossIncomeStatementFilter component** (used in income statement) was correctly using `localStorage` with keys:
  - `companyChoosen` (for selected company ID)
  - `user` (for user and companies data)

## Solution
Updated the `TossFilter` component in `/components/form/toss-filter.js` to:
1. Use `localStorage.getItem('user')` instead of `sessionStorage.getItem('userData')`
2. Use `localStorage.getItem('companyChoosen')` instead of `sessionStorage.getItem('selectedCompanyId')`

## Data Structure
The correct data structure stored in `localStorage` under the 'user' key:
```javascript
{
  user_id: "uuid",
  user_first_name: "string",
  user_last_name: "string",
  companies: [
    {
      company_id: "uuid",
      company_name: "string",
      stores: [
        {
          store_id: "uuid",
          store_name: "string"
        }
      ],
      role: { /* role data */ }
    }
  ]
}
```

## Testing
1. Open the test page at `/test-filter-storage.html`
2. Click "Setup Test Data" to create sample data in localStorage
3. Click "Test Filter Components" to verify the filter logic works
4. Navigate to the balance sheet page and verify the store dropdown shows the correct stores

## Affected Pages
- ✅ **Balance Sheet** (`/pages/finance/balance-sheet/`) - Fixed
- ✅ **Income Statement** (`/pages/finance/income-statement/`) - Already working correctly

## Key Files Modified
- `/components/form/toss-filter.js` - Updated `loadStores()` method

## Verification Steps
1. Select a company in the application
2. Navigate to the Balance Sheet page
3. Open the filter section
4. Verify that the Store dropdown shows:
   - "All Stores" as the first option
   - All stores belonging to the selected company with their names

## Important Notes
- The filter correctly sets `store_id` as the value for each store option
- "All Stores" option has a value of `"null"` (string) which gets converted to actual `null` when submitting filters
- Both filter components now use the same consistent localStorage approach