import '../entities/shift_overview.dart';
import '../entities/shift_request.dart';
import '../entities/attendance_location.dart';

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
  /// Returns updated shift data as Map
  Future<Map<String, dynamic>> updateShiftRequest({
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
  /// Returns list of shift card data as Map
  Future<List<Map<String, dynamic>>> getUserShiftCards({
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
  /// Returns current shift data or null if no active shift
  Future<Map<String, dynamic>?> getCurrentShift({
    required String userId,
    required String storeId,
  });
}
