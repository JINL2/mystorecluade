# myFinance 코드 효율성 개선 계획서

> 2025년 Flutter/Dart 트렌드 기반 프로젝트 최적화 로드맵

**작성일:** 2025-12-30
**프로젝트 규모:** 2,081개 파일 / 472,623 라인

---

## 📊 현재 프로젝트 분석 결과

### 프로젝트 통계

| 항목 | 현재 값 | 권장 수준 | 상태 |
|------|---------|----------|------|
| 총 Dart 파일 | 2,081개 | - | - |
| 총 코드 라인 | 472,623줄 | - | - |
| Feature 모듈 | 34개 | - | ✅ |
| StatefulWidget | 258개 | 최소화 | 🟡 |
| StatelessWidget | 560개 | 권장 | ✅ |
| ConsumerWidget | 236개 | 증가 필요 | 🟡 |
| @riverpod 사용 | 392개 | 증가 필요 | 🟡 |
| setState() 호출 | 1,056회 | 감소 필요 | 🔴 |
| Container 사용 | 1,828회 | 감소 필요 | 🟡 |
| SizedBox 사용 | 3,613회 | - | ✅ |
| const SizedBox | 3,262회 (90%) | 100% | ✅ |
| const Container | 0회 (0%) | - | ❌ |

### God Files (500줄 이상)

| 파일 | 라인 수 | 우선순위 |
|------|---------|----------|
| trade_pdf_service.dart | 2,091 | 🔴 |
| daily_attendance_detail_page.dart | 1,476 | 🔴 |
| lc_form_page.dart | 1,398 | 🔴 |
| app_router.dart | 1,086 | 🟡 |
| my_schedule_tab.dart | 1,037 | 🔴 |
| toss_success_error_dialog.dart | 938 | 🟡 |
| cash_transaction_page.dart | 937 | 🔴 |
| add_transaction_dialog.dart | 914 | 🔴 |
| signup_page.dart | 913 | 🟡 |
| add_account_page.dart | 867 | 🟡 |

### 현재 강점

✅ **flutter_lints 적용됨**
✅ **strict-mode 활성화** (strict-casts, strict-inference, strict-raw-types)
✅ **custom_lint 규칙 설정** (TossColors, TossTextStyles 강제)
✅ **Freezed/Riverpod Code Generation 사용**
✅ **Clean Architecture 구조** (feature 기반)

---

## 🎯 개선 계획 (4단계)

### Phase 1: 즉시 적용 가능 (1-2주)

#### 1.1 DCM 도입 및 미사용 코드 정리

```bash
# 설치
brew tap nicklockwood/formulae && brew install dcm

# 분석 실행
dcm check-unused-code lib
dcm check-unused-files lib
```

**목표:**
- [ ] Deprecated 클래스 33개 마이그레이션 완료 후 삭제
- [ ] 미사용 파일 탐지 및 제거
- [ ] 미사용 import 정리

#### 1.2 const 생성자 강화

**현황:** Container 1,828개 중 const 0개

```dart
// ❌ Before
Container(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)

// ✅ After - SizedBox 또는 Padding 사용
const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)
```

**작업:**
- [ ] Container → SizedBox/Padding/DecoratedBox 변환
- [ ] `flutter analyze` 경고 0개 달성

#### 1.3 setState 최적화

**현황:** 1,056회 사용 (258개 StatefulWidget)

```dart
// ❌ Before - 전체 rebuild
setState(() {
  _selectedAccount = account;
  _amount = amount;
});

// ✅ After - Riverpod 타겟 rebuild
ref.read(transactionFormProvider.notifier).updateAccount(account);
```

**목표:**
- [ ] 단순 상태는 StatelessWidget + Riverpod로 변환
- [ ] setState 500회 이하로 감소

---

### Phase 2: God File 분리 (2-4주)

#### 2.1 우선순위 대상 파일

| 파일 | 현재 | 목표 | 분리 전략 |
|------|------|------|----------|
| trade_pdf_service.dart (2,091줄) | 1파일 | 5-6파일 | 문서타입별 분리 |
| daily_attendance_detail_page.dart (1,476줄) | 1파일 | 4-5파일 | 섹션/위젯 분리 |
| lc_form_page.dart (1,398줄) | 1파일 | 4파일 | Form 섹션별 분리 |
| add_transaction_dialog.dart (914줄) | 1파일 | 3-4파일 | 입력 필드별 분리 |

#### 2.2 분리 패턴

```
features/letter_of_credit/presentation/pages/
├── lc_form_page.dart (메인 - 200줄)
├── widgets/
│   ├── lc_header_section.dart
│   ├── lc_party_section.dart
│   ├── lc_amount_section.dart
│   ├── lc_dates_section.dart
│   └── lc_documents_section.dart
└── index.dart (barrel export)
```

---

### Phase 3: Riverpod 3.0 마이그레이션 (4-6주)

#### 3.1 pubspec.yaml 업데이트

```yaml
dependencies:
  # Before
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # After
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0

dev_dependencies:
  riverpod_generator: ^3.0.0
```

#### 3.2 주요 변경사항 적용

```dart
// Before (2.x)
@riverpod
Future<List<Account>> accounts(AccountsRef ref) async { ... }

// After (3.0) - 통합된 Ref
@riverpod
Future<List<Account>> accounts(Ref ref) async { ... }
```

#### 3.3 새 기능 활용

```dart
// 자동 Provider 일시정지 (화면에 없으면 pause)
// → WebSocket, 실시간 데이터 자동 최적화

// Reactive Caching
@riverpod
Future<AccountList> accounts(Ref ref) async {
  // 캐시된 데이터 자동 재사용
  return ref.watch(accountRepositoryProvider).getAll();
}
```

**마이그레이션 체크리스트:**
- [ ] `Ref<T>` → `Ref` 변경
- [ ] `.valueOrNull` → `.value` 변경
- [ ] autoDispose 동작 확인
- [ ] Provider 테스트 업데이트

---

### Phase 4: 빌드 최적화 (6-8주)

#### 4.1 Tree Shaking 검증

```bash
# 앱 크기 분석
flutter build apk --analyze-size
flutter build ios --analyze-size

# Release 빌드
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

#### 4.2 이미지 최적화

```bash
# assets/images/ 폴더 분석
# PNG/JPEG → WebP 변환 (30-70% 감소)
```

#### 4.3 Deferred Loading (선택)

```dart
// 대용량 feature 지연 로딩
import 'package:myfinance/features/report_control/index.dart'
    deferred as reports;

Future<void> loadReports() async {
  await reports.loadLibrary();
  // reports 사용
}
```

---

## 📋 실행 체크리스트

### 주간 점검 항목

```bash
# 1. 정적 분석
flutter analyze

# 2. 미사용 코드 검사 (DCM 설치 후)
dcm check-unused-code lib
dcm check-unused-files lib

# 3. 빌드 테스트
flutter build ios --release
```

### 월간 점검 항목

| 항목 | 측정 방법 | 목표 |
|------|----------|------|
| setState 사용 | `grep -r "setState" lib \| wc -l` | < 500 |
| God Files | 500줄 이상 파일 수 | < 5개 |
| const 사용률 | const SizedBox / 전체 SizedBox | > 95% |
| 빌드 크기 | flutter build --analyze-size | 감소 추세 |
| 분석 경고 | flutter analyze | 0개 |

---

## 🛠 도구 설정

### analysis_options.yaml 추가 규칙 (권장)

```yaml
linter:
  rules:
    # 추가 권장 규칙
    - avoid_unnecessary_containers  # Container → SizedBox
    - sized_box_for_whitespace      # 빈 공간에 SizedBox 사용
    - use_colored_box               # 색상만 있으면 ColoredBox
    - use_decorated_box             # decoration만 있으면 DecoratedBox
    - prefer_final_locals           # 지역변수 final 권장
    - avoid_redundant_argument_values  # 기본값과 같은 인자 제거
```

### VSCode 설정 (권장)

```json
// .vscode/settings.json
{
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  }
}
```

---

## 📈 예상 효과

| 개선 항목 | 예상 효과 |
|----------|----------|
| const 생성자 강화 | 리빌드 50% 감소 |
| setState → Riverpod | 불필요한 rebuild 제거 |
| God File 분리 | 유지보수성 향상, 빌드 시간 감소 |
| Riverpod 3.0 | 메모리 사용량 최적화 |
| Tree Shaking 검증 | 앱 크기 30-50% 감소 가능 |
| 미사용 코드 제거 | 코드베이스 정리 |

---

## 📚 참고 자료

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Riverpod 3.0 Migration Guide](https://riverpod.dev/docs/whats_new)
- [DCM Documentation](https://dcm.dev)
- [Effective Dart](https://dart.dev/effective-dart)

---

## 🗓 타임라인 요약

```
Phase 1 (즉시)     │ DCM 도입, const 강화, setState 최적화
──────────────────┼───────────────────────────────────────
Phase 2 (2-4주)   │ God File 분리 (상위 10개)
──────────────────┼───────────────────────────────────────
Phase 3 (4-6주)   │ Riverpod 3.0 마이그레이션
──────────────────┼───────────────────────────────────────
Phase 4 (6-8주)   │ 빌드 최적화, 이미지 압축
```

---

**문서 버전:** 1.0
**최종 수정:** 2025-12-30
**작성자:** Claude Code Assistant
