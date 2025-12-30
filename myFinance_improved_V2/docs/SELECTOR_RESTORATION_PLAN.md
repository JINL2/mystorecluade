# Selector 복원 계획서

## 개요

커밋 `37ca8501` (wholepage refector)에서 사용되던 Autonomous Selector 패턴이 이후 `TossDropdown` + Provider 패턴으로 변경되었습니다.
이 문서는 원래의 Selector 패턴으로 복원하기 위한 조사 결과와 적용 계획을 담고 있습니다.

---

## 1. Selector 종류 및 위치

### 1.1 Selector 파일 (이미 복원됨 ✅)

| 파일 | 설명 | 상태 |
|------|------|------|
| `lib/shared/widgets/selectors/autonomous_cash_location_selector.dart` | Cash Location 선택기 (Company/Store 탭, 검색, blocked items 지원) | ✅ 복원됨 |
| `lib/shared/widgets/selectors/autonomous_counterparty_selector.dart` | Counterparty 선택기 (타입/내부 필터링) | ✅ 복원됨 |
| `lib/shared/widgets/selectors/enhanced_account_selector.dart` | Account 선택기 (Quick access, type-safe callback) | ✅ 복원됨 |
| `lib/shared/widgets/selectors/toss_base_selector.dart` | 기본 Single/Multi selector | ✅ 복원됨 |

---

## 2. 파일별 Selector 사용 현황 (커밋 37ca8501 기준)

### 2.1 journal_input/add_transaction_dialog.dart

| Line | Selector | 용도 |
|------|----------|------|
| 576 | `EnhancedAccountSelector` | Account 선택 (type-safe callback) |
| 610 | `AutonomousCashLocationSelector` | 내 Cash Location 선택 |
| 654 | `AutonomousCounterpartySelector` | Counterparty 선택 |
| 717 | `AutonomousCashLocationSelector` | Counterparty의 Cash Location 선택 (companyId, storeId 전달) |

**현재 상태:** `TossDropdown` + Provider로 변경됨 ❌

### 2.2 transaction_history/transaction_filter_sheet.dart

| Line | Selector | 용도 |
|------|----------|------|
| 132 | `EnhancedAccountSelector` | Account 필터 |
| 152 | `AutonomousCashLocationSelector` | Cash Location 필터 |
| 161 | `AutonomousCounterpartySelector` | Counterparty 필터 |

**현재 상태:** `TossDropdown` + Provider로 변경됨 ❌

### 2.3 transaction_template/template_usage_bottom_sheet.dart

| Line | Selector | 용도 |
|------|----------|------|
| 911 | `AutonomousCashLocationSelector` | 내 Cash Location 선택 |
| 962 | `AutonomousCounterpartySelector` | Counterparty 선택 |
| 1212 | `AutonomousCashLocationSelector` | Counterparty Cash Location 선택 |

**현재 상태:** `TossDropdown` + Provider로 변경됨 ❌

### 2.4 transaction_template/edit_template_bottom_sheet.dart

| Line | Selector | 용도 |
|------|----------|------|
| 891 | `AutonomousCashLocationSelector` | Entry의 Cash Location 선택 |
| 1207 | `AutonomousCashLocationSelector` | Counterparty Cash Location 선택 |

**현재 상태:** 부분적으로 Selector 사용 중 (entry_card.dart 등에서)

### 2.5 transaction_template/template_filter_sheet.dart

| Line | Selector | 용도 |
|------|----------|------|
| 91 | `EnhancedAccountSelector` | Account 필터 |
| 114 | `AutonomousCounterpartySelector` | Counterparty 필터 |
| 130 | `AutonomousCashLocationSelector` | Cash Location 필터 |

**현재 상태:** 확인 필요

### 2.6 transaction_template/widgets/forms/essential_selectors.dart

| Line | Selector | 용도 |
|------|----------|------|
| 94 | `AutonomousCashLocationSelector` | 기본 Cash Location 선택 |
| 107 | `AutonomousCounterpartySelector` | 기본 Counterparty 선택 |

**현재 상태:** 확인 필요

### 2.7 transaction_template/widgets/wizard/account_selector_card.dart

| Line | Selector | 용도 |
|------|----------|------|
| 145 | `EnhancedAccountSelector` | Account 선택 |
| 171 | `AutonomousCounterpartySelector` | Counterparty 선택 |
| 215 | `AutonomousCashLocationSelector` | Cash Location 선택 |
| 311 | `AutonomousCashLocationSelector` | Counterparty Cash Location 선택 |

**현재 상태:** 확인 필요

### 2.8 test/test_template_mapping_page.dart

| Line | Selector | 용도 |
|------|----------|------|
| 575 | `AutonomousCashLocationSelector` | 테스트용 Cash Location |
| 589 | `AutonomousCounterpartySelector` | 테스트용 Counterparty |

**현재 상태:** 테스트 파일 (낮은 우선순위)

---

## 3. Selector 사용법 가이드

### 3.1 AutonomousCashLocationSelector

```dart
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_cash_location_selector.dart';

// 기본 사용 (현재 회사/매장 기준)
AutonomousCashLocationSelector(
  selectedLocationId: _selectedCashLocationId,
  onCashLocationSelected: (cashLocation) {
    setState(() {
      _selectedCashLocationId = cashLocation.id;
      _selectedCashLocationName = cashLocation.name;
      _selectedCashLocationType = cashLocation.type;
    });
  },
  // Legacy callback (null 처리용)
  onChanged: (locationId) {
    if (locationId == null) {
      setState(() {
        _selectedCashLocationId = null;
        _selectedCashLocationName = null;
        _selectedCashLocationType = null;
      });
    }
  },
)

// Counterparty의 Cash Location 선택 (다른 회사)
AutonomousCashLocationSelector(
  companyId: _linkedCompanyId,  // Counterparty의 회사 ID
  storeId: _selectedCounterpartyStoreId,  // Counterparty의 매장 ID
  selectedLocationId: _selectedCounterpartyCashLocationId,
  label: 'Counterparty Cash Location',
  showScopeTabs: false,  // 탭 숨기기
  onCashLocationSelected: (cashLocation) {
    setState(() {
      _selectedCounterpartyCashLocationId = cashLocation.id;
    });
  },
  onChanged: (locationId) {
    if (locationId == null) {
      setState(() => _selectedCounterpartyCashLocationId = null);
    }
  },
)
```

#### 주요 파라미터

| 파라미터 | 타입 | 설명 |
|----------|------|------|
| `companyId` | `String?` | 특정 회사의 cash location 조회 (미지정시 현재 회사) |
| `storeId` | `String?` | 특정 매장으로 필터링 |
| `selectedLocationId` | `String?` | 현재 선택된 location ID |
| `onCashLocationSelected` | `Function(CashLocationData)` | Type-safe 콜백 (전체 엔티티) |
| `onChanged` | `Function(String?)` | Legacy 콜백 (ID만, null 지원) |
| `showScopeTabs` | `bool` | Company/Store 탭 표시 여부 (기본: true) |
| `showSearch` | `bool` | 검색 필드 표시 (기본: true) |
| `blockedLocationIds` | `Set<String>?` | 선택 불가능한 location ID 목록 |
| `hideLabel` | `bool` | 라벨 숨기기 (기본: false) |
| `storeOnly` | `bool` | 매장 전용 필터 (기본: false) |

### 3.2 AutonomousCounterpartySelector

```dart
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_counterparty_selector.dart';

AutonomousCounterpartySelector(
  selectedCounterpartyId: _selectedCounterpartyId,
  onCounterpartySelected: (counterparty) {
    setState(() {
      _selectedCounterpartyId = counterparty.id;
      _selectedCounterpartyName = counterparty.name;
      _isInternal = counterparty.isInternal;
      _linkedCompanyId = counterparty.linkedCompanyId;

      // Reset dependent fields
      _selectedCounterpartyStoreId = null;
      _selectedCounterpartyCashLocationId = null;
    });

    // Check account mapping if needed
    _checkAccountMapping();
  },
  onChanged: (counterpartyId) {
    if (counterpartyId == null) {
      setState(() {
        _selectedCounterpartyId = null;
        _selectedCounterpartyName = null;
        _isInternal = false;
        _linkedCompanyId = null;
      });
    }
  },
  // Optional filters
  counterpartyType: 'supplier',  // 'supplier', 'customer', etc.
  isInternal: false,  // Internal counterparties only
)
```

### 3.3 EnhancedAccountSelector

```dart
import 'package:myfinance_improved/shared/widgets/selectors/enhanced_account_selector.dart';

EnhancedAccountSelector(
  selectedAccountId: _selectedAccountId,
  onAccountSelected: (account) {
    setState(() {
      _selectedAccountId = account.id;
      _selectedAccountName = account.name;
      _selectedCategoryTag = account.categoryTag;

      // Reset dependent fields when account changes
      _selectedCashLocationId = null;
      _selectedCounterpartyId = null;
    });
  },
  onChanged: (accountId) {
    if (accountId == null) {
      setState(() {
        _selectedAccountId = null;
        _selectedAccountName = null;
        _selectedCategoryTag = null;
      });
    }
  },
)
```

---

## 4. 복원 적용 계획

### 4.1 우선순위

| 우선순위 | 파일 | 이유 |
|----------|------|------|
| 🔴 높음 | `add_transaction_dialog.dart` | 핵심 기능, 가장 많은 selector 사용 |
| 🔴 높음 | `transaction_filter_sheet.dart` | 필터 기능 핵심 |
| 🟡 중간 | `template_usage_bottom_sheet.dart` | 템플릿 사용 기능 |
| 🟡 중간 | `template_filter_sheet.dart` | 템플릿 필터 |
| 🟢 낮음 | `essential_selectors.dart` | 공통 위젯 |
| 🟢 낮음 | `account_selector_card.dart` | 마법사 위젯 |
| ⚪ 테스트 | `test_template_mapping_page.dart` | 테스트 전용 |

### 4.2 복원 단계

#### Phase 1: 핵심 파일 복원 (높은 우선순위)

**Step 1: add_transaction_dialog.dart**
```bash
# 이전 커밋에서 해당 파일만 복원
git show 37ca8501:myFinance_improved_V2/lib/features/journal_input/presentation/widgets/add_transaction_dialog.dart > /tmp/add_transaction_dialog_old.dart

# 수동으로 selector 부분만 비교하여 복원
```

변경 포인트:
1. Import 추가
   ```dart
   import 'package:myfinance_improved/shared/widgets/selectors/autonomous_cash_location_selector.dart';
   import 'package:myfinance_improved/shared/widgets/selectors/autonomous_counterparty_selector.dart';
   import 'package:myfinance_improved/shared/widgets/selectors/enhanced_account_selector.dart';
   ```

2. Account 선택 부분 (Line ~576)
   - `TossDropdown` → `EnhancedAccountSelector`

3. Cash Location 선택 부분 (Line ~610)
   - `TossDropdown` + `companyCashLocationsProvider` → `AutonomousCashLocationSelector`

4. Counterparty 선택 부분 (Line ~654)
   - `TossDropdown` + `currentCounterpartiesProvider` → `AutonomousCounterpartySelector`

5. Counterparty Cash Location 부분 (Line ~717)
   - `TossDropdown` + `counterpartyCompanyCashLocationsProvider` → `AutonomousCashLocationSelector(companyId: ...)`

**Step 2: transaction_filter_sheet.dart**
동일한 패턴으로 3개 selector 복원

#### Phase 2: 템플릿 관련 파일 (중간 우선순위)

**Step 3: template_usage_bottom_sheet.dart**
**Step 4: template_filter_sheet.dart**

#### Phase 3: 위젯 파일 (낮은 우선순위)

**Step 5: essential_selectors.dart**
**Step 6: account_selector_card.dart**

### 4.3 안전한 복원 방법

#### 방법 A: git checkout으로 파일 전체 복원 (주의 필요)
```bash
# 특정 파일만 이전 커밋에서 복원
git checkout 37ca8501 -- myFinance_improved_V2/lib/features/journal_input/presentation/widgets/add_transaction_dialog.dart
```
⚠️ **주의:** 이 방법은 해당 파일의 다른 변경사항도 되돌립니다. 비즈니스 로직 수정이 있었다면 그것도 사라집니다.

#### 방법 B: 수동으로 selector 부분만 복원 (권장)
1. 이전 커밋의 파일 내용 확인
   ```bash
   git show 37ca8501:myFinance_improved_V2/lib/features/journal_input/presentation/widgets/add_transaction_dialog.dart | grep -A 30 "AutonomousCashLocationSelector\|AutonomousCounterpartySelector\|EnhancedAccountSelector"
   ```

2. 현재 파일에서 `TossDropdown` 부분을 찾아 Selector로 교체

3. Import 문 추가

4. 빌드 테스트
   ```bash
   flutter analyze lib/
   ```

#### 방법 C: Diff 기반 패치 적용
```bash
# 두 버전 간 차이 확인
git diff 37ca8501 HEAD -- myFinance_improved_V2/lib/features/journal_input/presentation/widgets/add_transaction_dialog.dart
```

---

## 5. 체크리스트

### 복원 전 확인
- [ ] Selector 파일 4개 모두 존재하는지 확인
- [ ] `flutter analyze lib/` 에러 없는지 확인
- [ ] 현재 코드의 비즈니스 로직 변경사항 파악

### 파일별 복원 체크리스트

#### add_transaction_dialog.dart
- [ ] Import 문 추가
- [ ] `EnhancedAccountSelector` 복원 (Line 576)
- [ ] `AutonomousCashLocationSelector` 복원 - 내 Cash Location (Line 610)
- [ ] `AutonomousCounterpartySelector` 복원 (Line 654)
- [ ] `AutonomousCashLocationSelector` 복원 - Counterparty Cash Location (Line 717)
- [ ] 빌드 테스트 통과

#### transaction_filter_sheet.dart
- [ ] Import 문 추가
- [ ] `EnhancedAccountSelector` 복원 (Line 132)
- [ ] `AutonomousCashLocationSelector` 복원 (Line 152)
- [ ] `AutonomousCounterpartySelector` 복원 (Line 161)
- [ ] 빌드 테스트 통과

#### template_usage_bottom_sheet.dart
- [ ] Import 문 추가
- [ ] `AutonomousCashLocationSelector` 복원 (Line 911)
- [ ] `AutonomousCounterpartySelector` 복원 (Line 962)
- [ ] `AutonomousCashLocationSelector` 복원 - Counterparty (Line 1212)
- [ ] 빌드 테스트 통과

#### template_filter_sheet.dart
- [ ] Import 문 추가
- [ ] `EnhancedAccountSelector` 복원 (Line 91)
- [ ] `AutonomousCounterpartySelector` 복원 (Line 114)
- [ ] `AutonomousCashLocationSelector` 복원 (Line 130)
- [ ] 빌드 테스트 통과

#### essential_selectors.dart
- [ ] `AutonomousCashLocationSelector` 복원 (Line 94)
- [ ] `AutonomousCounterpartySelector` 복원 (Line 107)
- [ ] 빌드 테스트 통과

#### account_selector_card.dart
- [ ] Import 문 추가
- [ ] `EnhancedAccountSelector` 복원 (Line 145)
- [ ] `AutonomousCounterpartySelector` 복원 (Line 171)
- [ ] `AutonomousCashLocationSelector` 복원 (Line 215)
- [ ] `AutonomousCashLocationSelector` 복원 - Counterparty (Line 311)
- [ ] 빌드 테스트 통과

### 복원 후 확인
- [ ] `flutter analyze lib/` 에러 없음
- [ ] 앱 실행 테스트
- [ ] 각 selector 동작 테스트
  - [ ] Account 선택 동작
  - [ ] Cash Location 선택 동작 (Company/Store 탭 전환)
  - [ ] Counterparty 선택 동작
  - [ ] Counterparty Cash Location 선택 동작

---

## 6. TossDropdown vs Autonomous Selector 비교

| 항목 | TossDropdown + Provider | Autonomous Selector |
|------|------------------------|---------------------|
| 코드량 | 많음 (매번 Provider watch 필요) | 적음 (내장) |
| Type Safety | 낮음 (ID만 반환) | 높음 (전체 엔티티 반환) |
| Company/Store 탭 | 직접 구현 필요 | 내장 지원 |
| 검색 기능 | 직접 구현 필요 | 내장 지원 |
| Blocked Items | 직접 구현 필요 | 내장 지원 |
| Counterparty 회사 지원 | 별도 Provider 필요 | `companyId` 파라미터로 지원 |
| 재사용성 | 낮음 | 높음 |

---

## 7. 결론

Autonomous Selector 패턴은 다음과 같은 이점이 있습니다:
1. **재사용성**: 여러 페이지에서 동일한 selector 사용
2. **일관성**: 동일한 UI/UX 경험
3. **Type Safety**: 전체 엔티티를 콜백으로 전달
4. **내장 기능**: 검색, 탭, blocked items 등

따라서 `TossDropdown` + Provider 패턴으로 변경된 부분을 다시 Autonomous Selector 패턴으로 복원하는 것이 권장됩니다.

---

---

## 8. 현재 상태 요약 (2025-12-30 기준)

### 8.1 Selector를 사용 중인 파일 (현재)

| 파일 | 사용 Selector | 상태 |
|------|---------------|------|
| `transaction_template/widgets/edit_template/entry_card.dart` | `AutonomousCashLocationSelector` | ✅ 사용 중 |
| `transaction_template/widgets/edit_template/counterparty_section.dart` | `AutonomousCashLocationSelector` | ✅ 사용 중 |
| `transaction_template/widgets/template_usage/counterparty_cash_location_selector.dart` | `AutonomousCashLocationSelector` | ✅ 사용 중 |

### 8.2 복원이 필요한 파일 (TossDropdown으로 변경됨)

| 파일 | 이전 Selector | 현재 상태 | 복원 필요 |
|------|---------------|-----------|-----------|
| `journal_input/add_transaction_dialog.dart` | 4개 (Enhanced, Cash×2, Counterparty) | TossDropdown | ✅ 필요 |
| `transaction_history/transaction_filter_sheet.dart` | 3개 (Enhanced, Cash, Counterparty) | TossDropdown | ✅ 필요 |
| `transaction_template/template_usage_bottom_sheet.dart` | 3개 (Cash×2, Counterparty) | TossDropdown | ✅ 필요 |
| `transaction_template/template_filter_sheet.dart` | 3개 (Enhanced, Cash, Counterparty) | 확인 필요 | ❓ 확인 필요 |
| `transaction_template/widgets/forms/essential_selectors.dart` | 2개 (Cash, Counterparty) | 확인 필요 | ❓ 확인 필요 |
| `transaction_template/widgets/wizard/account_selector_card.dart` | 4개 (Enhanced, Cash×2, Counterparty) | 확인 필요 | ❓ 확인 필요 |

### 8.3 복원 작업 요약

```
총 8개 파일 중:
- ✅ 3개 파일: 이미 Selector 사용 중 (복원 불필요)
- ❌ 3개 파일: TossDropdown으로 변경됨 (복원 필요 확정)
- ❓ 3개 파일: 확인 필요
- ⚪ 1개 파일: 테스트 파일 (낮은 우선순위)
```

---

*문서 작성일: 2025-12-30*
*기준 커밋: 37ca8501 (wholepage refector)*
