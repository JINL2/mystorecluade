# DCM 분석 결과 보고서

**분석 일자:** 2025-12-30
**분석 도구:** dart_code_metrics v5.7.6

---

## 요약

| 항목 | 개수 |
|------|------|
| **총 분석 파일 수** | 2,401개 |
| **미사용 파일** | 162개 |
| **미사용 코드** | 273개 |

---

## 1. 미사용 파일 (162개)

### 1.1 우선 삭제 대상 - dev_tools (3개)
개발/디버깅 전용 파일로 프로덕션에서 불필요:
```
lib/dev_tools/responsive_tester.dart
lib/dev_tools/screen_size_debug.dart
lib/dev_tools/theme_validator.dart
```

### 1.2 우선 삭제 대상 - core 레이어 (14개)
```
lib/core/data/models/journal_entry_model.dart
lib/core/infrastructure/state_synchronizer.dart
lib/core/navigation/auth_navigator.dart
lib/core/navigation/go_router_extensions.dart
lib/core/navigation/safe_navigation.dart
lib/core/notifications/firebase_stub.dart
lib/core/notifications/services/token_manager_enhanced.dart
lib/core/notifications/utils/production_monitoring.dart
lib/core/services/inventory_service.dart
lib/core/utils/color_opacity_helper.dart
lib/core/utils/error_mapper.dart
lib/core/utils/image_cache_helper.dart
lib/core/utils/widget_migration_helper.dart
lib/core/validators/phone_validator.dart
```

### 1.3 Feature별 미사용 파일

| Feature | 미사용 파일 수 | 주요 파일 |
|---------|--------------|----------|
| attendance | 28개 | shift_overview_model, schedule_*_view, attendance_* 위젯들 |
| time_table_manage | 24개 | manager_overview_model, shift_* 위젯들 |
| cash_ending | 11개 | cash_ending_model, location_selector, currency_selector |
| inventory_management | 7개 | product_form/ 섹션들 |
| sales_invoice | 10개 | payment_method 관련 위젯들 |
| report_control | 8개 | template 위젯들 |
| homepage | 6개 | providers, feature_card 등 |
| transaction_template | 6개 | forms/ 위젯들 |
| session | 6개 | create_session_dialog, session_detail 위젯들 |
| cash_transaction | 4개 | direction_selection_card 등 |
| 기타 features | 28개 | 각 feature별 산발적 파일들 |

---

## 2. 미사용 코드 (273개)

### 2.1 주요 카테고리

| 타입 | 개수 | 예시 |
|------|------|------|
| unused top level variable | ~80개 | Provider 변수들 |
| unused class | ~60개 | Model, Helper 클래스들 |
| unused extension | ~40개 | String, Model extension들 |
| unused function | ~30개 | 헬퍼 함수들 |
| unused type alias | ~20개 | Callback typedef들 |
| unused enum/enum value | ~43개 | 사용되지 않는 enum 값들 |

### 2.2 즉시 정리 대상

**app/providers/**
```dart
// app_state_provider.dart - 4개 미사용 provider
userProfileImageProvider  // line 43
userFirstNameProvider     // line 49
userFullNameProvider      // line 55
userInitialsProvider      // line 67

// auth_providers.dart - 1개 미사용 provider
isAuthLoadingProvider     // line 67
```

**core/domain/entities/selector_entities.dart** - 5개 미사용 typedef
```dart
DataSelectionCallback
OnCounterpartySelectedCallback
OnCashLocationSelectedCallback
OnMultiCounterpartySelectedCallback
MultiDataSelectionCallback
```

**core/navigation/** - 5개 미사용 provider
```dart
isNavigatingProvider
currentRouteProvider
navigationHistoryProvider
isRouteLocked
navigationStatisticsProvider
```

---

## 3. 권장 조치

### Phase 1: 즉시 삭제 (안전)
1. `lib/dev_tools/` 폴더 전체 삭제
2. 미사용 core/utils 파일들 삭제:
   - color_opacity_helper.dart
   - error_mapper.dart
   - image_cache_helper.dart
   - widget_migration_helper.dart

### Phase 2: 확인 후 삭제 (Feature 파일들)
1. attendance feature - 28개 파일 검토
2. time_table_manage feature - 24개 파일 검토
3. cash_ending feature - 11개 파일 검토

### Phase 3: 코드 정리
1. 미사용 Provider 변수 정리
2. 미사용 extension 정리
3. 미사용 typedef 정리

---

## 4. 예상 효과

| 항목 | Before | After (예상) |
|------|--------|-------------|
| Dart 파일 수 | 2,401개 | ~2,239개 (-162) |
| 코드 라인 수 | 531,083줄 | ~500,000줄 (-6%) |
| 빌드 시간 | - | 5-10% 단축 예상 |

---

## 5. 실행 명령어

```bash
# 프로젝트 디렉토리로 이동
cd myFinance_improved_V2

# 미사용 파일 재검사
~/.pub-cache/bin/metrics check-unused-files lib --disable-sunset-warning

# 미사용 코드 재검사
~/.pub-cache/bin/metrics check-unused-code lib --disable-sunset-warning

# JSON 리포트 생성
~/.pub-cache/bin/metrics check-unused-files lib --reporter=json > unused_files.json
~/.pub-cache/bin/metrics check-unused-code lib --reporter=json > unused_code.json
```

---

## 6. 상세 파일 목록

상세 목록은 아래 파일 참조:
- [DCM_UNUSED_FILES_REPORT.txt](./DCM_UNUSED_FILES_REPORT.txt)
- [DCM_UNUSED_CODE_REPORT.txt](./DCM_UNUSED_CODE_REPORT.txt)

---

**작성:** Claude Code Assistant
**버전:** 1.0
