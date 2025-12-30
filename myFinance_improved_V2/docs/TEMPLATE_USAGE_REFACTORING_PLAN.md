# Template Usage Refactoring Plan (v2 - Clean Architecture 정합)

## 개요

`TemplateUsageBottomSheet`를 `create_transaction_from_template` RPC 대신 `insert_journal_with_everything_utc` RPC를 직접 호출하는 방식으로 리팩토링합니다.

**⚠️ 중요: 기존 Clean Architecture 패턴 100% 준수**

이 프로젝트는 이미 완성도 높은 Clean Architecture를 갖추고 있습니다. 새로운 코드 추가 시 기존 패턴과 **충돌 없이 확장**해야 합니다.

---

## 0. 기존 아키텍처 분석 (🔍 필수 선행 분석)

### 0.1 현재 transaction_template Domain Layer 구조

```
domain/
├── constants/
│   └── permission_constants.dart
├── entities/                           # ✅ 비즈니스 핵심 엔티티만
│   ├── template_entity.dart            # 템플릿 엔티티 (~600줄)
│   ├── template_attachment.dart        # 첨부파일 엔티티
│   ├── transaction_entity.dart         # 거래 엔티티
│   └── transaction_line_entity.dart    # 거래 라인 엔티티
├── enums/                              # ✅ Enum 정의
│   ├── template_enums.dart             # FormComplexity, AccountType 등
│   ├── template_constants.dart
│   └── approval_level.dart
├── exceptions/                         # ✅ 예외 클래스
│   ├── domain_exception.dart
│   ├── template_business_exception.dart
│   ├── validation_error.dart           # ⚠️ ValidationError 클래스 이미 존재!
│   └── validation_exception.dart
├── factories/
│   └── template_line_factory.dart
├── repositories/
│   ├── template_repository.dart
│   └── transaction_repository.dart
├── services/                           # ✅ 도메인 서비스 (비즈니스 로직)
│   └── account_mapping_validator.dart
├── usecases/
│   ├── create_template_usecase.dart
│   ├── create_transaction_usecase.dart
│   ├── create_transaction_from_template_usecase.dart  # ⚠️ 교체 대상
│   ├── delete_template_usecase.dart
│   └── update_template_usecase.dart
├── validators/                         # ✅ 검증 로직 (독립 클래스)
│   ├── template_form_validator.dart    # ⚠️ 확장 대상 (p_lines 검증 추가)
│   ├── template_validator.dart
│   ├── template_validation_result.dart
│   └── transaction_validator.dart
└── value_objects/                      # ✅ Value Objects (불변 데이터)
    ├── template_analysis_result.dart   # ⚠️ 이미 존재! (재사용 + 확장)
    ├── template_creation_data.dart
    ├── template_debt_configuration.dart
    ├── template_filter.dart
    ├── transaction_amount.dart         # ⚠️ 재사용
    ├── transaction_context.dart        # ⚠️ 재사용
    ├── transaction_counterparty.dart
    ├── transaction_location.dart
    └── transaction_metadata.dart
```

### 0.2 🔴 기존 클래스 재사용 전략 (중복 방지)

| 기존 클래스 | 위치 | 현재 용도 | 리팩토링 방향 |
|------------|------|----------|--------------|
| **`TemplateAnalysisResult`** | `value_objects/` | UI 복잡도 분석 (FormComplexity) | ✅ **재사용** - `rpcType` getter만 추가 |
| **`FormComplexity`** | `enums/template_enums.dart` | `simple`, `withCash`, `withCounterparty`, `complex` | ✅ **그대로 사용** |
| **`ValidationError`** | `exceptions/validation_error.dart` | 필드 검증 에러 | ✅ **재사용** - p_lines 에러에 활용 |
| **`TemplateFormValidator`** | `validators/` | 폼 입력 검증 | ✅ **확장** - p_lines 사전 검증 추가 |
| **`TransactionAmount`** | `value_objects/` | 금액 검증 Value Object | ✅ **재사용** |

### 0.3 ⚠️ 계획 수정 사항 (충돌 방지)

| 원래 계획 | 문제점 | **수정된 계획** |
|----------|--------|----------------|
| `template_type.dart` 신규 생성 | `FormComplexity` 이미 존재 | `template_enums.dart`에 **`TemplateRpcType` enum 추가** |
| `template_analysis_result.dart` 신규 생성 | 동일 파일명 이미 존재 | 기존 `TemplateAnalysisResult`에 **`rpcType` getter 추가** |
| `rpc_result.dart` (domain/entities/) | entities는 비즈니스 엔티티용 | **`value_objects/template_rpc_result.dart`** 생성 |
| `template_ui_config.dart` 신규 생성 | 불필요 (기존 로직 활용) | **생성하지 않음** - 기존 `TemplateAnalysisResult` 활용 |
| `template_defaults.dart` 신규 생성 | Value Object 패턴 필요 | **`value_objects/template_defaults.dart`** 생성 |
| `TemplateLinesValidator` 신규 생성 | Validator 패턴 준수 | **`validators/template_lines_validator.dart`** 생성 |

---

## 1. 현재 구조 분석

### 1.1 현재 아키텍처

```
┌──────────────────────────────────────────────────────────────────┐
│                 TemplateUsageBottomSheet                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  [Load Template]                                                 │
│       │                                                          │
│       ▼                                                          │
│  getTemplateForUsage (RPC)  ──► TemplateUsageResponseDto         │
│       │                           ├── success                    │
│       │                           ├── template                   │
│       │                           ├── ui_config                  │
│       │                           ├── analysis                   │
│       │                           └── defaults                   │
│       │                                                          │
│       ▼                                                          │
│  [Show Form]                                                     │
│       │ - Amount input                                           │
│       │ - Description input                                      │
│       │ - Cash location selector (conditional)                   │
│       │ - Counterparty selector (conditional)                    │
│       │ - Attachments                                            │
│       │                                                          │
│       ▼                                                          │
│  [Submit]                                                        │
│       │                                                          │
│       ▼                                                          │
│  create_transaction_from_template (RPC) ◄── 현재 방식            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 1.2 현재 문제점

| 문제 | 설명 |
|------|------|
| **RPC 의존성** | `create_transaction_from_template`은 서버 측 로직에 의존 |
| **유연성 부족** | 서버 RPC 수정 없이 클라이언트 동작 변경 어려움 |
| **디버깅 어려움** | 서버에서 무슨 일이 일어나는지 추적 어려움 |
| **중복 로직** | `get_template_for_usage`와 `create_transaction_from_template` 사이 중복 분석 |

### 1.3 현재 파일 구조 (실제)

```
lib/features/transaction_template/
├── data/
│   ├── cache/
│   │   └── template_cache_repository.dart
│   ├── datasources/
│   │   └── template_data_source.dart
│   ├── dtos/
│   │   ├── template_dto.dart
│   │   ├── template_usage_response_dto.dart
│   │   └── transaction_dto.dart
│   ├── mappers/
│   │   └── template_mapper.dart
│   ├── providers/
│   │   └── repository_providers.dart
│   ├── repositories/
│   │   ├── supabase_template_repository.dart
│   │   └── supabase_transaction_repository.dart
│   └── services/
│       └── account_mapping_validator_impl.dart
├── domain/
│   ├── constants/
│   ├── entities/
│   ├── enums/
│   ├── exceptions/
│   ├── factories/
│   ├── repositories/
│   ├── services/
│   ├── usecases/
│   ├── validators/
│   └── value_objects/
└── presentation/
    ├── dialogs/
    ├── modals/
    ├── pages/
    ├── providers/
    │   └── states/
    └── widgets/
        ├── common/
        ├── forms/
        └── wizard/
```

---

## 2. 새로운 아키텍처

### 2.1 목표 아키텍처

```
┌──────────────────────────────────────────────────────────────────┐
│                 TemplateUsageBottomSheet (Simplified)            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  [Load Template]                                                 │
│       │                                                          │
│       ▼                                                          │
│  Client-side Analysis (NO RPC)                                   │
│       │   └── TemplateAnalysisResult.analyze(template)  ◄─ 기존  │
│       │   └── _determineRpcType(data)                   ◄─ 신규  │
│       │                                                          │
│       ▼                                                          │
│  [Show Form] (Same UI, 기존 FormComplexity 활용)                 │
│       │                                                          │
│       ▼                                                          │
│  [Submit]                                                        │
│       │                                                          │
│       ▼                                                          │
│  Client-side Validation                                          │
│       │   └── TemplateLinesValidator.validate(lines)    ◄─ 신규  │
│       │                                                          │
│       ▼                                                          │
│  Client-side Build p_lines                                       │
│       │   └── TemplateLinesBuilder.build(...)           ◄─ 신규  │
│       │                                                          │
│       ▼                                                          │
│  insert_journal_with_everything_utc (RPC) ◄── 새로운 방식        │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 2.2 핵심 변경사항

| Before | After |
|--------|-------|
| `get_template_for_usage` RPC | `TemplateAnalysisResult.analyze()` (기존 클래스 활용) |
| `create_transaction_from_template` RPC | `insert_journal_with_everything_utc` RPC |
| Server-side template analysis | Client-side analysis (기존 로직 확장) |
| Server-side p_lines building | `TemplateLinesBuilder` (신규) |
| 없음 | `TemplateLinesValidator` (신규 - 사전 검증) |

---

## 3. 새로운 클래스 설계 (기존 아키텍처 정합)

### 3.1 TemplateRpcType Enum (기존 파일에 추가)

```dart
// lib/features/transaction_template/domain/enums/template_enums.dart
// ⚠️ 기존 파일에 추가 (새 파일 생성 X)

/// RPC 호출 시 템플릿 유형 (p_lines 빌드 방식 결정)
///
/// FormComplexity와 별개로 RPC 파라미터 빌드 로직에 사용됩니다.
/// - FormComplexity: UI 폼 복잡도 (어떤 필드를 보여줄지)
/// - TemplateRpcType: RPC 호출 방식 (p_lines 구성 방법)
enum TemplateRpcType {
  /// Cash-Cash: 모든 값 고정 (cash_location 변경 불가)
  cashCash,

  /// Internal: linked_company 있음, 모든 값 고정, Mirror Journal 생성
  internal,

  /// External Debt: counterparty, cash_location 변경 가능
  externalDebt,

  /// Expense/Revenue + Cash: cash_location만 변경 가능
  expenseRevenueCash,

  /// 알 수 없는 유형 (모든 필드 활성화)
  unknown,
}

/// Extension for TemplateRpcType
extension TemplateRpcTypeExtension on TemplateRpcType {
  /// cash_location 변경 가능 여부
  bool get canOverrideCashLocation {
    return this == TemplateRpcType.externalDebt ||
           this == TemplateRpcType.expenseRevenueCash ||
           this == TemplateRpcType.unknown;
  }

  /// counterparty 변경 가능 여부
  bool get canOverrideCounterparty {
    return this == TemplateRpcType.externalDebt ||
           this == TemplateRpcType.unknown;
  }

  /// Mirror Journal 생성 여부
  bool get createsMirrorJournal {
    return this == TemplateRpcType.internal;
  }

  /// 디버그용 표시 이름
  String get displayName {
    switch (this) {
      case TemplateRpcType.cashCash:
        return 'Cash-Cash (고정)';
      case TemplateRpcType.internal:
        return 'Internal (Mirror)';
      case TemplateRpcType.externalDebt:
        return 'External Debt';
      case TemplateRpcType.expenseRevenueCash:
        return 'Expense/Revenue + Cash';
      case TemplateRpcType.unknown:
        return 'Unknown';
    }
  }
}
```

### 3.2 TemplateAnalysisResult 확장 (기존 파일 수정)

```dart
// lib/features/transaction_template/domain/value_objects/template_analysis_result.dart
// ⚠️ 기존 클래스에 rpcType getter만 추가

/// TemplateAnalysisResult 클래스에 추가할 코드:

  /// RPC 호출 유형 결정 (p_lines 빌드 방식)
  ///
  /// 기존 FormComplexity와 별개로 RPC 파라미터 구성에 사용됩니다.
  TemplateRpcType get rpcType {
    // analyze() 메서드에서 이미 파싱한 데이터 기반 판별
    // missingItems를 기반으로 추론

    // Internal: counterparty_cash_location이 설정되어 있음
    if (!missingItems.contains('counterparty_cash_location') &&
        missingItems.contains('counterparty')) {
      // counterparty가 필요 없고 counterparty_cash_location도 없으면 internal
      return TemplateRpcType.internal;
    }

    // 복잡도 기반 매핑
    switch (complexity) {
      case FormComplexity.simple:
        // amount만 필요 = Expense/Revenue + Cash 또는 Cash-Cash
        if (missingItems.length == 1 && missingItems.contains('amount')) {
          return TemplateRpcType.expenseRevenueCash;
        }
        return TemplateRpcType.cashCash;

      case FormComplexity.withCash:
        return TemplateRpcType.expenseRevenueCash;

      case FormComplexity.withCounterparty:
        // counterparty 필요 = External Debt
        if (missingItems.contains('counterparty_cash_location')) {
          return TemplateRpcType.internal;
        }
        return TemplateRpcType.externalDebt;

      case FormComplexity.complex:
        return TemplateRpcType.unknown;
    }
  }

  /// RPC 타입을 더 정확하게 판별하는 static 메서드
  ///
  /// 템플릿 데이터를 직접 분석하여 RPC 타입을 결정합니다.
  static TemplateRpcType determineRpcType(List<dynamic> data, Map<String, dynamic> template) {
    int cashCount = 0;
    bool hasReceivablePayable = false;
    bool hasOther = false;
    bool hasCounterpartyCashLocationId = false;
    bool hasLinkedCompanyId = false;

    for (final line in data) {
      final categoryTag = line['category_tag']?.toString();

      if (categoryTag == 'cash' || categoryTag == 'bank') {
        cashCount++;
      }
      if (categoryTag == 'receivable' || categoryTag == 'payable') {
        hasReceivablePayable = true;
      }
      if (categoryTag == 'other' || categoryTag == null) {
        hasOther = true;
      }

      // Internal 판별
      if (line['counterparty_cash_location_id'] != null &&
          line['counterparty_cash_location_id'].toString().isNotEmpty) {
        hasCounterpartyCashLocationId = true;
      }
      if (line['linked_company_id'] != null &&
          line['linked_company_id'].toString().isNotEmpty) {
        hasLinkedCompanyId = true;
      }
    }

    // Template-level counterparty_cash_location_id 체크
    final templateCashLoc = template['counterparty_cash_location_id'];
    if (templateCashLoc != null && templateCashLoc.toString().isNotEmpty) {
      hasCounterpartyCashLocationId = true;
    }

    // 1. Cash-Cash: 두 개 이상의 cash/bank 계정
    if (cashCount >= 2) {
      return TemplateRpcType.cashCash;
    }

    // 2. Internal: counterparty_cash_location_id 또는 linked_company_id 있음
    if ((hasCounterpartyCashLocationId || hasLinkedCompanyId) && hasReceivablePayable) {
      return TemplateRpcType.internal;
    }

    // 3. External Debt: receivable/payable + cash
    if (hasReceivablePayable && cashCount == 1) {
      return TemplateRpcType.externalDebt;
    }

    // 4. Expense/Revenue + Cash
    if (hasOther && cashCount == 1) {
      return TemplateRpcType.expenseRevenueCash;
    }

    return TemplateRpcType.unknown;
  }
```

### 3.3 TemplateDefaults Value Object (신규)

```dart
// lib/features/transaction_template/domain/value_objects/template_defaults.dart
// ✅ 신규 생성 (value_objects 폴더에 위치)

import 'package:equatable/equatable.dart';

/// 템플릿에서 추출한 기본값들
///
/// RPC 호출 시 사용자가 변경하지 않은 경우 사용되는 기본값입니다.
class TemplateDefaults extends Equatable {
  /// 기본 현금 위치 ID
  final String? cashLocationId;

  /// 기본 현금 위치 이름 (UI 표시용)
  final String? cashLocationName;

  /// 기본 거래상대 ID
  final String? counterpartyId;

  /// 기본 거래상대 이름 (UI 표시용)
  final String? counterpartyName;

  /// 거래상대의 현금 위치 ID (Internal 거래용)
  final String? counterpartyCashLocationId;

  /// 거래상대의 매장 ID (Internal 거래용, linked_company_store_id)
  final String? counterpartyStoreId;

  /// 거래상대의 매장 이름 (UI 표시용)
  final String? counterpartyStoreName;

  const TemplateDefaults({
    this.cashLocationId,
    this.cashLocationName,
    this.counterpartyId,
    this.counterpartyName,
    this.counterpartyCashLocationId,
    this.counterpartyStoreId,
    this.counterpartyStoreName,
  });

  /// 템플릿 데이터에서 기본값 추출
  factory TemplateDefaults.fromTemplate(
    List<dynamic> data,
    Map<String, dynamic> template,
  ) {
    String? cashLocationId;
    String? cashLocationName;
    String? counterpartyId;
    String? counterpartyName;
    String? counterpartyCashLocationId;
    String? counterpartyStoreId;
    String? counterpartyStoreName;

    // 라인 데이터에서 추출
    for (final line in data) {
      cashLocationId ??= _extractString(line['cash_location_id']);
      cashLocationName ??= _extractString(line['cash_location_name']);
      counterpartyId ??= _extractString(line['counterparty_id']);
      counterpartyName ??= _extractString(line['counterparty_name']);
      counterpartyCashLocationId ??= _extractString(line['counterparty_cash_location_id']);
      counterpartyStoreId ??= _extractString(line['counterparty_store_id']);
      counterpartyStoreName ??= _extractString(line['counterparty_store_name']);
    }

    // Template-level fallback
    counterpartyId ??= _extractString(template['counterparty_id']);
    counterpartyCashLocationId ??= _extractString(template['counterparty_cash_location_id']);

    return TemplateDefaults(
      cashLocationId: cashLocationId,
      cashLocationName: cashLocationName,
      counterpartyId: counterpartyId,
      counterpartyName: counterpartyName,
      counterpartyCashLocationId: counterpartyCashLocationId,
      counterpartyStoreId: counterpartyStoreId,
      counterpartyStoreName: counterpartyStoreName,
    );
  }

  /// 빈 문자열을 null로 변환하는 헬퍼
  static String? _extractString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  /// 빈 기본값
  static const empty = TemplateDefaults();

  /// 모든 필수 값이 있는지 확인
  bool get hasAllRequiredValues =>
    cashLocationId != null && counterpartyId != null;

  /// Internal 거래에 필요한 값이 있는지 확인
  bool get hasInternalValues => counterpartyCashLocationId != null;

  @override
  List<Object?> get props => [
    cashLocationId,
    cashLocationName,
    counterpartyId,
    counterpartyName,
    counterpartyCashLocationId,
    counterpartyStoreId,
    counterpartyStoreName,
  ];

  @override
  String toString() => 'TemplateDefaults('
      'cashLocationId: $cashLocationId, '
      'counterpartyId: $counterpartyId, '
      'counterpartyCashLocationId: $counterpartyCashLocationId)';
}
```

### 3.4 TemplateRpcResult (신규 - Value Object)

```dart
// lib/features/transaction_template/domain/value_objects/template_rpc_result.dart
// ✅ 신규 생성 (value_objects 폴더에 위치)

import 'package:freezed_annotation/freezed_annotation.dart';
import '../exceptions/validation_error.dart';

part 'template_rpc_result.freezed.dart';

/// RPC 호출 결과를 타입 안전하게 표현
///
/// Freezed union type으로 모든 가능한 결과를 명시적으로 처리합니다.
@freezed
class TemplateRpcResult with _$TemplateRpcResult {
  /// 성공
  const factory TemplateRpcResult.success({
    required String journalId,
    String? mirrorJournalId,
  }) = TemplateRpcSuccess;

  /// 클라이언트 검증 에러 (서버 호출 전)
  const factory TemplateRpcResult.clientValidationError({
    required List<ValidationError> errors,
  }) = TemplateRpcClientValidationError;

  /// 서버 검증 에러 ([검증 실패] prefix)
  const factory TemplateRpcResult.serverValidationError({
    required String message,
    int? lineNumber,
  }) = TemplateRpcServerValidationError;

  /// 차대변 불균형 에러
  const factory TemplateRpcResult.balanceError({
    required double totalDebit,
    required double totalCredit,
  }) = TemplateRpcBalanceError;

  /// 데이터베이스 에러
  const factory TemplateRpcResult.databaseError({
    required String code,
    required String message,
  }) = TemplateRpcDatabaseError;

  /// 알 수 없는 에러
  const factory TemplateRpcResult.unknownError({
    required String message,
  }) = TemplateRpcUnknownError;
}

/// TemplateRpcResult 확장 메서드
extension TemplateRpcResultX on TemplateRpcResult {
  /// 성공 여부
  bool get isSuccess => this is TemplateRpcSuccess;

  /// 에러 여부
  bool get isError => !isSuccess;

  /// 사용자에게 표시할 에러 메시지
  String? get errorMessage {
    return when(
      success: (_, __) => null,
      clientValidationError: (errors) =>
        errors.map((e) => e.message).join('\n'),
      serverValidationError: (message, lineNumber) =>
        lineNumber != null ? '라인 $lineNumber: $message' : message,
      balanceError: (debit, credit) =>
        '차변(${debit.toStringAsFixed(0)})과 대변(${credit.toStringAsFixed(0)})이 일치하지 않습니다.',
      databaseError: (_, message) => message,
      unknownError: (message) => message,
    );
  }
}
```

### 3.5 TemplateLinesValidator (신규 - Validator 패턴)

```dart
// lib/features/transaction_template/domain/validators/template_lines_validator.dart
// ✅ 신규 생성 (validators 폴더에 위치)

import '../exceptions/validation_error.dart';

/// p_lines 배열 검증 결과
class LinesValidationResult {
  final bool isValid;
  final List<ValidationError> errors;

  const LinesValidationResult._({
    required this.isValid,
    required this.errors,
  });

  factory LinesValidationResult.success() =>
    const LinesValidationResult._(isValid: true, errors: []);

  factory LinesValidationResult.error(ValidationError error) =>
    LinesValidationResult._(isValid: false, errors: [error]);

  factory LinesValidationResult.errors(List<ValidationError> errors) =>
    LinesValidationResult._(isValid: errors.isEmpty, errors: errors);

  String? get firstErrorMessage => errors.isNotEmpty ? errors.first.message : null;
}

/// p_lines 배열 사전 검증 (RPC 호출 전)
///
/// 서버에서 발생할 수 있는 검증 에러를 클라이언트에서 미리 체크합니다.
/// 이를 통해 불필요한 서버 요청을 줄이고 빠른 피드백을 제공합니다.
class TemplateLinesValidator {
  /// p_lines 배열 전체 검증
  static LinesValidationResult validateLines(List<Map<String, dynamic>> lines) {
    final errors = <ValidationError>[];

    // 1. 기본 구조 검증
    if (lines.isEmpty) {
      return LinesValidationResult.error(
        const ValidationError(
          fieldName: 'lines',
          fieldValue: '[]',
          validationRule: 'notEmpty',
          message: '최소 1개 이상의 라인이 필요합니다',
        ),
      );
    }

    // 2. 각 라인 검증
    for (int i = 0; i < lines.length; i++) {
      final lineErrors = _validateLine(lines[i], i + 1);
      errors.addAll(lineErrors);
    }

    // 3. 차대변 균형 검증
    final balanceError = _validateBalance(lines);
    if (balanceError != null) {
      errors.add(balanceError);
    }

    // 4. 복수 linked_company 검증
    final linkedCompanyError = _validateSingleLinkedCompany(lines);
    if (linkedCompanyError != null) {
      errors.add(linkedCompanyError);
    }

    return LinesValidationResult.errors(errors);
  }

  static List<ValidationError> _validateLine(Map<String, dynamic> line, int lineNumber) {
    final errors = <ValidationError>[];

    // account_id 검증
    final accountId = line['account_id']?.toString();
    if (accountId == null || accountId.isEmpty) {
      errors.add(ValidationError(
        fieldName: 'account_id',
        fieldValue: accountId ?? 'null',
        validationRule: 'required',
        message: '라인 $lineNumber: account_id가 없거나 비어있습니다.',
      ));
    } else if (!_isValidUuid(accountId)) {
      errors.add(ValidationError(
        fieldName: 'account_id',
        fieldValue: accountId,
        validationRule: 'uuid',
        message: '라인 $lineNumber: account_id가 유효한 UUID가 아닙니다.',
      ));
    }

    // debit/credit 검증
    final debit = _parseNumber(line['debit']);
    final credit = _parseNumber(line['credit']);

    if ((debit == null || debit == 0) && (credit == null || credit == 0)) {
      errors.add(ValidationError(
        fieldName: 'amount',
        fieldValue: 'debit: $debit, credit: $credit',
        validationRule: 'required',
        message: '라인 $lineNumber: debit 또는 credit 중 하나는 0보다 커야 합니다.',
      ));
    }

    // debt 객체 검증 (있는 경우에만)
    final debt = line['debt'];
    if (debt != null && debt is Map<String, dynamic>) {
      final debtErrors = _validateDebtObject(debt, lineNumber);
      errors.addAll(debtErrors);
    }

    // cash 객체 검증 (있는 경우에만)
    final cash = line['cash'];
    if (cash != null && cash is Map<String, dynamic>) {
      final cashErrors = _validateCashObject(cash, lineNumber);
      errors.addAll(cashErrors);
    }

    return errors;
  }

  static List<ValidationError> _validateDebtObject(Map<String, dynamic> debt, int lineNumber) {
    final errors = <ValidationError>[];

    final counterpartyId = debt['counterparty_id']?.toString();
    if (counterpartyId == null || counterpartyId.isEmpty) {
      errors.add(ValidationError(
        fieldName: 'debt.counterparty_id',
        fieldValue: counterpartyId ?? 'null',
        validationRule: 'required',
        message: '라인 $lineNumber: debt에 counterparty_id가 없습니다.',
      ));
    } else if (!_isValidUuid(counterpartyId)) {
      errors.add(ValidationError(
        fieldName: 'debt.counterparty_id',
        fieldValue: counterpartyId,
        validationRule: 'uuid',
        message: '라인 $lineNumber: debt의 counterparty_id가 유효한 UUID가 아닙니다.',
      ));
    }

    final direction = debt['direction']?.toString();
    if (direction == null || direction.isEmpty) {
      errors.add(ValidationError(
        fieldName: 'debt.direction',
        fieldValue: direction ?? 'null',
        validationRule: 'required',
        message: '라인 $lineNumber: debt에 direction이 없습니다.',
      ));
    } else if (direction != 'receivable' && direction != 'payable') {
      errors.add(ValidationError(
        fieldName: 'debt.direction',
        fieldValue: direction,
        validationRule: 'enum',
        message: '라인 $lineNumber: debt의 direction은 "receivable" 또는 "payable"이어야 합니다.',
      ));
    }

    final category = debt['category']?.toString();
    if (category == null || category.isEmpty) {
      errors.add(ValidationError(
        fieldName: 'debt.category',
        fieldValue: category ?? 'null',
        validationRule: 'required',
        message: '라인 $lineNumber: debt에 category가 없습니다.',
      ));
    }

    return errors;
  }

  static List<ValidationError> _validateCashObject(Map<String, dynamic> cash, int lineNumber) {
    final errors = <ValidationError>[];

    final cashLocationId = cash['cash_location_id']?.toString();
    if (cashLocationId != null &&
        cashLocationId.isNotEmpty &&
        !_isValidUuid(cashLocationId)) {
      errors.add(ValidationError(
        fieldName: 'cash.cash_location_id',
        fieldValue: cashLocationId,
        validationRule: 'uuid',
        message: '라인 $lineNumber: cash의 cash_location_id가 유효한 UUID가 아닙니다.',
      ));
    }

    return errors;
  }

  static ValidationError? _validateBalance(List<Map<String, dynamic>> lines) {
    double totalDebit = 0;
    double totalCredit = 0;

    for (final line in lines) {
      totalDebit += _parseNumber(line['debit']) ?? 0;
      totalCredit += _parseNumber(line['credit']) ?? 0;
    }

    // 소수점 오차 허용 (0.01 이내)
    if ((totalDebit - totalCredit).abs() > 0.01) {
      return ValidationError(
        fieldName: 'balance',
        fieldValue: 'debit: $totalDebit, credit: $totalCredit',
        validationRule: 'balance',
        message: '차변($totalDebit)과 대변($totalCredit)의 합계가 일치하지 않습니다.',
      );
    }

    return null;
  }

  static ValidationError? _validateSingleLinkedCompany(List<Map<String, dynamic>> lines) {
    final linkedCompanyIds = <String>{};

    for (final line in lines) {
      final debt = line['debt'] as Map<String, dynamic>?;
      if (debt != null) {
        final linkedCompanyId = debt['linked_company_id']?.toString();
        if (linkedCompanyId != null && linkedCompanyId.isNotEmpty) {
          linkedCompanyIds.add(linkedCompanyId);
        }
      }
    }

    if (linkedCompanyIds.length > 1) {
      return ValidationError(
        fieldName: 'linked_company',
        fieldValue: linkedCompanyIds.toString(),
        validationRule: 'single',
        message: '한 저널에 여러 linked_company가 포함되어 있습니다.',
      );
    }

    return null;
  }

  static bool _isValidUuid(String value) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(value);
  }

  static double? _parseNumber(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
```

### 3.6 TemplateLinesBuilder (신규 - Domain Service)

```dart
// lib/features/transaction_template/domain/services/template_lines_builder.dart
// ✅ 신규 생성 (services 폴더에 위치)

import '../enums/template_enums.dart';

/// 템플릿 데이터를 RPC p_lines 형식으로 변환
///
/// 이 클래스는 순수 함수들로 구성되어 있으며,
/// 템플릿의 원본 데이터를 RPC 호출에 필요한 형식으로 변환합니다.
class TemplateLinesBuilder {

  /// p_lines 배열 빌드
  ///
  /// [templateData]: 템플릿의 data 배열
  /// [amount]: 사용자가 입력한 금액
  /// [rpcType]: 템플릿 RPC 타입 (오버라이드 가능 여부 결정)
  /// [overrideCashLocationId]: 사용자가 선택한 현금 위치 (변경 가능한 경우)
  /// [overrideCounterpartyId]: 사용자가 선택한 거래상대 (변경 가능한 경우)
  static List<Map<String, dynamic>> build({
    required List<dynamic> templateData,
    required double amount,
    required TemplateRpcType rpcType,
    String? overrideCashLocationId,
    String? overrideCounterpartyId,
  }) {
    final lines = <Map<String, dynamic>>[];
    final entryDate = DateTime.now().toIso8601String().split('T').first;

    for (int i = 0; i < templateData.length; i++) {
      final rawLine = templateData[i] as Map<String, dynamic>;

      // 1. 데이터 정규화 (레거시 호환)
      final normalizedLine = _normalizeLine(rawLine, i);

      // 2. RPC 라인 빌드
      final rpcLine = _buildRpcLine(
        line: normalizedLine,
        amount: amount,
        rpcType: rpcType,
        overrideCashLocationId: overrideCashLocationId,
        overrideCounterpartyId: overrideCounterpartyId,
        entryDate: entryDate,
      );

      lines.add(rpcLine);
    }

    return lines;
  }

  /// 구버전/신버전 템플릿 데이터 정규화
  ///
  /// 다양한 템플릿 데이터 형식을 일관된 형식으로 변환합니다.
  static Map<String, dynamic> _normalizeLine(Map<String, dynamic> raw, int index) {
    final normalized = Map<String, dynamic>.from(raw);

    // 1. type 필드 정규화 (누락 시 첫 번째=debit, 나머지=credit)
    if (normalized['type'] == null) {
      normalized['type'] = index == 0 ? 'debit' : 'credit';
    }

    // 2. category_tag 정규화 (null → 'other')
    if (normalized['category_tag'] == null) {
      final accountName = normalized['account_name']?.toString().toLowerCase() ?? '';
      if (accountName.contains('cash') || accountName.contains('bank')) {
        normalized['category_tag'] = 'cash';
      } else if (accountName.contains('receivable')) {
        normalized['category_tag'] = 'receivable';
      } else if (accountName.contains('payable')) {
        normalized['category_tag'] = 'payable';
      } else {
        normalized['category_tag'] = 'other';
      }
    }

    // 3. cash 구조 정규화 (nested → flat)
    if (normalized['cash'] is Map) {
      final cashObj = normalized['cash'] as Map<String, dynamic>;
      normalized['cash_location_id'] ??= cashObj['cash_location_id'];
    }

    // 4. 빈 문자열 → null 정규화
    normalized['counterparty_id'] = _emptyToNull(normalized['counterparty_id']);
    normalized['cash_location_id'] = _emptyToNull(normalized['cash_location_id']);
    normalized['counterparty_cash_location_id'] = _emptyToNull(normalized['counterparty_cash_location_id']);
    normalized['counterparty_store_id'] = _emptyToNull(normalized['counterparty_store_id']);

    return normalized;
  }

  static String? _emptyToNull(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  static Map<String, dynamic> _buildRpcLine({
    required Map<String, dynamic> line,
    required double amount,
    required TemplateRpcType rpcType,
    String? overrideCashLocationId,
    String? overrideCounterpartyId,
    required String entryDate,
  }) {
    final type = line['type']?.toString() ?? 'debit';
    final accountId = line['account_id']?.toString() ?? '';
    final categoryTag = line['category_tag']?.toString() ?? 'other';

    // Base line
    final rpcLine = <String, dynamic>{
      'account_id': accountId,
      'debit': type == 'debit' ? amount.toStringAsFixed(0) : '0',
      'credit': type == 'credit' ? amount.toStringAsFixed(0) : '0',
    };

    // Cash object 빌드
    if (categoryTag == 'cash' || categoryTag == 'bank') {
      final cashLocationId = _resolveCashLocationId(
        line: line,
        rpcType: rpcType,
        overrideCashLocationId: overrideCashLocationId,
      );

      if (cashLocationId != null) {
        rpcLine['cash'] = {'cash_location_id': cashLocationId};
      }
    }

    // Debt object 빌드
    if (categoryTag == 'receivable' || categoryTag == 'payable') {
      final debtObj = _buildDebtObject(
        line: line,
        categoryTag: categoryTag,
        rpcType: rpcType,
        overrideCounterpartyId: overrideCounterpartyId,
        entryDate: entryDate,
      );

      if (debtObj != null) {
        rpcLine['debt'] = debtObj;
      }
    }

    return rpcLine;
  }

  static String? _resolveCashLocationId({
    required Map<String, dynamic> line,
    required TemplateRpcType rpcType,
    String? overrideCashLocationId,
  }) {
    // 오버라이드 가능 여부에 따라 결정
    if (rpcType.canOverrideCashLocation) {
      return overrideCashLocationId ?? line['cash_location_id']?.toString();
    }

    // 고정 타입은 템플릿 값만 사용
    return line['cash_location_id']?.toString();
  }

  static Map<String, dynamic>? _buildDebtObject({
    required Map<String, dynamic> line,
    required String categoryTag,
    required TemplateRpcType rpcType,
    String? overrideCounterpartyId,
    required String entryDate,
  }) {
    // Counterparty ID 결정
    String? counterpartyId;
    if (rpcType.canOverrideCounterparty) {
      counterpartyId = overrideCounterpartyId ?? line['counterparty_id']?.toString();
    } else {
      counterpartyId = line['counterparty_id']?.toString();
    }

    if (counterpartyId == null || counterpartyId.isEmpty) {
      return null;
    }

    final debtObj = <String, dynamic>{
      'counterparty_id': counterpartyId,
      'direction': categoryTag,
      'category': 'account',
      'issue_date': entryDate,
    };

    // Internal 거래: linked_company_store_id 추가
    if (rpcType == TemplateRpcType.internal) {
      final linkedStoreId = line['counterparty_store_id']?.toString();
      if (linkedStoreId != null && linkedStoreId.isNotEmpty) {
        debtObj['linked_company_store_id'] = linkedStoreId;
      }
    }

    return debtObj;
  }
}
```

---

## 4. 새로운 파일 구조 (기존 아키텍처 정합)

```
lib/features/transaction_template/
├── data/
│   ├── datasources/
│   │   └── template_data_source.dart           # 유지
│   ├── dtos/
│   │   └── template_dto.dart                   # 유지
│   ├── mappers/
│   │   └── template_mapper.dart                # 유지
│   ├── repositories/
│   │   └── supabase_template_repository.dart   # 유지
│   └── services/
│       ├── account_mapping_validator_impl.dart # 유지
│       └── template_rpc_service.dart           # 🆕 RPC 호출 서비스
├── domain/
│   ├── entities/
│   │   ├── template_entity.dart                # 유지
│   │   └── template_attachment.dart            # 유지
│   ├── enums/
│   │   └── template_enums.dart                 # 🔄 수정: TemplateRpcType 추가
│   ├── services/
│   │   ├── account_mapping_validator.dart      # 유지
│   │   └── template_lines_builder.dart         # 🆕 p_lines 빌드
│   ├── validators/
│   │   ├── template_form_validator.dart        # 유지
│   │   ├── template_validator.dart             # 유지
│   │   └── template_lines_validator.dart       # 🆕 p_lines 검증
│   └── value_objects/
│       ├── template_analysis_result.dart       # 🔄 수정: rpcType getter 추가
│       ├── template_defaults.dart              # 🆕 기본값 VO
│       └── template_rpc_result.dart            # 🆕 RPC 결과 (freezed)
└── presentation/
    ├── modals/
    │   └── template_usage_bottom_sheet.dart    # 🔄 리팩토링
    └── providers/
        ├── use_case_providers.dart             # 유지
        └── template_rpc_provider.dart          # 🆕 RPC 서비스 provider
```

---

## 5. 구현 단계 (수정됨)

### Phase 1: Domain Layer (기존 파일 수정 + 신규 파일)

| 순서 | 파일 | 작업 유형 | 설명 |
|-----|------|----------|------|
| 1 | `template_enums.dart` | 🔄 수정 | `TemplateRpcType` enum 추가 |
| 2 | `template_analysis_result.dart` | 🔄 수정 | `rpcType` getter, `determineRpcType()` 추가 |
| 3 | `template_defaults.dart` | 🆕 신규 | 기본값 Value Object |
| 4 | `template_rpc_result.dart` | 🆕 신규 | RPC 결과 freezed 클래스 |
| 5 | `template_lines_validator.dart` | 🆕 신규 | p_lines 사전 검증 |
| 6 | `template_lines_builder.dart` | 🆕 신규 | p_lines 빌드 로직 |

### Phase 2: Data Layer

| 순서 | 파일 | 작업 유형 | 설명 |
|-----|------|----------|------|
| 7 | `template_rpc_service.dart` | 🆕 신규 | RPC 호출 서비스 |

### Phase 3: Presentation Layer

| 순서 | 파일 | 작업 유형 | 설명 |
|-----|------|----------|------|
| 8 | `template_rpc_provider.dart` | 🆕 신규 | Provider 정의 |
| 9 | `template_usage_bottom_sheet.dart` | 🔄 리팩토링 | 메인 UI 수정 |

### Phase 4: 정리 및 테스트

| 순서 | 작업 | 설명 |
|-----|------|------|
| 10 | 빌드 검증 | `dart run build_runner build` (freezed) |
| 11 | 미사용 코드 제거 | `get_template_for_usage` 관련 코드 (선택적) |
| 12 | 테스트 | 모든 템플릿 유형 테스트 |

---

## 6. 데이터 흐름 (리팩토링 후)

### 6.1 전체 데이터 흐름

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USER ACTION                                  │
│                     "템플릿으로 거래 생성"                            │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│  1. TEMPLATE LOAD                                                   │
│  ┌───────────────────┐                                              │
│  │ TemplateRepository │───► TransactionTemplate (Entity)            │
│  │  .findById()      │      └── data: List<Map>                     │
│  └───────────────────┘      └── counterparty_cash_location_id       │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│  2. CLIENT-SIDE ANALYSIS (No Server Call)                           │
│  ┌──────────────────────────┐                                       │
│  │ TemplateAnalysisResult   │                                       │
│  │   .analyze(template)     │───► FormComplexity (UI용)             │
│  │   .determineRpcType()    │───► TemplateRpcType (RPC용)           │
│  └──────────────────────────┘                                       │
│  ┌──────────────────────────┐                                       │
│  │ TemplateDefaults         │───► cashLocationId, counterpartyId    │
│  │   .fromTemplate()        │     counterpartyCashLocationId        │
│  └──────────────────────────┘                                       │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│  3. SHOW FORM (Based on FormComplexity)                             │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ TemplateUsageBottomSheet                                      │   │
│  │ ┌────────────────┐ ┌────────────────┐ ┌──────────────────┐   │   │
│  │ │  Amount Input  │ │ CashLocation   │ │  Counterparty    │   │   │
│  │ │  (Required)    │ │ Selector (Opt) │ │  Selector (Opt)  │   │   │
│  │ └────────────────┘ └────────────────┘ └──────────────────┘   │   │
│  └──────────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────────┘
                             │ User submits form
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│  4. CLIENT-SIDE VALIDATION                                          │
│  ┌────────────────────────┐                                         │
│  │ TemplateFormValidator  │───► Amount > 0?                         │
│  │   .validate()          │     Required fields filled?             │
│  └────────────────────────┘                                         │
│  ┌────────────────────────┐                                         │
│  │ TemplateLinesValidator │───► p_lines 구조 검증                   │
│  │   .validateLines()     │     차대변 균형 검증                    │
│  └────────────────────────┘     UUID 형식 검증                      │
└────────────────────────────┬────────────────────────────────────────┘
                             │ Validation passed
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│  5. BUILD P_LINES                                                   │
│  ┌──────────────────────────┐                                       │
│  │ TemplateLinesBuilder     │                                       │
│  │   .build(                │                                       │
│  │     templateData,        │                                       │
│  │     amount,              │───► List<Map<String, dynamic>>        │
│  │     rpcType,             │     [                                 │
│  │     overrideCashLoc,     │       {account_id, debit, credit,     │
│  │     overrideCounterparty │        cash: {cash_location_id},      │
│  │   )                      │        debt: {counterparty_id, ...}}  │
│  └──────────────────────────┘     ]                                 │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│  6. RPC CALL                                                        │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ insert_journal_with_everything_utc(                           │   │
│  │   p_base_amount: 10000,                                       │   │
│  │   p_company_id: "uuid",                                       │   │
│  │   p_created_by: "uuid",                                       │   │
│  │   p_lines: [...]  ◄── Built by TemplateLinesBuilder          │   │
│  │   p_counterparty_id: "uuid",                                  │   │
│  │   p_if_cash_location_id: "uuid"  ◄── For Internal only       │   │
│  │ )                                                             │   │
│  └──────────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│  7. RESULT HANDLING                                                 │
│  ┌──────────────────────────┐                                       │
│  │ TemplateRpcResult        │                                       │
│  │   .success()             │───► journal_id, mirror_journal_id     │
│  │   .serverValidationError │───► [검증 실패] 메시지 파싱           │
│  │   .balanceError()        │───► 차대변 불일치 처리                │
│  │   .databaseError()       │───► DB 에러 처리                      │
│  └──────────────────────────┘                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 에러 처리 흐름

```
┌─────────────────────────────────────────────────────────────────────┐
│                      ERROR HANDLING FLOW                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────┐                                                │
│  │ Client Errors   │ (RPC 호출 전)                                  │
│  ├─────────────────┤                                                │
│  │ • Amount <= 0   │───► TemplateFormValidator                      │
│  │ • Missing field │     "금액을 입력해주세요"                       │
│  │ • Invalid UUID  │───► TemplateLinesValidator                     │
│  │ • Balance error │     "account_id가 유효하지 않습니다"            │
│  └─────────────────┘                                                │
│           │                                                          │
│           │ 검증 통과                                                │
│           ▼                                                          │
│  ┌─────────────────┐                                                │
│  │ Server Errors   │ (RPC 호출 후)                                  │
│  ├─────────────────┤                                                │
│  │ • [검증 실패]   │───► TemplateRpcErrorParser                     │
│  │   라인 N: ...   │     serverValidationError 파싱                 │
│  │ • 차변/대변     │───► balanceError 처리                          │
│  │   불일치        │                                                │
│  │ • FK 위반       │───► databaseError 처리                         │
│  │ • 네트워크 오류 │───► unknownError 처리                          │
│  └─────────────────┘                                                │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. 마이그레이션 가이드

### 7.1 점진적 마이그레이션 (권장)

```
Phase A: 새 코드 추가 (기존 코드 유지)
    │
    ├── 1. Domain 신규 파일 추가
    ├── 2. Data 신규 파일 추가
    └── 3. 테스트

Phase B: Feature Flag로 전환
    │
    ├── 4. TemplateUsageBottomSheet에 useNewRpc flag 추가
    ├── 5. flag=true 시 새 로직 사용
    └── 6. 테스트

Phase C: 완전 전환
    │
    ├── 7. Feature flag 제거, 새 로직만 사용
    └── 8. 기존 RPC 관련 코드 제거 (선택적)
```

### 7.2 롤백 계획

```dart
// Feature flag 예시
final useDirectRpc = ref.watch(featureFlagProvider('template_direct_rpc'));

if (useDirectRpc) {
  // 새 방식: TemplateLinesBuilder → insert_journal_with_everything_utc
  final result = await ref.read(templateRpcServiceProvider)
    .createJournalFromTemplate(...);
} else {
  // 기존 방식: create_transaction_from_template RPC
  final result = await ref.read(createTransactionFromTemplateUseCaseProvider)
    .execute(...);
}
```

---

## 8. 에러 케이스 분석 및 대응 전략

### 8.1 RPC 에러 전체 목록 (insert_journal_with_everything_utc)

실제 RPC 함수에서 발생할 수 있는 모든 에러를 분석했습니다:

#### 8.1.1 p_lines 구조 에러

| 에러 코드 | 메시지 | 원인 | 클라이언트 대응 |
|----------|--------|------|-----------------|
| `P_LINES_NULL` | `[검증 실패] p_lines가 NULL입니다.` | lines 배열 미전달 | `TemplateLinesBuilder`에서 빈 배열 체크 |
| `P_LINES_NOT_ARRAY` | `[검증 실패] p_lines는 배열이어야 합니다. 현재 타입: %` | JSON 배열 아님 | 타입 검증 추가 |
| `P_LINES_EMPTY` | `[검증 실패] p_lines가 비어있습니다. 최소 1개 이상의 라인이 필요합니다.` | 빈 배열 | 템플릿 데이터 검증 |

#### 8.1.2 라인별 필수 필드 에러

| 에러 코드 | 메시지 | 원인 | 클라이언트 대응 |
|----------|--------|------|-----------------|
| `ACCOUNT_ID_MISSING` | `[검증 실패] 라인 %: account_id가 없거나 비어있습니다.` | account_id 누락 | 템플릿 데이터 검증 |
| `ACCOUNT_ID_INVALID` | `[검증 실패] 라인 %: account_id가 유효한 UUID가 아닙니다. 값: %` | 잘못된 UUID | UUID 포맷 검증 |
| `AMOUNT_MISSING` | `[검증 실패] 라인 %: debit 또는 credit 중 하나는 필수입니다.` | 금액 없음 | 금액 필수 검증 |
| `DEBIT_NOT_NUMBER` | `[검증 실패] 라인 %: debit이 숫자가 아닙니다. 값: %` | debit 형식 오류 | 숫자 형식 검증 |
| `CREDIT_NOT_NUMBER` | `[검증 실패] 라인 %: credit이 숫자가 아닙니다. 값: %` | credit 형식 오류 | 숫자 형식 검증 |

#### 8.1.3 Debt 객체 에러

| 에러 코드 | 메시지 | 원인 | 클라이언트 대응 |
|----------|--------|------|-----------------|
| `DEBT_COUNTERPARTY_MISSING` | `[검증 실패] 라인 %: debt에 counterparty_id가 없습니다.` | counterparty_id 누락 | receivable/payable 템플릿 검증 |
| `DEBT_COUNTERPARTY_INVALID` | `[검증 실패] 라인 %: debt의 counterparty_id가 유효한 UUID가 아닙니다.` | 잘못된 UUID | UUID 포맷 검증 |
| `DEBT_DIRECTION_MISSING` | `[검증 실패] 라인 %: debt에 direction이 없습니다.` | direction 누락 | 자동 설정 |
| `DEBT_DIRECTION_INVALID` | `[검증 실패] 라인 %: debt의 direction은 "receivable" 또는 "payable"이어야 합니다.` | 잘못된 direction 값 | category_tag 기반 자동 설정 |
| `DEBT_CATEGORY_MISSING` | `[검증 실패] 라인 %: debt에 category가 없습니다.` | category 누락 | 기본값 'account' 설정 |
| `DEBT_INTEREST_RATE_INVALID` | `[검증 실패] 라인 %: debt의 interest_rate가 숫자가 아닙니다.` | 형식 오류 | 숫자 형식 검증 |

#### 8.1.4 Cash 객체 에러

| 에러 코드 | 메시지 | 원인 | 클라이언트 대응 |
|----------|--------|------|-----------------|
| `CASH_LOCATION_INVALID` | `[검증 실패] 라인 %: cash의 cash_location_id가 유효한 UUID가 아닙니다.` | 잘못된 UUID | UUID 포맷 검증 |

#### 8.1.5 비즈니스 로직 에러

| 에러 코드 | 메시지 | 원인 | 클라이언트 대응 |
|----------|--------|------|-----------------|
| `MULTIPLE_LINKED_COMPANY` | `[검증 실패] 한 저널에 여러 linked_company가 포함되어 있습니다.` | 복수 내부거래 | 템플릿 데이터 검증 |
| `BALANCE_MISMATCH` | `차변과 대변의 합계가 일치하지 않습니다. 차변: %, 대변: %` | 차대변 불균형 | 클라이언트 사전 검증 |
| `LINKED_COMPANY_NOT_FOUND` | `linked_company_id가 존재하지 않습니다.` | 잘못된 linked_company_id | DB 조회 확인 |
| `LINKED_STORE_NOT_FOUND` | `linked_company_store_id가 존재하지 않습니다.` | 잘못된 store_id | DB 조회 확인 |

#### 8.1.6 경고 (Warning)

| 메시지 | 원인 | 클라이언트 대응 |
|--------|------|-----------------|
| `[경고] linked_company가 있지만 p_if_cash_location_id가 지정되지 않았습니다.` | Internal 거래 시 상대방 현금 위치 미지정 | `counterparty_cash_location_id` 필수 전달 |

---

### 8.2 실제 템플릿 데이터 구조 분석

#### 8.2.1 발견된 템플릿 데이터 필드

실제 DB에서 확인된 템플릿 라인 필드:

```dart
// 모든 템플릿 라인에 공통
{
  "account_id": "UUID",          // 필수
  "account_name": "String",      // UI용 (RPC 미사용)
  "type": "debit" | "credit",    // 차변/대변 구분
  "debit": "0",                  // 문자열 숫자
  "credit": "0",                 // 문자열 숫자
  "amount": "0" | 0,             // 문자열 또는 숫자 (주의!)
  "description": "String?",      // 선택
}

// Cash/Bank 타입
{
  "category_tag": "cash" | "bank",
  "cash_location_id": "UUID?",
  "cash_location_name": "String?",
  // 또는 nested 구조 (구버전 템플릿)
  "cash": {
    "cash_location_id": "UUID"
  }
}

// Receivable/Payable 타입
{
  "category_tag": "receivable" | "payable",
  "counterparty_id": "UUID",
  "counterparty_name": "String?",
  "counterparty_cash_location_id": "UUID?",  // Internal용
  "counterparty_store_id": "UUID?",          // Internal용 (linked_company_store_id)
  "counterparty_store_name": "String?",      // Internal용
}

// Revenue/Expense 타입
{
  "category_tag": "other" | null,  // 주의: null일 수 있음!
}
```

#### 8.2.2 데이터 불일치 케이스

| 케이스 | 발견 데이터 | 대응 |
|--------|------------|------|
| `category_tag: null` | Revenue/Expense에서 발견 | `other`로 기본값 처리 |
| `amount: 0` (숫자) vs `amount: "0"` (문자열) | 혼재 | 형변환 처리 |
| `cash` nested vs `cash_location_id` flat | 두 구조 혼재 | 양쪽 모두 지원 |
| `counterparty_id: ""` (빈 문자열) | 일부 템플릿 | null로 처리 |
| `type` 필드 누락 | 구버전 템플릿 | 첫 번째 라인 = debit 추론 |

---

### 8.3 Edge Case 처리 목록

| 케이스 | 발생 조건 | 대응 |
|--------|----------|------|
| **빈 금액 입력** | amount = 0 | UI에서 양수 검증 |
| **음수 금액** | amount < 0 | UI에서 양수 검증 |
| **템플릿 데이터 없음** | data = [] | 템플릿 로드 시 검증 |
| **Internal 템플릿에 counterparty_cash_location_id 누락** | 구버전 템플릿 | 경고 표시 + 생성 불가 처리 |
| **Counterparty가 삭제됨** | linked_company_id 유효하지 않음 | DB 조회 시 에러 메시지 |
| **Cash Location이 삭제됨** | cash_location_id 유효하지 않음 | DB 조회 시 에러 메시지 |
| **UUID 형식 오류** | 잘못된 UUID 문자열 | 클라이언트 검증 |
| **숫자 형식 오류** | debit/credit이 숫자 아님 | 클라이언트 검증 |
| **복수 linked_company** | 여러 내부거래 대상 | 클라이언트 검증 (불가) |
| **네트워크 오류** | RPC 호출 실패 | 재시도 로직 + 에러 표시 |

---

## 9. 검증 완료된 테스트 케이스

### 9.1 테스트 페이지 결과 (test_template_mapping_page.dart)

| 템플릿 유형 | 테스트 결과 | Mirror Journal | 비고 |
|------------|-------------|----------------|------|
| **Internal Receivable + Cash** | ✅ SUCCESS | ✅ 생성됨 | counterparty_cash_location_id 필수 |
| **Cash-Cash** | ✅ SUCCESS | N/A | 양쪽 cash_location 고정 |
| **Revenue + Cash** | ✅ SUCCESS | N/A | cash_location 변경 가능 |
| **Expense + Cash** | ✅ SUCCESS | N/A | cash_location 변경 가능 |

### 9.2 추가 필요 테스트

| 테스트 케이스 | 예상 결과 |
|--------------|----------|
| 금액 0 입력 | 클라이언트 검증 실패 |
| 음수 금액 입력 | 클라이언트 검증 실패 |
| 빈 템플릿 데이터 | 클라이언트 검증 실패 |
| 잘못된 UUID | 서버 검증 실패 |
| 삭제된 Counterparty | 서버 검증 실패 |
| 삭제된 Cash Location | 서버 검증 실패 |
| 네트워크 타임아웃 | 재시도 또는 에러 표시 |

---

## 10. 체크리스트

### 10.1 구현 전 확인사항

- [ ] `template_enums.dart`에 `TemplateRpcType` 추가 가능한지 확인
- [ ] `template_analysis_result.dart` 수정 범위 확인 (기존 로직 영향 없는지)
- [ ] `ValidationError` 클래스 필드 확인 (fieldName, fieldValue, validationRule, message)
- [ ] Freezed 빌드 설정 확인 (`template_rpc_result.dart` 위해)

### 10.2 구현 후 확인사항

- [ ] `dart run build_runner build` 성공
- [ ] `flutter analyze` 에러 없음
- [ ] 모든 템플릿 유형 테스트 통과
- [ ] 기존 기능 회귀 없음

---

*Created: 2025-12-29*
*Updated: 2025-12-29 - Clean Architecture 정합, 기존 클래스 재사용 전략, 데이터 흐름 다이어그램 추가*
