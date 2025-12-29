import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../widgets/timesheets/staff_timelog_card.dart';
import '../utils/timelog_helpers.dart';

/// Mixin providing computed properties and state management for StaffTimelogDetailPage
///
/// Handles:
/// - Change detection for confirmed times, bonus, memo, report status
/// - Salary calculations with live preview
/// - Problem status helpers (check-in/check-out related)
mixin TimelogStateMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  // State variables to be initialized by the concrete class
  String get confirmedCheckIn;
  String get confirmedCheckOut;
  int get bonusAmount;
  int get penaltyAmount;
  TextEditingController get memoController;
  String? get issueReportStatus;
  bool get isCheckInManuallyConfirmed;
  bool get isCheckOutManuallyConfirmed;

  // Initial values for change detection
  String get initialConfirmedCheckIn;
  String get initialConfirmedCheckOut;
  int get initialBonusAmount;
  int get initialPenaltyAmount;
  String get initialMemo;
  bool? get initialIsReportedSolved;

  // Staff record accessor
  StaffTimeRecord get staffRecord;

  // ============================================================================
  // Section-level Change Detection
  // ============================================================================

  /// Check if confirmed check-in time has changed
  bool get isCheckInChanged => confirmedCheckIn != initialConfirmedCheckIn;

  /// Check if confirmed check-out time has changed
  bool get isCheckOutChanged => confirmedCheckOut != initialConfirmedCheckOut;

  /// Check if confirmed attendance section has any changes
  /// Includes time changes OR manual confirmation (even if same time value)
  bool get isConfirmedTimeChanged =>
      isCheckInChanged ||
      isCheckOutChanged ||
      isCheckInManuallyConfirmed ||
      isCheckOutManuallyConfirmed;

  /// Check if bonus amount has changed
  bool get isBonusChanged => bonusAmount != initialBonusAmount;

  /// Check if memo has changed
  bool get isMemoChanged => memoController.text != initialMemo;

  /// Check if bonus/deduct has changed (for salary breakdown display)
  bool get isBonusOrDeductChanged =>
      bonusAmount != initialBonusAmount || penaltyAmount != initialPenaltyAmount;

  /// Check if issue report status has changed from initial RPC value
  bool get isReportStatusChanged {
    if (!staffRecord.isReported) return false;
    if (issueReportStatus == null) return false;

    final userSelectedValue = issueReportStatus == 'approved';
    if (initialIsReportedSolved == null) return true;
    return userSelectedValue != initialIsReportedSolved;
  }

  /// Overall change detection - true if any section has changes
  bool get hasChanges {
    return isConfirmedTimeChanged ||
        isBonusChanged ||
        isMemoChanged ||
        isReportStatusChanged;
  }

  // ============================================================================
  // Shift Status Helpers
  // ============================================================================

  /// Check if the shift is still in progress (not yet ended)
  bool get isShiftStillInProgress {
    final shiftEndTime = staffRecord.shiftEndTime;
    if (shiftEndTime == null) return false;
    return DateTime.now().isBefore(shiftEndTime);
  }

  /// Check if fully confirmed (all problems solved or shift in progress)
  bool get isFullyConfirmed {
    if (isShiftStillInProgress) return true;

    final pd = staffRecord.problemDetails;
    if (pd == null || pd.problemCount == 0) return true;
    if (pd.isFullySolved) return true;

    return false;
  }

  // ============================================================================
  // Check-in/Check-out Problem Helpers
  // ============================================================================

  /// Problem types related to check-in
  static const checkInTypes = {'late', 'invalid_checkin'};

  /// Problem types related to check-out
  static const checkOutTypes = {
    'overtime',
    'early_leave',
    'no_checkout',
    'absence',
    'location_issue',
  };

  /// Check-in related problems: late, invalid_checkin
  bool get hasCheckInProblem {
    final pd = staffRecord.problemDetails;
    if (pd == null) return staffRecord.isLate;
    return pd.hasLate || pd.problems.any((p) => p.type == 'invalid_checkin');
  }

  /// Check-out related problems: overtime, early_leave, no_checkout, etc.
  bool get hasCheckOutProblem {
    final pd = staffRecord.problemDetails;
    if (pd == null) return staffRecord.isOvertime;
    return pd.hasOvertime ||
        pd.hasEarlyLeave ||
        pd.hasNoCheckout ||
        pd.hasAbsence ||
        pd.hasLocationIssue;
  }

  /// Check if check-in problem is unsolved
  bool get hasUnsolvedCheckInProblem {
    final pd = staffRecord.problemDetails;
    if (pd == null) {
      return staffRecord.isLate && !staffRecord.isProblemSolved;
    }
    return pd.problems.any((p) => checkInTypes.contains(p.type) && !p.isSolved);
  }

  /// Check if check-out problem is unsolved
  bool get hasUnsolvedCheckOutProblem {
    final pd = staffRecord.problemDetails;
    if (pd == null) {
      return staffRecord.isOvertime && !staffRecord.isProblemSolved;
    }
    return pd.problems
        .any((p) => checkOutTypes.contains(p.type) && !p.isSolved);
  }

  /// Check if ALL check-in problems were solved by DB
  bool get isCheckInProblemSolved {
    final pd = staffRecord.problemDetails;
    if (pd == null) return staffRecord.isProblemSolved;
    final checkInProblems =
        pd.problems.where((p) => checkInTypes.contains(p.type));
    if (checkInProblems.isEmpty) return false;
    return checkInProblems.every((p) => p.isSolved);
  }

  /// Check if ALL check-out problems were solved by DB
  bool get isCheckOutProblemSolved {
    final pd = staffRecord.problemDetails;
    if (pd == null) return staffRecord.isProblemSolved;
    final checkOutProblems =
        pd.problems.where((p) => checkOutTypes.contains(p.type));
    if (checkOutProblems.isEmpty) return false;
    return checkOutProblems.every((p) => p.isSolved);
  }

  /// Check if there's an unsolved report
  bool get hasUnsolvedReport {
    final pd = staffRecord.problemDetails;
    if (pd == null) {
      final isReportedSolved = staffRecord.isReportedSolved;
      return staffRecord.isReported &&
          (isReportedSolved == null || !isReportedSolved);
    }
    return pd.problems.any((p) => p.type == 'reported' && !p.isSolved);
  }

  // ============================================================================
  // Salary Computed Properties
  // ============================================================================

  /// Get hourly rate from staffRecord
  double get hourlyRate {
    final salaryAmountStr = staffRecord.salaryAmount;
    if (salaryAmountStr == null || salaryAmountStr.isEmpty) return 0;
    final cleaned = salaryAmountStr.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0;
  }

  /// Calculate paid hours from current confirmed times
  double get calculatedPaidHour {
    final calculated =
        TimelogHelpers.calculateHoursFromTimes(confirmedCheckIn, confirmedCheckOut);
    return calculated ?? staffRecord.paidHour;
  }

  /// Check if confirmed time has changed from initial
  bool get isTimeChangeForPreview => isCheckInChanged || isCheckOutChanged;

  /// Display total confirmed time
  String get totalConfirmedTime {
    if (isTimeChangeForPreview) {
      return TimelogHelpers.formatHoursMinutes(calculatedPaidHour);
    }
    return TimelogHelpers.formatHoursMinutes(staffRecord.paidHour);
  }

  /// Original total confirmed time (from RPC)
  String get originalConfirmedTime =>
      TimelogHelpers.formatHoursMinutes(staffRecord.paidHour);

  /// Format hourly salary for display
  String get hourlySalary {
    final salaryAmount = staffRecord.salaryAmount;
    if (salaryAmount == null || salaryAmount.isEmpty) return '--';
    final amount = double.tryParse(salaryAmount);
    if (amount != null) {
      return '${NumberFormat('#,###').format(amount.toInt())}₫';
    }
    return '$salaryAmount₫';
  }

  /// Display base pay
  String get basePay {
    if (isTimeChangeForPreview) {
      final calc = (calculatedPaidHour * hourlyRate).toInt();
      return '${NumberFormat('#,###').format(calc)}₫';
    }
    final basePayStr = staffRecord.basePay;
    if (basePayStr == null || basePayStr.isEmpty) {
      final salaryAmountStr = staffRecord.salaryAmount;
      if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
        final salaryAmount = double.tryParse(salaryAmountStr);
        if (salaryAmount != null) {
          final basePayCalc = (staffRecord.paidHour * salaryAmount).toInt();
          return '${NumberFormat('#,###').format(basePayCalc)}₫';
        }
      }
      return '--';
    }
    final amount = double.tryParse(basePayStr);
    if (amount != null) {
      return '${NumberFormat('#,###').format(amount.toInt())}₫';
    }
    return '$basePayStr₫';
  }

  /// Base pay amount for calculations
  int get basePayAmount {
    if (isTimeChangeForPreview) {
      return (calculatedPaidHour * hourlyRate).toInt();
    }
    final basePayStr = staffRecord.basePay;
    if (basePayStr != null && basePayStr.isNotEmpty) {
      final cleanedStr = basePayStr.replaceAll(',', '');
      final amount = double.tryParse(cleanedStr);
      if (amount != null) return amount.toInt();
    }
    final salaryAmountStr = staffRecord.salaryAmount;
    if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
      final cleanedSalary = salaryAmountStr.replaceAll(',', '');
      final salaryAmount = double.tryParse(cleanedSalary);
      if (salaryAmount != null) {
        return (staffRecord.paidHour * salaryAmount).toInt();
      }
    }
    return 0;
  }

  /// Original base pay amount (from RPC)
  int get originalBasePayAmount {
    final basePayStr = staffRecord.basePay;
    if (basePayStr != null && basePayStr.isNotEmpty) {
      final cleanedStr = basePayStr.replaceAll(',', '');
      final amount = double.tryParse(cleanedStr);
      if (amount != null) return amount.toInt();
    }
    return (staffRecord.paidHour * hourlyRate).toInt();
  }

  String get bonusPay =>
      '${NumberFormat('#,###').format(bonusAmount - penaltyAmount)}₫';
  String get penaltyDeduction =>
      '${NumberFormat('#,###').format(penaltyAmount)}₫';
  String get totalPayment =>
      '${NumberFormat('#,###').format(basePayAmount + bonusAmount - penaltyAmount)}₫';

  /// Original base pay (from RPC)
  String get originalBasePay =>
      '${NumberFormat('#,###').format(originalBasePayAmount)}₫';

  /// Original bonus pay (from RPC)
  String get originalBonusPay =>
      '${NumberFormat('#,###').format(initialBonusAmount - initialPenaltyAmount)}₫';

  /// Original total payment (from RPC)
  String get originalTotalPayment =>
      '${NumberFormat('#,###').format(originalBasePayAmount + initialBonusAmount - initialPenaltyAmount)}₫';

  /// Check if any salary-affecting value has changed
  bool get hasSalaryChanges => isTimeChangeForPreview || isBonusOrDeductChanged;

  // ============================================================================
  // Button Text Helper
  // ============================================================================

  /// 리포트 확인이 필요한지 체크
  bool get needsReportCheck {
    return staffRecord.isReported && staffRecord.isReportedSolved == null;
  }

  /// 시간 확인이 필요한지 체크
  bool get needsTimeConfirm => !isFullyConfirmed;

  /// 버튼 문구 결정
  String get buttonText {
    final needsReport = needsReportCheck;
    final needsTime = needsTimeConfirm;

    if (needsReport && needsTime) {
      return 'Check Two Problems';
    } else if (needsReport) {
      return 'Check Report';
    } else if (needsTime) {
      return 'Check Confirm Time';
    } else {
      return 'Save & confirm shift';
    }
  }
}
