# Atomic Design Refactoring Plan
## 30년차 Flutter UI 아키텍트 관점 설계서

> **목표**: 확장성(Extensibility)과 통일성(Consistency)을 최우선으로 한 컴포넌트 아키텍처 재설계
>
> **원칙**: "한번 잘 만들면 100번 재사용한다"

---

## 1. 현재 문제 진단

### 1.1 심각도별 문제 분류

| 심각도 | 문제 | 파일 | 영향도 |
|--------|------|------|--------|
| **CRITICAL** | Atom이 Molecule import | `toss_enhanced_text_field.dart` | 아키텍처 붕괴 |
| **CRITICAL** | Atom이 Atom import | `toss_error_view.dart` | 원자성 위반 |
| **HIGH** | `Colors.black` 직접 사용 | `toss_fab.dart` | 테마 일관성 파괴 |
| **MEDIUM** | Magic Numbers | `category_chip.dart` 외 다수 | 유지보수성 저하 |
| **LOW** | 콜백 패턴 불일치 | 여러 컴포넌트 | 개발자 경험 저하 |

### 1.2 Atomic Design 원칙 위반 현황

```
올바른 의존성 방향:
Templates → Organisms → Molecules → Atoms → Flutter Primitives + Themes
                                              ↑
                                         현재 위반 지점
```

**위반 사례:**
- `TossEnhancedTextField` (Atom) → `TossKeyboardToolbar` (Molecule) ❌
- `TossErrorView` (Atom) → `TossPrimaryButton` (Atom) ❌

---

## 2. 콜백 & 데이터 파라미터 설계 원칙

### 2.1 콜백 패턴 분류 (3가지)

#### Pattern A: Simple Action (단순 액션)
```dart
/// 사용 시점: 버튼 클릭, 토글 등 단순 사용자 액션
/// 데이터 전달 불필요할 때
final VoidCallback? onPressed;
final VoidCallback? onRetry;
final VoidCallback? onClose;
```

**적용 컴포넌트**: TossButton, TossFAB, TossErrorView

#### Pattern B: Value Callback (값 전달 콜백)
```dart
/// 사용 시점: 입력값, 선택값 등 데이터를 부모에게 전달할 때
final ValueChanged<String>? onChanged;      // typedef void ValueChanged<T>(T value)
final ValueChanged<bool>? onToggle;
final ValueChanged<DateTime>? onDateSelected;
```

**적용 컴포넌트**: TossTextField, TossDropdown, TossDatePicker

#### Pattern C: Validation Callback (검증 콜백)
```dart
/// 사용 시점: 입력값 검증 후 에러 메시지 반환 필요할 때
final String? Function(String?)? validator;
final bool Function(T)? canSelect;
```

**적용 컴포넌트**: TossEnhancedTextField, Form 관련 컴포넌트

### 2.2 데이터 파라미터 설계 원칙

#### 원칙 1: 필수 vs 선택 명확히 구분
```dart
class TossButton extends StatelessWidget {
  // 필수: 컴포넌트 존재 이유
  final String text;

  // 선택: 커스터마이징 옵션 (기본값 제공)
  final Color? backgroundColor;
  final double? borderRadius;

  const TossButton({
    required this.text,           // 필수
    this.backgroundColor,         // 선택 (테마 기본값 사용)
    this.borderRadius,            // 선택 (테마 기본값 사용)
  });
}
```

#### 원칙 2: 테마 기본값 → 파라미터 오버라이드
```dart
// 좋은 예: 테마 상수를 기본값으로, 필요시 오버라이드
borderRadius: borderRadius ?? TossBorderRadius.button,

// 나쁜 예: 하드코딩된 기본값
borderRadius: borderRadius ?? 8.0,  // ❌ Magic Number
```

#### 원칙 3: Data Class로 복잡한 데이터 캡슐화
```dart
/// 여러 관련 속성을 하나의 객체로 묶음
class TossFABAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;  // 선택적 커스터마이징

  const TossFABAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
  });
}

// 사용
TossFAB.expandable(
  actions: [
    TossFABAction(icon: Icons.add, label: 'Add', onPressed: () {}),
    TossFABAction(icon: Icons.edit, label: 'Edit', onPressed: () {}),
  ],
)
```

### 2.3 콜백 네이밍 컨벤션

| 접두사 | 용도 | 예시 |
|--------|------|------|
| `on` | 이벤트 발생 시점 | `onPressed`, `onChanged`, `onSubmit` |
| `can` | 가능 여부 확인 | `canSelect`, `canDismiss` |
| `should` | 조건부 동작 | `shouldValidate`, `shouldAnimate` |
| `will` | 동작 직전 | `willPop`, `willChange` |
| `did` | 동작 직후 | `didChange`, `didSelect` |

---

## 3. 컴포넌트별 리팩토링 계획

### 3.1 TossEnhancedTextField 리팩토링

#### 현재 문제
```dart
// atoms/inputs/toss_enhanced_text_field.dart
import 'package:myfinance_improved/shared/widgets/molecules/keyboard/toss_keyboard_toolbar.dart';
// ❌ Atom이 Molecule을 import - 아키텍처 위반
```

#### 해결 방안 A: Molecules로 이동 (권장)
```
atoms/inputs/toss_text_field.dart        ← 기본 TextField (Atom 유지)
molecules/inputs/toss_enhanced_text_field.dart  ← 키보드 툴바 포함 (Molecule로 이동)
```

#### 해결 방안 B: 콜백 주입 패턴 (Atom 유지 원할 경우)
```dart
/// Atom은 키보드 툴바를 모름 - 외부에서 주입
class TossEnhancedTextField extends StatelessWidget {
  // 키보드 툴바 대신 콜백 제공
  final VoidCallback? onKeyboardDone;
  final VoidCallback? onKeyboardNext;
  final VoidCallback? onKeyboardPrevious;

  // 툴바 위젯 자체를 외부에서 주입 (선택적)
  final Widget? keyboardToolbar;

  // 또는 Builder 패턴
  final Widget Function(BuildContext, VoidCallback onDone)? toolbarBuilder;
}
```

#### 권장 해결책: **방안 A (Molecules로 이동)**
- 이유: 키보드 툴바와의 통합은 "조합"의 개념 → Molecule의 정의에 부합
- TossTextField (Atom)은 순수하게 유지
- TossEnhancedTextField (Molecule)이 TossTextField + TossKeyboardToolbar 조합

#### 마이그레이션 코드
```dart
// molecules/inputs/toss_enhanced_text_field.dart (새 위치)
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_text_field.dart';
import 'package:myfinance_improved/shared/widgets/molecules/keyboard/toss_keyboard_toolbar.dart';

class TossEnhancedTextField extends StatefulWidget {
  // TossTextField의 모든 파라미터 위임
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  // ...

  // 키보드 툴바 관련 파라미터
  final bool showKeyboardToolbar;
  final String keyboardDoneText;
  final VoidCallback? onKeyboardDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Atom 사용
        TossTextField(
          controller: controller,
          hintText: hintText,
          onChanged: onChanged,
          // ...
        ),
        // Molecule 사용 (조건부)
        if (showKeyboardToolbar && _isKeyboardVisible)
          TossKeyboardToolbar(
            onDone: onKeyboardDone ?? () => FocusScope.of(context).unfocus(),
            doneText: keyboardDoneText,
          ),
      ],
    );
  }
}
```

---

### 3.2 TossErrorView 리팩토링

#### 현재 문제
```dart
// atoms/feedback/toss_error_view.dart
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_primary_button.dart';
// ❌ Atom이 다른 Atom import - 원자성 위반

// 내부에서 직접 사용
TossPrimaryButton(
  text: 'Try Again',
  onPressed: onRetry,
)
```

#### 해결 방안 A: Builder 패턴 (권장)
```dart
class TossErrorView extends StatelessWidget {
  final Object error;
  final String? title;
  final String? message;

  // 액션 버튼을 외부에서 주입
  final Widget? actionButton;

  // 또는 Builder로 유연하게
  final Widget Function(BuildContext context, VoidCallback? onRetry)? actionBuilder;

  // 심플 케이스용 콜백 (actionButton 없을 때 기본 버튼 표시)
  final VoidCallback? onRetry;
  final String retryButtonText;
  final bool showRetryButton;
}
```

#### 해결 방안 B: Molecules로 이동
```
atoms/feedback/toss_error_view.dart      ← 버튼 없는 순수 에러 표시 (Atom)
molecules/feedback/toss_error_with_action.dart  ← 버튼 포함 (Molecule)
```

#### 권장 해결책: **방안 A (Builder 패턴)**
- 이유: 기존 API 호환성 유지하면서 확장성 확보
- `actionButton` 파라미터로 어떤 버튼이든 주입 가능
- 기본 동작은 `onRetry` + `retryButtonText`로 심플하게 유지

#### 리팩토링 코드
```dart
// atoms/feedback/toss_error_view.dart
class TossErrorView extends StatelessWidget {
  final Object error;
  final String title;
  final String? message;

  // 방법 1: 직접 위젯 주입
  final Widget? actionButton;

  // 방법 2: 심플 콜백 (actionButton 없을 때 사용)
  final VoidCallback? onRetry;
  final String retryButtonText;
  final bool showRetryButton;

  const TossErrorView({
    super.key,
    required this.error,
    this.title = 'Something went wrong',
    this.message,
    this.actionButton,
    this.onRetry,
    this.retryButtonText = 'Try Again',
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: TossSpacing.iconXL, color: TossColors.error),
        SizedBox(height: TossSpacing.space5),
        Text(title, style: TossTextStyles.h3),
        SizedBox(height: TossSpacing.space3),
        Text(_getErrorMessage(), style: TossTextStyles.body.copyWith(color: TossColors.gray600)),

        if (showRetryButton && (actionButton != null || onRetry != null)) ...[
          SizedBox(height: TossSpacing.space6),
          // 외부 주입 버튼 우선, 없으면 기본 버튼 (Flutter 기본 위젯 사용)
          actionButton ?? _buildDefaultRetryButton(context),
        ],
      ],
    );
  }

  // Flutter 기본 위젯만 사용 (다른 Atom import 없음)
  Widget _buildDefaultRetryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: TossSpacing.buttonHeightLG,
      child: ElevatedButton(
        onPressed: onRetry,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: TossColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.button),
          ),
        ),
        child: Text(retryButtonText, style: TossTextStyles.button),
      ),
    );
  }
}
```

#### 사용 예시
```dart
// 심플 사용 (기본 버튼)
TossErrorView(
  error: exception,
  onRetry: () => ref.refresh(dataProvider),
)

// 커스텀 버튼 주입
TossErrorView(
  error: exception,
  actionButton: TossPrimaryButton(
    text: 'Go Back',
    onPressed: () => Navigator.pop(context),
  ),
)

// 버튼 없이 에러만 표시
TossErrorView(
  error: exception,
  showRetryButton: false,
)
```

---

### 3.3 TossFAB 테마 적용

#### 현재 문제
```dart
// Line 128
color: Colors.black.withValues(alpha: widget.overlayOpacity)  // ❌

// Line 161
color: Colors.black.withValues(alpha: 0.1)  // ❌
```

#### 리팩토링
```dart
// Line 128 수정
color: TossColors.black.withValues(alpha: widget.overlayOpacity),

// Line 161 수정 - TossShadows 또는 TossColors 사용
color: TossColors.shadow,  // 이미 정의됨: Color(0x0A000000) = 4% opacity
// 또는 더 진한 그림자 필요시
color: TossColors.black.withValues(alpha: 0.1),
```

#### TossColors에 추가 권장
```dart
// toss_colors.dart에 추가
static const Color overlayLight = Color(0x1A000000);  // 10% black
static const Color overlayMedium = Color(0x4D000000); // 30% black
static const Color overlayDark = Color(0x80000000);   // 50% black
```

---

### 3.4 CategoryChip Magic Numbers 제거

#### 현재 문제
```dart
borderRadius: BorderRadius.circular(20),  // Magic Number
size: 14,  // Magic Number (icon)
fontSize: 12,  // Magic Number
```

#### 리팩토링
```dart
// Before
Icon(
  icon,
  size: 14,  // ❌
  color: textColor ?? TossColors.gray700,
)

// After
Icon(
  icon,
  size: TossSpacing.iconXS,  // 16.0 (가장 가까운 값)
  color: textColor ?? TossColors.gray700,
)

// Before
borderRadius: BorderRadius.circular(20),  // ❌

// After
borderRadius: BorderRadius.circular(TossBorderRadius.xxl),  // 20.0

// Before
style: TextStyle(fontSize: 12)  // ❌

// After
style: TossTextStyles.caption,  // 또는 bodySmall
```

#### TossSpacing에 추가 권장
```dart
// 14px 아이콘 사이즈가 자주 필요하다면
static const double iconXXS = 14.0;

// 또는 chip 전용 상수
static const double chipIconSize = 14.0;
static const double chipFontSize = 12.0;
```

---

## 4. 테마 시스템 확장 계획

### 4.1 TossSpacing 확장

```dart
// lib/shared/themes/toss_spacing.dart 추가 사항

class TossSpacing {
  // 기존 값들...

  // === NEW: Component-specific sizes ===

  // Chip 관련
  static const double chipIconSize = 14.0;
  static const double chipHeight = 32.0;
  static const double chipPaddingH = 12.0;
  static const double chipPaddingV = 8.0;

  // Toolbar 관련
  static const double toolbarHeight = 44.0;
  static const double toolbarButtonSize = 32.0;

  // Modal 관련
  static const double modalHandleWidth = 40.0;
  static const double modalHandleHeight = 4.0;
}
```

### 4.2 TossColors 확장

```dart
// lib/shared/themes/toss_colors.dart 추가 사항

class TossColors {
  // 기존 값들...

  // === NEW: Overlay 계열 ===
  static const Color overlayLight = Color(0x1A000000);   // 10%
  static const Color overlayMedium = Color(0x33000000);  // 20%
  static const Color overlayHeavy = Color(0x4D000000);   // 30%

  // === NEW: Interactive states ===
  static const Color primaryPressed = Color(0xFF0052CC);  // Darker primary
  static const Color primaryHover = Color(0xFF1A75FF);    // Lighter primary

  // === NEW: Semantic surface colors ===
  static const Color successSurface = Color(0xFFE6F9F3);  // Light green bg
  static const Color errorSurface = Color(0xFFFEECEB);    // Light red bg
  static const Color warningSurface = Color(0xFFFFF4E5);  // Light orange bg
}
```

### 4.3 TossTextStyles 확장

```dart
// lib/shared/themes/toss_text_styles.dart 확장

class TossTextStyles {
  // 기존 값들...

  // === NEW: Component-specific styles ===

  /// Chip 라벨용 (12px)
  static TextStyle get chipLabel => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Badge 텍스트용 (10px)
  static TextStyle get badge => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  /// 숫자 강조용 (Tabular figures)
  static TextStyle get number => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
```

---

## 5. 컴포넌트 설계 체크리스트

### 5.1 Atom 체크리스트

```
□ Flutter 기본 위젯만 사용하는가?
  - StatelessWidget, StatefulWidget
  - Container, Row, Column, Stack
  - Text, Icon, Image
  - GestureDetector, InkWell
  - AnimatedContainer 등 기본 애니메이션

□ 다른 Atom을 import하지 않는가?
  - ❌ import 'atoms/buttons/toss_button.dart'
  - ✅ import 'package:flutter/material.dart'

□ Molecule/Organism을 import하지 않는가?
  - ❌ import 'molecules/keyboard/...'
  - ❌ import 'organisms/dialogs/...'

□ 테마 시스템만 사용하는가?
  - ✅ TossColors, TossSpacing, TossTextStyles
  - ✅ TossBorderRadius, TossShadows, TossAnimations
  - ❌ Colors.black, hardcoded values

□ 콜백은 단순한가?
  - ✅ VoidCallback? onPressed
  - ✅ ValueChanged<T>? onChanged
  - ❌ 복잡한 비즈니스 로직 콜백
```

### 5.2 Molecule 체크리스트

```
□ Atom을 조합하여 구성하는가?
  - ✅ TossTextField + TossButton 조합
  - ✅ TossCard + TossChip + TossIcon 조합

□ 다른 Molecule을 적절히 사용하는가?
  - ✅ 필요시 다른 Molecule 조합 가능
  - ⚠️ 너무 많은 Molecule 조합 → Organism 고려

□ 테마 시스템을 일관되게 사용하는가?
  - ❌ Colors.black → TossColors.black
  - ❌ 20.0 → TossBorderRadius.xxl

□ 콜백 패턴이 적절한가?
  - ✅ Data class로 관련 데이터 묶음
  - ✅ 일관된 네이밍 (on, can, should)
```

### 5.3 Organism 체크리스트

```
□ Molecule과 Atom을 조합하는가?
  - ✅ Header + Body + Footer 구조
  - ✅ Navigation + Content + Actions

□ 독립적인 UI 섹션으로 기능하는가?
  - ✅ Dialog, BottomSheet, Card Section
  - ✅ Form, List, Calendar

□ 비즈니스 로직과 분리되어 있는가?
  - ❌ Provider/Bloc 직접 의존
  - ✅ 콜백으로 상위에 위임
```

---

## 6. 마이그레이션 실행 계획

### Phase 1: Critical Fixes (1-2일)

| 순서 | 작업 | 파일 | 위험도 |
|------|------|------|--------|
| 1 | TossEnhancedTextField → Molecules 이동 | `atoms/inputs/` → `molecules/inputs/` | 중 |
| 2 | TossErrorView 리팩토링 (Builder 패턴) | `atoms/feedback/toss_error_view.dart` | 저 |
| 3 | Import 경로 전체 업데이트 | 프로젝트 전체 | 중 |
| 4 | 빌드 검증 | - | - |

### Phase 2: Theme Consistency (1일)

| 순서 | 작업 | 파일 |
|------|------|------|
| 1 | TossFAB Colors.black 수정 | `molecules/buttons/toss_fab.dart` |
| 2 | CategoryChip magic numbers 제거 | `molecules/inputs/category_chip.dart` |
| 3 | 전체 Colors. 사용 검색 및 수정 | 프로젝트 전체 |
| 4 | 빌드 검증 | - |

### Phase 3: Theme Extension (1일)

| 순서 | 작업 | 파일 |
|------|------|------|
| 1 | TossSpacing 확장 | `themes/toss_spacing.dart` |
| 2 | TossColors 확장 | `themes/toss_colors.dart` |
| 3 | TossTextStyles 확장 | `themes/toss_text_styles.dart` |
| 4 | 관련 컴포넌트 새 상수 적용 | 해당 컴포넌트들 |

### Phase 4: Documentation & Cleanup (1일)

| 순서 | 작업 |
|------|------|
| 1 | _legacy 폴더 삭제 가능 여부 최종 확인 |
| 2 | 아키텍처 가이드 문서 완성 |
| 3 | 컴포넌트 JSDoc 주석 보강 |
| 4 | 최종 빌드 및 테스트 |

---

## 7. 확장성을 위한 설계 패턴

### 7.1 Variant 패턴 (TossButton 참고)

```dart
/// 동일 컴포넌트의 여러 스타일 변형
enum TossChipVariant { filled, outlined, ghost }

class TossChip extends StatelessWidget {
  final TossChipVariant variant;

  // Factory constructors for common cases
  factory TossChip.filled({required String label}) =>
    TossChip(label: label, variant: TossChipVariant.filled);

  factory TossChip.outlined({required String label}) =>
    TossChip(label: label, variant: TossChipVariant.outlined);
}
```

### 7.2 Composition 패턴

```dart
/// 작은 컴포넌트를 조합하여 큰 컴포넌트 구성
class TossFormField extends StatelessWidget {
  final String label;
  final Widget child;  // 어떤 입력 위젯이든 받음
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TossTextStyles.label),
        SizedBox(height: TossSpacing.space2),
        child,  // TossTextField, TossDropdown, etc.
        if (errorText != null)
          Text(errorText!, style: TossTextStyles.caption.copyWith(color: TossColors.error)),
      ],
    );
  }
}
```

### 7.3 Builder 패턴

```dart
/// 복잡한 커스터마이징이 필요할 때
class TossListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  // Builder for maximum flexibility
  final Widget Function(BuildContext, TossListTileData)? builder;
}
```

### 7.4 Data Class 패턴

```dart
/// 관련 데이터를 하나의 객체로 묶음
@freezed
class TossMenuItem with _$TossMenuItem {
  const factory TossMenuItem({
    required String id,
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    bool? enabled,
    Color? color,
  }) = _TossMenuItem;
}

// 사용
TossMenu(
  items: [
    TossMenuItem(id: 'edit', label: 'Edit', icon: Icons.edit, onTap: onEdit),
    TossMenuItem(id: 'delete', label: 'Delete', icon: Icons.delete, color: TossColors.error),
  ],
)
```

---

## 8. 결론 및 핵심 원칙

### 8.1 Atomic Design 핵심 원칙

1. **Atoms는 절대 다른 Atoms/Molecules를 import하지 않는다**
2. **모든 스타일 값은 Theme 상수를 사용한다**
3. **콜백은 단순하게, 데이터는 명확하게**
4. **확장 가능한 파라미터 설계 (필수/선택 구분)**

### 8.2 개발 시 체크 포인트

```
1. 새 컴포넌트 생성 전:
   □ 이미 존재하는 컴포넌트로 조합 가능한가?
   □ Atom/Molecule/Organism 어디에 속하는가?

2. 컴포넌트 구현 중:
   □ 하드코딩된 값이 있는가? → Theme 상수로 교체
   □ 다른 Atom을 import하는가? → Molecule로 이동 고려

3. 컴포넌트 완료 후:
   □ 체크리스트 통과하는가?
   □ 문서화 완료되었는가?
```

---

**작성일**: 2025-12-31
**버전**: 1.0
**다음 리뷰 예정**: Phase 1 완료 후
