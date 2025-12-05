import '../entities/bulk_approval_result.dart';
import '../entities/card_input_result.dart';
import '../entities/manager_overview.dart';
import '../entities/manager_shift_cards.dart';
import '../entities/monthly_shift_status.dart';
import '../entities/operation_result.dart';
import '../entities/reliability_score.dart';
import '../entities/schedule_data.dart';
import '../entities/shift_metadata.dart';

/// Time Table Repository Interface
///
/// Defines the contract for time table management data operations.
/// Implementations should handle data source communication.
abstract class TimeTableRepository {
  /// Get shift metadata for a store
  ///
  /// Uses get_shift_metadata_v2_utc RPC with timezone support
  ///
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul")
  ///
  /// Returns [ShiftMetadata] with available tags and settings
  Future<ShiftMetadata> getShiftMetadata({
    required String storeId,
    required String timezone,
  });

  /// Get monthly shift status for manager view
  ///
  /// Matches RPC: get_monthly_shift_status_manager_v4
  ///
  /// [requestTime] - User's LOCAL timestamp in format 'yyyy-MM-dd HH:mm:ss' (no timezone)
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns list of [MonthlyShiftStatus] for 3 months based on actual work date
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatus({
    required String requestTime,
    required String companyId,
    required String storeId,
    required String timezone,
  });

  /// Get manager overview data for a month
  ///
  /// Uses manager_shift_get_overview_v3 RPC with timezone support
  ///
  /// [startDate] - Start date in format 'yyyy-MM-dd' (user's local date)
  /// [endDate] - End date in format 'yyyy-MM-dd' (user's local date)
  /// [companyId] - Company ID
  /// [storeId] - Store ID (optional, NULL for all stores)
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
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
  /// Uses manager_shift_get_cards_v3 RPC with timezone support
  ///
  /// [startDate] - Start date in format 'yyyy-MM-dd' (user's local date)
  /// [endDate] - End date in format 'yyyy-MM-dd' (user's local date)
  /// [companyId] - Company ID
  /// [storeId] - Store ID (optional, NULL for all stores)
  /// [timezone] - User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// Returns [ManagerShiftCards] entity with cards collection
  Future<ManagerShiftCards> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  });

  /// Toggle shift request approval status using v3 RPC
  ///
  /// Uses toggle_shift_approval_v3 RPC
  /// - Toggles is_approved state (TRUE ↔ FALSE)
  /// - Updates approved_by and updated_at_utc
  /// - No longer recalculates start_time_utc/end_time_utc (already set by insert_shift_request_v6)
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

  /// Insert new schedule (assign employee to shift) using v4 RPC
  ///
  /// Uses manager_shift_insert_schedule_v4 RPC
  /// - p_start_time and p_end_time are user's LOCAL timestamps (yyyy-MM-dd HH:mm:ss)
  /// - p_timezone is required for converting local time to UTC
  /// - Duplicate check based on (user_id, shift_id, start_time_utc, end_time_utc)
  /// - No longer uses request_date or request_time columns
  ///
  /// [userId] - Employee user ID
  /// [shiftId] - Shift ID
  /// [storeId] - Store ID
  /// [startTime] - Shift start time in user's local time (yyyy-MM-dd HH:mm:ss)
  /// [endTime] - Shift end time in user's local time (yyyy-MM-dd HH:mm:ss)
  /// [approvedBy] - User ID of approver
  /// [timezone] - User's local timezone (e.g., "Asia/Ho_Chi_Minh")
  ///
  /// Returns [OperationResult] indicating success or failure
  Future<OperationResult> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
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

  /// Input card data (comprehensive shift update with tags) using v3 RPC
  ///
  /// Uses manager_shift_input_card_v3 RPC with timezone support
  /// - Uses start_time_utc as date basis (actual work date) instead of request_time
  /// - Uses v2/_utc columns for all time and status fields
  /// - Supports night shifts with automatic date adjustment
  /// - Auto-generates tags when status values change
  /// - Enriches tags with creator names
  /// - Returns shift_date (from start_time_utc) instead of request_date
  ///
  /// [managerId] - Manager user ID performing the update
  /// [shiftRequestId] - Shift request ID to update
  /// [confirmStartTime] - Confirmed start time (HH:mm format), null to keep existing
  /// [confirmEndTime] - Confirmed end time (HH:mm format), null to keep existing
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
    String? confirmStartTime,  // Nullable - RPC keeps existing if null
    String? confirmEndTime,    // Nullable - RPC keeps existing if null
    String? newTagContent,
    String? newTagType,
    required bool isLate,
    required bool isProblemSolved,
    required String timezone,
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

  /// Input card data (manager updates shift) using v4 RPC
  ///
  /// Uses manager_shift_input_card_v4 RPC
  /// - Simplified parameters: confirm times, problem solved status, bonus amount
  /// - Times must be in user's LOCAL timezone (HH:mm:ss format)
  /// - RPC converts local times to UTC internally
  ///
  /// [managerId] - Manager user ID performing the update
  /// [shiftRequestId] - Shift request ID to update
  /// [confirmStartTime] - Confirmed start time (HH:mm:ss format), null to keep existing
  /// [confirmEndTime] - Confirmed end time (HH:mm:ss format), null to keep existing
  /// [isProblemSolved] - Problem solved status, null to keep existing
  /// [bonusAmount] - Bonus amount, null to keep existing
  /// [timezone] - User's local timezone (e.g., "Asia/Ho_Chi_Minh")
  ///
  /// Returns Map with success status and optional error info
  Future<Map<String, dynamic>> inputCardV4({
    required String managerId,
    required String shiftRequestId,
    String? confirmStartTime,
    String? confirmEndTime,
    bool? isProblemSolved,
    double? bonusAmount,
    required String timezone,
  });

  /// Get reliability score data for stats tab
  ///
  /// Uses get_reliability_score RPC
  /// - p_time must be user's LOCAL timestamp in "yyyy-MM-dd HH:mm:ss" format
  ///   (no timezone conversion - send device local time as-is)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  ///
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  /// [time] - User's LOCAL timestamp (yyyy-MM-dd HH:mm:ss)
  /// [timezone] - User's local timezone
  ///
  /// Returns [ReliabilityScore] with shift summary, understaffed shifts, and employees
  Future<ReliabilityScore> getReliabilityScore({
    required String companyId,
    required String storeId,
    required String time,
    required String timezone,
  });
}
