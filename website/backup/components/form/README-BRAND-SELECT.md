# Enhanced TossSelect with Brand Management

This document explains how to use the enhanced TossSelect component with integrated "+ Add brand" functionality.

## Overview

The TossSelect component has been extended with:
- **Brand-specific footer actions** that add a "+ Add brand" option
- **AddBrandModal integration** for seamless brand creation
- **Automatic dropdown refresh** after brand creation
- **Error handling** for duplicate brands and network issues
- **Real-time validation** with proper UX feedback

## Components

### 1. TossSelect (Enhanced)
**File**: `toss-select.js`

New options added:
- `isBrandDropdown: boolean` - Enables brand-specific features
- `companyId: string|number` - Required company ID for brand creation
- `onBrandAdded: function` - Callback when new brand is successfully created
- `footerActions: array` - Custom footer actions (alternative to brand-specific behavior)

### 2. AddBrandModal
**Files**: `add-brand-modal.js`, `add-brand-modal.css`

Features:
- Clean, focused interface for brand creation
- Real-time validation with proper UX feedback
- Automatic brand code generation (optional)
- Error handling for duplicate brands
- Integration with Supabase RPC calls
- Loading states and proper accessibility

## Usage

### Basic Brand Dropdown Setup

```javascript
const brandSelect = new TossSelect({
    containerId: 'brand-select-container',
    name: 'brand',
    label: 'Brand',
    placeholder: 'Select a brand',
    required: true,
    searchable: true,
    options: brandOptions,
    
    // Enable brand dropdown features
    isBrandDropdown: true,
    companyId: selectedCompanyId, // Must be set
    
    onChange: (value, option) => {
        console.log('Brand selected:', option);
        // Handle brand selection
    },
    
    onBrandAdded: (brandData, selectInstance) => {
        console.log('New brand created:', brandData);
        // Refresh metadata, show success message, etc.
        refreshInventoryMetadata();
    }
});

brandSelect.init();
```

### Complete Example with Company Selection

```javascript
// Company select
const companySelect = new TossSelect({
    containerId: 'company-select-container',
    name: 'company',
    options: companyOptions,
    onChange: (value, option) => {
        // Update brand select with company ID
        brandSelect.options.companyId = value;
        brandSelect.enable();
    }
});

// Brand select with add functionality
const brandSelect = new TossSelect({
    containerId: 'brand-select-container',
    name: 'brand',
    options: brandOptions,
    disabled: true, // Enable after company selection
    
    // Brand-specific options
    isBrandDropdown: true,
    companyId: null, // Will be set by company select
    
    onBrandAdded: async (brandData) => {
        // Refresh the inventory metadata
        await refreshInventoryMetadata();
        
        // Show success notification
        showSuccessToast(`Brand "${brandData.brand_name}" created successfully!`);
    }
});

// Initialize both
companySelect.init();
brandSelect.init();
```

## AddBrandModal API

### Constructor Options

```javascript
const modal = new AddBrandModal({
    companyId: 123,                    // Required: Company ID
    onBrandAdded: (brandData) => {},   // Required: Success callback
    onError: (error) => {}             // Optional: Error callback
});
```

### Brand Data Structure

The `onBrandAdded` callback receives:

```javascript
{
    brand_id: 123,
    brand_name: "User Input",
    brand_code: "AUTO_GEN", // or user input
    company_id: 456,
    created_at: "2024-01-01T00:00:00.000Z"
}
```

## RPC Integration

The modal calls the `inventory_create_brand` Supabase RPC function:

```sql
-- Expected RPC function signature
CREATE OR REPLACE FUNCTION inventory_create_brand(
    p_company_id INTEGER,
    p_brand_name TEXT,
    p_brand_code TEXT DEFAULT NULL
) RETURNS TABLE (
    brand_id INTEGER,
    brand_name TEXT,
    brand_code TEXT,
    company_id INTEGER,
    created_at TIMESTAMPTZ
) AS $$
-- Function implementation
$$ LANGUAGE plpgsql;
```

### Error Handling

The modal handles these error scenarios:
- **DUPLICATE_BRAND**: Shows user-friendly error message
- **Network errors**: Shows retry message
- **Validation errors**: Real-time field validation
- **Missing company ID**: Prevents modal opening

## Styling

### CSS Files Required

```html
<!-- Core styles -->
<link rel="stylesheet" href="toss-select.css">
<link rel="stylesheet" href="toss-modal.css">
<link rel="stylesheet" href="toss-input.css">
<link rel="stylesheet" href="add-brand-modal.css">
```

### Customization

The modal follows Toss design system conventions and can be customized via CSS variables:

```css
:root {
    --toss-primary: #0064FF;
    --toss-error: #DC2626;
    --toss-success: #16A34A;
    /* ... other variables */
}
```

## Integration with Metadata System

After successful brand creation, you should refresh the inventory metadata:

```javascript
async function refreshInventoryMetadata() {
    try {
        // Call your metadata refresh function
        const newMetadata = await getInventoryMetadata();
        
        // Update all relevant dropdowns
        updateBrandDropdown(newMetadata.brands);
        updateCategoryDropdown(newMetadata.categories);
        // etc.
    } catch (error) {
        console.error('Failed to refresh metadata:', error);
    }
}
```

## Development and Testing

### Mock Mode

The component includes mock responses for development:

```javascript
// Automatically uses mock when on localhost
if (window.location.hostname === 'localhost') {
    // Mock responses active
}
```

### Testing Duplicate Brands

To test duplicate brand error handling, try creating a brand with the name "test duplicate".

## Accessibility Features

- **Keyboard navigation**: Full keyboard support
- **ARIA labels**: Proper screen reader support
- **Focus management**: Logical focus flow
- **Error announcements**: Validation errors are announced
- **High contrast support**: Respects user preferences

## Browser Support

- Modern browsers (Chrome 70+, Firefox 65+, Safari 12+, Edge 79+)
- Mobile browsers with touch support
- Keyboard-only navigation support

## Troubleshooting

### Common Issues

1. **"Company ID is required" error**
   - Ensure `companyId` is set before user tries to add brand
   - Check that company selection updates brand select properly

2. **Modal doesn't appear**
   - Verify TossModal is loaded before AddBrandModal
   - Check for console errors

3. **RPC call failures**
   - Verify Supabase client is available
   - Check RPC function exists and has correct signature
   - Ensure user has proper permissions

4. **Brand not appearing in dropdown**
   - Verify the success callback updates the options
   - Check that `updateDisplay()` is called
   - Ensure proper data format

### Debug Mode

Enable debug logging:

```javascript
const brandSelect = new TossSelect({
    // ... options
    debug: true // Enables console logging
});
```

## Performance Considerations

- The modal creates DOM elements on demand
- Form validation runs on input events (debounced)
- RPC calls include proper error handling and timeouts
- Memory cleanup on modal destroy

## Security Notes

- All user input is validated client-side and server-side
- XSS protection through proper HTML escaping
- SQL injection prevention through parameterized RPC calls
- Proper error message handling (no sensitive data exposure)