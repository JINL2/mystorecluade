# Time Table Manage Feature

> Employee shift scheduling, approval, and management system

**Last Updated**: 2025-01-11
**Status**: ✅ Production Ready (Refactored & Optimized)

---

## 📚 Table of Contents

1. [Quick Navigation](#-quick-navigation)
2. [Folder Structure](#-folder-structure)
3. [Architecture](#-architecture)
4. [Modification Guide](#-modification-guide)
5. [Data Flow](#-data-flow)
6. [Key Components](#-key-components)
7. [State Management](#-state-management)
8. [Coding Conventions](#-coding-conventions)
9. [Troubleshooting](#-troubleshooting)

---

## 🎯 Quick Navigation

### What do you want to do?

| Task | Where to look | Path |
|------|---------------|------|
| Change UI | [UI Modification](#ui-modification) | `presentation/widgets/` |
| Modify Business Logic | [Logic Modification](#logic-modification) | `domain/usecases/` |
| Add New API Call | [API Addition](#adding-new-api-call) | `data/datasources/` |
| Add New Data Model | [Data Model](#adding-new-data-model) | `data/models/freezed/` |

---

## 📁 Folder Structure

### Overview

```
time_table_manage/
│
├── data/                     # Data Layer
│   ├── datasources/          # Supabase RPC calls
│   ├── models/
│   │   ├── converters/       # Data converters
│   │   └── freezed/          # DTOs & Mappers
│   └── repositories/         # Repository implementations
│
├── domain/                   # Domain Layer
│   ├── entities/             # Business entities
│   ├── repositories/         # Repository interfaces
│   ├── usecases/             # Business logic
│   ├── value_objects/        # Value objects
│   └── exceptions/           # Domain exceptions
│
└── presentation/             # Presentation Layer
    ├── pages/                # Main pages
    ├── providers/            # Riverpod providers
    └── widgets/              # UI components
        ├── bottom_sheets/
        ├── calendar/
        ├── common/
        ├── manage/
        ├── schedule/
        └── shift_details/
```

### File Count

| Layer | Files | Description |
|-------|-------|-------------|
| Data | 39 | Datasource (1) + DTOs (36) + Repository (1) + Converter (1) |
| Domain | 39 | Entities (15) + UseCases (17) + Repository (1) + Value Objects (5) + Exception (1) |
| Presentation | 37 | Pages (1) + Providers (6) + Widgets (30) |
| Auto-Generated | 38 | Freezed (.freezed.dart) + JSON (.g.dart) |
| **Total** | **157** | Active source files |

---

## 🏗 Architecture

### Clean Architecture (3 Layers)

```
┌────────────────────────────────────┐
│        PRESENTATION                │
│  Pages │ Widgets │ Providers       │
│         ↓                           │
└────────────────────────────────────┘
              ↓
┌────────────────────────────────────┐
│          DOMAIN                    │
│  Entities │ UseCases │ Repository  │
│                                    │
└────────────────────────────────────┘
              ↓
┌────────────────────────────────────┐
│           DATA                     │
│  DTOs │ Datasource │ Repository    │
│         ↓                           │
└────────────────────────────────────┘
              ↓
        [Supabase]
```

### Dependency Rules

| Layer | Depends On | Rule |
|-------|------------|------|
| Presentation | Domain | ✅ Can depend on Domain |
| Domain | None | ❌ No dependencies |
| Data | Domain | ✅ Can depend on Domain |

**Key Principle**: Dependencies point inward. Domain is independent.

---

## 🛠 Modification Guide

### UI Modification

#### Change Calendar Design

**File**: `presentation/widgets/calendar/time_table_calendar.dart`

**What you can modify**:
- Calendar layout
- Day cell styling
- Month navigation
- Date selection behavior

**Example**:
```dart
// In time_table_calendar.dart
Container(
  decoration: BoxDecoration(
    color: TossColors.white,  // ← Change background color
    borderRadius: BorderRadius.circular(12),  // ← Change radius
  ),
  // ...
)
```

---

#### Change Shift Card Design

**Files**:
- Schedule tab: `presentation/widgets/schedule/schedule_shift_card.dart`
- Manage tab: `presentation/widgets/manage/manage_shift_card.dart`

**What you can modify**:
- Card layout
- Text styles
- Badge colors
- Spacing

---

#### Change Bottom Sheet UI

**Files**:
- Add shift: `presentation/widgets/bottom_sheets/add_shift_bottom_sheet.dart`
- Shift details: `presentation/widgets/bottom_sheets/shift_details_bottom_sheet.dart`

---

### Logic Modification

#### Change Approval Logic

**1. Business Logic**
```dart
File: domain/usecases/toggle_shift_approval.dart

Future<ShiftApprovalResult> call(ToggleShiftApprovalParams params) async {
  // Modify approval conditions here
  return await _repository.toggleShiftApproval(
    shiftRequestId: params.shiftRequestId,
    currentStatus: params.currentStatus,
  );
}
```

**2. API Call**
```dart
File: data/datasources/time_table_datasource.dart

Future<Map<String, dynamic>> toggleShiftApproval({
  required String shiftRequestId,
  required bool currentStatus,
}) async {
  final response = await _supabase.rpc<dynamic>(
    'toggle_shift_approval',  // ← RPC name
    params: {
      'p_shift_request_id': shiftRequestId,
      'p_current_status': currentStatus,
    },
  );
  return response as Map<String, dynamic>;
}
```

**3. UI**
```dart
File: presentation/widgets/schedule/schedule_approve_button.dart

// Button behavior
onTap: () async {
  final useCase = ref.read(toggleShiftApprovalUseCaseProvider);
  await useCase(params);
}
```

---

### Adding New Data Model

#### Example: Add `priority` field to ShiftCard

**Step 1: Update DTO**
```dart
File: data/models/freezed/shift_card_dto.dart

@freezed
class ShiftCardDto with _$ShiftCardDto {
  factory ShiftCardDto({
    required String shiftId,
    int? priority,  // ← NEW FIELD
  }) = _ShiftCardDto;

  factory ShiftCardDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftCardDtoFromJson(json);
}
```

**Step 2: Update Entity**
```dart
File: domain/entities/shift_card.dart

class ShiftCard {
  final String shiftId;
  final int? priority;  // ← NEW FIELD

  ShiftCard({
    required this.shiftId,
    this.priority,
  });
}
```

**Step 3: Update Mapper**
```dart
File: data/models/freezed/shift_card_dto_mapper.dart

extension ShiftCardDtoMapper on ShiftCardDto {
  ShiftCard toEntity() {
    return ShiftCard(
      shiftId: shiftId,
      priority: priority,  // ← MAP NEW FIELD
    );
  }
}
```

**Step 4: Regenerate Freezed**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Adding New API Call

#### Example: Add `getShiftStatistics` RPC

**Step 1: Add Datasource Method**
```dart
File: data/datasources/time_table_datasource.dart

Future<Map<String, dynamic>> getShiftStatistics({
  required String storeId,
  required String month,
}) async {
  try {
    final response = await _supabase.rpc<dynamic>(
      'get_shift_statistics',  // ← RPC name in Supabase
      params: {
        'p_store_id': storeId,
        'p_month': month,
      },
    );
    return response as Map<String, dynamic>;
  } catch (e, stackTrace) {
    throw TimeTableException(
      'Failed to get shift statistics: $e',
      originalError: e,
      stackTrace: stackTrace,
    );
  }
}
```

**Step 2: Add Repository Interface**
```dart
File: domain/repositories/time_table_repository.dart

Future<ShiftStatistics> getShiftStatistics({
  required String storeId,
  required String month,
});
```

**Step 3: Implement Repository**
```dart
File: data/repositories/time_table_repository_impl.dart

@override
Future<ShiftStatistics> getShiftStatistics({
  required String storeId,
  required String month,
}) async {
  final data = await _datasource.getShiftStatistics(
    storeId: storeId,
    month: month,
  );
  final dto = ShiftStatisticsDto.fromJson(data);
  return dto.toEntity();
}
```

**Step 4: Create UseCase**
```dart
File: domain/usecases/get_shift_statistics.dart

class GetShiftStatistics implements UseCase<ShiftStatistics, GetShiftStatisticsParams> {
  final TimeTableRepository _repository;

  GetShiftStatistics(this._repository);

  @override
  Future<ShiftStatistics> call(GetShiftStatisticsParams params) async {
    return await _repository.getShiftStatistics(
      storeId: params.storeId,
      month: params.month,
    );
  }
}

class GetShiftStatisticsParams {
  final String storeId;
  final String month;

  const GetShiftStatisticsParams({
    required this.storeId,
    required this.month,
  });
}
```

**Step 5: Register Provider**
```dart
File: presentation/providers/time_table_providers.dart

final getShiftStatisticsUseCaseProvider = Provider<GetShiftStatistics>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetShiftStatistics(repository);
});

final shiftStatisticsProvider = FutureProvider.family<ShiftStatistics, GetShiftStatisticsParams>(
  (ref, params) async {
    final useCase = ref.read(getShiftStatisticsUseCaseProvider);
    return await useCase(params);
  },
);
```

**Step 6: Use in UI**
```dart
final statistics = ref.watch(
  shiftStatisticsProvider(
    GetShiftStatisticsParams(
      storeId: storeId,
      month: '2025-01',
    ),
  ),
);

statistics.when(
  data: (data) => Text('Total: ${data.total}'),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

---

## 🔄 Data Flow

### Read Flow (Fetching Data)

```
[UI Component]
    ↓ watch
[Provider]
    ↓ call
[UseCase]
    ↓ call
[Repository]
    ↓ call
[Datasource]
    ↓ RPC
[Supabase]
    ↓ JSON response
[DTO.fromJson()]
    ↓ toEntity()
[Entity]
    ↓ return
[Provider]
    ↓ rebuild
[UI Component]
```

### Write Flow (Modifying Data)

```
[UI Event (Button Tap)]
    ↓
[Event Handler]
    ↓ read
[UseCase Provider]
    ↓ call
[UseCase]
    ↓ call
[Repository]
    ↓ call
[Datasource]
    ↓ RPC
[Supabase]
    ↓ response
[Success/Error]
    ↓ update
[State Provider]
    ↓ rebuild
[UI Component]
```

---

## 🧩 Key Components

### 1. Main Page

**time_table_manage_page.dart** (574 lines)

**Structure**:
```dart
TossScaffold(
  appBar: TossAppBar1(),
  body: Column([
    AnimatedTabBar(),           // Tab switcher
    TabBarView([
      ManageTabView(),          // Manage tab
      ScheduleTabContent(),     // Schedule tab
    ]),
  ]),
  floatingActionButton: AiChatFab(),
)
```

**Responsibilities**:
- Tab navigation
- Date selection state
- Store selection state
- Filter state (for Manage tab)

---

### 2. Manage Tab

**manage_tab_view.dart**

**Features**:
- Monthly statistics dashboard
- Date picker
- Filter (All/Approved/Pending/Problem)
- Shift card list

**Data Sources**:
- `managerOverviewProvider` → Statistics
- `managerCardsProvider` → Shift cards

---

### 3. Schedule Tab

**schedule_tab_content.dart** (NEW - Extracted from God Widget)

**Features**:
- Store selector
- Monthly calendar
- Daily shift list
- Add shift FAB
- Bulk approval

**Data Sources**:
- `monthlyShiftStatusProvider` → Monthly status
- `shiftMetadataProvider` → Shift metadata

---

### 4. Bottom Sheets

#### add_shift_bottom_sheet.dart
- Purpose: Add new shift
- State: `AddShiftFormNotifier`
- Fields: Shift name, Start/End time, Employee selection

#### shift_details_bottom_sheet.dart
- Purpose: View/Edit shift details
- State: `ShiftDetailsFormNotifier`
- Tabs: Shift Info, Bonus Management

---

### 5. Calendar

**time_table_calendar.dart**

**Features**:
- Date selection
- Shift status indicators (dots)
- Month navigation

**Status Indicators**:
- Green dot: Approved shifts
- Orange dot: Pending shifts
- Red dot: Problem shifts

---

## 🔐 State Management

### Provider Types

| Provider Type | Use Case | Example |
|---------------|----------|---------|
| `Provider` | Immutable instances (UseCases, Repositories) | `getMonthlyShiftStatusUseCaseProvider` |
| `FutureProvider` | Async data fetching (read-only) | `monthlyShiftStatusProvider` |
| `StateNotifier` | Mutable state (forms, selections) | `addShiftFormProvider` |

### Provider Organization

**time_table_providers.dart**

```dart
// 1. Infrastructure
timeTableDatasourceProvider
timeTableRepositoryProvider

// 2. UseCases (16)
getMonthlyShiftStatusUseCaseProvider
getManagerOverviewUseCaseProvider
// ...

// 3. UI State
selectedDateProvider

// 4. Data State (Async)
shiftMetadataProvider
monthlyShiftStatusProvider
managerOverviewProvider
managerCardsProvider

// 5. Form State
addShiftFormProvider
shiftDetailsFormProvider
selectedShiftRequestsProvider
```

---

## 📋 Coding Conventions

### File Naming

```
✅ Good:
shift_card_dto.dart
shift_card.dart
get_monthly_shift_status.dart

❌ Bad:
ShiftCardDTO.dart        (PascalCase)
shift-card-dto.dart      (kebab-case)
scd.dart                 (abbreviation)
```

### Class Naming

```dart
// DTO
class ShiftCardDto { }              // Suffix: Dto

// Entity
class ShiftCard { }                 // No suffix

// UseCase
class GetMonthlyShiftStatus { }     // Verb + Noun

// Widget
class ScheduleShiftCard extends StatelessWidget { }  // Noun
```

### Import Order

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. External packages (alphabetical)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 4. Internal packages (relative path, alphabetical)
import '../../domain/entities/shift_card.dart';
import '../../domain/repositories/time_table_repository.dart';

// 5. Part files
part 'shift_card_dto.freezed.dart';
part 'shift_card_dto.g.dart';
```

### Documentation Comments

```dart
/// Class/method description (3 slashes)
///
/// Multiple lines allowed
class MyClass {
  // Regular comment (2 slashes)
  final String field;

  /// Method description
  ///
  /// [param1] - Parameter description
  /// [param2] - Parameter description
  ///
  /// Returns description
  void myMethod(String param1, int param2) {
    // Implementation
  }
}
```

---

## 🔍 Troubleshooting

### Q1: Build Error - "*.freezed.dart not found"

**Solution**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Q2: Provider Not Found Error

**Possible Causes**:
1. Provider not defined in `time_table_providers.dart`
2. Missing `ProviderScope` in main app

**Solution**:
Check provider registration and app wrapper.

---

### Q3: RPC Call Fails

**Checklist**:
1. ✅ RPC name correct?
2. ✅ Parameter names start with `p_`? (e.g., `p_store_id`)
3. ✅ RPC exists in Supabase?
4. ✅ Permissions configured?

**Debug**:
```dart
try {
  final response = await _supabase.rpc<dynamic>(
    'my_rpc_name',
    params: {'p_store_id': storeId},
  );
  print('Response: $response');  // ← Check response
} catch (e, stackTrace) {
  print('Error: $e');            // ← Check error
  print('StackTrace: $stackTrace');
}
```

---

### Q4: DTO to Entity Conversion Error

**Possible Causes**:
1. Missing mapper
2. Field name mismatch
3. Missing field in mapper

**Solution**:
Verify field names match in DTO, Entity, and Mapper.

```dart
// DTO
class ShiftCardDto {
  final String userName;  // ← Field name
}

// Entity
class ShiftCard {
  final String userName;  // ← Must match
}

// Mapper
extension ShiftCardDtoMapper on ShiftCardDto {
  ShiftCard toEntity() {
    return ShiftCard(
      userName: userName,  // ← Map it
    );
  }
}
```

---

### Q5: UI Not Updating

**Cause**: Using `ref.read` instead of `ref.watch`

**Solution**:
```dart
// ❌ Wrong - read only once
final data = ref.read(myProvider);

// ✅ Correct - watch for changes
final data = ref.watch(myProvider);
```

---

### Q6: Time Zone Issue (9-hour difference)

**Cause**: Missing UTC ↔ Local conversion

**Solution**: Use `DateTimeUtils`
```dart
import 'package:myfinance_improved/core/utils/datetime_utils.dart';

// UTC to Local
final localTime = DateTimeUtils.toLocal(utcString);

// Local to UTC
final utcTime = DateTimeUtils.toUtc(localString);

// Time Only
final timeOnly = DateTimeUtils.formatTimeOnly(dateTime);
```

---

## 📚 Additional Resources

### Related Documents
- **FOLDER_STRUCTURE.md** - Detailed folder structure
- **QUICK_START.md** - 5-minute quick start guide
- **DTO_VERIFICATION_REPORT.md** - DTO ↔ RPC mapping verification

### Supabase RPCs

| RPC Name | Description | Parameters |
|----------|-------------|------------|
| `get_monthly_shift_status_by_store` | Monthly shift status | `p_store_id` |
| `get_manager_overview` | Manager dashboard | `p_store_id`, `p_target_month` |
| `process_bulk_approval` | Bulk approval | `p_shift_request_ids`, `p_approval_states` |
| `create_shift` | Create shift | `p_store_id`, `p_shift_name`, `p_start_time`, `p_end_time` |
| `toggle_shift_approval` | Toggle approval | `p_shift_request_id`, `p_current_status` |

---

## 🎉 Recent Changes

### 2025-01-11
- ✅ God Widget refactoring (994 → 574 lines)
- ✅ Extracted `AnimatedTabBar` (reusable)
- ✅ Extracted `ScheduleTabContent` (Schedule tab)
- ✅ Extracted `ScheduleShiftDataSection` (Shift data section)
- ✅ Deleted deprecated models folder (18 files, 176KB+)
- ✅ Removed unused code (`insertShiftSchedule` method & UseCase)
- ✅ Build verification passed

### 2025-01-10
- ✅ Freezed DTO migration completed
- ✅ Strong typing applied (Map → Entity)
- ✅ Provider conversion completed

---

**Last Updated**: 2025-01-11
**Author**: Flutter Developer
**Version**: 2.0 (Refactored & Optimized)

**Happy Coding! 🚀**
