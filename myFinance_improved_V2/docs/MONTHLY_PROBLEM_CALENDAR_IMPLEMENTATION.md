# Monthly Problem Calendar Implementation Plan

> **목적**: Timesheets 탭에 월간 캘린더 추가 - 문제 상태를 색상으로 표시
> **작성일**: 2025-12-19
> **상태**: Planning

---

## 1. 요구사항 요약

### 1.1 문제점 (현재)
- 매니저가 문제를 한눈에 볼 수 없음
- 2주 전 리포트도 찾기 어려움
- 어떤 날짜에 문제가 있는지 알 수 없음

### 1.2 해결책
월간 캘린더에 색상 코드로 문제 상태 표시:

| 색상 | 의미 | 조건 |
|------|------|------|
| 🟠 Orange | 미해결 리포트 | `is_reported_v2 = true AND is_reported_solved_v2 != true` |
| 🔴 Red | 미해결 문제 | `is_problem_v2 = true AND is_problem_solved_v2 = false` |
| 🟢 Green | 해결됨 | `is_problem_v2 = true AND is_problem_solved_v2 = true` |
| ⚪ Gray | 문제 없음 | 위 조건 모두 해당 안됨 |

**우선순위**: orange > red > green > gray

---

## 2. RPC 함수 설계

### 2.1 `get_monthly_problem_status_v1`

**위치**: `supabase/migrations/20251219_get_monthly_problem_status_v1.sql`

**입력**:
```sql
p_store_id UUID,
p_year INT,
p_month INT
```

**출력**:
```json
{
  "success": true,
  "year": 2024,
  "month": 12,
  "store_id": "uuid",
  "days": [
    {
      "date": "2024-12-01",
      "status": "orange",  // orange | red | green | gray
      "counts": {
        "unsolved_reports": 2,
        "unsolved_problems": 0,
        "solved_problems": 1,
        "total_shifts": 5
      },
      "problems": [
        {
          "request_id": "uuid",
          "employee_name": "John",
          "is_reported": true,
          "is_reported_solved": false,
          "is_problem": true,
          "is_problem_solved": false,
          "problem_type": "late",
          "problem_details": {...}
        }
      ]
    }
  ]
}
```

---

## 3. Flutter 구현 계획

### 3.1 파일 구조

```
lib/features/time_table_manage/
├── data/
│   ├── datasources/
│   │   └── time_table_remote_datasource.dart  // RPC 호출 추가
│   └── models/
│       └── monthly_problem_status_model.dart  // NEW: RPC 응답 모델
├── domain/
│   └── entities/
│       └── monthly_problem_status.dart        // NEW: 도메인 엔티티
├── presentation/
│   ├── providers/
│   │   └── time_table_providers.dart          // Provider 추가
│   └── widgets/
│       └── timesheets/
│           ├── timesheets_tab.dart            // 월간 캘린더 추가
│           ├── monthly_problem_calendar.dart  // NEW: 월간 캘린더 위젯
│           └── problem_day_cell.dart          // NEW: 날짜 셀 위젯
```

### 3.2 새로운 파일들

#### 3.2.1 `monthly_problem_status_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_problem_status_model.freezed.dart';
part 'monthly_problem_status_model.g.dart';

@freezed
class MonthlyProblemStatusModel with _$MonthlyProblemStatusModel {
  const factory MonthlyProblemStatusModel({
    required bool success,
    required int year,
    required int month,
    required String storeId,
    required List<DayProblemStatus> days,
  }) = _MonthlyProblemStatusModel;

  factory MonthlyProblemStatusModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyProblemStatusModelFromJson(json);
}

@freezed
class DayProblemStatus with _$DayProblemStatus {
  const factory DayProblemStatus({
    required String date,
    required String status,  // 'orange' | 'red' | 'green' | 'gray'
    required ProblemCounts counts,
    required List<ProblemDetail> problems,
  }) = _DayProblemStatus;

  factory DayProblemStatus.fromJson(Map<String, dynamic> json) =>
      _$DayProblemStatusFromJson(json);
}

@freezed
class ProblemCounts with _$ProblemCounts {
  const factory ProblemCounts({
    @JsonKey(name: 'unsolved_reports') required int unsolvedReports,
    @JsonKey(name: 'unsolved_problems') required int unsolvedProblems,
    @JsonKey(name: 'solved_problems') required int solvedProblems,
    @JsonKey(name: 'total_shifts') required int totalShifts,
  }) = _ProblemCounts;

  factory ProblemCounts.fromJson(Map<String, dynamic> json) =>
      _$ProblemCountsFromJson(json);
}

@freezed
class ProblemDetail with _$ProblemDetail {
  const factory ProblemDetail({
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'employee_name') required String employeeName,
    @JsonKey(name: 'is_reported') required bool isReported,
    @JsonKey(name: 'is_reported_solved') required bool isReportedSolved,
    @JsonKey(name: 'is_problem') required bool isProblem,
    @JsonKey(name: 'is_problem_solved') required bool isProblemSolved,
    @JsonKey(name: 'problem_type') String? problemType,
    @JsonKey(name: 'problem_details') Map<String, dynamic>? problemDetails,
  }) = _ProblemDetail;

  factory ProblemDetail.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailFromJson(json);
}
```

#### 3.2.2 `monthly_problem_calendar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 월간 캘린더 - 문제 상태 색상 표시
class MonthlyProblemCalendar extends ConsumerStatefulWidget {
  final String storeId;
  final DateTime initialMonth;
  final void Function(DateTime date, DayProblemStatus status)? onDayTap;

  const MonthlyProblemCalendar({
    super.key,
    required this.storeId,
    required this.initialMonth,
    this.onDayTap,
  });

  @override
  ConsumerState<MonthlyProblemCalendar> createState() => _MonthlyProblemCalendarState();
}

class _MonthlyProblemCalendarState extends ConsumerState<MonthlyProblemCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialMonth.year, widget.initialMonth.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    // Watch monthly problem status provider
    final statusAsync = ref.watch(monthlyProblemStatusProvider((
      storeId: widget.storeId,
      year: _currentMonth.year,
      month: _currentMonth.month,
    )));

    return Column(
      children: [
        // Month Navigation Header
        _buildMonthHeader(),

        // Weekday Headers
        _buildWeekdayHeaders(),

        // Calendar Grid
        statusAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (status) => _buildCalendarGrid(status),
        ),
      ],
    );
  }

  Widget _buildMonthHeader() {
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _changeMonth(-1),
        ),
        Text(monthName, style: TossTextStyles.h3),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(MonthlyProblemStatusModel status) {
    // Create status map for quick lookup
    final statusMap = <String, DayProblemStatus>{};
    for (final day in status.days) {
      statusMap[day.date] = day;
    }

    // Build calendar grid
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startingWeekday = firstDayOfMonth.weekday; // 1=Mon, 7=Sun

    final cells = <Widget>[];

    // Empty cells before first day
    for (int i = 1; i < startingWeekday; i++) {
      cells.add(const SizedBox());
    }

    // Day cells
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final dayStatus = statusMap[dateStr];

      cells.add(
        ProblemDayCell(
          day: day,
          status: dayStatus?.status ?? 'gray',
          counts: dayStatus?.counts,
          onTap: () {
            if (dayStatus != null) {
              widget.onDayTap?.call(date, dayStatus);
            }
          },
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cells,
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta, 1);
    });
  }
}
```

#### 3.2.3 `problem_day_cell.dart`

```dart
import 'package:flutter/material.dart';

/// 캘린더 날짜 셀 - 색상 표시
class ProblemDayCell extends StatelessWidget {
  final int day;
  final String status;  // 'orange' | 'red' | 'green' | 'gray'
  final ProblemCounts? counts;
  final VoidCallback? onTap;

  const ProblemDayCell({
    super.key,
    required this.day,
    required this.status,
    this.counts,
    this.onTap,
  });

  Color get _statusColor {
    switch (status) {
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _statusColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _statusColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == 'gray' ? Colors.grey : _statusColor,
              ),
            ),
            if (counts != null && counts!.unsolvedReports + counts!.unsolvedProblems > 0)
              Text(
                '${counts!.unsolvedReports + counts!.unsolvedProblems}',
                style: TextStyle(
                  fontSize: 10,
                  color: _statusColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

### 3.3 Provider 추가

`time_table_providers.dart`에 추가:

```dart
/// Monthly problem status provider
final monthlyProblemStatusProvider = FutureProvider.family<
    MonthlyProblemStatusModel,
    ({String storeId, int year, int month})>((ref, params) async {
  final supabase = ref.read(supabaseServiceProvider).client;

  final response = await supabase.rpc(
    'get_monthly_problem_status_v1',
    params: {
      'p_store_id': params.storeId,
      'p_year': params.year,
      'p_month': params.month,
    },
  );

  return MonthlyProblemStatusModel.fromJson(response);
});
```

### 3.4 `timesheets_tab.dart` 수정

기존 `WeekDatesPicker` 위에 월간 캘린더 추가:

```dart
// 기존 Problems 섹션 아래, Timelogs 섹션 위에 추가

// Monthly Calendar Section
const GrayDividerSpace(),

Padding(
  padding: horizontalPadding,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Monthly Overview',
        style: TossTextStyles.h3.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: TossSpacing.space3),

      // Monthly Problem Calendar
      if (widget.selectedStoreId != null)
        MonthlyProblemCalendar(
          storeId: widget.selectedStoreId!,
          initialMonth: DateTime.now(),
          onDayTap: (date, status) {
            // 날짜 탭 시 해당 날짜로 이동
            setState(() {
              _selectedDate = date;
              _currentWeekStart = _getWeekStart(date);
            });

            // 문제가 있는 경우 상세 모달 표시
            if (status.problems.isNotEmpty) {
              _showProblemDetailModal(context, date, status);
            }
          },
        ),
    ],
  ),
),
```

---

## 4. 구현 순서

### Phase 1: RPC 배포
1. ✅ `20251219_get_monthly_problem_status_v1.sql` 작성 완료
2. [ ] Supabase Dashboard에서 SQL 실행
3. [ ] RPC 테스트

### Phase 2: Flutter 모델
1. [ ] `monthly_problem_status_model.dart` 생성
2. [ ] `dart run build_runner build` 실행

### Phase 3: Provider
1. [ ] `monthlyProblemStatusProvider` 추가

### Phase 4: UI 위젯
1. [ ] `problem_day_cell.dart` 생성
2. [ ] `monthly_problem_calendar.dart` 생성
3. [ ] `timesheets_tab.dart` 수정

### Phase 5: 테스트
1. [ ] 월간 캘린더 표시 확인
2. [ ] 색상 코드 확인
3. [ ] 날짜 탭 기능 확인

---

## 5. 색상 레전드

UI에 표시할 레전드:

```
🟠 Orange - Has unresolved report
🔴 Red    - Has unresolved problem
🟢 Green  - All problems solved
⚪ Gray   - No problems
```

---

## 6. 테스트 쿼리

```sql
-- RPC 테스트
SELECT get_monthly_problem_status_v1(
  'your-store-id'::UUID,
  2024,
  12
);
```

---

**문서 끝**
