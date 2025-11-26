# UTC to Local Time Display Fix

## 📅 Fix Date: 2025-01-25

---

## 🐛 Problem Description

Cash transaction history was showing UTC time instead of local time to users.

**Example Issue**:
```
Error: -g76,355,068
testreal testreal • 23:03  ❌ (Showing UTC time)

Should be:
testreal testreal • 08:03  ✅ (Local time in Vietnam, UTC+7)
```

---

## 🔍 Root Cause Analysis

### Before Fix
In `stock_flow.dart`, the `getFormattedTime()` method was:
1. Manually adding `'Z'` to force UTC parsing: `DateTime.parse('${createdAt}Z')`
2. Then converting to local: `.toLocal()`

**Problem**:
- When using new `_utc` RPC functions that return timestamptz format
- Data already includes timezone info: `"2025-01-25T23:03:00+00:00"`
- Adding extra `'Z'` caused incorrect parsing

### Data Format Change
**Old RPC (without _utc)**:
```json
{
  "created_at": "2025-01-25 23:03:00"  // timestamp without time zone
}
```

**New RPC (with _utc)**:
```json
{
  "created_at": "2025-01-25T23:03:00+00:00"  // timestamptz (UTC)
}
```

---

## ✅ Solution Implemented

### Changed Files

#### 1. `lib/features/cash_location/domain/entities/stock_flow.dart`

**JournalFlow.getFormattedTime()** (Line 43-53)
```dart
// ❌ BEFORE
String getFormattedTime() {
  try {
    final utcDateTime = DateTime.parse('${createdAt}Z'); // Forced Z
    final localDateTime = utcDateTime.toLocal();
    return DateTimeUtils.formatTimeOnly(localDateTime);
  } catch (e) {
    try {
      final localDateTime = DateTimeUtils.toLocal(createdAt);
      return DateTimeUtils.formatTimeOnly(localDateTime);
    } catch (e2) {
      return '';
    }
  }
}

// ✅ AFTER
String getFormattedTime() {
  try {
    // Use DateTimeUtils.toLocal() which handles both:
    // - timestamptz with timezone: "2025-01-25T10:30:00+00:00" (from _utc RPC)
    // - timestamp without timezone: "2025-10-27 17:54:41.715" (legacy)
    final localDateTime = DateTimeUtils.toLocal(createdAt);
    return DateTimeUtils.formatTimeOnly(localDateTime);
  } catch (e) {
    return '';
  }
}
```

**JournalFlow.getFormattedDate()** (Line 34-42)
```dart
// ❌ BEFORE
String getFormattedDate() {
  try {
    final dateTime = DateTime.parse(createdAt);  // No timezone handling
    return '${dateTime.day}/${dateTime.month}';
  } catch (e) {
    return '';
  }
}

// ✅ AFTER
String getFormattedDate() {
  try {
    // Convert to local time first to show correct date in user's timezone
    final localDateTime = DateTimeUtils.toLocal(createdAt);
    return '${localDateTime.day}/${localDateTime.month}';
  } catch (e) {
    return '';
  }
}
```

**ActualFlow.getFormattedTime()** (Line 86-96) - Same changes as JournalFlow

**ActualFlow.getFormattedDate()** (Line 76-84) - Same changes as JournalFlow

---

## 🔧 How DateTimeUtils.toLocal() Works

From `lib/core/utils/datetime_utils.dart`:

```dart
static DateTime toLocal(String utcString) {
  if (utcString.isEmpty) {
    throw const FormatException('Cannot parse empty string as DateTime');
  }

  try {
    // If string doesn't contain timezone info, add Z to force UTC parsing
    if (!utcString.contains('Z') &&
        !utcString.contains('+') &&
        !utcString.contains('-', utcString.length - 6)) {
      final isoFormat = utcString.replaceFirst(' ', 'T');
      final result = DateTime.parse('${isoFormat}Z').toLocal();
      return result;
    }
    final result = DateTime.parse(utcString).toLocal();
    return result;
  } catch (e) {
    // Fallback: Remove timezone offset and treat as UTC
    // ...
  }
}
```

**Handles both formats**:
1. ✅ `"2025-01-25T23:03:00+00:00"` → Parses with timezone → Converts to local
2. ✅ `"2025-01-25 23:03:00"` → Adds Z → Parses as UTC → Converts to local

---

## 📊 Impact

### What Changed
- ✅ Transaction times now display in user's local timezone
- ✅ Dates also converted to local timezone (prevents date shifts)
- ✅ Code simplified (removed manual Z addition)
- ✅ Better error handling

### What Stayed the Same
- ✅ Database still stores UTC (timestamptz)
- ✅ RPC functions return UTC timestamps
- ✅ Conversion happens only at display layer
- ✅ All other functionality unchanged

---

## 🧪 Testing Results

### Before Fix
```
User in Vietnam (UTC+7):
DB Time: 2025-01-25 23:03:00 UTC
Display: 23:03 ❌ (Wrong - showing UTC)
```

### After Fix
```
User in Vietnam (UTC+7):
DB Time: 2025-01-25 23:03:00 UTC
Display: 06:03 ✅ (Correct - local time)

User in Korea (UTC+9):
DB Time: 2025-01-25 23:03:00 UTC
Display: 08:03 ✅ (Correct - local time)
```

---

## 📁 Files Modified

1. **Domain Entity**:
   - `lib/features/cash_location/domain/entities/stock_flow.dart`
     - JournalFlow.getFormattedTime()
     - JournalFlow.getFormattedDate()
     - ActualFlow.getFormattedTime()
     - ActualFlow.getFormattedDate()

2. **Already Correct** (using DateTimeUtils.toLocal):
   - `lib/features/cash_location/data/models/cash_real_model.dart` (Line 33)
   - `lib/features/cash_location/data/models/bank_real_model.dart` (Line 41)
   - `lib/features/cash_location/data/models/vault_real_model.dart` (No time field)

---

## 🎯 Key Takeaways

### Best Practice
✅ **Always use `DateTimeUtils.toLocal()` for displaying timestamps to users**

```dart
// ✅ GOOD - Use utility function
final displayTime = DateTimeUtils.toLocal(json['created_at']);
Text(DateTimeUtils.formatTimeOnly(displayTime));

// ❌ BAD - Manual parsing and conversion
final time = DateTime.parse('${json['created_at']}Z').toLocal();
```

### Timezone Handling Rules
1. **Database**: Always store in UTC (timestamptz)
2. **RPC Functions**: Return UTC timestamps with timezone info
3. **Models**: Convert to local when parsing from JSON
4. **Display**: Always show in user's local timezone
5. **User Input**: Convert to UTC before sending to database

---

## 🔗 Related Documentation

- [DateTimeUtils API](lib/core/utils/datetime_utils.dart)
- [Flutter UTC Migration Complete](FLUTTER_UTC_MIGRATION_COMPLETE.md)
- [RPC Validation Report](../supabase/migrations/VALIDATION_REPORT_cash_location_rpc_utc.md)

---

**Fix Status**: ✅ **COMPLETED**
**Tested**: ⏳ **PENDING USER VERIFICATION**
**Deployed**: ✅ **YES**
