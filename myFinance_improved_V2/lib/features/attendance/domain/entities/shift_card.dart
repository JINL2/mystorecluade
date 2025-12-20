import 'package:freezed_annotation/freezed_annotation.dart';

import 'manager_memo.dart';
import 'problem_details.dart';

part 'shift_card.freezed.dart';

/// Shift Card Entity - from user_shift_cards_v5 RPC
///
/// Represents a user's shift card with attendance details.
/// Pure domain entity - JSON serialization handled by Data layer (ShiftCardModel).
///
/// v5 변경사항:
/// - 개별 문제 컬럼 제거 (isLate, lateMinutes, isExtratime, overtimeMinutes 등)
/// - problem_details JSONB로 통합 (ProblemDetails)
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

    // Pay (some are formatted strings with commas)
    required String basePay,
    required double bonusAmount,
    required String totalPayWithBonus,
    required String salaryType,
    required String salaryAmount,

    // 문제 상세 (JSONB) - 모든 문제 정보 통합
    ProblemDetails? problemDetails,

    // v7: 매니저 메모 (JSONB array)
    @Default([]) List<ManagerMemo> managerMemos,
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

  // ============================================
  // 문제 관련 Getter (problemDetails에서 추출)
  // ============================================

  /// 지각 여부
  bool get isLate => problemDetails?.hasLate ?? false;

  /// 지각 분
  int get lateMinutes => problemDetails?.lateMinutes ?? 0;

  /// 초과근무 여부
  bool get isExtratime => problemDetails?.hasOvertime ?? false;

  /// 초과근무 분
  int get overtimeMinutes => problemDetails?.overtimeMinutes ?? 0;

  /// 결근 여부
  bool get isAbsence => problemDetails?.hasAbsence ?? false;

  /// 조퇴 여부
  bool get isEarlyLeave => problemDetails?.hasEarlyLeave ?? false;

  /// 체크아웃 누락
  bool get hasNoCheckout => problemDetails?.hasNoCheckout ?? false;

  /// 위치 문제 여부
  bool get hasLocationIssue => problemDetails?.hasLocationIssue ?? false;

  /// 체크인 위치 유효 여부 (위치 문제가 없으면 true)
  bool get isValidCheckinLocation => !hasLocationIssue;

  /// 체크인 거리 (미터)
  int? get checkinDistanceFromStore => problemDetails?.checkinDistance;

  /// 신고됨 여부
  bool get isReported => problemDetails?.hasReported ?? false;

  /// 문제 있음 여부
  bool get isProblem => problemDetails?.hasProblem ?? false;

  /// 문제 해결됨 여부
  bool get isProblemSolved => problemDetails?.isSolved ?? false;

  /// 문제 개수
  int get problemCount => problemDetails?.problemCount ?? 0;

  // ============================================
  // 급여 관련 Getter
  // ============================================

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
