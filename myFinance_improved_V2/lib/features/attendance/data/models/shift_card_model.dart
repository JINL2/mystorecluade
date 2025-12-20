import '../../domain/entities/manager_memo.dart';
import '../../domain/entities/problem_details.dart';
import '../../domain/entities/shift_card.dart';

/// Shift Card Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for ShiftCard entity.
/// Clean Architecture: Data layer handles JSON, Domain stays pure.
///
/// v5 변경사항:
/// - 개별 문제 컬럼 제거 (is_late, late_minutes, is_extratime 등)
/// - problem_details JSONB 추가 (모든 문제 정보 통합)
class ShiftCardModel {
  // Basic info - v5에서 shift_date로 변경됨
  final String requestDate; // v5: shift_date
  final String shiftRequestId;
  final String? shiftName;
  final String shiftStartTime; // e.g., "2025-06-01T14:00:00"
  final String shiftEndTime; // e.g., "2025-06-01T18:00:00"
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

  // Pay
  final String basePay;
  final double bonusAmount;
  final String totalPayWithBonus;
  final String salaryType;
  final String salaryAmount;

  // v5: Problem details (JSONB) - 모든 문제 정보 통합
  final ProblemDetailsModel? problemDetails;

  // v7: Manager memos (JSONB array)
  final List<ManagerMemoModel> managerMemos;

  const ShiftCardModel({
    required this.requestDate,
    required this.shiftRequestId,
    this.shiftName,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.storeName,
    required this.scheduledHours,
    required this.isApproved,
    this.actualStartTime,
    this.actualEndTime,
    this.confirmStartTime,
    this.confirmEndTime,
    required this.paidHours,
    required this.basePay,
    required this.bonusAmount,
    required this.totalPayWithBonus,
    required this.salaryType,
    required this.salaryAmount,
    this.problemDetails,
    this.managerMemos = const [],
  });

  /// Create from JSON (from RPC: user_shift_cards_v7)
  factory ShiftCardModel.fromJson(Map<String, dynamic> json) {
    // Parse problem_details JSONB
    ProblemDetailsModel? parsedProblemDetails;
    final problemDetailsJson = json['problem_details'];
    if (problemDetailsJson != null && problemDetailsJson is Map<String, dynamic>) {
      parsedProblemDetails = ProblemDetailsModel.fromJson(problemDetailsJson);
    }

    // Parse manager_memo JSONB array (v7)
    List<ManagerMemoModel> parsedManagerMemos = [];
    final managerMemoJson = json['manager_memo'];
    if (managerMemoJson != null && managerMemoJson is List) {
      parsedManagerMemos = managerMemoJson
          .where((item) => item is Map<String, dynamic>)
          .map((item) => ManagerMemoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return ShiftCardModel(
      // v5: shift_date (하위 호환성을 위해 request_date도 체크)
      requestDate: (json['shift_date'] ?? json['request_date'] ?? '') as String,
      shiftRequestId: json['shift_request_id'] as String,
      shiftName: json['shift_name'] as String?,
      shiftStartTime: json['shift_start_time'] as String? ?? '',
      shiftEndTime: json['shift_end_time'] as String? ?? '',
      storeName: json['store_name'] as String? ?? '',
      scheduledHours: (json['scheduled_hours'] as num?)?.toDouble() ?? 0.0,
      isApproved: json['is_approved'] as bool? ?? false,
      actualStartTime: json['actual_start_time'] as String?,
      actualEndTime: json['actual_end_time'] as String?,
      confirmStartTime: json['confirm_start_time'] as String?,
      confirmEndTime: json['confirm_end_time'] as String?,
      paidHours: (json['paid_hours'] as num?)?.toDouble() ?? 0.0,
      basePay: json['base_pay'] as String? ?? '0',
      bonusAmount: (json['bonus_amount'] as num?)?.toDouble() ?? 0.0,
      totalPayWithBonus: json['total_pay_with_bonus'] as String? ?? '0',
      salaryType: json['salary_type'] as String? ?? 'hourly',
      salaryAmount: json['salary_amount'] as String? ?? '0',
      problemDetails: parsedProblemDetails,
      managerMemos: parsedManagerMemos,
    );
  }

  /// Convert to Domain Entity
  ShiftCard toEntity() {
    return ShiftCard(
      requestDate: requestDate,
      shiftRequestId: shiftRequestId,
      shiftName: shiftName,
      shiftStartTime: shiftStartTime,
      shiftEndTime: shiftEndTime,
      storeName: storeName,
      scheduledHours: scheduledHours,
      isApproved: isApproved,
      actualStartTime: actualStartTime,
      actualEndTime: actualEndTime,
      confirmStartTime: confirmStartTime,
      confirmEndTime: confirmEndTime,
      paidHours: paidHours,
      basePay: basePay,
      bonusAmount: bonusAmount,
      totalPayWithBonus: totalPayWithBonus,
      salaryType: salaryType,
      salaryAmount: salaryAmount,
      problemDetails: problemDetails?.toEntity(),
      managerMemos: managerMemos.map((m) => m.toEntity()).toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift_date': requestDate,
      'shift_request_id': shiftRequestId,
      'shift_name': shiftName,
      'shift_start_time': shiftStartTime,
      'shift_end_time': shiftEndTime,
      'store_name': storeName,
      'scheduled_hours': scheduledHours,
      'is_approved': isApproved,
      'actual_start_time': actualStartTime,
      'actual_end_time': actualEndTime,
      'confirm_start_time': confirmStartTime,
      'confirm_end_time': confirmEndTime,
      'paid_hours': paidHours,
      'base_pay': basePay,
      'bonus_amount': bonusAmount,
      'total_pay_with_bonus': totalPayWithBonus,
      'salary_type': salaryType,
      'salary_amount': salaryAmount,
      'problem_details': problemDetails?.toJson(),
      'manager_memo': managerMemos.map((m) => m.toJson()).toList(),
    };
  }
}

/// Problem Details Model (DTO)
///
/// Maps problem_details JSONB from RPC v5
class ProblemDetailsModel {
  final bool hasLate;
  final bool hasAbsence;
  final bool hasOvertime;
  final bool hasEarlyLeave;
  final bool hasNoCheckout;
  final bool hasLocationIssue;
  final bool hasReported;
  final bool isSolved;
  final int problemCount;
  final String? detectedAt;
  final List<ProblemItemModel> problems;

  const ProblemDetailsModel({
    this.hasLate = false,
    this.hasAbsence = false,
    this.hasOvertime = false,
    this.hasEarlyLeave = false,
    this.hasNoCheckout = false,
    this.hasLocationIssue = false,
    this.hasReported = false,
    this.isSolved = false,
    this.problemCount = 0,
    this.detectedAt,
    this.problems = const [],
  });

  factory ProblemDetailsModel.fromJson(Map<String, dynamic> json) {
    List<ProblemItemModel> parsedProblems = [];
    final problemsJson = json['problems'];
    if (problemsJson != null && problemsJson is List) {
      parsedProblems = problemsJson
          .where((item) => item is Map<String, dynamic>)
          .map((item) => ProblemItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return ProblemDetailsModel(
      hasLate: json['has_late'] as bool? ?? false,
      hasAbsence: json['has_absence'] as bool? ?? false,
      hasOvertime: json['has_overtime'] as bool? ?? false,
      hasEarlyLeave: json['has_early_leave'] as bool? ?? false,
      hasNoCheckout: json['has_no_checkout'] as bool? ?? false,
      hasLocationIssue: json['has_location_issue'] as bool? ?? false,
      hasReported: json['has_reported'] as bool? ?? false,
      isSolved: json['is_solved'] as bool? ?? false,
      problemCount: json['problem_count'] as int? ?? 0,
      detectedAt: json['detected_at'] as String?,
      problems: parsedProblems,
    );
  }

  ProblemDetails toEntity() {
    return ProblemDetails(
      hasLate: hasLate,
      hasAbsence: hasAbsence,
      hasOvertime: hasOvertime,
      hasEarlyLeave: hasEarlyLeave,
      hasNoCheckout: hasNoCheckout,
      hasLocationIssue: hasLocationIssue,
      hasReported: hasReported,
      isSolved: isSolved,
      problemCount: problemCount,
      detectedAt: detectedAt,
      problems: problems.map((p) => p.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_late': hasLate,
      'has_absence': hasAbsence,
      'has_overtime': hasOvertime,
      'has_early_leave': hasEarlyLeave,
      'has_no_checkout': hasNoCheckout,
      'has_location_issue': hasLocationIssue,
      'has_reported': hasReported,
      'is_solved': isSolved,
      'problem_count': problemCount,
      'detected_at': detectedAt,
      'problems': problems.map((p) => p.toJson()).toList(),
    };
  }
}

/// Problem Item Model (DTO)
///
/// Individual problem entry in problems array
class ProblemItemModel {
  final String type;
  final int? actualMinutes;
  final int? payrollMinutes;
  final bool isPayrollAdjusted;
  final String? reason;
  final String? reportedAt;
  final bool isReportSolved;
  final int? distance; // for location issues

  const ProblemItemModel({
    required this.type,
    this.actualMinutes,
    this.payrollMinutes,
    this.isPayrollAdjusted = false,
    this.reason,
    this.reportedAt,
    this.isReportSolved = false,
    this.distance,
  });

  factory ProblemItemModel.fromJson(Map<String, dynamic> json) {
    return ProblemItemModel(
      type: json['type'] as String? ?? 'unknown',
      actualMinutes: json['actual_minutes'] as int?,
      payrollMinutes: json['payroll_minutes'] as int?,
      isPayrollAdjusted: json['is_payroll_adjusted'] as bool? ?? false,
      reason: json['reason'] as String?,
      reportedAt: json['reported_at'] as String?,
      isReportSolved: json['is_report_solved'] as bool? ?? false,
      distance: json['distance'] as int?,
    );
  }

  Problem toEntity() {
    switch (type) {
      case 'late':
        return Problem.late(
          actualMinutes: actualMinutes ?? 0,
          payrollMinutes: payrollMinutes ?? 0,
          isPayrollAdjusted: isPayrollAdjusted,
        );
      case 'overtime':
        return Problem.overtime(
          actualMinutes: actualMinutes ?? 0,
          payrollMinutes: payrollMinutes ?? 0,
          isPayrollAdjusted: isPayrollAdjusted,
        );
      case 'early_leave':
        return Problem.earlyLeave(
          actualMinutes: actualMinutes ?? 0,
          payrollMinutes: payrollMinutes ?? 0,
          isPayrollAdjusted: isPayrollAdjusted,
        );
      case 'absence':
        return const Problem.absence();
      case 'no_checkout':
        return const Problem.noCheckout();
      case 'invalid_checkin':
        return Problem.invalidCheckin(distance: distance ?? 0);
      case 'invalid_checkout':
        return Problem.invalidCheckout(distance: distance ?? 0);
      case 'reported':
        return Problem.reported(
          reason: reason ?? '',
          reportedAt: reportedAt,
          isReportSolved: isReportSolved,
        );
      default:
        // Unknown type - default to reported with type as reason
        return Problem.reported(reason: 'Unknown: $type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (actualMinutes != null) 'actual_minutes': actualMinutes,
      if (payrollMinutes != null) 'payroll_minutes': payrollMinutes,
      'is_payroll_adjusted': isPayrollAdjusted,
      if (reason != null) 'reason': reason,
      if (reportedAt != null) 'reported_at': reportedAt,
      'is_report_solved': isReportSolved,
      if (distance != null) 'distance': distance,
    };
  }
}

/// Manager Memo Model (DTO)
///
/// Maps manager_memo_v2 JSONB array from RPC v7
class ManagerMemoModel {
  final String? id;
  final String content;
  final String? createdAt;
  final String? createdBy;

  const ManagerMemoModel({
    this.id,
    this.content = '',
    this.createdAt,
    this.createdBy,
  });

  factory ManagerMemoModel.fromJson(Map<String, dynamic> json) {
    return ManagerMemoModel(
      id: json['id'] as String?,
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      createdBy: json['created_by'] as String?,
    );
  }

  ManagerMemo toEntity() {
    return ManagerMemo(
      id: id,
      content: content,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
    };
  }
}
