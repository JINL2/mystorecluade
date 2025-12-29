import '../../../../domain/entities/shift_card.dart';

/// Salary calculation result data class
class SalaryCalculation {
  final num paidHours;
  final num basePay;
  final num salaryAmount;
  final String salaryType;

  const SalaryCalculation({
    required this.paidHours,
    required this.basePay,
    required this.salaryAmount,
    required this.salaryType,
  });
}

/// Salary Calculator Helper
///
/// Handles all salary and bonus calculation logic for shift cards.
class SalaryCalculator {
  /// Calculate salary information from a shift card
  ///
  /// Returns [SalaryCalculation] containing:
  /// - paidHours: Hours worked (for hourly employees)
  /// - basePay: Base pay amount
  /// - salaryAmount: Hourly rate or monthly salary
  /// - salaryType: 'hourly' or 'monthly'
  static SalaryCalculation calculate(ShiftCard card) {
    final String salaryType = card.salaryType ?? 'hourly';
    final String salaryAmountStr = card.salaryAmount ?? '0';
    final num salaryAmount =
        num.tryParse(salaryAmountStr.replaceAll(',', '')) ?? 0;

    num paidHours = 0;
    num basePay = 0;

    if (salaryType == 'hourly') {
      paidHours = _calculatePaidHours(card);
      basePay = salaryAmount * paidHours;
    } else if (salaryType == 'monthly') {
      basePay = salaryAmount;
    }

    return SalaryCalculation(
      paidHours: paidHours,
      basePay: basePay,
      salaryAmount: salaryAmount,
      salaryType: salaryType,
    );
  }

  /// Calculate paid hours from shift card time data
  ///
  /// Priority: confirm times > actual times
  static num _calculatePaidHours(ShiftCard card) {
    // Get time data - prefer confirm times, fallback to actual times
    final String? confirmStartStr = card.confirmedStartTime?.toIso8601String();
    final String? confirmEndStr = card.confirmedEndTime?.toIso8601String();
    final String? actualStartStr = card.actualStartTime?.toIso8601String();
    final String? actualEndStr = card.actualEndTime?.toIso8601String();
    final String requestDate = card.shiftDate;

    String? startTimeStr;
    String? endTimeStr;

    // Priority: confirm times > actual times
    if (confirmStartStr != null &&
        confirmStartStr.isNotEmpty &&
        confirmStartStr != '--:--') {
      startTimeStr = confirmStartStr;
    } else if (actualStartStr != null && actualStartStr.isNotEmpty) {
      startTimeStr = actualStartStr;
    }

    if (confirmEndStr != null &&
        confirmEndStr.isNotEmpty &&
        confirmEndStr != '--:--') {
      endTimeStr = confirmEndStr;
    } else if (actualEndStr != null && actualEndStr.isNotEmpty) {
      endTimeStr = actualEndStr;
    }

    // Calculate hours if both start and end times are available
    if (startTimeStr == null || endTimeStr == null || requestDate.isEmpty) {
      return 0;
    }

    try {
      DateTime? startLocal;
      DateTime? endLocal;

      // Check if the time string is already a full timestamp or just time
      if (startTimeStr.contains('T') || startTimeStr.contains(' ')) {
        // Already a full timestamp (e.g., "2025-10-30T16:00:00.000")
        startLocal = DateTime.parse(startTimeStr);
        endLocal = DateTime.parse(endTimeStr);
      } else {
        // Just time (HH:mm or HH:mm:ss), need to add date
        final startParts = startTimeStr.split(':');
        final endParts = endTimeStr.split(':');

        if (startParts.length >= 2 && endParts.length >= 2) {
          // Create UTC DateTime and convert to local
          final startUtc = DateTime.parse(
            '${requestDate}T${startTimeStr.length == 5 ? '$startTimeStr:00' : startTimeStr}Z',
          );
          final endUtc = DateTime.parse(
            '${requestDate}T${endTimeStr.length == 5 ? '$endTimeStr:00' : endTimeStr}Z',
          );

          startLocal = startUtc.toLocal();
          endLocal = endUtc.toLocal();
        }
      }

      if (startLocal != null && endLocal != null) {
        final duration = endLocal.difference(startLocal);
        return duration.inMinutes / 60.0;
      }
    } catch (e) {
      // Silently handle error
    }

    return 0;
  }

  /// Get display text for salary type
  static String getSalaryTypeDisplay(String salaryType) {
    if (salaryType == 'hourly') {
      return 'Hourly Rate';
    } else if (salaryType == 'monthly') {
      return 'Monthly Salary';
    }
    return salaryType;
  }
}
