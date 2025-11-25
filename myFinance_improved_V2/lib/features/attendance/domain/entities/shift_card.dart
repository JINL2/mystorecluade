import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_card.freezed.dart';
part 'shift_card.g.dart';

/// Shift Card Entity - from user_shift_cards_v2 RPC
/// Represents a user's shift card with attendance details
@freezed
class ShiftCard with _$ShiftCard {
  const ShiftCard._();

  const factory ShiftCard({
    // Basic info
    @JsonKey(name: 'request_date') required String requestDate,
    @JsonKey(name: 'shift_request_id') required String shiftRequestId,
    @JsonKey(name: 'shift_time') required String shiftTime,
    @JsonKey(name: 'store_name') required String storeName,

    // Schedule
    @JsonKey(name: 'scheduled_hours') required double scheduledHours,
    @JsonKey(name: 'is_approved') required bool isApproved,

    // Actual times (nullable - might not be checked in/out yet)
    @JsonKey(name: 'actual_start_time') String? actualStartTime,
    @JsonKey(name: 'actual_end_time') String? actualEndTime,
    @JsonKey(name: 'confirm_start_time') String? confirmStartTime,
    @JsonKey(name: 'confirm_end_time') String? confirmEndTime,

    // Work hours
    @JsonKey(name: 'paid_hours') required double paidHours,

    // Late status
    @JsonKey(name: 'is_late') required bool isLate,
    @JsonKey(name: 'late_minutes') required num lateMinutes,
    @JsonKey(name: 'late_deducut_amount') required double lateDeducutAmount,

    // Overtime
    @JsonKey(name: 'is_extratime') required bool isExtratime,
    @JsonKey(name: 'overtime_minutes') required num overtimeMinutes,

    // Pay (some are formatted strings with commas)
    @JsonKey(name: 'base_pay') required String basePay,
    @JsonKey(name: 'bonus_amount') required double bonusAmount,
    @JsonKey(name: 'total_pay_with_bonus') required String totalPayWithBonus,
    @JsonKey(name: 'salary_type') required String salaryType,
    @JsonKey(name: 'salary_amount') required String salaryAmount,

    // Location validation
    @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,
    @JsonKey(name: 'checkin_distance_from_store') double? checkinDistanceFromStore,
    @JsonKey(name: 'checkout_distance_from_store') double? checkoutDistanceFromStore,

    // Problem reporting
    @JsonKey(name: 'is_reported') required bool isReported,
    @JsonKey(name: 'is_problem') required bool isProblem,
    @JsonKey(name: 'is_problem_solved') required bool isProblemSolved,
  }) = _ShiftCard;

  factory ShiftCard.fromJson(Map<String, dynamic> json) =>
      _$ShiftCardFromJson(json);

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
