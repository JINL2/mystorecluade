import '../../domain/entities/shift_card.dart';

/// Shift Card Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for ShiftCard entity.
/// Clean Architecture: Data layer handles JSON, Domain stays pure.
class ShiftCardModel {
  // Basic info
  final String requestDate;
  final String shiftRequestId;
  final String? shiftName;
  final String shiftTime;
  final String storeName;

  // Schedule
  final double scheduledHours;
  final bool isApproved;

  // Actual times
  final String? actualStartTime;
  final String? actualEndTime;
  final String? confirmStartTime;
  final String? confirmEndTime;

  // Work hours
  final double paidHours;

  // Late status
  final bool isLate;
  final num lateMinutes;
  final double lateDeducutAmount;

  // Overtime
  final bool isExtratime;
  final num overtimeMinutes;

  // Pay
  final String basePay;
  final double bonusAmount;
  final String totalPayWithBonus;
  final String salaryType;
  final String salaryAmount;

  // Location validation
  final bool? isValidCheckinLocation;
  final double? checkinDistanceFromStore;
  final double? checkoutDistanceFromStore;

  // Problem reporting
  final bool isReported;
  final bool isProblem;
  final bool isProblemSolved;

  const ShiftCardModel({
    required this.requestDate,
    required this.shiftRequestId,
    this.shiftName,
    required this.shiftTime,
    required this.storeName,
    required this.scheduledHours,
    required this.isApproved,
    this.actualStartTime,
    this.actualEndTime,
    this.confirmStartTime,
    this.confirmEndTime,
    required this.paidHours,
    required this.isLate,
    required this.lateMinutes,
    required this.lateDeducutAmount,
    required this.isExtratime,
    required this.overtimeMinutes,
    required this.basePay,
    required this.bonusAmount,
    required this.totalPayWithBonus,
    required this.salaryType,
    required this.salaryAmount,
    this.isValidCheckinLocation,
    this.checkinDistanceFromStore,
    this.checkoutDistanceFromStore,
    required this.isReported,
    required this.isProblem,
    required this.isProblemSolved,
  });

  /// Create from JSON (from RPC: user_shift_cards_v4)
  factory ShiftCardModel.fromJson(Map<String, dynamic> json) {
    return ShiftCardModel(
      requestDate: json['request_date'] as String,
      shiftRequestId: json['shift_request_id'] as String,
      shiftName: json['shift_name'] as String?,
      shiftTime: json['shift_time'] as String,
      storeName: json['store_name'] as String,
      scheduledHours: (json['scheduled_hours'] as num).toDouble(),
      isApproved: json['is_approved'] as bool,
      actualStartTime: json['actual_start_time'] as String?,
      actualEndTime: json['actual_end_time'] as String?,
      confirmStartTime: json['confirm_start_time'] as String?,
      confirmEndTime: json['confirm_end_time'] as String?,
      paidHours: (json['paid_hours'] as num).toDouble(),
      isLate: json['is_late'] as bool,
      lateMinutes: json['late_minutes'] as num,
      lateDeducutAmount: (json['late_deducut_amount'] as num).toDouble(),
      isExtratime: json['is_extratime'] as bool,
      overtimeMinutes: json['overtime_minutes'] as num,
      basePay: json['base_pay'] as String,
      bonusAmount: (json['bonus_amount'] as num).toDouble(),
      totalPayWithBonus: json['total_pay_with_bonus'] as String,
      salaryType: json['salary_type'] as String,
      salaryAmount: json['salary_amount'] as String,
      isValidCheckinLocation: json['is_valid_checkin_location'] as bool?,
      checkinDistanceFromStore:
          (json['checkin_distance_from_store'] as num?)?.toDouble(),
      checkoutDistanceFromStore:
          (json['checkout_distance_from_store'] as num?)?.toDouble(),
      isReported: json['is_reported'] as bool,
      isProblem: json['is_problem'] as bool,
      isProblemSolved: json['is_problem_solved'] as bool,
    );
  }

  /// Convert to Domain Entity
  ShiftCard toEntity() {
    return ShiftCard(
      requestDate: requestDate,
      shiftRequestId: shiftRequestId,
      shiftName: shiftName,
      shiftTime: shiftTime,
      storeName: storeName,
      scheduledHours: scheduledHours,
      isApproved: isApproved,
      actualStartTime: actualStartTime,
      actualEndTime: actualEndTime,
      confirmStartTime: confirmStartTime,
      confirmEndTime: confirmEndTime,
      paidHours: paidHours,
      isLate: isLate,
      lateMinutes: lateMinutes,
      lateDeducutAmount: lateDeducutAmount,
      isExtratime: isExtratime,
      overtimeMinutes: overtimeMinutes,
      basePay: basePay,
      bonusAmount: bonusAmount,
      totalPayWithBonus: totalPayWithBonus,
      salaryType: salaryType,
      salaryAmount: salaryAmount,
      isValidCheckinLocation: isValidCheckinLocation,
      checkinDistanceFromStore: checkinDistanceFromStore,
      checkoutDistanceFromStore: checkoutDistanceFromStore,
      isReported: isReported,
      isProblem: isProblem,
      isProblemSolved: isProblemSolved,
    );
  }

  /// Create from Entity (for serialization)
  factory ShiftCardModel.fromEntity(ShiftCard entity) {
    return ShiftCardModel(
      requestDate: entity.requestDate,
      shiftRequestId: entity.shiftRequestId,
      shiftName: entity.shiftName,
      shiftTime: entity.shiftTime,
      storeName: entity.storeName,
      scheduledHours: entity.scheduledHours,
      isApproved: entity.isApproved,
      actualStartTime: entity.actualStartTime,
      actualEndTime: entity.actualEndTime,
      confirmStartTime: entity.confirmStartTime,
      confirmEndTime: entity.confirmEndTime,
      paidHours: entity.paidHours,
      isLate: entity.isLate,
      lateMinutes: entity.lateMinutes,
      lateDeducutAmount: entity.lateDeducutAmount,
      isExtratime: entity.isExtratime,
      overtimeMinutes: entity.overtimeMinutes,
      basePay: entity.basePay,
      bonusAmount: entity.bonusAmount,
      totalPayWithBonus: entity.totalPayWithBonus,
      salaryType: entity.salaryType,
      salaryAmount: entity.salaryAmount,
      isValidCheckinLocation: entity.isValidCheckinLocation,
      checkinDistanceFromStore: entity.checkinDistanceFromStore,
      checkoutDistanceFromStore: entity.checkoutDistanceFromStore,
      isReported: entity.isReported,
      isProblem: entity.isProblem,
      isProblemSolved: entity.isProblemSolved,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'request_date': requestDate,
      'shift_request_id': shiftRequestId,
      'shift_name': shiftName,
      'shift_time': shiftTime,
      'store_name': storeName,
      'scheduled_hours': scheduledHours,
      'is_approved': isApproved,
      'actual_start_time': actualStartTime,
      'actual_end_time': actualEndTime,
      'confirm_start_time': confirmStartTime,
      'confirm_end_time': confirmEndTime,
      'paid_hours': paidHours,
      'is_late': isLate,
      'late_minutes': lateMinutes,
      'late_deducut_amount': lateDeducutAmount,
      'is_extratime': isExtratime,
      'overtime_minutes': overtimeMinutes,
      'base_pay': basePay,
      'bonus_amount': bonusAmount,
      'total_pay_with_bonus': totalPayWithBonus,
      'salary_type': salaryType,
      'salary_amount': salaryAmount,
      'is_valid_checkin_location': isValidCheckinLocation,
      'checkin_distance_from_store': checkinDistanceFromStore,
      'checkout_distance_from_store': checkoutDistanceFromStore,
      'is_reported': isReported,
      'is_problem': isProblem,
      'is_problem_solved': isProblemSolved,
    };
  }
}
