import '../entities/attendance_location.dart';
import '../entities/check_in_result.dart';
import '../entities/monthly_shift_status.dart';
import '../entities/shift_card.dart';
import '../entities/shift_metadata.dart';
import '../entities/shift_overview.dart';
import '../entities/shift_request.dart';

/// Attendance Repository Interface
///
/// Defines the contract for attendance data operations.
/// Implementations should handle data source communication.
abstract class AttendanceRepository {
  /// Get user shift overview for a specific month
  ///
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns [ShiftOverview] with monthly statistics
  Future<ShiftOverview> getUserShiftOverview({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  });

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
  /// Matches RPC: user_shift_cards_v3
  ///
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns list of ShiftCard from user_shift_cards_v3 RPC
  Future<List<ShiftCard>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  });

  /// Report an issue with a shift
  ///
  /// [shiftRequestId] - Shift request ID
  /// [reportReason] - Reason for reporting
  ///
  /// Returns true if successful
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
    String? reportReason,
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
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [requestDate] - Request date in format 'yyyy-MM-dd'
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestDate,
    required String timezone,
  });

  /// Get monthly shift status as raw JSON for UI display
  ///
  /// Matches RPC: get_monthly_shift_status_manager_v2
  ///
  /// Returns raw JSON preserving the nested structure:
  /// ```json
  /// [
  ///   {
  ///     "request_date": "2025-11-27",
  ///     "shifts": [
  ///       {
  ///         "shift_id": "...",
  ///         "shift_name": "...",
  ///         "pending_employees": [...],
  ///         "approved_employees": [...]
  ///       }
  ///     ]
  ///   }
  /// ]
  /// ```
  ///
  /// Use this method when UI needs the full nested structure.
  /// Use [getMonthlyShiftStatusManager] when entity conversion is needed.
  Future<List<Map<String, dynamic>>> getMonthlyShiftStatusRaw({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  });
}
