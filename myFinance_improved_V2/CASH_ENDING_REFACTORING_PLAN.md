# Cash Ending Feature - 아키텍처 리팩토링 플랜
## 30년차 Flutter 개발자의 실용적 수정 계획

**작성일**: 2025-11-11
**대상 모듈**: `/lib/features/cash_ending`
**참고 모듈**: `/lib/features/cash_location` (A+ 등급 구조)
**목표**: Clean Architecture 위반 사항 수정 (오버엔지니어링 없이)

---

## 📊 현재 상태 분석

### ✅ 잘 구현된 부분
1. **Cash Tab**: 완벽한 Clean Architecture
   - ✅ Domain entities 사용
   - ✅ Repository pattern 적용
   - ✅ DataSource 계층 분리

2. **Domain Layer**: 100% 순수성
   - ✅ 외부 의존성 없음
   - ✅ Entity/Repository 분리 명확

3. **Data Layer**: 캡슐화 우수
   - ✅ DataSource 패턴
   - ✅ Model ↔ Entity 변환

### ❌ 위반 사항 (수정 필요)

| # | 파일 | 문제 | 심각도 |
|---|------|------|--------|
| 1 | `presentation/providers/repository_providers.dart` | Data 레이어 직접 import | 🟡 중간 |
| 2 | `presentation/pages/cash_ending_page.dart:281` | Bank 저장 시 Supabase 직접 호출 | 🔴 높음 |
| 3 | `presentation/pages/cash_ending_page.dart:403` | Vault 저장 시 Supabase 직접 호출 | 🔴 높음 |

---

## 🎯 리팩토링 전략

### 원칙
1. **Cash Tab 구조 재사용**: 이미 완벽하게 구현된 패턴 복제
2. **최소 변경**: 기존 코드 최대한 보존
3. **네이밍 일관성**: cash_location 모듈과 동일한 네이밍 컨벤션
4. **오버엔지니어링 금지**: UseCase 레이어 추가하지 않음 (Repository로 충분)

### 참고 구조 (cash_location)
```
cash_location/
├── presentation/providers/
│   └── cash_location_providers.dart  ← repository_providers 여기서 import
├── domain/
│   ├── entities/
│   └── repositories/
└── data/
    ├── repositories/
    │   └── repository_providers.dart  ← DI 설정 파일
    ├── datasources/
    └── models/
```

---

## 📋 상세 리팩토링 플랜

### Phase 1: Bank 기능 Clean Architecture 적용

#### Step 1-1: Domain Layer 생성

**생성할 파일:**

```
domain/
├── entities/
│   └── bank_balance.dart          ← 새로 생성
└── repositories/
    └── bank_repository.dart       ← 새로 생성
```

**1. `domain/entities/bank_balance.dart`**
```dart
/// Domain entity for bank balance
class BankBalance {
  final String? balanceId;        // null for new records
  final String companyId;
  final String? storeId;
  final String locationId;
  final String currencyId;
  final int totalAmount;
  final String userId;
  final DateTime recordDate;
  final DateTime createdAt;

  BankBalance({
    this.balanceId,
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.currencyId,
    required this.totalAmount,
    required this.userId,
    required this.recordDate,
    required this.createdAt,
  });

  // Validation
  bool get isValid => companyId.isNotEmpty && locationId.isNotEmpty;
  bool get isHeadquarter => storeId == null || storeId == 'headquarter';
}
```

**2. `domain/repositories/bank_repository.dart`**
```dart
import '../entities/bank_balance.dart';

/// Repository interface for Bank operations (Domain Layer)
abstract class BankRepository {
  /// Save bank balance
  /// Throws exception on failure
  Future<void> saveBankBalance(BankBalance balance);

  /// Get bank balance history for a location
  Future<List<BankBalance>> getBankBalanceHistory({
    required String locationId,
    int limit = 10,
  });
}
```

**네이밍 규칙**:
- ✅ `BankBalance` (Cash와 동일 패턴: `CashEnding`)
- ✅ `BankRepository` (간결하고 명확)
- ✅ `saveBankBalance` (동사 + 명사)

---

#### Step 1-2: Data Layer 생성

**생성할 파일:**

```
data/
├── models/
│   └── bank_balance_model.dart          ← 새로 생성
├── datasources/
│   └── bank_remote_datasource.dart      ← 새로 생성
└── repositories/
    └── bank_repository_impl.dart        ← 새로 생성
```

**1. `data/models/bank_balance_model.dart`**
```dart
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/bank_balance.dart';

/// Data model for BankBalance (DTO)
class BankBalanceModel {
  final String? balanceId;
  final String companyId;
  final String? storeId;
  final String locationId;
  final String currencyId;
  final int totalAmount;
  final String userId;
  final DateTime recordDate;
  final DateTime createdAt;

  const BankBalanceModel({
    this.balanceId,
    required this.companyId,
    this.storeId,
    required this.locationId,
    required this.currencyId,
    required this.totalAmount,
    required this.userId,
    required this.recordDate,
    required this.createdAt,
  });

  /// Convert to RPC parameters (Supabase format)
  Map<String, dynamic> toRpcParams() {
    final recordDateStr = DateTimeUtils.toDateOnly(recordDate);
    final createdAtStr = DateTimeUtils.toRpcFormat(createdAt);

    return {
      'p_company_id': companyId,
      'p_store_id': (storeId == null || storeId == 'headquarter') ? null : storeId,
      'p_record_date': recordDateStr,
      'p_location_id': locationId,
      'p_currency_id': currencyId,
      'p_total_amount': totalAmount,
      'p_created_by': userId,
      'p_created_at': createdAtStr,
    };
  }

  /// Convert to Domain Entity
  BankBalance toEntity() {
    return BankBalance(
      balanceId: balanceId,
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
      currencyId: currencyId,
      totalAmount: totalAmount,
      userId: userId,
      recordDate: recordDate,
      createdAt: createdAt,
    );
  }

  /// Create from Domain Entity
  factory BankBalanceModel.fromEntity(BankBalance entity) {
    return BankBalanceModel(
      balanceId: entity.balanceId,
      companyId: entity.companyId,
      storeId: entity.storeId,
      locationId: entity.locationId,
      currencyId: entity.currencyId,
      totalAmount: entity.totalAmount,
      userId: entity.userId,
      recordDate: entity.recordDate,
      createdAt: entity.createdAt,
    );
  }

  /// Create from JSON (from database)
  factory BankBalanceModel.fromJson(Map<String, dynamic> json) {
    return BankBalanceModel(
      balanceId: json['balance_id']?.toString(),
      companyId: json['company_id']?.toString() ?? '',
      storeId: json['store_id']?.toString(),
      locationId: json['location_id']?.toString() ?? '',
      currencyId: json['currency_id']?.toString() ?? '',
      totalAmount: (json['total_amount'] as num?)?.toInt() ?? 0,
      userId: json['created_by']?.toString() ?? '',
      recordDate: DateTimeUtils.toLocal(
        json['record_date']?.toString() ?? DateTimeUtils.nowUtc(),
      ),
      createdAt: DateTimeUtils.toLocal(
        json['created_at']?.toString() ?? DateTimeUtils.nowUtc(),
      ),
    );
  }
}
```

**2. `data/datasources/bank_remote_datasource.dart`**
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Bank operations
///
/// This is the ONLY place where Supabase is used for bank operations.
class BankRemoteDataSource {
  final SupabaseClient _client;

  BankRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Save bank balance using RPC
  ///
  /// Calls bank_amount_insert_v2 stored procedure
  /// Throws exception on error
  Future<void> saveBankBalance(Map<String, dynamic> params) async {
    try {
      await _client.rpc<void>(
        'bank_amount_insert_v2',
        params: params,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get bank balance history
  Future<List<Map<String, dynamic>>> getBankBalanceHistory({
    required String locationId,
    int limit = 10,
  }) async {
    final response = await _client
        .from('bank_balance_history_view')  // 뷰가 있다면
        .select()
        .eq('location_id', locationId)
        .order('record_date', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }
}
```

**3. `data/repositories/bank_repository_impl.dart`**
```dart
import '../../domain/entities/bank_balance.dart';
import '../../domain/repositories/bank_repository.dart';
import '../datasources/bank_remote_datasource.dart';
import '../models/bank_balance_model.dart';

/// Repository Implementation for Bank operations
class BankRepositoryImpl implements BankRepository {
  final BankRemoteDataSource _remoteDataSource;

  BankRepositoryImpl({
    BankRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? BankRemoteDataSource();

  @override
  Future<void> saveBankBalance(BankBalance balance) async {
    try {
      // Entity → Model 변환
      final model = BankBalanceModel.fromEntity(balance);

      // RPC 파라미터 준비
      final params = model.toRpcParams();

      // DataSource 호출
      await _remoteDataSource.saveBankBalance(params);
    } catch (e) {
      throw Exception('Failed to save bank balance: $e');
    }
  }

  @override
  Future<List<BankBalance>> getBankBalanceHistory({
    required String locationId,
    int limit = 10,
  }) async {
    try {
      final data = await _remoteDataSource.getBankBalanceHistory(
        locationId: locationId,
        limit: limit,
      );

      return data
          .map((json) => BankBalanceModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bank balance history: $e');
    }
  }
}
```

---

#### Step 1-3: Provider 설정 업데이트

**수정할 파일: `presentation/providers/repository_providers.dart`**

```dart
// 기존 코드에 추가
import '../../domain/repositories/bank_repository.dart';
import '../../data/repositories/bank_repository_impl.dart';
import '../../data/datasources/bank_remote_datasource.dart';

/// Provider for Bank Remote Data Source
final bankRemoteDataSourceProvider = Provider<BankRemoteDataSource>((ref) {
  return BankRemoteDataSource();
});

/// Provider for Bank Repository
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  final dataSource = ref.watch(bankRemoteDataSourceProvider);
  return BankRepositoryImpl(remoteDataSource: dataSource);
});
```

---

#### Step 1-4: Presentation Layer 수정

**수정할 파일: `presentation/pages/cash_ending_page.dart`**

**Before (Lines 220-318):**
```dart
Future<void> _saveBankBalance(...) async {
  // ❌ 직접 Supabase 호출
  await Supabase.instance.client
      .rpc<dynamic>('bank_amount_insert_v2', params: params);
}
```

**After:**
```dart
import '../providers/repository_providers.dart';  // bank_repository_provider import

Future<void> _saveBankBalance(
  BuildContext context,
  CashEndingState state,
  String currencyId,
) async {
  // Validation
  if (state.selectedBankLocationId == null) {
    await TossDialogs.showCashEndingError(
      context: context,
      error: 'Please select a bank location',
    );
    return;
  }

  final companyId = ref.read(appStateProvider).companyChoosen;
  final userId = ref.read(appStateProvider).user['user_id'] as String?;

  if (companyId.isEmpty || userId == null) {
    await TossDialogs.showCashEndingError(
      context: context,
      error: 'Invalid company or user',
    );
    return;
  }

  final dynamic bankTabState = _bankTabKey.currentState;
  final amount = bankTabState?.bankAmount as String? ?? '0';
  final amountText = amount.replaceAll(',', '');
  final totalAmount = int.tryParse(amountText) ?? 0;

  // ✅ Create BankBalance entity
  final bankBalance = BankBalance(
    companyId: companyId,
    storeId: state.selectedStoreId,
    locationId: state.selectedBankLocationId!,
    currencyId: currencyId,
    totalAmount: totalAmount,
    userId: userId,
    recordDate: DateTime.now(),
    createdAt: DateTime.now(),
  );

  try {
    // ✅ Use BankRepository (Clean Architecture)
    await ref.read(bankRepositoryProvider).saveBankBalance(bankBalance);

    if (!mounted) return;

    HapticFeedback.mediumImpact();
    await TossDialogs.showBankBalanceSaved(context: context);
    bankTabState?.clearAmount?.call();

    // Reload stock flows
    if (state.selectedBankLocationId != null &&
        state.selectedBankLocationId!.isNotEmpty) {
      bankTabState?.reloadStockFlows?.call();
    }
  } catch (e) {
    if (!mounted) return;

    String errorMessage = 'Failed to save bank balance';
    if (e.toString().contains('network')) {
      errorMessage = 'Network error. Please check your connection and try again.';
    } else if (e.toString().contains('duplicate')) {
      errorMessage = 'Bank balance for today already exists.';
    } else if (e.toString().contains('permission')) {
      errorMessage = 'You do not have permission to save bank balance.';
    }

    await TossDialogs.showCashEndingError(
      context: context,
      error: errorMessage,
    );
  }
}
```

**변경 요약:**
- ❌ 제거: `Supabase.instance.client.rpc()` 직접 호출
- ✅ 추가: `BankBalance` entity 생성
- ✅ 추가: `bankRepositoryProvider` 사용
- ✅ 유지: 기존 에러 처리 로직

---

### Phase 2: Vault 기능 Clean Architecture 적용

**동일한 패턴으로 적용 (Bank와 구조 동일)**

#### Step 2-1: Domain Layer

**생성할 파일:**
```
domain/
├── entities/
│   └── vault_transaction.dart
└── repositories/
    └── vault_repository.dart
```

**네이밍:**
- `VaultTransaction` (entity)
- `VaultRepository` (interface)
- `saveVaultTransaction()` (method)

#### Step 2-2~2-4: Data Layer & Presentation

Bank와 동일한 패턴으로 구현:
- `VaultTransactionModel`
- `VaultRemoteDataSource`
- `VaultRepositoryImpl`
- Provider 설정
- `cash_ending_page.dart` 수정 (Line 403)

---

### Phase 3: Provider 파일 위치 조정

#### Step 3-1: repository_providers.dart 이동

**Before:**
```
presentation/providers/repository_providers.dart  ← Data import 있음
```

**After (cash_location 패턴 참고):**

**옵션 A: 현재 구조 유지 (권장)**
```
presentation/providers/
├── repository_providers.dart      ← DI 설정 (import는 data 허용)
└── cash_ending_provider.dart      ← Domain만 import
```

**이유:**
- cash_location도 동일한 패턴 사용 (Line 4: `import '../../data/repositories/repository_providers.dart'`)
- 실용적이고 간단함
- 테스트 시 mock 주입 가능

**옵션 B: 별도 DI 폴더 (오버엔지니어링)**
```
di/injection.dart  ← 추가 복잡도
```

**결정: 옵션 A 선택**

---

## 🗂️ 최종 폴더 구조

```
cash_ending/
├── presentation/
│   ├── pages/
│   │   └── cash_ending_page.dart        ← Supabase 제거, Repository 사용
│   ├── widgets/
│   │   └── tabs/
│   │       ├── cash_tab.dart            ✅ 이미 완벽함
│   │       ├── bank_tab.dart            ← 변경 없음 (page에서 처리)
│   │       └── vault_tab.dart           ← 변경 없음
│   └── providers/
│       ├── repository_providers.dart    ← Bank/Vault Provider 추가
│       ├── cash_ending_provider.dart
│       └── cash_ending_state.dart
│
├── domain/
│   ├── entities/
│   │   ├── cash_ending.dart             ✅ 기존
│   │   ├── bank_balance.dart            🆕 추가
│   │   ├── vault_transaction.dart       🆕 추가
│   │   ├── currency.dart
│   │   ├── denomination.dart
│   │   ├── location.dart
│   │   └── store.dart
│   ├── repositories/
│   │   ├── cash_ending_repository.dart  ✅ 기존
│   │   ├── bank_repository.dart         🆕 추가
│   │   ├── vault_repository.dart        🆕 추가
│   │   ├── location_repository.dart
│   │   ├── currency_repository.dart
│   │   └── stock_flow_repository.dart
│   └── exceptions/
│       └── cash_ending_exception.dart
│
└── data/
    ├── models/
    │   ├── cash_ending_model.dart       ✅ 기존
    │   ├── bank_balance_model.dart      🆕 추가
    │   ├── vault_transaction_model.dart 🆕 추가
    │   ├── currency_model.dart
    │   ├── denomination_model.dart
    │   └── ...
    ├── datasources/
    │   ├── cash_ending_remote_datasource.dart  ✅ 기존
    │   ├── bank_remote_datasource.dart         🆕 추가
    │   ├── vault_remote_datasource.dart        🆕 추가
    │   ├── location_remote_datasource.dart
    │   └── currency_remote_datasource.dart
    └── repositories/
        ├── cash_ending_repository_impl.dart  ✅ 기존
        ├── bank_repository_impl.dart         🆕 추가
        ├── vault_repository_impl.dart        🆕 추가
        ├── location_repository_impl.dart
        └── currency_repository_impl.dart
```

**변경 요약:**
- 🆕 추가: 6개 파일 (Bank 3개 + Vault 3개)
- ✏️ 수정: 2개 파일 (cash_ending_page.dart, repository_providers.dart)
- ✅ 유지: 나머지 모든 파일

---

## 📝 구현 체크리스트

### Bank 기능 (Phase 1)
- [ ] `domain/entities/bank_balance.dart` 생성
- [ ] `domain/repositories/bank_repository.dart` 생성
- [ ] `data/models/bank_balance_model.dart` 생성
- [ ] `data/datasources/bank_remote_datasource.dart` 생성
- [ ] `data/repositories/bank_repository_impl.dart` 생성
- [ ] `presentation/providers/repository_providers.dart` 업데이트
- [ ] `presentation/pages/cash_ending_page.dart` Line 220-318 수정
- [ ] Import 경로 수정
- [ ] 빌드 테스트

### Vault 기능 (Phase 2)
- [ ] `domain/entities/vault_transaction.dart` 생성
- [ ] `domain/repositories/vault_repository.dart` 생성
- [ ] `data/models/vault_transaction_model.dart` 생성
- [ ] `data/datasources/vault_remote_datasource.dart` 생성
- [ ] `data/repositories/vault_repository_impl.dart` 생성
- [ ] `presentation/providers/repository_providers.dart` 업데이트
- [ ] `presentation/pages/cash_ending_page.dart` Line 321-439 수정
- [ ] Import 경로 수정
- [ ] 빌드 테스트

### 최종 검증
- [ ] `flutter analyze` 통과
- [ ] 의존성 규칙 검증 (grep 테스트)
- [ ] 전체 기능 테스트 (Cash/Bank/Vault)
- [ ] 아키텍처 감사 리포트 작성

---

## 🎯 예상 효과

### Before (현재)
```
Presentation (cash_ending_page.dart)
    ↓ (직접 호출)
Supabase.instance.client.rpc()
```

### After (리팩토링 후)
```
Presentation (cash_ending_page.dart)
    ↓ (사용)
Domain (BankRepository interface)
    ↑ (구현)
Data (BankRepositoryImpl)
    ↓ (사용)
DataSource (BankRemoteDataSource)
    ↓ (호출)
Supabase.instance.client.rpc()
```

### 개선사항
1. ✅ **테스트 가능**: Repository를 mock으로 교체 가능
2. ✅ **유지보수성**: RPC 변경 시 DataSource만 수정
3. ✅ **재사용성**: 다른 곳에서도 Repository 사용 가능
4. ✅ **일관성**: Cash/Bank/Vault 모두 동일한 패턴
5. ✅ **의존성 규칙**: Clean Architecture 100% 준수

---

## 💡 네이밍 컨벤션 (일관성 유지)

### Entity 네이밍
- `CashEnding` ✅ (기존)
- `BankBalance` ✅ (새로)
- `VaultTransaction` ✅ (새로)

### Repository 네이밍
- `CashEndingRepository` ✅
- `BankRepository` ✅
- `VaultRepository` ✅

### Method 네이밍
- `saveCashEnding()` ✅
- `saveBankBalance()` ✅
- `saveVaultTransaction()` ✅

### Model 네이밍
- `CashEndingModel` ✅
- `BankBalanceModel` ✅
- `VaultTransactionModel` ✅

### DataSource 네이밍
- `CashEndingRemoteDataSource` ✅
- `BankRemoteDataSource` ✅
- `VaultRemoteDataSource` ✅

---

## ⚠️ 주의사항

1. **기존 코드 보존**
   - Cash Tab은 수정하지 않음 (이미 완벽함)
   - 에러 메시지, 다이얼로그는 그대로 유지
   - UI 로직 변경 없음

2. **최소 변경 원칙**
   - 새로운 레이어 추가 없음 (UseCase 등)
   - 기존 State 구조 유지
   - Provider 패턴 그대로 사용

3. **점진적 리팩토링**
   - Phase 1 (Bank) 완료 후 테스트
   - Phase 2 (Vault) 완료 후 테스트
   - 한 번에 하나씩 수정

4. **빌드 확인**
   - 각 파일 생성 후 `flutter analyze`
   - import 경로 오류 즉시 수정
   - 컴파일 에러 없이 진행

---

## 📊 리팩토링 후 평가 예상

| 항목 | Before | After | 개선 |
|-----|--------|-------|------|
| 레이어 구조 | 10/10 | 10/10 | - |
| Domain 순수성 | 10/10 | 10/10 | - |
| Data 캡슐화 | 9/10 | 10/10 | ✅ +1 |
| **의존성 규칙** | **3/10** | **10/10** | ✅ **+7** |
| Entity/Model 변환 | 10/10 | 10/10 | - |
| **전체 평가** | **B+ (75/100)** | **A+ (98/100)** | ✅ **+23** |

---

## 🚀 실행 순서

1. **Phase 1: Bank 기능 리팩토링**
   - 예상 시간: 30분
   - 파일 수: 6개 (3개 생성, 2개 수정, 1개 업데이트)

2. **Phase 2: Vault 기능 리팩토링**
   - 예상 시간: 25분 (Bank 패턴 복제)
   - 파일 수: 5개 (3개 생성, 2개 수정)

3. **Phase 3: 검증 및 테스트**
   - 예상 시간: 15분
   - flutter analyze
   - 기능 테스트
   - 리포트 작성

**총 예상 시간: 70분**

---

## ✅ 완료 기준

1. ✅ `flutter analyze` 에러 없음
2. ✅ Presentation에서 Supabase 직접 호출 0건
3. ✅ 모든 Repository가 Domain interface 구현
4. ✅ Cash/Bank/Vault 모두 동일한 패턴
5. ✅ 기존 기능 정상 동작
6. ✅ Clean Architecture 점수 A+

---

**작성자**: 30년차 Flutter 개발자
**승인 상태**: 사용자 확인 대기
**다음 단계**: 승인 시 Phase 1 (Bank) 구현 시작
