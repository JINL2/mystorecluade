# 시프트 선택 로직 수정 계획서

## 개요

현재 시프트 선택 로직에서 발견된 문제점들을 수정하기 위한 계획서입니다.

---

## 수정 대상 파일

| 파일 | 역할 | 수정 내용 |
|------|------|----------|
| `attendance_helper_methods.dart` | QR 스캔 시 시프트 선택 | 완료된 시프트 제외 로직 추가 |
| `schedule_shift_finder.dart` | UI에서 시프트 카드 표시 | "오늘" 기준 제거, 평균 시간 기반 전환 |
| `schedule_header.dart` | 시프트 상태 결정 | 시작 전 `upcoming` 처리 |

---

## 문제별 수정 계획

### 문제 1: QR 스캔 시 완료된 시프트 선택됨

**파일**: `lib/features/attendance/presentation/widgets/check_in_out/utils/attendance_helper_methods.dart`

**현재 문제**:
```
시프트 A: 09:00-13:00 (완료)
시프트 B: 15:00-19:00 (예정)
현재: 13:30

→ 시프트 A 선택됨 (가장 가까움)
→ RPC에서 "shift_already_completed" 에러
```

**수정 방법**:
```dart
// findClosestShiftRequestId() 함수에서
// 완료된 시프트 제외
if (card.isCheckedIn && card.isCheckedOut) continue;
```

**수정 후 동작**:
```
시프트 A: 09:00-13:00 (완료) → 스킵
시프트 B: 15:00-19:00 (예정) → 선택됨
→ 체크인 성공
```

---

### 문제 2: 시프트 카드 표시 - "오늘" 기준 문제

**파일**: `lib/features/attendance/presentation/pages/utils/schedule_shift_finder.dart`

**현재 문제**:
```
야간 시프트: 12/19 23:00 ~ 12/20 03:00
현재: 12/20 03:30

→ "오늘(12/20)" 기준으로 찾음
→ 시작일이 12/19라서 시프트가 안 보임
```

**수정 방법**:
- "오늘" 기준 제거
- "가장 최근 완료/진행중/예정" 시프트 찾기
- 평균 시간 기반 전환 로직 추가

**새로운 로직**:
```dart
static ShiftCard? findCurrentShift(List<ShiftCard> shiftCards) {
  final now = DateTime.now();

  // 1. 진행중인 시프트 찾기 (체크인 O, 체크아웃 X)
  for (final card in shiftCards) {
    if (card.isCheckedIn && !card.isCheckedOut) {
      return card; // 최우선
    }
  }

  // 2. 가장 최근 완료된 시프트와 가장 가까운 예정 시프트 찾기
  ShiftCard? lastCompleted;
  ShiftCard? nextUpcoming;

  for (final card in shiftCards) {
    if (!card.isApproved) continue;

    final endTime = parseDateTime(card.shiftEndTime);
    final startTime = parseDateTime(card.shiftStartTime);

    // 완료된 시프트 (체크인 O, 체크아웃 O)
    if (card.isCheckedIn && card.isCheckedOut) {
      if (lastCompleted == null || endTime.isAfter(lastCompletedEndTime)) {
        lastCompleted = card;
      }
    }

    // 예정 시프트 (체크인 X, 시작시간 > 현재)
    if (!card.isCheckedIn && startTime.isAfter(now)) {
      if (nextUpcoming == null || startTime.isBefore(nextUpcomingStartTime)) {
        nextUpcoming = card;
      }
    }
  }

  // 3. 평균 시간 기준으로 어떤 시프트를 보여줄지 결정
  if (lastCompleted != null && nextUpcoming != null) {
    final completedEnd = parseDateTime(lastCompleted.shiftEndTime);
    final upcomingStart = parseDateTime(nextUpcoming.shiftStartTime);

    // 평균 시간 = (완료 종료 + 예정 시작) / 2
    final avgTime = completedEnd.add(
      Duration(milliseconds: upcomingStart.difference(completedEnd).inMilliseconds ~/ 2)
    );

    if (now.isBefore(avgTime)) {
      return lastCompleted; // 완료된 시프트 표시
    } else {
      return nextUpcoming; // 예정 시프트 표시
    }
  }

  // 4. 둘 중 하나만 있으면 그것 반환
  return lastCompleted ?? nextUpcoming;
}
```

---

### 문제 3: 시작 전인데 "undone" 표시

**파일**: `lib/features/attendance/presentation/pages/widgets/schedule_header.dart`

**현재 문제**:
```
시프트: 15:00-19:00
현재: 08:00

→ ShiftStatus.undone 반환 (미완료로 표시)
→ 아직 시작도 안 했는데 결근처럼 보임
```

**수정 방법**:
```dart
ShiftStatus _determineStatus(ShiftCard? card) {
  // ... 기존 체크 ...

  // 오늘 시프트, 체크인 전
  // 현재 시간이 시작 시간 전이면 upcoming
  if (now.isBefore(startDateTime)) {
    return ShiftStatus.upcoming;
  }

  // 현재 시간이 시작 시간 지났는데 체크인 없으면 undone
  return ShiftStatus.undone;
}
```

**수정 후 동작**:
```
시프트: 15:00-19:00

08:00 → upcoming (예정)
15:30, 체크인 없음 → undone (미완료/결근)
15:30, 체크인 있음 → onTime 또는 late
```

---

### 문제 4: 시프트 전환 타이밍

**파일**: `lib/features/attendance/presentation/pages/utils/schedule_shift_finder.dart`

**현재 문제**:
```
시프트 A: 09:00-13:00 (완료)
시프트 B: 15:00-19:00 (예정)

→ 언제 A에서 B로 바뀌어야 하는지 불명확
```

**수정 방법**: 평균 시간 기준 전환

```
평균 시간 = (13:00 + 15:00) / 2 = 14:00

13:30 → 시프트 A 표시 (완료)
14:01 → 시프트 B 표시 (체크인 버튼)
```

---

## 엣지케이스 처리

### 케이스 1: 야간 시프트

```
시프트: 12/19 23:00 ~ 12/20 03:00
```

| 현재 시간 | 체크인 | 체크아웃 | 보여줄 것 | 상태 |
|-----------|--------|----------|-----------|------|
| 12/19 22:00 | X | X | 이 시프트 | upcoming |
| 12/19 23:30 | X | X | 이 시프트 | undone |
| 12/19 23:30 | O | X | 이 시프트 | onTime/late |
| 12/20 03:30 | O | O | 이 시프트 | completed |
| 12/20 10:00 | O | O | 이 시프트 (다음 시프트 없으면) | completed |

**처리 방법**: "오늘" 기준 대신 시프트의 시작/종료 시간과 현재 시간 비교

---

### 케이스 2: 하루에 시프트 2개

```
시프트 A: 09:00-13:00
시프트 B: 15:00-19:00
평균 시간: 14:00
```

| 현재 시간 | A 상태 | B 상태 | 보여줄 것 |
|-----------|--------|--------|-----------|
| 08:00 | 예정 | 예정 | A (더 가까움) |
| 10:00, A 체크인 | 진행중 | 예정 | A (진행중 우선) |
| 13:30, A 완료 | 완료 | 예정 | A (14:00 전) |
| 14:01, A 완료 | 완료 | 예정 | B (14:00 후) |
| 16:00, B 체크인 | 완료 | 진행중 | B (진행중 우선) |

**처리 방법**:
1. 진행중 시프트 최우선
2. 완료+예정 둘 다 있으면 평균 시간 기준
3. 하나만 있으면 그것 표시

---

### 케이스 3: 연속 시프트 (체인)

```
시프트 A: 09:00-13:00
시프트 B: 13:00-17:00 (A와 연속)
시프트 C: 17:00-21:00 (B와 연속)
```

| 현재 시간 | 동작 |
|-----------|------|
| 09:30, QR 스캔 | A 체크인 |
| 13:30, QR 스캔 | RPC가 A 체크아웃 + B 자동처리 |
| 17:30, QR 스캔 | RPC가 B 체크아웃 + C 자동처리 |
| 21:30, QR 스캔 | C 체크아웃 (chain_length: 3) |

**처리 방법**: RPC (`update_shift_requests_v7`)가 연속 시프트 자동 처리. 앱은 결과만 표시.

---

### 케이스 4: 시프트 없는 날

```
오늘 시프트: 없음
어제 시프트: 09:00-17:00 (완료)
내일 시프트: 09:00-17:00 (예정)
```

| 조건 | 보여줄 것 |
|------|-----------|
| findCurrentShift() | null 반환 |
| findClosestUpcomingShift() | 내일 시프트 |
| UI | "No Shift Today" + 내일 시프트 미리보기 |

**처리 방법**:
- `findCurrentShift()` null이면 `findClosestUpcomingShift()` 호출
- 둘 다 null이면 "No Shift" 표시

---

### 케이스 5: 체크인 후 앱 재시작

```
시프트: 09:00-17:00
09:30에 체크인 완료
10:00에 앱 재시작
```

| 상황 | 동작 |
|------|------|
| 앱 시작 | user_shift_cards_v5 호출 |
| 데이터 | actual_start_time 있음, actual_end_time 없음 |
| 상태 | isCheckedIn=true, isCheckedOut=false |
| UI | 진행중 시프트 표시 + 체크아웃 버튼 |

**처리 방법**: 서버 데이터 기준으로 상태 복원 (이미 정상 동작)

---

### 케이스 6: 시프트 시간 중간에 QR 스캔 (체크인 안 함)

```
시프트: 09:00-17:00
현재: 12:00 (체크인 안 함)
QR 스캔
```

| 동작 | 결과 |
|------|------|
| findClosestShiftRequestId() | 이 시프트 선택 |
| RPC 호출 | actual_start_time = 12:00 저장 |
| 결과 | 체크인 성공 (지각으로 처리될 수 있음) |

**처리 방법**: 정상 동작. 지각 여부는 RPC/View에서 계산.

---

### 케이스 7: 시프트 종료 후 체크아웃 안 함

```
시프트: 09:00-17:00
09:30 체크인 완료
현재: 18:00 (체크아웃 안 함)
```

| UI 표시 | QR 스캔 시 |
|---------|-----------|
| 진행중 시프트 + 체크아웃 버튼 | 체크아웃 처리됨 |
| problemDetails.hasNoCheckout = true (다음 새로고침 후) | 초과근무 계산됨 |

**처리 방법**: 정상 동작. 관리자가 나중에 확인 가능.

---

## 수정 순서

1. **schedule_header.dart** - `_determineStatus()` 수정 (문제 3)
2. **schedule_shift_finder.dart** - `findCurrentShift()` 새로 작성 (문제 2, 4)
3. **attendance_helper_methods.dart** - `findClosestShiftRequestId()` 수정 (문제 1)
4. 테스트

---

## 테스트 체크리스트

- [ ] 야간 시프트 (어제 시작 ~ 오늘 종료) 정상 표시
- [ ] 하루 2개 시프트 - 평균 시간 기준 전환
- [ ] 시프트 시작 전 - upcoming 표시
- [ ] 시프트 시작 후 체크인 없음 - undone 표시
- [ ] 완료된 시프트 - completed 표시, 버튼 없음
- [ ] QR 스캔 - 완료된 시프트 건너뛰고 다음 시프트 선택
- [ ] 연속 시프트 체크아웃 - chain_length 정상 처리
- [ ] 시프트 없는 날 - "No Shift" 표시
