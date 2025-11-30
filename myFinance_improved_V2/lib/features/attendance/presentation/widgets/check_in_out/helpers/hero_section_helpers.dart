import 'package:intl/intl.dart';

import '../../../../domain/entities/shift_card.dart';

/// Helper functions for AttendanceHeroSection
///
/// ✅ Clean Architecture: Works with ShiftCard Entity instead of Map<String, dynamic>
class HeroSectionHelpers {
  /// Filter shift cards by month
  ///
  /// ✅ Clean Architecture: Uses ShiftCard Entity
  static List<ShiftCard> filterCardsByMonth(
    List<ShiftCard> shiftCards,
    String? currentDisplayedMonth,
  ) {
    if (currentDisplayedMonth == null || shiftCards.isEmpty) {
      return [];
    }

    return shiftCards.where((card) {
      return card.requestDate.startsWith(currentDisplayedMonth);
    }).toList();
  }

  /// Calculate total shifts for current month from shift cards
  ///
  /// ✅ Clean Architecture: Uses ShiftCard Entity
  static int calculateTotalShifts(
    List<ShiftCard> shiftCards,
    String? currentDisplayedMonth,
  ) {
    return filterCardsByMonth(shiftCards, currentDisplayedMonth).length;
  }

  /// Calculate total overtime minutes from shift cards
  ///
  /// ✅ Clean Architecture: Uses ShiftCard Entity
  static int calculateTotalOvertimeMinutes(List<ShiftCard> shiftCards) {
    return shiftCards.fold<int>(
      0,
      (total, card) => total + card.overtimeMinutes.toInt(),
    );
  }

  /// Calculate total late minutes from shift cards
  ///
  /// ✅ Clean Architecture: Uses ShiftCard Entity
  static int calculateTotalLateMinutes(List<ShiftCard> shiftCards) {
    return shiftCards.fold<int>(
      0,
      (total, card) => total + card.lateMinutes.toInt(),
    );
  }

  /// Format month display from year-month string (e.g., "2025-11")
  static String getMonthDisplay(String yearMonth) {
    if (yearMonth.isEmpty) {
      return DateFormat.yMMMM().format(DateTime.now());
    }

    try {
      // Parse "2025-11" format
      final parts = yearMonth.split('-');
      if (parts.length >= 2) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final date = DateTime(year, month);
        return DateFormat.yMMMM().format(date);
      }
    } catch (_) {
      // Return original if parsing fails
    }

    return yearMonth;
  }

  /// Calculate total work hours from shift cards
  ///
  /// ✅ Clean Architecture: Uses ShiftCard Entity
  static double calculateTotalWorkHours(List<ShiftCard> shiftCards) {
    return shiftCards.fold<double>(
      0.0,
      (total, card) => total + card.paidHours,
    );
  }

  /// Calculate total payment from shift cards
  ///
  /// ✅ Clean Architecture: Uses ShiftCard Entity
  static double calculateTotalPayment(List<ShiftCard> shiftCards) {
    return shiftCards.fold<double>(
      0.0,
      (total, card) => total + card.totalPayAmount,
    );
  }
}
