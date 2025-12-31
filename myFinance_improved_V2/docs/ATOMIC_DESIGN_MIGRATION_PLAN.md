# Atomic Design Migration Master Plan

> **형식**: 계획 → 예상 → 실행 → 검증
> **목표**: "toss_" 접두사 제거 + Atomic Design 구조 적용
> **작성일**: 2025-12-31

---

## 🔍 프로젝트 컨텍스트

### 프로젝트 정보
- **프로젝트명**: myFinance (회계/재무 관리 앱)
- **위치**: `myFinance_improved_V2/`
- **기술 스택**: Flutter 3.x, Riverpod, Supabase, Clean Architecture

### Import 현황 (실측)
| 폴더 | Import 횟수 | 비고 |
|------|------------|------|
| `common/` | **302회** | 가장 많이 사용됨 |
| `toss/` | **279회** | 두 번째로 많이 사용됨 |
| `selectors/` | 25회 | 비교적 적음 |

### 가장 많이 사용되는 위젯 TOP 10
| 순위 | 위젯 | 사용 횟수 |
|------|------|----------|
| 1 | `toss_scaffold.dart` | 64회 |
| 2 | `toss_success_error_dialog.dart` | 59회 |
| 3 | `toss_loading_view.dart` | 50회 |
| 4 | `toss_app_bar_1.dart` | 43회 |
| 5 | `toss_primary_button.dart` | 38회 |
| 6 | `toss_dropdown.dart` | 32회 |
| 7 | `toss_button.dart` | 28회 |
| 8 | `toss_text_field.dart` | 18회 |
| 9 | `toss_bottom_sheet.dart` | 18회 |
| 10 | `toss_search_field.dart` | 17회 |

### 현재 폴더별 실제 파일 수
| 폴더 | 실제 파일 | 상태 |
|------|----------|------|
| `toss/` | 31개 | ✅ 실제 위젯 있음 |
| `common/` | 20개 | ✅ 실제 위젯 있음 |
| `selectors/` | 20개 | ✅ 실제 위젯 있음 (하위폴더 포함) |
| `ai/` | 3개 | ✅ 유지 |
| `ai_chat/` | 10개 | ✅ 유지 (미니 피처) |
| `feedback/` | index만 | ⚠️ common에서 re-export |
| `overlays/` | index만 | ⚠️ toss에서 re-export |
| `navigation/` | index만 | ⚠️ 빈 폴더 |
| `calendar/` | index만 | ⚠️ 빈 폴더 |
| `domain/` | index만 | ⚠️ 빈 폴더 |
| `keyboard/` | index만 | ⚠️ 빈 폴더 |

### 현재 Re-export 구조 (복잡함)
```
feedback/dialogs/index.dart → common/toss_*_dialog.dart 를 re-export
overlays/sheets/index.dart  → toss/toss_bottom_sheet.dart 를 re-export
overlays/pickers/index.dart → toss/toss_time_picker.dart 를 re-export
```

**문제**: 같은 파일이 여러 경로로 import 가능 → 혼란 유발

---

## 📊 현재 상태 분석

### 현재 폴더 구조
```
shared/widgets/
├── toss/           # 31개 (실제 위젯 파일)
│   ├── toss_button.dart
│   ├── toss_primary_button.dart
│   ├── toss_secondary_button.dart
│   ├── toss_text_field.dart
│   ├── toss_dropdown.dart
│   ├── toss_card.dart
│   ├── toss_bottom_sheet.dart
│   ├── toss_time_picker.dart
│   ├── toss_month_calendar.dart
│   └── ... (22개 더)
│
├── common/         # 20개 (실제 위젯 파일)
│   ├── toss_scaffold.dart        ← 64회 사용 (1위)
│   ├── toss_success_error_dialog.dart ← 59회 사용 (2위)
│   ├── toss_loading_view.dart    ← 50회 사용 (3위)
│   ├── toss_app_bar_1.dart       ← 43회 사용 (4위)
│   ├── toss_confirm_cancel_dialog.dart
│   ├── toss_info_dialog.dart
│   ├── toss_date_picker.dart
│   └── ... (13개 더)
│
├── selectors/      # 20개 (잘 구조화됨)
│   ├── base/       # 기본 셀렉터 컴포넌트
│   ├── account/    # 계정 선택자
│   ├── cash_location/  # 현금 위치 선택자
│   └── counterparty/   # 거래처 선택자
│
├── ai/             # 3개 (유지)
├── ai_chat/        # 10개 (유지 - 미니 피처)
│
├── feedback/       # ⚠️ Re-export만 (실제 파일 없음)
├── overlays/       # ⚠️ Re-export만 (실제 파일 없음)
├── navigation/     # ⚠️ 빈 폴더
├── calendar/       # ⚠️ 빈 폴더
├── domain/         # ⚠️ 빈 폴더
└── keyboard/       # ⚠️ 빈 폴더
```

### 문제점
1. **"toss_" 접두사 남발**: 51개 파일 중 45개가 toss_ 접두사 사용
2. **Re-export 혼란**: 같은 파일이 2-3개 경로로 접근 가능
3. **빈 폴더 다수**: 6개 폴더가 index.dart만 보유
4. **분류 기준 불명확**: common과 toss 구분이 모호
5. **확장성 부족**: 새 위젯 추가 시 어디에 넣을지 불명확

---

## 🎯 목표 구조 (Atomic Design)

### 새로운 폴더 구조
```
shared/widgets/
├── atoms/                    # 가장 작은 단위 (단독으로 의미 있음)
│   ├── buttons/
│   │   ├── primary_button.dart
│   │   ├── secondary_button.dart
│   │   └── toggle_button.dart
│   ├── inputs/
│   │   ├── text_field.dart
│   │   └── search_field.dart
│   ├── display/
│   │   ├── badge.dart
│   │   ├── chip.dart
│   │   ├── card.dart
│   │   └── avatar.dart
│   ├── feedback/
│   │   ├── loading_view.dart
│   │   ├── empty_view.dart
│   │   ├── error_view.dart
│   │   └── refresh_indicator.dart
│   ├── layout/
│   │   ├── divider.dart
│   │   └── section_header.dart
│   └── index.dart
│
├── molecules/                # Atoms 조합 (2-3개 결합)
│   ├── inputs/
│   │   ├── dropdown.dart
│   │   ├── quantity_stepper.dart
│   │   ├── quantity_input.dart
│   │   └── keyboard_toolbar.dart
│   ├── cards/
│   │   ├── expandable_card.dart
│   │   └── white_card.dart
│   ├── navigation/
│   │   ├── tab_bar.dart
│   │   └── app_bar.dart
│   ├── buttons/
│   │   ├── fab.dart
│   │   └── speed_dial.dart
│   ├── display/
│   │   ├── avatar_stack.dart
│   │   └── category_chip.dart
│   └── index.dart
│
├── organisms/                # 독립적인 기능 단위
│   ├── dialogs/
│   │   ├── confirm_dialog.dart
│   │   ├── info_dialog.dart
│   │   └── result_dialog.dart
│   ├── sheets/
│   │   ├── bottom_sheet.dart
│   │   └── selection_sheet.dart
│   ├── pickers/
│   │   ├── date_picker.dart
│   │   ├── time_picker.dart
│   │   ├── month_picker.dart
│   │   └── date_range_picker.dart
│   ├── menus/
│   │   └── popup_menu.dart
│   ├── selectors/
│   │   ├── base/
│   │   │   ├── selector_config.dart
│   │   │   ├── single_selector.dart
│   │   │   └── multi_selector.dart
│   │   ├── account/
│   │   ├── cash_location/
│   │   └── counterparty/
│   ├── domain/
│   │   ├── shift_card.dart
│   │   └── exchange_calculator.dart
│   └── index.dart
│
├── templates/                # 페이지 레이아웃
│   ├── scaffold.dart
│   └── index.dart
│
├── ai/                       # AI 관련 (유지)
│   └── ...
│
├── ai_chat/                  # AI Chat 미니피처 (유지)
│   └── ...
│
└── index.dart                # Master barrel file
```

---

## 📋 Phase 1: Atoms

### 1.1 계획

| 작업 | 현재 위치 | 새 위치 | 새 이름 |
|------|----------|---------|---------|
| 버튼 | toss/toss_button.dart | atoms/buttons/ | button.dart |
| 버튼 | toss/toss_primary_button.dart | atoms/buttons/ | primary_button.dart |
| 버튼 | toss/toss_secondary_button.dart | atoms/buttons/ | secondary_button.dart |
| 버튼 | toss/toggle_button.dart | atoms/buttons/ | toggle_button.dart |
| 입력 | toss/toss_text_field.dart | atoms/inputs/ | text_field.dart |
| 입력 | toss/toss_search_field.dart | atoms/inputs/ | search_field.dart |
| 입력 | toss/toss_enhanced_text_field.dart | atoms/inputs/ | enhanced_text_field.dart |
| 표시 | toss/toss_badge.dart | atoms/display/ | badge.dart |
| 표시 | toss/toss_chip.dart | atoms/display/ | chip.dart |
| 표시 | toss/toss_card.dart | atoms/display/ | card.dart |
| 표시 | toss/toss_card_safe.dart | atoms/display/ | card_safe.dart |
| 표시 | common/cached_product_image.dart | atoms/display/ | cached_image.dart |
| 표시 | common/employee_profile_avatar.dart | atoms/display/ | profile_avatar.dart |
| 피드백 | common/toss_loading_view.dart | atoms/feedback/ | loading_view.dart |
| 피드백 | common/toss_empty_view.dart | atoms/feedback/ | empty_view.dart |
| 피드백 | common/toss_error_view.dart | atoms/feedback/ | error_view.dart |
| 피드백 | toss/toss_refresh_indicator.dart | atoms/feedback/ | refresh_indicator.dart |
| 레이아웃 | common/gray_divider_space.dart | atoms/layout/ | divider.dart |
| 레이아웃 | common/toss_section_header.dart | atoms/layout/ | section_header.dart |

### 1.2 예상

- **이동 파일 수**: 19개
- **영향받는 import**: ~100개 파일
- **예상 소요 시간**: 2-3시간
- **위험도**: 낮음 (기본 컴포넌트, 의존성 적음)

### 1.3 실행 단계

```
Step 1.3.1: 폴더 구조 생성
├── atoms/buttons/
├── atoms/inputs/
├── atoms/display/
├── atoms/feedback/
└── atoms/layout/

Step 1.3.2: 파일 이동 + 리네이밍
├── git mv로 파일 이동
├── 클래스명은 유지 (TossButton → TossButton)
└── 파일명에서 toss_ 접두사 제거

Step 1.3.3: Barrel file 생성
└── atoms/index.dart

Step 1.3.4: 기존 경로에 Re-export 추가
└── toss/toss_button.dart → export 'atoms/buttons/button.dart'
```

### 1.4 검증

```bash
# 1. 분석 에러 확인
flutter analyze lib

# 2. 빌드 테스트
flutter build apk --debug

# 3. iOS 빌드 (선택)
flutter build ios --debug --no-codesign
```

**체크리스트**:
- [ ] `flutter analyze lib` 에러 0개
- [ ] `flutter build apk --debug` 성공
- [ ] Design Library atoms 탭 정상 작동

---

## 📋 Phase 2: Molecules

### 2.1 계획

| 작업 | 현재 위치 | 새 위치 | 새 이름 |
|------|----------|---------|---------|
| 입력 | toss/toss_dropdown.dart | molecules/inputs/ | dropdown.dart |
| 입력 | toss/toss_quantity_stepper.dart | molecules/inputs/ | quantity_stepper.dart |
| 입력 | toss/toss_quantity_input.dart | molecules/inputs/ | quantity_input.dart |
| 입력 | common/keyboard_toolbar_1.dart | molecules/inputs/ | keyboard_toolbar.dart |
| 입력 | toss/category_chip.dart | molecules/inputs/ | category_chip.dart |
| 카드 | toss/toss_expandable_card.dart | molecules/cards/ | expandable_card.dart |
| 카드 | common/toss_white_card.dart | molecules/cards/ | white_card.dart |
| 네비 | toss/toss_tab_bar_1.dart | molecules/navigation/ | tab_bar.dart |
| 네비 | common/toss_app_bar_1.dart | molecules/navigation/ | app_bar.dart |
| 버튼 | common/toss_fab.dart | molecules/buttons/ | fab.dart |
| 버튼 | common/toss_speed_dial.dart | molecules/buttons/ | speed_dial.dart |
| 표시 | common/avatar_stack_interact.dart | molecules/display/ | avatar_stack.dart |
| 메뉴 | common/safe_popup_menu.dart | molecules/menus/ | popup_menu.dart |

### 2.2 예상

- **이동 파일 수**: 13개
- **영향받는 import**: ~80개 파일
- **예상 소요 시간**: 2-3시간
- **위험도**: 중간 (Atoms 의존)

### 2.3 실행 단계

```
Step 2.3.1: 폴더 구조 생성
├── molecules/inputs/
├── molecules/cards/
├── molecules/navigation/
├── molecules/buttons/
├── molecules/display/
└── molecules/menus/

Step 2.3.2: 파일 이동 + 리네이밍

Step 2.3.3: Barrel file 생성

Step 2.3.4: 기존 경로에 Re-export 추가
```

### 2.4 검증

```bash
flutter analyze lib
flutter build apk --debug
```

**체크리스트**:
- [ ] `flutter analyze lib` 에러 0개
- [ ] `flutter build apk --debug` 성공
- [ ] Design Library molecules 탭 정상 작동

---

## 📋 Phase 3: Organisms

### 3.1 계획

| 작업 | 현재 위치 | 새 위치 | 새 이름 |
|------|----------|---------|---------|
| 다이얼로그 | common/toss_confirm_cancel_dialog.dart | organisms/dialogs/ | confirm_dialog.dart |
| 다이얼로그 | common/toss_info_dialog.dart | organisms/dialogs/ | info_dialog.dart |
| 다이얼로그 | common/toss_success_error_dialog.dart | organisms/dialogs/ | result_dialog.dart |
| 시트 | toss/toss_bottom_sheet.dart | organisms/sheets/ | bottom_sheet.dart |
| 시트 | toss/toss_selection_bottom_sheet.dart | organisms/sheets/ | selection_sheet.dart |
| 피커 | common/toss_date_picker.dart | organisms/pickers/ | date_picker.dart |
| 피커 | toss/toss_time_picker.dart | organisms/pickers/ | time_picker.dart |
| 피커 | toss/toss_month_calendar.dart | organisms/pickers/ | month_picker.dart |
| 피커 | toss/month_dates_picker.dart | organisms/pickers/ | month_dates_picker.dart |
| 피커 | toss/week_dates_picker.dart | organisms/pickers/ | week_dates_picker.dart |
| 피커 | toss/calendar_time_range.dart | organisms/pickers/ | date_range_picker.dart |
| 네비 | toss/toss_month_navigation.dart | organisms/navigation/ | month_navigation.dart |
| 네비 | toss/toss_week_navigation.dart | organisms/navigation/ | week_navigation.dart |
| 도메인 | toss/toss_today_shift_card.dart | organisms/domain/ | today_shift_card.dart |
| 도메인 | toss/toss_week_shift_card.dart | organisms/domain/ | week_shift_card.dart |
| 도메인 | common/exchange_rate_calculator.dart | organisms/domain/ | exchange_calculator.dart |

### 3.2 예상

- **이동 파일 수**: 16개
- **영향받는 import**: ~60개 파일
- **예상 소요 시간**: 2-3시간
- **위험도**: 중간 (Molecules 의존)

### 3.3 실행 단계

```
Step 3.3.1: 폴더 구조 생성
├── organisms/dialogs/
├── organisms/sheets/
├── organisms/pickers/
├── organisms/navigation/
└── organisms/domain/

Step 3.3.2: 파일 이동 + 리네이밍

Step 3.3.3: Barrel file 생성

Step 3.3.4: 기존 경로에 Re-export 추가
```

### 3.4 검증

```bash
flutter analyze lib
flutter build apk --debug
```

**체크리스트**:
- [ ] `flutter analyze lib` 에러 0개
- [ ] `flutter build apk --debug` 성공
- [ ] Design Library organisms 탭 정상 작동

---

## 📋 Phase 4: Selectors 통합

### 4.1 계획

Selectors는 이미 잘 구조화되어 있으므로 organisms/selectors/로 이동만 수행.

```
현재: selectors/
├── base/
├── account/
├── cash_location/
└── counterparty/

이동 후: organisms/selectors/
├── base/
├── account/
├── cash_location/
└── counterparty/
```

### 4.2 예상

- **이동 폴더 수**: 4개
- **영향받는 import**: ~50개 파일
- **예상 소요 시간**: 1시간
- **위험도**: 낮음 (구조 유지)

### 4.3 실행 단계

```
Step 4.3.1: 폴더 이동
git mv lib/shared/widgets/selectors lib/shared/widgets/organisms/selectors

Step 4.3.2: Import 업데이트
sed 스크립트로 일괄 변경

Step 4.3.3: 기존 경로에 Re-export 추가
```

### 4.4 검증

```bash
flutter analyze lib
flutter build apk --debug
```

---

## 📋 Phase 5: Templates

### 5.1 계획

| 현재 위치 | 새 위치 | 새 이름 |
|----------|---------|---------|
| common/toss_scaffold.dart | templates/ | scaffold.dart |

### 5.2 예상

- **이동 파일 수**: 1개
- **영향받는 import**: ~30개 파일
- **예상 소요 시간**: 30분
- **위험도**: 낮음

---

## 📋 Phase 6: Cleanup

### 6.1 계획

1. **빈 폴더 삭제**
   - feedback/ (organisms로 이동됨)
   - overlays/ (organisms로 이동됨)
   - navigation/ (molecules로 이동됨)
   - calendar/ (organisms로 이동됨)
   - domain/ (organisms로 이동됨)
   - keyboard/ (molecules로 이동됨)

2. **레거시 폴더 정리**
   - toss/ (re-export만 남김)
   - common/ (re-export만 남김)

3. **Master index.dart 업데이트**

### 6.2 예상

- **삭제 폴더 수**: 6개
- **예상 소요 시간**: 30분
- **위험도**: 낮음

### 6.3 실행 단계

```
Step 6.3.1: 빈 폴더 삭제
rm -rf lib/shared/widgets/feedback
rm -rf lib/shared/widgets/overlays
...

Step 6.3.2: Master index.dart 업데이트
export 'atoms/index.dart';
export 'molecules/index.dart';
export 'organisms/index.dart';
export 'templates/index.dart';

Step 6.3.3: Design Library 탭 업데이트
```

### 6.4 검증

```bash
flutter analyze lib
flutter build apk --debug
flutter build ios --debug --no-codesign
```

---

## 🛡️ 안전 장치

### Re-export 전략 (호환성 유지)

```dart
// lib/shared/widgets/toss/toss_button.dart (기존 파일)
// 내용 삭제 후 re-export만 남김
export 'package:myfinance_improved/shared/widgets/atoms/buttons/button.dart';
```

이 방식으로:
- ✅ 기존 import 100% 동작
- ✅ 점진적으로 새 import로 전환 가능
- ✅ 6개월 후 re-export 제거

### 롤백 계획

```bash
# 각 Phase 시작 전 태그 생성
git tag -a "pre-atomic-phase-1" -m "Before Atomic Design Phase 1"
git tag -a "pre-atomic-phase-2" -m "Before Atomic Design Phase 2"
...

# 문제 발생 시 롤백
git checkout pre-atomic-phase-X
```

---

## 📈 예상 ROI

### 비용
- 마이그레이션 시간: 8-12시간 (1-2일)
- 테스트 시간: 2-4시간

### 이득
- 신규 개발자 온보딩 50% 단축
- 위젯 검색 시간 3배 감소
- "이 위젯 어디에 추가해야 하지?" 질문 제거
- 디자인 시스템 확장 용이
- 코드 리뷰 효율 향상

---

## 📚 참고 자료

- [Handling Flutter Imports Like a Pro (2025)](https://www.bitsofflutter.dev/handling-flutter-imports-like-a-pro-2025-edition/)
- [Building a Design System with Atomic Design in Flutter](https://medium.com/@hlfdev/building-a-design-system-with-atomic-design-in-flutter-a7a16e28739b)
- [Flutter Design System in Large-Scale Apps](https://leancode.co/blog/building-a-design-system-in-flutter-app)
- [How to Use export in Dart to Seamlessly Migrate Classes](https://widgettricks.substack.com/p/how-to-use-export-in-dart)

---

*문서 작성일: 2025-12-31*
*작성자: Claude Code*
*버전: 2.0 (계획-예상-실행-검증 형식)*
