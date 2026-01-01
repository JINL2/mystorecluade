# Shared Widget Refactoring Plan
## 2025 Flutter Best Practices 기반 리팩토링 전략

**작성일:** 2026-01-01
**기준:** 2025년 Flutter 업계 표준 + Atomic Design 원칙

---

## 1. 현재 Shared 구조 평가

### 1.1 잘 되어 있는 점

| 항목 | 평가 | 설명 |
|------|------|------|
| **Atomic Design 구조** | EXCELLENT | atoms → molecules → organisms 계층 명확 |
| **Barrel Export** | EXCELLENT | index.dart로 깔끔한 export |
| **Theme 분리** | EXCELLENT | colors, spacing, typography 분리 |
| **Selector 패턴** | EXCELLENT | Autonomous 위젯 (자체 Riverpod 상태관리) |
| **문서화** | GOOD | DESIGNER_MANUAL.md 존재 |
| **Widgetbook 연동** | GOOD | 디자인 시스템 시각화 가능 |

### 1.2 개선이 필요한 점

| 항목 | 현재 상태 | 문제점 |
|------|-----------|--------|
| **도메인 위젯 혼재** | organisms/shift/ | 비즈니스 로직 포함 위젯이 shared에 있음 |
| **Feature 채택률** | 15.3% | 업계 표준(25-30%) 대비 낮음 |
| **중복 위젯** | 144+ | Feature에서 shared 대신 직접 구현 |
| **일부 Legacy 코드** | selectors/ | autonomous_*, enhanced_* deprecated 파일 존재 |

---

## 2. 2025 업계 표준 vs 현재 상태

### Widget 배치 기준 (업계 표준)

```
┌────────────────────────────────────────────────────────────────────┐
│                    Widget 배치 결정 기준                           │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Q1: 비즈니스/도메인 로직이 포함되어 있나?                         │
│      ├─ YES → Feature Widget (절대 Shared 아님)                   │
│      └─ NO  → Q2로                                                │
│                                                                    │
│  Q2: 2개 이상 Feature에서 사용되나?                                │
│      ├─ YES → Shared Widget                                       │
│      └─ NO  → Feature 내부 Widget                                 │
│                                                                    │
│  Q3: 순수 UI 스타일링인가? (데이터 모델 무관)                      │
│      ├─ YES → Shared Atoms/Molecules                              │
│      └─ NO  → Feature Widget 또는 Shared Selector                 │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### 업계 표준 비율

| 영역 | 업계 표준 | 현재 상태 | Gap |
|------|-----------|-----------|-----|
| Shared Widget 사용률 | 25-30% | 15.3% | -10~15% |
| Feature 자체 Widget | 40-50% | 30.3% | 적정 |
| Page Composition | 25-35% | 54.4% | +20% (높음) |

---

## 3. 문제점 상세 분석

### 3.1 organisms/shift/ - 도메인 위젯 문제

**현재 위치:** `shared/widgets/organisms/shift/`
```
├── toss_today_shift_card.dart
└── toss_week_shift_card.dart
```

**문제:**
- `Shift` 도메인 모델에 강하게 결합
- attendance feature 전용 위젯
- shared에 있으면 안 됨

**해결:** → `features/attendance/presentation/widgets/`로 이동

---

### 3.2 Deprecated Selector 파일들

**현재 위치:** `shared/widgets/selectors/`
```
├── autonomous_cash_location_selector.dart  ← deprecated
├── autonomous_counterparty_selector.dart   ← deprecated
├── enhanced_account_selector.dart          ← deprecated
├── toss_base_selector.dart                 ← deprecated
```

**문제:**
- 새 구조(`account/`, `cash_location/`, `counterparty/`)와 중복
- 혼란 유발

**해결:** → deprecated 파일 삭제 (마이그레이션 후)

---

### 3.3 Feature에서 Shared 미사용

**예시 - 중복 구현:**

| Feature 위젯 | 사용해야 할 Shared | 현재 상태 |
|--------------|-------------------|-----------|
| `RevenueCard` | `TossWhiteCard` | Container 직접 사용 |
| `SalaryBreakdownCard` | `TossWhiteCard` | Container 직접 사용 |
| `ReliabilityScoreBottomSheet` | `TossBottomSheet` | 직접 구현 |
| `CreateStoreSheet` | `TossBottomSheet` | 직접 구현 |

---

## 4. 리팩토링 플랜

### Phase 1: Shared 정리 (1-2일)

#### 1.1 도메인 위젯 이동

```bash
# organisms/shift/ → features/attendance/
mv shared/widgets/organisms/shift/toss_today_shift_card.dart \
   features/attendance/presentation/widgets/shift/today_shift_card.dart

mv shared/widgets/organisms/shift/toss_week_shift_card.dart \
   features/attendance/presentation/widgets/shift/week_shift_card.dart
```

**organisms/index.dart 수정:**
```dart
// 삭제:
// export 'shift/toss_today_shift_card.dart';
// export 'shift/toss_week_shift_card.dart';
```

#### 1.2 Deprecated 파일 정리

```bash
# 사용처 확인 후 삭제
rm shared/widgets/selectors/autonomous_cash_location_selector.dart
rm shared/widgets/selectors/autonomous_counterparty_selector.dart
rm shared/widgets/selectors/enhanced_account_selector.dart
rm shared/widgets/selectors/toss_base_selector.dart
```

---

### Phase 2: Feature 채택률 향상 (1-2주)

#### 2.1 Bottom Sheet 마이그레이션

**Before:**
```dart
// features/homepage/presentation/widgets/create_store_sheet.dart
class CreateStoreSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(...),
    );
  }
}
```

**After:**
```dart
// features/homepage/presentation/widgets/create_store_sheet.dart
import 'package:myfinance_improved/shared/widgets/index.dart';

class CreateStoreSheet extends StatelessWidget {
  static Future<void> show(BuildContext context) {
    return TossBottomSheet.show(
      context: context,
      title: 'Create Store',
      builder: (_) => const CreateStoreSheet._(),
    );
  }

  const CreateStoreSheet._();

  @override
  Widget build(BuildContext context) {
    return Column(
      // 비즈니스 로직만 남김
    );
  }
}
```

#### 2.2 Card 마이그레이션

**Before:**
```dart
// features/homepage/presentation/widgets/revenue_card.dart
class RevenueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(...)],
      ),
      child: Column(
        children: [
          // 비즈니스 로직 + UI
        ],
      ),
    );
  }
}
```

**After:**
```dart
// features/homepage/presentation/widgets/revenue_card.dart
import 'package:myfinance_improved/shared/widgets/index.dart';

class RevenueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TossWhiteCard(
      child: Column(
        children: [
          // 비즈니스 로직만 (스타일링은 TossWhiteCard가 담당)
        ],
      ),
    );
  }
}
```

---

### Phase 3: Shared 확장 (필요시)

#### 3.1 누락된 Shared Widget 추가

현재 없지만 필요할 수 있는 위젯:

| 위젯 | 카테고리 | 용도 |
|------|----------|------|
| `TossListTile` | molecules/display | 일관된 리스트 아이템 |
| `TossAvatar` | atoms/display | 다양한 아바타 (현재 employee 전용) |
| `TossIconButton` | atoms/buttons | 아이콘 버튼 표준화 |
| `TossSwitch` | atoms/inputs | 스위치 토글 |

#### 3.2 확장 판단 기준

```
새 Shared Widget 추가 기준:
┌──────────────────────────────────────────────────────────────┐
│ 1. 3개 이상 Feature에서 동일 패턴 발견                        │
│ 2. 도메인 로직 없음 (순수 UI)                                 │
│ 3. 일관된 디자인 시스템 필요                                  │
│ 4. 변경 시 전체 앱에 반영되어야 함                            │
└──────────────────────────────────────────────────────────────┘
```

---

## 5. 마이그레이션 우선순위

### HIGH Priority (즉시 효과)

| 작업 | 영향 파일 | 난이도 | 효과 |
|------|-----------|--------|------|
| Bottom Sheet → TossBottomSheet | 15+ | Low | High |
| Dialog → TossInfoDialog 등 | 21+ | Low | High |
| organisms/shift/ 이동 | 2 | Low | 구조 정리 |

### MEDIUM Priority (일관성)

| 작업 | 영향 파일 | 난이도 | 효과 |
|------|-----------|--------|------|
| Card → TossWhiteCard | 30+ | Medium | Medium |
| Section Header 표준화 | 25+ | Low | Low |
| Deprecated 파일 삭제 | 4 | Low | 정리 |

### LOW Priority (기술 부채)

| 작업 | 영향 파일 | 난이도 | 효과 |
|------|-----------|--------|------|
| Loading/Empty/Error 뷰 통일 | 50+ | High | Low |
| 모든 Container → TossCard | 100+ | High | Low |

---

## 6. 최종 목표 구조

### 6.1 Shared 폴더 (After)

```
lib/shared/
├── themes/                      # 그대로 유지
│   ├── toss_colors.dart
│   ├── toss_text_styles.dart
│   ├── toss_spacing.dart
│   └── ...
│
├── widgets/
│   ├── atoms/                   # 그대로 유지 (16개)
│   │   ├── buttons/
│   │   ├── inputs/
│   │   ├── display/
│   │   ├── feedback/
│   │   └── layout/
│   │
│   ├── molecules/               # 그대로 유지 (15개)
│   │   ├── buttons/
│   │   ├── cards/
│   │   ├── inputs/
│   │   ├── navigation/
│   │   └── keyboard/
│   │
│   ├── organisms/               # shift/ 제거 (11개 → 9개)
│   │   ├── dialogs/
│   │   ├── sheets/
│   │   ├── pickers/
│   │   ├── calendars/
│   │   └── utilities/
│   │   # ❌ shift/ 삭제 (feature로 이동)
│   │
│   ├── templates/               # 그대로 유지
│   │
│   ├── selectors/               # deprecated 정리
│   │   ├── base/
│   │   ├── account/
│   │   ├── cash_location/
│   │   └── counterparty/
│   │   # ❌ autonomous_*, enhanced_*, toss_base_* 삭제
│   │
│   └── ai/                      # 그대로 유지
│       └── ai_chat/
│
└── extensions/                  # 그대로 유지
```

### 6.2 Feature 폴더 (After)

```
lib/features/attendance/presentation/
├── pages/
│   └── attendance_main_page.dart
│
└── widgets/                     # Feature 전용 위젯
    ├── shift/                   # ← shared에서 이동
    │   ├── today_shift_card.dart
    │   └── week_shift_card.dart
    │
    ├── stats/
    │   ├── salary_breakdown_card.dart    # TossWhiteCard 사용
    │   └── reliability_score_sheet.dart  # TossBottomSheet 사용
    │
    └── check_in_out/
        └── ...
```

---

## 7. 체크리스트

### Phase 1 완료 조건
- [ ] organisms/shift/ → features/attendance/ 이동
- [ ] organisms/index.dart에서 shift export 제거
- [ ] deprecated selector 파일 4개 삭제
- [ ] 빌드 에러 없음 확인

### Phase 2 완료 조건
- [ ] 모든 custom bottom sheet가 TossBottomSheet 래핑
- [ ] 모든 confirm dialog가 TossConfirmCancelDialog 사용
- [ ] Feature 채택률 25% 이상

### Phase 3 완료 조건 (선택)
- [ ] 필요시 새 Shared Widget 추가
- [ ] Widgetbook 업데이트
- [ ] DESIGNER_MANUAL.md 업데이트

---

## 8. 핵심 원칙 요약

```
┌─────────────────────────────────────────────────────────────────┐
│                    Shared Widget 배치 원칙                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Shared에 있어야 할 것:                                      │
│     • 순수 UI 컴포넌트 (버튼, 카드, 입력필드)                   │
│     • 2개 이상 Feature에서 사용                                 │
│     • 도메인/비즈니스 로직 없음                                 │
│     • 디자인 시스템 일관성 필요                                 │
│                                                                 │
│  ❌ Shared에 있으면 안 되는 것:                                 │
│     • 특정 도메인 모델에 의존 (Shift, Salary 등)                │
│     • 비즈니스 로직 포함                                        │
│     • 1개 Feature에서만 사용                                    │
│     • 자주 변경되는 요구사항                                    │
│                                                                 │
│  📌 Feature Widget은 Shared를 "사용"해야 함:                    │
│     • SalaryCard가 TossWhiteCard를 사용 (O)                    │
│     • SalaryCard가 Container 직접 사용 (X)                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 9. 예상 효과

| 지표 | Before | After | 개선 |
|------|--------|-------|------|
| Shared 채택률 | 15.3% | 28%+ | +85% |
| 중복 코드 | 144 files | 50 files | -65% |
| 유지보수성 | Medium | High | 향상 |
| 디자인 일관성 | Medium | High | 향상 |
| 빌드 시간 | - | 개선 | const 최적화 |

---

**작성:** Claude (Flutter 30년차 Architect 관점)
**참고:** Flutter Official Docs, LeanCode, Bancolombia Design System
