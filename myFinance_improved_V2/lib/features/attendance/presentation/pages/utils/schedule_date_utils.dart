import 'package:flutter/material.dart';

import '../../../domain/entities/shift_card.dart';

/// Result of continuous chain detection
class ChainDetectionResult {
  /// The in-progress shift that started the chain (has isCheckedIn=true)
  final ShiftCard? inProgressShift;

  /// When the chain started (first shift's start_time)
  final DateTime? chainStartTime;

  /// When the chain ends (last shift's end_time)
  final DateTime? chainLastEndTime;

  /// All shifts in the chain, sorted by start time
  final List<ShiftCard> chainShifts;

  /// Whether we should be in checkout mode (chain ends today or later)
  final bool shouldCheckout;

  /// Error message if chain has validation issues
  /// e.g., 'chain_has_separate_checkin' if middle shift has individual check-in
  final String? errorCode;

  const ChainDetectionResult({
    this.inProgressShift,
    this.chainStartTime,
    this.chainLastEndTime,
    this.chainShifts = const [],
    this.shouldCheckout = false,
    this.errorCode,
  });

  /// No chain found
  static const ChainDetectionResult empty = ChainDetectionResult();

  /// Check if a valid chain was found
  bool get hasChain => inProgressShift != null && chainShifts.isNotEmpty;

  /// Check if chain has validation error
  bool get hasError => errorCode != null;
}

/// Shared DateTime utilities for schedule views
class ScheduleDateUtils {
  ScheduleDateUtils._();

  // ============================================================
  // GRACE PERIOD CONSTANTS
  // ============================================================

  /// 다음 시프트가 없을 때 기본 체크아웃 유예 시간
  static const int defaultGraceHours = 3;

  /// 최대 체크아웃 유예 시간 (다음 시프트가 아무리 멀어도 이 시간 후에는 체크아웃 불가)
  static const int maxGraceHours = 6;

  /// 다음 시프트 시작 전 최소 버퍼 (이 시간 전에는 체크아웃 마감)
  static const int bufferMinutes = 15;

  /// 연속 체인으로 판정하는 시간 차이 (분)
  static const int chainThresholdMinutes = 5;

  // ============================================================
  // CORE PARSING UTILITIES
  // ============================================================

  /// Parse shift datetime from ISO format string
  /// Supports: "2025-06-01T14:00:00" or "2025-06-01 14:00:00"
  static DateTime? parseShiftDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;
    try {
      if (dateTimeStr.contains('T')) {
        return DateTime.parse(dateTimeStr);
      }
      if (dateTimeStr.contains(' ')) {
        return DateTime.parse(dateTimeStr.replaceFirst(' ', 'T'));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Extract date-only from shift time string (e.g., "2025-12-20T08:00:00")
  static DateTime? parseShiftDate(String? shiftTime) {
    final dateTime = parseShiftDateTime(shiftTime);
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ============================================================
  // CHECKOUT DEADLINE CALCULATION (SINGLE SOURCE OF TRUTH)
  // ============================================================

  /// 체크아웃 마감 시간 계산
  ///
  /// **규칙 (우선순위 순):**
  /// 1. 연속 체인 (gap ≤ 5분): 다음 시프트 시작 시간 반환 (체인으로 처리)
  /// 2. 다음 시프트가 grace period 이내: 다음 시프트 시작 - 15분
  /// 3. 다음 시프트가 멀거나 없음: min(시프트 끝 + 3시간, 시프트 끝 + 6시간)
  ///
  /// **예시:**
  /// | 시프트 끝 | 다음 시프트 | Gap | 체크아웃 마감 |
  /// |----------|------------|-----|--------------|
  /// | 01:00    | 01:05      | 5분 | 01:05 (체인) |
  /// | 01:00    | 02:00      | 1시간| 01:45 (시작-15분) |
  /// | 01:00    | 03:00      | 2시간| 02:45 (시작-15분) |
  /// | 01:00    | 08:00      | 7시간| 04:00 (기본 3시간) |
  /// | 01:00    | 3일 후     | 72시간| 04:00 (기본 3시간) |
  /// | 01:00    | 없음       | -   | 04:00 (기본 3시간) |
  static DateTime calculateCheckoutDeadline(
    DateTime shiftEnd,
    DateTime? nextShiftStart,
  ) {
    final defaultDeadline = shiftEnd.add(const Duration(hours: defaultGraceHours));
    final maxDeadline = shiftEnd.add(const Duration(hours: maxGraceHours));

    if (nextShiftStart == null) {
      // 다음 시프트 없음 → 기본 3시간
      return defaultDeadline;
    }

    final gap = nextShiftStart.difference(shiftEnd);

    // 연속 시프트 (5분 이내) → 체인으로 처리 (다음 시프트 시작까지)
    if (gap.inMinutes <= chainThresholdMinutes) {
      return nextShiftStart;
    }

    // 다음 시프트가 grace period 이내 → 시작 15분 전까지
    if (gap.inHours < defaultGraceHours) {
      final beforeNextShift = nextShiftStart.subtract(
        const Duration(minutes: bufferMinutes),
      );
      // 최소한 현재보다는 미래여야 함
      return beforeNextShift.isAfter(shiftEnd) ? beforeNextShift : shiftEnd;
    }

    // 기본: 3시간 (최대 6시간 상한 적용)
    return defaultDeadline.isBefore(maxDeadline) ? defaultDeadline : maxDeadline;
  }

  /// 현재 시간이 체크아웃 가능 시간 내인지 확인
  ///
  /// [shiftEnd] 시프트 종료 시간
  /// [nextShiftStart] 다음 시프트 시작 시간 (없으면 null)
  /// [currentTime] 현재 시간
  ///
  /// Returns: true면 아직 체크아웃 가능, false면 체크아웃 마감됨
  static bool isWithinCheckoutWindow(
    DateTime shiftEnd,
    DateTime? nextShiftStart,
    DateTime currentTime,
  ) {
    final deadline = calculateCheckoutDeadline(shiftEnd, nextShiftStart);
    return currentTime.isBefore(deadline);
  }

  /// 다음 시프트 시작 시간 찾기 (헬퍼)
  ///
  /// [shiftCards] 전체 시프트 목록
  /// [afterTime] 이 시간 이후의 시프트만 검색
  /// [excludeShiftIds] 제외할 shift ID 목록 (체인에 포함된 shift 등)
  ///
  /// Returns: 다음 시프트 시작 시간, 없으면 null
  static DateTime? findNextShiftStartTime(
    List<ShiftCard> shiftCards,
    DateTime afterTime, {
    Set<String>? excludeShiftIds,
  }) {
    DateTime? nextStart;

    for (final card in shiftCards) {
      if (!card.isApproved || card.isCheckedIn) continue;

      // Exclude specific shifts (e.g., shifts in the current chain)
      if (excludeShiftIds != null && excludeShiftIds.contains(card.shiftRequestId)) {
        continue;
      }

      final startTime = parseShiftDateTime(card.shiftStartTime);
      if (startTime == null || !startTime.isAfter(afterTime)) continue;

      if (nextStart == null || startTime.isBefore(nextStart)) {
        nextStart = startTime;
      }
    }

    return nextStart;
  }

  // ============================================================
  // CONTINUOUS CHAIN DETECTION (UNIFIED LOGIC)
  // ============================================================

  /// Detect continuous shift chain from in-progress shift
  ///
  /// For continuous shifts (10:00~15:00, 15:00~20:00, 20:00~02:00):
  /// - Only FIRST shift has isCheckedIn=true
  /// - Chain detection traces forward to find all connected shifts
  /// - Uses 1-minute tolerance for time matching
  /// - Grace period is checked against CHAIN'S LAST end_time, not first shift's end_time
  ///
  /// **Algorithm (v2 - Chain-first approach):**
  /// 1. Find checked-in shift (without grace period check)
  /// 2. Build chain forward (find all continuous shifts)
  /// 3. Check grace period using chain's last end_time
  /// 4. If within grace period → CHECKOUT mode
  /// 5. If past grace period → return empty (CHECKIN mode)
  ///
  /// **Example:**
  /// - Morning 10:00~15:00 (checked in)
  /// - Afternoon 15:00~20:00 (continuous)
  /// - Night 20:00~02:00 (continuous)
  /// - At 02:30 next day: grace period check uses 02:00 (chain end), not 15:00 (first shift end)
  ///
  /// Returns [ChainDetectionResult] with chain info and checkout determination
  static ChainDetectionResult detectContinuousChain(
    List<ShiftCard> shiftCards, {
    DateTime? currentTime,
  }) {
    if (shiftCards.isEmpty) return ChainDetectionResult.empty;

    final now = currentTime ?? DateTime.now();

    // Step 1: Find checked-in shift (WITHOUT grace period check)
    // Grace period will be checked after building the chain
    ShiftCard? inProgressShift;
    for (final card in shiftCards) {
      if (card.isApproved && card.isCheckedIn && !card.isCheckedOut) {
        inProgressShift = card;
        break;
      }
    }

    if (inProgressShift == null) return ChainDetectionResult.empty;

    final chainStartTime = parseShiftDateTime(inProgressShift.shiftStartTime);
    if (chainStartTime == null) return ChainDetectionResult.empty;

    // Step 2: Sort and filter candidates for chain
    final sortedShifts = shiftCards
        .where((c) => c.isApproved && !c.isCheckedOut)
        .toList()
      ..sort((a, b) {
        final aStart = parseShiftDateTime(a.shiftStartTime);
        final bStart = parseShiftDateTime(b.shiftStartTime);
        if (aStart == null || bStart == null) return 0;
        return aStart.compareTo(bStart);
      });

    // Step 3: Build chain forward from in-progress shift
    final chainShifts = <ShiftCard>[inProgressShift];
    DateTime? currentEndTime = parseShiftDateTime(inProgressShift.shiftEndTime);
    DateTime? chainLastEndTime = currentEndTime;

    for (final c in sortedShifts) {
      if (c.shiftRequestId == inProgressShift.shiftRequestId) continue;

      final shiftStart = parseShiftDateTime(c.shiftStartTime);
      final shiftEnd = parseShiftDateTime(c.shiftEndTime);
      if (shiftStart == null || shiftEnd == null) continue;

      // Check if this shift continues the chain (start_time = previous end_time)
      // Allow 1 minute tolerance for edge cases
      if (currentEndTime != null) {
        final diff = shiftStart.difference(currentEndTime).abs();
        if (diff.inMinutes <= 1) {
          chainShifts.add(c);
          currentEndTime = shiftEnd;
          chainLastEndTime = shiftEnd;
        }
      }
    }

    // Step 3.5: Validate chain - check for separate check-ins in middle shifts
    // Server will reject this case with 'chain_shift_has_separate_checkin'
    // We detect it early here to provide better UX
    for (int i = 1; i < chainShifts.length; i++) {
      final middleShift = chainShifts[i];
      if (middleShift.isCheckedIn) {
        // Middle shift has separate check-in - this is invalid
        return ChainDetectionResult(
          inProgressShift: inProgressShift,
          chainStartTime: chainStartTime,
          chainLastEndTime: chainLastEndTime,
          chainShifts: chainShifts,
          shouldCheckout: false,
          errorCode: 'chain_has_separate_checkin',
        );
      }
    }

    // Step 4: Check grace period using CHAIN'S LAST end_time
    // This is the key fix - we use the chain's end, not the first shift's end
    if (chainLastEndTime != null && now.isAfter(chainLastEndTime)) {
      // Chain has ended - check if within grace period
      // Exclude chain shifts when finding next shift (they're part of current work session)
      final chainShiftIds = chainShifts.map((s) => s.shiftRequestId).toSet();
      final nextShiftStart = findNextShiftStartTime(
        shiftCards,
        chainLastEndTime,
        excludeShiftIds: chainShiftIds,
      );
      if (!isWithinCheckoutWindow(chainLastEndTime, nextShiftStart, now)) {
        // Grace period passed - chain is invalid, switch to CHECKIN mode
        return ChainDetectionResult.empty;
      }
    }

    // Step 5: Within grace period or chain hasn't ended yet → CHECKOUT mode
    return ChainDetectionResult(
      inProgressShift: inProgressShift,
      chainStartTime: chainStartTime,
      chainLastEndTime: chainLastEndTime,
      chainShifts: chainShifts,
      shouldCheckout: true,
    );
  }

  /// Find the correct shift for checkout from chain
  /// Used for both UI display and QR scan checkout
  ///
  /// **Logic (v2):**
  /// 1. If any shift hasn't ended yet → return that shift
  /// 2. If all shifts ended → return shift with end_time closest to now
  ///
  /// Example: 10:00~15:00, 15:00~20:00, 20:00~02:00 chain
  /// - At 10:00 → Morning (end 15:00 > 10:00, not ended yet)
  /// - At 16:00 → Afternoon (Morning ended, Afternoon end 20:00 > 16:00)
  /// - At 21:00 → Night (Morning/Afternoon ended, Night end 02:00 > 21:00)
  /// - At 01:00 → Night (end 02:00 > 01:00, not ended yet)
  /// - At 02:30 → Night (all ended, Night's 02:00 is closest to 02:30)
  static ShiftCard? findClosestCheckoutShift(
    ChainDetectionResult chain, {
    DateTime? currentTime,
  }) {
    if (!chain.hasChain || !chain.shouldCheckout) return null;
    if (chain.chainShifts.isEmpty) return null;

    final now = currentTime ?? DateTime.now();

    // Sort shifts by start_time (chronological order)
    final sorted = [...chain.chainShifts]..sort((a, b) {
      final aStart = parseShiftDateTime(a.shiftStartTime);
      final bStart = parseShiftDateTime(b.shiftStartTime);
      if (aStart == null || bStart == null) return 0;
      return aStart.compareTo(bStart);
    });

    // Find the earliest shift that hasn't ended yet (end_time > now)
    for (final shift in sorted) {
      final endTime = parseShiftDateTime(shift.shiftEndTime);
      if (endTime == null) continue;

      if (endTime.isAfter(now)) {
        return shift;
      }
    }

    // All shifts ended - find the one with end_time closest to now
    // This handles late checkout (e.g., at 02:30, Night's 02:00 is closest)
    ShiftCard? closestShift;
    Duration? smallestDiff;

    for (final shift in sorted) {
      final endTime = parseShiftDateTime(shift.shiftEndTime);
      if (endTime == null) continue;

      final diff = now.difference(endTime).abs();
      if (smallestDiff == null || diff < smallestDiff) {
        smallestDiff = diff;
        closestShift = shift;
      }
    }

    return closestShift ?? sorted.last;
  }

  /// Find the shift with start_time closest to current time for check-in
  ///
  /// Uses Grace Period logic for shift transitions.
  ///
  /// **Grace Period Rules:**
  /// 1. 기본: 시프트 끝 + 3시간
  /// 2. 다음 시프트가 3시간 이내: 다음 시프트 시작 - 15분
  /// 3. 최대 상한: 6시간
  ///
  /// Example:
  /// - Dec 22 Night ends: 01:00
  /// - Checkout deadline: 01:00 + 3시간 = 04:00
  /// - At 03:00 → Dec 22 Night (checkout mode)
  /// - At 04:01 → Dec 23 shift (checkin mode)
  static ShiftCard? findClosestCheckinShift(
    List<ShiftCard> shiftCards, {
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Step 1: Find if there's an in-progress shift that should still be shown
    // (checked in but not out, or recently ended)
    final inProgressOrRecentShift = _findInProgressOrRecentShift(shiftCards, now);
    if (inProgressOrRecentShift != null) {
      // User should checkout this shift, not check into a new one
      return null;
    }

    // Step 2: Filter check-in candidates
    // - Approved, not checked in
    // - Start time is today OR within valid check-in window
    final checkinCandidates = shiftCards.where((c) {
      if (!c.isApproved || c.isCheckedIn) return false;

      final shiftStartTime = parseShiftDateTime(c.shiftStartTime);
      if (shiftStartTime == null) return false;

      final shiftDate = DateTime(shiftStartTime.year, shiftStartTime.month, shiftStartTime.day);

      // Allow check-in for TODAY's shifts
      if (isSameDay(shiftDate, today)) return true;

      return false;
    }).toList();

    if (checkinCandidates.isEmpty) return null;

    // Sort by distance from current time to start_time (closest first)
    checkinCandidates.sort((a, b) {
      final aStart = parseShiftDateTime(a.shiftStartTime);
      final bStart = parseShiftDateTime(b.shiftStartTime);
      if (aStart == null || bStart == null) return 0;
      return aStart.difference(now).abs().compareTo(bStart.difference(now).abs());
    });

    return checkinCandidates.first;
  }

  /// Find in-progress shift OR recently ended shift that should still show checkout
  ///
  /// Uses the same chain-first logic as [detectContinuousChain].
  /// Grace period is checked against the CHAIN'S LAST end_time.
  ///
  /// Returns the shift if:
  /// 1. Shift is in-progress (checked in, not out)
  /// 2. Chain ended but we're within the grace period checkout window
  ///
  /// Returns null if user can proceed to check into a new shift
  static ShiftCard? _findInProgressOrRecentShift(
    List<ShiftCard> shiftCards,
    DateTime now,
  ) {
    // Use detectContinuousChain which handles chain-based grace period correctly
    final chain = detectContinuousChain(shiftCards, currentTime: now);

    // If chain exists and shouldCheckout is true, return the in-progress shift
    if (chain.hasChain && chain.shouldCheckout) {
      return chain.inProgressShift;
    }

    return null;
  }

  /// Get week range (Monday to Sunday) for a given date
  static DateTimeRange getWeekRange(DateTime date) {
    final weekday = date.weekday; // 1=Mon, 7=Sun
    final monday = date.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateTimeRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  /// Format time from 24h to 12h format
  /// Input: "14:00" -> Output: "2:00 PM"
  static String formatTime(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24;
    }
  }

  /// Format time range from shiftStartTime and shiftEndTime
  /// Input: "2025-06-01T14:00:00", "2025-06-01T18:00:00"
  /// Output: "2:00 PM - 6:00 PM"
  static String formatTimeRangeFromDateTime(String shiftStartTime, String shiftEndTime) {
    try {
      final startDateTime = parseShiftDateTime(shiftStartTime);
      final endDateTime = parseShiftDateTime(shiftEndTime);
      if (startDateTime == null || endDateTime == null) return '--:-- - --:--';

      final startTimeStr = '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';

      final formattedStart = formatTime(startTimeStr);
      final formattedEnd = formatTime(endTimeStr);
      return '$formattedStart - $formattedEnd';
    } catch (e) {
      return '--:-- - --:--';
    }
  }

  /// Extract shift type from shiftStartTime based on hour
  /// Morning: before 12, Afternoon: 12-17, Evening: after 17
  static String extractShiftTypeFromDateTime(String shiftStartTime) {
    try {
      final startDateTime = parseShiftDateTime(shiftStartTime);
      if (startDateTime == null) return 'Shift';

      final startHour = startDateTime.hour;
      if (startHour < 12) return 'Morning';
      if (startHour < 17) return 'Afternoon';
      return 'Evening';
    } catch (e) {
      return 'Shift';
    }
  }

  /// Format date to "Tue, 18 Jun 2025" format
  static String formatDateFull(DateTime date) {
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final weekDay = weekDays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekDay, ${date.day} $month ${date.year}';
  }

  /// Format date from shiftStartTime string
  static String formatDateFromShiftTime(String shiftStartTime) {
    final date = parseShiftDateTime(shiftStartTime);
    if (date == null) return 'Unknown date';
    return formatDateFull(date);
  }
}
