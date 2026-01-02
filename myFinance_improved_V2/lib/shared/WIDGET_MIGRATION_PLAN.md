# Shared Widget Migration Plan

## 대전제: 코드 효율성 & 디자인 통일성

> **안전한 마이그레이션 원칙**
> - 각 페이지/폴더마다 파라미터와 요구사항이 다름을 인지
> - 기능 손실 없이 1:1 대체 가능한 경우만 마이그레이션
> - Feature-specific 위젯은 유지 (도메인 로직 포함)
> - 단순 UI 위젯만 Toss 위젯으로 통일

---

## 정확한 현재 상태 (2026-01-01)

| Widget Type | Toss | Native | Migration % | Priority |
|-------------|------|--------|-------------|----------|
| **Button** | 306 | 0 | **100%** ✅ | Done |
| **Card** | 62+ | 6 | **91%** ✅ | Low |
| Dialog | 165 | 49 | 77% | Low |
| Scaffold | 90 | 52 | 63% | Medium |
| AppBar | 62 | 75 | 45% | Medium |
| Loading | 74 | 129 | 36% | **High** |
| Toast/SnackBar | 78 | 210 | 27% | **High** |

### Card 분석 상세 (이전 분석 오류 수정)
- **이전 분석**: Card 390개 (잘못됨 - class명 포함)
- **정확한 분석**: Flutter `Card(` 위젯 **6개만** 존재
- **Toss Card 위젯들**: TossWhiteCard(21), TossExpandableCard(4), TossSelectionCard(19), TradeSimpleCard(18)
- **Feature-specific Cards** (마이그레이션 대상 아님): EmployeeCard, ShiftCard, ProductCard 등

---

## 마이그레이션 대상 vs 제외 대상

### ✅ 마이그레이션 대상 (단순 UI 위젯)
```dart
// 이런 패턴은 마이그레이션
CircularProgressIndicator()  → TossLoadingView()
SnackBar(content: Text('...'))  → TossToast.info()
Card(child: ...)  → TossWhiteCard(child: ...)
```

### ❌ 마이그레이션 제외 (Feature-specific 위젯)
```dart
// 이런 패턴은 유지 - 도메인 로직 포함
EmployeeCard(employee: employee)  // 유지
ShiftCard(shift: shift)  // 유지
ProductCard(product: product)  // 유지
TransactionCard(transaction: tx)  // 유지
```

### ❌ 마이그레이션 제외 (특수 요구사항)
```dart
// 커스텀 기능이 필요한 경우
CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(customColor),
  strokeWidth: 6,  // 특수 스타일
)

// 이런 경우 주석으로 명시
// NOTE: Keep native - custom animation color required
```

---

## Phase 1: Loading Migration (129개) - HIGH PRIORITY

### 목표
- `CircularProgressIndicator` 129개 → `TossLoadingView`
- 예상 마이그레이션율: ~36% → ~70%

### 파일별 분석 필요
각 CircularProgressIndicator 사용처를 분석하여 분류:

#### Type A: 단순 로딩 (바로 마이그레이션)
```dart
// Before
Center(child: CircularProgressIndicator())
if (isLoading) CircularProgressIndicator()

// After
const TossLoadingView()
if (isLoading) const TossLoadingView()
```

#### Type B: 인라인 로딩 (크기 조정 필요)
```dart
// Before
SizedBox(
  width: 20,
  height: 20,
  child: CircularProgressIndicator(strokeWidth: 2),
)

// After
TossLoadingView.inline(size: 20)
```

#### Type C: 커스텀 스타일 (마이그레이션 제외 또는 TossLoadingView 확장)
```dart
// 특수 색상, 두께 등이 필요한 경우
CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
  backgroundColor: TossColors.gray100,
)
// → TossLoadingView가 지원하면 마이그레이션, 아니면 유지
```

### 작업 순서
1. `grep -rn "CircularProgressIndicator" lib/features/` 로 전체 목록 추출
2. 각 파일별 Type 분류
3. Type A 먼저 마이그레이션 (가장 안전)
4. Type B는 TossLoadingView.inline 지원 확인 후 마이그레이션
5. Type C는 케이스별 판단

### 주요 파일 (예상)
| 폴더 | 예상 개수 | 난이도 |
|------|----------|--------|
| session/ | ~15 | Easy |
| cash_location/ | ~12 | Easy |
| cash_transaction/ | ~10 | Easy |
| inventory_management/ | ~20 | Medium |
| 기타 | ~72 | Mixed |

---

## Phase 2: Toast Migration (210개) - HIGH PRIORITY

### 목표
- `SnackBar` / `ScaffoldMessenger.showSnackBar` 210개 → `TossToast`
- 예상 마이그레이션율: ~70% → ~85%

### 패턴 분류

#### Type A: 단순 메시지 (바로 마이그레이션)
```dart
// Before
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('저장되었습니다')),
);

// After
TossToast.success(context, '저장되었습니다');
```

#### Type B: 에러 메시지
```dart
// Before
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('오류가 발생했습니다'),
    backgroundColor: Colors.red,
  ),
);

// After
TossToast.error(context, '오류가 발생했습니다');
```

#### Type C: Action 버튼 포함 (TossToast 확장 필요 확인)
```dart
// Before
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('삭제되었습니다'),
    action: SnackBarAction(
      label: '취소',
      onPressed: undoDelete,
    ),
  ),
);

// After (TossToast가 action 지원하는 경우)
TossToast.info(
  context,
  '삭제되었습니다',
  action: ToastAction(label: '취소', onPressed: undoDelete),
);

// TossToast가 action 미지원시 → 유지 또는 TossToast 확장
```

### 작업 순서
1. TossToast 현재 지원 기능 확인 (action, duration 등)
2. 부족한 기능 있으면 TossToast 먼저 확장
3. Type A, B 먼저 마이그레이션
4. Type C는 기능 지원 확인 후 마이그레이션

---

## Phase 3: Card Migration (6개) - LOW PRIORITY

### 목표
- Native `Card(` 위젯 6개 → Toss Card 계열

### 대상 파일 (정확한 목록)
```
lib/features/purchase_order/presentation/widgets/po_form/po_items_section.dart:169
lib/features/letter_of_credit/presentation/pages/lc_detail_page.dart:313
lib/features/letter_of_credit/presentation/pages/lc_detail_page.dart:453
lib/features/letter_of_credit/presentation/pages/lc_list_page.dart:350
lib/features/letter_of_credit/presentation/pages/lc_form_page.dart:1048
lib/features/session/presentation/pages/session_page.dart:117
```

### 마이그레이션 전략
각 Card의 용도를 분석하여 적합한 Toss Card 선택:

| 현재 Card 용도 | 권장 Toss Card |
|---------------|----------------|
| 정보 표시 카드 | TossWhiteCard |
| 선택 가능 카드 | TossSelectionCard |
| 확장 가능 카드 | TossExpandableCard |
| 거래 정보 카드 | TradeSimpleCard |

### 작업 순서
1. 각 6개 파일 읽고 Card 용도 파악
2. 적합한 Toss Card 매핑
3. 하나씩 마이그레이션 + 빌드 확인

---

## Phase 4: Dialog Migration (49개) - LOW PRIORITY

### 목표
- `AlertDialog` 49개 중 **적합한 것만** TossDialog로

### 선택적 마이그레이션 원칙
TossDialog가 지원하는 패턴만 마이그레이션:
- ✅ 단순 확인 다이얼로그 → TossDialog.confirm
- ✅ 성공/에러 알림 → TossDialog.success/error
- ❌ 커스텀 컨텐츠 (Form, 복잡한 UI) → 유지

### 마이그레이션 제외 예시
```dart
// 이런 복잡한 다이얼로그는 유지
AlertDialog(
  title: Text('상품 추가'),
  content: Column(
    children: [
      TextField(...),
      DropdownButton(...),
      CheckboxListTile(...),
    ],
  ),
  actions: [...],
)
```

---

## Phase 5: Scaffold/AppBar (신규 페이지 전략)

### 현황
- TossScaffold: 90개 사용 중
- Native Scaffold: 52개 사용 중
- TossAppBar: 62개 사용 중
- Native AppBar: 75개 사용 중

### 전략: 기존 유지 + 신규만 적용
- **기존 페이지**: 동작하는 코드 건드리지 않음
- **신규 페이지**: TossScaffold + TossAppBar 필수 사용
- **리팩토링 시**: 해당 페이지만 TossScaffold로 전환

### 이유
- Scaffold/AppBar 변경은 레이아웃 전체에 영향
- 테스트 범위가 넓어 리스크 높음
- 점진적 자연 마이그레이션이 안전

---

## 마이그레이션 체크리스트

### 각 파일 마이그레이션 전
- [ ] 해당 위젯이 단순 UI인지 Feature-specific인지 확인
- [ ] Toss 위젯이 필요한 모든 기능 지원하는지 확인
- [ ] 특수 스타일/동작이 필요한지 확인

### 각 파일 마이그레이션 후
- [ ] `flutter analyze` 에러 없음
- [ ] 해당 화면 정상 동작 확인
- [ ] 시각적 디자인 일관성 확인

### 각 Phase 완료 후
- [ ] `flutter build apk --debug` 성공
- [ ] 주요 플로우 테스트

---

## 예상 마이그레이션 효과

| Phase | 대상 | 개수 | 마이그레이션율 변화 |
|-------|------|------|-------------------|
| 완료 | Button | 306 | 0% → 100% ✅ |
| 1 | Loading | ~100 (선별) | 36% → 70% |
| 2 | Toast | ~150 (선별) | 27% → 75% |
| 3 | Card | 6 | 91% → 100% |
| 4 | Dialog | ~30 (선별) | 77% → 90% |
| 5 | Scaffold/AppBar | 점진적 | 유지 |

**최종 목표: 핵심 위젯 85%+ 마이그레이션**
(100%가 아닌 이유: 특수 케이스는 네이티브 유지가 맞음)

---

## 완료 기록

### ✅ Phase 0: Button Migration (2026-01-01)
- TossButton 6가지 variant 구현 완료
- features 폴더 전체 306개 버튼 마이그레이션
- 마이그레이션율: 0% → 100%

### 📊 정확한 분석 완료 (2026-01-01)
- Card 분석 오류 수정: 390개 → 6개 (실제 Flutter Card)
- Feature-specific 위젯 제외 원칙 수립
- 우선순위 재정립: Loading(129) > Toast(210) > Card(6)
