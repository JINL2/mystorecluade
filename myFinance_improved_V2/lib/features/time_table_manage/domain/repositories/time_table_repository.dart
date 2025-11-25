import '../entities/available_employees_data.dart';
import '../entities/bulk_approval_result.dart';
import '../entities/card_input_result.dart';
import '../entities/manager_overview.dart';
import '../entities/manager_shift_cards.dart';
import '../entities/monthly_shift_status.dart';
import '../entities/operation_result.dart';
import '../entities/schedule_data.dart';
import '../entities/shift_metadata.dart';

/// Time Table Repository Interface
///
/// Defines the contract for time table management data operations.
/// Implementations should handle data source communication.
abstract class TimeTableRepository {
  /// Get shift metadata for a store
  ///
  /// Uses get_shift_metadata_v2 RPC with timezone support
  ///
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [ShiftMetadata] with available tags and settings
  Future<ShiftMetadata> getShiftMetadata({
    required String storeId,
    required String timezone,
  });

  /// Get raw shift metadata for UI display
  ///
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns dynamic list directly from RPC for backward compatibility
  Future<dynamic> getShiftMetadataRaw({
    required String storeId,
    required String timezone,
  });

  /// Get monthly shift status for manager view
  ///
  /// Matches RPC: get_monthly_shift_status_manager_v2
  ///
  /// [requestTime] - UTC timestamp in format 'yyyy-MM-dd HH:mm:ss'
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns list of [MonthlyShiftStatus] for 3 months
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatus({
    required String requestTime,
    required String companyId,
    required String storeId,
    required String timezone,
  });

  /// Get manager overview data for a month
  ///
  /// Uses manager_shift_get_overview_v2 RPC with timezone support
  ///
  /// [startDate] - Start date in format 'yyyy-MM-dd' (local date)
  /// [endDate] - End date in format 'yyyy-MM-dd' (local date)
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [ManagerOverview] with statistics
  Future<ManagerOverview> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  });

  /// Get manager shift cards for employee view
  ///
  /// Uses manager_shift_get_cards_v2 RPC with timezone support
  ///
  /// [startDate] - Start date in format 'yyyy-MM-dd' (local date)
  /// [endDate] - End date in format 'yyyy-MM-dd' (local date)
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [ManagerShiftCards] entity with cards collection
  Future<ManagerShiftCards> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  });

  /// Toggle shift request approval status using v2 RPC
  ///
  /// Uses toggle_shift_approval_v2 RPC
  /// - Toggles is_approved state for shift requests
  /// - Updates approved_by and updated_at_utc
  /// - Updates start_time_utc and end_time_utc from store_shifts
  /// - Handles overnight shifts correctly
  ///
  /// [shiftRequestIds] - List of shift request IDs to toggle
  /// [userId] - User ID performing the approval
  ///
  /// Returns void (no result)
  Future<void> toggleShiftApproval({
    required List<String> shiftRequestIds,
    required String userId,
  });

  /// Delete a shift
  ///
  /// [shiftId] - Shift ID to delete
  ///
  /// Returns [OperationResult] indicating success or failure
  Future<OperationResult> deleteShift({
    required String shiftId,
  });

  /// Delete a shift tag
  ///
  /// [tagId] - Tag ID to delete
  /// [userId] - User ID performing the deletion
  ///
  /// Returns [OperationResult] indicating success or failure
  Future<OperationResult> deleteShiftTag({
    required String tagId,
    required String userId,
  });

  /// Get available employees for shift assignment using v2 RPC
  ///
  /// Uses manager_shift_get_schedule_v2 RPC with timezone support
  /// - Returns shift times converted to local timezone
  /// - Uses start_time_utc and end_time_utc columns
  ///
  /// [storeId] - Store ID
  /// [shiftDate] - Shift date in format 'yyyy-MM-dd'
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [AvailableEmployeesData] with employees list and existing shifts
  Future<AvailableEmployeesData> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
    required String timezone,
  });

  /// Get schedule data (employees and shifts) for a store using v2 RPC
  ///
  /// Uses manager_shift_get_schedule_v2 RPC with timezone support
  /// - Returns shift times converted to local timezone
  /// - Uses start_time_utc and end_time_utc columns
  ///
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [ScheduleData] with employees and shifts
  Future<ScheduleData> getScheduleData({
    required String storeId,
    required String timezone,
  });

  /// Insert new schedule (assign employee to shift) using v2 RPC
  ///
  /// Uses manager_shift_insert_schedule_v2 RPC with timezone support
  /// - Handles duplicate detection and overnight shifts
  /// - Calculates start_time_utc and end_time_utc automatically
  ///
  /// [userId] - Employee user ID
  /// [shiftId] - Shift ID
  /// [storeId] - Store ID
  /// [requestTime] - Request time in UTC timestamp format 'yyyy-MM-dd HH:mm:ss'
  /// [approvedBy] - User ID of approver
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [OperationResult] indicating success or failure
  Future<OperationResult> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestTime,
    required String approvedBy,
    required String timezone,
  });

  /// Process bulk shift approval
  ///
  /// [shiftRequestIds] - List of shift request IDs
  /// [approvalStates] - List of approval states
  ///
  /// Returns [BulkApprovalResult] with detailed processing results
  Future<BulkApprovalResult> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  });

  /// Input card data (comprehensive shift update with tags) using v2 RPC
  ///
  /// Uses manager_shift_input_card_v2 RPC with timezone support
  /// - Uses v2/_utc columns for all time and status fields
  /// - Supports night shifts with automatic date adjustment
  /// - Auto-generates tags when status values change
  /// - Enriches tags with creator names
  ///
  /// [managerId] - Manager user ID performing the update
  /// [shiftRequestId] - Shift request ID to update
  /// [confirmStartTime] - Confirmed start time (HH:mm format)
  /// [confirmEndTime] - Confirmed end time (HH:mm format)
  /// [newTagContent] - Optional tag content to add
  /// [newTagType] - Optional tag type
  /// [isLate] - Whether employee was late
  /// [isProblemSolved] - Whether any problem was resolved
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [CardInputResult] with updated shift request
  Future<CardInputResult> inputCard({
    required String managerId,
    required String shiftRequestId,
    required String confirmStartTime,
    required String confirmEndTime,
    String? newTagContent,
    String? newTagType,
    required bool isLate,
    required bool isProblemSolved,
    required String timezone,
  });

  /// Add bonus to shift
  ///
  /// [shiftRequestId] - Shift request ID
  /// [bonusAmount] - Bonus amount
  /// [bonusReason] - Bonus reason
  ///
  /// Returns [OperationResult] indicating success or failure
  Future<OperationResult> addBonus({
    required String shiftRequestId,
    required double bonusAmount,
    required String bonusReason,
  });

  /// Update bonus amount for shift request
  ///
  /// [shiftRequestId] - Shift request ID
  /// [bonusAmount] - New bonus amount
  ///
  /// Returns update result
  Future<void> updateBonusAmount({
    required String shiftRequestId,
    required double bonusAmount,
  });
}
