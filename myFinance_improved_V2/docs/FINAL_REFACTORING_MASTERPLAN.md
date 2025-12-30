# MyFinance Shared 폴더 리팩토링 마스터플랜

> **버전**: 2.0 Final
> **작성일**: 2025-12-30
> **원칙**: Zero Breaking Change + AI/Human Readable Structure

---

## 1. 네이밍 컨벤션 (Naming Convention)

### 1.1 폴더 이름 규칙

```
✅ 좋은 예:
selectors/account/          # 무엇을 선택하는지 명확
selectors/cash_location/    # snake_case, 의미 명확
selectors/counterparty/     # 단일 책임 명확

❌ 나쁜 예:
selectors/enhanced/         # 무엇이 enhanced인지 불명확
selectors/autonomous/       # 기술적 용어, 비즈니스 의미 없음
selectors/misc/             # 의미 없음
```

### 1.2 파일 이름 규칙

```
✅ 좋은 예:
account_selector.dart           # 메인 위젯 (외부 API)
account_selector_sheet.dart     # 바텀시트 UI
account_selector_list.dart      # 리스트 컴포넌트
account_selector_item.dart      # 아이템 컴포넌트
account_selector_state.dart     # 상태 관리

❌ 나쁜 예:
enhanced_account_selector.dart  # "enhanced"는 버전 정보, 이름에 불필요
_account_bottom_sheet.dart      # 언더스코어 prefix는 private 파일 암시 (혼란)
account_bs.dart                 # 축약어 사용 금지
```

### 1.3 클래스 이름 규칙

```dart
// ✅ 좋은 예: 역할이 명확
class AccountSelector extends ConsumerStatefulWidget {}
class AccountSelectorSheet extends StatelessWidget {}
class AccountSelectorList extends StatelessWidget {}
class AccountSelectorItem extends StatelessWidget {}

// ❌ 나쁜 예: 불필요한 수식어
class EnhancedAccountSelector {}      // "Enhanced" 제거
class AutonomousCashLocationSelector {} // "Autonomous" 제거
class TossAccountSelector {}          // "Toss"는 디자인 시스템, 위젯 이름에 불필요
```

---

## 2. 폴더 구조 (TO-BE)

### 2.1 selectors/ 최종 구조

```
lib/shared/widgets/selectors/
│
├── index.dart                    # 메인 barrel export
│
├── base/                         # 기본 제네릭 셀렉터
│   ├── index.dart
│   ├── single_selector.dart      # TossSingleSelector<T>
│   └── multi_selector.dart       # TossMultiSelector<T>
│
├── account/                      # 계정 선택기
│   ├── index.dart                # barrel export
│   ├── account_selector.dart     # 메인 위젯 (외부 API)
│   ├── account_selector_sheet.dart    # 바텀시트 컨테이너
│   ├── account_selector_list.dart     # 리스트 UI
│   ├── account_selector_item.dart     # 아이템 위젯
│   ├── account_quick_access.dart      # Quick Access 섹션
│   └── account_multi_select.dart      # 다중 선택 UI
│
├── cash_location/                # 현금 위치 선택기
│   ├── index.dart
│   ├── cash_location_selector.dart    # 메인 위젯
│   ├── cash_location_sheet.dart       # 바텀시트 컨테이너
│   ├── cash_location_tabs.dart        # Company/Store 탭
│   ├── cash_location_list.dart        # 리스트 UI
│   └── cash_location_item.dart        # 아이템 위젯
│
└── counterparty/                 # 거래처 선택기
    ├── index.dart
    └── counterparty_selector.dart     # 메인 위젯 (크기 적정)
```

### 2.2 파일별 책임 (Single Responsibility)

| 파일 | 책임 | 예상 줄 수 |
|------|------|----------|
| `*_selector.dart` | 메인 위젯, Props 정의, 외부 API | 150-250 |
| `*_sheet.dart` | 바텀시트 컨테이너, 레이아웃 | 150-200 |
| `*_list.dart` | 리스트 렌더링, 스크롤 | 100-150 |
| `*_item.dart` | 단일 아이템 UI | 80-120 |
| `*_tabs.dart` | 탭 네비게이션 | 80-100 |
| `*_quick_access.dart` | Quick Access 섹션 | 100-150 |

---

## 3. Phase 3: God File 분리 상세 계획

### 3.1 enhanced_account_selector.dart 분리

**현재**: 1,160줄, 1개 파일
**목표**: 6개 파일, 각 150-250줄

#### Step 1: 폴더 및 파일 생성

```bash
mkdir -p lib/shared/widgets/selectors/account
```

#### Step 2: 파일별 코드 분리

**account_selector.dart** (메인 위젯 - 외부 API)
```dart
/// Account Selector
///
/// 계정을 선택하는 자율형(Autonomous) 위젯.
/// 내부적으로 Riverpod Provider를 사용하여 데이터를 자동으로 로드합니다.
///
/// ## 기본 사용법
/// ```dart
/// AccountSelector(
///   selectedAccountId: _selectedId,
///   onAccountSelected: (account) {
///     setState(() => _selectedId = account.id);
///   },
/// )
/// ```
///
/// ## 다중 선택
/// ```dart
/// AccountSelector.multi(
///   selectedAccountIds: _selectedIds,
///   onMultiAccountSelected: (accounts) {
///     setState(() => _selectedIds = accounts.map((a) => a.id).toList());
///   },
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ... imports

export 'account_selector_sheet.dart' show AccountSelectorSheet;
export 'account_selector_item.dart' show AccountSelectorItem;

/// 계정 선택 콜백 타입
typedef OnAccountSelected = void Function(AccountData account);
typedef OnMultiAccountSelected = void Function(List<AccountData> accounts);

/// 계정 선택기 위젯
class AccountSelector extends ConsumerStatefulWidget {
  // ... 기존 props (selectedAccountId, onAccountSelected 등)

  /// 단일 선택 모드 생성자
  const AccountSelector({...});

  /// 다중 선택 모드 생성자
  const AccountSelector.multi({...});
}
```

**account_selector_sheet.dart** (바텀시트)
```dart
/// Account Selector Bottom Sheet
///
/// AccountSelector가 내부적으로 사용하는 바텀시트 UI.
/// 직접 사용하지 않고, AccountSelector를 통해 자동으로 표시됩니다.
library;

import 'package:flutter/material.dart';
// ... imports

class AccountSelectorSheet extends StatelessWidget {
  final List<AccountData> accounts;
  final String? selectedId;
  final OnAccountSelected onSelect;
  final bool showSearch;
  final bool showQuickAccess;
  // ...
}
```

**account_selector_list.dart** (리스트)
```dart
/// Account Selector List
///
/// 계정 목록을 렌더링하는 위젯.
library;

class AccountSelectorList extends StatelessWidget {
  final List<AccountData> accounts;
  final String? selectedId;
  final OnAccountSelected onSelect;
  final ScrollController? scrollController;
  // ...
}
```

**account_selector_item.dart** (아이템)
```dart
/// Account Selector Item
///
/// 계정 목록의 단일 아이템 위젯.
library;

class AccountSelectorItem extends StatelessWidget {
  final AccountData account;
  final bool isSelected;
  final VoidCallback onTap;
  final int? usageCount; // Quick Access용
  // ...
}
```

**account_quick_access.dart** (Quick Access)
```dart
/// Account Quick Access Section
///
/// 자주 사용하는 계정을 빠르게 선택할 수 있는 섹션.
library;

class AccountQuickAccess extends StatelessWidget {
  final List<QuickAccessAccount> quickAccounts;
  final List<AccountData> allAccounts;
  final String? selectedId;
  final OnAccountSelected onSelect;
  // ...
}
```

**account_multi_select.dart** (다중 선택)
```dart
/// Account Multi Select UI
///
/// 다중 선택 모드의 UI 컴포넌트.
library;

class AccountMultiSelectControls extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onConfirm;
  // ...
}

class AccountMultiSelectItem extends StatelessWidget {
  final AccountData account;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;
  // ...
}
```

#### Step 3: index.dart 작성

```dart
/// Account Selector
///
/// 계정 선택을 위한 자율형 위젯 모음.
///
/// ## 주요 클래스
/// - [AccountSelector] - 메인 위젯 (단일/다중 선택)
/// - [AccountSelectorSheet] - 바텀시트 (내부 사용)
/// - [AccountSelectorItem] - 아이템 위젯 (커스텀 필요시)
///
/// ## 사용 예시
/// ```dart
/// import 'package:myfinance_improved/shared/widgets/selectors/account/index.dart';
///
/// AccountSelector(
///   selectedAccountId: _id,
///   onAccountSelected: (account) => setState(() => _id = account.id),
/// )
/// ```
library;

// 메인 위젯 (외부 API)
export 'account_selector.dart';

// 서브 컴포넌트 (필요시 직접 사용)
export 'account_selector_sheet.dart';
export 'account_selector_list.dart';
export 'account_selector_item.dart';
export 'account_quick_access.dart';
export 'account_multi_select.dart';
```

### 3.2 autonomous_cash_location_selector.dart 분리

**현재**: ~1,400줄, 1개 파일
**목표**: 5개 파일, 각 150-250줄

```
cash_location/
├── index.dart
├── cash_location_selector.dart    # 메인 위젯
├── cash_location_sheet.dart       # 바텀시트
├── cash_location_tabs.dart        # Company/Store 탭
├── cash_location_list.dart        # 리스트
└── cash_location_item.dart        # 아이템
```

### 3.3 toss_base_selector.dart 리네이밍

**현재**:
```
selectors/
├── toss_base_selector.dart  # TossSingleSelector, TossMultiSelector
```

**변경**:
```
selectors/
└── base/
    ├── index.dart
    ├── single_selector.dart   # TossSingleSelector<T> (이름 유지, 파일만 분리)
    └── multi_selector.dart    # TossMultiSelector<T>
```

---

## 4. 호환성 유지 전략

### 4.1 클래스 이름 변경 시 Deprecated 처리

```dart
// account_selector.dart

/// 새 이름
class AccountSelector extends ConsumerStatefulWidget { ... }

/// 기존 이름 유지 (deprecated)
@Deprecated('Use AccountSelector instead. Will be removed in v2.0')
typedef EnhancedAccountSelector = AccountSelector;
```

```dart
// cash_location_selector.dart

/// 새 이름
class CashLocationSelector extends ConsumerStatefulWidget { ... }

/// 기존 이름 유지 (deprecated)
@Deprecated('Use CashLocationSelector instead. Will be removed in v2.0')
typedef AutonomousCashLocationSelector = CashLocationSelector;
```

### 4.2 Import 경로 호환성

```dart
// selectors/index.dart (최상위)

library;

// 새 구조
export 'base/index.dart';
export 'account/index.dart';
export 'cash_location/index.dart';
export 'counterparty/index.dart';

// ⚠️ 호환성: 기존 파일 경로 re-export
// 기존: import '.../selectors/enhanced_account_selector.dart'
// 이제: 위 import가 account/index.dart를 통해 작동
export 'account/account_selector.dart' show AccountSelector, EnhancedAccountSelector;
export 'cash_location/cash_location_selector.dart' show CashLocationSelector, AutonomousCashLocationSelector;
```

---

## 5. 실행 순서 (Step-by-Step)

### Phase 3 실행 순서

```
Day 1: 폴더 구조 생성
├── mkdir -p selectors/base
├── mkdir -p selectors/account
├── mkdir -p selectors/cash_location
└── mkdir -p selectors/counterparty

Day 2-3: base/ 분리
├── toss_base_selector.dart → base/single_selector.dart
├── toss_base_selector.dart → base/multi_selector.dart
├── base/index.dart 생성
└── 빌드 테스트

Day 4-5: account/ 분리
├── enhanced_account_selector.dart 분석
├── account_selector.dart 생성 (메인)
├── account_selector_sheet.dart 생성
├── account_selector_list.dart 생성
├── account_selector_item.dart 생성
├── account_quick_access.dart 생성
├── account_multi_select.dart 생성
├── account/index.dart 생성
├── typedef 호환성 추가
└── 빌드 테스트

Day 6-7: cash_location/ 분리
├── autonomous_cash_location_selector.dart 분석
├── cash_location_selector.dart 생성 (메인)
├── cash_location_sheet.dart 생성
├── cash_location_tabs.dart 생성
├── cash_location_list.dart 생성
├── cash_location_item.dart 생성
├── cash_location/index.dart 생성
├── typedef 호환성 추가
└── 빌드 테스트

Day 8: counterparty/ 정리
├── autonomous_counterparty_selector.dart → counterparty/counterparty_selector.dart
├── typedef 호환성 추가
└── counterparty/index.dart 생성

Day 9: 정리 및 테스트
├── selectors/index.dart 업데이트
├── 기존 파일 삭제 (또는 re-export만 유지)
├── 전체 빌드 테스트
└── 8개 사용 파일 동작 테스트
```

---

## 6. 최종 폴더 구조

### 6.1 selectors/ 완성형

```
lib/shared/widgets/selectors/
│
├── index.dart                      # 통합 barrel export
│
├── base/                           # 제네릭 기본 셀렉터
│   ├── index.dart
│   ├── single_selector.dart        # TossSingleSelector<T>
│   ├── multi_selector.dart         # TossMultiSelector<T>
│   └── selector_config.dart        # SelectorConfig 클래스
│
├── account/                        # 계정 선택기 (6개 파일)
│   ├── index.dart
│   ├── account_selector.dart       # AccountSelector (메인)
│   ├── account_selector_sheet.dart
│   ├── account_selector_list.dart
│   ├── account_selector_item.dart
│   ├── account_quick_access.dart
│   └── account_multi_select.dart
│
├── cash_location/                  # 현금 위치 선택기 (5개 파일)
│   ├── index.dart
│   ├── cash_location_selector.dart # CashLocationSelector (메인)
│   ├── cash_location_sheet.dart
│   ├── cash_location_tabs.dart
│   ├── cash_location_list.dart
│   └── cash_location_item.dart
│
└── counterparty/                   # 거래처 선택기 (2개 파일)
    ├── index.dart
    └── counterparty_selector.dart  # CounterpartySelector (메인)
```

### 6.2 전체 shared/ 구조

```
lib/shared/
├── index.dart                      # 통합 barrel
│
├── extensions/
│   └── string_extensions.dart
│
├── utils/
│   ├── data_filter_utils.dart
│   ├── thousand_separator_formatter.dart
│   └── debug/                      # Phase 2에서 이동
│       ├── index.dart
│       └── ... (5개 디버그 파일)
│
├── themes/
│   ├── index.dart
│   └── ... (디자인 토큰들)
│
└── widgets/
    ├── index.dart
    ├── core/                       # 유지 (re-export 구조)
    ├── common/                     # ✅ index.dart 추가됨
    ├── toss/                       # 유지 (실제 위젯 파일)
    ├── selectors/                  # ✅ 분리 완료
    │   ├── base/
    │   ├── account/
    │   ├── cash_location/
    │   └── counterparty/
    ├── overlays/
    ├── feedback/
    ├── calendar/
    ├── keyboard/
    ├── navigation/
    ├── domain/
    ├── ai/
    └── ai_chat/
```

---

## 7. 사용 예시 (After Refactoring)

### 7.1 단일 선택

```dart
import 'package:myfinance_improved/shared/widgets/index.dart';

// 계정 선택
AccountSelector(
  selectedAccountId: _accountId,
  onAccountSelected: (account) {
    setState(() {
      _accountId = account.id;
      _accountName = account.name;
    });
  },
)

// 현금 위치 선택
CashLocationSelector(
  selectedLocationId: _locationId,
  onCashLocationSelected: (location) {
    setState(() => _locationId = location.id);
  },
)

// 거래처 선택
CounterpartySelector(
  selectedCounterpartyId: _counterpartyId,
  onCounterpartySelected: (counterparty) {
    setState(() => _counterpartyId = counterparty.id);
  },
)
```

### 7.2 다중 선택

```dart
AccountSelector.multi(
  selectedAccountIds: _selectedIds,
  onMultiAccountSelected: (accounts) {
    setState(() {
      _selectedIds = accounts.map((a) => a.id).toList();
    });
  },
)
```

### 7.3 기존 코드 호환성

```dart
// 기존 코드 (여전히 작동, deprecated 경고 표시)
EnhancedAccountSelector(...)           // → AccountSelector로 리다이렉트
AutonomousCashLocationSelector(...)    // → CashLocationSelector로 리다이렉트
AutonomousCounterpartySelector(...)    // → CounterpartySelector로 리다이렉트
```

---

## 8. 체크리스트

### Phase 1 ✅ 완료

- [x] `selectors/index.dart` 생성
- [x] `common/index.dart` 생성
- [x] `widgets/index.dart` 수정
- [x] `shared/index.dart` 생성

### Phase 2: themes/ 정리

- [ ] `utils/debug/` 폴더 생성
- [ ] 5개 디버그 파일 이동
- [ ] `themes/index.dart` 수정

### Phase 3: God File 분리

- [ ] `selectors/base/` 생성 및 분리
- [ ] `selectors/account/` 생성 및 분리 (6개 파일)
- [ ] `selectors/cash_location/` 생성 및 분리 (5개 파일)
- [ ] `selectors/counterparty/` 생성 및 분리
- [ ] `selectors/index.dart` 업데이트
- [ ] typedef 호환성 추가
- [ ] 전체 빌드 테스트
- [ ] 8개 사용 파일 동작 테스트

---

## 9. 성공 지표

| 지표 | 현재 | 목표 |
|------|------|------|
| 최대 파일 크기 | 1,400줄 | **250줄** |
| 파일당 클래스 수 | 3-5개 | **1개** |
| 폴더 이름 명확성 | 60% | **100%** |
| 클래스 이름 일관성 | 50% | **100%** |
| Breaking Change | - | **0개** |
| AI 이해도 (구조) | 70% | **95%** |

---

*문서 버전: 2.0 Final*
*작성일: 2025-12-30*
