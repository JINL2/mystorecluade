import '../entities/shift_card.dart';
import '../repositories/attendance_repository.dart';

/// Get current active shift for a user
///
/// Returns the user's shift cards and finds the current one based on today's date
class GetCurrentShift {
  final AttendanceRepository _repository;

  GetCurrentShift(this._repository);

  /// Get current shift for the user
  ///
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns the current day's ShiftCard or null if no shift today
  Future<ShiftCard?> call({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    final shiftCards = await _repository.getUserShiftCards(
      requestTime: requestTime,
      userId: userId,
      companyId: companyId,
      storeId: storeId,
      timezone: timezone,
    );

    if (shiftCards.isEmpty) return null;

    // Extract date from requestTime (yyyy-MM-dd HH:mm:ss -> yyyy-MM-dd)
    final requestDate = requestTime.split(' ').first;

    // Find shift card matching today's date
    try {
      return shiftCards.firstWhere(
        (card) => card.requestDate == requestDate,
      );
    } catch (e) {
      return null;
    }
  }
}
