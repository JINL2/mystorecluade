# Time Table Manage - RPC Calls Summary

## Documentation Generated
This is a comprehensive analysis of all RPC (Remote Procedure Call) functions used in the time_table_manage feature.

**Generation Date:** November 26, 2024
**Source:** TimeTableDatasource class analysis
**Status:** Complete

---

## Files Included

1. **RPC_DOCUMENTATION.md** - Comprehensive 19KB reference
   - All 12 RPC functions with detailed specifications
   - Parameter structures and encoding standards
   - Response handling patterns
   - Error handling and security considerations
   - Direct database operations (bonus management, shift deletion)

2. **RPC_QUICK_REFERENCE.md** - Quick lookup guide 7.2KB
   - RPC functions at a glance
   - Parameter patterns and formatting
   - Datasource methods organized by operation type
   - Usage examples for common scenarios
   - Response handling patterns

---

## RPC Functions Overview

### Total RPC Functions: 12

#### Read Operations (7)
1. `get_shift_metadata` - Fetch shift configuration
2. `get_monthly_shift_status_manager` - Monthly statistics
3. `manager_shift_get_overview` - Dashboard overview
4. `manager_shift_get_cards` - Shift cards for date range
5. `manager_shift_get_schedule` - Available employees/shifts
6. `get_tags_by_card_id` - Tags for a shift card

#### Write Operations (5)
7. `insert_shift_schedule` - Create new shift
8. `manager_shift_insert_schedule` - Assign employee to shift
9. `manager_shift_input_card` - Update shift card data
10. `manager_shift_update_shift` - Update shift details
11. `toggle_shift_approval` - Approve/reject shift (single or bulk)
12. `manager_shift_delete_tag` - Delete shift tag

#### Non-RPC Database Operations (3)
- `deleteShift` - Direct DELETE on store_shifts table
- `addBonus` - Direct UPDATE on shift_requests table
- `updateBonusAmount` - Direct UPDATE on shift_requests table

---

## Key Parameter Patterns

### All IDs are Strings
```
p_store_id, p_company_id, p_user_id, p_manager_id, 
p_shift_id, p_shift_request_id, p_tag_id, p_card_id
```

### Date Formatting
```
Dates: 'yyyy-MM-dd' format (String)
Times: ISO 8601 UTC format (String)
```

### Common Parameter Types
```
Booleans:   p_is_late, p_is_problem_solved, p_new_approval_state
Integers:   p_target_count
Arrays:     p_tags, p_shift_request_ids
Optional:   p_shift_name, p_new_tag_content, p_new_tag_type
```

---

## Data Flow Pattern

1. **Presentation Layer** → Calls Repository methods
2. **Repository Layer** → Calls Datasource methods with parameters
3. **Datasource Layer** → Executes RPC call with params
4. **Supabase Server** → Processes RPC and returns response
5. **Datasource** → Validates response (null check, type check)
6. **Repository** → Converts response to DTO then Entity
7. **Presentation Layer** → Receives domain entity

---

## Response Type Handling

### Map Responses (8 functions)
```dart
if (response is Map<String, dynamic>) {
  return response;  // Ready for DTO conversion
}
if (response is List && response.isNotEmpty) {
  return response.first as Map;  // Extract first element
}
return {};  // Null/empty fallback
```

### List Responses (4 functions)
```dart
if (response is List) {
  return response;  // Return as-is or cast items
}
return [];  // Null/empty fallback
```

---

## Exception Mapping

| Operation | Exception Type |
|-----------|---|
| Metadata fetch | `ShiftMetadataException` |
| Status retrieval | `ShiftStatusException` |
| General operations | `TimeTableException` |
| Approval operations | `ShiftApprovalException` |
| Shift creation | `ShiftCreationException` |
| Shift deletion | `ShiftDeletionException` |
| Parameter validation | `InvalidShiftParametersException` |

---

## Bulk Operations Support

### Toggle Shift Approval - Bulk
```dart
// Single shift
params: {
  'p_shift_request_id': String,
  'p_new_approval_state': bool
}

// Multiple shifts
params: {
  'p_shift_request_ids': List<String>,
  'p_user_id': String
}
```

---

## Date Range Queries

Functions that accept date ranges:
- `manager_shift_get_overview` - startDate, endDate
- `manager_shift_get_cards` - startDate, endDate

Functions that accept single dates:
- `get_monthly_shift_status_manager` - requestDate
- `manager_shift_insert_schedule` - requestDate

---

## Response Transformation Examples

### Create Shift Flow
```
RPC Response (Map)
  ↓
ShiftDto.fromJson(response)
  ↓
ShiftDto.toEntity()
  ↓
Shift Entity (domain layer)
```

### Get Schedule Flow
```
RPC Response (Map with {store_employees, store_shifts})
  ↓
AvailableEmployeesDataDto.fromJson()
  ↓
AvailableEmployeesDataDto.toEntity()
  ↓
AvailableEmployeesData Entity
```

---

## Security & Scoping

1. **Store Scoping** - All queries filtered by `p_store_id`
2. **Company Scoping** - Overview/cards queries filtered by `p_company_id`
3. **User Context** - Some operations track user IDs for audit
4. **Authentication** - All calls use authenticated Supabase session
5. **Validation** - CreateShiftParams validates before RPC call

---

## Performance Characteristics

| Operation | Single/Bulk | Network Calls |
|-----------|---|---|
| Get metadata | Single | 1 |
| Get monthly status | Single | 1 |
| Get overview | Single | 1 |
| Get cards | Single | 1 |
| Get schedule | Single | 1 |
| Create shift | Single | 1 |
| Toggle approval | Single | 1 |
| Toggle approval | Bulk (N items) | 1 |
| Assign employee | Single | 1 |
| Input card | Single | 1 |
| Update shift | Single | 1 |
| Delete tag | Single | 1 |
| Get tags | Single | 1 |

---

## Testing Strategy

When writing tests for these RPC calls:

1. **Mock the SupabaseClient**
2. **Test null responses** - All datasource methods handle null
3. **Test type checking** - Response type validation logic
4. **Test DTOs** - fromJson conversion for each response type
5. **Test error cases** - Each exception type is thrown correctly
6. **Test parameter validation** - CreateShiftParams validation
7. **Test date formatting** - UTC conversion and formatting
8. **Test bulk operations** - Array parameter handling

---

## Integration Points

### With Repository Layer
- All datasource methods are called from repository
- Repository handles DTO → Entity conversion
- Repository adds additional business logic

### With Presentation Layer
- Use repository methods, not datasource directly
- Repository returns domain entities
- Presentation works with entities not DTOs

### With Supabase
- Uses `SupabaseClient.rpc()` method
- All parameters prefixed with `p_` (PostgreSQL convention)
- Returns dynamic responses that need type checking

---

## Related Files

**Datasource:**
- `/data/datasources/time_table_datasource.dart` - All RPC implementations

**Repository:**
- `/data/repositories/time_table_repository_impl.dart` - RPC calls through datasource

**Models:**
- `/data/models/freezed/` - DTOs for response conversion

**Domain:**
- `/domain/repositories/time_table_repository.dart` - Repository interface
- `/domain/entities/` - Domain entities returned to presentation

**Value Objects:**
- `/domain/value_objects/create_shift_params.dart` - Parameter validation

---

## Quick Links to Documentation

### For Specific RPC
1. Open `RPC_DOCUMENTATION.md`
2. Search for RPC function name
3. Find section with detailed specification
4. Check parameters, return type, and transformations

### For Quick Lookup
1. Open `RPC_QUICK_REFERENCE.md`
2. Find function in appropriate category
3. Check parameter patterns section
4. See usage example

### For Implementation
1. Check datasource method in `time_table_datasource.dart`
2. Check repository method in `time_table_repository_impl.dart`
3. Reference DTO in `data/models/freezed/`
4. Check entity in `domain/entities/`

---

## Notes & Observations

1. **Naming Convention** - All parameters use `p_` prefix (PostgreSQL standard)
2. **Type Safety** - Comprehensive null checking and type validation
3. **Error Handling** - Specific exceptions for different operations
4. **Batch Support** - `toggle_shift_approval` supports bulk operations
5. **Optional Parameters** - Uses Dart's conditional map inclusion `if (x != null)`
6. **Date Handling** - UTC conversion via `DateTimeUtils.toUtc()`
7. **Response Flexibility** - Handles both Map and List responses gracefully
8. **Direct DB Operations** - Some operations (bonus, delete) use direct table queries

---

## Version Information

- **Analysis Date:** 2024-11-26
- **Framework:** Flutter + Dart
- **Backend:** Supabase PostgreSQL
- **Client:** supabase_flutter
- **Architecture:** Clean Architecture (Datasource → Repository → Usecase → Presentation)

---

**Documentation Complete**
For detailed specifications, see `RPC_DOCUMENTATION.md`
For quick reference, see `RPC_QUICK_REFERENCE.md`

