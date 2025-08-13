# 📊 Route Mapping Table

> **REFERENCE**: Complete mapping of all routes in the system. Check here BEFORE adding new routes.

**Last Updated**: 2025-01-10

---

## ✅ Active Routes

| Supabase Route | GoRouter Path | Page Class | Category | Status |
|----------------|---------------|------------|----------|--------|
| `attendance` | `/attendance` | `AttendanceMainPage` | HR | ✅ Active |
| `timetableManage` | `/timetableManage` | `TimeTableManagePage` | HR | ✅ Active |
| `employeeSetting` | `/employeeSetting` | `EnhancedEmployeeSettingPage` | HR | ✅ Active |
| `delegateRolePage` | `/delegateRolePage` | `DelegateRolePage` | HR | ✅ Active |
| `rolePermissionPage` | `/rolePermissionPage` | `RolePermissionPage` | HR | ✅ Active |
| `storeShiftSetting` | `/storeShiftSetting` | `StoreShiftPage` | HR | ✅ Active |
| `timetable` | `/timetable` | `TimetablePage` | HR | ✅ Active |
| `cashEnding` | `/cashEnding` | `CashEndingPage` | Finance | ✅ Active |
| `journalInput` | `/journalInput` | `JournalInputPage` | Finance | ✅ Active |
| `balanceSheet` | `/balanceSheet` | `BalanceSheetPage` | Finance | ✅ Active |
| `registerCounterparty` | `/registerCounterparty` | `CounterPartyPage` | Finance | ✅ Active |
| `addFixAsset` | `/addFixAsset` | `AddFixAssetPage` | Finance | ✅ Active |

---

## 🔴 Routes in Supabase but NOT in Router

| Supabase Route | Expected Path | Status | Action Needed |
|----------------|---------------|--------|---------------|
| `incomeStatement` | `/incomeStatement` | ❌ Missing | Add to app_router.dart |
| `cashControl` | `/cashControl` | ❌ Missing | Add to app_router.dart |
| `transactionHistory` | `/transactionHistory` | ❌ Missing | Add to app_router.dart |
| `myPage` | `/myPage` | ❌ Missing | Add to app_router.dart |
| `surveyDashboard` | `/surveyDashboard` | ❌ Missing | Add to app_router.dart |
| `accountMapping` | `/accountMapping` | ❌ Missing | Add to app_router.dart |
| `debtControl` | `/debtControl` | ❌ Missing | Add to app_router.dart |

---

## 🟡 Inconsistent Naming

| Current Route | Should Be | Reason |
|--------------|-----------|---------|
| `delegateRolePage` | `delegateRole` | Remove 'Page' suffix |
| `rolePermissionPage` | `rolePermission` | Remove 'Page' suffix |
| `storeShiftSetting` | `storeShift` | Simplify name |
| `registerCounterparty` | `counterParty` | Simplify name |

---

## 📁 File Locations

### Router File
```
/lib/presentation/app/app_router.dart
```

### Page Files
```
/lib/presentation/pages/
├── attendance/attendance_main_page.dart
├── time_table_manage/time_table_manage_page.dart
├── employee_setting/enhanced_employee_setting_page.dart
├── delegate_role/delegate_role_page.dart
├── role_permission/role_permission_page.dart
├── store_shift/store_shift_page.dart
├── timetable/timetable_page.dart
├── cash_ending/cash_ending_page.dart
├── journal_input/journal_input_page.dart
├── balance_sheet/balance_sheet_page.dart
├── counter_party/counter_party_page.dart
└── add_fix_asset/add_fix_asset_page.dart
```

---

## 🔧 How to Fix Missing Routes

### For each missing route:

1. **Create the page file**:
```bash
/lib/presentation/pages/[feature]/[feature]_page.dart
```

2. **Add to router**:
```dart
// In app_router.dart
import '../pages/[feature]/[feature]_page.dart';

// In routes array
GoRoute(
  path: '[featureRoute]',
  builder: (context, state) => const [Feature]Page(),
),
```

3. **Test the route**:
- Check feature appears in menu
- Click navigates correctly
- No errors in console

---

## 📋 Pre-Addition Checklist

Before adding a new route:
```yaml
□ Check this table - does route already exist?
□ Follow naming convention (camelCase, no 'Page')
□ Route doesn't conflict with existing ones
□ Category is appropriate
□ Icon URL is valid
```

---

## 🚀 Quick SQL Queries

### Get all routes from Supabase:
```sql
SELECT 
  f.route,
  f.feature_name,
  c.category_name
FROM features f
JOIN categories c ON f.category_id = c.category_id
ORDER BY c.category_name, f.route;
```

### Check for duplicate routes:
```sql
SELECT route, COUNT(*) 
FROM features 
GROUP BY route 
HAVING COUNT(*) > 1;
```

### Find features without routes:
```sql
SELECT feature_name 
FROM features 
WHERE route IS NULL OR route = '';
```

---

**NOTE**: This table should be updated whenever routes are added or modified.