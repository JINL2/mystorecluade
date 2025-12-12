# ⚡ Quick Start Guide - Time Table Manage

> Get started in 5 minutes - Most common tasks only

---

## 🎯 Find Quickly

| What I want to do | Where to modify | File path |
|-------------------|-----------------|-----------|
| 📱 Change UI | [UI Changes](#-ui-changes) | `presentation/widgets/` |
| 🔧 Modify Feature | [Feature Modification](#-feature-modification) | `domain/usecases/` |
| 🗄️ Add New Data | [Data Addition](#-adding-new-data) | `data/models/freezed/` |
| 🔌 Add API Call | [API Addition](#-adding-api-call) | `data/datasources/` |

---

## 📱 UI Changes

### Q: Change Calendar Design
```
📁 presentation/widgets/calendar/time_table_calendar.dart
```

### Q: Change Shift Card Design
```
Schedule tab: presentation/widgets/schedule/schedule_shift_card.dart
Manage tab:   presentation/widgets/manage/manage_shift_card.dart
```

### Q: Change Bottom Sheet
```
Add shift:    presentation/widgets/bottom_sheets/add_shift_bottom_sheet.dart
Shift details: presentation/widgets/bottom_sheets/shift_details_bottom_sheet.dart
```

---

## 🔧 Feature Modification

### Modify Approval Logic

**Step 1: Business Logic**
```dart
📁 domain/usecases/toggle_shift_approval.dart

// Modify approval conditions here
```

**Step 2: API Call**
```dart
📁 data/datasources/time_table_datasource.dart

Future<Map<String, dynamic>> toggleShiftApproval({
  required String shiftRequestId,
  required bool currentStatus,
}) async {
  // RPC call logic
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

**Step 3: UI**
```dart
📁 presentation/widgets/schedule/schedule_approve_button.dart

// Button design & behavior
```

---

## 🗄️ Adding New Data

### Add New Field from Database

**Example: Add `priority` field to ShiftCard**

**Step 1: Update DTO**
```dart
📁 data/models/freezed/shift_card_dto.dart

@freezed
class ShiftCardDto with _$ShiftCardDto {
  factory ShiftCardDto({
    required String shiftId,
    int? priority,  // ← NEW!
  }) = _ShiftCardDto;

  factory ShiftCardDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftCardDtoFromJson(json);
}
```

**Step 2: Update Entity**
```dart
📁 domain/entities/shift_card.dart

class ShiftCard {
  final String shiftId;
  final int? priority;  // ← NEW!

  ShiftCard({
    required this.shiftId,
    this.priority,
  });
}
```

**Step 3: Update Mapper**
```dart
📁 data/models/freezed/shift_card_dto_mapper.dart

extension ShiftCardDtoMapper on ShiftCardDto {
  ShiftCard toEntity() {
    return ShiftCard(
      shiftId: shiftId,
      priority: priority,  // ← NEW!
    );
  }
}
```

**Step 4: Regenerate Freezed**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔌 Adding API Call

### Add New RPC

**Example: Get shift statistics**

**Step 1: Add Datasource Method**
```dart
📁 data/datasources/time_table_datasource.dart

Future<Map<String, dynamic>> getShiftStatistics({
  required String storeId,
  required String month,
}) async {
  try {
    final response = await _supabase.rpc<dynamic>(
      'get_shift_statistics',  // ← New RPC name
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
📁 domain/repositories/time_table_repository.dart

Future<ShiftStatistics> getShiftStatistics({
  required String storeId,
  required String month,
});
```

**Step 3: Add Repository Implementation**
```dart
📁 data/repositories/time_table_repository_impl.dart

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
📁 domain/usecases/get_shift_statistics.dart

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
📁 presentation/providers/time_table_providers.dart

// UseCase Provider
final getShiftStatisticsUseCaseProvider = Provider<GetShiftStatistics>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetShiftStatistics(repository);
});

// Data Provider (FutureProvider)
final shiftStatisticsProvider = FutureProvider.family<ShiftStatistics, GetShiftStatisticsParams>(
  (ref, params) async {
    final useCase = ref.read(getShiftStatisticsUseCaseProvider);
    return await useCase(params);
  },
);
```

**Step 6: Use in UI**
```dart
// In widget
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

## 🎨 Common Tasks

### Regenerate Freezed
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Test Build
```bash
flutter build apk --debug
```

### Run Analyze
```bash
flutter analyze
```

---

## 🗂️ Folder Structure (Simplified)

```
time_table_manage/
│
├── data/
│   ├── datasources/          → API calls
│   ├── models/freezed/       → DTOs & Mappers
│   └── repositories/         → Repository implementation
│
├── domain/
│   ├── entities/             → Business models
│   ├── usecases/             → Business logic
│   ├── repositories/         → Repository interface
│   └── value_objects/        → Value objects
│
└── presentation/
    ├── pages/                → Main pages
    ├── providers/            → Riverpod providers
    └── widgets/              → UI components
        ├── bottom_sheets/
        ├── calendar/
        ├── common/
        ├── manage/
        ├── schedule/
        └── shift_details/
```

---

## ⚠️ Common Mistakes

### 1. Using `read` instead of `watch`
```dart
❌ final data = ref.read(myProvider);   // Won't detect changes
✅ final data = ref.watch(myProvider);  // Detects changes
```

### 2. UTC/Local Time Confusion
```dart
❌ final time = DateTime.parse(utcString);  // 9-hour difference
✅ final time = DateTimeUtils.toLocal(utcString);  // Correct
```

### 3. Forgetting Freezed Regeneration
```dart
After modifying DTOs, always run:
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Wrong Import Path
```dart
❌ import 'shift_card.dart';  // Relative path
✅ import '../../domain/entities/shift_card.dart';  // Correct path
```

---

## 🔍 Debugging Tips

### Check RPC Response
```dart
final response = await _supabase.rpc<dynamic>('my_rpc', params: {...});
print('📦 Response: $response');  // ← Check response
```

### Check Provider State
```dart
final myState = ref.watch(myProvider);
print('🔍 State: $myState');  // ← Check state
```

### Print Errors
```dart
try {
  // ...
} catch (e, stackTrace) {
  print('❌ Error: $e');
  print('📍 Stack: $stackTrace');
}
```

---

## 📚 More Information

- 📖 [README_EN.md](README_EN.md) - Complete guide
- 📁 [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) - Detailed folder structure

---

## 🚀 Getting Started

1. **Read README_EN.md** first (understand overall structure)
2. **Refer to QUICK_START_EN.md** while working (this file!)
3. **Find similar code** (refer to existing code)
4. **Ask questions** (check "Troubleshooting" section in README)

---

**Happy Coding! ⚡**
