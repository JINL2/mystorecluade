# Build Error Fix - inventory_service.dart

**날짜**: 2025-01-24
**상태**: ✅ 완료

---

## 🔴 발생한 에러

```
lib/core/services/inventory_service.dart:2:8: Error: Error when reading 'lib/core/models/inventory_models.dart':
No such file or directory
import '../models/inventory_models.dart';

Multiple type errors for:
- InventoryMetadata
- InventoryPageResult
- Pagination
- Currency
```

---

## 🔍 원인 분석

`lib/core/services/inventory_service.dart` 파일이 존재하지 않는 `lib/core/models/inventory_models.dart`를 임포트하고 있었습니다.

### 배경

1. **Old Structure (lib_old)**:
   - 기존에는 `lib_old/data/services/inventory_service.dart`에 전체 인벤토리 서비스가 있었음
   - 해당 서비스는 `lib_old/data/models/inventory_models.dart`를 사용

2. **New Structure (lib/features)**:
   - Clean Architecture로 마이그레이션: `lib/features/inventory_management/`
   - 새로운 구조에서는 Repository 패턴을 사용
   - Domain entities를 `lib/features/inventory_management/domain/entities/`에 정의

3. **문제점**:
   - `lib/core/services/inventory_service.dart`는 old structure의 모델을 참조
   - 해당 모델 파일들은 Clean Architecture 마이그레이션 후 삭제됨

---

## ✅ 해결 방법

### 조사 결과

`inventory_service.dart`는 실제로 **sales_invoice 기능에서만** 다음 두 메서드를 사용:

```dart
// lib/features/sales_invoice/presentation/providers/payment_providers.dart
await _inventoryService.getBaseCurrency(companyId: ...)
await _inventoryService.getCashLocations(companyId: ..., storeId: ...)
```

### 적용한 해결책

필요없는 모든 메서드를 제거하고, **sales_invoice에서 사용하는 2개 메서드만 유지**:

1. `getBaseCurrency()` - 통화 정보 조회
2. `getCashLocations()` - 현금 위치 조회

### 수정 내용

**Before** (933 lines):
```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inventory_models.dart'; // ❌ 존재하지 않는 파일

class InventoryService {
  // 15개 이상의 메서드들 (대부분 사용 안됨)
  Future<InventoryMetadata?> getInventoryMetadata(...) // ❌ 타입 에러
  Future<InventoryPageResult?> getInventoryPage(...) // ❌ 타입 에러
  Future<Map<String, dynamic>?> getProductDetails(...)
  Future<Map<String, dynamic>?> createProduct(...)
  Future<Map<String, dynamic>?> editProduct(...)
  Future<Map<String, dynamic>?> deleteProducts(...)
  Future<Map<String, dynamic>?> createCategory(...)
  Future<Map<String, dynamic>?> createBrand(...)
  Future<bool> updateProductStock(...)
  Future<Map<String, dynamic>?> getInventoryProductListCompany(...)
  Future<Map<String, dynamic>?> getBaseCurrency(...) // ✅ 사용됨
  Future<List<Map<String, dynamic>>?> getCashLocations(...) // ✅ 사용됨
}
```

**After** (148 lines):
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Legacy InventoryService - Only contains methods used by sales_invoice feature
///
/// Note: This service is kept for backward compatibility with sales_invoice.
/// For new inventory management features, use the repository pattern in
/// lib/features/inventory_management/
class InventoryService {
  final _client = Supabase.instance.client;

  // Get base currency and company currencies for payment methods
  Future<Map<String, dynamic>?> getBaseCurrency({
    required String companyId,
  }) async {
    // ... 구현 ...
  }

  // Get cash locations for payment methods
  Future<List<Map<String, dynamic>>?> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    // ... 구현 ...
  }
}
```

---

## 📊 결과

### Before Fix
- **파일 크기**: 933 lines
- **메서드 수**: 15개
- **에러 수**: 24개 (Error: 18개, Warning: 6개)
- **빌드 상태**: ❌ 실패

### After Fix
- **파일 크기**: 148 lines (84% 감소)
- **메서드 수**: 2개 (필요한 것만 유지)
- **에러 수**: 0개 (Error: 0개, Warning: 8개 - print 사용)
- **빌드 상태**: ✅ 성공

### Build Result
```bash
$ flutter build ios --debug --no-codesign

Building com.storebase.app for device (ios)...
✓ Built build/ios/iphoneos/Runner.app
```

---

## 🎯 핵심 포인트

1. **최소화 원칙**: 실제로 사용되는 코드만 유지
2. **Clean Architecture 준수**: 새로운 인벤토리 기능은 `lib/features/inventory_management/` 사용
3. **Legacy 코드 격리**: Old service는 sales_invoice 호환성을 위해서만 유지
4. **명확한 문서화**: 주석으로 Legacy 코드임을 명시

---

## 🔄 향후 작업 (선택사항)

### Priority: Low
Sales Invoice 기능을 새로운 Clean Architecture로 마이그레이션하면, 이 Legacy 서비스도 완전히 제거 가능:

1. `sales_invoice` 기능에서 필요한 데이터를 새로운 repository로 조회
2. `lib/core/services/inventory_service.dart` 완전 삭제
3. `lib/features/sales_invoice/presentation/providers/payment_providers.dart`에서 임포트 제거

---

## ✅ 최종 상태

**모든 컴파일 에러 해결 완료!**

- ✅ Inventory Management 100% 완료 (Product List, Add, Detail, Edit)
- ✅ Build Error 해결
- ✅ iOS 빌드 성공

**사용자는 이제 앱을 정상적으로 빌드하고 실행할 수 있습니다!**
