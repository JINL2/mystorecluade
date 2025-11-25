import '../entities/attendance_location.dart';
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

  /// Get shift requests for a date range
  ///
  /// [userId] - User ID
  /// [storeId] - Store ID
  /// [startDate] - Start date
  /// [endDate] - End date
  ///
  /// Returns list of [ShiftRequest]
  Future<List<ShiftRequest>> getShiftRequests({
    required String userId,
    required String storeId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Update shift request (check-in or check-out)
  ///
  /// Matches RPC: update_shift_requests_v5
  ///
  /// [userId] - User ID
  /// [storeId] - Store ID
  /// [timestamp] - Current timestamp in UTC ISO 8601 format
  /// [location] - GPS location
  ///
  /// Returns updated shift data as Map with status and time
  Future<Map<String, dynamic>> updateShiftRequest({
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
  });

  /// Check in for a shift
  ///
  /// [shiftRequestId] - Shift request ID
  /// [location] - GPS location
  Future<void> checkIn({
    required String shiftRequestId,
    required AttendanceLocation location,
  });

  /// Check out from a shift
  ///
  /// [shiftRequestId] - Shift request ID
  /// [location] - GPS location
  Future<void> checkOut({
    required String shiftRequestId,
    required AttendanceLocation location,
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

  /// Get current active shift for user
  ///
  /// [userId] - User ID
  /// [storeId] - Store ID
  ///
  /// Returns current shift data or null if no active shift
  Future<Map<String, dynamic>?> getCurrentShift({
    required String userId,
    required String storeId,
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
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [storeId] - Store ID
  /// [requestDate] - Request date in format 'yyyy-MM-dd'
  ///
  /// Returns created ShiftRequest
  Future<ShiftRequest?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
  });

  /// Delete a shift request
  ///
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [requestDate] - Request date in format 'yyyy-MM-dd'
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestDate,
  });
}
