# 🏗️ Architecture Overview - Transaction Template Module

> **대상 독자**: AI Agent, 개발자, 아키텍트
> **목적**: 이 모듈의 전체 구조를 빠르게 이해하고 수정할 수 있도록 안내

---

## 📚 Table of Contents

1. [Quick Reference](#-quick-reference)
2. [Folder Structure](#-folder-structure)
3. [Data Flow](#-data-flow)
4. [File Responsibility Matrix](#-file-responsibility-matrix)
5. [Modification Guide by Task](#-modification-guide-by-task)
6. [Common Patterns](#-common-patterns)
7. [Integration Points](#-integration-points)

---

## 🚀 Quick Reference

### 통계 (Statistics)

| 항목 | 수치 |
|-----|-----|
| **총 파일 수** | 72 files |
| **총 코드 라인** | 17,470 lines |
| **아키텍처** | Clean Architecture (3-Layer) |
| **상태 관리** | Riverpod (StateNotifier) |
| **디자인 시스템** | Toss Design System |

### 핵심 개념 (Core Concepts)

```
📱 Presentation → 🧠 Domain ← 💾 Data
   (UI)           (Logic)      (DB)
```

- **Presentation**: Flutter Widgets, Providers (UI 레이어)
- **Domain**: Entities, UseCases, Validators (비즈니스 로직)
- **Data**: Repositories, DTOs, Services (데이터 소스)

---

## 📁 Folder Structure

```
transaction_template_refectore/
│
├── 📱 presentation/                      [28% of files - UI Layer]
│   ├── pages/                            1 file  - Main screens
│   │   └── transaction_template_page.dart
│   │
│   ├── modals/                           4 files - Popup sheets
│   │   ├── add_template_bottom_sheet.dart         (Create template wizard)
│   │   ├── quick_template_bottom_sheet.dart       (Quick transaction)
│   │   ├── template_usage_bottom_sheet.dart       (Use template)
│   │   └── template_filter_sheet.dart             (Filter options)
│   │
│   ├── widgets/                          10 files - Reusable UI components
│   │   ├── forms/                        5 files
│   │   │   ├── quick_amount_input.dart            (Number input)
│   │   │   ├── quick_status_indicator.dart        (Status badge)
│   │   │   ├── complex_template_card.dart         (Warning card)
│   │   │   ├── collapsible_description.dart       (Expandable text)
│   │   │   └── essential_selectors.dart           (Selector widgets)
│   │   │
│   │   ├── wizard/                       4 files
│   │   │   ├── step_indicator.dart                (Progress dots)
│   │   │   ├── template_basic_info_form.dart      (Name/description form)
│   │   │   ├── account_selector_card.dart         (Account picker)
│   │   │   └── permissions_form.dart              (Permission settings)
│   │   │
│   │   └── common/                       1 file
│   │       └── store_selector.dart                (Store dropdown)
│   │
│   ├── providers/                        5 files - State management
│   │   ├── template_provider.dart                 (Main template state)
│   │   ├── transaction_provider.dart              (Transaction state)
│   │   ├── validator_providers.dart               (Validator DI)
│   │   ├── use_case_providers.dart                (UseCase DI)
│   │   └── states/                       2 files
│   │       ├── template_state.dart                (Template state model)
│   │       └── transaction_state.dart             (Transaction state model)
│   │
│   └── dialogs/                          1 file
│       └── template_creation_dialogs.dart         (Success/error dialogs)
│
├── 🧠 domain/                            [49% of files - Business Logic]
│   ├── entities/                         3 files - Core business objects
│   │   ├── template_entity.dart                   (TransactionTemplate)
│   │   ├── transaction_entity.dart                (Transaction)
│   │   └── transaction_line_entity.dart           (TransactionLine)
│   │
│   ├── usecases/                         4 files - Business operations
│   │   ├── create_template_usecase.dart           (Template creation logic)
│   │   ├── delete_template_usecase.dart           (Template deletion logic)
│   │   ├── create_transaction_usecase.dart        (Transaction creation)
│   │   └── create_transaction_from_template_usecase.dart
│   │
│   ├── validators/                       4 files - Validation rules
│   │   ├── template_validator.dart                (Template validation)
│   │   ├── transaction_validator.dart             (Transaction validation)
│   │   ├── template_form_validator.dart           (Form validation)
│   │   └── template_validation_result.dart        (Validation result DTO)
│   │
│   ├── factories/                        2 files - Object creation
│   │   ├── template_line_factory.dart             (Create transaction lines)
│   │   └── template_line_factory_test.dart        (Factory tests)
│   │
│   ├── repositories/                     2 files - Data interfaces
│   │   ├── template_repository.dart               (Template CRUD interface)
│   │   └── transaction_repository.dart            (Transaction CRUD interface)
│   │
│   ├── value_objects/                    10 files - Domain value types
│   │   ├── template_creation_data.dart            (Template creation DTO)
│   │   ├── template_filter.dart                   (Filter criteria)
│   │   ├── template_analysis_result.dart          (Analysis result)
│   │   ├── template_debt_configuration.dart       (Debt config)
│   │   ├── transaction_context.dart               (Transaction context)
│   │   ├── transaction_counterparty.dart          (Counterparty info)
│   │   ├── transaction_location.dart              (Location info)
│   │   ├── transaction_amount.dart                (Amount info)
│   │   ├── transaction_metadata.dart              (Metadata)
│   │   └── debt_category_mapper.dart              (Category mapping)
│   │
│   ├── enums/                            3 files - Enumerations
│   │   ├── template_enums.dart                    (Form complexity, etc.)
│   │   ├── template_constants.dart                (Permission UUIDs)
│   │   └── approval_level.dart                    (Approval levels)
│   │
│   ├── exceptions/                       5 files - Business exceptions
│   │   ├── domain_exception.dart                  (Base exception)
│   │   ├── template_business_exception.dart       (Template errors)
│   │   ├── transaction_business_exception.dart    (Transaction errors)
│   │   ├── validation_exception.dart              (Validation errors)
│   │   └── validation_error.dart                  (Validation error DTO)
│   │
│   ├── constants/                        1 file
│   │   └── permission_constants.dart              (Permission constants)
│   │
│   └── providers/                        1 file
│       └── repository_providers.dart              (Repository DI)
│
└── 💾 data/                              [11% of files - Data Layer]
    ├── repositories/                     3 files - Repository implementations
    │   ├── supabase_template_repository.dart      (Template DB operations)
    │   ├── supabase_transaction_repository.dart   (Transaction DB operations)
    │   └── repository_providers.dart              (Repository factory providers)
    │
    ├── dtos/                             3 files + 2 generated - Data transfer
    │   ├── template_dto.dart                      (Template DTO)
    │   ├── template_dto.freezed.dart              (Generated)
    │   ├── template_dto.g.dart                    (Generated)
    │   ├── transaction_dto.dart                   (Transaction DTO)
    │   ├── transaction_dto.g.dart                 (Generated)
    │   └── mappers/                      1 file
    │       └── template_mapper.dart               (DTO ↔ Entity conversion)
    │
    ├── services/                         1 file - Data services
    │   └── template_data_service.dart             (Supabase API calls)
    │
    └── cache/                            1 file - Caching layer
        └── template_cache_repository.dart         (In-memory cache)
```

---

## 🔄 Data Flow

### 1. Template Creation Flow (템플릿 생성)

```
┌─────────────────────────────────────────────────────────────────┐
│  USER ACTION: "Create Template" button clicked                 │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                             │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                 │
│  📄 add_template_bottom_sheet.dart (Line 220)                  │
│     ↓ User fills wizard (3 steps)                             │
│     ↓ Collects: name, description, accounts, permissions      │
│                                                                 │
│  📄 template_line_factory.dart (Line 85)                       │
│     ↓ Creates transaction lines from UI data                  │
│     ↓ Output: List<Map<String, dynamic>> data                 │
│                                                                 │
│  📄 template_provider.dart (Line 72)                           │
│     ↓ Calls: createTemplate(command)                          │
│     ↓ setState: isCreating = true                             │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  DOMAIN LAYER                                                   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                 │
│  📄 create_template_usecase.dart (Line 25)                     │
│     ↓ Step 1: Check name uniqueness (Line 34)                 │
│     ↓ Step 2: Create entity (Line 39)                         │
│     ↓ Step 3: Validate entity (Line 44)                       │
│     ↓ Step 4: Validate data structure (Line 62)               │
│     ↓ Step 5: Validate policy (Line 83)                       │
│     ↓ Step 6: Validate account access (Line 119)              │
│     ↓ Step 7: Validate quotas (Line 123)                      │
│     ↓ Step 8: Build optimistic template (Line 149)            │
│                                                                 │
│  📄 template_entity.dart (Line 148)                            │
│     ↓ validate() - 6-step validation                          │
│     ↓ Returns: TemplateValidationResult                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  DATA LAYER                                                     │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                 │
│  📄 supabase_template_repository.dart (Line 37)                │
│     ↓ save(template)                                           │
│     ↓ Calls: _dataService.save(template)                      │
│     ↓ Updates: _cacheRepository.cacheTemplate(template)       │
│     ↓ Invalidates: _cacheRepository.invalidateCache()         │
│                                                                 │
│  📄 template_data_service.dart                                 │
│     ↓ Converts entity → DTO                                   │
│     ↓ Calls Supabase RPC: insert_template                     │
│     ↓ Returns: success/error                                  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  SUPABASE DATABASE                                              │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                 │
│  📊 Table: transaction_template                                │
│     ↓ INSERT: template_id, name, data, tags, etc.             │
│     ↓ Returns: inserted row                                   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  BACK TO PRESENTATION                                           │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                 │
│  📄 template_provider.dart (Line 79)                           │
│     ↓ result.isSuccess = true                                 │
│     ↓ setState: isCreating = false                            │
│     ↓ Calls: loadTemplates() - refresh list                   │
│                                                                 │
│  📄 template_creation_dialogs.dart                             │
│     ↓ Shows success dialog                                    │
│     ↓ Closes bottom sheet                                     │
│     ↓ User sees new template in list                          │
└─────────────────────────────────────────────────────────────────┘
```

---

### 2. Template List Loading Flow (템플릿 목록 로딩)

```
USER OPENS PAGE
       ↓
TransactionTemplatePage.initState() (Line 59)
       ↓
ref.read(templateProvider.notifier).loadTemplates()
       ↓
TemplateNotifier.loadTemplates() (Line 34)
       ↓
       ├─→ setState: isLoading = true
       │
       ↓
_repository.findByContext() (Line 44)
       ↓
SupabaseTemplateRepository.findByContext() (Line 86)
       ↓
       ├─→ Check cache first (Line 120)
       │   ├─→ Cache HIT: return cached data
       │   └─→ Cache MISS: fetch from DB
       │
       ↓
_dataService.findByCompanyAndStore() (Line 138)
       ↓
Supabase SELECT query
       ↓
       ├─→ Convert DB rows → DTOs
       │
       ↓
       ├─→ Convert DTOs → Entities
       │
       ↓
_cacheRepository.cacheTemplates() (Line 148)
       ↓
Return List<TransactionTemplate>
       ↓
TemplateNotifier.setState() (Line 55)
       ├─→ isLoading = false
       ├─→ templates = result
       └─→ errorMessage = null
       ↓
UI rebuilds with template list
```

---

## 📋 File Responsibility Matrix

### Who Does What? (파일별 역할 매트릭스)

| 작업 | 담당 파일 | 라인 번호 | 설명 |
|-----|----------|---------|------|
| **UI 렌더링** |
| 메인 화면 그리기 | `transaction_template_page.dart` | 100-500 | App bar, tabs, list view |
| 템플릿 생성 폼 | `add_template_bottom_sheet.dart` | 45-300 | 3-step wizard |
| 금액 입력 | `quick_amount_input.dart` | 20-150 | Number pad + formatter |
| 단계 표시 | `step_indicator.dart` | 10-60 | Progress dots (● ● ○) |
| **상태 관리** |
| 템플릿 목록 상태 | `template_provider.dart` | 19-213 | Loading, success, error |
| 생성 상태 | `template_provider.dart` | 218-279 | Creating progress |
| 필터 상태 | `template_provider.dart` | 284-339 | Search, visibility |
| **비즈니스 로직** |
| 템플릿 생성 로직 | `create_template_usecase.dart` | 25-178 | 8-step orchestration |
| 템플릿 삭제 로직 | `delete_template_usecase.dart` | - | Deletion workflow |
| 엔티티 검증 | `template_entity.dart` | 148-481 | 6-step validation |
| 정책 검증 | `template_validator.dart` | - | Business rules |
| **데이터 변환** |
| UI → 비즈니스 객체 | `template_line_factory.dart` | 21-155 | Map → Entity |
| 엔티티 → DTO | `template_mapper.dart` | - | Entity → JSON |
| DTO → 엔티티 | `template_mapper.dart` | - | JSON → Entity |
| **데이터베이스** |
| 템플릿 CRUD | `supabase_template_repository.dart` | 36-310 | Save, find, delete |
| Supabase API 호출 | `template_data_service.dart` | - | RPC calls |
| 캐싱 | `template_cache_repository.dart` | - | In-memory cache |

---

## 🛠️ Modification Guide by Task

### Task 1: UI 디자인 변경

**목표**: 버튼 색상, 폰트 크기, 간격 조정

**수정 파일:**
- ✅ `presentation/pages/` - 메인 화면
- ✅ `presentation/modals/` - 팝업
- ✅ `presentation/widgets/` - 컴포넌트

**금지 파일:**
- ❌ `domain/*` - 절대 수정 금지
- ❌ `data/*` - 절대 수정 금지

**예시:**
```dart
// ✅ GOOD: Color change
Container(
  color: TossColors.primary,  // Change this
)

// ❌ BAD: Logic change
ref.read(templateProvider.notifier).loadTemplates()  // Don't touch!
```

---

### Task 2: 새로운 검증 규칙 추가

**목표**: 템플릿 이름에 특수문자 금지

**수정 파일:**
1. ✅ `domain/validators/template_validator.dart` - 검증 로직 추가
2. ✅ `domain/entities/template_entity.dart` - validate() 메서드 수정

**수정 순서:**
```dart
// Step 1: Add validation in template_entity.dart (Line 152)
if (name.contains(RegExp(r'[!@#$%^&*()]'))) {
  errors.add('Template name cannot contain special characters');
}

// Step 2: Test in UI - error message should appear
```

---

### Task 3: 새로운 필드 추가 (예: Category)

**목표**: 템플릿에 카테고리 필드 추가

**수정 파일 (순서대로):**
1. ✅ `domain/entities/template_entity.dart` - Entity에 필드 추가
2. ✅ `data/dtos/template_dto.dart` - DTO에 필드 추가
3. ✅ `data/repositories/supabase_template_repository.dart` - DB 매핑
4. ✅ `presentation/modals/add_template_bottom_sheet.dart` - UI 입력 필드

**수정 예시:**
```dart
// Step 1: Entity (domain/entities/template_entity.dart)
class TransactionTemplate {
  final String? category;  // ← ADD THIS

  const TransactionTemplate({
    // ...existing fields
    this.category,  // ← ADD THIS
  });
}

// Step 2: DTO (data/dtos/template_dto.dart)
@freezed
class TemplateDto with _$TemplateDto {
  factory TemplateDto({
    // ...existing fields
    String? category,  // ← ADD THIS
  }) = _TemplateDto;

  factory TemplateDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateDtoFromJson(json);
}

// Step 3: UI (presentation/modals/add_template_bottom_sheet.dart)
TextField(
  decoration: InputDecoration(labelText: 'Category'),
  onChanged: (value) => _category = value,  // ← ADD THIS
)
```

---

### Task 4: 새로운 UseCase 추가 (예: Duplicate Template)

**목표**: 템플릿 복제 기능 추가

**수정 파일 (순서대로):**
1. ✅ `domain/usecases/duplicate_template_usecase.dart` - 새 파일 생성
2. ✅ `domain/repositories/template_repository.dart` - 인터페이스 추가
3. ✅ `data/repositories/supabase_template_repository.dart` - 구현 추가
4. ✅ `presentation/providers/template_provider.dart` - Provider 추가
5. ✅ `presentation/pages/transaction_template_page.dart` - UI 버튼 추가

**템플릿 코드:**
```dart
// Step 1: Create UseCase (domain/usecases/duplicate_template_usecase.dart)
class DuplicateTemplateUseCase {
  final TemplateRepository _repository;

  const DuplicateTemplateUseCase({required TemplateRepository repository})
      : _repository = repository;

  Future<DuplicateTemplateResult> execute(String templateId) async {
    // 1. Find original template
    final original = await _repository.findById(templateId);
    if (original == null) {
      throw TemplateBusinessException('Template not found');
    }

    // 2. Create copy with new name
    final copy = original.copyWith(
      templateId: Uuid().v4(),
      name: '${original.name} (Copy)',
      createdAt: DateTime.now(),
    );

    // 3. Save copy
    await _repository.save(copy);

    return DuplicateTemplateResult.success(template: copy);
  }
}

// Step 2: Add to Provider (presentation/providers/template_provider.dart)
Future<bool> duplicateTemplate(String templateId) async {
  try {
    final result = await _duplicateUseCase.execute(templateId);
    if (result.isSuccess) {
      await loadTemplates();
      return true;
    }
    return false;
  } catch (e) {
    state = state.copyWith(errorMessage: e.toString());
    return false;
  }
}
```

---

### Task 5: 캐싱 전략 변경

**목표**: 캐시 TTL을 10분에서 5분으로 변경

**수정 파일:**
- ✅ `data/cache/template_cache_repository.dart`

**수정 위치:**
```dart
// Find this constant (around line 10)
static const _cacheDuration = Duration(minutes: 10);

// Change to:
static const _cacheDuration = Duration(minutes: 5);
```

---

## 🔧 Common Patterns

### Pattern 1: Provider → UseCase → Repository

**설명**: 대부분의 비즈니스 작업이 따르는 패턴

```dart
// 1. User Action (UI)
onPressed: () async {
  // 2. Call Provider
  final success = await ref.read(templateProvider.notifier)
      .createTemplate(command);

  // 3. Provider calls UseCase
  // (Inside TemplateNotifier.createTemplate)
  final result = await _createUseCase.execute(command);

  // 4. UseCase calls Repository
  // (Inside CreateTemplateUseCase.execute)
  await _templateRepository.save(template);

  // 5. Repository calls Data Service
  // (Inside SupabaseTemplateRepository.save)
  await _dataService.save(template);

  // 6. Data Service calls Supabase
  // (Inside TemplateDataService.save)
  await supabase.rpc('insert_template', params: dto);
}
```

---

### Pattern 2: Entity Validation Pattern

**설명**: 모든 엔티티는 자체 검증 메서드를 가짐

```dart
class TransactionTemplate {
  TemplateValidationResult validate() {
    final errors = <String>[];

    // Step 1: Basic field validation
    if (name.trim().isEmpty) {
      errors.add('Name is required');
    }

    // Step 2: Data structure validation
    final dataErrors = _validateDataJSONBStructure();
    errors.addAll(dataErrors);

    // Step 3: Balance validation
    final balanceErrors = _validateDebitCreditBalance();
    errors.addAll(balanceErrors);

    // Step 4-6: Object-specific validation
    errors.addAll(_validateCashObjects());
    errors.addAll(_validateDebtObjects());
    errors.addAll(_validateFixedAssetObjects());

    return TemplateValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}
```

---

### Pattern 3: Factory Pattern for Object Creation

**설명**: Factory를 사용해 복잡한 객체 생성 캡슐화

```dart
class TemplateLineFactory {
  static Map<String, dynamic> createLine({
    required String accountId,
    required String accountCategoryTag,
    String? cashLocationId,
    String? counterpartyId,
  }) {
    final line = {
      'account_id': accountId,
      'amount': '0',
    };

    // Add type-specific fields
    switch (accountCategoryTag) {
      case 'cash':
        line['cash_location_id'] = cashLocationId;
        break;
      case 'payable':
        line['counterparty_id'] = counterpartyId;
        break;
    }

    return line;
  }
}
```

---

### Pattern 4: Optimistic Update (Deletion)

**설명**: UI를 즉시 업데이트하고 나중에 DB 동기화

```dart
Future<bool> deleteTemplate(DeleteTemplateCommand command) async {
  try {
    // Step 1: Execute UseCase (DB deletion)
    final result = await _deleteUseCase.execute(command);

    if (result.isSuccess) {
      // Step 2: Optimistic update - immediately remove from local state
      final updatedTemplates = state.templates
          .where((t) => t.templateId != command.templateId)
          .toList();

      setState(() {
        templates: updatedTemplates,  // UI updates immediately!
      });

      return true;
    }
    return false;
  } catch (e) {
    // Step 3: On error, revert by reloading
    await loadTemplates();
    return false;
  }
}
```

---

### Pattern 5: Load After Save (Creation)

**설명**: DB에 저장 후 목록 새로고침

```dart
Future<bool> createTemplate(CreateTemplateCommand command) async {
  try {
    // Step 1: Execute UseCase (DB insert)
    final result = await _createUseCase.execute(command);

    if (result.isSuccess) {
      // Step 2: Reload entire list from DB
      await loadTemplates(
        companyId: command.companyId,
        storeId: command.storeId,
      );

      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}
```

---

## 🔗 Integration Points

### 1. Global Providers (외부 의존성)

이 모듈은 다음 글로벌 Provider에 의존합니다:

| Provider | 위치 | 사용 목적 |
|---------|-----|---------|
| `appStateProvider` | `lib/presentation/providers/app_state_provider.dart` | 현재 선택된 company/store ID |
| `accountProvider` | `lib/presentation/providers/entities/account_provider.dart` | 계정 목록 조회 |
| `cashLocationProvider` | `lib/presentation/providers/entities/cash_location_provider.dart` | 현금 위치 목록 |
| `counterpartyProvider` | `lib/presentation/providers/entities/counterparty_provider.dart` | 거래처 목록 |

**사용 예시:**
```dart
// Get current company/store
final appState = ref.watch(appStateProvider);
final companyId = appState.companyChoosen;
final storeId = appState.storeChoosen;

// Get account list
final accounts = ref.watch(accountProvider);

// Get cash locations
final locations = ref.watch(cashLocationProvider(companyId, storeId, 'cash'));
```

---

### 2. Supabase RPC Functions (데이터베이스 함수)

이 모듈이 호출하는 Supabase RPC 함수들:

| RPC Function | 목적 | 파라미터 | 반환값 |
|-------------|------|---------|-------|
| `insert_template` | 템플릿 생성 | template_id, name, data, tags, etc. | inserted row |
| `update_template` | 템플릿 수정 | template_id, updated fields | updated row |
| `delete_template` | 템플릿 삭제 | template_id | success boolean |
| `get_templates_by_company` | 회사별 템플릿 조회 | company_id, store_id | template array |
| `insert_journal_with_everything` | 거래 생성 (템플릿 사용) | journal data, lines array | journal_id |

---

### 3. Navigation Routes (화면 이동)

이 모듈로 진입하는 경로:

```dart
// From main menu
Navigator.pushNamed(context, '/templates');

// From transaction screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TransactionTemplatePage(),
  ),
);
```

---

### 4. Design System (디자인 시스템)

이 모듈이 사용하는 디자인 토큰:

```dart
// Colors
import 'package:myfinance_improved/core/themes/toss_colors.dart';

// Text Styles
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';

// Spacing
import 'package:myfinance_improved/core/themes/toss_spacing.dart';

// Border Radius
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';

// Shadows
import 'package:myfinance_improved/core/themes/toss_shadows.dart';

// Common Widgets
import 'package:myfinance_improved/presentation/widgets/common/toss_app_bar.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_scaffold.dart';
```

---

## 📊 Dependency Graph

```
presentation/pages/transaction_template_page.dart
    ↓
    ├─→ presentation/providers/template_provider.dart
    │       ↓
    │       ├─→ domain/usecases/create_template_usecase.dart
    │       │       ↓
    │       │       ├─→ domain/entities/template_entity.dart
    │       │       ├─→ domain/validators/template_validator.dart
    │       │       └─→ domain/repositories/template_repository.dart (interface)
    │       │               ↓
    │       │               └─→ data/repositories/supabase_template_repository.dart
    │       │                       ↓
    │       │                       ├─→ data/services/template_data_service.dart
    │       │                       │       ↓
    │       │                       │       └─→ Supabase Client
    │       │                       │
    │       │                       └─→ data/cache/template_cache_repository.dart
    │       │
    │       └─→ domain/usecases/delete_template_usecase.dart
    │
    ├─→ presentation/modals/add_template_bottom_sheet.dart
    │       ↓
    │       ├─→ presentation/widgets/wizard/step_indicator.dart
    │       ├─→ presentation/widgets/wizard/template_basic_info_form.dart
    │       ├─→ presentation/widgets/wizard/account_selector_card.dart
    │       └─→ domain/factories/template_line_factory.dart
    │
    └─→ presentation/modals/quick_template_bottom_sheet.dart
            ↓
            └─→ presentation/widgets/forms/quick_amount_input.dart
```

---

## 🎯 Quick Commands for AI

### Command: "Create new validator"

```
1. Create file: domain/validators/{name}_validator.dart
2. Follow pattern from template_validator.dart
3. Add validation logic
4. Return ValidationResult
5. Register in validator_providers.dart
```

---

### Command: "Add new UI component"

```
1. Create file: presentation/widgets/{category}/{name}.dart
2. Use StatelessWidget if no local state
3. Import Toss Design System
4. Use TossColors, TossTextStyles, TossSpacing
5. Add example usage in doc comment
```

---

### Command: "Modify business logic"

```
1. ⚠️ WARNING: This changes business rules!
2. Modify: domain/usecases/{name}_usecase.dart
3. Update: domain/entities/{name}_entity.dart validation
4. Update: domain/validators/{name}_validator.dart
5. Test: Ensure no breaking changes
6. ❌ DO NOT touch presentation or data layers
```

---

## 📚 Additional Resources

- [UI Designer Guide](./UI_DESIGNER_GUIDE.md) - For UI/UX designers
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev)
- [Supabase Documentation](https://supabase.com/docs)

---

**Last Updated**: 2025-10-13
**Version**: 1.0
**Code Quality Score**: 88/100 (A+)
