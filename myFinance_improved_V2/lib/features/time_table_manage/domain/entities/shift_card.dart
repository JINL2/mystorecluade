import 'package:freezed_annotation/freezed_annotation.dart';

import 'employee_info.dart';
import 'shift.dart';
import 'tag.dart';

part 'shift_card.freezed.dart';
part 'shift_card.g.dart';

/// Shift Card Entity
///
/// Represents a comprehensive view of a shift assignment with all relevant
/// information including employee, shift details, approval status, and tags.
@freezed
class ShiftCard with _$ShiftCard {
  const ShiftCard._();

  const factory ShiftCard({
    /// The shift request ID
    @JsonKey(name: 'shift_request_id') required String shiftRequestId,

    /// Employee information
    required EmployeeInfo employee,

    /// Shift information
    required Shift shift,

    /// The date of the shift request (yyyy-MM-dd format)
    @JsonKey(name: 'request_date') required String requestDate,

    /// Whether the shift is approved
    @JsonKey(name: 'is_approved') required bool isApproved,

    /// Whether there's a problem with this shift
    @JsonKey(name: 'is_problem') required bool hasProblem,

    /// Whether the problem has been solved
    @JsonKey(name: 'is_problem_solved', defaultValue: false)
    required bool isProblemSolved,

    /// Whether the employee was late
    @JsonKey(name: 'is_late', defaultValue: false) required bool isLate,

    /// Late duration in minutes
    @JsonKey(name: 'late_minute', defaultValue: 0) required int lateMinute,

    /// Whether the employee worked overtime
    @JsonKey(name: 'is_over_time', defaultValue: false)
    required bool isOverTime,

    /// Overtime duration in minutes
    @JsonKey(name: 'over_time_minute', defaultValue: 0)
    required int overTimeMinute,

    /// Paid hours for this shift
    @JsonKey(name: 'paid_hour', defaultValue: 0.0) required double paidHour,

    /// Whether this shift has been reported
    @JsonKey(name: 'is_reported', defaultValue: false)
    required bool isReported,

    /// Bonus amount (if any)
    @JsonKey(name: 'bonus_amount') double? bonusAmount,

    /// Reason for bonus (if any)
    @JsonKey(name: 'bonus_reason') String? bonusReason,

    /// Confirmed start time (manager-confirmed start time)
    @JsonKey(name: 'confirm_start_time') DateTime? confirmedStartTime,

    /// Confirmed end time (manager-confirmed end time)
    @JsonKey(name: 'confirm_end_time') DateTime? confirmedEndTime,

    /// Actual start time (employee's actual check-in time from device)
    @JsonKey(name: 'actual_start') DateTime? actualStartTime,

    /// Actual end time (employee's actual check-out time from device)
    @JsonKey(name: 'actual_end') DateTime? actualEndTime,

    /// Check-in location validity
    @JsonKey(name: 'is_valid_checkin_location') bool? isValidCheckinLocation,

    /// Check-in distance from store in meters
    @JsonKey(name: 'checkin_distance_from_store')
    double? checkinDistanceFromStore,

    /// Check-out location validity
    @JsonKey(name: 'is_valid_checkout_location')
    bool? isValidCheckoutLocation,

    /// Check-out distance from store in meters
    @JsonKey(name: 'checkout_distance_from_store')
    double? checkoutDistanceFromStore,

    /// Salary type ('hourly' or 'monthly')
    @JsonKey(name: 'salary_type') String? salaryType,

    /// Salary amount (hourly rate or monthly salary)
    @JsonKey(name: 'salary_amount') String? salaryAmount,

    /// List of tags associated with this shift card
    @JsonKey(name: 'notice_tag', defaultValue: <Tag>[]) required List<Tag> tags,

    /// Problem type (e.g., "late", "early_checkout", etc.)
    @JsonKey(name: 'problem_type') String? problemType,

    /// Report reason if this shift was reported
    @JsonKey(name: 'report_reason') String? reportReason,

    /// When the request was created (optional, not returned by RPC)
    @JsonKey(name: 'created_at') DateTime? createdAt,

    /// When the request was approved (if approved)
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
  }) = _ShiftCard;

  /// Create from JSON
  factory ShiftCard.fromJson(Map<String, dynamic> json) =>
      _$ShiftCardFromJson(json);

  /// Check if shift is pending approval
  bool get isPending => !isApproved;

  /// Check if shift has bonus
  bool get hasBonus => bonusAmount != null && bonusAmount! > 0;

  /// Check if shift has confirmed times
  bool get hasConfirmedTimes =>
      confirmedStartTime != null && confirmedEndTime != null;

  /// Check if shift has tags
  bool get hasTags => tags.isNotEmpty;

  /// Get number of tags
  int get tagsCount => tags.length;

  /// Calculate actual work duration in hours (if confirmed times exist)
  double? get actualWorkDurationInHours {
    if (confirmedStartTime == null || confirmedEndTime == null) return null;
    final duration = confirmedEndTime!.difference(confirmedStartTime!);
    return duration.inMinutes / 60.0;
  }

  /// Get estimated earnings (shift duration * hourly rate + bonus)
  double get estimatedEarnings {
    // This is a simplified calculation
    // In a real app, you'd get hourly rate from employee data
    final basePay = shift.durationInHours * 10.0; // Placeholder hourly rate
    return basePay + (bonusAmount ?? 0.0);
  }

  /// Get bonus tags
  List<Tag> get bonusTags {
    return tags.where((tag) => tag.isBonus).toList();
  }

  /// Get warning tags
  List<Tag> get warningTags {
    return tags.where((tag) => tag.isWarning).toList();
  }

  /// Get late tags
  List<Tag> get lateTags {
    return tags.where((tag) => tag.isLate).toList();
  }

  /// Check if employee was late (based on tags or confirmed times)
  bool get wasLate {
    // Check if there's a "late" tag
    if (lateTags.isNotEmpty) return true;

    // Or check if confirmed start time is after planned start time
    if (confirmedStartTime != null && shift.planStartTime != null) {
      return confirmedStartTime!.isAfter(shift.planStartTime!);
    }

    return false;
  }
}
