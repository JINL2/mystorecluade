# Design System 채택 현황 보고서

**생성일**: 2025-12-31
**분석 범위**: `lib/features/` 디렉토리
**목표**: 채택률 18% → 70%+ 달성

---

## 1. Executive Summary

### 현재 상태 요약

| 카테고리 | 채택률 | 상태 |
|----------|--------|------|
| **Colors** | 48% | 🟡 개선 필요 |
| **Spacing** | 99.6% | 🟢 우수 |
| **BorderRadius** | 94.2% | 🟢 우수 |
| **TextStyles** | 96.4% | 🟢 우수 |
| **TextField** | 18.3% | 🔴 긴급 |
| **Button** | 39.3% | 🟡 개선 필요 |
| **Card** | 100% | 🟢 우수 |

**핵심 발견**: 디자인 토큰(Spacing, BorderRadius, TextStyles)은 이미 우수한 채택률을 보이고 있습니다.
**집중 영역**: TextField 마이그레이션이 가장 시급합니다.

---

## 2. 디자인 토큰 상세 분석

### 2.1 Colors (TossColors)

| 유형 | 사용 횟수 | 비율 |
|------|----------|------|
| TossColors | 6,812 | 48.3% |
| 하드코딩 (Color/Colors) | 7,279 | 51.7% |
| **합계** | **14,091** | - |

**채택률: 48%** 🟡

**분석**:
- Colors 클래스의 직접 사용이 많음 (예: `Colors.white`, `Colors.black`)
- `Color(0xFF...)` 형태의 하드코딩도 존재
- 일부는 Flutter Material 컴포넌트의 기본값으로 사용됨

**권장 조치**:
- `Colors.white` → `TossColors.white`
- `Colors.black` → `TossColors.gray900`
- 커스텀 색상 → TossColors에 추가 또는 기존 색상 매핑

---

### 2.2 Spacing (TossSpacing)

| 유형 | 사용 횟수 | 비율 |
|------|----------|------|
| TossSpacing | 4,728 | 99.6% |
| 하드코딩 (EdgeInsets.all(숫자)) | 19 | 0.4% |
| **합계** | **4,747** | - |

**채택률: 99.6%** 🟢

**분석**:
- 거의 완벽한 채택률
- 하드코딩된 19건은 특수한 경우로 보임
- 현재 상태 유지하면 됨

---

### 2.3 BorderRadius (TossBorderRadius)

| 유형 | 사용 횟수 | 비율 |
|------|----------|------|
| TossBorderRadius | 1,433 | 94.2% |
| 하드코딩 (BorderRadius.circular(숫자)) | 89 | 5.8% |
| **합계** | **1,522** | - |

**채택률: 94.2%** 🟢

**분석**:
- 우수한 채택률
- 89건의 하드코딩은 점진적으로 수정 가능
- 우선순위 낮음

---

### 2.4 TextStyles (TossTextStyles)

| 유형 | 사용 횟수 | 비율 |
|------|----------|------|
| TossTextStyles | 2,912 | 96.4% |
| 하드코딩 (TextStyle()) | 108 | 3.6% |
| **합계** | **3,020** | - |

**채택률: 96.4%** 🟢

**분석**:
- 우수한 채택률
- 하드코딩된 108건 중 대부분은 `.copyWith()` 확장 용도
- 현재 상태 유지하면 됨

---

## 3. 위젯 채택률 상세 분석

### 3.1 TextField → TossTextField

| 유형 | 사용 횟수 | 비율 |
|------|----------|------|
| TossTextField | 40 | 18.3% |
| TextField/TextFormField 직접 사용 | 178 | 81.7% |
| **합계** | **218** | - |

**채택률: 18.3%** 🔴 **긴급**

**분석**:
- 가장 낮은 채택률
- 178건의 직접 사용을 마이그레이션 필요
- Form validation, controller 연동 등 기존 로직 유지 필요

**마이그레이션 예시**:
```dart
// Before
TextFormField(
  controller: _controller,
  decoration: InputDecoration(labelText: 'Email'),
  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
)

// After
TossTextField(
  label: 'Email',
  controller: _controller,
  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
  isRequired: true,
)
```

---

### 3.2 Button → TossButton

| 유형 | 사용 횟수 | 비율 |
|------|----------|------|
| TossButton 계열 | 121 | 39.3% |
| ElevatedButton/TextButton/OutlinedButton 직접 사용 | 187 | 60.7% |
| **합계** | **308** | - |

**채택률: 39.3%** 🟡

**분석**:
- 중간 수준의 채택률
- 187건의 직접 사용을 마이그레이션 필요
- 버튼 variant 매핑 필요

**마이그레이션 매핑**:
| Flutter Widget | TossButton |
|----------------|------------|
| `ElevatedButton` | `TossButton.primary()` |
| `OutlinedButton` | `TossButton.outlined()` |
| `TextButton` | `TossButton.textButton()` |

---

### 3.3 Card → TossCard

| 유형 | 사용 횟수 | 비율 |
|------|----------|------|
| TossCard/TossExpandableCard | 25 | 100% |
| Card 직접 사용 | 0 | 0% |
| **합계** | **25** | - |

**채택률: 100%** 🟢

**분석**:
- 완벽한 채택률
- 현재 상태 유지

---

## 4. 컴포넌트 품질 검증

### 4.1 TossTextField 테스트 커버리지

**파일**: `test/shared/widgets/toss_text_field_test.dart`

| 테스트 케이스 | 상태 |
|--------------|------|
| renders with label | ✅ |
| shows required indicator (*) when isRequired is true | ✅ |
| does not show required indicator when isRequired is false | ✅ |
| controller updates text | ✅ |
| onChanged callback is called when text changes | ✅ |
| validator shows error message | ✅ |
| disabled field does not accept input | ✅ |
| renders with custom labelWidget | ✅ |
| renders with suffixIcon | ✅ |
| multiline field has correct maxLines | ✅ |
| obscureText hides password | ✅ |
| isImportant changes label font weight | ✅ |

**테스트 수: 12개** ✅ 완료

---

### 4.2 TossButton 테스트 커버리지

**파일**: `test/shared/widgets/toss_button_test.dart`

| 테스트 그룹 | 테스트 케이스 수 |
|------------|-----------------|
| Primary Button | 6 |
| Secondary Button | 2 |
| Outlined Button | 2 |
| Outlined Gray Button | 1 |
| Text Button | 2 |
| Debouncing | 1 |
| Loading State | 1 |
| Button Variants | 1 |

**테스트 수: 16개** ✅ 완료

---

## 5. 인프라 현황

### 5.1 Lint 설정

| 항목 | 상태 |
|------|------|
| custom_lint 패키지 | ✅ 설치됨 |
| prefer_toss_widgets 규칙 | ✅ severity: warning |
| widget_suggestions 매핑 | ✅ 6개 위젯 |

### 5.2 CI/CD 파이프라인

| Job | 상태 |
|-----|------|
| flutter-analysis | ✅ 기존 |
| widget-adoption-check | ✅ 추가됨 |
| test | ✅ 추가됨 |

### 5.3 개발자 도구

| 명령어 | 설명 | 상태 |
|--------|------|------|
| `make widget-report` | 위젯 채택률 리포트 | ✅ |
| `make lint-custom` | custom_lint 실행 | ✅ |
| `make lint-all` | flutter analyze + custom_lint | ✅ |

---

## 6. 마이그레이션 우선순위

### 긴급 (Week 1)

| 순위 | 대상 | 현재 채택률 | 목표 | 예상 작업량 |
|------|------|-------------|------|------------|
| 1 | TextField → TossTextField | 18.3% | 70% | 178건 |
| 2 | Button → TossButton | 39.3% | 70% | 187건 |

### 중요 (Week 2-3)

| 순위 | 대상 | 현재 채택률 | 목표 | 예상 작업량 |
|------|------|-------------|------|------------|
| 3 | Colors 하드코딩 정리 | 48% | 80% | 선별적 |
| 4 | BorderRadius 하드코딩 정리 | 94.2% | 98% | 89건 |

### 유지 (현재 상태 유지)

| 대상 | 현재 채택률 |
|------|-------------|
| Spacing | 99.6% |
| TextStyles | 96.4% |
| Card | 100% |

---

## 7. 권장 실행 계획

### Phase 1: TextField 마이그레이션 (Week 1)

**우선순위 파일**:
1. `lc_form_page.dart` - 약 21건
2. `add_account_page.dart` - 약 13건
3. `pi_form_page.dart` - 약 6건
4. `po_form_page.dart` - 약 5건

**예상 효과**: 채택률 18% → 50%+

### Phase 2: Button 마이그레이션 (Week 2)

**auth, session, inventory feature 순서로 진행**

**예상 효과**: 채택률 39% → 70%+

### Phase 3: Colors 정리 (Week 3)

**점진적으로 `Colors.xxx` → `TossColors.xxx` 변환**

---

## 8. 결론

### 긍정적 발견
- **디자인 토큰** (Spacing, BorderRadius, TextStyles)은 이미 우수한 채택률 (94%+)
- **TossCard**는 100% 채택 완료
- **테스트 인프라** 구축 완료 (TossTextField 12개, TossButton 16개 테스트)
- **CI/CD** 위젯 채택률 자동 검사 추가됨

### 개선 필요 영역
- **TextField**: 18.3% → 70%+ (178건 마이그레이션 필요)
- **Button**: 39.3% → 70%+ (187건 마이그레이션 필요)
- **Colors**: 48% → 80% (선별적 정리 필요)

### 다음 단계
1. `lc_form_page.dart` TextField 마이그레이션부터 시작
2. 파일별 마이그레이션 후 테스트 실행
3. 주간 채택률 리포트로 진행 상황 추적

---

*이 보고서는 자동 생성되었으며, 정확한 수치는 grep 기반 검색 결과입니다.*
