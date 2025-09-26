# Inventory Sorting Fix Implementation

## Issues Identified
1. Initial issue: Sorting parameters were not being passed to the backend service
2. Regression issue: After adding sorting parameters, the product list stopped loading because the backend doesn't support sorting parameters yet
3. Final issue: Even with UI selection, products weren't actually sorted because backend doesn't apply sorting

## Changes Made (with Backward Compatibility)

### 1. **InventoryService** (`lib/data/services/inventory_service.dart`)
- Added `sortBy` and `sortDirection` optional parameters to `getInventoryPage()` method
- Implemented backward compatibility:
  - First tries to call RPC with sorting parameters if sorting is requested
  - If the call fails (backend doesn't support), falls back to calling without sorting
  - This ensures the product list loads even if backend doesn't support sorting yet

### 2. **InventoryPageNotifier** (`lib/presentation/pages/inventory_management/providers/inventory_providers.dart`)
- Changed `sortBy` and `sortDirection` from required String to nullable String?
- Removed default values ('name', 'asc') to prevent always sending sorting params
- Updated `loadInitialData()` to pass sorting state to service
- Updated `loadNextPage()` to pass sorting state to service
- Updated `clearFilters()` to reset sorting to null instead of defaults
- **Added client-side sorting**: Implemented `_sortProducts()` method that sorts products in memory
- Applied sorting after fetching data in both `loadInitialData()` and `loadNextPage()`
- Supports sorting by: name, price, stock, created_at (with ascending/descending)

### 3. **InventoryManagementPageV2** (`lib/presentation/pages/inventory_management/inventory_management_page_v2.dart`)
- Changed `_sortBy` and `_sortDirection` from String to nullable String?
- Updated sort sheet to handle null values properly
- Updated `_getSortLabel()` to show default label when no sorting is set
- Fixed sort option selection to set default direction when first selected

## Backend Requirements

⚠️ **IMPORTANT**: The backend Supabase RPC function `get_inventory_page` needs to be updated to:

1. Accept the new parameters:
   - `p_sort_by` (text) - Column to sort by: 'name', 'price', 'stock', 'created_at'
   - `p_sort_direction` (text) - Sort direction: 'asc' or 'desc'

2. Apply sorting to the query based on these parameters

### Example Backend Function Update (PostgreSQL)

```sql
CREATE OR REPLACE FUNCTION get_inventory_page(
  p_company_id UUID,
  p_store_id UUID,
  p_page INTEGER DEFAULT 1,
  p_limit INTEGER DEFAULT 10,
  p_search TEXT DEFAULT '',
  p_sort_by TEXT DEFAULT 'name',
  p_sort_direction TEXT DEFAULT 'asc'
)
RETURNS JSON AS $$
DECLARE
  v_offset INTEGER;
  v_total_count INTEGER;
  v_order_clause TEXT;
BEGIN
  -- Calculate offset
  v_offset := (p_page - 1) * p_limit;
  
  -- Build dynamic ORDER BY clause
  v_order_clause := CASE p_sort_by
    WHEN 'name' THEN 'p.name'
    WHEN 'price' THEN 'p.sale_price'
    WHEN 'stock' THEN 'p.on_hand'
    WHEN 'created_at' THEN 'p.created_at'
    ELSE 'p.name'
  END;
  
  IF p_sort_direction = 'desc' THEN
    v_order_clause := v_order_clause || ' DESC';
  ELSE
    v_order_clause := v_order_clause || ' ASC';
  END IF;
  
  -- Your existing query logic with dynamic ORDER BY
  -- ...
  
END;
$$ LANGUAGE plpgsql;
```

## Testing the Fix

1. **Verify Backend Support**: Check if the Supabase RPC function accepts the new parameters
2. **Test Sorting Options**:
   - Name (A-Z / Z-A)
   - Price (Low to High / High to Low)
   - Stock (Low to High / High to Low)
   - Date Added (Newest / Oldest)

## UI Flow (Current Implementation with Client-Side Sorting)
1. User taps on sort filter button
2. Bottom sheet appears with sort options
3. User selects a sort option (e.g., "Price")
4. User can toggle direction with arrows
5. Provider updates state and refreshes data
6. Service fetches products from backend (unsorted)
7. **Provider applies client-side sorting to the fetched products**
8. UI displays sorted products

## Client-Side Sorting Implementation

The app now sorts products on the client side after fetching them from the backend:

```dart
// Sorting is applied in InventoryPageNotifier after fetching data
final sortedProducts = _sortProducts(result.products);
```

Supported sort fields:
- **Name**: Alphabetical order (A-Z or Z-A)
- **Price**: Numeric comparison of product prices
- **Stock**: Numeric comparison of stock quantities
- **Date Added**: Chronological order based on createdAt timestamp

## Current Status
✅ Frontend implementation complete with backward compatibility
✅ Product list loads correctly even without backend support
✅ Sorting UI is ready and functional
✅ **Client-side sorting is now working** - products are sorted in the app
ℹ️ Sorting happens on the client side until backend support is added
⚠️ Backend function can be updated for server-side sorting (optional, for better performance with large datasets)
ℹ️ When backend is updated, server-side sorting will be used automatically