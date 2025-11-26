import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/tag.dart';
import 'shift_card_dto.dart';

/// Extension to map ShiftCardDto → Domain Entity
///
/// Separates DTO (data layer) from Entity (domain layer)
extension ShiftCardDtoMapper on ShiftCardDto {
  /// Convert DTO to Domain Entity
  ShiftCard toEntity() {
    return ShiftCard(
      shiftRequestId: shiftRequestId,
      employee: _mapEmployee(),
      shift: _mapShift(),
      requestDate: requestDate,
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
      shiftDate: requestDate,
      planStartTime: _parseTime(shiftTime?.startTime) ?? now,
      planEndTime: _parseTime(shiftTime?.endTime) ?? now,
      targetCount: 0, // RPC doesn't return target_count
      currentCount: 0, // RPC doesn't return current_count
      shiftName: shiftName,
      storeName: storeName,
    );
  }

  /// Parse time string (HH:MM or HH:MM:SS) to DateTime
  DateTime? _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;

    try {
      // If full datetime
      if (timeStr.contains('T') || timeStr.length > 10) {
        return DateTimeUtils.toLocal(timeStr);
      }

      // If time only (HH:MM or HH:MM:SS), combine with requestDate
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final second = parts.length >= 3 ? int.parse(parts[2]) : 0;

        // Parse requestDate
        final dateParts = requestDate.split('-');
        if (dateParts.length == 3) {
          final utcDateTime = DateTime.utc(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            hour,
            minute,
            second,
          );
          return utcDateTime.toLocal();
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Extension to map TagDto → Tag Entity
extension TagDtoMapper on TagDto {
  Tag toEntity() {
    return Tag(
      tagId: id ?? '',
      cardId: '', // RPC doesn't return card_id, will be set at card level
      tagType: type ?? '',
      tagContent: content ?? '',
      createdAt: createdAt != null
          ? DateTimeUtils.toLocal(createdAt!)
          : DateTime.now(),
      createdBy: createdBy ?? '',
    );
  }
}
