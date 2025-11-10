import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/shift_card.dart';
import 'employee_info_model.dart';
import 'shift_model.dart';
import 'tag_model.dart';

/// Shift Card Model (DTO + Mapper)
class ShiftCardModel {
  final String shiftRequestId;
  final EmployeeInfoModel employee;
  final ShiftModel shift;
  final String requestDate;
  final bool isApproved;
  final bool hasProblem;
  final bool isProblemSolved;
  final bool isLate;
  final int lateMinute;
  final bool isOverTime;
  final int overTimeMinute;
  final double paidHour;
  final bool isReported;
  final double? bonusAmount;
  final String? bonusReason;
  final String? confirmedStartTime;
  final String? confirmedEndTime;
  final String? actualStart;  // Actual check-in time from RPC (HH:MM:SS format)
  final String? actualEnd;    // Actual check-out time from RPC (HH:MM:SS format)
  final bool? isValidCheckinLocation;  // Check-in location validity
  final double? checkinDistanceFromStore;  // Check-in distance in meters
  final bool? isValidCheckoutLocation;  // Check-out location validity
  final double? checkoutDistanceFromStore;  // Check-out distance in meters
  final String? salaryType;  // Salary type: 'hourly' or 'monthly'
  final String? salaryAmount;  // Salary amount (hourly rate or monthly salary)
  final List<TagModel> tags;
  final String? problemType;  // Problem type from RPC
  final String? reportReason;  // Report reason from RPC
  final String createdAt;
  final String? approvedAt;

  const ShiftCardModel({
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
    this.actualStart,
    this.actualEnd,
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

  factory ShiftCardModel.fromJson(Map<String, dynamic> json) {
    try {
      // Check if data is nested or flat structure
      final bool isNested = json.containsKey('employee') && json['employee'] is Map;

      Map<String, dynamic> employeeData;
      Map<String, dynamic> shiftData;

      if (isNested) {
        // Nested structure (from direct DB query)
        employeeData = json['employee'] as Map<String, dynamic>? ?? {};
        shiftData = json['shift'] as Map<String, dynamic>? ?? {};
      } else {
        // Flat structure (from RPC)
        // RPC returns shift_time as "HH:mm-HH:mm", need to split it
        final shiftTime = json['shift_time'] as String? ?? '';
        String planStartTime = '';
        String planEndTime = '';

        if (shiftTime.contains('-')) {
          final parts = shiftTime.split('-');
          if (parts.length == 2) {
            planStartTime = parts[0].trim();
            planEndTime = parts[1].trim();
          }
        }

        employeeData = {
          'user_id': json['user_id'],
          'user_name': json['user_name'],
          'profile_image': json['profile_image'],
        };
        shiftData = {
          'shift_id': json['shift_id'],
          'store_id': json['store_id'],
          'shift_date': json['request_date'], // Use request_date as shift_date
          'shift_name': json['shift_name'],
          'plan_start_time': planStartTime,
          'plan_end_time': planEndTime,
          'target_count': json['target_count'] ?? 0,
          'current_count': json['current_count'] ?? 0,
          'tags': json['tags'] ?? [],
        };
      }

      final model = ShiftCardModel(
        shiftRequestId: json['shift_request_id'] as String? ?? '',
        employee: EmployeeInfoModel.fromJson(employeeData),
        shift: ShiftModel.fromJson(shiftData),
        requestDate: json['request_date'] as String? ?? '',
        isApproved: json['is_approved'] as bool? ?? false,
        hasProblem: json['has_problem'] as bool? ?? json['is_problem'] as bool? ?? false,
        isProblemSolved: json['is_problem_solved'] as bool? ?? false,
        isLate: json['is_late'] as bool? ?? false,
        lateMinute: (json['late_minute'] as num?)?.toInt() ?? 0,
        isOverTime: json['is_over_time'] as bool? ?? false,
        overTimeMinute: (json['over_time_minute'] as num?)?.toInt() ?? 0,
        paidHour: (json['paid_hour'] as num?)?.toDouble() ?? 0.0,
        isReported: json['is_reported'] as bool? ?? false,
        bonusAmount: json['bonus_amount'] != null
            ? (json['bonus_amount'] as num).toDouble()
            : null,
        bonusReason: json['bonus_reason'] as String?,
        confirmedStartTime: json['confirmed_start_time'] as String? ?? json['confirm_start_time'] as String?,
        confirmedEndTime: json['confirmed_end_time'] as String? ?? json['confirm_end_time'] as String?,
        actualStart: json['actual_start'] as String?,
        actualEnd: json['actual_end'] as String?,
        isValidCheckinLocation: json['is_valid_checkin_location'] as bool?,
        checkinDistanceFromStore: (json['checkin_distance_from_store'] as num?)?.toDouble(),
        isValidCheckoutLocation: json['is_valid_checkout_location'] as bool?,
        checkoutDistanceFromStore: (json['checkout_distance_from_store'] as num?)?.toDouble(),
        salaryType: json['salary_type'] as String?,
        salaryAmount: json['salary_amount'] as String?,
        tags: (json['notice_tag'] as List<dynamic>? ?? json['tags'] as List<dynamic>?)
                ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        problemType: json['problem_type'] as String?,
        reportReason: json['report_reason'] as String?,
        createdAt: json['created_at'] as String? ?? '',
        approvedAt: json['approved_at'] as String?,
      );

      return model;
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'employee': employee.toJson(),
      'shift': shift.toJson(),
      'request_date': requestDate,
      'is_approved': isApproved,
      'has_problem': hasProblem,
      if (bonusAmount != null) 'bonus_amount': bonusAmount,
      if (bonusReason != null) 'bonus_reason': bonusReason,
      if (confirmedStartTime != null) 'confirmed_start_time': confirmedStartTime,
      if (confirmedEndTime != null) 'confirmed_end_time': confirmedEndTime,
      if (salaryType != null) 'salary_type': salaryType,
      if (salaryAmount != null) 'salary_amount': salaryAmount,
      'tags': tags.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      if (approvedAt != null) 'approved_at': approvedAt,
    };
  }

  /// Helper method to parse optional time strings that might be in "HH:mm" format
  /// Combines with requestDate to create a complete datetime for DateTimeUtils
  DateTime? _parseOptionalTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty || timeStr == 'null') {
      return null;
    }

    try {
      // If it's a full ISO8601 or timestamp, use DateTimeUtils directly
      if (timeStr.contains('T') || (timeStr.contains(' ') && timeStr.length > 10) || timeStr.contains('Z')) {
        return DateTimeUtils.toLocal(timeStr);
      }

      // If it's "HH:mm" or "HH:mm:ss" format, combine with requestDate
      final timeParts = timeStr.split(':');
      if (timeParts.length >= 2) {  // Support both HH:MM and HH:MM:SS
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final second = timeParts.length >= 3 ? int.parse(timeParts[2].split('.')[0]) : 0;  // Handle HH:MM:SS or HH:MM:SS.mmm

        // Parse requestDate to get year, month, day
        if (requestDate.isNotEmpty && requestDate != 'null' && requestDate.length >= 10) {
          final dateParts = requestDate.substring(0, 10).split('-');
          // Create as UTC because RPC returns UTC time, then convert to local
          final utcDateTime = DateTime.utc(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            hour,
            minute,
            second,
          );
          return utcDateTime.toLocal();
        } else {
          // Fallback to today's date if requestDate is invalid
          final now = DateTime.now().toUtc();
          final utcDateTime = DateTime.utc(now.year, now.month, now.day, hour, minute, second);
          return utcDateTime.toLocal();
        }
      }

      // If format is unknown, try DateTimeUtils as last resort
      return DateTimeUtils.toLocal(timeStr);
    } catch (e) {
      return null;
    }
  }

  ShiftCard toEntity() {
    // Parse createdAt with fallback
    DateTime parsedCreatedAt;
    try {
      parsedCreatedAt = createdAt.isNotEmpty
          ? DateTimeUtils.toLocal(createdAt)
          : DateTime.now();
    } catch (e) {
      parsedCreatedAt = DateTime.now();
    }

    final entity = ShiftCard(
      shiftRequestId: shiftRequestId,
      employee: employee.toEntity(),
      shift: shift.toEntity(),
      requestDate: requestDate,
      isApproved: isApproved,
      hasProblem: hasProblem,
      isProblemSolved: isProblemSolved,
      isLate: isLate,
      lateMinute: lateMinute,
      isOverTime: isOverTime,
      overTimeMinute: overTimeMinute,
      paidHour: paidHour,
      isReported: isReported,
      bonusAmount: bonusAmount,
      bonusReason: bonusReason,
      confirmedStartTime: _parseOptionalTime(confirmedStartTime),
      confirmedEndTime: _parseOptionalTime(confirmedEndTime),
      actualStartTime: _parseOptionalTime(actualStart),
      actualEndTime: _parseOptionalTime(actualEnd),
      isValidCheckinLocation: isValidCheckinLocation,
      checkinDistanceFromStore: checkinDistanceFromStore,
      isValidCheckoutLocation: isValidCheckoutLocation,
      checkoutDistanceFromStore: checkoutDistanceFromStore,
      salaryType: salaryType,
      salaryAmount: salaryAmount,
      tags: tags.map((e) => e.toEntity()).toList(),
      problemType: problemType,
      reportReason: reportReason,
      createdAt: parsedCreatedAt,
      approvedAt: _parseOptionalTime(approvedAt),
    );

    return entity;
  }

  factory ShiftCardModel.fromEntity(ShiftCard entity) {
    return ShiftCardModel(
      shiftRequestId: entity.shiftRequestId,
      employee: EmployeeInfoModel.fromEntity(entity.employee),
      shift: ShiftModel.fromEntity(entity.shift),
      requestDate: entity.requestDate,
      isApproved: entity.isApproved,
      hasProblem: entity.hasProblem,
      isProblemSolved: entity.isProblemSolved,
      isLate: entity.isLate,
      lateMinute: entity.lateMinute,
      isOverTime: entity.isOverTime,
      overTimeMinute: entity.overTimeMinute,
      paidHour: entity.paidHour,
      isReported: entity.isReported,
      bonusAmount: entity.bonusAmount,
      bonusReason: entity.bonusReason,
      confirmedStartTime: entity.confirmedStartTime != null
          ? DateTimeUtils.formatTimeOnly(entity.confirmedStartTime!)
          : null,
      confirmedEndTime: entity.confirmedEndTime != null
          ? DateTimeUtils.formatTimeOnly(entity.confirmedEndTime!)
          : null,
      actualStart: entity.actualStartTime != null
          ? DateTimeUtils.formatTimeOnly(entity.actualStartTime!)
          : null,
      actualEnd: entity.actualEndTime != null
          ? DateTimeUtils.formatTimeOnly(entity.actualEndTime!)
          : null,
      isValidCheckinLocation: entity.isValidCheckinLocation,
      checkinDistanceFromStore: entity.checkinDistanceFromStore,
      isValidCheckoutLocation: entity.isValidCheckoutLocation,
      checkoutDistanceFromStore: entity.checkoutDistanceFromStore,
      tags: entity.tags.map((e) => TagModel.fromEntity(e)).toList(),
      createdAt: DateTimeUtils.toUtc(entity.createdAt),
      approvedAt: entity.approvedAt != null
          ? DateTimeUtils.toUtc(entity.approvedAt!)
          : null,
    );
  }
}
