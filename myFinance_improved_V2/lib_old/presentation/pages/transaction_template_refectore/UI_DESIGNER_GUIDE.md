# 🎨 UI/UX Designer Guide - Transaction Template Module

> **목적**: 이 문서는 UI/UX 디자이너가 AI를 활용해 디자인만 수정할 수 있도록 작성되었습니다.
> **중요**: 비즈니스 로직(Domain/Data Layer)은 수정하지 마세요. Presentation Layer만 수정하세요!

---

## 📋 목차

1. [빠른 시작 가이드](#-빠른-시작-가이드)
2. [폴더 구조 개요](#-폴더-구조-개요)
3. [수정 가능한 파일들](#-수정-가능한-파일들)
4. [디자인 시스템](#-디자인-시스템)
5. [화면별 가이드](#-화면별-가이드)
6. [컴포넌트 카탈로그](#-컴포넌트-카탈로그)
7. [AI 프롬프트 예시](#-ai-프롬프트-예시)
8. [금지 사항](#-금지-사항)

---

## 🚀 빠른 시작 가이드

### ✅ 수정해도 되는 것

- ✅ **색상**: `TossColors.*` 값 변경
- ✅ **폰트**: `TossTextStyles.*` 값 변경
- ✅ **간격**: `TossSpacing.*` 값 변경
- ✅ **아이콘**: `Icons.*` 교체
- ✅ **레이아웃**: Widget 배치 순서, `Column`/`Row` 구조
- ✅ **애니메이션**: `Duration`, `Curve` 값 조정
- ✅ **텍스트**: UI 라벨, 버튼 텍스트 (비즈니스 로직 제외)

### ❌ 수정하면 안 되는 것

- ❌ **Provider 로직**: `ref.read()`, `ref.watch()` 호출 코드
- ❌ **UseCase 파일**: `domain/usecases/` 내 모든 파일
- ❌ **Entity 파일**: `domain/entities/` 내 모든 파일
- ❌ **Repository 파일**: `data/repositories/` 내 모든 파일
- ❌ **비즈니스 검증**: `validate()`, `execute()` 같은 비즈니스 메서드

---

## 📁 폴더 구조 개요

```
transaction_template_refectore/
│
├── 🎨 presentation/           ← 🎯 여기만 수정하세요!
│   ├── pages/                 ← 메인 화면들
│   ├── modals/                ← 팝업/바텀시트
│   ├── widgets/               ← 재사용 가능한 UI 컴포넌트
│   ├── providers/             ← 상태 관리 (로직은 건드리지 마세요!)
│   └── dialogs/               ← 작은 알림창
│
├── 🧠 domain/                 ← ❌ 절대 수정 금지! (비즈니스 로직)
│   ├── entities/
│   ├── usecases/
│   ├── validators/
│   └── repositories/
│
└── 💾 data/                   ← ❌ 절대 수정 금지! (데이터베이스)
    ├── repositories/
    ├── dtos/
    └── services/
```

---

## 🎨 수정 가능한 파일들

### 📍 1. 메인 화면 (Pages)

| 파일 경로 | 화면 설명 | 수정 가능 항목 |
|----------|---------|--------------|
| `presentation/pages/transaction_template_page.dart` | 템플릿 목록 메인 화면 | 탭 디자인, 목록 레이아웃, 버튼 위치 |

**주요 UI 요소:**
- **App Bar**: 상단 네비게이션 바
- **Tab Bar**: "내 템플릿" / "관리자 템플릿" 탭
- **Template List**: 템플릿 카드 목록
- **FAB (Floating Action Button)**: 우측 하단 "+" 버튼

**수정 예시:**
```dart
// ✅ GOOD: 색상 변경
AppBar(
  backgroundColor: TossColors.primary,  // 이 값 변경 가능
  title: Text('Transaction Templates'),
)

// ✅ GOOD: 간격 조정
SizedBox(height: TossSpacing.space4),  // space4 → space6으로 변경 가능

// ❌ BAD: Provider 로직 수정
ref.read(templateProvider.notifier).loadTemplates()  // 이건 건드리지 마세요!
```

---

### 📍 2. 팝업/바텀시트 (Modals)

| 파일 경로 | 화면 설명 | 수정 가능 항목 |
|----------|---------|--------------|
| `presentation/modals/add_template_bottom_sheet.dart` | 새 템플릿 생성 팝업 | Wizard 단계 레이아웃, 입력 폼 디자인 |
| `presentation/modals/quick_template_bottom_sheet.dart` | 빠른 거래 생성 팝업 | 금액 입력 UI, 버튼 스타일 |
| `presentation/modals/template_usage_bottom_sheet.dart` | 템플릿 사용 팝업 | 금액/설명 입력 폼 디자인 |
| `presentation/modals/template_filter_sheet.dart` | 필터 선택 팝업 | 필터 칩, 체크박스 디자인 |

**수정 예시 (add_template_bottom_sheet.dart):**
```dart
// ✅ GOOD: 바텀시트 높이 조정
constraints: BoxConstraints(
  maxHeight: MediaQuery.of(context).size.height * 0.9,  // 0.9 → 0.85로 변경 가능
),

// ✅ GOOD: Wizard 단계 인디케이터 색상 변경
StepIndicator(
  currentStep: _currentStep,
  totalSteps: _totalSteps,
  activeColor: TossColors.primary,  // 색상 변경 가능
)

// ❌ BAD: 단계 로직 수정
void _nextStep() {
  if (_currentStep < _totalSteps) {  // 이 조건문은 건드리지 마세요!
    setState(() { _currentStep++; });
  }
}
```

---

### 📍 3. 재사용 컴포넌트 (Widgets)

#### 3-1. Forms (입력 폼 컴포넌트)

| 파일 경로 | 컴포넌트 설명 | 수정 가능 항목 |
|----------|-------------|--------------|
| `widgets/forms/quick_amount_input.dart` | 금액 입력 필드 | 입력창 스타일, 키패드 레이아웃 |
| `widgets/forms/quick_status_indicator.dart` | 상태 표시기 | 색상, 아이콘, 애니메이션 |
| `widgets/forms/complex_template_card.dart` | 복잡한 템플릿 안내 카드 | 카드 디자인, 아이콘 |
| `widgets/forms/collapsible_description.dart` | 접을 수 있는 설명 | 펼침/접힘 애니메이션 |
| `widgets/forms/essential_selectors.dart` | 필수 선택 위젯들 | 선택기 버튼 디자인 |

**수정 예시 (quick_amount_input.dart):**
```dart
// ✅ GOOD: 입력 필드 테두리 스타일 변경
decoration: BoxDecoration(
  border: Border.all(color: TossColors.gray300, width: 1),  // 색상/두께 변경 가능
  borderRadius: BorderRadius.circular(TossBorderRadius.md),  // 둥근 정도 변경 가능
)

// ✅ GOOD: 폰트 크기 변경
Text(
  formattedAmount,
  style: TossTextStyles.displayLarge.copyWith(  // displayLarge → displayMedium 변경 가능
    fontSize: 48,  // 크기 직접 조정 가능
  ),
)
```

#### 3-2. Wizard (단계별 안내 컴포넌트)

| 파일 경로 | 컴포넌트 설명 | 수정 가능 항목 |
|----------|-------------|--------------|
| `widgets/wizard/step_indicator.dart` | 단계 표시기 (1/3, 2/3...) | 점 색상, 크기, 간격 |
| `widgets/wizard/template_basic_info_form.dart` | 기본 정보 입력 폼 | 입력 필드 레이아웃 |
| `widgets/wizard/account_selector_card.dart` | 계정 선택 카드 | 카드 디자인, 선택 표시 |
| `widgets/wizard/permissions_form.dart` | 권한 설정 폼 | 라디오 버튼, 체크박스 디자인 |

**수정 예시 (step_indicator.dart):**
```dart
// ✅ GOOD: 단계 인디케이터 점 크기 변경
Container(
  width: 8,   // 8 → 10으로 키우기
  height: 8,  // 8 → 10으로 키우기
  decoration: BoxDecoration(
    color: isActive ? TossColors.primary : TossColors.gray300,  // 색상 변경 가능
    shape: BoxShape.circle,
  ),
)

// ✅ GOOD: 점 사이 간격 조정
SizedBox(width: TossSpacing.space2),  // space2 → space3으로 변경 가능
```

#### 3-3. Common (공통 컴포넌트)

| 파일 경로 | 컴포넌트 설명 | 수정 가능 항목 |
|----------|-------------|--------------|
| `widgets/common/store_selector.dart` | 매장 선택 드롭다운 | 드롭다운 스타일, 아이콘 |

---

## 🎨 디자인 시스템

### 1. 색상 (Colors)

프로젝트는 **Toss Design System**을 사용하고 있습니다.

**사용 가능한 색상:**
```dart
// Primary Colors (메인 색상)
TossColors.primary        // 파랑 (#3182F6)
TossColors.primaryDark    // 진한 파랑
TossColors.primaryLight   // 연한 파랑

// Gray Scale (회색 톤)
TossColors.gray50         // 매우 연한 회색 (배경)
TossColors.gray100
TossColors.gray200        // 테두리용
TossColors.gray300
TossColors.gray400
TossColors.gray500
TossColors.gray600        // 보조 텍스트
TossColors.gray700        // 일반 텍스트
TossColors.gray800
TossColors.gray900        // 진한 텍스트

// Semantic Colors (의미있는 색상)
TossColors.success        // 성공 (녹색)
TossColors.warning        // 경고 (노랑)
TossColors.error          // 에러 (빨강)
TossColors.info           // 정보 (파랑)

// Utility Colors
TossColors.white          // 흰색
TossColors.black          // 검정
TossColors.transparent    // 투명
```

**색상 수정 예시:**
```dart
// ✅ GOOD: 버튼 배경색 변경
Container(
  color: TossColors.primary,  // primary → success로 녹색 버튼 만들기
)

// ✅ GOOD: 텍스트 색상 변경
Text(
  'Hello',
  style: TextStyle(color: TossColors.gray700),  // gray700 → gray900로 더 진하게
)
```

---

### 2. 타이포그래피 (Text Styles)

**사용 가능한 텍스트 스타일:**
```dart
// Display (큰 제목)
TossTextStyles.displayLarge    // 48px, 굵게 (금액 표시용)
TossTextStyles.displayMedium   // 36px
TossTextStyles.displaySmall    // 28px

// Heading (제목)
TossTextStyles.headingLarge    // 24px (페이지 제목)
TossTextStyles.headingMedium   // 20px (섹션 제목)
TossTextStyles.headingSmall    // 18px (카드 제목)

// Body (본문)
TossTextStyles.bodyLarge       // 16px, 일반 (기본 본문)
TossTextStyles.body            // 14px, 일반 (작은 본문)
TossTextStyles.bodySmall       // 12px (캡션)

// Label (라벨)
TossTextStyles.label           // 14px, 중간 굵기 (버튼 텍스트)
TossTextStyles.labelSmall      // 12px (작은 라벨)
```

**텍스트 스타일 수정 예시:**
```dart
// ✅ GOOD: 제목 크기 변경
Text(
  'Template Name',
  style: TossTextStyles.headingLarge,  // headingLarge → headingMedium으로 작게
)

// ✅ GOOD: 폰트 굵기 조정
Text(
  'Description',
  style: TossTextStyles.body.copyWith(
    fontWeight: FontWeight.w600,  // w600 → w700으로 더 굵게
  ),
)

// ✅ GOOD: 색상 + 크기 동시 변경
Text(
  'Amount',
  style: TossTextStyles.displayLarge.copyWith(
    color: TossColors.primary,
    fontSize: 56,  // 48 → 56으로 키우기
  ),
)
```

---

### 3. 간격 (Spacing)

**사용 가능한 간격 값:**
```dart
TossSpacing.space0_5   // 2px  (매우 좁은 간격)
TossSpacing.space1     // 4px  (좁은 간격)
TossSpacing.space2     // 8px  (작은 간격)
TossSpacing.space3     // 12px (보통 간격)
TossSpacing.space4     // 16px (기본 간격)
TossSpacing.space5     // 20px (넓은 간격)
TossSpacing.space6     // 24px (큰 간격)
TossSpacing.space8     // 32px (매우 큰 간격)
TossSpacing.space10    // 40px (특별히 큰 간격)
TossSpacing.space12    // 48px
TossSpacing.space16    // 64px
```

**간격 수정 예시:**
```dart
// ✅ GOOD: 위젯 사이 세로 간격 조정
Column(
  children: [
    Text('Title'),
    SizedBox(height: TossSpacing.space4),  // space4 → space6으로 넓히기
    Text('Description'),
  ],
)

// ✅ GOOD: 패딩 조정
Padding(
  padding: EdgeInsets.all(TossSpacing.space4),  // space4 → space3으로 좁히기
  child: MyWidget(),
)

// ✅ GOOD: 마진 조정
Container(
  margin: EdgeInsets.symmetric(
    horizontal: TossSpacing.space4,  // 좌우 16px
    vertical: TossSpacing.space2,    // 상하 8px
  ),
)
```

---

### 4. 둥근 모서리 (Border Radius)

**사용 가능한 값:**
```dart
TossBorderRadius.none     // 0px  (직각)
TossBorderRadius.sm       // 4px  (약간 둥글게)
TossBorderRadius.md       // 8px  (보통 둥글게)
TossBorderRadius.lg       // 12px (많이 둥글게)
TossBorderRadius.xl       // 16px (매우 둥글게)
TossBorderRadius.full     // 9999px (완전 원형)
```

**모서리 수정 예시:**
```dart
// ✅ GOOD: 카드 모서리 둥글기 변경
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(TossBorderRadius.md),  // md → lg로 더 둥글게
  ),
)

// ✅ GOOD: 버튼 둥글기 변경
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TossBorderRadius.xl),  // xl → full로 완전 원형
    ),
  ),
)
```

---

### 5. 그림자 (Shadows)

**사용 가능한 그림자:**
```dart
TossShadows.none          // 그림자 없음
TossShadows.sm            // 작은 그림자
TossShadows.md            // 보통 그림자
TossShadows.lg            // 큰 그림자
TossShadows.xl            // 매우 큰 그림자
```

**그림자 수정 예시:**
```dart
// ✅ GOOD: 카드 그림자 조정
Container(
  decoration: BoxDecoration(
    boxShadow: TossShadows.md,  // md → lg로 더 진한 그림자
  ),
)
```

---

## 📱 화면별 가이드

### 🖼️ 1. 메인 화면 (TransactionTemplatePage)

**파일:** `presentation/pages/transaction_template_page.dart`

**화면 구성:**
```
┌─────────────────────────┐
│  ← Transaction Templates│  ← App Bar
├─────────────────────────┤
│ [내 템플릿] [관리자 템플릿] │  ← Tab Bar (권한에 따라 1~2개 탭)
├─────────────────────────┤
│                         │
│  ┌───────────────────┐  │
│  │ Template Card 1   │  │  ← Template List (스크롤 가능)
│  └───────────────────┘  │
│  ┌───────────────────┐  │
│  │ Template Card 2   │  │
│  └───────────────────┘  │
│  ┌───────────────────┐  │
│  │ Template Card 3   │  │
│  └───────────────────┘  │
│                    [+]  │  ← FAB (Floating Action Button)
└─────────────────────────┘
```

**수정 가능한 UI 요소:**

1. **App Bar 색상**
```dart
// 현재 코드 (라인 ~120)
TossAppBar(
  title: 'Transaction Templates',
  backgroundColor: TossColors.white,  // ← 이 색상 변경 가능
)
```

2. **탭 디자인**
```dart
// 현재 코드 (라인 ~180)
TossTabBar(
  controller: _tabController,
  tabs: [
    Tab(text: 'My Templates'),  // ← 텍스트 변경 가능
    if (hasAdminPermission) Tab(text: 'Admin Templates'),
  ],
  indicatorColor: TossColors.primary,  // ← 선택된 탭 밑줄 색상 변경 가능
)
```

3. **템플릿 카드 레이아웃**
```dart
// 현재 코드 (라인 ~250)
Container(
  margin: EdgeInsets.symmetric(
    horizontal: TossSpacing.space4,  // ← 카드 좌우 마진 조정 가능
    vertical: TossSpacing.space2,     // ← 카드 상하 간격 조정 가능
  ),
  padding: EdgeInsets.all(TossSpacing.space4),  // ← 카드 내부 패딩 조정 가능
  decoration: BoxDecoration(
    color: TossColors.white,
    borderRadius: BorderRadius.circular(TossBorderRadius.lg),  // ← 둥글기 조정 가능
    boxShadow: TossShadows.sm,  // ← 그림자 크기 조정 가능
  ),
)
```

4. **FAB 위치/색상**
```dart
// 현재 코드 (라인 ~350)
FloatingActionButton(
  onPressed: _onAddTemplate,
  backgroundColor: TossColors.primary,  // ← 배경색 변경 가능
  child: Icon(Icons.add, color: TossColors.white),  // ← 아이콘 변경 가능
)
```

---

### 🖼️ 2. 템플릿 생성 팝업 (AddTemplateBottomSheet)

**파일:** `presentation/modals/add_template_bottom_sheet.dart`

**화면 구성 (3단계 Wizard):**
```
Step 1: Basic Info        Step 2: Account Selection    Step 3: Permissions
┌───────────────┐        ┌───────────────┐           ┌───────────────┐
│ ● ○ ○         │        │ ● ● ○         │           │ ● ● ●         │
│               │        │               │           │               │
│ Name: [____]  │        │ Debit Account │           │ Visibility    │
│               │        │ [Select...]   │           │ ○ Public      │
│ Desc: [____]  │        │               │           │ ○ Private     │
│               │        │ Credit Account│           │               │
│ [Cancel][Next]│        │ [Select...]   │           │ Permission    │
└───────────────┘        │               │           │ ○ Common      │
                         │ [Back] [Next] │           │ ○ Manager     │
                         └───────────────┘           │               │
                                                     │ [Back][Create]│
                                                     └───────────────┘
```

**수정 가능한 UI 요소:**

1. **바텀시트 높이**
```dart
// 현재 코드 (라인 30)
constraints: BoxConstraints(
  maxHeight: MediaQuery.of(context).size.height * 0.9,  // ← 0.9 → 0.85로 낮추기
)
```

2. **단계 인디케이터 색상**
```dart
// 현재 코드 (라인 ~160)
StepIndicator(
  currentStep: _currentStep,
  totalSteps: _totalSteps,
  activeColor: TossColors.primary,      // ← 활성 단계 색상
  inactiveColor: TossColors.gray300,    // ← 비활성 단계 색상
)
```

3. **입력 필드 스타일**
```dart
// 현재 코드 (라인 ~200)
TextField(
  controller: _nameController,
  decoration: InputDecoration(
    labelText: 'Template Name',       // ← 라벨 텍스트 변경 가능
    hintText: 'Enter template name',  // ← 힌트 텍스트 변경 가능
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(TossBorderRadius.md),  // ← 둥글기 조정
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: TossColors.primary, width: 2),  // ← 포커스 색상
    ),
  ),
)
```

4. **버튼 스타일**
```dart
// 현재 코드 (라인 ~400)
TossPrimaryButton(
  text: 'Create Template',
  onPressed: _onCreateTemplate,
  backgroundColor: TossColors.primary,   // ← 배경색 변경 가능
  textColor: TossColors.white,           // ← 텍스트 색상 변경 가능
  height: 48,                            // ← 버튼 높이 조정 가능
)
```

---

### 🖼️ 3. 빠른 거래 생성 팝업 (QuickTemplateBottomSheet)

**파일:** `presentation/modals/quick_template_bottom_sheet.dart`

**화면 구성:**
```
┌─────────────────────────┐
│ Quick Transaction       │  ← 제목
├─────────────────────────┤
│                         │
│       ₩ 50,000         │  ← 금액 표시 (큰 폰트)
│                         │
│  [1] [2] [3]           │  ← 숫자 키패드
│  [4] [5] [6]           │
│  [7] [8] [9]           │
│  [00][0] [⌫]           │
│                         │
│  Description:           │
│  [__________________]   │  ← 설명 입력
│                         │
│  [Cancel]  [Confirm]    │  ← 버튼
└─────────────────────────┘
```

**수정 가능한 UI 요소:**

1. **금액 표시 폰트**
```dart
// 위치: widgets/forms/quick_amount_input.dart (라인 ~50)
Text(
  formattedAmount,
  style: TossTextStyles.displayLarge.copyWith(
    fontSize: 48,                    // ← 크기 조정 (48 → 56)
    fontWeight: FontWeight.w700,     // ← 굵기 조정
    color: TossColors.primary,       // ← 색상 변경
  ),
)
```

2. **키패드 버튼 크기**
```dart
// 현재 코드 (라인 ~120)
Container(
  width: 80,   // ← 버튼 너비 조정
  height: 60,  // ← 버튼 높이 조정
  decoration: BoxDecoration(
    color: TossColors.gray100,                          // ← 배경색
    borderRadius: BorderRadius.circular(TossBorderRadius.md),  // ← 둥글기
  ),
  child: Center(
    child: Text(
      number,
      style: TossTextStyles.headingLarge.copyWith(
        color: TossColors.gray900,  // ← 숫자 색상
      ),
    ),
  ),
)
```

3. **설명 입력 필드**
```dart
// 현재 코드 (라인 ~200)
TextField(
  decoration: InputDecoration(
    hintText: 'Optional description',  // ← 힌트 텍스트 변경
    filled: true,
    fillColor: TossColors.gray50,      // ← 배경색 변경
  ),
)
```

---

### 🖼️ 4. 필터 선택 팝업 (TemplateFilterSheet)

**파일:** `presentation/modals/template_filter_sheet.dart`

**화면 구성:**
```
┌─────────────────────────┐
│ Filter Templates        │  ← 제목
├─────────────────────────┤
│                         │
│ Visibility:             │
│  [All] [Public] [Private] │  ← 칩 버튼
│                         │
│ Status:                 │
│  [All] [Active] [Inactive]│
│                         │
│ ☐ My Templates Only     │  ← 체크박스
│                         │
│  [Clear]  [Apply]       │  ← 버튼
└─────────────────────────┘
```

**수정 가능한 UI 요소:**

1. **칩 버튼 스타일**
```dart
// 현재 코드 (라인 ~80)
ChoiceChip(
  label: Text('All'),
  selected: isSelected,
  selectedColor: TossColors.primary,      // ← 선택된 칩 배경색
  backgroundColor: TossColors.gray100,    // ← 일반 칩 배경색
  labelStyle: TextStyle(
    color: isSelected ? TossColors.white : TossColors.gray700,  // ← 텍스트 색상
  ),
)
```

2. **체크박스 스타일**
```dart
// 현재 코드 (라인 ~150)
CheckboxListTile(
  title: Text('My Templates Only'),
  value: showMyTemplatesOnly,
  activeColor: TossColors.primary,  // ← 체크박스 색상
)
```

---

## 📦 컴포넌트 카탈로그

### 1. StepIndicator (단계 표시기)

**파일:** `widgets/wizard/step_indicator.dart`

**모양:**
```
● ● ○ ○ ○
```

**사용법:**
```dart
StepIndicator(
  currentStep: 2,        // 현재 단계 (1부터 시작)
  totalSteps: 5,         // 총 단계 수
  activeColor: TossColors.primary,    // 활성 점 색상
  inactiveColor: TossColors.gray300,  // 비활성 점 색상
  dotSize: 8.0,          // 점 크기
  spacing: 8.0,          // 점 사이 간격
)
```

---

### 2. ComplexTemplateCard (복잡한 템플릿 안내)

**파일:** `widgets/forms/complex_template_card.dart`

**모양:**
```
┌─────────────────────────┐
│ ⚙️  Complex Template    │
│                         │
│ This template requires  │
│ detailed setup...       │
│                         │
│ [Open Detailed Setup →] │
└─────────────────────────┘
```

**사용법:**
```dart
ComplexTemplateCard(
  title: 'Complex Template',              // 제목 (변경 가능)
  description: 'This template requires...', // 설명 (변경 가능)
  buttonText: 'Open Detailed Setup',      // 버튼 텍스트 (변경 가능)
  onOpenDetailed: () {
    // 버튼 클릭 시 동작 (비즈니스 로직이므로 건드리지 마세요!)
  },
)
```

**수정 가능 항목:**
```dart
// 파일 내부 (라인 32)
Container(
  padding: EdgeInsets.all(TossSpacing.space4),  // ← 내부 패딩 조정
  decoration: BoxDecoration(
    color: TossColors.gray50,                    // ← 배경색 변경
    borderRadius: BorderRadius.circular(TossBorderRadius.md),  // ← 둥글기
    border: Border.all(color: TossColors.gray200),  // ← 테두리 색상
  ),
)
```

---

### 3. CollapsibleDescription (접을 수 있는 설명)

**파일:** `widgets/forms/collapsible_description.dart`

**모양:**
```
Description ▼
─────────────────
This is a long description
that can be collapsed...
```

**사용법:**
```dart
CollapsibleDescription(
  title: 'Description',        // 제목
  description: 'Long text...',  // 내용
  maxLines: 3,                 // 접혔을 때 최대 줄 수
  expandIcon: Icons.expand_more,   // 펼치기 아이콘
  collapseIcon: Icons.expand_less, // 접기 아이콘
)
```

---

### 4. AccountSelectorCard (계정 선택 카드)

**파일:** `widgets/wizard/account_selector_card.dart`

**모양:**
```
┌─────────────────────────┐
│ Debit Account           │  ← 라벨
│ ┌─────────────────────┐ │
│ │ Cash                │ │  ← 선택된 계정
│ └─────────────────────┘ │
│ [Select Account]        │  ← 버튼
└─────────────────────────┘
```

**수정 가능 항목:**
```dart
// 파일 내부 (라인 ~50)
Container(
  padding: EdgeInsets.all(TossSpacing.space3),  // ← 패딩 조정
  decoration: BoxDecoration(
    border: Border.all(
      color: isSelected ? TossColors.primary : TossColors.gray300,  // ← 테두리 색상
      width: isSelected ? 2 : 1,  // ← 테두리 두께
    ),
    borderRadius: BorderRadius.circular(TossBorderRadius.md),
  ),
)
```

---

## 🤖 AI 프롬프트 예시

디자이너가 AI(Claude/GPT)에게 요청할 때 사용할 수 있는 프롬프트 예시입니다.

### 예시 1: 색상 변경

```
📋 프롬프트:
"transaction_template_refectore/presentation/pages/transaction_template_page.dart 파일에서
App Bar의 배경색을 TossColors.primary로 변경하고,
템플릿 카드의 그림자를 TossShadows.lg로 변경해줘.
비즈니스 로직은 건드리지 말고 UI 스타일만 수정해."

✅ 예상 결과:
- App Bar 배경이 파란색으로 변경
- 카드 그림자가 더 진해짐
- Provider/UseCase 코드는 그대로 유지
```

---

### 예시 2: 레이아웃 간격 조정

```
📋 프롬프트:
"transaction_template_refectore/presentation/modals/add_template_bottom_sheet.dart에서
Step Indicator와 입력 폼 사이의 간격을 TossSpacing.space6으로 넓혀주고,
Next/Back 버튼 사이의 간격을 TossSpacing.space3으로 좁혀줘.
상태 관리 코드는 건드리지 마."

✅ 예상 결과:
- 단계 표시기와 폼 사이 간격이 24px로 증가
- 버튼 사이 간격이 12px로 감소
- setState, ref.read 같은 로직은 그대로
```

---

### 예시 3: 폰트 크기 변경

```
📋 프롬프트:
"transaction_template_refectore/presentation/widgets/forms/quick_amount_input.dart에서
금액 표시 폰트를 TossTextStyles.displayLarge에서 fontSize 56으로 키우고,
색상을 TossColors.success로 변경해줘.
숫자 입력 로직은 건드리지 마."

✅ 예상 결과:
- 금액이 56px 크기로 커짐
- 금액 색상이 녹색으로 변경
- onAmountChanged 같은 콜백은 그대로
```

---

### 예시 4: 버튼 스타일 변경

```
📋 프롬프트:
"transaction_template_refectore/presentation/modals/template_filter_sheet.dart에서
Apply 버튼의 배경색을 TossColors.success로 변경하고,
높이를 56px로 키워줘.
Clear 버튼은 TossSecondaryButton 스타일 그대로 유지하고,
필터 로직은 건드리지 마."

✅ 예상 결과:
- Apply 버튼이 녹색 배경에 56px 높이
- Clear 버튼은 변화 없음
- onApply 콜백은 그대로
```

---

### 예시 5: 애니메이션 속도 조정

```
📋 프롬프트:
"transaction_template_refectore/presentation/widgets/forms/collapsible_description.dart에서
펼침/접힘 애니메이션의 Duration을 300ms에서 500ms로 느리게 변경하고,
Curve를 Curves.easeInOut에서 Curves.elasticOut으로 바꿔줘.
텍스트 내용이나 onTap 로직은 건드리지 마."

✅ 예상 결과:
- 애니메이션이 더 천천히 부드럽게 재생
- 약간 튕기는 효과 추가
- 확장/축소 로직은 그대로
```

---

## 🚫 금지 사항

### ❌ 절대 수정하면 안 되는 코드

#### 1. Provider 관련 코드

```dart
// ❌ BAD: Provider 로직 수정 금지!
final templates = ref.watch(templateProvider);  // 이 줄 건드리지 마세요
ref.read(templateProvider.notifier).loadTemplates();  // 이 줄도 건드리지 마세요

// ✅ GOOD: 주변 UI만 수정
Container(
  color: TossColors.primary,  // ← 이런 UI 속성만 변경하세요
  child: ref.watch(templateProvider).when(
    loading: () => LoadingWidget(),  // ← 로딩 위젯 디자인만 변경
    error: (e, s) => ErrorWidget(e),
    data: (templates) => ListView(...),
  ),
)
```

#### 2. UseCase 실행 코드

```dart
// ❌ BAD: UseCase 로직 수정 금지!
final result = await ref.read(createTemplateUseCaseProvider).execute(command);
if (result.isSuccess) {
  // 이 조건문 건드리지 마세요!
}

// ✅ GOOD: 성공/실패 시 보여줄 UI만 수정
if (result.isSuccess) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Success'),  // ← 텍스트만 변경
      backgroundColor: TossColors.success,  // ← 색상만 변경
    ),
  );
}
```

#### 3. Entity/Repository 파일

```dart
// ❌ BAD: 이 파일들은 아예 열지도 마세요!
domain/entities/template_entity.dart        // Entity 정의
domain/usecases/create_template_usecase.dart  // 비즈니스 로직
domain/repositories/template_repository.dart  // 인터페이스
data/repositories/supabase_template_repository.dart  // DB 통신

// ✅ GOOD: Presentation Layer만 수정
presentation/pages/transaction_template_page.dart  // 메인 화면
presentation/modals/add_template_bottom_sheet.dart  // 팝업
presentation/widgets/forms/quick_amount_input.dart  // 입력 위젯
```

#### 4. 검증 로직

```dart
// ❌ BAD: 검증 로직 수정 금지!
if (template.name.isEmpty) {  // 이 조건 건드리지 마세요
  return 'Name is required';
}

// ✅ GOOD: 에러 메시지 표시 UI만 수정
if (errorMessage != null) {
  Text(
    errorMessage,
    style: TextStyle(color: TossColors.error),  // ← 색상만 변경
  )
}
```

---

### ✅ 안전한 수정 체크리스트

디자인 수정 전에 이 체크리스트를 확인하세요:

- [ ] `presentation/` 폴더 내의 파일만 수정하나요?
- [ ] `ref.read()` 또는 `ref.watch()` 코드는 건드리지 않았나요?
- [ ] `async/await` 함수 로직은 수정하지 않았나요?
- [ ] `if` 조건문의 조건식은 그대로 두었나요?
- [ ] `TossColors.*`, `TossTextStyles.*` 같은 디자인 토큰만 변경했나요?
- [ ] 버튼의 `onPressed` 콜백 로직은 건드리지 않았나요?
- [ ] Widget의 레이아웃(Column/Row/Stack)만 조정했나요?

**모두 ✅라면 안전하게 수정할 수 있습니다!**

---

## 📞 도움이 필요할 때

### 🆘 문제 해결 가이드

#### 문제 1: 색상이 적용되지 않아요
```
✅ 해결책:
1. TossColors.* 값을 정확히 입력했는지 확인
2. copyWith()를 사용해서 스타일을 덮어쓰고 있는지 확인
3. 부모 위젯의 Theme이 자식 위젯 색상을 덮어쓰고 있는지 확인
```

#### 문제 2: 간격이 변경되지 않아요
```
✅ 해결책:
1. SizedBox 또는 Padding을 사용했는지 확인
2. TossSpacing.* 값이 정확한지 확인
3. Flex(Expanded/Flexible)가 간격을 무시하고 있는지 확인
```

#### 문제 3: 에러가 발생해요
```
✅ 해결책:
1. 에러 메시지를 AI에게 복사해서 물어보기
2. 최근 변경 사항 되돌리기 (Git revert)
3. Domain/Data Layer 파일을 수정했다면 즉시 되돌리기!
```

---

## 🎓 학습 자료

### Flutter UI 기본 개념

1. **Widget Tree**: Flutter는 위젯을 트리 구조로 배치합니다
2. **Stateless vs Stateful**: 상태가 없는 위젯 vs 상태가 있는 위젯
3. **Build Method**: UI를 그리는 메서드 (여기만 수정하세요!)

### 참고 링크

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Material Design Guidelines](https://material.io/design)
- [Toss Design System](https://toss.im/design)

---

## 📝 변경 이력 템플릿

디자인 수정 후 이 템플릿을 사용해서 기록하세요:

```markdown
## 변경 이력

### [2025-10-13] 메인 화면 색상 변경

**변경 파일:**
- presentation/pages/transaction_template_page.dart

**변경 내용:**
1. App Bar 배경색: TossColors.white → TossColors.primary
2. 템플릿 카드 그림자: TossShadows.sm → TossShadows.lg
3. FAB 색상: TossColors.primary → TossColors.success

**스크린샷:**
[Before] [After]

**비즈니스 로직 영향:** 없음 ✅
```

---

## ✨ 마지막 팁

1. **작은 변경부터 시작하세요**: 색상 하나부터 바꿔보고, 잘 되면 다음으로 넘어가세요
2. **자주 테스트하세요**: 매번 변경 후 앱을 실행해서 확인하세요
3. **Git을 활용하세요**: 변경 전 커밋해두면 되돌리기 쉽습니다
4. **AI에게 물어보세요**: 확신이 없으면 AI에게 "이 코드 수정해도 돼?"라고 물어보세요

---

**행운을 빕니다! 🎉**

이 가이드를 따라하면 안전하게 디자인을 수정할 수 있습니다.
궁금한 점이 있으면 AI에게 이 문서를 참고하라고 알려주세요!
