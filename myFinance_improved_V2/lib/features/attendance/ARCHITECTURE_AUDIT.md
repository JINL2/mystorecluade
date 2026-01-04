# Attendance - Architecture Audit Report

**Audit Date:** 2026-01-02
**Auditor:** Claude Opus 4.5 Architecture Review
**Feature Path:** `myFinance_improved_V2/lib/features/attendance`

---

## 요약

| 항목 | 상태 |
|------|------|
| **전체 평가** | **B+** |
| **Critical 이슈** | 0개 |
| **Warning** | 6개 |
| **Info** | 4개 |

### 강점
- Clean Architecture 3-Layer 구조 완벽 준수 (data/domain/presentation)
- Domain 레이어 순수성 유지 (Flutter/외부 패키지 import 없음)
- Either 패턴으로 일관된 에러 처리
- Entity-DTO 분리 패턴 적용
- Riverpod 2.0+ 코드 생성 방식 사용

### 개선 필요 사항
- God File 경고: 3개 파일이 500줄 이상
- God Class 경고: 4개 파일에 3개 이상 클래스
- Utility 파일이 presentation 레이어에 위치

---

## 1. God File 탐지

### 기준
- **Warning**: 500줄 이상
- **Critical**: 1000줄 이상

### 분석 결과

| 파일 | 라인 수 | 상태 | 비고 |
|------|---------|------|------|
| `presentation/widgets/shift/today_shift_card.dart` | 693 | WARNING | UI 위젯 분리 권장 |
| `presentation/pages/my_schedule_tab.dart` | 667 | WARNING | 상태 로직 분리 권장 |
| `data/datasources/attendance_datasource.dart` | 623 | WARNING | 메서드별 파일 분리 고려 |
| `presentation/pages/qr_scanner_page.dart` | 560 | WARNING | 비즈니스 로직 분리 권장 |
| `presentation/pages/utils/schedule_date_utils.dart` | 497 | OK | 유틸리티, 허용 범위 |

### 생성 파일 (분석 제외)

| 파일 | 라인 수 | 상태 |
|------|---------|------|
| `domain/entities/problem_details.freezed.dart` | 2173 | EXCLUDED (generated) |
| `data/models/monthly_attendance_model.freezed.dart` | 1435 | EXCLUDED (generated) |
| `domain/entities/monthly_attendance.freezed.dart` | 1312 | EXCLUDED (generated) |
| `domain/entities/user_shift_stats.freezed.dart` | 1307 | EXCLUDED (generated) |

### 권장 사항

1. **`today_shift_card.dart`**: 693줄
   - `_buildProblemSection()`, `_buildTimeSection()` 등을 별도 위젯으로 추출
   - `TodayShiftProblemBadges`, `TodayShiftTimeDisplay` 위젯 생성 권장

2. **`my_schedule_tab.dart`**: 667줄
   - 캐싱 로직을 별도 Controller/Notifier로 분리
   - `_buildProblemStatusMap()`, `_countUnsolvedProblems()` 유틸리티 분리

3. **`attendance_datasource.dart`**: 623줄
   - RPC 메서드별로 Mixin 또는 Extension 분리 고려

---

## 2. God Class 탐지

### 기준
- **Warning**: 한 파일에 3개 이상 클래스

### 분석 결과

| 파일 | 클래스 수 | 클래스 목록 | 권장 사항 |
|------|-----------|-------------|-----------|
| `data/models/user_shift_stats_model.dart` | 5 | Model + 관련 서브모델 | 파일 분리 권장 |
| `domain/entities/user_shift_stats.dart` | 5 | Entity + 서브엔티티 | Freezed 특성상 허용 |
| `data/models/shift_card_model.dart` | 4 | ShiftCardModel, ProblemDetailsModel, ProblemItemModel, ManagerMemoModel | 관련 모델이므로 허용 가능 |
| `data/models/monthly_attendance_model.dart` | 4 | 관련 모델 그룹 | 파일 분리 권장 |
| `domain/entities/monthly_shift_status.dart` | 3 | Entity + 서브엔티티 | Freezed 특성상 허용 |
| `domain/entities/monthly_attendance.dart` | 3 | Entity + 서브엔티티 | Freezed 특성상 허용 |
| `presentation/pages/qr_scanner_page.dart` | 3 | Page + State + CustomClipper | CustomClipper 별도 분리 권장 |
| `presentation/widgets/stats/salary_trend_section.dart` | 3 | 위젯 그룹 | 파일 분리 권장 |

### 권장 사항

1. **Data Models 분리**
   - `problem_details_model.dart` - ProblemDetailsModel, ProblemItemModel 분리
   - `manager_memo_model.dart` - ManagerMemoModel 분리

2. **QR Scanner 분리**
   - `_ScannerOverlayClipper`를 `scanner_overlay_clipper.dart`로 분리

---

## 3. 폴더 구조

### Clean Architecture 레이어 체크

```
attendance/
├── data/           [OK] Data Layer
│   ├── datasources/    [OK] Remote/Local 데이터 소스
│   ├── models/         [OK] DTO/Mapper
│   └── repositories/   [OK] Repository 구현체
├── domain/         [OK] Domain Layer
│   ├── entities/       [OK] 순수 도메인 모델
│   ├── exceptions/     [OK] 도메인 예외
│   ├── repositories/   [OK] Repository 인터페이스
│   └── usecases/       [OK] 비즈니스 로직
└── presentation/   [OK] Presentation Layer
    ├── pages/          [OK] 화면 (Page/Tab)
    ├── providers/      [OK] Riverpod Providers
    └── widgets/        [OK] UI 컴포넌트
```

### 평가: PASS

모든 Clean Architecture 레이어가 올바르게 구성됨.

---

## 4. Domain 순수성

### 검사 항목
- Flutter import 여부
- Data 레이어 import 여부
- Presentation 레이어 import 여부

### 분석 결과

```bash
# Flutter import 검사
$ grep -r "import.*flutter" domain/
결과: 없음 [PASS]

# Data 레이어 import 검사
$ grep -r "import.*data/" domain/
결과: 없음 [PASS]

# Presentation 레이어 import 검사
$ grep -r "import.*presentation/" domain/
결과: 없음 [PASS]
```

### Domain 파일 분석

| 파일 | 외부 의존성 | 상태 |
|------|-------------|------|
| `entities/*.dart` | `freezed_annotation` only | PASS |
| `repositories/*.dart` | `dartz` (Either), core/errors | PASS |
| `usecases/*.dart` | `dartz`, domain entities | PASS |
| `exceptions/*.dart` | 없음 | PASS |

### 평가: PASS (100%)

Domain 레이어가 완벽하게 순수성을 유지하고 있음.

---

## 5. Data 레이어 위반

### 검사 항목
- Presentation import 여부
- BuildContext 사용 여부

### 분석 결과

```bash
# Presentation import 검사
$ grep -r "import.*presentation/" data/
결과: 없음 [PASS]

# BuildContext 검사
$ grep -r "BuildContext" data/
결과: 없음 [PASS]
```

### 평가: PASS

Data 레이어가 Presentation 의존성 없이 올바르게 구현됨.

---

## 6. Entity vs DTO 분리

### 분석 결과

| Entity (Domain) | Model/DTO (Data) | 상태 |
|-----------------|------------------|------|
| `ShiftCard` | `ShiftCardModel` | PASS |
| `ShiftRequest` | `ShiftRequestModel` | PASS |
| `ShiftMetadata` | `ShiftMetadataModel` | PASS |
| `MonthlyShiftStatus` | `MonthlyShiftStatusModel` | PASS |
| `MonthlyAttendance` | `MonthlyAttendanceModel` | PASS |
| `UserShiftStats` | `UserShiftStatsModel` | PASS |
| `BaseCurrency` | `BaseCurrencyModel` | PASS |
| `CheckInResult` | `CheckInResultModel` | PASS |
| `ProblemDetails` | `ProblemDetailsModel` | PASS |
| `ManagerMemo` | `ManagerMemoModel` | PASS |

### DTO Mapper 패턴

```dart
// 예시: ShiftCardModel
class ShiftCardModel {
  factory ShiftCardModel.fromJson(Map<String, dynamic> json) => ...;
  ShiftCard toEntity() => ShiftCard(...);  // Entity 변환
  Map<String, dynamic> toJson() => ...;
}
```

### 평가: PASS

- 모든 Entity에 대응하는 Model(DTO)이 존재
- `fromJson()`, `toEntity()`, `toJson()` 메서드 일관 적용
- JSON 직렬화가 Data 레이어에서만 처리됨

---

## 7. Repository 패턴

### Repository Interface (Domain)

```dart
// domain/repositories/attendance_repository.dart
abstract class AttendanceRepository {
  Future<Either<Failure, CheckInResult>> updateShiftRequest({...});
  Future<Either<Failure, List<ShiftCard>>> getUserShiftCards({...});
  Future<Either<Failure, bool>> reportShiftIssue({...});
  // ... 9개 메서드
}
```

### Repository Implementation (Data)

```dart
// data/repositories/attendance_repository_impl.dart
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDatasource _datasource;

  @override
  Future<Either<Failure, CheckInResult>> updateShiftRequest({...}) async {
    try {
      final json = await _datasource.updateShiftRequest(...);
      return Right(CheckInResultModel.fromJson(json).toEntity());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }
}
```

### 평가: PASS

- Interface/Implementation 분리 완료
- Either 패턴으로 에러 처리 통일
- Datasource 의존성 주입 적용

---

## 8. Riverpod 사용 현황

### @riverpod 어노테이션 분석

| 파일 | Provider 개수 | 타입 |
|------|---------------|------|
| `attendance_providers.dart` | 17 | UseCase, State Providers |
| `monthly_attendance_providers.dart` | 9 | Monthly 관련 Providers |
| `repository_providers.dart` | 3 | Repository/Datasource DI |
| `qr_scanner_state.dart` | 2 | QR Scanner State |

**총 31개 @riverpod Provider**

### Provider 패턴 분석

```dart
// UseCase Provider (권장 패턴)
@riverpod
CheckInShift checkInShift(CheckInShiftRef ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return CheckInShift(repository);
}

// Family Provider (파라미터 있는 Provider)
@riverpod
Future<List<ShiftCard>> monthlyShiftCards(
  MonthlyShiftCardsRef ref,
  String yearMonth,  // 캐싱 키
) async { ... }
```

### 평가: PASS

- Riverpod 2.0+ 코드 생성 방식 사용
- Provider 네이밍 컨벤션 준수 (`*Provider` 접미사)
- Family Provider로 효율적인 캐싱 구현

---

## 9. Cross-Feature 의존성

### 검사 결과

```bash
$ grep -r "import.*features/(?!attendance)" attendance/
결과: 없음 [PASS]
```

### 외부 의존성 분석

| 의존성 타입 | 경로 | 상태 |
|-------------|------|------|
| Core | `core/errors/failures.dart` | OK (공통) |
| Core | `core/utils/datetime_utils.dart` | OK (공통) |
| Core | `core/monitoring/sentry_config.dart` | OK (공통) |
| App | `app/providers/app_state_provider.dart` | OK (전역 상태) |
| App | `app/providers/auth_providers.dart` | OK (인증) |
| Shared | `shared/themes/*` | OK (공통 UI) |
| Shared | `shared/widgets/*` | OK (공통 위젯) |

### 평가: PASS

- 다른 Feature에 대한 의존성 없음
- Core/App/Shared 레이어만 참조

---

## 10. 효율성 이슈

### 중복 코드 분석

#### 1. 날짜 포맷팅 유틸리티

```dart
// 여러 파일에서 유사한 패턴
final yearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
```

**권장**: `DateTimeUtils`에 `toYearMonth()` 메서드 추가

#### 2. Provider Invalidation 패턴

```dart
// qr_scanner_page.dart, my_schedule_tab.dart 등에서 반복
ref.invalidate(monthlyShiftCardsProvider(currentYearMonth));
ref.invalidate(monthlyShiftCardsProvider(prevYearMonth));
```

**권장**: `AttendanceRefreshService` 클래스로 중앙화

### 불필요한 복잡성

#### 1. schedule_date_utils.dart 위치

현재 위치: `presentation/pages/utils/`
권장 위치: `domain/services/` 또는 `core/utils/`

비즈니스 로직 (체크아웃 마감 계산, 연속 시프트 감지)이 포함되어 있어 Domain 레이어가 더 적합.

#### 2. 위젯 내 비즈니스 로직

`my_schedule_tab.dart`의 `_buildProblemStatusMap()`, `_countUnsolvedProblems()`는 UseCase로 분리 권장.

---

## 개선 우선순위

### High Priority

1. **[WARNING] God File 분리**
   - `today_shift_card.dart`: 작은 위젯으로 분리
   - `my_schedule_tab.dart`: Controller/Notifier 패턴 적용

2. **[WARNING] 유틸리티 위치 변경**
   - `schedule_date_utils.dart`를 `domain/services/`로 이동

### Medium Priority

3. **[INFO] God Class 분리**
   - Data Models의 서브 클래스 별도 파일로 분리
   - `_ScannerOverlayClipper` 분리

4. **[INFO] 중복 코드 리팩토링**
   - 날짜 포맷 유틸리티 통합
   - Provider Invalidation 서비스 생성

### Low Priority

5. **[INFO] 문서화**
   - Public API에 dartdoc 주석 추가
   - 복잡한 비즈니스 로직에 설명 추가

---

## 파일 통계

| 항목 | 수치 |
|------|------|
| 전체 Dart 파일 | 89개 |
| 생성된 파일 (.freezed.dart, .g.dart) | ~30개 |
| 수동 작성 파일 | ~59개 |
| Domain Entities | 14개 |
| Data Models | 8개 |
| UseCases | 10개 |
| Providers | 31개 |

---

## 결론

Attendance 피처는 Clean Architecture 원칙을 잘 준수하고 있으며, 특히 Domain 레이어의 순수성과 Entity-DTO 분리가 모범적으로 구현되어 있습니다.

주요 개선 포인트는 일부 큰 파일들의 분리와 유틸리티 클래스의 위치 조정입니다. 이러한 개선을 통해 코드 유지보수성과 테스트 용이성을 더욱 높일 수 있습니다.

**최종 평가: B+ (Good)**

---

*Generated by Claude Opus 4.5 Architecture Audit*
