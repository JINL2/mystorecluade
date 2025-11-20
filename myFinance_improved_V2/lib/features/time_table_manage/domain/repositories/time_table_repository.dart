import '../entities/available_employees_data.dart';
import '../entities/bulk_approval_result.dart';
import '../entities/card_input_result.dart';
import '../entities/manager_overview.dart';
import '../entities/manager_shift_cards.dart';
import '../entities/monthly_shift_status.dart';
import '../entities/operation_result.dart';
import '../entities/schedule_data.dart';
import '../entities/shift.dart';
import '../entities/shift_approval_result.dart';
import '../entities/shift_metadata.dart';
import '../entities/shift_request.dart';
import '../entities/tag.dart';
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

  /// Get raw shift metadata for UI display
  ///
  /// [storeId] - Store ID
  ///
  /// Returns dynamic list directly from RPC for backward compatibility
  Future<dynamic> getShiftMetadataRaw({
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
  /// [startDate] - Start date in format 'yyyy-MM-dd'
  /// [endDate] - End date in format 'yyyy-MM-dd'
  /// [companyId] - Company ID
  /// [storeId] - Store ID
  ///
  /// Returns [ManagerShiftCards] entity with cards collection
  Future<ManagerShiftCards> getManagerShiftCards({
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
  /// Returns [ShiftApprovalResult] with updated request
  Future<ShiftApprovalResult> toggleShiftApproval({
    required String shiftRequestId,
    required bool newApprovalState,
  });

  /// Create a new shift
  ///
  /// [params] - Parameters for creating the shift
  ///
  /// Returns created [Shift] entity
  Future<Shift> createShift({
    required CreateShiftParams params,
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

  /// Get available employees for shift assignment
  ///
  /// [storeId] - Store ID
  /// [shiftDate] - Shift date in format 'yyyy-MM-dd'
  ///
  /// Returns [AvailableEmployeesData] with employees list and existing shifts
  Future<AvailableEmployeesData> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
  });

  /// Get schedule data (employees and shifts) for a store
  ///
  /// [storeId] - Store ID
  ///
  /// Returns [ScheduleData] with employees and shifts
  Future<ScheduleData> getScheduleData({
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
  /// Returns [OperationResult] indicating success or failure
  Future<OperationResult> insertSchedule({
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
  /// Returns [BulkApprovalResult] with detailed processing results
  Future<BulkApprovalResult> processBulkApproval({
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
  /// Returns updated [ShiftRequest] entity
  Future<ShiftRequest> updateShift({
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
  });

  /// Get tags by card ID
  ///
  /// [cardId] - Card ID
  ///
  /// Returns list of [Tag] entities
  Future<List<Tag>> getTagsByCardId({
    required String cardId,
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
