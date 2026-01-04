/// Salary calculation utilities for staff timelog detail page
///
/// Provides methods to calculate pay based on confirmed times.
library;

import 'package:intl/intl.dart';

import '../../../widgets/timesheets/staff_timelog_card.dart';
import 'timelog_helpers.dart';

/// Salary calculator for staff timelog
class SalaryCalculator {
  final StaffTimeRecord staffRecord;
  final String confirmedCheckIn;
  final String confirmedCheckOut;
  final int bonusAmount;
  final int penaltyAmount;

  // Initial values for comparison
  final String initialConfirmedCheckIn;
  final String initialConfirmedCheckOut;
  final int initialBonusAmount;
  final int initialPenaltyAmount;

  SalaryCalculator({
    required this.staffRecord,
    required this.confirmedCheckIn,
    required this.confirmedCheckOut,
    required this.bonusAmount,
    required this.penaltyAmount,
    required this.initialConfirmedCheckIn,
    required this.initialConfirmedCheckOut,
    required this.initialBonusAmount,
    required this.initialPenaltyAmount,
  });

  /// Get hourly rate as number for calculations
  double get hourlyRate {
    final salaryAmountStr = staffRecord.salaryAmount;
    if (salaryAmountStr == null || salaryAmountStr.isEmpty) return 0;
    final cleaned = salaryAmountStr.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0;
  }

  /// Check if confirmed time has changed
  bool get isTimeChanged =>
      confirmedCheckIn != initialConfirmedCheckIn ||
      confirmedCheckOut != initialConfirmedCheckOut;

  /// Check if bonus/deduct has changed
  bool get isBonusOrDeductChanged =>
      bonusAmount != initialBonusAmount || penaltyAmount != initialPenaltyAmount;

  /// Check if any salary-affecting value has changed
  bool get hasSalaryChanges => isTimeChanged || isBonusOrDeductChanged;

  /// Calculate paid hours from current confirmed times
  double get calculatedPaidHour {
    final calculated = TimelogHelpers.calculateHoursFromTimes(
      confirmedCheckIn,
      confirmedCheckOut,
    );
    return calculated ?? staffRecord.paidHour;
  }

  /// Display total confirmed time
  String get totalConfirmedTime {
    if (isTimeChanged) {
      return TimelogHelpers.formatHoursMinutes(calculatedPaidHour);
    }
    return TimelogHelpers.formatHoursMinutes(staffRecord.paidHour);
  }

  /// Original total confirmed time (from RPC)
  String get originalConfirmedTime =>
      TimelogHelpers.formatHoursMinutes(staffRecord.paidHour);

  /// Formatted hourly salary
  String get hourlySalary {
    final salaryAmount = staffRecord.salaryAmount;
    if (salaryAmount == null || salaryAmount.isEmpty) return '--';
    final amount = double.tryParse(salaryAmount);
    if (amount != null) {
      return '${NumberFormat('#,###').format(amount.toInt())}₫';
    }
    return '$salaryAmount₫';
  }

  /// Current base pay amount
  int get basePayAmount {
    if (isTimeChanged) {
      return (calculatedPaidHour * hourlyRate).toInt();
    }
    // Original logic
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

  /// Display base pay
  String get basePay {
    if (isTimeChanged) {
      final calc = (calculatedPaidHour * hourlyRate).toInt();
      return '${NumberFormat('#,###').format(calc)}₫';
    }
    // Original logic
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

  /// Net bonus (bonus - penalty)
  int get netBonus => bonusAmount - penaltyAmount;

  /// Display bonus pay
  String get bonusPay => '${NumberFormat('#,###').format(netBonus)}₫';

  /// Display total payment
  String get totalPayment =>
      '${NumberFormat('#,###').format(basePayAmount + netBonus)}₫';

  /// Original base pay (for comparison)
  String get originalBasePay =>
      '${NumberFormat('#,###').format(originalBasePayAmount)}₫';

  /// Original bonus pay (for comparison)
  String get originalBonusPay =>
      '${NumberFormat('#,###').format(initialBonusAmount - initialPenaltyAmount)}₫';

  /// Original total payment (for comparison)
  String get originalTotalPayment => '${NumberFormat('#,###').format(
        originalBasePayAmount + initialBonusAmount - initialPenaltyAmount,
      )}₫';

  /// Format as of date from shift date
  String asOfDate(String shiftDate) => TimelogHelpers.formatAsOfDate(shiftDate);
}
