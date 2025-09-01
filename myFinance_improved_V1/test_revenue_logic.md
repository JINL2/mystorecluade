# Revenue Logic Test Documentation

## Fixed Issues

### 1. Company Revenue Consistency
**Problem**: Company revenue was becoming 0 when switching stores
**Solution**: 
- Modified `revenue_service.dart` to always pass `null` for `p_store_id` parameter
- This ensures we always get full company data with all stores
- Store-specific revenue is extracted from the response's `stores` array

### 2. Cache Management
**Problem**: Cache key included store ID, causing unnecessary fetches
**Solution**:
- Changed cache key from `${companyId}_${storeId}_${period}` to `${companyId}_${period}`
- Cache is now company-specific, not store-specific

### 3. State Management
**Problem**: Store changes were triggering full revenue refetch
**Solution**:
- Removed store listener that triggered `fetchRevenue()`
- Added new store listener that only triggers UI rebuild without fetching
- Company revenue stays consistent across all stores

## How It Works

1. **Initial Load**: When homepage loads, fetches revenue for the selected company
2. **Company Tab**: Shows total company revenue from the RPC response
3. **Store Tab**: Shows specific store revenue extracted from cached response
4. **Store Switch**: Only triggers UI update, uses cached data for new store
5. **Period Change**: Triggers new fetch for the selected period
6. **Company Change**: Triggers new fetch for the new company

## Expected Behavior

- Company revenue should remain the same when switching between stores
- Store revenue should update to show the selected store's data
- No new RPC calls when switching stores (uses cached data)
- New RPC calls only when changing company or period