# Atomic Design 검증 계획서
## 에러 없는 리팩토링을 위한 단계별 검증 전략

> **목표**: 각 단계에서 빌드/테스트 통과를 보장하며 점진적 리팩토링
>
> **원칙**: "작은 변경 → 즉시 검증 → 다음 단계"

---

## 1. 검증 전략 개요

### 1.1 3단계 검증 프로세스

```
┌─────────────────────────────────────────────────────────────────┐
│  Step 1: Static Analysis (정적 분석)                              │
│  - flutter analyze                                               │
│  - dart fix --dry-run                                            │
│  - import 순환 참조 검사                                           │
├─────────────────────────────────────────────────────────────────┤
│  Step 2: Build Verification (빌드 검증)                           │
│  - flutter build apk --debug                                     │
│  - flutter build ios --debug --no-codesign (macOS)              │
├─────────────────────────────────────────────────────────────────┤
│  Step 3: Runtime Verification (런타임 검증)                        │
│  - Design Library 페이지에서 컴포넌트 동작 확인                      │
│  - Hot reload 정상 작동 확인                                       │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 검증 스크립트 준비

```bash
# 프로젝트 루트에 verify.sh 생성
#!/bin/bash
set -e  # 에러 발생 시 즉시 중단

echo "=== Step 1: Static Analysis ==="
flutter analyze
if [ $? -ne 0 ]; then
  echo "❌ Static analysis failed"
  exit 1
fi
echo "✅ Static analysis passed"

echo ""
echo "=== Step 2: Build Verification ==="
flutter build apk --debug
if [ $? -ne 0 ]; then
  echo "❌ Build failed"
  exit 1
fi
echo "✅ Build passed"

echo ""
echo "=== All Verifications Passed ==="
```

---

## 2. Phase 1 검증: Critical Fixes

### 2.1 TossEnhancedTextField 이동 검증

#### Step 1: 백업 생성
```bash
# 원본 백업 (롤백용)
cp lib/shared/widgets/atoms/inputs/toss_enhanced_text_field.dart \
   lib/shared/widgets/atoms/inputs/toss_enhanced_text_field.dart.backup
```

#### Step 2: 새 위치에 파일 생성
```bash
# molecules/inputs/ 폴더 확인
ls lib/shared/widgets/molecules/inputs/

# 새 파일 생성 (기존 파일 복사)
cp lib/shared/widgets/atoms/inputs/toss_enhanced_text_field.dart \
   lib/shared/widgets/molecules/inputs/toss_enhanced_text_field.dart
```

#### Step 3: Import 경로 검색 및 수정 대상 파악
```bash
# 현재 import 사용처 확인 (수정 전 목록화)
grep -r "atoms/inputs/toss_enhanced_text_field" lib --include="*.dart" > /tmp/enhanced_textfield_imports.txt
cat /tmp/enhanced_textfield_imports.txt
```

#### Step 4: 점진적 수정 및 검증
```bash
# 파일 1개씩 수정 후 analyze
# 예: 첫 번째 파일 수정
sed -i '' 's|atoms/inputs/toss_enhanced_text_field|molecules/inputs/toss_enhanced_text_field|g' \
  lib/path/to/first_file.dart

# 즉시 검증
flutter analyze lib/path/to/first_file.dart
```

#### Step 5: 전체 수정 후 빌드 검증
```bash
# 모든 import 수정 후
flutter analyze
flutter build apk --debug
```

#### Step 6: 원본 파일 처리
```bash
# 빌드 성공 확인 후 원본 파일을 re-export로 변경
cat > lib/shared/widgets/atoms/inputs/toss_enhanced_text_field.dart << 'EOF'
/// @deprecated Use molecules/inputs/toss_enhanced_text_field.dart instead
///
/// This file is kept for backward compatibility.
/// New code should import from molecules/inputs/
@Deprecated('Use molecules/inputs/toss_enhanced_text_field.dart instead')
export '../../molecules/inputs/toss_enhanced_text_field.dart';
EOF

# 다시 검증
flutter analyze
flutter build apk --debug
```

#### Rollback 절차 (문제 발생 시)
```bash
# 백업에서 복원
mv lib/shared/widgets/atoms/inputs/toss_enhanced_text_field.dart.backup \
   lib/shared/widgets/atoms/inputs/toss_enhanced_text_field.dart

# 새 파일 삭제
rm lib/shared/widgets/molecules/inputs/toss_enhanced_text_field.dart

# git으로 import 변경 되돌리기
git checkout -- lib/
```

---

### 2.2 TossErrorView 리팩토링 검증

#### Step 1: 현재 사용처 파악
```bash
# TossErrorView 사용 위치 확인
grep -r "TossErrorView" lib --include="*.dart" | grep -v "\.dart:" | head -20

# TossPrimaryButton import 위치 확인 (toss_error_view.dart 내)
grep "TossPrimaryButton" lib/shared/widgets/atoms/feedback/toss_error_view.dart
```

#### Step 2: 테스트 케이스 정의
```dart
/// 검증해야 할 사용 패턴들:

// Pattern 1: 기본 사용 (onRetry만)
TossErrorView(
  error: Exception('Test'),
  onRetry: () => print('retry'),
)

// Pattern 2: 커스텀 제목
TossErrorView(
  error: Exception('Test'),
  title: 'Custom Title',
  onRetry: () => print('retry'),
)

// Pattern 3: 버튼 없이
TossErrorView(
  error: Exception('Test'),
  showRetryButton: false,
)

// Pattern 4: 커스텀 버튼 (새로 추가될 패턴)
TossErrorView(
  error: Exception('Test'),
  actionButton: CustomButton(...),
)
```

#### Step 3: 점진적 리팩토링
```dart
// Phase A: actionButton 파라미터 추가 (기존 동작 유지)
class TossErrorView extends StatelessWidget {
  // 기존 파라미터들...
  final Widget? actionButton;  // NEW

  // build()에서 actionButton 우선 사용
}

// flutter analyze && flutter build apk --debug

// Phase B: TossPrimaryButton import 제거
// _buildDefaultRetryButton()에서 ElevatedButton 직접 사용

// flutter analyze && flutter build apk --debug
```

#### Step 4: 기존 사용처 동작 확인
```bash
# Design Library에서 TossErrorView 데모 확인
# 1. 앱 실행
# 2. Design Library > Feedback 섹션 이동
# 3. TossErrorView 동작 확인
```

---

## 3. Phase 2 검증: Theme Consistency

### 3.1 Colors.black 수정 검증

#### Step 1: 수정 대상 전체 파악
```bash
# Flutter Colors 직접 사용 검색
grep -rn "Colors\." lib/shared/widgets --include="*.dart" | grep -v "TossColors"

# 결과를 파일로 저장
grep -rn "Colors\." lib/shared/widgets --include="*.dart" | grep -v "TossColors" > /tmp/colors_violations.txt
```

#### Step 2: 파일별 수정 및 검증
```bash
# 예: toss_fab.dart 수정
# 수정 전 내용 확인
grep -n "Colors.black" lib/shared/widgets/molecules/buttons/toss_fab.dart

# 수정 후 즉시 검증
flutter analyze lib/shared/widgets/molecules/buttons/toss_fab.dart
```

#### Step 3: 시각적 검증
```
수정 전/후 비교 체크리스트:
□ FAB 확장 시 오버레이 색상 동일한가?
□ 액션 라벨 그림자 동일한가?
□ 애니메이션 부드러운가?
```

### 3.2 Magic Numbers 수정 검증

#### Step 1: Magic Number 검색
```bash
# 숫자 리터럴 검색 (borderRadius, size 등에서)
grep -rn "BorderRadius.circular([0-9]" lib/shared/widgets --include="*.dart"
grep -rn "size: [0-9]" lib/shared/widgets --include="*.dart"
grep -rn "fontSize: [0-9]" lib/shared/widgets --include="*.dart"
```

#### Step 2: 수정 매핑 테이블

| 파일 | 현재 값 | 변경 값 | 검증 방법 |
|------|---------|---------|-----------|
| category_chip.dart:33 | `20` | `TossBorderRadius.xxl` | 시각적 동일성 |
| category_chip.dart:52 | `14` | `TossSpacing.iconXS` (16) | 약간 커짐 허용 |
| category_chip.dart:62 | `12` | `TossTextStyles.caption` | 폰트 스타일 확인 |

#### Step 3: 단위 검증
```bash
# 각 수정 후 analyze
flutter analyze lib/shared/widgets/molecules/inputs/category_chip.dart

# 전체 수정 후 빌드
flutter build apk --debug
```

---

## 4. 자동화 검증 스크립트

### 4.1 Atomic Design 규칙 검증 스크립트

```bash
#!/bin/bash
# verify_atomic_design.sh - Atomic Design 아키텍처 규칙 검증

echo "=== Atomic Design Architecture Verification ==="
echo ""

ERRORS=0

# Rule 1: Atoms should not import other Atoms
echo "Checking Rule 1: Atoms should not import other Atoms..."
ATOM_IMPORTS=$(grep -r "import.*atoms/" lib/shared/widgets/atoms --include="*.dart" | grep -v "index.dart" | grep -v "themes")
if [ -n "$ATOM_IMPORTS" ]; then
  echo "❌ VIOLATION: Atoms importing other Atoms:"
  echo "$ATOM_IMPORTS"
  ERRORS=$((ERRORS + 1))
else
  echo "✅ Passed"
fi
echo ""

# Rule 2: Atoms should not import Molecules
echo "Checking Rule 2: Atoms should not import Molecules..."
ATOM_MOLECULE_IMPORTS=$(grep -r "import.*molecules/" lib/shared/widgets/atoms --include="*.dart")
if [ -n "$ATOM_MOLECULE_IMPORTS" ]; then
  echo "❌ VIOLATION: Atoms importing Molecules:"
  echo "$ATOM_MOLECULE_IMPORTS"
  ERRORS=$((ERRORS + 1))
else
  echo "✅ Passed"
fi
echo ""

# Rule 3: Atoms should not import Organisms
echo "Checking Rule 3: Atoms should not import Organisms..."
ATOM_ORGANISM_IMPORTS=$(grep -r "import.*organisms/" lib/shared/widgets/atoms --include="*.dart")
if [ -n "$ATOM_ORGANISM_IMPORTS" ]; then
  echo "❌ VIOLATION: Atoms importing Organisms:"
  echo "$ATOM_ORGANISM_IMPORTS"
  ERRORS=$((ERRORS + 1))
else
  echo "✅ Passed"
fi
echo ""

# Rule 4: No direct Flutter Colors usage (except TossColors)
echo "Checking Rule 4: No direct Flutter Colors usage..."
COLORS_VIOLATIONS=$(grep -rn "Colors\." lib/shared/widgets --include="*.dart" | grep -v "TossColors" | grep -v "// ignore")
if [ -n "$COLORS_VIOLATIONS" ]; then
  echo "⚠️  WARNING: Direct Colors usage found:"
  echo "$COLORS_VIOLATIONS"
else
  echo "✅ Passed"
fi
echo ""

# Rule 5: No magic numbers in border radius
echo "Checking Rule 5: No hardcoded BorderRadius values..."
BORDER_RADIUS_VIOLATIONS=$(grep -rn "BorderRadius.circular([0-9]" lib/shared/widgets --include="*.dart" | grep -v "TossBorderRadius")
if [ -n "$BORDER_RADIUS_VIOLATIONS" ]; then
  echo "⚠️  WARNING: Hardcoded BorderRadius found:"
  echo "$BORDER_RADIUS_VIOLATIONS"
else
  echo "✅ Passed"
fi
echo ""

# Summary
echo "=== Verification Summary ==="
if [ $ERRORS -gt 0 ]; then
  echo "❌ $ERRORS critical violations found!"
  exit 1
else
  echo "✅ All critical rules passed"
  exit 0
fi
```

### 4.2 사용법

```bash
# 스크립트 실행 권한 부여
chmod +x verify_atomic_design.sh

# 실행
./verify_atomic_design.sh

# CI/CD에서 사용
# .github/workflows/code-quality.yml 에 추가:
# - name: Verify Atomic Design
#   run: ./verify_atomic_design.sh
```

---

## 5. 단계별 체크포인트

### 5.1 Phase 1 완료 체크포인트

```
□ TossEnhancedTextField가 molecules/inputs/에 있는가?
□ atoms/inputs/toss_enhanced_text_field.dart가 re-export로 변경되었는가?
□ TossErrorView에서 TossPrimaryButton import가 제거되었는가?
□ flutter analyze 에러 0개인가?
□ flutter build apk --debug 성공하는가?
□ verify_atomic_design.sh Rule 1-3 통과하는가?
```

### 5.2 Phase 2 완료 체크포인트

```
□ Colors.black 사용이 모두 TossColors로 변경되었는가?
□ CategoryChip magic numbers가 테마 상수로 변경되었는가?
□ flutter analyze 에러 0개인가?
□ flutter build apk --debug 성공하는가?
□ Design Library에서 시각적 변화가 없거나 의도된 변화인가?
```

### 5.3 Phase 3 완료 체크포인트

```
□ TossSpacing에 새 상수가 추가되었는가?
□ TossColors에 overlay 계열이 추가되었는가?
□ 새 상수를 사용하는 컴포넌트가 업데이트되었는가?
□ flutter analyze 에러 0개인가?
□ flutter build apk --debug 성공하는가?
```

### 5.4 Phase 4 완료 체크포인트

```
□ _legacy 폴더가 삭제 가능한 상태인가?
□ 모든 import가 새 경로를 사용하는가?
□ 문서가 완성되었는가?
□ 최종 빌드 성공하는가?
```

---

## 6. 롤백 전략

### 6.1 Git 기반 롤백

```bash
# Phase 시작 전 태그 생성
git tag -a "pre-phase1-refactor" -m "Before Phase 1 refactoring"
git tag -a "pre-phase2-refactor" -m "Before Phase 2 refactoring"

# 문제 발생 시 롤백
git reset --hard pre-phase1-refactor

# 또는 특정 파일만 롤백
git checkout pre-phase1-refactor -- lib/shared/widgets/atoms/
```

### 6.2 Stash 기반 임시 저장

```bash
# 작업 중 변경사항 임시 저장
git stash push -m "Phase 1 in progress"

# 문제 발생 시 복원
git stash pop
```

### 6.3 Branch 기반 격리

```bash
# 각 Phase별 브랜치 생성
git checkout -b refactor/phase1-critical-fixes
git checkout -b refactor/phase2-theme-consistency

# Phase 완료 후 merge
git checkout Jinrefector
git merge refactor/phase1-critical-fixes
```

---

## 7. 검증 일정

| 단계 | 작업 | 검증 | 예상 시간 |
|------|------|------|-----------|
| Phase 1-1 | TossEnhancedTextField 이동 | analyze + build | 30분 |
| Phase 1-2 | TossErrorView 리팩토링 | analyze + build + visual | 30분 |
| Phase 1-3 | Import 정리 | analyze + build | 20분 |
| **Phase 1 검증** | verify_atomic_design.sh | 전체 검증 | 10분 |
| Phase 2-1 | Colors.black 수정 | analyze + build + visual | 20분 |
| Phase 2-2 | Magic numbers 수정 | analyze + build + visual | 30분 |
| **Phase 2 검증** | verify_atomic_design.sh | 전체 검증 | 10분 |
| Phase 3 | Theme 확장 | analyze + build | 30분 |
| Phase 4 | 문서화 & 정리 | 최종 검증 | 30분 |
| **총 예상 시간** | | | **약 3.5시간** |

---

## 8. 결론

### 핵심 검증 원칙

1. **작은 단위로 수정**: 한 번에 하나의 파일/컴포넌트만 수정
2. **즉시 검증**: 수정 직후 `flutter analyze` 실행
3. **빌드 확인**: 파일 그룹 수정 완료 시 `flutter build` 실행
4. **시각적 검증**: UI 변경 시 Design Library에서 확인
5. **롤백 준비**: 항상 이전 상태로 돌아갈 수 있는 방법 확보

### 자동화의 중요성

```bash
# 매 수정 후 실행할 명령어
flutter analyze && flutter build apk --debug && ./verify_atomic_design.sh
```

이 명령이 통과하면 안전하게 다음 단계로 진행할 수 있습니다.

---

**작성일**: 2025-12-31
**버전**: 1.0
**관련 문서**: ATOMIC_DESIGN_REFACTORING_PLAN.md
