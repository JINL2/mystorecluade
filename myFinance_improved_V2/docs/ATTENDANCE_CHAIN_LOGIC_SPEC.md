# 출퇴근 연속 체인 로직 명세서

> **Version**: v2.1 (2025-01-05)
> **Author**: Claude
> **Last Updated**: 2025-01-05
>
> **v2.1 변경사항**: Client에서 체인 중간 시프트 개별 체크인 검증 추가 (Issue #1 해결)

---

## 목차

1. [개요](#1-개요)
2. [핵심 컴포넌트](#2-핵심-컴포넌트)
3. [Shift ID 선택 로직](#3-shift-id-선택-로직)
4. [연속 체인 감지 로직](#4-연속-체인-감지-로직)
5. [Grace Period 계산 로직](#5-grace-period-계산-로직)
6. [체크아웃 Shift 선택 로직](#6-체크아웃-shift-선택-로직)
7. [UI Check-in/Check-out 표시 로직](#7-ui-check-incheck-out-표시-로직)
8. [서버 RPC 로직](#8-서버-rpc-로직)
9. [Edge Case 분석](#9-edge-case-분석)
10. [동기화 검증](#10-동기화-검증)

---

## 1. 개요

### 1.1 문제 상황

연속 시프트(예: 오전 10:00~15:00, 오후 15:00~20:00, 야간 20:00~02:00)에서 직원이 오전에 체크인 후 새벽 2시에 체크아웃하려고 할 때:

- **기존 문제**: Grace period가 첫 시프트(오전)의 end_time(15:00) 기준으로 계산되어, 새벽 2시에는 이미 만료됨
- **결과**: 체크아웃 대신 다음 날 오전 시프트에 체크인이 됨

### 1.2 해결 방안

Grace period를 **체인의 마지막 시프트 end_time** 기준으로 계산하도록 변경

```
Before: grace_period = first_shift.end_time + 3h = 15:00 + 3h = 18:00
After:  grace_period = chain_last.end_time + 3h = 02:00 + 3h = 05:00
```

---

## 2. 핵심 컴포넌트

### 2.1 파일 구조

```
lib/features/attendance/
├── presentation/
│   ├── pages/
│   │   ├── utils/
│   │   │   ├── schedule_date_utils.dart      # 체인 감지, grace period 계산
│   │   │   └── schedule_shift_finder.dart    # UI용 shift 찾기
│   │   └── widgets/
│   │       └── schedule_header.dart          # UI 상태 결정
│   └── widgets/
│       └── check_in_out/
│           └── utils/
│               └── attendance_helper_methods.dart  # QR 스캔용 shift ID 선택
└── data/
    └── datasources/
        └── attendance_datasource.dart        # RPC 호출
```

### 2.2 핵심 상수

```dart
// schedule_date_utils.dart
static const int defaultGraceHours = 3;      // 기본 체크아웃 유예 시간
static const int maxGraceHours = 6;          // 최대 체크아웃 유예 시간
static const int bufferMinutes = 15;         // 다음 시프트 시작 전 버퍼
static const int chainThresholdMinutes = 5;  // 연속 체인 판정 시간 차이
```

---

## 3. Shift ID 선택 로직

### 3.1 함수 정보

- **파일**: `attendance_helper_methods.dart`
- **함수**: `AttendanceHelpers.findClosestShiftRequestId()`
- **용도**: QR 스캔 시 서버로 보낼 shift_request_id 결정

### 3.2 알고리즘

```
┌─────────────────────────────────────────────────────────────┐
│                  findClosestShiftRequestId()                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Input: shiftCards (List<ShiftCard>), now (DateTime)        │
│                                                             │
│  Step 1: detectContinuousChain(shiftCards, now)             │
│          └─ 체인 감지 + grace period 체크                    │
│                                                             │
│  Step 2: chain.shouldCheckout == true?                      │
│          │                                                  │
│          ├─ YES → findClosestCheckoutShift(chain, now)      │
│          │        └─ return checkoutShift.shiftRequestId    │
│          │                                                  │
│          └─ NO  → findClosestCheckinShift(shiftCards, now)  │
│                   └─ return checkinShift.shiftRequestId     │
│                                                             │
│  Step 3: 둘 다 없으면 null 반환                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 코드

```dart
static String? findClosestShiftRequestId(
  List<ShiftCard> shiftCards, {
  DateTime? now,
}) {
  if (shiftCards.isEmpty) return null;
  final currentTime = now ?? DateTime.now();

  // PRIORITY 1: 체인 감지 (grace period 포함)
  final chain = ScheduleDateUtils.detectContinuousChain(
    shiftCards,
    currentTime: currentTime,
  );

  // CHECKOUT MODE
  if (chain.shouldCheckout) {
    final checkoutShift = ScheduleDateUtils.findClosestCheckoutShift(
      chain,
      currentTime: currentTime,
    );
    if (checkoutShift != null) {
      return checkoutShift.shiftRequestId;
    }
  }

  // CHECKIN MODE
  final checkinShift = ScheduleDateUtils.findClosestCheckinShift(
    shiftCards,
    currentTime: currentTime,
  );
  return checkinShift?.shiftRequestId;
}
```

---

## 4. 연속 체인 감지 로직

### 4.1 함수 정보

- **파일**: `schedule_date_utils.dart`
- **함수**: `ScheduleDateUtils.detectContinuousChain()`
- **용도**: 연속된 시프트 체인 감지 및 체크아웃 가능 여부 판단

### 4.2 알고리즘 (v2 - Chain-first Approach)

```
┌─────────────────────────────────────────────────────────────┐
│                   detectContinuousChain()                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Step 1: Find checked-in shift (grace period 체크 없이!)    │
│  ┌───────────────────────────────────────────────┐          │
│  │ for card in shiftCards:                        │          │
│  │   if isApproved && isCheckedIn && !isCheckedOut: │        │
│  │     inProgressShift = card                     │          │
│  │     break                                      │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 2: Sort shifts by start_time                          │
│                                                             │
│  Step 3: Build chain forward from inProgressShift           │
│  ┌───────────────────────────────────────────────┐          │
│  │ chainShifts = [inProgressShift]                │          │
│  │ currentEndTime = inProgressShift.endTime       │          │
│  │                                                │          │
│  │ for shift in sortedShifts:                     │          │
│  │   if |shift.startTime - currentEndTime| ≤ 1분: │          │
│  │     chainShifts.add(shift)                     │          │
│  │     currentEndTime = shift.endTime             │          │
│  │     chainLastEndTime = shift.endTime           │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 4: Grace period check (CHAIN'S LAST end_time 기준!)   │
│  ┌───────────────────────────────────────────────┐          │
│  │ if now > chainLastEndTime:                     │          │
│  │   chainShiftIds = chainShifts.map(id).toSet()  │          │
│  │   nextShiftStart = findNextShift(              │          │
│  │     excludeShiftIds: chainShiftIds             │          │
│  │   )                                            │          │
│  │   if !isWithinCheckoutWindow(...):             │          │
│  │     return ChainDetectionResult.empty          │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 5: Return result                                      │
│  ┌───────────────────────────────────────────────┐          │
│  │ return ChainDetectionResult(                   │          │
│  │   inProgressShift: Morning,                    │          │
│  │   chainShifts: [Morning, Afternoon, Night],    │          │
│  │   chainLastEndTime: Night.endTime,             │          │
│  │   shouldCheckout: true,                        │          │
│  │ )                                              │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.3 핵심 변경 사항 (v1 → v2)

| 항목 | v1 (기존) | v2 (수정) |
|------|-----------|-----------|
| Grace period 기준 | 첫 시프트 end_time | **체인 마지막 end_time** |
| 다음 시프트 검색 | 모든 시프트 대상 | **체인 시프트 제외** |
| 체인 빌드 시점 | Grace period 체크 후 | **Grace period 체크 전** |

### 4.4 코드

```dart
static ChainDetectionResult detectContinuousChain(
  List<ShiftCard> shiftCards, {
  DateTime? currentTime,
}) {
  if (shiftCards.isEmpty) return ChainDetectionResult.empty;
  final now = currentTime ?? DateTime.now();

  // Step 1: Find checked-in shift (WITHOUT grace period check)
  ShiftCard? inProgressShift;
  for (final card in shiftCards) {
    if (card.isApproved && card.isCheckedIn && !card.isCheckedOut) {
      inProgressShift = card;
      break;
    }
  }
  if (inProgressShift == null) return ChainDetectionResult.empty;

  // Step 2-3: Build chain forward
  final chainShifts = <ShiftCard>[inProgressShift];
  DateTime? currentEndTime = parseShiftDateTime(inProgressShift.shiftEndTime);
  DateTime? chainLastEndTime = currentEndTime;

  // ... (chain building logic)

  // Step 4: Grace period check using CHAIN'S LAST end_time
  if (chainLastEndTime != null && now.isAfter(chainLastEndTime)) {
    final chainShiftIds = chainShifts.map((s) => s.shiftRequestId).toSet();
    final nextShiftStart = findNextShiftStartTime(
      shiftCards,
      chainLastEndTime,
      excludeShiftIds: chainShiftIds,  // 체인 시프트 제외!
    );
    if (!isWithinCheckoutWindow(chainLastEndTime, nextShiftStart, now)) {
      return ChainDetectionResult.empty;  // Grace period 만료
    }
  }

  return ChainDetectionResult(
    inProgressShift: inProgressShift,
    chainLastEndTime: chainLastEndTime,
    chainShifts: chainShifts,
    shouldCheckout: true,
  );
}
```

---

## 5. Grace Period 계산 로직

### 5.1 함수 정보

- **파일**: `schedule_date_utils.dart`
- **함수**: `calculateCheckoutDeadline()`, `isWithinCheckoutWindow()`

### 5.2 규칙

```
┌─────────────────────────────────────────────────────────────┐
│                    Grace Period Rules                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  calculateCheckoutDeadline(shiftEnd, nextShiftStart)        │
│                                                             │
│  Case 1: 다음 시프트 없음                                    │
│  └─ deadline = shiftEnd + 3시간                             │
│                                                             │
│  Case 2: 다음 시프트 5분 이내 (연속 체인)                    │
│  └─ deadline = nextShiftStart (체인으로 처리)               │
│                                                             │
│  Case 3: 다음 시프트 3시간 이내                              │
│  └─ deadline = nextShiftStart - 15분                        │
│                                                             │
│  Case 4: 다음 시프트 3시간 이상                              │
│  └─ deadline = shiftEnd + 3시간 (max 6시간)                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.3 예시 테이블

| shiftEnd | nextStart | Gap | Deadline | 설명 |
|----------|-----------|-----|----------|------|
| 01:00 | 01:05 | 5분 | 01:05 | 연속 체인 |
| 01:00 | 02:00 | 1시간 | 01:45 | 시작 15분 전 |
| 01:00 | 03:00 | 2시간 | 02:45 | 시작 15분 전 |
| 01:00 | 08:00 | 7시간 | 04:00 | 기본 3시간 |
| 01:00 | 3일 후 | 72시간 | 04:00 | 기본 3시간 |
| 01:00 | null | - | 04:00 | 기본 3시간 |

### 5.4 코드

```dart
static DateTime calculateCheckoutDeadline(
  DateTime shiftEnd,
  DateTime? nextShiftStart,
) {
  final defaultDeadline = shiftEnd.add(Duration(hours: defaultGraceHours));
  final maxDeadline = shiftEnd.add(Duration(hours: maxGraceHours));

  if (nextShiftStart == null) {
    return defaultDeadline;
  }

  final gap = nextShiftStart.difference(shiftEnd);

  // 연속 시프트 (5분 이내)
  if (gap.inMinutes <= chainThresholdMinutes) {
    return nextShiftStart;
  }

  // 다음 시프트가 grace period 이내
  if (gap.inHours < defaultGraceHours) {
    final beforeNextShift = nextShiftStart.subtract(
      Duration(minutes: bufferMinutes),
    );
    return beforeNextShift.isAfter(shiftEnd) ? beforeNextShift : shiftEnd;
  }

  // 기본: 3시간 (최대 6시간)
  return defaultDeadline.isBefore(maxDeadline) ? defaultDeadline : maxDeadline;
}
```

---

## 6. 체크아웃 Shift 선택 로직

### 6.1 함수 정보

- **파일**: `schedule_date_utils.dart`
- **함수**: `findClosestCheckoutShift()`
- **용도**: 체인 내에서 체크아웃할 시프트 결정

### 6.2 알고리즘

```
┌─────────────────────────────────────────────────────────────┐
│                  findClosestCheckoutShift()                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Input: ChainDetectionResult, currentTime                   │
│                                                             │
│  Step 1: 아직 끝나지 않은 시프트 찾기                        │
│  ┌───────────────────────────────────────────────┐          │
│  │ for shift in chainShifts (sorted by startTime): │         │
│  │   if shift.endTime > now:                      │          │
│  │     return shift  ← 아직 진행 중인 시프트       │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 2: 모두 끝났으면 end_time이 now와 가장 가까운 시프트   │
│  ┌───────────────────────────────────────────────┐          │
│  │ for shift in chainShifts:                      │          │
│  │   diff = |now - shift.endTime|                 │          │
│  │   if diff < smallestDiff:                      │          │
│  │     closestShift = shift                       │          │
│  │ return closestShift                            │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.3 예시

체인: Morning(10:00~15:00), Afternoon(15:00~20:00), Night(20:00~02:00)

| 현재 시간 | 선택된 Shift | 이유 |
|----------|-------------|------|
| 10:00 | Morning | Morning 안 끝남 (15:00 > 10:00) |
| 14:30 | Morning | Morning 안 끝남 (15:00 > 14:30) |
| 16:00 | Afternoon | Morning 끝남, Afternoon 안 끝남 (20:00 > 16:00) |
| 21:00 | Night | Morning/Afternoon 끝남, Night 안 끝남 (02:00 > 21:00) |
| 01:00 | Night | Night 안 끝남 (02:00 > 01:00) |
| 02:30 | Night | 모두 끝남, Night의 02:00이 02:30에 가장 가까움 |
| 03:00 | Night | 모두 끝남, Night의 02:00이 03:00에 가장 가까움 |

---

## 7. UI Check-in/Check-out 표시 로직

### 7.1 함수 정보

- **파일**: `schedule_header.dart`
- **함수**: `_determineStatus()`
- **용도**: TossTodayShiftCard에 표시할 버튼 결정

### 7.2 알고리즘

```
┌─────────────────────────────────────────────────────────────┐
│                     _determineStatus()                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Input: ShiftCard card, bool isPartOfInProgressChain        │
│                                                             │
│  // 미래 시프트                                              │
│  if startDate > today:                                      │
│    return ShiftStatus.upcoming → "Check-in" 버튼            │
│                                                             │
│  // 완료된 시프트                                            │
│  if card.isCheckedIn && card.isCheckedOut:                  │
│    return ShiftStatus.completed → "Report" 버튼             │
│                                                             │
│  // 체크인 완료, 체크아웃 대기                               │
│  if card.isCheckedIn && !card.isCheckedOut:                 │
│    return onTime/late → "Check-out" 버튼                    │
│                                                             │
│  // ✅ 핵심: 연속 체인의 일부                                │
│  if isPartOfInProgressChain && !card.isCheckedOut:          │
│    return ShiftStatus.inProgress → "Check-out" 버튼 ✅      │
│                                                             │
│  // 과거 시프트인데 체크인 안함                              │
│  if endDate < today:                                        │
│    return ShiftStatus.undone → "Check-in" 버튼              │
│                                                             │
│  // 기타                                                    │
│  return ShiftStatus.upcoming → "Check-in" 버튼              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 7.3 isPartOfInProgressChain 결정 과정

```dart
// my_schedule_tab.dart
final result = ScheduleShiftFinder.findCurrentShiftWithChainInfo(todayShiftCards);
final currentShift = result.shift;
final isPartOfInProgressChain = result.isPartOfInProgressChain;

// schedule_shift_finder.dart
static CurrentShiftResult findCurrentShiftWithChainInfo(...) {
  final chain = ScheduleDateUtils.detectContinuousChain(shiftCards);

  if (chain.hasChain && chain.shouldCheckout) {
    final checkoutShift = ScheduleDateUtils.findClosestCheckoutShift(chain);

    // 반환된 시프트가 inProgressShift와 다르면 체인의 일부
    final isChainShift = checkoutShift.shiftRequestId !=
                         chain.inProgressShift?.shiftRequestId;

    return CurrentShiftResult(
      shift: checkoutShift,
      isPartOfInProgressChain: isChainShift,  // Night은 true
    );
  }
}
```

---

## 8. 서버 RPC 로직

### 8.1 함수 정보

- **위치**: Supabase Database Function
- **이름**: `update_shift_requests_v8`
- **용도**: 체크인/체크아웃 처리

### 8.2 알고리즘

```
┌─────────────────────────────────────────────────────────────┐
│                  update_shift_requests_v8                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Input: p_shift_request_id, p_user_id, p_store_id, p_time   │
│                                                             │
│  Step 1: Get requested shift                                │
│  ┌───────────────────────────────────────────────┐          │
│  │ SELECT * FROM shift_requests                   │          │
│  │ WHERE shift_request_id = p_shift_request_id    │          │
│  │   AND is_approved = TRUE                       │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 2: Build FULL backward chain (1분 tolerance)          │
│  ┌───────────────────────────────────────────────┐          │
│  │ v_continuous_chain = [p_shift_request_id]      │          │
│  │                                                │          │
│  │ LOOP:                                          │          │
│  │   Find prev_shift where:                       │          │
│  │     |prev.end_time - chain[0].start_time| ≤ 1분│          │
│  │   Prepend to chain                             │          │
│  │ END LOOP                                       │          │
│  │                                                │          │
│  │ Result: [Morning, Afternoon, Night]            │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 3: Find first checked-in shift in chain               │
│  ┌───────────────────────────────────────────────┐          │
│  │ FOR i IN 1..chain_length:                      │          │
│  │   IF chain[i].actual_start_time IS NOT NULL:   │          │
│  │     v_checkin_shift = chain[i]                 │          │
│  │     v_checkin_index = i                        │          │
│  │     EXIT                                       │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 4A: Chain checkout (chain_length >= 2 && checkin found)│
│  ┌───────────────────────────────────────────────┐          │
│  │ -- First shift (checkin_shift)                 │          │
│  │ UPDATE SET actual_end = end_time_utc           │          │
│  │                                                │          │
│  │ -- Middle shifts                               │          │
│  │ UPDATE SET actual_start = start_time_utc,      │          │
│  │            actual_end = end_time_utc           │          │
│  │                                                │          │
│  │ -- Last shift (requested)                      │          │
│  │ UPDATE SET actual_start = start_time_utc,      │          │
│  │            actual_end = v_time_utc (스캔시간)  │          │
│  │                                                │          │
│  │ RETURN 'check_out', chain_length: N            │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
│  Step 4B: Single shift (no chain or no checkin)             │
│  ┌───────────────────────────────────────────────┐          │
│  │ IF actual_start IS NULL:                       │          │
│  │   UPDATE SET actual_start = v_time_utc         │          │
│  │   RETURN 'attend'                              │          │
│  │ ELSE:                                          │          │
│  │   UPDATE SET actual_end = v_time_utc           │          │
│  │   RETURN 'check_out'                           │          │
│  └───────────────────────────────────────────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. Edge Case 분석

### 9.1 Case 1: 정상 연속 시프트 (새벽 2시 30분 체크아웃)

**시나리오**:
- Morning(10:00~15:00): 체크인 완료
- Afternoon(15:00~20:00): 체크인 없음 (연속)
- Night(20:00~02:00): 체크인 없음 (연속)
- 현재 시간: 02:30 AM (다음날)

**각 컴포넌트 동작**:

| 컴포넌트 | 함수 | 동작 | 결과 |
|---------|------|------|------|
| **Client** | `detectContinuousChain()` | inProgressShift=Morning, chainLastEndTime=02:00, grace check: 02:30 < 05:00 | shouldCheckout=true |
| **Client** | `findClosestCheckoutShift()` | 모두 끝남, Night의 02:00이 02:30에 가장 가까움 | Night 반환 |
| **Client** | `findClosestShiftRequestId()` | - | Night.shiftRequestId |
| **UI** | `findCurrentShiftWithChainInfo()` | shift=Night, Night.id ≠ Morning.id | isPartOfInProgressChain=true |
| **UI** | `_determineStatus()` | isPartOfInProgressChain=true && !isCheckedOut | ShiftStatus.inProgress |
| **UI** | Button | - | **"Check-out" 버튼** ✅ |
| **Server** | `update_shift_requests_v8` | backward chain=[M,A,N], checkin=Morning | 체인 체크아웃 처리 |

**결과**: ✅ 성공 - Check-out 버튼 표시, Night ID로 RPC 호출, 서버에서 3개 시프트 일괄 체크아웃

---

### 9.2 Case 2: Grace Period 만료 후 다음 날 시프트 체크인

**시나리오**:
- Night(20:00~01:00): 체크인 완료, 체크아웃 안함
- 다음날 Morning(10:00~15:00): 승인됨
- 현재 시간: 05:30 AM (Night 종료 후 4시간 30분)

**각 컴포넌트 동작**:

| 컴포넌트 | 함수 | 동작 | 결과 |
|---------|------|------|------|
| **Client** | `detectContinuousChain()` | inProgressShift=Night, chainLastEndTime=01:00, grace check: 05:30 > 04:00 | **ChainDetectionResult.empty** |
| **Client** | `findClosestCheckinShift()` | 오늘 시프트 중 Morning의 10:00이 가장 가까움 | Morning 반환 |
| **Client** | `findClosestShiftRequestId()` | - | Morning.shiftRequestId |
| **UI** | `findCurrentShiftWithChainInfo()` | chain.hasChain=false | shift=Morning, isPartOfInProgressChain=false |
| **UI** | `_determineStatus()` | !isCheckedIn && today | ShiftStatus.upcoming |
| **UI** | Button | - | **"Check-in" 버튼** ✅ |
| **Server** | `update_shift_requests_v8` | single shift 처리 | Morning 체크인 |

**결과**: ✅ 성공 - Night는 no_checkout 상태로 남고, Morning에 새로 체크인

---

### 9.3 Case 3: 다음 시프트가 가까울 때 (Grace Period 단축)

**시나리오**:
- Morning(10:00~15:00): 체크인 완료
- Afternoon(16:00~20:00): 승인됨 (1시간 gap - 연속 아님)
- 현재 시간: 15:50 (Morning 종료 후 50분)

**Grace Period 계산**:
- gap = 16:00 - 15:00 = 1시간 < 3시간
- deadline = 16:00 - 15분 = **15:45**
- 15:50 > 15:45 → **Grace period 만료!**

**각 컴포넌트 동작**:

| 컴포넌트 | 함수 | 동작 | 결과 |
|---------|------|------|------|
| **Client** | `detectContinuousChain()` | chainLastEndTime=15:00, nextShift=16:00, deadline=15:45, 15:50 > 15:45 | **empty** |
| **Client** | `findClosestCheckinShift()` | Afternoon의 16:00이 가장 가까움 | Afternoon |
| **UI** | `_determineStatus()` | !isCheckedIn && startTime > now | upcoming |
| **UI** | Button | - | **"Check-in" 버튼** |

**결과**: Morning은 no_checkout, Afternoon에 새로 체크인 가능

---

### 9.4 Case 4: 체인 중간 시프트에 개별 체크인이 있는 경우

**시나리오**:
- Morning(10:00~15:00): 체크인 완료
- Afternoon(15:00~20:00): **개별 체크인 있음** (비정상)
- Night(20:00~02:00): 체크인 없음
- 현재 시간: 22:00

**각 컴포넌트 동작** (v2.1 - Client 검증 추가):

| 컴포넌트 | 함수 | 동작 | 결과 |
|---------|------|------|------|
| **Client** | `detectContinuousChain()` | inProgressShift=Morning, chain building... | chain=[Morning, Afternoon, Night] |
| **Client** | Step 3.5 validation | `chainShifts[1].isCheckedIn == true` 감지 | **errorCode='chain_has_separate_checkin'** |
| **Client** | `findClosestShiftRequestId()` | `chain.hasError == true` → 체크아웃 모드 스킵 | Sentry 로깅 후 체크인 모드로 전환 |
| **Server** | validation (fallback) | chain[i].actual_start IS NOT NULL (i > checkin_index) | **ERROR: chain_shift_has_separate_checkin** |

**결과**: ✅ 개선됨 - Client에서 미리 감지하여 Sentry 로깅, 체크아웃 모드 비활성화

**코드 변경 (v2.1)**:
```dart
// schedule_date_utils.dart - Step 3.5
for (int i = 1; i < chainShifts.length; i++) {
  final middleShift = chainShifts[i];
  if (middleShift.isCheckedIn) {
    return ChainDetectionResult(
      // ...
      shouldCheckout: false,
      errorCode: 'chain_has_separate_checkin',
    );
  }
}
```

---

### 9.5 Case 5: 야간 시프트만 단독 (체인 없음)

**시나리오**:
- Night(20:00~02:00): 체크인 완료
- 현재 시간: 02:30 AM

**각 컴포넌트 동작**:

| 컴포넌트 | 함수 | 동작 | 결과 |
|---------|------|------|------|
| **Client** | `detectContinuousChain()` | inProgressShift=Night, chain=[Night] only | chainLastEndTime=02:00 |
| **Client** | grace check | 02:30 < 05:00 (02:00+3h) | shouldCheckout=true |
| **Client** | `findClosestCheckoutShift()` | Night.endTime=02:00 < now=02:30, Night이 가장 가까움 | Night |
| **UI** | `_determineStatus()` | Night.isCheckedIn=true | inProgress |
| **UI** | Button | - | **"Check-out" 버튼** ✅ |
| **Server** | `update_shift_requests_v8` | single shift (chain_length=1) | Night 체크아웃 |

**결과**: ✅ 성공 - 단독 야간 시프트도 정상 처리

---

### 9.6 Case 6: 빈 시프트 목록

**시나리오**:
- shiftCards = [] (빈 배열)

**각 컴포넌트 동작**:

| 컴포넌트 | 함수 | 결과 |
|---------|------|------|
| **Client** | `findClosestShiftRequestId()` | return null |
| **UI** | `findCurrentShiftWithChainInfo()` | shift=null |
| **UI** | `_determineStatus(null)` | ShiftStatus.noShift |
| **UI** | Display | 빈 상태 표시 |

**결과**: ✅ 안전하게 처리됨

---

### 9.7 Case 7: 체인 마지막 시프트가 아직 진행 중

**시나리오**:
- Morning(10:00~15:00): 체크인 완료
- Afternoon(15:00~20:00): 체크인 없음 (연속)
- Night(20:00~02:00): 체크인 없음 (연속)
- 현재 시간: 21:00 (Night 진행 중)

**각 컴포넌트 동작**:

| 컴포넌트 | 함수 | 동작 | 결과 |
|---------|------|------|------|
| **Client** | `detectContinuousChain()` | chainLastEndTime=02:00, 21:00 < 02:00 | grace check skip (아직 안끝남) |
| **Client** | `findClosestCheckoutShift()` | Night.endTime=02:00 > now=21:00 | **Night** (아직 안끝난 시프트) |
| **UI** | Button | - | **"Check-out" 버튼** ✅ |

**결과**: ✅ 진행 중인 Night 시프트로 체크아웃 가능

---

### 9.8 Case 8: 다음 날로 넘어가는 야간 시프트의 날짜 처리

**시나리오**:
- Dec 4 Night(20:00~02:00): 체크인 완료
- Dec 5 Morning(10:00~15:00): 승인됨 (다음 날)
- 현재 시간: Dec 5 01:30 AM

**핵심 포인트**: Night의 end_time은 Dec 5 02:00이지만, shift_date는 Dec 4

**각 컴포넌트 동작**:

| 컴포넌트 | 동작 | 결과 |
|---------|------|------|
| **Client** | chainLastEndTime = Dec 5 02:00 | 정확한 DateTime |
| **Client** | nextShiftStart = Dec 5 10:00 (Morning) | 8시간 gap |
| **Client** | grace deadline = 02:00 + 3h = 05:00 | |
| **Client** | 01:30 < 05:00 | shouldCheckout=true ✅ |

**결과**: ✅ 날짜가 바뀌어도 정확한 시간 비교로 처리됨

---

## 10. 동기화 검증

### 10.1 검증 체크리스트

| # | 검증 항목 | Client | UI | Server | 상태 |
|---|----------|--------|-----|--------|------|
| 1 | 체인 감지 기준 | 1분 tolerance | 동일 로직 사용 | 1분 tolerance | ✅ |
| 2 | Grace period 기준 | chain.lastEndTime | 동일 로직 사용 | N/A (클라이언트 책임) | ✅ |
| 3 | 체크아웃 시프트 선택 | endTime closest to now | 동일 로직 사용 | backward chain | ✅ |
| 4 | 체인 시프트 제외 | excludeShiftIds | 동일 | N/A | ✅ |
| 5 | UI 버튼 표시 | N/A | isPartOfInProgressChain | N/A | ✅ |

### 10.2 데이터 플로우

```
┌─────────────────────────────────────────────────────────────┐
│                      Data Flow Diagram                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [QR Scan]                                                  │
│      │                                                      │
│      ▼                                                      │
│  findClosestShiftRequestId()                                │
│      │                                                      │
│      ├─── detectContinuousChain() ◄──┐                      │
│      │         │                      │                     │
│      │         ▼                      │ Same Logic          │
│      │    shouldCheckout?             │                     │
│      │         │                      │                     │
│      │    ┌────┴────┐                 │                     │
│      │    │         │                 │                     │
│      │   YES       NO                 │                     │
│      │    │         │                 │                     │
│      │    ▼         ▼                 │                     │
│      │  findClosest findClosest       │                     │
│      │  CheckoutShift CheckinShift    │                     │
│      │    │         │                 │                     │
│      │    ▼         ▼                 │                     │
│      │  Night.id  Morning.id          │                     │
│      │    │         │                 │                     │
│      └────┴────┬────┘                 │                     │
│                │                      │                     │
│                ▼                      │                     │
│  [UI Display] ─────────────────────►──┘                     │
│      │                                                      │
│      │  findCurrentShiftWithChainInfo()                     │
│      │      │                                               │
│      │      ▼                                               │
│      │  isPartOfInProgressChain?                            │
│      │      │                                               │
│      │  ┌───┴───┐                                           │
│      │  │       │                                           │
│      │ YES     NO                                           │
│      │  │       │                                           │
│      │  ▼       ▼                                           │
│      │ inProgress upcoming                                  │
│      │  │       │                                           │
│      │  ▼       ▼                                           │
│      │ Check-out Check-in                                   │
│      │ Button   Button                                      │
│      │                                                      │
│      ▼                                                      │
│  [RPC Call] ─────────────────────────────────────►          │
│      │                                            │         │
│      │  update_shift_requests_v8                  │         │
│      │      │                                     │         │
│      │      ▼                                     │         │
│      │  Build backward chain                      │         │
│      │      │                                     │         │
│      │      ▼                                     │         │
│      │  Find first checked-in shift               │         │
│      │      │                                     │         │
│      │      ▼                                     │         │
│      │  Process chain checkout                    │         │
│      │      │                                     │         │
│      │      ▼                                     │         │
│      │  Return success                            │         │
│      │                                            │         │
│      ◄────────────────────────────────────────────┘         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 부록: 관련 파일 목록

| 파일 | 주요 함수 | 역할 |
|------|----------|------|
| `schedule_date_utils.dart` | `detectContinuousChain()`, `findClosestCheckoutShift()`, `calculateCheckoutDeadline()` | 핵심 로직 |
| `attendance_helper_methods.dart` | `findClosestShiftRequestId()` | QR 스캔용 ID 선택 |
| `schedule_shift_finder.dart` | `findCurrentShiftWithChainInfo()` | UI용 시프트 찾기 |
| `schedule_header.dart` | `_determineStatus()` | UI 상태 결정 |
| `attendance_datasource.dart` | `updateShiftRequest()` | RPC 호출 |
| `update_shift_requests_v8` (DB) | - | 서버 처리 |

---

*End of Document*
