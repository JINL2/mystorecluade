# UUID Currency Selection Fix

## 🐛 Problem Identified

**Error**: `invalid input syntax for type uuid: "vnd"`

The system was attempting to pass a currency code ("vnd") instead of a UUID to the `update_user_salary` RPC function's `p_currency_id` parameter.

## 🔍 Root Cause Analysis

### Issue 1: Fallback Currency IDs
The `getFallbackCurrencies()` function was using simple strings like 'vnd', 'usd' instead of proper UUID format:

```javascript
// ❌ BEFORE - Invalid UUID format
{ currency_id: 'vnd', currency_code: 'VND', currency_name: 'Vietnamese Dong', currency_symbol: '₫' }

// ✅ AFTER - Proper UUID format
{ currency_id: '93f9bc80-eb8c-4e3e-b214-50db1699b7b6', currency_code: 'VND', currency_name: 'Vietnamese Dong', currency_symbol: '₫' }
```

### Issue 2: Fallback Trigger Scenarios
Fallback currencies are used when:
1. Company has no currencies configured in `company_currencies` table
2. Supabase connection error
3. Selected company has no company_id set

## ✅ Solutions Implemented

### 1. Fixed Fallback Currency UUIDs
```javascript
getFallbackCurrencies() {
    // Fallback currencies with proper UUID format
    return [
        { currency_id: '00000000-0000-0000-0000-000000000001', currency_code: 'USD', currency_name: 'US Dollar', currency_symbol: '$' },
        { currency_id: '00000000-0000-0000-0000-000000000002', currency_code: 'EUR', currency_name: 'Euro', currency_symbol: '€' },
        { currency_id: '00000000-0000-0000-0000-000000000003', currency_code: 'GBP', currency_name: 'British Pound', currency_symbol: '£' },
        { currency_id: '93f9bc80-eb8c-4e3e-b214-50db1699b7b6', currency_code: 'VND', currency_name: 'Vietnamese Dong', currency_symbol: '₫' },
        { currency_id: '00000000-0000-0000-0000-000000000005', currency_code: 'KRW', currency_name: 'Korean Won', currency_symbol: '₩' }
    ];
}
```

**Note**: Used the actual VND UUID `93f9bc80-eb8c-4e3e-b214-50db1699b7b6` from the employee data provided.

### 2. Added UUID Validation
```javascript
// Validate UUID format before RPC call
const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
if (!uuidRegex.test(selectedCurrencyId)) {
    console.error('Invalid currency UUID format:', selectedCurrencyId);
    this.showAlert(`Invalid currency selection. Please refresh the page and try again.`, 'error');
    return;
}
```

### 3. Enhanced Debugging
```javascript
console.log('✅ Loaded company-specific currencies:', this.currencies);

// Validate that all currencies have proper UUIDs
const invalidCurrencies = this.currencies.filter(c => 
    !c.currency_id || 
    !c.currency_id.match(/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i)
);
if (invalidCurrencies.length > 0) {
    console.warn('⚠️ Found currencies with invalid UUIDs:', invalidCurrencies);
}
```

## 🧪 Testing Scenarios

### Scenario 1: Normal Operation (Company has currencies configured)
```javascript
// Expected flow:
1. loadCurrencies() → company_currencies query succeeds
2. Returns currencies with proper UUIDs from database
3. Employee edit modal shows currencies with UUID values
4. Save operation uses proper UUID
5. RPC call succeeds
```

### Scenario 2: Fallback Mode (No company currencies configured)
```javascript
// Expected flow:
1. loadCurrencies() → company_currencies query returns empty array
2. System uses fallback currencies with proper UUID format
3. Employee edit modal shows fallback currencies
4. Save operation uses fallback UUID (e.g., VND: 93f9bc80-eb8c-4e3e-b214-50db1699b7b6)
5. RPC call succeeds IF the UUID exists in currency_types table
```

### Scenario 3: Error Prevention
```javascript
// If somehow an invalid UUID gets through:
1. UUID validation regex catches invalid format
2. Shows user-friendly error message
3. Prevents RPC call with invalid data
4. User can refresh page to reload proper currencies
```

## 🎯 Console Debug Output

### Success Case
```
✅ Loaded company-specific currencies: [
  { currency_id: "93f9bc80-eb8c-4e3e-b214-50db1699b7b6", currency_code: "VND", ... }
]
Setting currency dropdown for employee: {
  employeeCurrencyId: "93f9bc80-eb8c-4e3e-b214-50db1699b7b6",
  employeeCurrencyCode: "VND"
}
✅ Currency set by currency_id: 93f9bc80-eb8c-4e3e-b214-50db1699b7b6
```

### Fallback Case
```
⚠️ No currencies configured for this company, using fallback currencies with proper UUIDs
Currency dropdown populated with 5 options
✅ Currency set by currency_id: 93f9bc80-eb8c-4e3e-b214-50db1699b7b6
```

### Error Prevention
```
❌ Invalid currency UUID format: vnd
ERROR: Invalid currency selection. Please refresh the page and try again.
```

## 🔧 Database Requirements

### For Production Use
The fallback UUIDs should match actual records in the `currency_types` table:

```sql
-- Ensure these UUIDs exist in currency_types table
INSERT INTO currency_types (currency_id, currency_code, currency_name, currency_symbol) VALUES 
('00000000-0000-0000-0000-000000000001', 'USD', 'US Dollar', '$'),
('93f9bc80-eb8c-4e3e-b214-50db1699b7b6', 'VND', 'Vietnamese Dong', '₫'),
-- ... other currencies
```

### Company Currency Configuration
Ensure companies have proper currency associations:

```sql
-- Link company to available currencies
INSERT INTO company_currencies (company_id, currency_id) VALUES 
('ebd66ba7-fde7-4332-b6b5-0d8a7f615497', '93f9bc80-eb8c-4e3e-b214-50db1699b7b6');
```

## 🎉 Expected Results

After this fix:
1. ✅ No more "invalid input syntax for type uuid" errors
2. ✅ Currency dropdown always shows proper UUID values
3. ✅ RPC calls succeed with valid UUID parameters
4. ✅ Fallback currencies use proper UUID format
5. ✅ Validation prevents invalid UUID submission
6. ✅ Better error messages for debugging

The system now handles both database-loaded currencies and fallback currencies with proper UUID validation throughout the entire flow.