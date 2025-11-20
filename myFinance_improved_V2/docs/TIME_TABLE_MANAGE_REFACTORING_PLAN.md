# Time Table Manage 기능 리팩토링 계획서

**프로젝트**: myFinance_improved_V2
**대상 기능**: time_table_manage
**작성일**: 2025-11-07
**예상 작업 기간**: 30-42시간 (5-7일)

---

## 📋 목차

1. [현황 분석](#1-현황-분석)
2. [문제점 요약](#2-문제점-요약)
3. [목표 아키텍처](#3-목표-아키텍처)
4. [폴더 구조 변화](#4-폴더-구조-변화)
5. [단계별 작업 계획](#5-단계별-작업-계획)
6. [파일별 상세 작업 목록](#6-파일별-상세-작업-목록)
7. [의존성 해결 순서](#7-의존성-해결-순서)
8. [작업 체크리스트](#8-작업-체크리스트)

---

## 1. 현황 분석

### 1.1 현재 폴더 구조

```
lib/features/time_table_manage/
├── data/                          (9 files)
│   ├── datasources/
│   │   └── time_table_datasource.dart
│   ├── models/                    (7 models)
│   └── repositories/
│       └── time_table_repository_impl.dart
│
├── domain/                        (13 files)
│   ├── entities/                  (7 entities)
│   ├── exceptions/
│   │   └── time_table_exceptions.dart
│   ├── repositories/
│   │   └── time_table_repository.dart
│   ├── usecases/                  [❌ EMPTY]
│   └── value_objects/             (4 files)
│
└── presentation/                  (35 files)
    ├── pages/
    │   └── time_table_manage_page.dart  (1,136 lines)
    ├── providers/
    │   └── time_table_providers.dart
    └── widgets/                   (30+ widgets)
```

**총 파일 수**: 57개

### 1.2 코드 통계

- **time_table_manage_page.dart**: 1,136줄 (과도하게 큼)
- **time_table_repository_impl.dart**: 543줄 (복잡한 변환 로직 포함)
- **State 변수**: 17개 (Page에 집중)
- **dynamic 타입**: 15개 위치에서 사용

---

## 2. 문제점 요약

### 🔴 Critical Issues (즉시 수정 필요)

#### Issue #1: Presentation → Datasource 직접 접근
**파일**: `presentation/pages/time_table_manage_page.dart:306`
```dart
// ❌ Layer Skipping
final rawData = await ref.read(timeTableDatasourceProvider)
    .getShiftMetadata(storeId: storeId);
```

**영향**:
- Repository의 에러 핸들링 우회
- Model to Entity 변환 로직 우회
- 캐싱, 로깅 등 횡단 관심사 처리 불가

---

#### Issue #2: Repository가 Map 반환 (Entity 대신)
**파일**: `domain/repositories/time_table_repository.dart`
**위반 메서드**: 13개

| 라인 | 메서드 | 현재 반환 타입 | 올바른 반환 타입 |
|------|--------|---------------|-----------------|
| 54 | getManagerShiftCards | Map<String, dynamic> | ManagerShiftCards |
| 67 | toggleShiftApproval | Map<String, dynamic> | ShiftApprovalResult |
| 77 | createShift | Map<String, dynamic> | Shift |
| 94 | deleteShiftTag | Map<String, dynamic> | OperationResult |
| 105 | getAvailableEmployees | Map<String, dynamic> | AvailableEmployeesData |
| 117 | insertShiftSchedule | Map<String, dynamic> | OperationResult |
| 128 | getScheduleData | Map<String, dynamic> | ScheduleData |
| 141 | insertSchedule | Map<String, dynamic> | OperationResult |
| 155 | processBulkApproval | Map<String, dynamic> | BulkApprovalResult |
| 168 | updateShift | Map<String, dynamic> | ShiftRequest |
| 187 | inputCard | Map<String, dynamic> | CardInputResult |
| 203 | getTagsByCardId | List<Map<String, dynamic>> | List<Tag> |
| 214 | addBonus | Map<String, dynamic> | OperationResult |

**영향**:
- Domain 레이어가 Data 레이어 구조에 의존 (DIP 위반)
- 타입 안전성 상실
- 컴파일 타임 에러 감지 불가

---

#### Issue #3: UseCase 레이어 완전 누락
**폴더**: `domain/usecases/` [비어있음]

**Presentation에서 Repository 직접 호출 위치**:

| 파일 | 라인 | 메서드 | 필요한 UseCase |
|------|------|--------|---------------|
| time_table_manage_page.dart | 349 | getMonthlyShiftStatus | GetMonthlyShiftStatusUseCase |
| time_table_manage_page.dart | 474 | getManagerOverview | GetManagerOverviewUseCase |
| time_table_manage_page.dart | 553 | getManagerShiftCards | GetManagerShiftCardsUseCase |
| shift_details_bottom_sheet.dart | 275 | processBulkApproval | ProcessBulkApprovalUseCase |
| shift_details_bottom_sheet.dart | 359 | deleteShiftTag | DeleteShiftTagUseCase |
| shift_details_bottom_sheet.dart | 1047 | inputCard | InputCardUseCase |
| add_shift_bottom_sheet.dart | 110 | getScheduleData | GetScheduleDataUseCase |
| add_shift_bottom_sheet.dart | 186 | insertSchedule | InsertScheduleUseCase |
| bonus_management_tab.dart | 105 | updateBonusAmount | UpdateBonusAmountUseCase |

**총 10개 위치**에서 직접 호출

---

### 🟡 High Priority Issues

#### Issue #4: Page에 비즈니스 로직 집중
**파일**: `presentation/pages/time_table_manage_page.dart` (1,136줄)

**문제 메서드**:
- `fetchShiftMetadata()` - 26줄 (Datasource 직접 접근)
- `fetchMonthlyShiftStatus()` - 112줄 (Entity → Map 역변환 포함)
- `fetchManagerOverview()` - 78줄
- `fetchManagerCards()` - 56줄
- `_formatShiftTime()` - 63줄 (시간 포맷팅 로직)
- `_getEmployeeShiftsForDate()` - 11줄
- `_getAssignedEmployeesForShift()` - 39줄

**State 변수 (17개)**:
```dart
dynamic shiftMetadata;                              // ❌ dynamic
List<dynamic> monthlyShiftData = [];                // ❌ dynamic
Set<String> loadedMonths = {};
Map<String, Map<String, dynamic>> managerOverviewDataByMonth = {};  // ❌ 3단계 Map
Map<String, Map<String, dynamic>> managerCardsDataByMonth = {};     // ❌ 3단계 Map
// ... 12개 더
```

---

#### Issue #5: dynamic 타입 남용
**파일**: `presentation/pages/time_table_manage_page.dart`

**라인 1**: 대량의 lint 무시
```dart
// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation,
// argument_type_not_assignable, invalid_assignment, non_bool_condition,
// non_bool_negation_expression, non_bool_operand, use_of_void_result
```

**dynamic 사용 위치**: 15개
- 라인 45: `dynamic shiftMetadata;`
- 라인 46: `List<dynamic> monthlyShiftData = [];`
- 라인 57: `Map<String, Map<String, dynamic>> managerOverviewDataByMonth = {};`
- 라인 61-82: `void _preloadProfileImages(List<dynamic> shiftData)`
- 등등...

---

#### Issue #6: Provider 미사용 (이중 관리)
**문제**: Provider에 `MonthlyShiftStatusNotifier`가 구현되어 있지만 Page에서 사용하지 않음

**Provider**: `time_table_providers.dart:80-153`
```dart
class MonthlyShiftStatusNotifier extends StateNotifier<MonthlyShiftStatusState> {
  // ✅ 제대로 구현됨
  // - Repository 주입
  // - 캐싱 로직 (loadedMonths)
  // - 에러 처리
  // - Entity 타입 사용
}
```

**Page**: `time_table_manage_page.dart:46-47, 323-434`
```dart
// ❌ 동일한 기능을 중복 구현
List<dynamic> monthlyShiftData = [];
Set<String> loadedMonths = {};

Future<void> fetchMonthlyShiftStatus() async {
  // Provider와 동일한 로직을 112줄로 다시 구현
}
```

---

## 3. 목표 아키텍처

### 3.1 Clean Architecture 레이어

```
┌─────────────────────────────────────┐
│     Presentation Layer              │
│  (Pages, Widgets, Providers)        │
│                                     │
│  - UI 렌더링만 담당                   │
│  - Provider를 통한 상태 관리          │
│  - UseCase 호출                     │
└─────────────────────────────────────┘
              ↓ (UseCase를 통해서만)
┌─────────────────────────────────────┐
│       Domain Layer                  │
│  (Entities, UseCases, Repository    │
│   Interfaces, Value Objects)        │
│                                     │
│  - 비즈니스 로직                      │
│  - Entity 정의                       │
│  - Repository Interface만 정의       │
└─────────────────────────────────────┘
              ↓ (구현)
┌─────────────────────────────────────┐
│        Data Layer                   │
│  (Models, Repositories, Datasources)│
│                                     │
│  - 데이터 변환 (Model ↔ Entity)      │
│  - API 통신                         │
│  - 로컬 저장소                       │
└─────────────────────────────────────┘
```

### 3.2 의존성 규칙

✅ **올바른 의존성**:
```
Presentation → Domain ← Data
     ↓           ↑
  UseCase    Repository
                Interface
```

❌ **위반 사례**:
- Presentation → Datasource (Layer Skipping)
- Presentation → Repository (UseCase 없음)
- Domain (Repository) → Data (Map 반환)

---

## 4. 폴더 구조 변화

### 4.1 AS-IS (현재)

```
time_table_manage/
├── data/                          (9 files)
├── domain/                        (13 files)
│   └── usecases/                  [❌ EMPTY]
└── presentation/                  (35 files)
```

### 4.2 TO-BE (목표)

```
time_table_manage/
├── data/                          (18 files) [+9]
│   ├── datasources/               (1 file)
│   ├── models/                    (16 files) [+9]
│   └── repositories/              (1 file) [수정]
│
├── domain/                        (32 files) [+19]
│   ├── entities/                  (16 files) [+9]
│   ├── exceptions/                (1 file)
│   ├── repositories/              (1 file) [수정]
│   ├── usecases/                  (19 files) [+19 NEW]
│   └── value_objects/             (4 files)
│
└── presentation/                  (36 files) [+1, 대폭 리팩토링]
    ├── pages/                     (1 file) [1,136→300줄]
    ├── providers/                 (3 files) [수정]
    └── widgets/                   (30+ files) [일부 수정]
```

**파일 변화**: 57개 → 86개 (+29개)

---

## 5. 단계별 작업 계획

### Phase 1: Domain Layer 보완

#### STEP 1: Entity 생성 (8개 파일) ⏱️ 4-6시간

**작업 순서** (의존성 순서):

1. **tag.dart** (의존성 없음)
   - 파일: `domain/entities/tag.dart`
   - 목적: 시프트 카드 태그 정보
   - 필드: tagId, cardId, tagType, tagContent, createdAt, createdBy

2. **operation_result.dart** (의존성 없음)
   - 파일: `domain/entities/operation_result.dart`
   - 목적: CRUD 작업 결과
   - 필드: success, message, errorCode, metadata

3. **shift_approval_result.dart** (shift_request 의존)
   - 파일: `domain/entities/shift_approval_result.dart`
   - 목적: 승인 처리 결과
   - 의존: shift_request.dart

4. **available_employees_data.dart** (employee_info, shift 의존)
   - 파일: `domain/entities/available_employees_data.dart`
   - 목적: 가용 직원 목록 데이터
   - 의존: employee_info.dart, shift.dart

5. **schedule_data.dart** (employee_info, shift 의존)
   - 파일: `domain/entities/schedule_data.dart`
   - 목적: 스케줄 전체 데이터
   - 의존: employee_info.dart, shift.dart

6. **bulk_approval_result.dart** (의존성 없음)
   - 파일: `domain/entities/bulk_approval_result.dart`
   - 목적: 일괄 승인 결과

7. **card_input_result.dart** (shift_request, tag 의존)
   - 파일: `domain/entities/card_input_result.dart`
   - 목적: 카드 입력 결과
   - 의존: shift_request.dart, tag.dart

8. **shift_card.dart** (employee_info, shift, tag 의존)
   - 파일: `domain/entities/shift_card.dart`
   - 목적: 시프트 카드 정보
   - 의존: employee_info.dart, shift.dart, tag.dart

9. **manager_shift_cards.dart** (shift_card 의존)
   - 파일: `domain/entities/manager_shift_cards.dart`
   - 목적: 매니저 시프트 카드 목록
   - 의존: shift_card.dart

---

### Phase 2: Data Layer 보완

#### STEP 2: Model 생성 (9개 파일) ⏱️ 4-6시간

**각 Model 구조**:
```dart
class XxxModel {
  // Fields

  const XxxModel({...});

  // JSON → Model
  factory XxxModel.fromJson(Map<String, dynamic> json) { }

  // Model → JSON
  Map<String, dynamic> toJson() { }

  // Model → Entity
  Xxx toEntity() { }

  // Entity → Model
  factory XxxModel.fromEntity(Xxx entity) { }
}
```

**생성 순서**:
1. `data/models/tag_model.dart`
2. `data/models/operation_result_model.dart`
3. `data/models/shift_approval_result_model.dart`
4. `data/models/available_employees_data_model.dart`
5. `data/models/schedule_data_model.dart`
6. `data/models/bulk_approval_result_model.dart`
7. `data/models/card_input_result_model.dart`
8. `data/models/shift_card_model.dart`
9. `data/models/manager_shift_cards_model.dart`

---

### Phase 3: Domain Layer UseCase 추가

#### STEP 3: Repository Interface 수정 ⏱️ 1시간

**파일**: `domain/repositories/time_table_repository.dart`

**작업 내용**:
1. Import 추가 (9개 신규 Entity)
2. 메서드 시그니처 수정 (13개 메서드)

**수정 예시**:
```dart
// Before
Future<Map<String, dynamic>> getTagsByCardId({required String cardId});

// After
Future<List<Tag>> getTagsByCardId({required String cardId});
```

---

#### STEP 4: Repository Implementation 수정 ⏱️ 6-8시간

**파일**: `data/repositories/time_table_repository_impl.dart`

**작업 내용**:
1. Import 추가 (9개 신규 Model)
2. 각 메서드 구현 수정 (13개)

**수정 패턴**:
```dart
@override
Future<List<Tag>> getTagsByCardId({required String cardId}) async {
  try {
    final data = await _datasource.getTagsByCardId(cardId: cardId);

    // List<Map> → List<TagModel> → List<Tag>
    final models = data.map((json) => TagModel.fromJson(json)).toList();
    return models.map((model) => model.toEntity()).toList();
  } catch (e) {
    if (e is TimeTableException) rethrow;
    throw TimeTableException('태그 조회 실패: $e', originalError: e);
  }
}
```

---

#### STEP 5: UseCase 생성 (19개 파일) ⏱️ 6-8시간

**파일 목록**:
1. `domain/usecases/base_usecase.dart` [필수]
2. `domain/usecases/get_shift_metadata_usecase.dart`
3. `domain/usecases/get_monthly_shift_status_usecase.dart`
4. `domain/usecases/get_manager_overview_usecase.dart`
5. `domain/usecases/get_manager_shift_cards_usecase.dart`
6. `domain/usecases/toggle_shift_approval_usecase.dart`
7. `domain/usecases/create_shift_usecase.dart`
8. `domain/usecases/delete_shift_usecase.dart`
9. `domain/usecases/delete_shift_tag_usecase.dart`
10. `domain/usecases/get_available_employees_usecase.dart`
11. `domain/usecases/insert_shift_schedule_usecase.dart`
12. `domain/usecases/get_schedule_data_usecase.dart`
13. `domain/usecases/insert_schedule_usecase.dart`
14. `domain/usecases/process_bulk_approval_usecase.dart`
15. `domain/usecases/update_shift_usecase.dart`
16. `domain/usecases/input_card_usecase.dart`
17. `domain/usecases/get_tags_by_card_id_usecase.dart`
18. `domain/usecases/add_bonus_usecase.dart`
19. `domain/usecases/update_bonus_amount_usecase.dart`

**UseCase 템플릿**:
```dart
import '../entities/xxx.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

class XxxUseCase implements UseCase<ReturnType, XxxParams> {
  final TimeTableRepository repository;

  XxxUseCase(this.repository);

  @override
  Future<ReturnType> call(XxxParams params) async {
    // 비즈니스 로직 (검증, 권한 확인 등)

    return await repository.xxxMethod(
      param1: params.param1,
      param2: params.param2,
    );
  }
}

class XxxParams {
  final String param1;
  final String param2;

  const XxxParams({required this.param1, required this.param2});

  bool get isValid => param1.isNotEmpty && param2.isNotEmpty;
}
```

---

### Phase 4: Presentation Layer 수정

#### STEP 6: Provider 수정 ⏱️ 2-3시간

**파일**: `presentation/providers/time_table_providers.dart`

**작업 내용**:

1. **UseCase Provider 추가 (19개)**:
```dart
// UseCase Providers
final getShiftMetadataUseCaseProvider = Provider<GetShiftMetadataUseCase>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetShiftMetadataUseCase(repository);
});

// ... 18개 더
```

2. **StateNotifier 수정**:
```dart
// Before
class MonthlyShiftStatusNotifier extends StateNotifier<MonthlyShiftStatusState> {
  final TimeTableRepository _repository;  // ❌

  Future<void> loadMonth({...}) async {
    final data = await _repository.getMonthlyShiftStatus(...);  // ❌
  }
}

// After
class MonthlyShiftStatusNotifier extends StateNotifier<MonthlyShiftStatusState> {
  final GetMonthlyShiftStatusUseCase _getMonthlyShiftStatusUseCase;  // ✅

  Future<void> loadMonth({...}) async {
    final data = await _getMonthlyShiftStatusUseCase(  // ✅
      GetMonthlyShiftStatusParams(...),
    );
  }
}
```

---

#### STEP 7: Page 수정 ⏱️ 4-6시간

**파일**: `presentation/pages/time_table_manage_page.dart`

**작업 내용**:

1. **lint 무시 제거** (라인 1)
```dart
// 삭제
// ignore_for_file: avoid_dynamic_calls, ...
```

2. **State 변수 정리** (라인 36-92)
```dart
// Before (17개 변수)
dynamic shiftMetadata;
List<dynamic> monthlyShiftData = [];
Set<String> loadedMonths = {};
// ... 14개 더

// After (최소화)
DateTime selectedDate = DateTime.now();
String? selectedStoreId;
ScrollController _scheduleScrollController = ScrollController();
```

3. **fetchShiftMetadata() 수정** (라인 296-321)
```dart
// Before
final rawData = await ref.read(timeTableDatasourceProvider)
    .getShiftMetadata(storeId: storeId);  // ❌

// After
final useCase = ref.read(getShiftMetadataUseCaseProvider);
final metadata = await useCase(GetShiftMetadataParams(storeId: storeId));  // ✅
```

4. **복잡한 메서드 제거** (272줄)
   - `fetchMonthlyShiftStatus()` - 112줄 → Provider로 대체
   - `fetchManagerOverview()` - 78줄 → Provider로 대체
   - `fetchManagerCards()` - 56줄 → Provider로 대체
   - `_formatShiftTime()` - 63줄 → Value Object로 이동

5. **build() 메서드 수정**
```dart
// Before
if (isLoadingShiftStatus) { /* ... */ }

// After
final monthlyStatus = ref.watch(monthlyShiftStatusProvider(selectedStoreId!));
monthlyStatus.when(
  data: (data) => _buildShiftList(data),
  loading: () => TossLoadingView(),
  error: (error, stack) => ErrorView(error),
);
```

**목표**: 1,136줄 → 300줄 이하

---

#### STEP 8: Widget 수정 ⏱️ 3-4시간

**파일 1**: `presentation/widgets/bottom_sheets/shift_details_bottom_sheet.dart`
- 라인 275: `processBulkApproval()` → UseCase 사용
- 라인 359: `deleteShiftTag()` → UseCase 사용
- 라인 1047: `inputCard()` → UseCase 사용

**파일 2**: `presentation/widgets/bottom_sheets/add_shift_bottom_sheet.dart`
- 라인 110: `getScheduleData()` → UseCase 사용
- 라인 186: `insertSchedule()` → UseCase 사용

**파일 3**: `presentation/widgets/shift_details/bonus_management_tab.dart`
- 라인 105: `updateBonusAmount()` → UseCase 사용

**수정 패턴**:
```dart
// Before
await ref.read(timeTableRepositoryProvider).processBulkApproval(...);  // ❌

// After
final useCase = ref.read(processBulkApprovalUseCaseProvider);
final result = await useCase(ProcessBulkApprovalParams(...));  // ✅
```

---

## 6. 파일별 상세 작업 목록

### 6.1 신규 생성 파일 (37개)

#### Domain Entities (9개)
```
domain/entities/
├── tag.dart                            [NEW] ~60줄
├── operation_result.dart               [NEW] ~50줄
├── shift_approval_result.dart          [NEW] ~60줄
├── available_employees_data.dart       [NEW] ~70줄
├── schedule_data.dart                  [NEW] ~60줄
├── bulk_approval_result.dart           [NEW] ~80줄
├── card_input_result.dart              [NEW] ~70줄
├── shift_card.dart                     [NEW] ~100줄
└── manager_shift_cards.dart            [NEW] ~80줄
```

#### Data Models (9개)
```
data/models/
├── tag_model.dart                      [NEW] ~80줄
├── operation_result_model.dart         [NEW] ~70줄
├── shift_approval_result_model.dart    [NEW] ~80줄
├── available_employees_data_model.dart [NEW] ~90줄
├── schedule_data_model.dart            [NEW] ~80줄
├── bulk_approval_result_model.dart     [NEW] ~100줄
├── card_input_result_model.dart        [NEW] ~90줄
├── shift_card_model.dart               [NEW] ~120줄
└── manager_shift_cards_model.dart      [NEW] ~100줄
```

#### Domain UseCases (19개)
```
domain/usecases/
├── base_usecase.dart                           [NEW] ~15줄
├── get_shift_metadata_usecase.dart             [NEW] ~40줄
├── get_monthly_shift_status_usecase.dart       [NEW] ~50줄
├── get_manager_overview_usecase.dart           [NEW] ~50줄
├── get_manager_shift_cards_usecase.dart        [NEW] ~50줄
├── toggle_shift_approval_usecase.dart          [NEW] ~40줄
├── create_shift_usecase.dart                   [NEW] ~45줄
├── delete_shift_usecase.dart                   [NEW] ~35줄
├── delete_shift_tag_usecase.dart               [NEW] ~40줄
├── get_available_employees_usecase.dart        [NEW] ~45줄
├── insert_shift_schedule_usecase.dart          [NEW] ~45줄
├── get_schedule_data_usecase.dart              [NEW] ~40줄
├── insert_schedule_usecase.dart                [NEW] ~50줄
├── process_bulk_approval_usecase.dart          [NEW] ~45줄
├── update_shift_usecase.dart                   [NEW] ~45줄
├── input_card_usecase.dart                     [NEW] ~60줄
├── get_tags_by_card_id_usecase.dart            [NEW] ~40줄
├── add_bonus_usecase.dart                      [NEW] ~45줄
└── update_bonus_amount_usecase.dart            [NEW] ~40줄
```

---

### 6.2 수정 파일 (6개)

#### 1. domain/repositories/time_table_repository.dart
**작업 내용**:
- [ ] Import 추가 (9개 신규 Entity)
- [ ] 메서드 시그니처 수정 (13개 메서드, Map → Entity)

**수정 라인**: 54, 67, 77, 84, 94, 105, 117, 128, 141, 155, 168, 187, 203, 214

---

#### 2. data/repositories/time_table_repository_impl.dart
**작업 내용**:
- [ ] Import 추가 (9개 신규 Model)
- [ ] 메서드 구현 수정 (13개 메서드)
  - Map 받기 → Model 변환 → Entity 반환

**수정 라인**: 236-259, 261-278, 280-302, 304-317, 319-333, 335-352, 354-373, 375-388, 390-407, 409-430, 432-456, 457-486, 488-501, 503-522

---

#### 3. presentation/providers/time_table_providers.dart
**작업 내용**:
- [ ] UseCase Provider 추가 (19개)
- [ ] MonthlyShiftStatusNotifier 수정 (Repository → UseCase)
- [ ] ManagerOverviewNotifier 수정 (Repository → UseCase)
- [ ] Provider 생성자 수정 (UseCase 주입)

**추가 라인**: ~200줄 추가

---

#### 4. presentation/pages/time_table_manage_page.dart
**작업 내용**:
- [ ] 라인 1: lint 무시 제거
- [ ] 라인 36-92: State 변수 17개 → 3개로 축소
- [ ] 라인 296-321: fetchShiftMetadata() 수정 (Datasource → UseCase)
- [ ] 라인 323-434: fetchMonthlyShiftStatus() 제거 (Provider로 대체)
- [ ] 라인 436-513: fetchManagerOverview() 제거 (Provider로 대체)
- [ ] 라인 515-570: fetchManagerCards() 제거 (Provider로 대체)
- [ ] 라인 718-780: _formatShiftTime() 이동 (Value Object로)
- [ ] build() 메서드 전면 수정 (Provider watch 사용)

**목표**: 1,136줄 → 300줄

---

#### 5. presentation/widgets/bottom_sheets/shift_details_bottom_sheet.dart
**작업 내용**:
- [ ] 라인 275: processBulkApproval → UseCase
- [ ] 라인 359: deleteShiftTag → UseCase
- [ ] 라인 1047: inputCard → UseCase

---

#### 6. presentation/widgets/bottom_sheets/add_shift_bottom_sheet.dart
**작업 내용**:
- [ ] 라인 110: getScheduleData → UseCase
- [ ] 라인 186: insertSchedule → UseCase

---

#### 7. presentation/widgets/shift_details/bonus_management_tab.dart
**작업 내용**:
- [ ] 라인 105: updateBonusAmount → UseCase

---

## 7. 의존성 해결 순서

### 7.1 의존성 그래프

```
STEP 1: Entities (독립적)
    ├── tag.dart
    ├── operation_result.dart
    └── bulk_approval_result.dart
          ↓
STEP 1: Entities (기존 Entity 의존)
    ├── shift_approval_result.dart (→ shift_request)
    ├── available_employees_data.dart (→ employee_info, shift)
    ├── schedule_data.dart (→ employee_info, shift)
    └── card_input_result.dart (→ shift_request, tag)
          ↓
STEP 1: Entities (신규 Entity 의존)
    ├── shift_card.dart (→ employee_info, shift, tag)
    └── manager_shift_cards.dart (→ shift_card)
          ↓
STEP 2: Models (Entity 의존)
    └── 모든 Model은 해당 Entity에 의존
          ↓
STEP 3: Repository Interface (Entity 의존)
    └── time_table_repository.dart
          ↓
STEP 4: Repository Impl (Model 의존)
    └── time_table_repository_impl.dart
          ↓
STEP 5: UseCases (Repository Interface 의존)
    └── 모든 UseCase는 Repository에 의존
          ↓
STEP 6: Providers (UseCase 의존)
    └── time_table_providers.dart
          ↓
STEP 7-8: Presentation (Provider 의존)
    └── Pages, Widgets
```

### 7.2 작업 순서 (의존성 순)

```
1. Domain Entities (기초) → 2. Domain Entities (복합)
   ↓
3. Data Models
   ↓
4. Domain Repository Interface
   ↓
5. Data Repository Implementation
   ↓
6. Domain UseCases
   ↓
7. Presentation Providers
   ↓
8. Presentation Pages/Widgets
```

---

## 8. 작업 체크리스트

### Phase 1: Domain Entities ⏱️ 4-6h

- [ ] `domain/entities/tag.dart` (~60줄)
- [ ] `domain/entities/operation_result.dart` (~50줄)
- [ ] `domain/entities/bulk_approval_result.dart` (~80줄)
- [ ] `domain/entities/shift_approval_result.dart` (~60줄)
- [ ] `domain/entities/available_employees_data.dart` (~70줄)
- [ ] `domain/entities/schedule_data.dart` (~60줄)
- [ ] `domain/entities/card_input_result.dart` (~70줄)
- [ ] `domain/entities/shift_card.dart` (~100줄)
- [ ] `domain/entities/manager_shift_cards.dart` (~80줄)

### Phase 2: Data Models ⏱️ 4-6h

- [ ] `data/models/tag_model.dart` (~80줄)
- [ ] `data/models/operation_result_model.dart` (~70줄)
- [ ] `data/models/bulk_approval_result_model.dart` (~100줄)
- [ ] `data/models/shift_approval_result_model.dart` (~80줄)
- [ ] `data/models/available_employees_data_model.dart` (~90줄)
- [ ] `data/models/schedule_data_model.dart` (~80줄)
- [ ] `data/models/card_input_result_model.dart` (~90줄)
- [ ] `data/models/shift_card_model.dart` (~120줄)
- [ ] `data/models/manager_shift_cards_model.dart` (~100줄)

### Phase 3: Domain Layer ⏱️ 7-9h

#### Repository Interface
- [ ] `domain/repositories/time_table_repository.dart` - Import 추가
- [ ] `domain/repositories/time_table_repository.dart` - 13개 메서드 수정

#### Repository Implementation
- [ ] `data/repositories/time_table_repository_impl.dart` - Import 추가
- [ ] `data/repositories/time_table_repository_impl.dart` - 13개 메서드 구현 수정

#### UseCases
- [ ] `domain/usecases/base_usecase.dart`
- [ ] `domain/usecases/get_shift_metadata_usecase.dart`
- [ ] `domain/usecases/get_monthly_shift_status_usecase.dart`
- [ ] `domain/usecases/get_manager_overview_usecase.dart`
- [ ] `domain/usecases/get_manager_shift_cards_usecase.dart`
- [ ] `domain/usecases/toggle_shift_approval_usecase.dart`
- [ ] `domain/usecases/create_shift_usecase.dart`
- [ ] `domain/usecases/delete_shift_usecase.dart`
- [ ] `domain/usecases/delete_shift_tag_usecase.dart`
- [ ] `domain/usecases/get_available_employees_usecase.dart`
- [ ] `domain/usecases/insert_shift_schedule_usecase.dart`
- [ ] `domain/usecases/get_schedule_data_usecase.dart`
- [ ] `domain/usecases/insert_schedule_usecase.dart`
- [ ] `domain/usecases/process_bulk_approval_usecase.dart`
- [ ] `domain/usecases/update_shift_usecase.dart`
- [ ] `domain/usecases/input_card_usecase.dart`
- [ ] `domain/usecases/get_tags_by_card_id_usecase.dart`
- [ ] `domain/usecases/add_bonus_usecase.dart`
- [ ] `domain/usecases/update_bonus_amount_usecase.dart`

### Phase 4: Presentation Layer ⏱️ 9-13h

#### Providers
- [ ] `presentation/providers/time_table_providers.dart` - 19개 UseCase Provider 추가
- [ ] `presentation/providers/time_table_providers.dart` - MonthlyShiftStatusNotifier 수정
- [ ] `presentation/providers/time_table_providers.dart` - ManagerOverviewNotifier 수정

#### Pages
- [ ] `presentation/pages/time_table_manage_page.dart` - lint 무시 제거
- [ ] `presentation/pages/time_table_manage_page.dart` - State 변수 정리
- [ ] `presentation/pages/time_table_manage_page.dart` - fetchShiftMetadata() 수정
- [ ] `presentation/pages/time_table_manage_page.dart` - 복잡한 메서드 제거 (272줄)
- [ ] `presentation/pages/time_table_manage_page.dart` - build() 메서드 수정

#### Widgets
- [ ] `presentation/widgets/bottom_sheets/shift_details_bottom_sheet.dart` - 3곳 수정
- [ ] `presentation/widgets/bottom_sheets/add_shift_bottom_sheet.dart` - 2곳 수정
- [ ] `presentation/widgets/shift_details/bonus_management_tab.dart` - 1곳 수정

---

## 9. 작업 완료 검증

### 9.1 의존성 검증

**확인 사항**:
- [ ] Presentation에서 Datasource 직접 import 없음
- [ ] Presentation에서 Repository 직접 import 있으나 Provider를 통해 UseCase만 호출
- [ ] Domain Layer에서 Data Layer import 없음
- [ ] Repository Interface가 Entity만 반환 (Map 없음)

### 9.2 타입 안전성 검증

**확인 사항**:
- [ ] `dynamic` 타입 사용 제거
- [ ] lint 무시 지시문 제거
- [ ] `flutter analyze` 통과
- [ ] 모든 메서드에 명시적 반환 타입

### 9.3 코드 품질 검증

**확인 사항**:
- [ ] time_table_manage_page.dart가 300줄 이하
- [ ] 각 파일이 단일 책임 원칙 준수
- [ ] Provider/UseCase를 통한 의존성 주입
- [ ] Entity ↔ Map 역변환 제거

### 9.4 기능 테스트

**확인 사항**:
- [ ] 시프트 메타데이터 조회
- [ ] 월별 시프트 상태 조회
- [ ] 매니저 오버뷰 조회
- [ ] 매니저 시프트 카드 조회
- [ ] 시프트 승인/취소
- [ ] 일괄 승인 처리
- [ ] 태그 CRUD
- [ ] 보너스 관리
- [ ] 스케줄 추가/수정

---

## 10. 예상 이슈 및 해결책

### Issue 1: Model fromJson 복잡도
**문제**: RPC 응답 구조가 복잡하여 Model 변환이 어려움
**해결**: Repository에서 일부 변환 로직 유지, Model에 `fromRpcResponse()` factory 추가

### Issue 2: Provider 의존성 순환
**문제**: Provider 간 순환 참조 가능성
**해결**: Provider는 Repository에만 의존, StateNotifier는 UseCase에만 의존

### Issue 3: 기존 코드 호환성
**문제**: Widget에서 Map 구조를 기대하는 코드
**해결**: 점진적 마이그레이션, Entity에 `toMap()` 메서드 임시 추가 (deprecated)

### Issue 4: 테스트 코드 부재
**문제**: 리팩토링 후 동작 검증 어려움
**해결**: 각 단계마다 수동 테스트, 주요 UseCase는 단위 테스트 추가

---

## 11. 참고 자료

### Clean Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)

### Riverpod Best Practices
- [Riverpod Documentation](https://riverpod.dev/)
- [Provider vs Riverpod](https://codewithandrea.com/articles/flutter-state-management-riverpod/)

### Dart Style Guide
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

## 12. 변경 이력

| 날짜 | 작성자 | 변경 내용 |
|------|--------|----------|
| 2025-11-07 | Claude Code | 초안 작성 |

---

**작성자**: Claude Code
**검토자**: (검토 필요)
**승인자**: (승인 필요)

---

**문서 끝**
