import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/manager_memo.dart';
import '../../../domain/entities/problem_details.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/tag.dart';
import 'shift_card_dto.dart';

/// Extension to map ShiftCardDto → Domain Entity
///
/// Separates DTO (data layer) from Entity (domain layer)
/// v6: BREAKING CHANGE - Removed legacy problem fields.
/// All problem data now comes from problemDetails (problem_details_v2).
/// This ensures single source of truth across all pages.
extension ShiftCardDtoMapper on ShiftCardDto {
  /// Convert DTO to Domain Entity
  ///
  /// NOTE: Legacy fields (isLate, isOverTime, isProblemSolved, etc.) are
  /// intentionally NOT mapped. Use ShiftCard's computed getters that
  /// derive values from problemDetails instead.
  ShiftCard toEntity() {
    return ShiftCard(
      shiftRequestId: shiftRequestId,
      employee: _mapEmployee(),
      shift: _mapShift(),
      shiftDate: shiftDate,
      isApproved: isApproved,
      // v6: Removed legacy problem fields - now computed from problemDetails:
      // - hasProblem → computed from problemDetails.problemCount
      // - isProblemSolved → computed from problemDetails.isSolved
      // - isLate, lateMinute → computed from problemDetails.problems
      // - isOverTime, overTimeMinute → computed from problemDetails.problems
      // - isReported, reportReason → computed from problemDetails.problems
      // - isReportedSolved → computed from problemDetails.problems
      // - problemType → computed from problemDetails.problems
      paidHour: paidHour,
      bonusAmount: bonusAmount,
      bonusReason: null, // Not in RPC
      confirmedStartTime: _parseTime(confirmStartTime),
      confirmedEndTime: _parseTime(confirmEndTime),
      actualStartTime: _parseTime(actualStart),
      actualEndTime: _parseTime(actualEnd),
      // v6: Location validation booleans removed from RPC (use problemDetails.hasLocationIssue instead)
      // Only distance values are kept for display purposes
      isValidCheckinLocation: null, // Derive from problemDetails.hasLocationIssue if needed
      checkinDistanceFromStore: checkinDistanceFromStore,
      isValidCheckoutLocation: null, // Derive from problemDetails.hasLocationIssue if needed
      checkoutDistanceFromStore: checkoutDistanceFromStore,
      salaryType: salaryType,
      salaryAmount: salaryAmount,
      basePay: basePay,
      totalPayWithBonus: totalPayWithBonus,
      // Store raw time strings from RPC for display without conversion
      actualStartRaw: actualStart,
      actualEndRaw: actualEnd,
      confirmedStartRaw: confirmStartTime,
      confirmedEndRaw: confirmEndTime,
      tags: noticeTags.map((tag) => tag.toEntity()).toList(),
      managerMemos: managerMemos.map((memo) => memo.toEntity()).toList(),
      // v5: Problem details - SINGLE SOURCE OF TRUTH for all problem data
      problemDetails: problemDetails?.toEntity(),
      // Shift start/end time from RPC ("2025-12-05 14:00" format)
      // Used for consecutive shift detection
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      createdAt: DateTime.now(), // RPC doesn't return created_at
      approvedAt: null, // RPC doesn't return approved_at
    );
  }

  /// Map DTO user fields to EmployeeInfo entity
  EmployeeInfo _mapEmployee() {
    return EmployeeInfo(
      userId: userId,
      userName: userName,
      profileImage: profileImage,
    );
  }

  /// Map DTO shift fields to Shift entity
  Shift _mapShift() {
    final now = DateTime.now();

    return Shift(
      shiftId: '', // RPC doesn't return shift_id
      storeId: '', // RPC doesn't return store_id
      storeName: storeName,
      shiftDate: shiftDate,
      planStartTime: _parseTime(shiftTime?.startTime) ?? now,
      planEndTime: _parseTime(shiftTime?.endTime) ?? now,
      targetCount: 0, // RPC doesn't return target_count
      currentCount: 0, // RPC doesn't return current_count
      shiftName: shiftName,
    );
  }

  /// Parse time string (HH:MM or HH:MM:SS) to DateTime
  ///
  /// NOTE: RPC returns times already converted to local timezone via p_timezone parameter.
  /// DO NOT apply additional UTC-to-local conversion - times are already local!
  DateTime? _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;

    try {
      // If full datetime (ISO8601 format)
      if (timeStr.contains('T') || timeStr.length > 10) {
        // RPC returns local time, parse as-is without timezone conversion
        final parsed = DateTime.parse(timeStr);
        return parsed;
      }

      // If time only (HH:MM or HH:MM:SS), combine with shiftDate
      // RPC returns local time strings (e.g., "07:09" means 07:09 local time)
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final second = parts.length >= 3 ? int.parse(parts[2]) : 0;

        // Parse shiftDate (already in local date format from RPC)
        final dateParts = shiftDate.split('-');
        if (dateParts.length == 3) {
          // Create as local DateTime directly - NO UTC conversion needed
          // RPC already converted times to local timezone
          return DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            hour,
            minute,
            second,
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Extension to map TagDto → Tag Entity
///
/// NOTE: RPC returns times already converted to local timezone via p_timezone parameter.
/// DO NOT apply additional UTC-to-local conversion - times are already local!
extension TagDtoMapper on TagDto {
  Tag toEntity() {
    return Tag(
      tagId: id ?? '',
      cardId: '', // RPC doesn't return card_id, will be set at card level
      tagType: type ?? '',
      tagContent: content ?? '',
      createdAt: createdAt != null
          ? DateTime.parse(createdAt!) // Parse as-is, already local time from RPC
          : DateTime.now(),
      createdBy: createdBy ?? '',
    );
  }
}

/// Extension to map ManagerMemoDto → ManagerMemo Entity
///
/// v4: Maps manager_memo jsonb array items to domain entity
extension ManagerMemoDtoMapper on ManagerMemoDto {
  ManagerMemo toEntity() {
    return ManagerMemo(
      type: type ?? 'note',
      content: content ?? '',
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}

/// Extension to map ProblemDetailsDto → ProblemDetails Entity
///
/// v5: Maps problem_details jsonb to domain entity
extension ProblemDetailsDtoMapper on ProblemDetailsDto {
  ProblemDetails toEntity() {
    // Pass root-level isSolved to each problem item
    final rootIsSolved = isSolved;
    return ProblemDetails(
      hasLate: hasLate,
      hasOvertime: hasOvertime,
      hasReported: hasReported,
      hasNoCheckout: hasNoCheckout,
      hasAbsence: hasAbsence,
      hasEarlyLeave: hasEarlyLeave,
      hasLocationIssue: hasLocationIssue,
      hasPayrollLate: hasPayrollLate,
      hasPayrollOvertime: hasPayrollOvertime,
      hasPayrollEarlyLeave: hasPayrollEarlyLeave,
      problemCount: problemCount,
      isSolved: isSolved,
      detectedAt: detectedAt != null ? DateTime.tryParse(detectedAt!) : null,
      problems: problems.map((p) => p.toEntity(rootIsSolved)).toList(),
    );
  }
}

/// Extension to map ProblemItemDto → ProblemItem Entity
///
/// v5: Maps individual problem items from jsonb array
/// - For 'reported' type: uses isReportSolved (null = pending, true = approved, false = rejected)
/// - For other types (late, overtime, no_checkout, etc.): uses root-level isSolved
extension ProblemItemDtoMapper on ProblemItemDto {
  ProblemItem toEntity(bool rootIsSolved) {
    // reported type has its own nullable solve status, others use root-level
    final bool? itemIsSolved = type == 'reported' ? isReportSolved : rootIsSolved;
    return ProblemItem(
      type: type ?? 'unknown',
      actualMinutes: actualMinutes,
      payrollMinutes: payrollMinutes,
      isPayrollAdjusted: isPayrollAdjusted,
      reason: reason,
      reportedAt: reportedAt != null ? DateTime.tryParse(reportedAt!) : null,
      isSolved: itemIsSolved,
    );
  }
}
