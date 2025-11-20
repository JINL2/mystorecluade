import 'employee_info.dart';
import 'shift.dart';
import 'tag.dart';

/// Shift Card Entity
///
/// Represents a comprehensive view of a shift assignment with all relevant
/// information including employee, shift details, approval status, and tags.
class ShiftCard {
  /// The shift request ID
  final String shiftRequestId;

  /// Employee information
  final EmployeeInfo employee;

  /// Shift information
  final Shift shift;

  /// The date of the shift request (yyyy-MM-dd format)
  final String requestDate;

  /// Whether the shift is approved
  final bool isApproved;

  /// Whether there's a problem with this shift
  final bool hasProblem;

  /// Whether the problem has been solved
  final bool isProblemSolved;

  /// Whether the employee was late
  final bool isLate;

  /// Late duration in minutes
  final int lateMinute;

  /// Whether the employee worked overtime
  final bool isOverTime;

  /// Overtime duration in minutes
  final int overTimeMinute;

  /// Paid hours for this shift
  final double paidHour;

  /// Whether this shift has been reported
  final bool isReported;

  /// Bonus amount (if any)
  final double? bonusAmount;

  /// Reason for bonus (if any)
  final String? bonusReason;

  /// Confirmed start time (manager-confirmed start time)
  final DateTime? confirmedStartTime;

  /// Confirmed end time (manager-confirmed end time)
  final DateTime? confirmedEndTime;

  /// Actual start time (employee's actual check-in time from device)
  final DateTime? actualStartTime;

  /// Actual end time (employee's actual check-out time from device)
  final DateTime? actualEndTime;

  /// Check-in location validity
  final bool? isValidCheckinLocation;

  /// Check-in distance from store in meters
  final double? checkinDistanceFromStore;

  /// Check-out location validity
  final bool? isValidCheckoutLocation;

  /// Check-out distance from store in meters
  final double? checkoutDistanceFromStore;

  /// Salary type ('hourly' or 'monthly')
  final String? salaryType;

  /// Salary amount (hourly rate or monthly salary)
  final String? salaryAmount;

  /// List of tags associated with this shift card
  final List<Tag> tags;

  /// Problem type (e.g., "late", "early_checkout", etc.)
  final String? problemType;

  /// Report reason if this shift was reported
  final String? reportReason;

  /// When the request was created
  final DateTime createdAt;

  /// When the request was approved (if approved)
  final DateTime? approvedAt;

  const ShiftCard({
    required this.shiftRequestId,
    required this.employee,
    required this.shift,
    required this.requestDate,
    required this.isApproved,
    required this.hasProblem,
    this.isProblemSolved = false,
    this.isLate = false,
    this.lateMinute = 0,
    this.isOverTime = false,
    this.overTimeMinute = 0,
    this.paidHour = 0.0,
    this.isReported = false,
    this.bonusAmount,
    this.bonusReason,
    this.confirmedStartTime,
    this.confirmedEndTime,
    this.actualStartTime,
    this.actualEndTime,
    this.isValidCheckinLocation,
    this.checkinDistanceFromStore,
    this.isValidCheckoutLocation,
    this.checkoutDistanceFromStore,
    this.salaryType,
    this.salaryAmount,
    this.tags = const [],
    this.problemType,
    this.reportReason,
    required this.createdAt,
    this.approvedAt,
  });

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
    if (confirmedStartTime != null) {
      return confirmedStartTime!.isAfter(shift.planStartTime);
    }

    return false;
  }

  /// Copy with method for immutability
  ShiftCard copyWith({
    String? shiftRequestId,
    EmployeeInfo? employee,
    Shift? shift,
    String? requestDate,
    bool? isApproved,
    bool? hasProblem,
    bool? isProblemSolved,
    bool? isLate,
    int? lateMinute,
    bool? isOverTime,
    int? overTimeMinute,
    double? paidHour,
    bool? isReported,
    double? bonusAmount,
    String? bonusReason,
    DateTime? confirmedStartTime,
    DateTime? confirmedEndTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    bool? isValidCheckinLocation,
    double? checkinDistanceFromStore,
    bool? isValidCheckoutLocation,
    double? checkoutDistanceFromStore,
    List<Tag>? tags,
    DateTime? createdAt,
    DateTime? approvedAt,
  }) {
    return ShiftCard(
      shiftRequestId: shiftRequestId ?? this.shiftRequestId,
      employee: employee ?? this.employee,
      shift: shift ?? this.shift,
      requestDate: requestDate ?? this.requestDate,
      isApproved: isApproved ?? this.isApproved,
      hasProblem: hasProblem ?? this.hasProblem,
      isProblemSolved: isProblemSolved ?? this.isProblemSolved,
      isLate: isLate ?? this.isLate,
      lateMinute: lateMinute ?? this.lateMinute,
      isOverTime: isOverTime ?? this.isOverTime,
      overTimeMinute: overTimeMinute ?? this.overTimeMinute,
      paidHour: paidHour ?? this.paidHour,
      isReported: isReported ?? this.isReported,
      bonusAmount: bonusAmount ?? this.bonusAmount,
      bonusReason: bonusReason ?? this.bonusReason,
      confirmedStartTime: confirmedStartTime ?? this.confirmedStartTime,
      confirmedEndTime: confirmedEndTime ?? this.confirmedEndTime,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      isValidCheckinLocation: isValidCheckinLocation ?? this.isValidCheckinLocation,
      checkinDistanceFromStore: checkinDistanceFromStore ?? this.checkinDistanceFromStore,
      isValidCheckoutLocation: isValidCheckoutLocation ?? this.isValidCheckoutLocation,
      checkoutDistanceFromStore: checkoutDistanceFromStore ?? this.checkoutDistanceFromStore,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }

  @override
  String toString() {
    return 'ShiftCard(id: $shiftRequestId, employee: ${employee.userName}, date: $requestDate, approved: $isApproved)';
  }
}
