# Widgetbook 도입 계획서

## 개요

**목표**: 모든 Atoms/Molecules 위젯을 카탈로그화하여 독립적으로 테스트 및 확인 가능하게 함

**예상 소요 시간**: 2-3시간

---

## 현재 위젯 현황

### Atoms (15개)
| 카테고리 | 위젯명 | 상태 |
|---------|--------|------|
| **Buttons** | TossButton | 등록 예정 |
| | TossPrimaryButton | 등록 예정 |
| | TossSecondaryButton | 등록 예정 |
| | ToggleButton | 등록 예정 |
| **Display** | TossCard | 등록 예정 |
| | TossCardSafe | 등록 예정 |
| | TossChip | 등록 예정 |
| | TossBadge | 등록 예정 |
| | CachedProductImage | 등록 예정 |
| | EmployeeProfileAvatar | 등록 예정 |
| **Feedback** | TossErrorView | 등록 예정 |
| | TossEmptyView | 등록 예정 |
| | TossLoadingView | 등록 예정 |
| | TossRefreshIndicator | 등록 예정 |
| **Inputs** | TossTextField | 등록 예정 |
| | TossSearchField | 등록 예정 |
| **Layout** | TossSectionHeader | 등록 예정 |
| | GrayDividerSpace | 등록 예정 |

### Molecules (15개)
| 카테고리 | 위젯명 | 상태 |
|---------|--------|------|
| **Buttons** | TossFAB | 등록 예정 |
| | TossSpeedDial | 등록 예정 |
| **Cards** | TossWhiteCard | 등록 예정 |
| | TossExpandableCard | 등록 예정 |
| **Display** | AvatarStackInteract | 등록 예정 |
| **Inputs** | TossDropdown | 등록 예정 |
| | TossEnhancedTextField | 등록 예정 |
| | TossQuantityInput | 등록 예정 |
| | TossQuantityStepper | 등록 예정 |
| | CategoryChip | 등록 예정 |
| **Keyboard** | TossKeyboardToolbar | 등록 예정 |
| | TossCurrencyExchangeModal | 등록 예정 |
| | TossTextFieldKeyboardModal | 등록 예정 |
| **Navigation** | TossAppBar1 | 등록 예정 |
| | TossTabBar1 | 등록 예정 |

---

## 폴더 구조 (생성 예정)

```
lib/
├── widgetbook/
│   ├── main.dart                    # Widgetbook 앱 진입점
│   ├── widgetbook.dart              # 메인 설정
│   └── use_cases/
│       ├── atoms/
│       │   ├── buttons/
│       │   │   ├── toss_button_use_case.dart
│       │   │   ├── toss_primary_button_use_case.dart
│       │   │   └── toggle_button_use_case.dart
│       │   ├── display/
│       │   │   ├── toss_card_use_case.dart
│       │   │   ├── toss_chip_use_case.dart
│       │   │   └── toss_badge_use_case.dart
│       │   ├── feedback/
│       │   │   ├── toss_error_view_use_case.dart
│       │   │   ├── toss_empty_view_use_case.dart
│       │   │   └── toss_loading_view_use_case.dart
│       │   └── inputs/
│       │       ├── toss_text_field_use_case.dart
│       │       └── toss_search_field_use_case.dart
│       └── molecules/
│           ├── buttons/
│           │   └── toss_fab_use_case.dart
│           ├── cards/
│           │   └── toss_expandable_card_use_case.dart
│           └── inputs/
│               └── toss_dropdown_use_case.dart
```

---

## 작업 단계

### Phase 1: 환경 설정 (내가 할 일)
- [x] 계획서 작성
- [ ] pubspec.yaml에 widgetbook 패키지 추가
- [ ] lib/widgetbook/ 폴더 구조 생성
- [ ] main.dart 및 widgetbook.dart 기본 설정

### Phase 2: Atoms 등록 (내가 할 일)
- [ ] Buttons 카테고리 등록 (TossButton, TossPrimaryButton 등)
- [ ] Display 카테고리 등록 (TossCard, TossChip, TossBadge)
- [ ] Feedback 카테고리 등록 (TossErrorView, TossEmptyView, TossLoadingView)
- [ ] Inputs 카테고리 등록 (TossTextField, TossSearchField)

### Phase 3: Molecules 등록 (내가 할 일)
- [ ] Buttons 카테고리 등록 (TossFAB)
- [ ] Cards 카테고리 등록 (TossExpandableCard)
- [ ] Inputs 카테고리 등록 (TossDropdown, TossQuantityInput)
- [ ] Navigation 카테고리 등록 (TossAppBar1, TossTabBar1)

### Phase 4: 테스트 및 실행 (사용자와 함께)
- [ ] Widgetbook 앱 실행 테스트
- [ ] 모든 위젯 미리보기 확인
- [ ] Knobs 기능 동작 확인

---

## 사용자가 할 수 있는 것

### 1. 실행 방법
```bash
# Widgetbook 앱 실행 (일반 앱과 별도)
cd myFinance_improved_V2
flutter run -t lib/widgetbook/main.dart

# 또는 웹으로 실행 (브라우저에서 확인)
flutter run -t lib/widgetbook/main.dart -d chrome
```

### 2. 사용 방법
- 좌측 패널에서 위젯 선택
- 우측 Knobs 패널에서 속성 변경
- Device 선택으로 다양한 화면 크기 테스트
- Theme 토글로 테마 변경 확인 (다크모드 추가 시)

### 3. 새 위젯 추가 시
```dart
// lib/widgetbook/use_cases/atoms/buttons/my_new_button_use_case.dart
WidgetbookUseCase(
  name: 'MyNewButton',
  builder: (context) => MyNewButton(
    text: context.knobs.string(label: 'Text', initialValue: '버튼'),
    onPressed: () {},
  ),
)
```

---

## 예상 결과

### Before (현재)
- 위젯 확인하려면 앱 전체 실행 필요
- 특정 상태(disabled, loading) 보려면 코드 수정 필요
- 디자이너에게 보여주려면 빌드 후 기기 전달 필요

### After (Widgetbook 도입 후)
- 위젯만 독립적으로 즉시 확인
- Knobs로 모든 상태 실시간 전환
- 브라우저 링크로 디자이너에게 공유

---

## 다음 단계

계획 승인 후 바로 구현 시작 가능합니다.

**예상 파일 생성**: 약 15-20개 파일
**예상 코드 라인**: 약 500-700줄
**예상 시간**: 2-3시간
