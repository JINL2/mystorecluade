# Shift Display Implementation Plan

## 목표

유저가 한눈에 자신의 스케줄 관련 데이터를 파악할 수 있게 하는 것

---

## 1. Current Shift 카드 상태별 UI

### 1.1 체크인 전 - Upcoming (시프트 시작 전)

```
┌─────────────────────────────────────┐
│ Current Shift              Upcoming │  ← 파란색/회색 뱃지
│ Afternoon                           │
│ Sat, 20 Dec 2025                    │
│                                     │
│ Time           14:00 - 17:00        │  ← 예정 시간만
│ Location       Store A              │
│                                     │
│        [ Check-in ]                 │
└─────────────────────────────────────┘
```

### 1.2 체크인 전 - Undone (시프트 시작 후 체크인 안 함)

```
┌─────────────────────────────────────┐
│ Current Shift               Undone  │  ← 빨간색 뱃지
│ Afternoon                           │
│ Sat, 20 Dec 2025                    │
│                                     │
│ Time           14:00 - 17:00        │
│ Location       Store A              │
│                                     │
│ ⚠️ You haven't checked in yet!      │  ← 경고 메시지
│                                     │
│        [ Check-in ]                 │
└─────────────────────────────────────┘
```

### 1.3 체크인 후 - 근무중 (OnTime / Late)

```
┌─────────────────────────────────────┐
│ Current Shift                 Late  │  ← 문제 뱃지 (있으면)
│ Afternoon                           │
│ Sat, 20 Dec 2025                    │
│                                     │
│ Real Time      14:05 - --:--        │  ← 실제 시간
│ Payment Time   14:00 - --:--        │  ← 급여 시간
│ Location       Store A              │
│                                     │
│ ⚠️ Late: 5 minutes                  │  ← 문제 상세
│                                     │
│        [ Check-out ]                │
└─────────────────────────────────────┘
```

### 1.4 체크아웃 후 - Completed

```
┌─────────────────────────────────────┐
│ Current Shift            Completed  │  ← 초록색 뱃지
│ Afternoon                           │
│ Sat, 20 Dec 2025                    │
│                                     │
│ Real Time      14:05 - 17:32        │  ← 실제 시간
│ Payment Time   14:00 - 17:00        │  ← 급여 시간
│ Location       Store A              │
│                                     │
│ ⚠️ Late: 5 minutes                  │  ← 문제 있으면 표시
│ ⏱️ Overtime: 32 minutes             │
│                                     │
│      [ Report Issue ]               │  ← 문제 있으면 보고 버튼
└─────────────────────────────────────┘
```

### 1.5 시프트 없음

```
┌─────────────────────────────────────┐
│ No Shift Today                      │
│                                     │
│ Next shift:                         │
│ Mon, 22 Dec 2025                    │
│ Morning (09:00 - 13:00)             │
│                                     │
│     [ Go to Shift Sign Up ]         │
└─────────────────────────────────────┘
```

---

## 2. 시프트 선택 로직 통합

### 2.1 현재 문제

| 함수 | 용도 | 문제 |
|------|------|------|
| `findTodayShift()` | UI 표시 | "오늘" 필터로 야간 시프트 놓침 |
| `findClosestShiftRequestId()` | QR 스캔 | 완료된 시프트도 선택됨 |

### 2.2 해결: 공통 함수 `findCurrentShift()`

```dart
/// 가장 관련있는 시프트 찾기 (UI + QR 공통)
///
/// [excludeCompleted]: true면 완료된 시프트 제외 (QR용)
static ShiftCard? findCurrentShift(
  List<ShiftCard> shiftCards, {
  bool excludeCompleted = false,
}) {
  final now = DateTime.now();

  // 1순위: 진행중 시프트 (체크인 O, 체크아웃 X)
  for (final card in shiftCards) {
    if (!card.isApproved) continue;
    if (card.isCheckedIn && !card.isCheckedOut) {
      return card;
    }
  }

  // 2순위: 완료된 시프트 vs 예정 시프트 (평균 시간 기준)
  ShiftCard? lastCompleted;
  DateTime? lastCompletedEnd;
  ShiftCard? nextUpcoming;
  DateTime? nextUpcomingStart;

  for (final card in shiftCards) {
    if (!card.isApproved) continue;

    final startTime = _parseDateTime(card.shiftStartTime);
    final endTime = _parseDateTime(card.shiftEndTime);
    if (startTime == null || endTime == null) continue;

    // 완료된 시프트
    if (card.isCheckedIn && card.isCheckedOut) {
      if (excludeCompleted) continue;
      if (lastCompleted == null || endTime.isAfter(lastCompletedEnd!)) {
        lastCompleted = card;
        lastCompletedEnd = endTime;
      }
    }
    // 예정 시프트 (체크인 X)
    else if (!card.isCheckedIn) {
      if (nextUpcoming == null || startTime.isBefore(nextUpcomingStart!)) {
        nextUpcoming = card;
        nextUpcomingStart = startTime;
      }
    }
  }

  // 둘 다 있으면 평균 시간 기준
  if (lastCompleted != null && nextUpcoming != null) {
    final avgTime = lastCompletedEnd!.add(
      Duration(
        milliseconds: nextUpcomingStart!.difference(lastCompletedEnd).inMilliseconds ~/ 2,
      ),
    );

    return now.isBefore(avgTime) ? lastCompleted : nextUpcoming;
  }

  return lastCompleted ?? nextUpcoming;
}
```

### 2.3 사용 방법

```dart
// UI용 (My Schedule 탭)
final currentShift = ScheduleShiftFinder.findCurrentShift(shiftCards);

// QR용 (체크인/체크아웃)
final shiftToCheckIn = ScheduleShiftFinder.findCurrentShift(
  shiftCards,
  excludeCompleted: true,
);
```

---

## 3. 상태 결정 로직 수정

### 3.1 현재 문제

```dart
// 시프트 시작 전인데 undone 반환
return ShiftStatus.undone;  // ← 잘못됨
```

### 3.2 수정된 `_determineStatus()`

```dart
ShiftStatus _determineStatus(ShiftCard? card) {
  if (card == null) return ShiftStatus.noShift;

  final now = DateTime.now();
  final startDateTime = _parseShiftDateTime(card.shiftStartTime);
  final endDateTime = _parseShiftDateTime(card.shiftEndTime);

  if (startDateTime == null || endDateTime == null) return ShiftStatus.noShift;

  // 체크인 + 체크아웃 완료
  if (card.isCheckedIn && card.isCheckedOut) {
    return ShiftStatus.completed;
  }

  // 체크인만 완료 (근무중)
  if (card.isCheckedIn && !card.isCheckedOut) {
    return card.isLate ? ShiftStatus.late : ShiftStatus.onTime;
  }

  // 체크인 전
  if (now.isBefore(startDateTime)) {
    // 시프트 시작 전
    return ShiftStatus.upcoming;
  } else if (now.isBefore(endDateTime)) {
    // 시프트 시간 중인데 체크인 안 함
    return ShiftStatus.undone;
  } else {
    // 시프트 종료 후 체크인 안 함 (결근)
    return ShiftStatus.undone;
  }
}
```

---

## 4. 수정할 파일 목록

| # | 파일 | 수정 내용 |
|---|------|----------|
| 1 | `schedule_shift_finder.dart` | `findCurrentShift()` 새 함수 추가 |
| 2 | `schedule_shift_finder.dart` | `findTodayShift()` deprecated 또는 제거 |
| 3 | `attendance_helper_methods.dart` | `findClosestShiftRequestId()` → `findCurrentShift(excludeCompleted: true)` |
| 4 | `schedule_header.dart` | `_determineStatus()` 수정 - 시작 전 upcoming 처리 |
| 5 | `my_schedule_tab.dart` | `findTodayShift()` → `findCurrentShift()` 호출 변경 |
| 6 | `toss_today_shift_card.dart` | undone 상태일 때 경고 메시지 추가 |

---

## 5. 구현 순서

### Step 1: 공통 함수 작성
- `schedule_shift_finder.dart`에 `findCurrentShift()` 추가
- 단위 테스트 작성

### Step 2: 상태 결정 로직 수정
- `schedule_header.dart`의 `_determineStatus()` 수정
- 시작 전 → upcoming 반환

### Step 3: UI 호출 변경
- `my_schedule_tab.dart`에서 `findCurrentShift()` 사용

### Step 4: QR 스캔 로직 변경
- `attendance_helper_methods.dart`에서 `findCurrentShift(excludeCompleted: true)` 사용

### Step 5: UI 개선
- undone 상태 경고 메시지 추가
- completed 상태 Report Issue 버튼 추가 (문제 있을 때)

---

## 6. 테스트 시나리오

| # | 시나리오 | 예상 UI | 예상 QR |
|---|----------|---------|---------|
| 1 | 시프트 시작 전 (08:00, 시프트 14:00) | Upcoming + Check-in 버튼 | 이 시프트 선택 |
| 2 | 시프트 중 체크인 안 함 (14:30, 시프트 14:00) | Undone + 경고 + Check-in | 이 시프트 선택 |
| 3 | 체크인 완료, 근무중 | OnTime/Late + Check-out | 이 시프트 선택 |
| 4 | 체크아웃 완료 | Completed + 결과 표시 | 다음 시프트 선택 |
| 5 | 야간 시프트 완료 (새벽 2:30) | 야간 시프트 (Completed) | 아침 시프트 선택 |
| 6 | 오전 완료, 오후 예정 (13:30) | 오전 시프트 (평균 14:00 전) | 오후 시프트 선택 |
| 7 | 오전 완료, 오후 예정 (14:30) | 오후 시프트 (평균 14:00 후) | 오후 시프트 선택 |
| 8 | 시프트 없음 | No Shift + 다음 시프트 정보 | null (에러 처리) |

---

## 7. 엣지케이스 처리

### 7.1 야간 시프트
```
시프트: 12/19 23:00 ~ 12/20 02:00
체크아웃: 12/20 02:30

→ "오늘" 필터 없이 가장 최근 완료된 시프트로 표시
→ 다음 시프트와 평균 시간 비교하여 전환
```

### 7.2 하루 2개 시프트
```
시프트 A: 09:00-13:00 (완료)
시프트 B: 15:00-19:00 (예정)
평균: 14:00

13:30 → 시프트 A 표시 (Completed)
14:30 → 시프트 B 표시 (Upcoming)
QR 스캔 → 항상 시프트 B 선택 (완료 제외)
```

### 7.3 연속 시프트
```
시프트 A: 09:00-13:00
시프트 B: 13:00-17:00 (연속)

→ RPC가 연속 시프트 자동 처리
→ 앱은 결과만 표시
```
