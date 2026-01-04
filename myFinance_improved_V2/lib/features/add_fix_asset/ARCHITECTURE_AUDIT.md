# Add Fix Asset - Architecture Audit Report

**Audit Date:** 2026-01-02
**Feature Path:** `myFinance_improved_V2/lib/features/add_fix_asset`
**Total Files:** 14 (Dart files)
**Total Lines:** 2,740

---

## 요약

| 항목 | 상태 |
|------|------|
| **전체 평가** | **A** |
| **Critical 이슈** | 0개 |
| **Warning** | 3개 |
| **Info** | 5개 |

이 feature는 Clean Architecture 원칙을 잘 준수하고 있으며, 레이어 분리, Repository 패턴, Riverpod 상태 관리가 올바르게 구현되어 있습니다. 몇 가지 경미한 개선 사항이 있지만 전반적으로 우수한 구조를 가지고 있습니다.

---

## 1. God File 탐지

### 분석 결과: **PASS**

| 파일 | 줄 수 | 상태 |
|------|-------|------|
| `asset_form_sheet.dart` | 658 | Warning (500-1000) |
| `add_fix_asset_page.dart` | 528 | Warning (500-1000) |
| `fixed_asset_state.freezed.dart` | 478 | Pass (자동 생성) |
| `asset_list_item.dart` | 326 | Pass |
| `fixed_asset_notifier.dart` | 143 | Pass |
| 기타 파일들 | < 100 | Pass |

### 상세 분석

- **asset_form_sheet.dart (658줄)**: UI 폼 위젯으로, 여러 빌더 메서드가 포함되어 있음. 위젯 분리를 고려할 수 있으나 현재도 관리 가능한 수준
- **add_fix_asset_page.dart (528줄)**: 메인 페이지로 store selector, asset list, bottom sheet 로직 포함. 위젯 분리로 개선 가능
- **fixed_asset_state.freezed.dart**: Freezed가 자동 생성한 파일로 분석 제외

### 결론
- Critical God File 없음 (1000줄 이상)
- Warning: 2개 파일이 500-1000줄 범위

---

## 2. God Class 탐지

### 분석 결과: **PASS**

| 파일 | 클래스 수 | 상태 |
|------|-----------|------|
| `fixed_asset_state.dart` | 2 | Pass (상태 클래스 그룹) |
| `asset_form_sheet.dart` | 2 | Pass (Widget + State) |
| `add_fix_asset_page.dart` | 2 | Pass (Widget + State) |
| 기타 파일들 | 1 | Pass |

### 상세 분석

- **fixed_asset_state.dart**: `FixedAssetState`와 `FixedAssetFormState` - 논리적으로 관련된 상태 클래스들로 적절함
- StatefulWidget 파일들은 Widget + State 클래스 쌍으로 Flutter 표준 패턴

### 결론
- God Class 없음 (3개 이상 클래스 포함 파일 없음)

---

## 3. 폴더 구조 검사

### 분석 결과: **PASS**

```
add_fix_asset/
├── data/
│   ├── datasources/
│   │   └── fixed_asset_data_source.dart
│   ├── models/
│   │   └── fixed_asset_model.dart
│   └── repositories/
│       └── fixed_asset_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── fixed_asset.dart
│   ├── repositories/
│   │   └── fixed_asset_repository.dart (interface)
│   └── value_objects/
│       ├── asset_financial_info.dart
│       └── depreciation_info.dart
└── presentation/
    ├── pages/
    │   └── add_fix_asset_page.dart
    ├── providers/
    │   ├── fixed_asset_notifier.dart
    │   ├── fixed_asset_providers.dart
    │   └── states/
    │       ├── fixed_asset_state.dart
    │       └── fixed_asset_state.freezed.dart
    └── widgets/
        ├── asset_form_sheet.dart
        └── asset_list_item.dart
```

### 체크리스트

| 항목 | 존재 여부 |
|------|-----------|
| data 폴더 | O |
| domain 폴더 | O |
| presentation 폴더 | O |
| data/datasources | O |
| data/models | O |
| data/repositories | O |
| domain/entities | O |
| domain/repositories | O |
| domain/value_objects | O |
| presentation/pages | O |
| presentation/providers | O |
| presentation/widgets | O |

### 결론
- 완벽한 Clean Architecture 폴더 구조

---

## 4. Domain 순수성

### 분석 결과: **PASS**

#### Domain 레이어 파일 분석

| 파일 | Import 분석 | 상태 |
|------|-------------|------|
| `fixed_asset.dart` | domain 내부만 참조 | Pass |
| `fixed_asset_repository.dart` | domain 내부만 참조 | Pass |
| `asset_financial_info.dart` | 외부 import 없음 | Pass |
| `depreciation_info.dart` | 외부 import 없음 | Pass |

#### Import 상세

```dart
// fixed_asset.dart
import '../value_objects/asset_financial_info.dart';  // domain 내부
import '../value_objects/depreciation_info.dart';      // domain 내부

// fixed_asset_repository.dart
import '../entities/fixed_asset.dart';  // domain 내부

// asset_financial_info.dart, depreciation_info.dart
// - 외부 import 없음 (순수 Dart)
```

### 위반 체크

- [ ] Flutter UI import (material.dart, widgets.dart) - 없음
- [ ] data 레이어 import - 없음
- [ ] presentation 레이어 import - 없음
- [ ] 외부 패키지 import (http, dio 등) - 없음

### 결론
- Domain 레이어가 완벽하게 순수함
- 외부 의존성 없이 비즈니스 로직만 포함

---

## 5. Data 레이어 검사

### 분석 결과: **PASS**

#### Data 레이어 파일 분석

| 파일 | 위반 여부 | 상태 |
|------|-----------|------|
| `fixed_asset_data_source.dart` | 없음 | Pass |
| `fixed_asset_model.dart` | 없음 | Pass |
| `fixed_asset_repository_impl.dart` | 없음 | Pass |

#### Import 상세

```dart
// fixed_asset_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';  // 허용 (데이터 소스)
import '../models/fixed_asset_model.dart';                 // data 내부

// fixed_asset_model.dart
import '../../../../core/utils/datetime_utils.dart';       // core 유틸 (허용)
import '../../domain/entities/fixed_asset.dart';           // domain (허용)
import '../../domain/value_objects/asset_financial_info.dart'; // domain (허용)

// fixed_asset_repository_impl.dart
import '../../domain/entities/fixed_asset.dart';           // domain (허용)
import '../../domain/repositories/fixed_asset_repository.dart'; // domain (허용)
import '../datasources/fixed_asset_data_source.dart';      // data 내부
import '../models/fixed_asset_model.dart';                 // data 내부
```

### 위반 체크

- [ ] presentation import - 없음
- [ ] BuildContext 사용 - 없음
- [ ] Flutter Widget import - 없음

### 결론
- Data 레이어가 올바르게 구현됨
- Domain에 대한 의존성만 있음 (허용됨)

---

## 6. Entity vs DTO 분리

### 분석 결과: **PASS**

| 타입 | 파일 | 역할 |
|------|------|------|
| **Entity** | `domain/entities/fixed_asset.dart` | 도메인 비즈니스 로직 |
| **DTO/Model** | `data/models/fixed_asset_model.dart` | JSON 직렬화/역직렬화 |

### Entity 분석 (FixedAsset)

```dart
class FixedAsset {
  final String? assetId;
  final String assetName;
  final DateTime acquisitionDate;
  final AssetFinancialInfo financialInfo;  // Value Object 사용
  final String companyId;
  final String? storeId;
  final DateTime? createdAt;

  // 비즈니스 로직
  DepreciationInfo calculateDepreciation() { ... }
  bool get isHeadquartersAsset => ...;
  bool get isValid => ...;
}
```

### DTO/Model 분석 (FixedAssetModel)

```dart
class FixedAssetModel {
  // JSON 필드들 (snake_case 매핑)
  final String? assetId;
  final String assetName;
  // ...

  // 직렬화 메서드
  factory FixedAssetModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }

  // Entity 변환 메서드
  FixedAsset toEntity() { ... }
  factory FixedAssetModel.fromEntity(FixedAsset entity) { ... }
}
```

### Value Objects 분석

| Value Object | 설명 |
|--------------|------|
| `AssetFinancialInfo` | 재무 정보 (취득가, 잔존가치, 내용연수) |
| `DepreciationInfo` | 감가상각 계산 결과 |

### 결론
- Entity와 DTO가 명확히 분리됨
- Value Objects를 통한 도메인 개념 캡슐화
- 양방향 변환 메서드 제공 (toEntity, fromEntity)

---

## 7. Repository 패턴

### 분석 결과: **PASS**

### 인터페이스 (Domain Layer)

```dart
// domain/repositories/fixed_asset_repository.dart
abstract class FixedAssetRepository {
  Future<List<FixedAsset>> getFixedAssets({...});
  Future<FixedAsset?> getFixedAssetById(String assetId);
  Future<void> createFixedAsset(FixedAsset asset);
  Future<void> updateFixedAsset(FixedAsset asset);
  Future<void> deleteFixedAsset(String assetId);
  Future<String?> getCompanyBaseCurrency(String companyId);
  Future<String> getCurrencySymbol(String currencyId);
}
```

### 구현체 (Data Layer)

```dart
// data/repositories/fixed_asset_repository_impl.dart
class FixedAssetRepositoryImpl implements FixedAssetRepository {
  final FixedAssetDataSource _dataSource;
  // 모든 메서드 구현
}
```

### 체크리스트

| 항목 | 상태 |
|------|------|
| 인터페이스 정의 (domain) | O |
| 구현체 분리 (data) | O |
| Domain Entity 반환 | O |
| DataSource 패턴 사용 | O |
| 에러 처리 | O |

### DataSource 패턴

```dart
// data/datasources/fixed_asset_data_source.dart
class FixedAssetDataSource {
  final SupabaseClient _supabase;
  // Supabase 직접 통신
}
```

### 결론
- Repository 패턴이 올바르게 구현됨
- 의존성 역전 원칙 준수

---

## 8. Riverpod 검사

### 분석 결과: **PASS**

### Provider 구조

```dart
// presentation/providers/fixed_asset_providers.dart

// Infrastructure Providers (DI)
final supabaseClientProvider = Provider<SupabaseClient>((ref) => ...);
final fixedAssetDataSourceProvider = Provider<FixedAssetDataSource>((ref) => ...);
final fixedAssetRepositoryProvider = Provider<FixedAssetRepository>((ref) => ...);

// State Notifier Provider
final fixedAssetProvider = StateNotifierProvider<FixedAssetNotifier, FixedAssetState>((ref) => ...);

// Helper Providers
final companyBaseCurrencyProvider = FutureProvider.family<String?, String>((ref, companyId) => ...);
final currencySymbolProvider = FutureProvider.family<String, String>((ref, currencyId) => ...);
```

### State 관리

| 컴포넌트 | 타입 | 용도 |
|----------|------|------|
| `FixedAssetNotifier` | StateNotifier | 메인 상태 관리 |
| `FixedAssetState` | Freezed | UI 상태 (immutable) |
| `FixedAssetFormState` | Freezed | 폼 상태 (정의됨, 미사용) |

### Riverpod 사용 패턴

- **StateNotifierProvider**: 메인 CRUD 로직
- **Provider**: DI (DataSource, Repository)
- **FutureProvider.family**: 파라미터화된 비동기 데이터

### Info: 사용되지 않는 상태

- `FixedAssetFormState`가 정의되어 있지만 실제로 사용되지 않음
- 폼 상태 관리는 위젯 내부 StatefulWidget으로 처리됨

### 결론
- Riverpod이 올바르게 설정됨
- DI 체인이 명확함
- StateNotifier 패턴 적절히 사용

---

## 9. Cross-Feature 의존성

### 분석 결과: **PASS**

### 외부 Feature 의존성

| Import | 소스 | 타입 |
|--------|------|------|
| `app/providers/app_state_provider.dart` | add_fix_asset_page.dart | App 레벨 (허용) |
| `app/providers/auth_providers.dart` | add_fix_asset_page.dart | App 레벨 (허용) |

### Shared 모듈 의존성

| Import | 소스 | 타입 |
|--------|------|------|
| `shared/themes/toss_*.dart` | 여러 위젯 | 공유 테마 (허용) |
| `shared/widgets/index.dart` | 여러 위젯 | 공유 위젯 (허용) |
| `core/utils/datetime_utils.dart` | fixed_asset_model.dart | Core 유틸 (허용) |

### 외부 패키지 의존성

| 패키지 | 사용 위치 | 용도 |
|--------|-----------|------|
| `flutter_riverpod` | Providers, Notifier | 상태 관리 |
| `supabase_flutter` | DataSource, Providers | 백엔드 통신 |
| `freezed_annotation` | State | 불변 상태 |

### 위반 체크

- [ ] 다른 feature 직접 import - 없음
- [ ] 순환 의존성 - 없음

### 결론
- Cross-Feature 의존성 없음
- App/Core/Shared 레벨 의존성만 존재 (적절함)
- Feature가 독립적으로 동작

---

## 10. 효율성 분석

### 분석 결과: **PASS** (개선 여지 있음)

### 장점

1. **명확한 책임 분리**
   - DataSource: Supabase 통신
   - Repository: 데이터 변환 및 에러 처리
   - Notifier: 상태 관리

2. **Value Objects 활용**
   - `AssetFinancialInfo`: 재무 정보 캡슐화
   - `DepreciationInfo`: 감가상각 계산 로직 캡슐화

3. **Freezed 상태 관리**
   - Immutable 상태
   - copyWith 자동 생성

4. **DateTimeUtils 사용**
   - 날짜 변환 로직 중앙화

### 개선 가능 영역

#### Info 1: 미사용 상태 클래스
```dart
// FixedAssetFormState - 정의되었으나 사용되지 않음
@freezed
class FixedAssetFormState with _$FixedAssetFormState { ... }
```
**권장**: 사용하지 않으면 제거하거나, 폼 상태 관리에 활용

#### Info 2: 위젯 분리 가능성
```dart
// add_fix_asset_page.dart (528줄)
// 분리 가능한 부분:
// - _buildStoreSelector() -> 별도 위젯
// - _buildAssetsList() -> 별도 위젯
```

#### Info 3: asset_form_sheet.dart 분리
```dart
// 658줄 - 다음으로 분리 가능:
// - _buildTextField() -> 재사용 가능한 위젯
// - _buildFinancialSection() -> 별도 위젯
// - _buildDepreciationPreview() -> 별도 위젯
```

#### Info 4: Dialog 로직 중복
```dart
// add_fix_asset_page.dart에서 반복되는 패턴
await showDialog<bool>(
  context: context,
  builder: (context) => TossDialog.success/error(...),
);
// -> 헬퍼 함수로 추출 가능
```

#### Info 5: Store 관련 로직
```dart
// add_fix_asset_page.dart에서 stores 추출 로직이 복잡
// -> 별도 헬퍼 또는 Provider로 분리 가능
```

### 코드 품질 지표

| 지표 | 점수 | 설명 |
|------|------|------|
| 가독성 | 9/10 | 명확한 네이밍, 좋은 주석 |
| 유지보수성 | 8/10 | 레이어 분리 양호 |
| 테스트 용이성 | 9/10 | 의존성 주입으로 모킹 가능 |
| 재사용성 | 7/10 | 일부 위젯 분리 필요 |

---

## 권장 수정사항

### 높은 우선순위 (Warning)

1. **asset_form_sheet.dart 위젯 분리**
   - 현재: 658줄의 단일 파일
   - 권장: 섹션별 위젯 분리 (FinancialSection, DepreciationPreview 등)
   - 효과: 가독성 향상, 테스트 용이성 증가

2. **add_fix_asset_page.dart 위젯 분리**
   - 현재: 528줄의 단일 파일
   - 권장: StoreSelector, AssetsList를 별도 위젯으로 분리
   - 효과: 단일 책임 원칙 준수

### 낮은 우선순위 (Info)

3. **미사용 FixedAssetFormState 정리**
   - 현재: 정의되어 있으나 사용되지 않음
   - 권장: 제거하거나 폼 상태 관리에 활용
   - 효과: 코드 정리

4. **Dialog 헬퍼 함수 추출**
   - 현재: showDialog 호출이 여러 곳에 중복
   - 권장: showSuccessDialog, showErrorDialog 헬퍼 생성
   - 효과: 코드 중복 제거

5. **Store 로직 분리**
   - 현재: 페이지 내에서 복잡한 stores 추출 로직
   - 권장: 별도 Provider 또는 유틸리티로 분리
   - 효과: 로직 재사용성 향상

---

## 결론

`add_fix_asset` feature는 Clean Architecture를 잘 준수하고 있으며, 다음과 같은 강점이 있습니다:

- **완벽한 레이어 분리**: data/domain/presentation
- **순수한 Domain 레이어**: 외부 의존성 없음
- **올바른 Repository 패턴**: 인터페이스와 구현체 분리
- **적절한 Riverpod 사용**: DI, StateNotifier
- **Entity/DTO 분리**: 도메인 모델과 데이터 모델 구분
- **Value Objects 활용**: 도메인 개념 캡슐화

경미한 개선 사항(위젯 분리, 미사용 코드 정리)이 있지만, 전반적으로 **A 등급**의 우수한 아키텍처를 가지고 있습니다.
