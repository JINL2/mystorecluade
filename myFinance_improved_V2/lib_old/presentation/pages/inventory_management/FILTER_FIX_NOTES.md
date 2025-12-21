# Inventory Filter Fix Implementation

## Issue Identified
1. The stock status filter was showing hardcoded Korean text options from metadata RPC
2. Stock status should only have 2 options: "normal" and "error" (for negative stock)
3. Filters were not actually filtering the products
4. "All" option was not working properly - filters were being applied immediately instead of when "Apply Filters" was tapped

## Changes Made

### 1. **Filter Bottom Sheet** (`inventory_management_page_v2.dart`)
- Replaced dynamic stock status options from metadata with hardcoded 2 options:
  - **Normal**: Shows products with stock >= 0
  - **Error (Negative Stock)**: Shows products with stock < 0
- Categories and Brands still use metadata from RPC
- **Fixed filter application logic**:
  - Added temporary state variables for modal selections
  - Filters are now only applied when "Apply Filters" button is tapped
  - "Clear All" button properly resets all selections to null
  - "All" option (null value) now correctly shows all products

### 2. **Filter Logic Implementation** (`inventory_providers.dart`)
- Added `_filterProducts()` method for client-side filtering
- Filters products by:
  - **Category**: Matches categoryId
  - **Brand**: Matches brandId  
  - **Stock Status**: 
    - "normal" → stock >= 0
    - "error" → stock < 0
- Applied filtering before sorting in data loading

### 3. **Service Layer Updates** (`inventory_service.dart`)
- Added filter parameters to `getInventoryPage()` for future backend support:
  - `categoryId`
  - `brandId`
  - `stockStatus`
- Currently these are passed but not used by backend (client-side filtering only)

## How It Works

### Filter Flow
1. User opens filter sheet and selects filters
2. Filter state is updated in provider
3. Provider calls `refresh()` to reload data
4. Data is fetched from backend (unfiltered)
5. **Client-side filtering is applied** using `_filterProducts()`
6. Sorting is applied to filtered results
7. Filtered and sorted products are displayed

### Stock Status Filter Logic
```dart
if (state.selectedStockStatus == 'error') {
  // Show only products with negative stock
  filteredProducts = filteredProducts.where((p) => p.stock < 0).toList();
} else if (state.selectedStockStatus == 'normal') {
  // Show only products with non-negative stock
  filteredProducts = filteredProducts.where((p) => p.stock >= 0).toList();
}
```

## Testing

1. **Stock Status Filter**:
   - Select "Normal" → Shows products with stock >= 0
   - Select "Error (Negative Stock)" → Shows only products with negative stock
   - Select "All" → Shows all products

2. **Category/Brand Filters**:
   - Work with metadata from RPC
   - Filter products by matching IDs

3. **Combined Filters**:
   - Multiple filters can be applied simultaneously
   - Filters are applied in order: Category → Brand → Stock Status

## Future Improvements

When backend supports filtering:
1. Remove client-side filtering logic
2. Backend will handle filtering via RPC parameters
3. Better performance with large datasets
4. More accurate pagination (current approach filters after fetching)

## Current Status
✅ Stock status filter shows only "Normal" and "Error" options
✅ Client-side filtering is working
✅ Negative stock products can be filtered
✅ All filters work together (category, brand, stock status)
✅ "All" option now works correctly to show all products
✅ Filters are only applied when "Apply Filters" is tapped (not immediately on selection)
⚠️ Backend filtering support needed for optimal performance