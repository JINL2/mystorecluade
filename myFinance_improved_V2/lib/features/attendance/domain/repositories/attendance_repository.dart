import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
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
///
/// Uses Either<Failure, T> pattern for error handling:
/// - Left(Failure): Operation failed with error details
/// - Right(T): Operation succeeded with result
abstract class AttendanceRepository {
  /// Update shift request (check-in or check-out)
  ///
  /// Matches RPC: update_shift_requests_v8
  ///
  /// [shiftRequestId] - Shift request ID (from user_shift_cards_v4)
  /// [userId] - User ID
  /// [storeId] - Store ID
  /// [timestamp] - Current timestamp in UTC ISO 8601 format
  /// [location] - GPS location
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns Either<Failure, CheckInResult> entity with action details
  Future<Either<Failure, CheckInResult>> updateShiftRequest({
    required String shiftRequestId,
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  });

  /// Get user shift cards for a month
  ///
  /// Matches RPC: user_shift_cards_v6
  ///
  /// [requestTime] - Local timestamp (e.g., "2025-12-15 10:00:00") - no timezone offset
  /// [userId] - User ID
  /// [companyId] - Company ID
  /// [storeId] - Store ID (Optional - null이면 회사 전체 조회)
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns Either<Failure, List<ShiftCard>> filtered by start_time_utc (actual shift date)
  Future<Either<Failure, List<ShiftCard>>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    String? storeId,
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
  /// Returns Either<Failure, bool> - true if successful
  Future<Either<Failure, bool>> reportShiftIssue({
    required String shiftRequestId,
    required String reportReason,
    required String time,
    required String timezone,
  });

  /// Get shift metadata for a store
  ///
  /// Matches RPC: get_shift_metadata_v2_utc
  ///
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns Either<Failure, List<ShiftMetadata>> with times in user's local timezone
  Future<Either<Failure, List<ShiftMetadata>>> getShiftMetadata({
    required String storeId,
    required String timezone,
  });

  /// Get monthly shift status for manager view
  ///
  /// Matches RPC: get_monthly_shift_status_manager_v4
  ///
  /// [storeId] - Store ID
  /// [companyId] - Company ID
  /// [requestTime] - User's LOCAL timestamp in format 'yyyy-MM-dd HH:mm:ss' (no timezone)
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns Either<Failure, List<MonthlyShiftStatus>> for 3 months
  Future<Either<Failure, List<MonthlyShiftStatus>>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  });

  /// Insert a new shift request
  ///
  /// Matches RPC: insert_shift_request_v6
  ///
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [storeId] - Store ID
  /// [startTime] - Shift start time as local timestamp (e.g., "2025-12-06 09:00:00")
  /// [endTime] - Shift end time as local timestamp (e.g., "2025-12-06 18:00:00")
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// NOTE: All timestamps must be WITHOUT timezone offset
  ///
  /// Returns Either<Failure, ShiftRequest?> created ShiftRequest
  Future<Either<Failure, ShiftRequest?>> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String timezone,
  });

  /// Delete a shift request
  ///
  /// Matches RPC: delete_shift_request_v3
  ///
  /// [userId] - User ID
  /// [shiftId] - Shift ID
  /// [startTime] - Shift start time as local timestamp (e.g., "2025-12-06 09:00:00")
  /// [endTime] - Shift end time as local timestamp (e.g., "2025-12-06 18:00:00")
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// NOTE: All timestamps must be WITHOUT timezone offset
  Future<Either<Failure, Unit>> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String startTime,
    required String endTime,
    required String timezone,
  });

  /// Get base currency for a company
  ///
  /// Matches RPC: get_base_currency
  ///
  /// [companyId] - Company ID
  ///
  /// Returns Either<Failure, BaseCurrency> with currency symbol and details
  Future<Either<Failure, BaseCurrency>> getBaseCurrency({
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
  /// Returns Either<Failure, UserShiftStats> with salary info, period stats, and weekly payments
  Future<Either<Failure, UserShiftStats>> getUserShiftStats({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  });
}
