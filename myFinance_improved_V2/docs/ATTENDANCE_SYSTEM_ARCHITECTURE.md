# Attendance System Architecture

## 목차
1. [폴더 구조](#1-폴더-구조)
2. [RPC 목록](#2-rpc-목록)
3. [데이터 흐름](#3-데이터-흐름)
4. [시프트 선택 로직](#4-시프트-선택-로직)
5. [문제점 및 해결방안](#5-문제점-및-해결방안)

---

## 1. 폴더 구조

```
lib/features/attendance/
├── data/
│   ├── datasources/
│   │   └── attendance_datasource.dart    # Supabase RPC 호출
│   ├── models/
│   │   ├── shift_card_model.dart         # ShiftCard JSON 매핑
│   │   ├── check_in_result_model.dart    # 체크인 결과 매핑
│   │   └── ...
│   ├── repositories/
│   │   └── attendance_repository_impl.dart
│   └── providers/
│       └── attendance_data_providers.dart
│
├── domain/
│   ├── entities/
│   │   ├── shift_card.dart               # 시프트 카드 엔티티
│   │   ├── check_in_result.dart          # 체크인 결과 엔티티
│   │   ├── problem_details.dart          # 문제 상세 (v5)
│   │   └── ...
│   ├── repositories/
│   │   └── attendance_repository.dart    # Repository 인터페이스
│   ├── usecases/
│   │   ├── check_in_shift.dart           # 체크인/체크아웃 UseCase
│   │   ├── get_user_shift_cards.dart     # 시프트 카드 조회
│   │   └── ...
│   └── providers/
│       └── attendance_repository_provider.dart
│
└── presentation/
    ├── pages/
    │   ├── attendance_main_page.dart     # 메인 페이지 (3개 탭)
    │   ├── my_schedule_tab.dart          # My Schedule 탭
    │   ├── qr_scanner_page.dart          # QR 스캐너
    │   ├── utils/
    │   │   ├── schedule_shift_finder.dart    # 시프트 찾기 로직 ⭐
    │   │   ├── schedule_date_utils.dart
    │   │   ├── schedule_week_builder.dart
    │   │   └── schedule_month_builder.dart
    │   └── widgets/
    │       ├── schedule_header.dart      # 헤더 (Current Shift 카드)
    │       ├── schedule_week_view.dart   # 주간 뷰
    │       └── schedule_month_view.dart  # 월간 뷰
    │
    ├── widgets/
    │   └── check_in_out/
    │       └── utils/
    │           └── attendance_helper_methods.dart  # QR 스캔용 시프트 찾기 ⭐
    │
    └── providers/
        └── attendance_providers.dart     # Riverpod Providers
```

---

## 2. RPC 목록

### 2.1 `user_shift_cards_v5` - 시프트 카드 조회

**용도**: 월별 시프트 카드 목록 조회 (UI 표시용)

**파라미터**:
```sql
p_request_time: timestamp    -- 로컬 시간 (예: "2025-12-15 10:00:00")
p_user_id: uuid              -- 사용자 ID
p_company_id: uuid           -- 회사 ID
p_store_id: uuid             -- 매장 ID
p_timezone: text             -- 타임존 (예: "Asia/Ho_Chi_Minh")
```

**반환값**:
```json
[
  {
    "shift_date": "2025-12-20T14:00:00",
    "shift_request_id": "uuid",
    "shift_name": "Afternoon",
    "shift_start_time": "2025-12-20T14:00:00",
    "shift_end_time": "2025-12-20T17:00:00",
    "scheduled_hours": 3.0,
    "is_approved": true,
    "actual_start_time": "14:05:23",      // 체크인 시간 (HH:MI:SS)
    "actual_end_time": null,               // 체크아웃 시간
    "confirm_start_time": "14:00",         // 급여 계산용 시작 (HH:MI)
    "confirm_end_time": null,              // 급여 계산용 종료
    "paid_hours": 0,
    "base_pay": "0",
    "bonus_amount": 0,
    "total_pay_with_bonus": "0",
    "salary_type": "hourly",
    "salary_amount": "50,000",
    "store_name": "Store A",
    "problem_details": {                   // v5: JSONB로 통합
      "has_late": true,
      "has_overtime": false,
      "late_minutes": 5,
      "problems": [...]
    }
  }
]
```

**호출 위치**: `AttendanceDatasource.getUserShiftCards()`

---

### 2.2 `update_shift_requests_v7` - 체크인/체크아웃

**용도**: QR 스캔 시 체크인 또는 체크아웃 처리

**파라미터**:
```sql
p_shift_request_id: uuid     -- 시프트 요청 ID
p_user_id: uuid              -- 사용자 ID
p_store_id: uuid             -- 매장 ID (QR 코드에서 획득)
p_time: timestamp            -- 로컬 시간
p_lat: double                -- 위도
p_lng: double                -- 경도
p_timezone: text             -- 타임존
```

**반환값**:
```json
// 체크인 성공
{ "status": "attend", "message": "checkin_completed" }

// 체크아웃 성공
{ "status": "check_out", "message": "checkout_completed" }

// 연속 시프트 체크아웃
{ "status": "check_out", "message": "chain_checkout_completed", "chain_length": 3 }

// 에러
{ "status": "error", "message": "shift_already_completed" }
{ "status": "error", "message": "shift_not_found" }
{ "status": "error", "message": "first_shift_no_checkin" }
```

**내부 로직**:
```
1. 시프트 찾기 (shift_request_id로 조회)
2. 연속 시프트 체인 빌드 (end_time = start_time 인 것들)
3. 체인 길이에 따라 처리:
   - 단일 시프트: 체크인 없으면 체크인, 있으면 체크아웃
   - 연속 시프트: 첫 시프트 체크인 확인 후 모든 시프트 체크아웃
```

**호출 위치**: `AttendanceDatasource.updateShiftRequest()`

---

## 3. 데이터 흐름

### 3.1 UI 표시 흐름 (My Schedule 탭)

```
┌─────────────────────────────────────────────────────────────────┐
│                    attendance_main_page.dart                     │
│                         (3개 탭 관리)                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      my_schedule_tab.dart                        │
│                                                                  │
│  1. monthlyShiftCardsProvider(yearMonth) 구독                    │
│  2. ScheduleShiftFinder.findTodayShift(shiftCards) 호출         │
│  3. ScheduleHeader에 todayShift 전달                            │
└─────────────────────────────────────────────────────────────────┘
                              │
           ┌──────────────────┴──────────────────┐
           ▼                                      ▼
┌─────────────────────┐              ┌─────────────────────────┐
│   schedule_header   │              │  schedule_week_view /   │
│      .dart          │              │  schedule_month_view    │
│                     │              │        .dart            │
│ - Current Shift 카드 │              │                         │
│ - Week/Month 토글   │              │ - 시프트 리스트 표시     │
│ - Check-in 버튼     │              │                         │
└─────────────────────┘              └─────────────────────────┘
```

### 3.2 QR 스캔 흐름 (체크인/체크아웃)

```
┌─────────────────────────────────────────────────────────────────┐
│                      qr_scanner_page.dart                        │
│                                                                  │
│  1. QR 스캔 → storeId 획득                                       │
│  2. getUserShiftCards() 호출 → 월별 시프트 목록                  │
│  3. findClosestShiftRequestId() 호출 → 체크인할 시프트 선택     │
│  4. checkInShift() 호출 → update_shift_requests_v7 RPC          │
│  5. 결과 표시 및 데이터 새로고침                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              attendance_helper_methods.dart                      │
│                                                                  │
│  findClosestShiftRequestId(shiftCards):                         │
│    1. 진행중 시프트 (start <= now <= end) → 즉시 반환           │
│    2. 과거 시프트 중 가장 가까운 것 (endTime 기준)               │
│    3. 미래 시프트 중 가장 가까운 것 (startTime 기준)             │
│    4. 날짜 검증: startDate 또는 endDate가 오늘                   │
│    5. 거리 비교하여 반환                                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   update_shift_requests_v7                       │
│                        (RPC)                                     │
│                                                                  │
│  1. shift_request_id로 시프트 조회                               │
│  2. 연속 시프트 체인 빌드                                        │
│  3. 체크인 또는 체크아웃 처리                                    │
│  4. 결과 반환                                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. 시프트 선택 로직

### 4.1 UI용: `findTodayShift()`

**파일**: `schedule_shift_finder.dart`

**현재 로직**:
```dart
1. "오늘" 날짜에 해당하는 시프트만 필터링
   - startDate가 오늘 OR endDate가 오늘

2. 여러 시프트가 있으면 우선순위:
   - 진행중 시프트 (now가 start~end 사이)
   - 가장 가까운 시프트 (시간 거리 기준)
```

**문제점**: "오늘" 필터 때문에 야간 시프트 놓침

---

### 4.2 QR용: `findClosestShiftRequestId()`

**파일**: `attendance_helper_methods.dart`

**현재 로직**:
```dart
1. 진행중 시프트 (start <= now <= end) → 즉시 반환

2. 과거 시프트 중 가장 가까운 것 찾기
   - 거리 = now - endTime

3. 미래 시프트 중 가장 가까운 것 찾기
   - 거리 = startTime - now

4. 날짜 검증
   - startDate 또는 endDate가 오늘이어야 유효

5. 유효한 것 중 거리가 가까운 것 반환
```

**문제점**: 완료된 시프트도 선택될 수 있음

---

## 5. 문제점 및 해결방안

### 5.1 문제 요약

| # | 문제 | 영향 | 위치 |
|---|------|------|------|
| 1 | 완료된 시프트가 QR 스캔 시 선택됨 | "shift_already_completed" 에러 | `findClosestShiftRequestId()` |
| 2 | UI에서 야간 시프트가 안 보임 | 체크아웃 직후 다음 시프트로 넘어감 | `findTodayShift()` |
| 3 | 시프트 시작 전인데 "undone" 표시 | 잘못된 상태 표시 | `_determineStatus()` |
| 4 | UI와 QR 로직 불일치 | 사용자 혼란 | 두 함수 모두 |

---

### 5.2 해결방안: 통합 로직

**핵심 아이디어**: UI와 QR이 같은 로직을 사용해야 함

```dart
/// 가장 관련있는 시프트 찾기 (UI + QR 공통)
static ShiftCard? findCurrentShift(
  List<ShiftCard> shiftCards, {
  bool excludeCompleted = false,  // QR용: true, UI용: false
}) {
  final now = DateTime.now();

  // 1순위: 진행중 시프트 (체크인 O, 체크아웃 X)
  for (final card in shiftCards) {
    if (card.isCheckedIn && !card.isCheckedOut) {
      return card;
    }
  }

  // 완료된 시프트와 예정 시프트 분리
  ShiftCard? lastCompleted;
  DateTime? lastCompletedEnd;
  ShiftCard? nextUpcoming;
  DateTime? nextUpcomingStart;

  for (final card in shiftCards) {
    if (!card.isApproved) continue;

    final startTime = parseDateTime(card.shiftStartTime);
    final endTime = parseDateTime(card.shiftEndTime);
    if (startTime == null || endTime == null) continue;

    // 완료된 시프트 (체크인 O, 체크아웃 O)
    if (card.isCheckedIn && card.isCheckedOut) {
      if (excludeCompleted) continue;  // QR용이면 스킵

      if (lastCompleted == null || endTime.isAfter(lastCompletedEnd!)) {
        lastCompleted = card;
        lastCompletedEnd = endTime;
      }
    }
    // 예정 시프트 (체크인 X, 아직 시작 안 함)
    else if (!card.isCheckedIn && startTime.isAfter(now)) {
      if (nextUpcoming == null || startTime.isBefore(nextUpcomingStart!)) {
        nextUpcoming = card;
        nextUpcomingStart = startTime;
      }
    }
    // 시작했는데 체크인 안 한 시프트 (undone)
    else if (!card.isCheckedIn && endTime.isAfter(now)) {
      // 체크인 가능한 시프트
      if (nextUpcoming == null || startTime.isBefore(nextUpcomingStart!)) {
        nextUpcoming = card;
        nextUpcomingStart = startTime;
      }
    }
  }

  // 2순위: 완료 + 예정 둘 다 있으면 평균 시간 기준
  if (lastCompleted != null && nextUpcoming != null) {
    final avgTime = lastCompletedEnd!.add(
      Duration(
        milliseconds: nextUpcomingStart!.difference(lastCompletedEnd).inMilliseconds ~/ 2,
      ),
    );

    if (now.isBefore(avgTime)) {
      return lastCompleted;  // 완료된 시프트 표시
    } else {
      return nextUpcoming;   // 예정 시프트 표시
    }
  }

  // 3순위: 하나만 있으면 그것 반환
  return lastCompleted ?? nextUpcoming;
}
```

---

### 5.3 수정할 파일 목록

| 파일 | 수정 내용 |
|------|----------|
| `schedule_shift_finder.dart` | `findTodayShift()` → `findCurrentShift()` 사용 |
| `attendance_helper_methods.dart` | `findClosestShiftRequestId()` → `findCurrentShift(excludeCompleted: true)` 사용 |
| `schedule_header.dart` | `_determineStatus()` - 시작 전 upcoming 처리 |

---

### 5.4 테스트 시나리오

| # | 시나리오 | 예상 결과 |
|---|----------|-----------|
| 1 | 야간 시프트 체크아웃 직후 (새벽 2:30) | UI: 야간 시프트 (completed) |
| 2 | 야간 시프트 체크아웃 후 아침 (08:00) | UI: 아침 시프트 (upcoming) |
| 3 | 오전 시프트 완료 (13:30), 오후 시프트 있음 | UI: 오전 시프트 (평균 14:00 전) |
| 4 | 오전 시프트 완료 (14:30), 오후 시프트 있음 | UI: 오후 시프트 (평균 14:00 후) |
| 5 | 오전 시프트 완료, QR 스캔 | QR: 오후 시프트 선택 (완료 제외) |
| 6 | 시프트 시작 전 (08:00, 시프트 15:00) | UI: upcoming 상태 |
| 7 | 시프트 시작 후 체크인 안 함 (16:00, 시프트 15:00) | UI: undone 상태 |
