# RPC Quick Reference - Time Table Manage Feature

## All RPC Functions at a Glance

### 1. Metadata & Configuration
| Function | Purpose | Params | Returns |
|----------|---------|--------|---------|
| `get_shift_metadata` | Fetch shift config | `p_store_id` | `dynamic` |

### 2. Status & Overview
| Function | Purpose | Params | Returns |
|----------|---------|--------|---------|
| `get_monthly_shift_status_manager` | Monthly stats | `p_store_id`, `p_request_date` | `List` |
| `manager_shift_get_overview` | Dashboard data | `p_start_date`, `p_end_date`, `p_store_id`, `p_company_id` | `Map` |
| `manager_shift_get_cards` | Shift cards | `p_start_date`, `p_end_date`, `p_store_id`, `p_company_id` | `Map` |

### 3. Shift Management
| Function | Purpose | Params | Returns |
|----------|---------|--------|---------|
| `insert_shift_schedule` | Create shift | `p_store_id`, `p_shift_date`, `p_plan_start_time`, `p_plan_end_time`, `p_target_count`, `p_tags` | `Map` |
| `manager_shift_update_shift` | Update shift | `p_shift_request_id`, + optional times/status | `Map` |
| `toggle_shift_approval` | Approve shift | `p_shift_request_id`, `p_new_approval_state` OR bulk with `p_shift_request_ids`, `p_user_id` | `Map`/`void` |

### 4. Employee & Schedule
| Function | Purpose | Params | Returns |
|----------|---------|--------|---------|
| `manager_shift_get_schedule` | Get employees/shifts | `p_store_id` | `Map` {store_employees, store_shifts} |
| `manager_shift_insert_schedule` | Assign employee | `p_user_id`, `p_shift_id`, `p_store_id`, `p_request_date`, `p_approved_by` | `Map` |

### 5. Card & Tag Management
| Function | Purpose | Params | Returns |
|----------|---------|--------|---------|
| `manager_shift_input_card` | Update shift card | `p_manager_id`, `p_shift_request_id`, `p_confirm_start_time`, `p_confirm_end_time`, `p_new_tag_content`, `p_new_tag_type`, `p_is_late`, `p_is_problem_solved` | `Map` |
| `get_tags_by_card_id` | Fetch tags | `p_card_id` | `List<Map>` |
| `manager_shift_delete_tag` | Delete tag | `p_tag_id`, `p_user_id` | `Map` |

---

## Parameter Patterns

### Date/Time
```dart
'p_request_date': 'yyyy-MM-dd'        // String format
'p_shift_date': 'yyyy-MM-dd'          // String format
'p_start_date': 'yyyy-MM-dd'          // String format
'p_end_date': 'yyyy-MM-dd'            // String format
'p_plan_start_time': '2024-11-26T08:00:00Z'  // ISO 8601 UTC
'p_plan_end_time': '2024-11-26T16:00:00Z'    // ISO 8601 UTC
```

### IDs
```dart
'p_store_id': 'string-uuid'
'p_company_id': 'string-uuid'
'p_user_id': 'string-uuid'
'p_manager_id': 'string-uuid'
'p_shift_id': 'string-uuid'
'p_shift_request_id': 'string-uuid'
'p_tag_id': 'string-uuid'
'p_card_id': 'string-uuid'
```

### Arrays
```dart
'p_tags': List<String>               // ['morning', 'weekend']
'p_shift_request_ids': List<String>  // Multiple IDs for bulk ops
```

### Booleans & Numbers
```dart
'p_new_approval_state': bool
'p_is_late': bool
'p_is_problem_solved': bool
'p_target_count': int
```

---

## Datasource Methods

### Read Operations
```dart
// Metadata
getShiftMetadata(storeId)
getMonthlyShiftStatus(requestDate, storeId)
getShiftMetadataRaw(storeId)

// Overview & Cards
getManagerOverview(startDate, endDate, companyId, storeId)
getManagerShiftCards(startDate, endDate, companyId, storeId)

// Schedule & Employees
getAvailableEmployees(storeId, shiftDate)
getScheduleData(storeId)
getTagsByCardId(cardId)
```

### Write Operations
```dart
// Create & Update
createShift(params: Map)
insertSchedule(userId, shiftId, storeId, requestDate, approvedBy)
updateShift(shiftRequestId, startTime?, endTime?, isProblemSolved?)
inputCard(managerId, shiftRequestId, confirmStartTime, confirmEndTime, newTagContent?, newTagType?, isLate, isProblemSolved)

// Delete & Toggle
deleteShift(shiftId)  // Direct DB operation
deleteShiftTag(tagId, userId)
toggleShiftApproval(shiftRequestId, newApprovalState)  // Single
processBulkApproval(shiftRequestIds, approvalStates)   // Multiple

// Bonus (Direct DB)
addBonus(shiftRequestId, bonusAmount, bonusReason)
updateBonusAmount(shiftRequestId, bonusAmount)
```

---

## Response Handling

### Map Responses
```dart
if (response == null) return {};
if (response is Map<String, dynamic>) return response;
if (response is List && response.isNotEmpty) return response.first as Map;
return {};
```

### List Responses
```dart
if (response == null) return [];
if (response is List) return response;
return [];
```

### Type Conversion
```dart
final dto = MyDto.fromJson(response);
final entity = dto.toEntity();
```

---

## Exception Types

```dart
ShiftMetadataException      // Metadata fetch
ShiftStatusException         // Status operations
TimeTableException          // General
ShiftApprovalException      // Approval operations
ShiftCreationException      // Create operations
ShiftDeletionException      // Delete operations
InvalidShiftParametersException  // Validation
```

---

## Usage Examples

### Create Shift
```dart
final params = CreateShiftParams(
  storeId: 'store_123',
  shiftDate: '2024-11-26',
  planStartTime: DateTime(2024, 11, 26, 8, 0),
  planEndTime: DateTime(2024, 11, 26, 16, 0),
  targetCount: 5,
  tags: ['morning'],
);
final result = await repository.createShift(params: params);
```

### Get Manager Overview
```dart
final overview = await repository.getManagerOverview(
  startDate: '2024-11-01',
  endDate: '2024-11-30',
  companyId: 'company_123',
  storeId: 'store_123',
);
```

### Toggle Approval
```dart
// Single
final result = await repository.toggleShiftApproval(
  shiftRequestId: 'shift_req_123',
  newApprovalState: true,
);

// Bulk
final result = await repository.processBulkApproval(
  shiftRequestIds: ['id1', 'id2', 'id3'],
  approvalStates: [true, true, false],
);
```

### Input Card
```dart
final result = await repository.inputCard(
  managerId: 'manager_123',
  shiftRequestId: 'shift_req_123',
  confirmStartTime: '2024-11-26T08:00:00Z',
  confirmEndTime: '2024-11-26T16:00:00Z',
  newTagContent: 'Arrived 15 min late',
  newTagType: 'attendance',
  isLate: true,
  isProblemSolved: false,
);
```

### Get Schedule
```dart
final schedule = await repository.getScheduleData(storeId: 'store_123');
// Returns: ScheduleData with employees and shifts
```

### Assign Employee
```dart
final result = await repository.insertSchedule(
  userId: 'user_123',
  shiftId: 'shift_123',
  storeId: 'store_123',
  requestDate: '2024-11-26',
  approvedBy: 'manager_456',
);
```

---

## Common Patterns

### Conditional Parameters
```dart
// In updateShift - only include non-null params
params: {
  'p_shift_request_id': shiftRequestId,
  if (startTime != null) 'p_start_time': startTime,
  if (endTime != null) 'p_end_time': endTime,
}
```

### Array Transformation
```dart
// Multiple items to list
final dtos = response
  .map((item) => MyDto.fromJson(item as Map<String, dynamic>))
  .toList();
```

### Grouping Data
```dart
// Group by month
final Map<String, List<Dto>> grouped = {};
for (final dto in dtos) {
  final month = dto.date.substring(0, 7);
  grouped.putIfAbsent(month, () => []).add(dto);
}
```

---

## Notes

- All dates in `yyyy-MM-dd` format
- All times in ISO 8601 UTC format
- All IDs are strings (typically UUIDs)
- Null responses return empty defaults
- Bulk operations use array parameters
- Optional parameters use `if` conditions
- Store/company scoping on all queries

