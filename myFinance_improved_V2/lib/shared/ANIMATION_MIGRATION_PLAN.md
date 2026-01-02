# TossAnimations 마이그레이션 계획서

> **목표**: shared 위젯에서 TossAnimations 시스템을 100% 활용하여 앱 전체에 일관된 애니메이션 자동 적용
> **현재 상태**: 17% 활용 (6/36 인스턴스)
> **목표 상태**: 95%+ 활용

---

## 1. 현황 분석

### 1.1 문제점

```
┌─────────────────────────────────────────────────────────────┐
│  TossAnimations 시스템은 잘 정의됨                           │
│  BUT 실제 위젯에서 거의 사용하지 않음                         │
│                                                             │
│  Duration(milliseconds: 200)  ← 36개 하드코딩               │
│  TossAnimations.normal        ← 6개만 사용                  │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 영향도

| 항목 | 현재 | 목표 |
|------|------|------|
| TossAnimations 직접 사용 | 6개 | 36개+ |
| 하드코딩 Duration | 36개 | 0개 |
| 애니메이션 없는 인터랙티브 위젯 | 20개+ | 5개 이하 |
| 전체 일관성 | 17% | 95% |

---

## 2. TossAnimations 시스템 요약

### 2.1 Duration 상수 (언제 사용?)

```dart
// lib/shared/themes/toss_animations.dart

TossAnimations.instant  // 50ms  - 터치 피드백 즉시 반응
TossAnimations.quick    // 100ms - 체크박스, 아주 빠른 토글
TossAnimations.fast     // 150ms - 버튼, 칩 선택, 섹션 펼치기 ⭐
TossAnimations.normal   // 200ms - 카드 상태변화, 일반 전환 ⭐
TossAnimations.medium   // 250ms - 탭/페이지 전환, 바텀시트 ⭐
TossAnimations.slow     // 300ms - 복잡한 다중 요소 전환
TossAnimations.slower   // 400ms - 온보딩, 대규모 레이아웃
```

### 2.2 Curve 상수 (어떻게 움직여?)

```dart
TossAnimations.standard   // easeInOutCubic - 기본 (대부분)
TossAnimations.enter      // easeOutCubic   - 화면 진입
TossAnimations.exit       // easeInCubic    - 화면 퇴장
TossAnimations.decelerate // easeOut        - 부드러운 감속
TossAnimations.emphasis   // fastOutSlowIn  - 강조
```

### 2.3 헬퍼 위젯/메서드

```dart
// 펼치기/접기 아이콘 회전 (90도)
TossAnimations.expandIcon(isExpanded: bool, child: Widget)

// 펼치기/접기 콘텐츠
TossAnimations.expandContent(isExpanded: bool, child: Widget)

// 선택 칩 (자동 색상 전환)
TossAnimations.selectionChip(label: String, isSelected: bool, onTap: VoidCallback)

// 탭 인디케이터 데코레이션
TossAnimations.tabIndicatorDecoration()
```

---

## 3. 마이그레이션 대상 (우선순위별)

### Phase 1: Core Widgets (높은 사용 빈도)

| 파일 | 현재 | 변경 | 이유 |
|------|------|------|------|
| `atoms/buttons/toggle_button.dart` | `Duration(ms: 200)` | `TossAnimations.normal` | 토글 선택 |
| `atoms/buttons/toss_button.dart` | 일부 하드코딩 | 완전 통일 | 버튼 프레스 |
| `molecules/cards/toss_expandable_card.dart` | `Duration(ms: 200)` | `TossAnimations.fast` | 펼치기는 150ms가 적합 |
| `molecules/buttons/toss_fab.dart` | `Duration(ms: 200)` | `TossAnimations.normal` | FAB 확장 |

### Phase 2: Display & Feedback

| 파일 | 현재 | 변경 | 이유 |
|------|------|------|------|
| `atoms/feedback/toss_skeleton.dart` | `Duration(ms: 1200)` | 새 상수 정의 | 로딩 특화 |
| `atoms/display/cached_product_image.dart` | `Duration(ms: 150)` | `TossAnimations.fast` | fade-in |
| `molecules/menus/safe_popup_menu.dart` | `Duration(ms: 50)` | `TossAnimations.instant` | 즉시 반응 |

### Phase 3: Keyboard & Modal

| 파일 | 현재 | 변경 | 이유 |
|------|------|------|------|
| `molecules/keyboard/toss_textfield_keyboard_modal.dart` | 하드코딩 | `TossAnimations.medium` | 모달 전환 |
| `molecules/keyboard/toss_currency_exchange_modal.dart` | 하드코딩 | `TossAnimations.medium` | 모달 전환 |
| `molecules/keyboard/modal_keyboard_patterns.dart` | 하드코딩 | `TossAnimations.medium` | 모달 전환 |

### Phase 4: 애니메이션 추가 (터치 피드백 개선)

| 파일 | 현재 | 추가할 애니메이션 |
|------|------|-----------------|
| `atoms/display/toss_chip.dart` | 없음 | 선택 시 배경색 전환 |
| `molecules/inputs/category_chip.dart` | 없음 | 선택 시 스케일 + 색상 |
| `molecules/cards/toss_selection_card.dart` | 없음 | 선택 시 테두리/그림자 |
| `atoms/inputs/toss_text_field.dart` | 없음 | 포커스 시 테두리 색상 전환 |

---

## 4. 신규 상수 추가 (toss_animations.dart)

```dart
// ==================== 추가할 상수 ====================

/// 로딩 펄스 애니메이션 (스켈레톤용)
static const Duration loadingPulse = Duration(milliseconds: 1200);

/// 로딩 스피너 한 바퀴 (원형 인디케이터)
static const Duration loadingRotation = Duration(milliseconds: 1500);

/// 디바운스 딜레이 (검색 입력)
static const Duration debounceDelay = Duration(milliseconds: 300);

/// 스낵바/토스트 표시 시간
static const Duration toastDuration = Duration(seconds: 3);
```

---

## 5. 마이그레이션 코드 패턴

### 5.1 Before → After 예시

```dart
// ❌ BEFORE: 하드코딩
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  curve: Curves.easeInOut,
  ...
)

// ✅ AFTER: TossAnimations
AnimatedContainer(
  duration: TossAnimations.normal,
  curve: TossAnimations.standard,
  ...
)
```

### 5.2 펼치기/접기 섹션

```dart
// ❌ BEFORE: 수동 구현
AnimatedRotation(
  turns: _isExpanded ? 0.25 : 0,
  duration: const Duration(milliseconds: 200),
  child: Icon(Icons.chevron_right),
)

// ✅ AFTER: 헬퍼 사용
TossAnimations.expandIcon(
  isExpanded: _isExpanded,
  child: Icon(Icons.chevron_right),
)
```

### 5.3 선택 칩

```dart
// ❌ BEFORE: 수동 AnimatedContainer
AnimatedContainer(
  duration: const Duration(milliseconds: 150),
  decoration: BoxDecoration(
    color: isSelected ? Colors.black : Colors.grey[200],
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(label),
)

// ✅ AFTER: 헬퍼 사용
TossAnimations.selectionChip(
  label: label,
  isSelected: isSelected,
  onTap: () => onSelect(),
)
```

---

## 6. 검증 체크리스트

### 6.1 마이그레이션 완료 검증

```bash
# 하드코딩 Duration 검색 (0이 되어야 함)
grep -r "Duration(milliseconds:" lib/shared/widgets/ | wc -l

# TossAnimations 사용 검색 (증가해야 함)
grep -r "TossAnimations\." lib/shared/widgets/ | wc -l
```

### 6.2 시각적 검증 항목

- [ ] 버튼 누름 → 즉각적 피드백 (100ms 이하 반응)
- [ ] 카드 선택 → 부드러운 전환 (200ms)
- [ ] 섹션 펼치기 → 빠른 확장 (150ms)
- [ ] 탭 전환 → 자연스러운 슬라이드 (250ms)
- [ ] 바텀시트 → 스무스한 등장 (250ms)
- [ ] 로딩 스켈레톤 → 일정한 펄스 (1200ms)

---

## 7. 예상 효과

### 7.1 사용자 경험

| 항목 | Before | After |
|------|--------|-------|
| 버튼 반응 | 제각각 (100~300ms) | 일관됨 (100ms) |
| 전환 느낌 | 뚝뚝 끊김 | 물 흐르듯 |
| 전체 리듬감 | 혼란스러움 | 예측 가능 |

### 7.2 개발자 경험

| 항목 | Before | After |
|------|--------|-------|
| 새 위젯 개발 | "몇 ms로 할까?" | `TossAnimations.fast` |
| 애니메이션 수정 | 50개 파일 수정 | 상수 1개 수정 |
| 코드 리뷰 | "왜 200ms?" | "TossAnimations.normal은 표준" |

### 7.3 유지보수

```
Before: "앱이 느려요" → 어디가 느린지 모름
After:  TossAnimations.normal = 250ms로 변경 → 전체 반영
```

---

## 8. 실행 계획

### Week 1: Phase 1 (Core)
- [ ] toggle_button.dart
- [ ] toss_button.dart 완전 정리
- [ ] toss_expandable_card.dart
- [ ] toss_fab.dart
- [ ] 빌드 검증

### Week 2: Phase 2 + 3 (Display & Modal)
- [ ] toss_skeleton.dart + 새 상수 추가
- [ ] cached_product_image.dart
- [ ] safe_popup_menu.dart
- [ ] keyboard 모달 파일들 (3개)
- [ ] 빌드 검증

### Week 3: Phase 4 (Enhancement)
- [ ] toss_chip.dart 애니메이션 추가
- [ ] category_chip.dart 애니메이션 추가
- [ ] toss_selection_card.dart 애니메이션 추가
- [ ] toss_text_field.dart 포커스 애니메이션
- [ ] 전체 시각적 검증

---

## 9. 자동화 교체 패턴

```
# 정규식 기반 일괄 교체

Duration(milliseconds: 50)   → TossAnimations.instant
Duration(milliseconds: 100)  → TossAnimations.quick
Duration(milliseconds: 150)  → TossAnimations.fast
Duration(milliseconds: 200)  → TossAnimations.normal
Duration(milliseconds: 250)  → TossAnimations.medium
Duration(milliseconds: 300)  → TossAnimations.slow
Duration(milliseconds: 400)  → TossAnimations.slower

Curves.easeInOut    → TossAnimations.standard
Curves.easeOut      → TossAnimations.decelerate
Curves.easeIn       → TossAnimations.accelerate
Curves.easeOutCubic → TossAnimations.enter
```

---

## 10. 결론

**핵심 메시지**: shared 위젯에 TossAnimations를 적용하면, 해당 위젯을 사용하는 **모든 화면에 자동으로 일관된 애니메이션**이 적용됩니다.

**ROI**:
- 투자: 약 20개 파일 수정
- 효과: 600+ 화면에 일관된 애니메이션 자동 적용

---

*작성일: 2026-01-01*
*Flutter 3.x / Dart 3.x 기준*
