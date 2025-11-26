# Time Table Manage Feature - RPC Calls Documentation

## Overview
This document comprehensively documents all Supabase RPC calls used in the `time_table_manage` feature. All RPC calls are made through the `TimeTableDatasource` class and use the Supabase Flutter client.

---

## RPC Calls Summary

| # | RPC Function | Purpose | Parameters | Return Type |
|---|---|---|---|---|
| 1 | `get_shift_metadata` | Fetch shift configuration metadata | `p_store_id` | `dynamic` (List or Map) |
| 2 | `get_monthly_shift_status_manager` | Get monthly shift statistics | `p_store_id`, `p_request_date` | `List<dynamic>` |
| 3 | `manager_shift_get_overview` | Get manager dashboard overview | `p_start_date`, `p_end_date`, `p_store_id`, `p_company_id` | `Map<String, dynamic>` |
| 4 | `manager_shift_get_cards` | Get shift cards for date range | `p_start_date`, `p_end_date`, `p_store_id`, `p_company_id` | `Map<String, dynamic>` |
| 5 | `toggle_shift_approval` | Toggle shift request approval status | `p_shift_request_id`, `p_new_approval_state` OR `p_shift_request_ids`, `p_user_id` | `Map<String, dynamic>` or `void` |
| 6 | `insert_shift_schedule` | Create new shift | Dynamic params from `CreateShiftParams` | `Map<String, dynamic>` |
| 7 | `manager_shift_delete_tag` | Delete a shift tag | `p_tag_id`, `p_user_id` | `Map<String, dynamic>` |
| 8 | `manager_shift_insert_schedule` | Assign employee to shift | `p_user_id`, `p_shift_id`, `p_store_id`, `p_request_date`, `p_approved_by` | `Map<String, dynamic>` |
| 9 | `manager_shift_input_card` | Input shift card data with tags | `p_manager_id`, `p_shift_request_id`, `p_confirm_start_time`, `p_confirm_end_time`, `p_new_tag_content`, `p_new_tag_type`, `p_is_late`, `p_is_problem_solved` | `Map<String, dynamic>` |
| 10 | `manager_shift_get_schedule` | Get available employees and shifts | `p_store_id` | `Map<String, dynamic>` |
| 11 | `manager_shift_update_shift` | Update shift details | `p_shift_request_id`, `p_start_time` (optional), `p_end_time` (optional), `p_is_problem_solved` (optional) | `Map<String, dynamic>` |
| 12 | `get_tags_by_card_id` | Get tags for a shift card | `p_card_id` | `List<Map<String, dynamic>>` |

---

## Detailed RPC Call Specifications

### 1. GET_SHIFT_METADATA
**Purpose:** Fetch shift configuration metadata for a specific store

**Function Location:** `TimeTableDatasource.getShiftMetadata()`

**Parameters:**
```dart
{
  'p_store_id': String  // Required: Store identifier
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'get_shift_metadata',
  params: {
    'p_store_id': storeId,
  },
);
```

**Return Type:** `dynamic` (List or Map)

**Error Handling:** `ShiftMetadataException`

**Data Transformation:**
- Returns metadata about shift configurations
- Converted to `List<ShiftMetadataDto>` in repository layer
- Maps to `ShiftMetadata` entity

---

### 2. GET_MONTHLY_SHIFT_STATUS_MANAGER
**Purpose:** Get monthly shift status/statistics for manager view

**Function Location:** `TimeTableDatasource.getMonthlyShiftStatus()`

**Parameters:**
```dart
{
  'p_store_id': String,      // Required: Store identifier
  'p_request_date': String   // Required: Date in format 'yyyy-MM-dd'
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'get_monthly_shift_status_manager',
  params: {
    'p_store_id': storeId,
    'p_request_date': requestDate,
  },
);
```

**Return Type:** `List<dynamic>`

**Error Handling:** `ShiftStatusException`

**Data Transformation:**
- Converts each item to `MonthlyShiftStatusDto`
- Groups results by month (yyyy-MM)
- Aggregates statistics (total_required, total_approved, total_pending)
- Maps to `List<MonthlyShiftStatus>` entities

---

### 3. MANAGER_SHIFT_GET_OVERVIEW
**Purpose:** Get comprehensive manager dashboard overview with statistics

**Function Location:** `TimeTableDatasource.getManagerOverview()`

**Parameters:**
```dart
{
  'p_start_date': String,    // Required: Start date 'yyyy-MM-dd'
  'p_end_date': String,      // Required: End date 'yyyy-MM-dd'
  'p_store_id': String,      // Required: Store identifier
  'p_company_id': String     // Required: Company identifier
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'manager_shift_get_overview',
  params: {
    'p_start_date': startDate,
    'p_end_date': endDate,
    'p_store_id': storeId,
    'p_company_id': companyId,
  },
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `TimeTableException`

**Data Transformation:**
- If response is List, takes first element as Map
- Converts to `ManagerOverviewDto`
- Maps to `ManagerOverview` entity

**Expected Response Structure:**
- Contains overview statistics for the specified date range
- Store and company specific data

---

### 4. MANAGER_SHIFT_GET_CARDS
**Purpose:** Get shift cards (detailed shift records) for a date range

**Function Location:** `TimeTableDatasource.getManagerShiftCards()`

**Parameters:**
```dart
{
  'p_start_date': String,    // Required: Start date 'yyyy-MM-dd'
  'p_end_date': String,      // Required: End date 'yyyy-MM-dd'
  'p_store_id': String,      // Required: Store identifier
  'p_company_id': String     // Required: Company identifier
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'manager_shift_get_cards',
  params: {
    'p_start_date': startDate,
    'p_end_date': endDate,
    'p_store_id': storeId,
    'p_company_id': companyId,
  },
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `TimeTableException`

**Data Transformation:**
- Converts response to `ManagerShiftCardsDto`
- Maps to `ManagerShiftCards` entity with context (storeId, startDate, endDate)

**Expected Response Structure:**
- Contains array of shift cards
- Each card has shift request details, employee info, timing, status

---

### 5. TOGGLE_SHIFT_APPROVAL
**Purpose:** Toggle/update shift request approval status

**Function Location:** 
- `TimeTableDatasource.toggleShiftApproval()` - Single shift
- `TimeTableDatasource.processBulkApproval()` - Multiple shifts

**Parameters (Single Shift):**
```dart
{
  'p_shift_request_id': String,       // Required: Shift request ID
  'p_new_approval_state': bool        // Required: Approval state (true/false)
}
```

**Parameters (Bulk Approval):**
```dart
{
  'p_shift_request_ids': List<String>, // Required: Array of shift request IDs
  'p_user_id': String                  // Required: Current user ID
}
```

**Example Calls:**
```dart
// Single shift
final response = await _supabase.rpc<dynamic>(
  'toggle_shift_approval',
  params: {
    'p_shift_request_id': shiftRequestId,
    'p_new_approval_state': newApprovalState,
  },
);

// Bulk approval
await _supabase.rpc<dynamic>(
  'toggle_shift_approval',
  params: {
    'p_shift_request_ids': shiftRequestIds,
    'p_user_id': userId,
  },
);
```

**Return Type:** 
- Single: `Map<String, dynamic>`
- Bulk: `void` (returns null)

**Error Handling:** `ShiftApprovalException`

**Data Transformation:**
- Single: Converts to `ShiftApprovalResultDto` → `ShiftApprovalResult` entity
- Bulk: Manually constructs result with success count and processed IDs

---

### 6. INSERT_SHIFT_SCHEDULE
**Purpose:** Create a new shift with complete configuration

**Function Location:** `TimeTableDatasource.createShift()`

**Parameters:**
```dart
// From CreateShiftParams.toJson()
{
  'p_store_id': String,              // Required: Store ID
  'p_shift_date': String,            // Required: Date 'yyyy-MM-dd'
  'p_plan_start_time': String,       // Required: UTC datetime
  'p_plan_end_time': String,         // Required: UTC datetime
  'p_target_count': int,             // Required: Number of employees needed
  'p_tags': List<String>,            // Required: Array of tag strings
  'p_shift_name': String?            // Optional: Custom shift name
}
```

**Example Call:**
```dart
final params = CreateShiftParams(
  storeId: 'store_123',
  shiftDate: '2024-11-26',
  planStartTime: DateTime(2024, 11, 26, 8, 0),
  planEndTime: DateTime(2024, 11, 26, 16, 0),
  targetCount: 5,
  tags: ['morning', 'weekend'],
  shiftName: 'Morning Shift',
);

final response = await _supabase.rpc<dynamic>(
  'insert_shift_schedule',
  params: params.toJson(),
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `ShiftCreationException`, `InvalidShiftParametersException`

**Validation:**
- Store ID must not be empty
- Shift date must not be empty
- End time must be after start time
- Target count must be > 0

**Data Transformation:**
- Converts to `ShiftDto`
- Maps to `Shift` entity

**Time Handling:**
- Times are converted to UTC using `DateTimeUtils.toUtc()`

---

### 7. MANAGER_SHIFT_DELETE_TAG
**Purpose:** Delete a shift tag associated with a shift card

**Function Location:** `TimeTableDatasource.deleteShiftTag()`

**Parameters:**
```dart
{
  'p_tag_id': String,      // Required: Tag identifier
  'p_user_id': String      // Required: User performing deletion
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'manager_shift_delete_tag',
  params: {
    'p_tag_id': tagId,
    'p_user_id': userId,
  },
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `TimeTableException`

**Data Transformation:**
- Converts to `OperationResultDto`
- Maps to `OperationResult` entity

---

### 8. MANAGER_SHIFT_INSERT_SCHEDULE
**Purpose:** Assign an employee to a shift (insert schedule record)

**Function Location:** `TimeTableDatasource.insertSchedule()`

**Parameters:**
```dart
{
  'p_user_id': String,         // Required: Employee user ID
  'p_shift_id': String,        // Required: Shift ID
  'p_store_id': String,        // Required: Store ID
  'p_request_date': String,    // Required: Request date 'yyyy-MM-dd'
  'p_approved_by': String      // Required: Manager/approver user ID
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'manager_shift_insert_schedule',
  params: {
    'p_user_id': userId,
    'p_shift_id': shiftId,
    'p_store_id': storeId,
    'p_request_date': requestDate,
    'p_approved_by': approvedBy,
  },
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `TimeTableException`

**Data Transformation:**
- Converts to `OperationResultDto`
- Maps to `OperationResult` entity

**Context:** Used when assigning employees to shifts, with approval tracking

---

### 9. MANAGER_SHIFT_INPUT_CARD
**Purpose:** Input/update shift card data including confirmed times and tags

**Function Location:** `TimeTableDatasource.inputCard()`

**Parameters:**
```dart
{
  'p_manager_id': String,           // Required: Manager user ID
  'p_shift_request_id': String,     // Required: Shift request ID
  'p_confirm_start_time': String,   // Required: Confirmed start time
  'p_confirm_end_time': String,     // Required: Confirmed end time
  'p_new_tag_content': String?,     // Optional: Tag content/description
  'p_new_tag_type': String?,        // Optional: Tag type (category)
  'p_is_late': bool,                // Required: Whether employee was late
  'p_is_problem_solved': bool       // Required: Whether issue was resolved
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'manager_shift_input_card',
  params: {
    'p_manager_id': managerId,
    'p_shift_request_id': shiftRequestId,
    'p_confirm_start_time': confirmStartTime,
    'p_confirm_end_time': confirmEndTime,
    'p_new_tag_content': newTagContent,
    'p_new_tag_type': newTagType,
    'p_is_late': isLate,
    'p_is_problem_solved': isProblemSolved,
  },
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `TimeTableException`

**Data Transformation:**
- Converts to `CardInputResultDto`
- Maps to `CardInputResult` entity

**Context:** Comprehensive shift card update including:
- Actual times worked (vs planned times)
- Tag creation (issues, notes, categories)
- Attendance status (late/on-time)
- Problem resolution status

---

### 10. MANAGER_SHIFT_GET_SCHEDULE
**Purpose:** Get available employees and shifts for scheduling/assignment

**Function Location:** 
- `TimeTableDatasource.getAvailableEmployees()`
- `TimeTableDatasource.getScheduleData()`

**Parameters:**
```dart
{
  'p_store_id': String    // Required: Store identifier
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'manager_shift_get_schedule',
  params: {
    'p_store_id': storeId,
  },
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `TimeTableException`

**Expected Response Structure:**
```dart
{
  'store_employees': List<dynamic>,  // Available employees
  'store_shifts': List<dynamic>      // Available shifts
}
```

**Data Transformation:**
- For `getAvailableEmployees()`: Maps response keys:
  - `store_employees` → `employees`
  - `store_shifts` → `shifts`
  - Returns `AvailableEmployeesData` entity

- For `getScheduleData()`: Converts to `ScheduleDataDto`
  - Returns `ScheduleData` entity with storeId context

**Context:** Used for:
- Employee selector when assigning shifts
- Schedule management interface
- Availability checking

---

### 11. MANAGER_SHIFT_UPDATE_SHIFT
**Purpose:** Update shift request details (times, problem status)

**Function Location:** `TimeTableDatasource.updateShift()`

**Parameters:**
```dart
{
  'p_shift_request_id': String,     // Required: Shift request ID
  'p_start_time': String?,          // Optional: New start time
  'p_end_time': String?,            // Optional: New end time
  'p_is_problem_solved': bool?      // Optional: Problem resolution status
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'manager_shift_update_shift',
  params: {
    'p_shift_request_id': shiftRequestId,
    if (startTime != null) 'p_start_time': startTime,
    if (endTime != null) 'p_end_time': endTime,
    if (isProblemSolved != null) 'p_is_problem_solved': isProblemSolved,
  },
);
```

**Return Type:** `Map<String, dynamic>`

**Error Handling:** `TimeTableException`

**Data Transformation:**
- Converts to `ShiftRequestDto`
- Maps to `ShiftRequest` entity

**Notes:**
- Uses conditional parameter inclusion (only sends non-null values)
- Allows partial updates

---

### 12. GET_TAGS_BY_CARD_ID
**Purpose:** Retrieve all tags associated with a specific shift card

**Function Location:** `TimeTableDatasource.getTagsByCardId()`

**Parameters:**
```dart
{
  'p_card_id': String    // Required: Shift card identifier
}
```

**Example Call:**
```dart
final response = await _supabase.rpc<dynamic>(
  'get_tags_by_card_id',
  params: {
    'p_card_id': cardId,
  },
);
```

**Return Type:** `List<Map<String, dynamic>>`

**Error Handling:** `TimeTableException`

**Data Transformation:**
- Each item converted to `TagDto`
- Maps to `Tag` entity
- Returns `List<Tag>`

**Context:** Used to retrieve and display tags/notes associated with shift cards

---

## Direct Database Operations (Non-RPC)

These operations bypass RPC and use direct Supabase table operations:

### DELETE SHIFT
```dart
await _supabase
  .from('store_shifts')
  .delete()
  .eq('shift_id', shiftId);
```
**Purpose:** Delete a shift directly from store_shifts table
**Error Handling:** `ShiftDeletionException`

### ADD BONUS (Direct Update)
```dart
await _supabase
  .from('shift_requests')
  .update({
    'bonus_amount': bonusAmount,
    'bonus_reason': bonusReason,
  })
  .eq('shift_request_id', shiftRequestId);
```
**Purpose:** Add or update bonus amount for a shift request
**Return:** Success result constructed manually
**Error Handling:** `TimeTableException`

### UPDATE BONUS AMOUNT (Direct Update)
```dart
await _supabase
  .from('shift_requests')
  .update({'bonus_amount': bonusAmount})
  .eq('shift_request_id', shiftRequestId);
```
**Purpose:** Update bonus amount for a shift request
**Error Handling:** `TimeTableException`

---

## Parameter Encoding Standards

### Date/Time Formatting
- **Dates:** `yyyy-MM-dd` format (ISO 8601)
- **Times:** UTC datetime strings (handled by `DateTimeUtils.toUtc()`)
- **Date Range:** Separate start and end date parameters

### Data Types
- **IDs:** Strings (UUIDs or formatted identifiers)
- **Counts:** Integers
- **Flags:** Booleans
- **Collections:** Lists of appropriate types
- **Timestamps:** ISO 8601 formatted UTC strings

### Null Handling
- Optional parameters are conditionally included in request params
- Null parameters are omitted from the params Map using `if` conditions
- Server-side defaults apply when parameters are omitted

---

## Error Handling Pattern

All RPC calls follow consistent error handling:

```dart
try {
  final response = await _supabase.rpc<dynamic>(
    'function_name',
    params: {...},
  );
  
  // Handle null response
  if (response == null) {
    return {}; // or [] or default value
  }
  
  // Type checking and conversion
  if (response is Map<String, dynamic>) {
    return response;
  }
  
  return {}; // Fallback
} catch (e, stackTrace) {
  throw SpecificException(
    'Failed to operation: $e',
    originalError: e,
    stackTrace: stackTrace,
  );
}
```

**Exception Types:**
- `ShiftMetadataException` - Metadata fetch failures
- `ShiftStatusException` - Status retrieval failures
- `TimeTableException` - General timesheet failures
- `ShiftApprovalException` - Approval toggle failures
- `ShiftCreationException` - Shift creation failures
- `ShiftDeletionException` - Shift deletion failures

---

## Response Handling Patterns

### Type Resolution
```dart
// Pattern 1: Map response
if (response is Map<String, dynamic>) {
  return response;
}

// Pattern 2: List response (take first element)
if (response is List && response.isNotEmpty) {
  return response.first as Map<String, dynamic>;
}

// Pattern 3: List of items
if (response is List) {
  return response.cast<Map<String, dynamic>>();
}

// Pattern 4: Generic dynamic
return response;
```

### DTO Conversion Pattern
```dart
// Response from RPC
final data = await datasource.getRpc();

// Convert to DTO
final dto = MyDto.fromJson(data);

// Convert DTO to entity
final entity = dto.toEntity();

// Return entity
return entity;
```

---

## Security Considerations

1. **User Context:** Some RPCs include user IDs for audit trails
2. **Store/Company Scoping:** All queries filtered by store_id and/or company_id
3. **Authentication:** All calls use authenticated Supabase session
4. **Null Safety:** Comprehensive null checking for all responses
5. **Parameter Validation:** CreateShiftParams includes validation before RPC call

---

## Performance Notes

1. **Batch Operations:** `toggle_shift_approval` supports bulk IDs in single call
2. **Date Filtering:** Monthly/range queries limited to specific date ranges
3. **Response Caching:** No explicit caching at datasource level
4. **Network Calls:** Each function is one RPC call (except bulk operations)

---

## Testing Considerations

When testing these RPC calls:
1. Mock the Supabase client
2. Ensure parameter objects are properly JSON serializable
3. Test both success and null response cases
4. Validate exception throwing on errors
5. Test date/time formatting compliance

