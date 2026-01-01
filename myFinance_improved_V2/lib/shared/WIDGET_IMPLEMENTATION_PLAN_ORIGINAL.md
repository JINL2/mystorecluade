# Widget Implementation Plan (Original - 2025 Industry Standards)
## 30년차 Flutter Architect의 2025 산업 표준 기반 분석

**작성일:** 2026-01-01
**목적:** 2025 Flutter 업계 표준과의 비교 및 Gap 분석
**상태:** 참고용 (실제 구현은 WIDGET_IMPLEMENTATION_PLAN.md 참조)

---

## 📊 2025 산업 표준 분석

> 이 문서는 2025년 Flutter 업계의 Atomic Design 표준을 기준으로
> 현재 프로젝트의 Gap을 분석한 원본 계획입니다.
>
> 실제 구현은 ROI 분석 기반으로 수정된 `WIDGET_IMPLEMENTATION_PLAN.md`를 참조하세요.

---

## 1️⃣ Atoms 레벨 - 2025 산업 표준 비교

### 📋 현재 보유 현황 (14개)

| 카테고리 | 위젯명 | 상태 |
|----------|--------|------|
| buttons/ | `TossButton` | ✅ |
| buttons/ | `ToggleButton` | ✅ |
| inputs/ | `TossTextField` | ✅ |
| inputs/ | `TossSearchField` | ✅ |
| display/ | `TossBadge` | ✅ |
| display/ | `TossChip` | ✅ |
| display/ | `InfoRow` | ✅ |
| display/ | `CachedProductImage` | ✅ |
| display/ | `EmployeeProfileAvatar` | ✅ |
| feedback/ | `TossLoadingView` | ✅ |
| feedback/ | `TossEmptyView` | ✅ |
| feedback/ | `TossErrorView` | ✅ |
| feedback/ | `TossRefreshIndicator` | ✅ |
| layout/ | `GrayDividerSpace` | ✅ |
| layout/ | `TossSectionHeader` | ✅ |

### 🎯 2025 산업 표준 필수 Atoms (24개)

| 카테고리 | 위젯명 | 현재 상태 | 우선순위 |
|----------|--------|:--------:|:--------:|
| **buttons/** | TossButton | ✅ 보유 | - |
| buttons/ | TossIconButton | ❌ 미보유 | 🔴 HIGH |
| buttons/ | TossToggleButton | ✅ 보유 | - |
| **inputs/** | TossTextField | ✅ 보유 | - |
| inputs/ | TossSearchField | ✅ 보유 | - |
| inputs/ | TossSwitch | ❌ 미보유 | 🟡 MED |
| inputs/ | TossCheckbox | ❌ 미보유 | 🟡 MED |
| inputs/ | TossRadio | ❌ 미보유 | 🟢 LOW |
| inputs/ | TossSlider | ❌ 미보유 | 🟢 LOW |
| **display/** | TossBadge | ✅ 보유 | - |
| display/ | TossChip | ✅ 보유 | - |
| display/ | TossAvatar | ⚠️ 이름변경 필요 | 🟡 MED |
| display/ | TossIcon | ❌ 미보유 | 🟡 MED |
| display/ | TossDivider | ⚠️ gray_divider 존재 | 🟢 LOW |
| display/ | TossSpacer | ❌ 미보유 | 🟢 LOW |
| display/ | TossImage | ✅ 보유 (CachedProductImage) | - |
| display/ | TossInfoRow | ✅ 보유 | - |
| **feedback/** | TossLoadingView | ✅ 보유 | - |
| feedback/ | TossEmptyView | ✅ 보유 | - |
| feedback/ | TossErrorView | ✅ 보유 | - |
| feedback/ | TossSkeleton | ❌ 미보유 | 🟡 MED |
| feedback/ | TossSnackbar | ❌ 미보유 | 🟡 MED |
| **layout/** | TossSectionHeader | ✅ 보유 | - |
| layout/ | GrayDividerSpace | ✅ 보유 | - |

### 📊 Atoms 커버리지

```
현재: 14개 / 24개 = 58%
목표: 24개 / 24개 = 100%
Gap: 10개 위젯 추가 필요
```

---

## 2️⃣ Molecules 레벨 - 2025 산업 표준 비교

### 📋 현재 보유 현황 (18개)

| 카테고리 | 위젯명 | 상태 |
|----------|--------|------|
| buttons/ | `TossSpeedDial` | ✅ |
| cards/ | `TossCard` | ✅ |
| cards/ | `TossExpandableCard` | ✅ |
| cards/ | `TossWhiteCard` | ✅ |
| display/ | `AvatarStackInteract` | ✅ |
| display/ | `InfoCard` | ✅ |
| display/ | `IconInfoRow` | ✅ |
| inputs/ | `TossDropdown` | ✅ |
| inputs/ | `TossQuantityStepper` | ✅ |
| inputs/ | `TossQuantityInput` | ✅ |
| inputs/ | `TossEnhancedTextField` | ✅ |
| inputs/ | `CategoryChip` | ✅ |
| inputs/ | `KeyboardToolbar` | ✅ |
| menus/ | `SafePopupMenu` | ✅ |
| navigation/ | `TossTabBar` | ✅ |
| navigation/ | `TossAppBar` | ✅ |
| keyboard/ | `TossCurrencyExchangeModal` | ✅ |
| keyboard/ | `TossTextFieldKeyboardModal` | ✅ |

### 🎯 2025 산업 표준 필수 Molecules (26개)

| 카테고리 | 위젯명 | 현재 상태 | 우선순위 |
|----------|--------|:--------:|:--------:|
| **buttons/** | TossSpeedDial | ✅ 보유 | - |
| buttons/ | TossFloatingAction | ❌ 미보유 | 🟢 LOW |
| **cards/** | TossCard | ✅ 보유 | - |
| cards/ | TossExpandableCard | ✅ 보유 | - |
| cards/ | TossWhiteCard | ✅ 보유 | - |
| cards/ | TossInfoCard | ⚠️ InfoCard 존재 | 🟡 MED |
| **display/** | AvatarStackInteract | ✅ 보유 | - |
| display/ | IconInfoRow | ✅ 보유 | - |
| display/ | TossUserCard | ❌ 미보유 | 🟡 MED |
| display/ | TossRatingBar | ❌ 미보유 | 🟢 LOW |
| **inputs/** | TossDropdown | ✅ 보유 | - |
| inputs/ | TossQuantityStepper | ✅ 보유 | - |
| inputs/ | TossQuantityInput | ✅ 보유 | - |
| inputs/ | TossEnhancedTextField | ✅ 보유 | - |
| inputs/ | TossSearchBar | ❌ 미보유 (SearchField는 Atom) | 🟡 MED |
| inputs/ | TossRangeSlider | ❌ 미보유 | 🟢 LOW |
| **menus/** | SafePopupMenu | ✅ 보유 | - |
| menus/ | TossContextMenu | ❌ 미보유 | 🟢 LOW |
| **navigation/** | TossTabBar | ✅ 보유 | - |
| navigation/ | TossAppBar | ✅ 보유 | - |
| navigation/ | TossBottomNav | ❌ 미보유 | 🟡 MED |
| navigation/ | TossBreadcrumb | ❌ 미보유 | 🟢 LOW |
| **keyboard/** | TossCurrencyExchangeModal | ✅ 보유 | - |
| keyboard/ | TossTextFieldKeyboardModal | ✅ 보유 | - |
| keyboard/ | TossKeyboardToolbar | ✅ 보유 | - |
| **lists/** | TossListTile | ❌ 미보유 | 🔴 HIGH |

### 📊 Molecules 커버리지

```
현재: 18개 / 26개 = 69%
목표: 26개 / 26개 = 100%
Gap: 8개 위젯 추가 필요
```

---

## 3️⃣ 원본 구현 계획

### Phase 1: 필수 Atoms 추가 (10개)

| 위젯 | 카테고리 | 설명 | 예상 코드량 |
|------|----------|------|:----------:|
| `TossIconButton` | buttons/ | 아이콘 버튼 통합 | ~80줄 |
| `TossSwitch` | inputs/ | 토글 스위치 | ~60줄 |
| `TossCheckbox` | inputs/ | 체크박스 | ~50줄 |
| `TossRadio` | inputs/ | 라디오 버튼 | ~50줄 |
| `TossSlider` | inputs/ | 슬라이더 | ~70줄 |
| `TossAvatar` | display/ | 아바타 (리네이밍) | ~20줄 |
| `TossIcon` | display/ | 아이콘 래퍼 | ~40줄 |
| `TossDivider` | display/ | 구분선 | ~30줄 |
| `TossSpacer` | display/ | 간격 | ~25줄 |
| `TossSkeleton` | feedback/ | 스켈레톤 로딩 | ~100줄 |

### Phase 2: 필수 Molecules 추가 (8개)

| 위젯 | 카테고리 | 설명 | 예상 코드량 |
|------|----------|------|:----------:|
| `TossFloatingAction` | buttons/ | FAB 버튼 | ~60줄 |
| `TossInfoCard` | cards/ | 정보 카드 | ~80줄 |
| `TossUserCard` | display/ | 사용자 카드 | ~100줄 |
| `TossRatingBar` | display/ | 평점 바 | ~90줄 |
| `TossSearchBar` | inputs/ | 검색 바 (Molecule) | ~120줄 |
| `TossContextMenu` | menus/ | 컨텍스트 메뉴 | ~80줄 |
| `TossBottomNav` | navigation/ | 하단 네비게이션 | ~100줄 |
| `TossListTile` | lists/ | 리스트 타일 | ~90줄 |

### Phase 3: Widgetbook 카탈로그 추가

각 위젯별 use case 파일 작성:
- `atoms_directory.dart` 업데이트
- `molecules_directory.dart` 업데이트
- 다크모드 테스트 케이스 추가

---

## 4️⃣ 예상 작업량

| Phase | 위젯 수 | 예상 코드량 | 예상 시간 |
|:-----:|:------:|:----------:|:--------:|
| 1 | 10개 | ~525줄 | 1주 |
| 2 | 8개 | ~720줄 | 1주 |
| 3 | - | ~400줄 | 3일 |
| **합계** | **18개** | **~1,645줄** | **2.5주** |

---

## 5️⃣ 최종 목표 구조

```
shared/widgets/
├── atoms/
│   ├── buttons/
│   │   ├── toss_button.dart        ✅ 기존
│   │   ├── toss_icon_button.dart   🆕 NEW
│   │   └── toggle_button.dart      ✅ 기존
│   ├── inputs/
│   │   ├── toss_text_field.dart    ✅ 기존
│   │   ├── toss_search_field.dart  ✅ 기존
│   │   ├── toss_switch.dart        🆕 NEW
│   │   ├── toss_checkbox.dart      🆕 NEW
│   │   ├── toss_radio.dart         🆕 NEW
│   │   └── toss_slider.dart        🆕 NEW
│   ├── display/
│   │   ├── toss_badge.dart         ✅ 기존
│   │   ├── toss_chip.dart          ✅ 기존
│   │   ├── toss_avatar.dart        🔄 리네이밍
│   │   ├── toss_icon.dart          🆕 NEW
│   │   ├── toss_divider.dart       🆕 NEW
│   │   ├── toss_spacer.dart        🆕 NEW
│   │   └── info_row.dart           ✅ 기존
│   ├── feedback/
│   │   ├── toss_loading_view.dart  ✅ 기존
│   │   ├── toss_empty_view.dart    ✅ 기존
│   │   ├── toss_error_view.dart    ✅ 기존
│   │   ├── toss_skeleton.dart      🆕 NEW
│   │   └── toss_refresh_indicator.dart ✅ 기존
│   └── layout/
│       ├── gray_divider_space.dart ✅ 기존
│       └── toss_section_header.dart ✅ 기존
│
└── molecules/
    ├── buttons/
    │   ├── toss_speed_dial.dart    ✅ 기존
    │   └── toss_floating_action.dart 🆕 NEW
    ├── cards/
    │   ├── toss_card.dart          ✅ 기존
    │   ├── toss_expandable_card.dart ✅ 기존
    │   ├── toss_white_card.dart    ✅ 기존
    │   └── toss_info_card.dart     🆕 NEW
    ├── display/
    │   ├── avatar_stack_interact.dart ✅ 기존
    │   ├── icon_info_row.dart      ✅ 기존
    │   ├── toss_user_card.dart     🆕 NEW
    │   └── toss_rating_bar.dart    🆕 NEW
    ├── inputs/
    │   ├── toss_dropdown.dart      ✅ 기존
    │   ├── toss_quantity_stepper.dart ✅ 기존
    │   ├── toss_search_bar.dart    🆕 NEW
    │   └── ...기존 유지
    ├── menus/
    │   ├── safe_popup_menu.dart    ✅ 기존
    │   └── toss_context_menu.dart  🆕 NEW
    ├── navigation/
    │   ├── toss_tab_bar.dart       ✅ 기존
    │   ├── toss_app_bar.dart       ✅ 기존
    │   └── toss_bottom_nav.dart    🆕 NEW
    ├── lists/
    │   └── toss_list_tile.dart     🆕 NEW
    └── keyboard/
        └── ...기존 유지
```

---

## ⚠️ 중요: 이 계획은 수정되었습니다

이 문서는 **2025 산업 표준 기반의 원본 분석**입니다.

**실제 구현은 ROI 분석 기반으로 수정된 계획을 따릅니다:**

📄 **`WIDGET_IMPLEMENTATION_PLAN.md`** 참조

### 수정된 계획 요약:

| 항목 | 원본 계획 | 수정된 계획 |
|------|:--------:|:----------:|
| 새 위젯 개수 | 18개 | 4개 |
| 예상 작업 시간 | 2.5주 | 1-2일 |
| 접근 방식 | 산업 표준 충족 | ROI 기반 |

### 핵심 수정 사항:

1. **Theme First** - IconButton, Switch, Checkbox 등은 ThemeData로 해결
2. **ROI 기반** - 10회 미만 사용 패턴은 위젯화하지 않음
3. **실사용 데이터** - grep 분석 결과 기반 우선순위 결정

---

**작성:** Claude (30년차 Flutter Architect)
**목적:** 2025 산업 표준 참고 및 비교 분석용
