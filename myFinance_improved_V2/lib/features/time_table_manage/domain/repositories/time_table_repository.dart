import '../entities/shift_metadata.dart';
import '../entities/monthly_shift_status.dart';
import '../entities/manager_overview.dart';
import '../value_objects/create_shift_params.dart';

/// Time Table Repository Interface
///
/// Defines the contract for time table management data operations.
/// Implementations should handle data source communication.
abstract class TimeTableRepository {
  /// Get shift metadata for a store
  ///
  /// [storeId] - Store ID
  ///
  /// Returns [ShiftMetadata] with available tags and settings
  Future<ShiftMetadata> getShiftMetadata({
    required String storeId,
  });

  /// Get monthly shift status for manager view
  ///
  /// [requestDate] - Date in format 'yyyy-MM-dd'
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  ///
  /// Returns list of [MonthlyShiftStatus] (may include next month)
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatus({
    required String requestDate,
    required String companyId,
    required String storeId,
  });

  /// Get manager overview data for a month
  ///
  /// [requestDate] - Date in format 'yyyy-MM-dd'
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  ///
  /// Returns [ManagerOverview] with statistics
  Future<ManagerOverview> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  });

  /// Get manager shift cards for employee view
  ///
  /// [requestDate] - Date in format 'yyyy-MM-dd'
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  ///
  /// Returns shift cards data as Map with stores structure
  Future<Map<String, dynamic>> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  });

  /// Toggle shift request approval status
  ///
  /// [shiftRequestId] - Shift request ID
  /// [newApprovalState] - New approval state (true = approved, false = pending)
  ///
  /// Returns updated shift request data
  Future<Map<String, dynamic>> toggleShiftApproval({
    required String shiftRequestId,
    required bool newApprovalState,
  });

  /// Create a new shift
  ///
  /// [params] - Parameters for creating the shift
  ///
  /// Returns created shift data
  Future<Map<String, dynamic>> createShift({
    required CreateShiftParams params,
  });

  /// Delete a shift
  ///
  /// [shiftId] - Shift ID to delete
  Future<void> deleteShift({
    required String shiftId,
  });

  /// Delete a shift tag
  ///
  /// [tagId] - Tag ID to delete
  /// [userId] - User ID performing the deletion
  ///
  /// Returns deletion result
  Future<Map<String, dynamic>> deleteShiftTag({
    required String tagId,
    required String userId,
  });

  /// Get available employees for shift assignment
  ///
  /// [storeId] - Store ID
  /// [shiftDate] - Shift date in format 'yyyy-MM-dd'
  ///
  /// Returns list of available employees and existing shifts
  Future<Map<String, dynamic>> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
  });

  /// Insert shift schedule for selected employees
  ///
  /// [storeId] - Store ID
  /// [shiftId] - Shift ID
  /// [employeeIds] - List of employee IDs to assign
  ///
  /// Returns insertion result
  Future<Map<String, dynamic>> insertShiftSchedule({
    required String storeId,
    required String shiftId,
    required List<String> employeeIds,
  });

  /// Get schedule data (employees and shifts) for a store
  ///
  /// [storeId] - Store ID
  ///
  /// Returns employees and shifts data
  Future<Map<String, dynamic>> getScheduleData({
    required String storeId,
  });

  /// Insert new schedule (assign employee to shift)
  ///
  /// [userId] - Employee user ID
  /// [shiftId] - Shift ID
  /// [storeId] - Store ID
  /// [requestDate] - Request date in format 'yyyy-MM-dd'
  /// [approvedBy] - User ID of approver
  ///
  /// Returns insert result
  Future<Map<String, dynamic>> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
    required String approvedBy,
  });

  /// Process bulk shift approval
  ///
  /// [shiftRequestIds] - List of shift request IDs
  /// [approvalStates] - List of approval states
  ///
  /// Returns processing result
  Future<Map<String, dynamic>> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  });

  /// Update shift details
  ///
  /// [shiftRequestId] - Shift request ID
  /// [startTime] - Start time (optional)
  /// [endTime] - End time (optional)
  /// [isProblemSolved] - Problem solved status (optional)
  ///
  /// Returns update result
  Future<Map<String, dynamic>> updateShift({
    required String shiftRequestId,
    String? startTime,
    String? endTime,
    bool? isProblemSolved,
  });

  /// Input card data (comprehensive shift update with tags)
  ///
  /// [managerId] - Manager user ID performing the update
  /// [shiftRequestId] - Shift request ID to update
  /// [confirmStartTime] - Confirmed start time (HH:mm format)
  /// [confirmEndTime] - Confirmed end time (HH:mm format)
  /// [newTagContent] - Optional tag content to add
  /// [newTagType] - Optional tag type
  /// [isLate] - Whether employee was late
  /// [isProblemSolved] - Whether any problem was resolved
  ///
  /// Returns operation result
  Future<Map<String, dynamic>> inputCard({
    required String managerId,
    required String shiftRequestId,
    required String confirmStartTime,
    required String confirmEndTime,
    String? newTagContent,
    String? newTagType,
    required bool isLate,
    required bool isProblemSolved,
  });

  /// Get tags by card ID
  ///
  /// [cardId] - Card ID
  ///
  /// Returns list of tags
  Future<List<Map<String, dynamic>>> getTagsByCardId({
    required String cardId,
  });

  /// Add bonus to shift
  ///
  /// [shiftRequestId] - Shift request ID
  /// [bonusAmount] - Bonus amount
  /// [bonusReason] - Bonus reason
  ///
  /// Returns add bonus result
  Future<Map<String, dynamic>> addBonus({
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
