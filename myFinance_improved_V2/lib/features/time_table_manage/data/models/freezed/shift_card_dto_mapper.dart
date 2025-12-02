import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/tag.dart';
import 'shift_card_dto.dart';

/// Extension to map ShiftCardDto → Domain Entity
///
/// Separates DTO (data layer) from Entity (domain layer)
/// v3: Uses shiftDate (from start_time_utc) instead of requestDate
extension ShiftCardDtoMapper on ShiftCardDto {
  /// Convert DTO to Domain Entity
  ShiftCard toEntity() {
    return ShiftCard(
      shiftRequestId: shiftRequestId,
      employee: _mapEmployee(),
      shift: _mapShift(),
      shiftDate: shiftDate,
      isApproved: isApproved,
      hasProblem: isProblem,
      isProblemSolved: isProblemSolved,
      isLate: isLate,
      lateMinute: lateMinute,
      isOverTime: isOverTime,
      overTimeMinute: overTimeMinute,
      paidHour: paidHour,
      isReported: isReported,
      bonusAmount: bonusAmount,
      bonusReason: null, // Not in RPC
      confirmedStartTime: _parseTime(confirmStartTime),
      confirmedEndTime: _parseTime(confirmEndTime),
      actualStartTime: _parseTime(actualStart),
      actualEndTime: _parseTime(actualEnd),
      isValidCheckinLocation: isValidCheckinLocation,
      checkinDistanceFromStore: checkinDistanceFromStore,
      isValidCheckoutLocation: isValidCheckoutLocation,
      checkoutDistanceFromStore: checkoutDistanceFromStore,
      salaryType: salaryType,
      salaryAmount: salaryAmount,
      tags: noticeTags.map((tag) => tag.toEntity()).toList(),
      problemType: problemType,
      reportReason: reportReason,
      createdAt: DateTime.now(), // RPC doesn't return created_at
      approvedAt: null, // RPC doesn't return approved_at
    );
  }

  /// Map DTO user fields to EmployeeInfo entity
  EmployeeInfo _mapEmployee() {
    return EmployeeInfo(
      userId: '', // RPC doesn't return user_id in this format
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
