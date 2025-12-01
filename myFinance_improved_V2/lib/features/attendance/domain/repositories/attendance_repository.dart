import '../entities/attendance_location.dart';
import '../entities/base_currency.dart';
import '../entities/check_in_result.dart';
import '../entities/monthly_shift_status.dart';
import '../entities/shift_card.dart';
import '../entities/shift_metadata.dart';
import '../entities/shift_request.dart';
import '../entities/user_shift_stats.dart';

/// Attendance Repository Interface
///
/// Defines the contract for attendance data operations.
/// Implementations should handle data source communication.
abstract class AttendanceRepository {
  /// Update shift request (check-in or check-out)
  ///
  /// Matches RPC: update_shift_requests_v6
  ///
  /// [userId] - User ID
  /// [storeId] - Store ID
  /// [timestamp] - Current timestamp in UTC ISO 8601 format
  /// [location] - GPS location
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns CheckInResult entity with action details
  Future<CheckInResult> updateShiftRequest({
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  });

  /// Get user shift cards for a month
  ///
  /// Matches RPC: user_shift_cards_v4
  ///
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns list of ShiftCard from user_shift_cards_v4 RPC
  Future<List<ShiftCard>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  });

  /// Report an issue with a shift
  ///
  /// Matches RPC: report_shift_request
  ///
  /// [shiftRequestId] - Shift request ID
  /// [reportReason] - Reason for reporting
  /// [time] - Local time string (e.g., "2024-11-15 10:30:25")
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns true if successful
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
    required String reportReason,
    required String time,
    required String timezone,
  });

  /// Get shift metadata for a store
  ///
  /// Matches RPC: get_shift_metadata_v2
  ///
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns list of shift metadata with times in user's local timezone
  Future<List<ShiftMetadata>> getShiftMetadata({
    required String storeId,
    required String timezone,
  });

  /// Get monthly shift status for manager view
  ///
  /// Matches RPC: get_monthly_shift_status_manager_v2
  ///
  /// [storeId] - Store ID
  /// [companyId] - Company ID
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns list of shift status data for 3 months
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  });

  /// Insert a new shift request
  ///
  /// Matches RPC: insert_shift_request_v3
  ///
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [storeId] - Store ID
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns created ShiftRequest
  Future<ShiftRequest?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestTime,
    required String timezone,
  });

  /// Delete a shift request
  ///
  /// Matches RPC: delete_shift_request_v2
  ///
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [requestTime] - Local timestamp with timezone offset (e.g., "2024-11-15T10:30:25+09:00")
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestTime,
    required String timezone,
  });

  /// Get base currency for a company
  ///
  /// Matches RPC: get_base_currency
  ///
  /// [companyId] - Company ID
  ///
  /// Returns [BaseCurrency] with currency symbol and details
  Future<BaseCurrency> getBaseCurrency({
    required String companyId,
  });

  /// Get user shift statistics for Stats tab
  ///
  /// Matches RPC: user_shift_stats
  ///
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns [UserShiftStats] with salary info, period stats, and weekly payments
  Future<UserShiftStats> getUserShiftStats({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  });
}
