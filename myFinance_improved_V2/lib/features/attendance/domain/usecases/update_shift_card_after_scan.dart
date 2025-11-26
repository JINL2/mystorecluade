import '../entities/scan_result.dart';
import '../entities/shift_card.dart';

/// Use Case for updating shift card after QR scan
///
/// Business Rules:
/// 1. Check-in: Update actual_start_time and confirm_start_time
/// 2. Check-in: Clear actual_end_time and confirm_end_time (for re-check-in scenarios)
/// 3. Check-out: Update actual_end_time and confirm_end_time
///
/// ✅ Clean Architecture: Uses Domain entities (ScanResult, ShiftCard)
class UpdateShiftCardAfterScan {
  /// Update shift card based on scan action
  ///
  /// Parameters:
  /// - [card]: The shift card to update
  /// - [action]: 'check_in' or 'check_out'
  /// - [timestamp]: The UTC timestamp string from QR scan
  ///
  /// Returns: Updated ShiftCard
  ShiftCard call({
    required ShiftCard card,
    required String action,
    required String timestamp,
  }) {
    if (action == 'check_in') {
      // Business Rule: When checking in, clear any existing check-out time
      // This handles re-check-in scenarios
      return card.copyWith(
        actualStartTime: timestamp,
        confirmStartTime: timestamp,
        actualEndTime: null,
        confirmEndTime: null,
      );
    } else if (action == 'check_out') {
      // Business Rule: When checking out, only update end times
      return card.copyWith(
        actualEndTime: timestamp,
        confirmEndTime: timestamp,
      );
    }

    // If action is not recognized, return card unchanged
    return card;
  }

  /// Create a new shift card from scan result
  ///
  /// This is for edge cases where the shift card doesn't exist yet
  /// (shouldn't happen normally but provides fallback)
  ///
  /// ✅ Clean Architecture: Uses ScanResult entity instead of Map
  ShiftCard createFromScanResult(ScanResult scanResult) {
    return ShiftCard(
      requestDate: scanResult.requestDate,
      shiftRequestId: scanResult.shiftRequestId,
      shiftTime: scanResult.shiftTimeRange,
      storeName: scanResult.storeName,
      scheduledHours: 0.0,
      isApproved: true,
      actualStartTime: scanResult.isCheckIn ? scanResult.timestamp : null,
      confirmStartTime: scanResult.isCheckIn ? scanResult.timestamp : null,
      actualEndTime: scanResult.isCheckOut ? scanResult.timestamp : null,
      confirmEndTime: scanResult.isCheckOut ? scanResult.timestamp : null,
      paidHours: 0.0,
      isLate: false,
      lateMinutes: 0,
      lateDeducutAmount: 0.0,
      isExtratime: false,
      overtimeMinutes: 0,
      basePay: '0',
      bonusAmount: 0.0,
      totalPayWithBonus: '0',
      salaryType: 'hourly',
      salaryAmount: '0',
      isReported: false,
      isProblem: false,
      isProblemSolved: false,
    );
  }
}
