# Attendance Check-in/Check-out Workflow Documentation

> Last Updated: 2025-12-23
> Version: v9 (Midpoint-based Shift Transition)

## Table of Contents

1. [Overview](#overview)
2. [Core Concepts](#core-concepts)
3. [STEP 1: UI Shift Finding Logic](#step-1-ui-shift-finding-logic)
4. [STEP 2: UI Button Mode Determination](#step-2-ui-button-mode-determination)
5. [STEP 3: QR Scan Shift Selection](#step-3-qr-scan-shift-selection)
6. [STEP 4: RPC Processing](#step-4-rpc-processing)
7. [Complete Flow Example](#complete-flow-example)
8. [Bug Fix History](#bug-fix-history)

---

## Overview

This document explains the complete workflow of the attendance check-in/check-out system:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         COMPLETE ATTENDANCE WORKFLOW                        │
└─────────────────────────────────────────────────────────────────────────────┘

   STEP 1                STEP 2               STEP 3              STEP 4
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Find Shift   │───→│ Determine    │───→│ QR Scan      │───→│ RPC Process  │
│ to Display   │    │ Button Mode  │    │ Find Shift   │    │ in Database  │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
 schedule_shift_     schedule_header.    attendance_        update_shift_
 finder.dart         dart               helper_methods.     requests_v8.sql
                                        dart
```

### Key Files

| Step | File | Purpose |
|------|------|---------|
| 1 | `schedule_shift_finder.dart` | Find the most relevant shift to display |
| 1 | `schedule_date_utils.dart` | Core utilities: chain detection, parsing |
| 2 | `schedule_header.dart` | Determine Check-in vs Check-out button |
| 3 | `attendance_helper_methods.dart` | Find shift_id when QR is scanned |
| 3 | `qr_scanner_page.dart` | QR scanning and RPC call |
| 4 | `update_shift_requests_v8.sql` | Database RPC function |

---

## Core Concepts

### Shift Date Definition

**CRITICAL RULE**: A shift's date is determined by `start_time`'s LOCAL date only (not `end_time`).

```
Example:
- Night shift: 23:00 (Dec 21) ~ 03:00 (Dec 22)
- This is a "December 21st shift" (based on start_time)
- NOT a December 22nd shift
```

### Continuous Shift Chain

When multiple shifts are connected (end_time = next start_time), they form a "continuous chain":

```
Chain Example:
08:00~13:00 (Morning) → 13:00~19:00 (Afternoon) → 19:00~02:00 (Night)

- Only the FIRST shift (Morning) has check-in record
- When checking out, ALL shifts in the chain are processed together
- Uses 1-minute tolerance for time matching
```

### Check-in vs Check-out Mode

| Condition | Mode |
|-----------|------|
| No shift has `isCheckedIn=true` | Check-in |
| Any shift has `isCheckedIn=true && isCheckedOut=false` | Check-out |

### Midpoint-based Shift Transition (v9)

**Problem**: What happens when an employee forgets to checkout?

When an employee doesn't checkout and the shift ends, the system needs to determine:
1. Should the user still checkout the ended shift?
2. Or should they check into the next shift (and mark the previous as "no_checkout")?

**Solution**: Calculate the **midpoint** between the previous shift's end_time and next shift's start_time.

```
Formula:
midpoint = previous_end_time + (next_start_time - previous_end_time) / 2

Example:
- Dec 22 Night: 20:00 ~ 01:00 (checked in at 19:50, no checkout)
- Dec 23 Night: 20:00 ~ 01:00 (not checked in)
- Midpoint = 01:00 + (20:00 - 01:00) / 2 = 01:00 + 9.5h = 10:30

Timeline:
01:00 ──────────────── 10:30 ──────────────── 20:00
      │ CHECKOUT MODE │        │ CHECKIN MODE │
      └───────────────┘        └──────────────┘
```

| Time | Action |
|------|--------|
| Before 10:30 | Return Dec 22 Night for CHECKOUT |
| After 10:30 | Return Dec 23 Night for CHECKIN (Dec 22 becomes "no_checkout") |

**Default Grace Period**: If no next shift exists, use 3 hours after end_time as the cutoff.

---

## STEP 1: UI Shift Finding Logic

**File**: `schedule_shift_finder.dart` → `findCurrentShiftWithChainInfo()`

### Purpose

Find the most relevant shift to display on the main attendance screen.

### Priority Order

```
1. In-progress shift chain (checked in but not out)
   ↓ If not found
2. Today's shifts (by time distance to now)
   ↓ If not found
3. Next upcoming shift (future date)
```

### Detailed Logic

```dart
static CurrentShiftResult findCurrentShiftWithChainInfo(
  List<ShiftCard> shiftCards, {
  bool excludeCompleted = false,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIORITY 1: In-progress shift (checked in but not checked out)
  // This has highest priority - always show the shift user is currently working on
  // ═══════════════════════════════════════════════════════════════════════════
  final chain = ScheduleDateUtils.detectContinuousChain(shiftCards, currentTime: now);

  if (chain.hasChain) {
    // If shouldCheckout is true, find the best shift in the chain for checkout
    if (chain.shouldCheckout) {
      final checkoutShift = ScheduleDateUtils.findClosestCheckoutShift(chain, currentTime: now);
      if (checkoutShift != null) {
        // Chain shift: might not have isCheckedIn=true itself
        final isChainShift = checkoutShift.shiftRequestId != chain.inProgressShift?.shiftRequestId;
        return CurrentShiftResult(
          shift: checkoutShift,
          isPartOfInProgressChain: isChainShift,  // Important for button mode!
        );
      }
    }
    // Always return in-progress shift if it exists
    if (chain.inProgressShift != null) {
      return CurrentShiftResult(shift: chain.inProgressShift);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIORITY 2: Today's shifts (not-started or completed)
  // Compare: completed's end_time vs not-started's start_time
  // Show whichever is closest to current time
  // ═══════════════════════════════════════════════════════════════════════════
  // ... (filters today's shifts and finds closest by time distance)

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIORITY 3: Next upcoming shift (future date)
  // ═══════════════════════════════════════════════════════════════════════════
  if (nextUpcoming != null) return CurrentShiftResult(shift: nextUpcoming);

  return const CurrentShiftResult();
}
```

### Chain Detection (`detectContinuousChain`)

**File**: `schedule_date_utils.dart`

```dart
static ChainDetectionResult detectContinuousChain(
  List<ShiftCard> shiftCards, {
  DateTime? currentTime,
}) {
  // Step 1: Find in-progress shift (checked in but not out)
  ShiftCard? inProgressShift;
  for (final card in shiftCards) {
    if (card.isApproved && card.isCheckedIn && !card.isCheckedOut) {
      inProgressShift = card;
      break;
    }
  }

  if (inProgressShift == null) return ChainDetectionResult.empty;

  // Step 2: Sort candidates for chain
  final sortedShifts = shiftCards
      .where((c) => c.isApproved && !c.isCheckedOut)
      .toList()
    ..sort((a, b) => /* by start_time */);

  // Step 3: Trace the chain forward from in-progress shift
  // Condition: start_time = previous end_time (±1 minute)
  final chainShifts = <ShiftCard>[inProgressShift];
  DateTime? currentEndTime = parseShiftDateTime(inProgressShift.shiftEndTime);

  for (final c in sortedShifts) {
    if (c.shiftRequestId == inProgressShift.shiftRequestId) continue;

    final shiftStart = parseShiftDateTime(c.shiftStartTime);
    if (currentEndTime != null) {
      final diff = shiftStart.difference(currentEndTime).abs();
      if (diff.inMinutes <= 1) {
        chainShifts.add(c);
        currentEndTime = parseShiftDateTime(c.shiftEndTime);
      }
    }
  }

  return ChainDetectionResult(
    inProgressShift: inProgressShift,
    chainShifts: chainShifts,
    shouldCheckout: true,  // Always true when in-progress shift exists
  );
}
```

### Output

```dart
class CurrentShiftResult {
  final ShiftCard? shift;                    // The shift to display
  final bool isPartOfInProgressChain;        // Used for button mode determination
}
```

---

## STEP 2: UI Button Mode Determination

**File**: `schedule_header.dart` → `_determineStatus()`

### Purpose

Determine whether to show "Check-in" or "Check-out" button based on shift status.

### Input/Output

```
Input: CurrentShiftResult from STEP 1
       ├── shift: ShiftCard
       └── isPartOfInProgressChain: bool

Output: ShiftStatus enum
        → Determines which button to show
```

### Status Flow

```
ShiftCard data
     ↓
_determineStatus()
     ↓
ShiftStatus enum
     ↓
TossTodayShiftCard UI
     ↓
Shows "Check-in" or "Check-out" button
```

### Status Determination Logic

```dart
ShiftStatus _determineStatus(ShiftCard? card) {
  // 1. No shift → noShift (no button)
  if (card == null) return ShiftStatus.noShift;

  // 2. Future shift → upcoming (no button, just info)
  if (startDate.isAfter(today)) return ShiftStatus.upcoming;

  // 3. Completed → completed (no button)
  if (card.isCheckedIn && card.isCheckedOut) return ShiftStatus.completed;

  // 4. In-progress → onTime/late (shows Check-out button)
  //    This is when THIS shift has isCheckedIn=true
  if (card.isCheckedIn && !card.isCheckedOut) {
    return card.isLate ? ShiftStatus.late : ShiftStatus.onTime;
  }

  // 5. Part of chain → inProgress (shows Check-out button)
  //    Even though THIS shift's isCheckedIn=false,
  //    an earlier shift in the chain was checked in
  //    ⭐ THIS IS THE KEY: isPartOfInProgressChain from STEP 1
  if (isPartOfInProgressChain && !card.isCheckedOut) {
    return ShiftStatus.inProgress;
  }

  // 6. Today but not started → undone (shows Check-in button)
  return ShiftStatus.undone;
}
```

### ShiftStatus to Button Mapping

| ShiftStatus | Button Shown |
|-------------|--------------|
| `noShift` | "Go to Shift Sign-up" |
| `upcoming` | No action button |
| `undone` | **"Check-in"** |
| `onTime`, `late`, `inProgress` | **"Check-out"** |
| `completed` | No action button |

### Chain Example

```
Shifts: Morning(08:00~13:00), Afternoon(13:00~19:00), Night(19:00~02:00)
User checked in at 07:50 for Morning shift

At 15:00:
- detectContinuousChain() returns:
  - inProgressShift: Morning
  - chainShifts: [Morning, Afternoon, Night]
  - shouldCheckout: true

- findClosestCheckoutShift() returns: Afternoon
  (because Morning ended at 13:00, Afternoon ends at 19:00 > 15:00)

- findCurrentShiftWithChainInfo() returns:
  - shift: Afternoon
  - isPartOfInProgressChain: true  ⭐

- _determineStatus() receives:
  - Afternoon.isCheckedIn = false (only Morning has check-in)
  - isPartOfInProgressChain = true
  - Returns: ShiftStatus.inProgress

- UI shows: "Check-out" button ✅
```

---

## STEP 3: QR Scan Shift Selection

**File**: `attendance_helper_methods.dart` → `findClosestShiftRequestId()`

### Purpose

When user scans QR code, determine which shift_request_id to send to the RPC.

### Flow

```
User taps "Check-in" or "Check-out" button
     ↓
Opens QR Scanner (qr_scanner_page.dart)
     ↓
Scans QR Code (contains store_id)
     ↓
Fetches user's shift cards for that store
     ↓
findClosestShiftRequestId(shiftCards)  ← THIS STEP
     ↓
Returns shift_request_id
     ↓
Calls update_shift_requests_v8 RPC
```

### Decision Logic (v9 with Midpoint)

```dart
static String? findClosestShiftRequestId(
  List<ShiftCard> shiftCards, {
  DateTime? now,
}) {
  if (shiftCards.isEmpty) return null;
  final currentTime = now ?? DateTime.now();

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIORITY 1: Detect continuous chain
  // ═══════════════════════════════════════════════════════════════════════════
  final chain = ScheduleDateUtils.detectContinuousChain(
    shiftCards,
    currentTime: currentTime,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CHECKOUT MODE: Chain detected with in-progress shift
  // ═══════════════════════════════════════════════════════════════════════════
  if (chain.shouldCheckout) {
    final checkoutShift = ScheduleDateUtils.findClosestCheckoutShift(
      chain,
      currentTime: currentTime,
    );
    if (checkoutShift != null) {
      final endTime = ScheduleDateUtils.parseShiftDateTime(checkoutShift.shiftEndTime);

      // ┌─────────────────────────────────────────────────────────────────────┐
      // │ MIDPOINT CHECK: Has the shift ended?                                │
      // └─────────────────────────────────────────────────────────────────────┘
      if (endTime != null && currentTime.isAfter(endTime)) {
        // Shift ended - check midpoint
        final shouldStillCheckout = _isBeforeMidpoint(
          shiftCards, checkoutShift, currentTime
        );

        if (!shouldStillCheckout) {
          // Past midpoint → skip to checkin mode
          // The ended shift will be marked as no_checkout by cron job
          // Fall through to CHECKIN MODE below...
        } else {
          // Before midpoint → still checkout
          return checkoutShift.shiftRequestId;
        }
      } else {
        // Shift hasn't ended yet → normal checkout
        return checkoutShift.shiftRequestId;
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CHECKIN MODE: Find closest check-in shift
  // ═══════════════════════════════════════════════════════════════════════════
  final checkinShift = ScheduleDateUtils.findClosestCheckinShift(
    shiftCards,
    currentTime: currentTime,
  );
  if (checkinShift != null) {
    return checkinShift.shiftRequestId;
  }

  return null;
}
```

### Midpoint Calculation Helper

```dart
static bool _isBeforeMidpoint(
  List<ShiftCard> shiftCards,
  ShiftCard endedShift,
  DateTime currentTime,
) {
  const defaultGraceHours = 3;

  final endedShiftEndTime = ScheduleDateUtils.parseShiftDateTime(endedShift.shiftEndTime);
  if (endedShiftEndTime == null) return true;  // Safety fallback

  // Find next upcoming shift (not checked in, start_time > endedShift's end_time)
  ShiftCard? nextShift;
  DateTime? nextShiftStart;
  for (final card in shiftCards) {
    if (!card.isApproved || card.isCheckedIn) continue;
    final startTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
    if (startTime == null || !startTime.isAfter(endedShiftEndTime)) continue;

    if (nextShift == null || startTime.isBefore(nextShiftStart!)) {
      nextShift = card;
      nextShiftStart = startTime;
    }
  }

  // Calculate midpoint
  DateTime midpoint;
  if (nextShiftStart != null) {
    // Midpoint = (previous_end + next_start) / 2
    final totalMinutes = nextShiftStart.difference(endedShiftEndTime).inMinutes;
    midpoint = endedShiftEndTime.add(Duration(minutes: totalMinutes ~/ 2));
  } else {
    // No next shift: use default grace period
    midpoint = endedShiftEndTime.add(Duration(hours: defaultGraceHours));
  }

  return currentTime.isBefore(midpoint);
}
```

### Check-in Shift Selection (`findClosestCheckinShift`)

**File**: `schedule_date_utils.dart`

```dart
static ShiftCard? findClosestCheckinShift(
  List<ShiftCard> shiftCards, {
  DateTime? currentTime,
}) {
  final now = currentTime ?? DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Step 1: Check if there's an in-progress shift that should still show checkout
  final inProgressOrRecentShift = _findInProgressOrRecentShift(shiftCards, now);
  if (inProgressOrRecentShift != null) {
    // User should checkout this shift, not check into a new one
    return null;
  }

  // Step 2: Filter check-in candidates
  // - Approved, not checked in
  // - Start time is TODAY (no future shifts!)
  final checkinCandidates = shiftCards.where((c) {
    if (!c.isApproved || c.isCheckedIn) return false;

    final shiftStartTime = parseShiftDateTime(c.shiftStartTime);
    if (shiftStartTime == null) return false;

    final shiftDate = DateTime(shiftStartTime.year, shiftStartTime.month, shiftStartTime.day);

    // ⭐ CRITICAL: Only allow TODAY's shifts
    return isSameDay(shiftDate, today);
  }).toList();

  if (checkinCandidates.isEmpty) return null;

  // Sort by distance from current time to start_time (closest first)
  checkinCandidates.sort((a, b) {
    final aStart = parseShiftDateTime(a.shiftStartTime);
    final bStart = parseShiftDateTime(b.shiftStartTime);
    return aStart.difference(now).abs().compareTo(bStart.difference(now).abs());
  });

  return checkinCandidates.first;
}
```

### QR Scanner Page Integration

**File**: `qr_scanner_page.dart`

```dart
// Inside onDetect callback after QR is scanned:

// 1. Fetch shift cards for the scanned store
final shiftCardsResult = await getUserShiftCards(
  requestTime: currentTime,
  userId: userId,
  companyId: companyId,
  storeId: storeId,  // From QR code
  timezone: timezone,
);

// 2. Find the closest shift's request ID
final shiftRequestId = AttendanceHelpers.findClosestShiftRequestId(
  shiftCards,
  now: now,
);

if (shiftRequestId == null) {
  throw Exception('No approved shift found for today.');
}

// 3. Submit attendance using RPC
final checkInResult = await checkInShift(
  shiftRequestId: shiftRequestId,  // ← This is sent to RPC
  userId: userId,
  storeId: storeId,
  timestamp: currentTime,
  location: AttendanceLocation(
    latitude: position.latitude,
    longitude: position.longitude,
  ),
  timezone: timezone,
);
```

---

## STEP 4: RPC Processing

**File**: `update_shift_requests_v8.sql`

### Purpose

Process the attendance request in the database. Handles both check-in and check-out.

### Input Parameters

```sql
p_shift_request_id uuid,    -- The shift to process (from STEP 3)
p_user_id uuid,             -- User ID
p_store_id uuid,            -- Store ID (from QR code)
p_time timestamp,           -- Local scan time
p_lat double precision,     -- GPS latitude
p_lng double precision,     -- GPS longitude
p_timezone text             -- e.g., 'Asia/Ho_Chi_Minh'
```

### Processing Flow

```
Receive shift_request_id
        ↓
Build backward chain (end_time = start_time)
        ↓
Find first shift with check-in record
        ↓
    ┌───────────────────┬───────────────────┐
    │   Chain Found     │   Single Shift    │
    │   (≥2 shifts)     │   (1 shift)       │
    ↓                   ↓                   ↓
Process chain checkout  Check-in or Check-out
```

### Detailed Logic

```sql
CREATE OR REPLACE FUNCTION update_shift_requests_v8(
  p_shift_request_id uuid,
  p_user_id uuid,
  p_store_id uuid,
  p_time timestamp,
  p_lat double precision,
  p_lng double precision,
  p_timezone text
) RETURNS json
LANGUAGE plpgsql
AS $$
DECLARE
  v_continuous_chain uuid[];
  v_checkin_index int;
  -- ...
BEGIN
  -- Convert local time to UTC
  v_time_utc := (p_time AT TIME ZONE p_timezone);

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Step 1: Get requested shift info
  -- ═══════════════════════════════════════════════════════════════════════════
  SELECT * INTO v_current_shift
  FROM shift_requests
  WHERE shift_request_id = p_shift_request_id
    AND user_id = p_user_id
    AND store_id = p_store_id
    AND is_approved = TRUE;

  IF v_current_shift.shift_request_id IS NULL THEN
    RETURN json_build_object('status', 'error', 'message', 'shift_not_found');
  END IF;

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Step 2: Build FULL continuous shift chain (backward direction)
  -- Trace: S5 → S4 → S3 → S2 → S1 (by end_time = start_time, 1 min tolerance)
  -- ═══════════════════════════════════════════════════════════════════════════
  v_continuous_chain := ARRAY[p_shift_request_id];

  LOOP
    SELECT * INTO v_prev_shift
    FROM shift_requests
    WHERE user_id = p_user_id
      AND store_id = p_store_id
      AND is_approved = TRUE
      AND shift_request_id != ALL(v_continuous_chain)
      -- Match end_time = start_time with 1 minute tolerance
      AND ABS(EXTRACT(EPOCH FROM (
        end_time_utc - (SELECT start_time_utc FROM shift_requests WHERE shift_request_id = v_continuous_chain[1])
      ))) <= 60;

    IF v_prev_shift.shift_request_id IS NULL THEN
      EXIT; -- No more continuous shifts
    END IF;

    -- Prepend to chain (oldest first)
    v_continuous_chain := v_prev_shift.shift_request_id || v_continuous_chain;
  END LOOP;

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Step 3: Find the first shift with check-in record in the chain
  -- ═══════════════════════════════════════════════════════════════════════════
  v_checkin_index := NULL;

  FOR i IN 1..v_chain_length LOOP
    SELECT * INTO v_chain_shift
    FROM shift_requests
    WHERE shift_request_id = v_continuous_chain[i];

    IF v_chain_shift.actual_start_time_utc IS NOT NULL THEN
      -- Found checked-in shift
      v_checkin_shift := v_chain_shift;
      v_checkin_index := i;
      EXIT;
    END IF;
  END LOOP;

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Step 4: Determine action
  -- ═══════════════════════════════════════════════════════════════════════════

  -- Case A: Chain with check-in found (continuous checkout)
  IF v_chain_length >= 2 AND v_checkin_index IS NOT NULL THEN
    -- Process checkout for checkin_shift to requested_shift
    -- ...
    RETURN json_build_object('status', 'check_out', 'message', 'chain_checkout_completed');

  -- Case B: Single shift processing
  ELSE
    IF v_current_shift.actual_start_time_utc IS NULL THEN
      -- CHECK-IN
      UPDATE shift_requests SET
        actual_start_time_utc = v_time_utc,
        checkin_location_v2 = v_location
      WHERE shift_request_id = p_shift_request_id;

      RETURN json_build_object('status', 'attend', 'message', 'checkin_completed');

    ELSE IF v_current_shift.actual_end_time_utc IS NULL THEN
      -- CHECK-OUT
      UPDATE shift_requests SET
        actual_end_time_utc = v_time_utc,
        checkout_location_v2 = v_location,
        bonus_amount_v2 = bonus;
      WHERE shift_request_id = p_shift_request_id;

      RETURN json_build_object('status', 'check_out', 'message', 'checkout_completed');
    END IF;
  END IF;

END;
$$;
```

### Chain Checkout Processing

```sql
-- Example: Morning(S1) → Afternoon(S2) → Night(S3)
-- S1 has check-in, user scans at Night

-- Step 1: Build chain backward from S3
v_continuous_chain := [S1, S2, S3]

-- Step 2: Find first checked-in shift (S1)
v_checkin_index := 1

-- Step 3: Process checkout for S1 to S3
-- S1: actual_end_time = S1.end_time (13:00) - scheduled end time
-- S2: actual_start = start_time, actual_end = end_time - auto-filled
-- S3: actual_start = start_time, actual_end = SCAN_TIME - actual checkout time
```

### Database Changes

**Check-in Record:**
```sql
actual_start_time_utc = <scan time in UTC>
checkin_location_v2 = <GPS point>
```

**Check-out Record (Single):**
```sql
actual_end_time_utc = <scan time in UTC>
checkout_location_v2 = <GPS point>
bonus_amount_v2 = <shift bonus>
```

**Check-out Record (Chain):**
```sql
-- First shift in chain (checked-in shift)
actual_end_time_utc = end_time_utc  -- Shift's scheduled end time

-- Middle shifts in chain
actual_start_time_utc = start_time_utc  -- Auto-filled
actual_end_time_utc = end_time_utc      -- Auto-filled

-- Last shift in chain (scanned shift)
actual_start_time_utc = start_time_utc  -- Auto-filled
actual_end_time_utc = <actual scan time> -- Real checkout time
```

### Return Values

| Status | Message | Meaning |
|--------|---------|---------|
| `attend` | `checkin_completed` | Single shift check-in |
| `check_out` | `checkout_completed` | Single shift check-out |
| `check_out` | `chain_checkout_completed` | Chain check-out |
| `error` | `shift_not_found` | Invalid shift |
| `error` | `shift_already_completed` | Already checked out |

---

## Complete Flow Example

### Scenario: Night Shift with Continuous Chain

```
Shifts for Dec 22:
- Morning: 08:00~13:00
- Afternoon: 13:00~19:00
- Night: 19:00~02:00 (Dec 23)

User checks in at 07:50 for Morning shift
```

**At 15:00 (during Afternoon shift):**

```
STEP 1: findCurrentShiftWithChainInfo()
├── detectContinuousChain()
│   ├── inProgressShift: Morning (checked in at 07:50)
│   ├── chainShifts: [Morning, Afternoon, Night]
│   └── shouldCheckout: true
├── findClosestCheckoutShift(chain)
│   └── Returns: Afternoon (end 19:00 > 15:00)
└── Returns: CurrentShiftResult(shift: Afternoon, isPartOfInProgressChain: true)

STEP 2: _determineStatus(Afternoon)
├── Afternoon.isCheckedIn = false
├── isPartOfInProgressChain = true
└── Returns: ShiftStatus.inProgress → Shows "Check-out" button

STEP 3: User taps "Check-out" → Scans QR
├── findClosestShiftRequestId(shiftCards)
│   ├── detectContinuousChain() → finds chain
│   ├── findClosestCheckoutShift() → Afternoon
│   └── Returns: Afternoon.shiftRequestId
└── Calls RPC with Afternoon's ID

STEP 4: update_shift_requests_v8(Afternoon.id, ...)
├── Builds chain: [Morning, Afternoon, Night]
├── Finds check-in: Morning (index 1)
├── Processes:
│   ├── Morning: actual_end = 13:00 (scheduled)
│   ├── Afternoon: actual_start = 13:00, actual_end = 15:00 (scan time)
│   └── (Night not processed - after requested shift)
└── Returns: { status: 'check_out', message: 'chain_checkout_completed' }
```

**At 01:04 (after Night shift ended):**

```
Without Midpoint Logic (BUG):
├── Date is now Dec 23
├── findClosestCheckinShift()
│   ├── Filters for TODAY's shifts (Dec 23)
│   ├── Dec 23 Night (20:00~01:00) matches!
│   └── Returns: Dec 23 Night  ← WRONG!
└── User gets checked into Dec 23 shift instead of Dec 22 checkout

With Midpoint Logic (v9 FIX):
├── findClosestShiftRequestId()
│   ├── detectContinuousChain() → finds Dec 22 Night (in-progress)
│   ├── findClosestCheckoutShift() → Dec 22 Night
│   ├── endTime (01:00) < currentTime (01:04) → shift ended
│   ├── _isBeforeMidpoint():
│   │   ├── Dec 22 Night ends: 01:00
│   │   ├── Dec 23 Night starts: 20:00
│   │   ├── midpoint = 01:00 + 9.5h = 10:30
│   │   └── 01:04 < 10:30 → Returns true (before midpoint)
│   └── Returns: Dec 22 Night  ← CORRECT!
└── User can checkout Dec 22 Night shift
```

---

## Bug Fix History

### 2025-12-23: Midpoint-based Shift Transition (v9)

**Problem**: Checkout at 01:04 on Dec 23 resulted in check-in to Dec 23 Night instead of checkout for Dec 22 Night.

**Scenario**:
- Dec 22 Night (20:00~01:00): Checked in at 19:49, forgot to checkout
- Dec 23 at 01:04: User scans QR expecting checkout
- **Bug**: System checked user into Dec 23 Night shift instead!

**Root Cause**: At 01:04 on Dec 23:
1. The date had changed to Dec 23
2. Dec 22 Night's chain detection found an in-progress shift
3. But `findClosestCheckinShift` was called with "today = Dec 23"
4. Dec 23 Night's start_time is Dec 23, so it matched as "today's shift"
5. This returned Dec 23 Night for check-in instead of Dec 22 Night for checkout

**Solution**: Midpoint-based transition logic
1. Calculate midpoint between ended shift's end_time and next shift's start_time
2. Before midpoint: Return the ended shift for checkout
3. After midpoint: Allow check-in to next shift (ended shift becomes "no_checkout" problem)

**Example**:
```
Dec 22 Night: ends at 01:00
Dec 23 Night: starts at 20:00
Midpoint = 01:00 + 9.5h = 10:30

At 01:04: Before midpoint → Checkout Dec 22 Night
At 10:31: After midpoint → Check-in Dec 23 Night
```

**Files Changed**:
- `attendance_helper_methods.dart` - Added `_isBeforeMidpoint()` helper
- `attendance_helper_methods.dart` - Updated `findClosestShiftRequestId()` with midpoint check
- `schedule_date_utils.dart` - Added midpoint helpers in chain detection

---

### 2025-12-22: Future Shift Check-in Prevention

**Problem**: User could check into tomorrow's shift from today.

**Root Cause**: `findClosestCheckinShift` allowed check-in for shifts within "past 24 hours ~ future". At 22:02 Vietnam time on Dec 22, the Dec 23 shift (16:00 start) was selected because it was the "closest" shift by time distance.

**Before (Bug)**:
```dart
// Allowed future shifts!
final past24Hours = now.subtract(const Duration(hours: 24));
return !shiftStartTime.isBefore(past24Hours);
```

**After (Fixed)**:
```dart
// Only allow TODAY's shifts
final shiftDate = DateTime(shiftStartTime.year, shiftStartTime.month, shiftStartTime.day);
return isSameDay(shiftDate, today);
```

**Files Changed**:
- `schedule_date_utils.dart` - Fixed `findClosestCheckinShift`

---

## Related Documentation

- [RPC Documentation](../RPC_DOCUMENTATION.md)
- [RPC Quick Reference](../RPC_QUICK_REFERENCE.md)
