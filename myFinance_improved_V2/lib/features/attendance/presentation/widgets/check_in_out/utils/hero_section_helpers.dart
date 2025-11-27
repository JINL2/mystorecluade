/// Helper functions for attendance hero section
class HeroSectionHelpers {
  /// Calculate total shifts for current month from shift cards
  static int calculateTotalShifts(
    List<Map<String, dynamic>> allShiftCardsData,
    String? currentDisplayedMonth,
  ) {
    if (currentDisplayedMonth == null) return 0;

    final currentMonthShifts = allShiftCardsData.where((card) {
      final requestDate = card['request_date']?.toString() ?? '';
      return requestDate.startsWith(currentDisplayedMonth);
    }).toList();

    return currentMonthShifts.length;
  }

  /// Parse and format month display from request_month (format: "2025-08")
  static String getMonthDisplay(dynamic requestMonth) {
    if (requestMonth == null || requestMonth.toString().isEmpty) {
      return 'Current Month';
    }

    final parts = requestMonth.toString().split('-');
    if (parts.length == 2) {
      final year = parts[0];
      final month = int.tryParse(parts[1]) ?? DateTime.now().month;
      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      return '${monthNames[month - 1]} $year';
    }

    return 'Current Month';
  }

  /// Calculate overtime bonus amount
  static String calculateOvertimeBonus(
    dynamic overtimeTotal,
    dynamic salaryAmount,
    dynamic currencySymbol,
  ) {
    if (overtimeTotal == null || (overtimeTotal as num) <= 0) {
      return '';
    }

    final bonus = ((overtimeTotal as num) * (salaryAmount as num) / 60).toStringAsFixed(0);
    return '+$currencySymbol$bonus';
  }
}
