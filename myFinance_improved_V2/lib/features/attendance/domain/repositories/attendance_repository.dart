import '../entities/attendance_location.dart';
import '../entities/monthly_shift_status.dart';
import '../entities/shift_card_data.dart';
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
  /// [requestDate] - Date in format 'yyyy-MM-dd'
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  ///
  /// Returns [ShiftOverview] with monthly statistics
  Future<ShiftOverview> getUserShiftOverview({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
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
  /// [userId] - User ID
  /// [storeId] - Store ID
  /// [requestDate] - Request date in format 'yyyy-MM-dd'
  /// [timestamp] - Current timestamp in ISO 8601 format
  /// [location] - GPS location
  ///
  /// Returns updated shift data (strongly typed)
  Future<ShiftCardData> updateShiftRequest({
    required String userId,
    required String storeId,
    required String requestDate,
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
  /// [requestDate] - Date in format 'yyyy-MM-dd'
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  ///
  /// Returns list of shift card data (strongly typed)
  Future<List<ShiftCardData>> getUserShiftCards({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  });

  /// Get current active shift for user
  ///
  /// [userId] - User ID
  /// [storeId] - Store ID
  ///
  /// Returns current shift data or null if no active shift (strongly typed)
  Future<ShiftCardData?> getCurrentShift({
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
  /// [storeId] - Store ID
  ///
  /// Returns list of shift metadata (strongly typed)
  Future<List<ShiftMetadata>> getShiftMetadata({
    required String storeId,
  });

  /// Get monthly shift status for user view
  ///
  /// [storeId] - Store ID
  /// [userId] - User ID
  /// [requestDate] - Request date in format 'yyyy-MM-dd'
  ///
  /// Returns list of shift status data (strongly typed)
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatus({
    required String storeId,
    required String userId,
    required String requestDate,
  });

  /// Insert a new shift request
  ///
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [storeId] - Store ID
  /// [requestDate] - Request date in format 'yyyy-MM-dd'
  ///
  /// Returns created shift card data (strongly typed)
  Future<ShiftCardData?> insertShiftRequest({
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
