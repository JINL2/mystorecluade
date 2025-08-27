# Currency Dropdown Implementation - Employee Settings

## Overview
The currency dropdown in the employee edit modal now queries the Supabase `currency_types` table to dynamically populate available currencies, properly handles currency_id as the value, and sets the correct default selection based on the employee's current currency.

## Implementation Details

### 1. Database Integration
**Table**: `currency_types`
**Columns Used**:
- `currency_id` (UUID) - Primary key, used as dropdown value
- `currency_code` (text) - e.g., "USD", "VND", "EUR"
- `currency_name` (text) - e.g., "US Dollar", "Vietnamese Dong"
- `currency_symbol` (text) - e.g., "$", "₫", "€"

### 2. Loading Currencies from Supabase
```javascript
async loadCurrencies() {
    const { data, error } = await supabase
        .from('currency_types')
        .select('currency_id, currency_code, currency_name, currency_symbol')
        .order('currency_code');
    
    if (data && data.length > 0) {
        this.currencies = data;
    }
    
    this.updateCurrencyDropdown();
}
```

### 3. Populating the Dropdown
The dropdown now:
- Uses `currency_id` (UUID) as the option value
- Displays format: "USD - US Dollar ($)"
- Stores `currency_code` in `data-currency-code` attribute for reference

```javascript
updateCurrencyDropdown() {
    const currencySelect = document.getElementById('editCurrency');
    currencySelect.innerHTML = '';
    
    this.currencies.forEach(currency => {
        const option = document.createElement('option');
        option.value = currency.currency_id; // UUID as value
        option.dataset.currencyCode = currency.currency_code;
        option.textContent = `${currency.currency_code} - ${currency.currency_name} (${currency.currency_symbol})`;
        currencySelect.appendChild(option);
    });
}
```

### 4. Setting Default Value
When opening the edit modal, the system:
1. First tries to select by `currency_id` if available
2. Falls back to finding by `currency_code` if needed
3. Updates the currency symbol display accordingly

```javascript
if (employee.currencyId) {
    currencySelect.value = employee.currencyId;
} else {
    // Fallback: find by currency_code
    const optionByCode = Array.from(currencySelect.options).find(
        opt => opt.dataset.currencyCode === employee.currencyCode
    );
    if (optionByCode) {
        currencySelect.value = optionByCode.value;
    }
}
```

### 5. Saving Changes
When saving employee changes, the system now:
- Retrieves the selected `currency_id` from the dropdown value
- Also captures the `currency_code` for reference
- Includes both in the update payload

```javascript
const selectedCurrencyId = currencySelect.value; // currency_id
const selectedOption = currencySelect.options[currencySelect.selectedIndex];
const selectedCurrencyCode = selectedOption.dataset.currencyCode;

const updatePayload = {
    currency_id: selectedCurrencyId, // UUID for database
    currency_code: selectedCurrencyCode, // For reference
    // ... other fields
};
```

## Features Implemented

### ✅ Dynamic Currency Loading
- Queries `currency_types` table on page load
- Caches currencies for efficient reuse
- Fallback to hardcoded currencies if database fails

### ✅ Proper UUID Handling
- Uses `currency_id` (UUID) as the primary identifier
- Maintains backward compatibility with `currency_code`
- Stores both for flexibility

### ✅ Smart Default Selection
- Automatically selects employee's current currency
- Handles both `currency_id` and `currency_code` matching
- Updates currency symbol display when selection changes

### ✅ User Experience
- Shows readable format: "VND - Vietnamese Dong (₫)"
- Live currency symbol updates when changing selection
- Maintains all existing functionality

## Data Flow

1. **Page Load**: 
   - `loadInitialData()` → `loadCurrencies()` → Queries Supabase
   - Populates dropdown with available currencies

2. **Edit Employee**:
   - Click edit button → `showEditEmployeeModal()`
   - Ensures currencies are loaded
   - Sets dropdown to employee's current `currency_id`

3. **Change Currency**:
   - User selects new currency
   - Symbol updates immediately
   - Both `currency_id` and `currency_code` tracked

4. **Save Changes**:
   - Retrieves selected `currency_id`
   - Prepares update payload with UUID
   - Ready for Supabase update

## Testing

To verify the implementation:

1. **Check Currency Loading**:
   ```javascript
   // In browser console
   employeeSettingsPage.currencies
   // Should show array of currencies from database
   ```

2. **Check Dropdown Population**:
   - Open edit modal for any employee
   - Dropdown should show currencies like "VND - Vietnamese Dong (₫)"

3. **Check Default Selection**:
   - Edit an employee with VND currency
   - Dropdown should automatically select "VND - Vietnamese Dong (₫)"

4. **Check Save Payload**:
   - Edit employee and change currency
   - Check console for update payload
   - Should show proper `currency_id` (UUID)

## Example Data Structure

### From Supabase:
```json
{
    "currency_id": "93f9bc80-eb8c-4e3e-b214-50db1699b7b6",
    "currency_code": "VND",
    "currency_name": "Vietnamese Dong",
    "currency_symbol": "₫"
}
```

### In Update Payload:
```json
{
    "currency_id": "93f9bc80-eb8c-4e3e-b214-50db1699b7b6",
    "currency_code": "VND",
    "salary_amount": 30000,
    "salary_type": "hourly"
}
```

## Benefits

1. **Data Integrity**: Uses proper UUID foreign keys
2. **Flexibility**: Supports dynamic currency list from database
3. **User-Friendly**: Shows readable currency names and symbols
4. **Maintainable**: Centralized currency management in database
5. **Backward Compatible**: Works with existing employee data structure