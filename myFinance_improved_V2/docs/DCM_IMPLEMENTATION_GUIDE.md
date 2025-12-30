# DCM (Dart Code Metrics) 구현 가이드

> 신규 직원용 코드 품질 분석 도구 설정 및 사용 가이드

## 📋 목차

1. [DCM 소개](#1-dcm-소개)
2. [설치 방법](#2-설치-방법)
3. [기본 명령어](#3-기본-명령어)
4. [실행 및 결과 해석](#4-실행-및-결과-해석)
5. [프로젝트 적용 체크리스트](#5-프로젝트-적용-체크리스트)
6. [CI/CD 통합 (선택사항)](#6-cicd-통합-선택사항)

---

## 1. DCM 소개

### DCM이란?
DCM(Dart Code Metrics)은 Dart/Flutter 코드의 품질을 분석하는 정적 분석 도구입니다.

### 주요 기능
| 기능 | 설명 | 우리 프로젝트 활용 |
|------|------|-------------------|
| `check-unused-code` | 사용되지 않는 코드 탐지 | deprecated 클래스 정리 |
| `check-unused-files` | 사용되지 않는 파일 탐지 | 불필요한 파일 삭제 |
| `analyze-widgets` | 위젯 사용 패턴 분석 | shared widget 활용도 측정 |
| `check-dependencies` | 의존성 순환 참조 탐지 | 레이어 분리 검증 |

### 왜 필요한가?
- **2,397개 파일** 규모의 프로젝트에서 수동 검토 불가능
- deprecated 코드 자동 탐지
- 리팩토링 후 검증 자동화

---

## 2. 설치 방법

### 방법 A: 전역 설치 (권장)

```bash
# Homebrew로 설치 (macOS)
brew tap nicklockwood/formulae
brew install dcm

# 또는 dart pub으로 설치
dart pub global activate dart_code_metrics
```

### 방법 B: 프로젝트 의존성으로 설치

```yaml
# pubspec.yaml
dev_dependencies:
  dart_code_metrics: ^5.7.0
```

### 설치 확인

```bash
dcm --version
# 출력 예: dcm version 1.x.x
```

---

## 3. 기본 명령어

### 3.1 사용되지 않는 코드 찾기

```bash
# 프로젝트 루트에서 실행
cd myFinance_improved_V2

# 전체 lib 폴더 분석
dcm check-unused-code lib

# 특정 폴더만 분석
dcm check-unused-code lib/shared/widgets
```

### 3.2 사용되지 않는 파일 찾기

```bash
# 사용되지 않는 파일 탐지
dcm check-unused-files lib

# JSON 형식으로 출력 (자동화용)
dcm check-unused-files lib --reporter=json > unused_files.json
```

### 3.3 위젯 분석

```bash
# 위젯 사용 패턴 분석
dcm analyze-widgets lib

# 특정 폴더의 위젯만 분석
dcm analyze-widgets lib/shared/widgets
```

### 3.4 의존성 순환 참조 확인

```bash
# 순환 의존성 탐지
dcm check-dependencies lib
```

---

## 4. 실행 및 결과 해석

### 4.1 check-unused-code 결과 예시

```
lib/shared/widgets/selectors/enhanced_account_selector.dart:
  ⚠ Unused class 'EnhancedAccountSelector'
    This class is never used in the analyzed code.
    Consider removing it or using @Deprecated annotation.
```

**해석:**
- `EnhancedAccountSelector` 클래스가 사용되지 않음
- **조치:** 이미 `@Deprecated` 처리됨 → 향후 삭제 예정 확인

### 4.2 check-unused-files 결과 예시

```
Unused files:
  lib/shared/themes/debug_theme_switcher.dart
  lib/shared/utils/old_helper.dart
```

**해석:**
- 해당 파일들이 어디서도 import되지 않음
- **조치:** 파일 삭제 또는 필요시 import 추가

### 4.3 analyze-widgets 결과 예시

```
Widget usage analysis:
  AccountSelector: 12 usages
  TossButton: 45 usages
  TossTextField: 38 usages

Potentially unused widgets:
  CustomLegacyDropdown: 0 usages
```

**해석:**
- 사용 빈도 높은 위젯 = 공통 컴포넌트로 적합
- 0 usages = 삭제 또는 deprecate 대상

---

## 5. 프로젝트 적용 체크리스트

### ✅ Phase 1: 설치 및 기본 실행

- [ ] DCM 설치 완료
- [ ] `dcm --version` 으로 설치 확인
- [ ] 프로젝트 루트로 이동 (`cd myFinance_improved_V2`)

### ✅ Phase 2: 기본 분석 실행

```bash
# 아래 명령어들을 순서대로 실행
```

- [ ] `dcm check-unused-code lib` 실행
- [ ] `dcm check-unused-files lib` 실행
- [ ] `dcm analyze-widgets lib/shared/widgets` 실행

### ✅ Phase 3: 결과 기록

분석 결과를 아래 표에 기록:

| 항목 | 개수 | 비고 |
|------|------|------|
| Unused code items | ___ | |
| Unused files | ___ | |
| Deprecated classes detected | ___ | |
| Widgets with 0 usage | ___ | |

### ✅ Phase 4: 우선순위 정리

1. **즉시 삭제 가능:** 완전히 사용되지 않는 파일
2. **확인 필요:** @Deprecated 마킹된 클래스 (마이그레이션 완료 후 삭제)
3. **보류:** 테스트/개발용 파일

### ✅ Phase 5: 보고서 작성

```markdown
## DCM 분석 결과 보고서

**분석 일자:** YYYY-MM-DD
**분석자:** [이름]

### 요약
- 총 분석 파일 수: ___
- 미사용 코드: ___건
- 미사용 파일: ___건

### 권장 조치
1. [파일명] - [조치 내용]
2. [파일명] - [조치 내용]
```

---

## 6. CI/CD 통합 (선택사항)

### GitHub Actions 예시

```yaml
# .github/workflows/code-quality.yml
name: Code Quality Check

on:
  pull_request:
    branches: [main, develop]

jobs:
  dcm-analysis:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Install DCM
        run: dart pub global activate dart_code_metrics

      - name: Check unused code
        run: dcm check-unused-code lib --fatal-unused

      - name: Check unused files
        run: dcm check-unused-files lib --fatal-unused
```

### analysis_options.yaml 설정

```yaml
# analysis_options.yaml에 추가
dart_code_metrics:
  metrics:
    cyclomatic-complexity: 20
    number-of-parameters: 4
    maximum-nesting-level: 5
  rules:
    - prefer-conditional-expressions
    - no-boolean-literal-compare
    - avoid-unused-parameters
```

---

## 7. 자주 묻는 질문 (FAQ)

### Q: DCM이 무료인가요?
A: 기본 기능은 무료입니다. 고급 기능(Teams 기능, IDE 통합)은 유료입니다.

### Q: 실행 시간이 오래 걸리나요?
A: 2,000+ 파일 기준 약 30초~2분 소요됩니다.

### Q: Deprecated 클래스가 unused로 나오면?
A: 정상입니다. Deprecated 마킹된 클래스가 실제로 사용되지 않으면 삭제 대상입니다.

### Q: 거짓 양성(False Positive)이 있나요?
A: 동적 import나 reflection 사용 시 발생할 수 있습니다. 결과를 항상 검토하세요.

---

## 8. 우리 프로젝트 현황

### 현재 알려진 Deprecated 클래스 (33개 사용 중)

```
EnhancedAccountSelector    → AccountSelector 로 마이그레이션
AutonomousCashLocationSelector → CashLocationSelector 로 마이그레이션
AutonomousCounterpartySelector → CounterpartySelector 로 마이그레이션
TossBaseSelector           → BaseSelector 로 마이그레이션
```

### DCM으로 확인할 항목

1. **shared/widgets/selectors/** - 새 구조 사용 여부
2. **core/utils/** - 유틸리티 중복 확인
3. **features/**/widgets/** - feature-specific vs shared 분류

---

## 9. 연락처

질문이 있으면 아래로 연락:
- Slack: #flutter-team
- 담당자: [팀 리드 이름]

---

**문서 버전:** 1.0
**최종 수정:** 2025-12-30
**작성자:** Claude Code Assistant
