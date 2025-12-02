import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_card.freezed.dart';

/// Shift Card Entity - from user_shift_cards_v4 RPC
///
/// Represents a user's shift card with attendance details.
/// Pure domain entity - JSON serialization handled by Data layer (ShiftCardModel).
@freezed
class ShiftCard with _$ShiftCard {
  const ShiftCard._();

  const factory ShiftCard({
    // Basic info
    required String requestDate,
    required String shiftRequestId,
    String? shiftName, // e.g., "Afternoon", "Morning"
    required String shiftStartTime, // e.g., "2025-06-01T14:00:00"
    required String shiftEndTime, // e.g., "2025-06-01T18:00:00"
    required String storeName,

    // Schedule
    required double scheduledHours,
    required bool isApproved,

    // Actual times (nullable - might not be checked in/out yet)
    String? actualStartTime,
    String? actualEndTime,
    String? confirmStartTime,
    String? confirmEndTime,

    // Work hours
    required double paidHours,

    // Late status
    required bool isLate,
    required num lateMinutes,
    required double lateDeducutAmount,

    // Overtime
    required bool isExtratime,
    required num overtimeMinutes,

    // Pay (some are formatted strings with commas)
    required String basePay,
    required double bonusAmount,
    required String totalPayWithBonus,
    required String salaryType,
    required String salaryAmount,

    // Location validation
    bool? isValidCheckinLocation,
    double? checkinDistanceFromStore,
    double? checkoutDistanceFromStore,

    // Problem reporting
    required bool isReported,
    required bool isProblem,
    required bool isProblemSolved,
  }) = _ShiftCard;

  /// Check if user has checked in
  bool get isCheckedIn => actualStartTime != null || confirmStartTime != null;

  /// Check if user has checked out
  bool get isCheckedOut => actualEndTime != null || confirmEndTime != null;

  /// Get work status
  String get workStatus {
    if (!isApproved) return 'Pending Approval';
    if (isCheckedIn && !isCheckedOut) return 'Working';
    if (isCheckedIn && isCheckedOut) return 'Completed';
    return 'Approved';
  }

  /// Parse base_pay to double (remove commas)
  double get basePayAmount {
    try {
      return double.parse(basePay.replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }

  /// Parse total_pay_with_bonus to double
  double get totalPayAmount {
    try {
      return double.parse(totalPayWithBonus.replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }

  /// Parse salary_amount to double
  double get salaryAmountValue {
    try {
      return double.parse(salaryAmount.replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }
}
