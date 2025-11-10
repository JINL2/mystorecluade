import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/available_employees_data.dart';
import '../../domain/entities/bulk_approval_result.dart';
import '../../domain/entities/card_input_result.dart';
import '../../domain/entities/manager_overview.dart';
import '../../domain/entities/manager_shift_cards.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/operation_result.dart';
import '../../domain/entities/schedule_data.dart';
import '../../domain/entities/shift.dart';
import '../../domain/entities/shift_approval_result.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/entities/shift_request.dart';
import '../../domain/entities/tag.dart';
import '../../domain/exceptions/time_table_exceptions.dart';
import '../../domain/repositories/time_table_repository.dart';
import '../../domain/value_objects/create_shift_params.dart';
import '../datasources/time_table_datasource.dart';
import '../models/available_employees_data_model.dart';
import '../models/bulk_approval_result_model.dart';
import '../models/card_input_result_model.dart';
import '../models/manager_overview_model.dart';
import '../models/manager_shift_cards_model.dart';
import '../models/monthly_shift_status_model.dart';
import '../models/operation_result_model.dart';
import '../models/schedule_data_model.dart';
import '../models/shift_approval_result_model.dart';
import '../models/shift_metadata_model.dart';
import '../models/shift_model.dart';
import '../models/shift_request_model.dart';
import '../models/tag_model.dart';

/// Time Table Repository Implementation
///
/// Implements the repository interface using the datasource.
class TimeTableRepositoryImpl implements TimeTableRepository {
  final TimeTableDatasource _datasource;

  TimeTableRepositoryImpl(this._datasource);

  @override
  Future<ShiftMetadata> getShiftMetadata({
    required String storeId,
  }) async {
    try {
      final data = await _datasource.getShiftMetadata(storeId: storeId);
      final model = ShiftMetadataModel.fromJson(data as Map<String, dynamic>);
      return model.toEntity();
    } catch (e) {
      if (e is ShiftMetadataException) rethrow;
      throw ShiftMetadataException(
        'Failed to fetch shift metadata: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatus({
    required String requestDate,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final data = await _datasource.getMonthlyShiftStatus(
        requestDate: requestDate,
        storeId: storeId,
      );

      // The RPC returns a flat array of daily records, we need to group by month
      // Each item has 'request_date' (yyyy-MM-dd), we group by yyyy-MM
      final Map<String, List<Map<String, dynamic>>> groupedByMonth = {};

      for (final item in data) {
        final itemMap = item as Map<String, dynamic>;
        final requestDate = itemMap['request_date'] as String?;

        if (requestDate != null && requestDate.length >= 7) {
          // Extract month (yyyy-MM) from date (yyyy-MM-dd)
          final month = requestDate.substring(0, 7);

          if (!groupedByMonth.containsKey(month)) {
            groupedByMonth[month] = [];
          }

          // Transform RPC response to match DailyShiftDataModel expectations
          final transformedItem = Map<String, dynamic>.from(itemMap);
          transformedItem['date'] = requestDate;
          transformedItem.remove('request_date');

          // Transform shifts array structure
          // RPC returns: {shift_id, shift_name, pending_employees, approved_employees, ...}
          // Model expects: {shift: {shift_id, shift_name, ...}, pending_requests: [...], approved_requests: [...]}
          if (transformedItem['shifts'] is List) {
            final shifts = transformedItem['shifts'] as List;
            // Create DateTime objects for default times (today at 09:00 and 18:00)
            final now = DateTime.now();
            final defaultStartTime = DateTime(now.year, now.month, now.day, 9, 0);
            final defaultEndTime = DateTime(now.year, now.month, now.day, 18, 0);

            transformedItem['shifts'] = shifts.map((shift) {
              if (shift is Map<String, dynamic>) {
                // Transform employee lists to add missing fields required by ShiftRequestModel
                final pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
                final approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];

                final transformPendingRequests = pendingEmployees.map((emp) {
                  if (emp is Map<String, dynamic>) {
                    return {
                      ...emp,
                      'shift_id': shift['shift_id'], // Add missing shift_id
                      'created_at': DateTimeUtils.toUtc(now), // Add missing created_at
                      'employee': {
                        'user_id': emp['user_id'],
                        'user_name': emp['user_name'],
                        'profile_image': emp['profile_image'],
                      },
                    };
                  }
                  return emp;
                }).toList();

                final transformApprovedRequests = approvedEmployees.map((emp) {
                  if (emp is Map<String, dynamic>) {
                    return {
                      ...emp,
                      'shift_id': shift['shift_id'], // Add missing shift_id
                      'created_at': DateTimeUtils.toUtc(now), // Add missing created_at
                      'approved_at': DateTimeUtils.toUtc(now), // Add approved_at for approved requests
                      'employee': {
                        'user_id': emp['user_id'],
                        'user_name': emp['user_name'],
                        'profile_image': emp['profile_image'],
                      },
                    };
                  }
                  return emp;
                }).toList();

                return {
                  'shift': {
                    'shift_id': shift['shift_id'],
                    'shift_name': shift['shift_name'],
                    'required_employees': shift['required_employees'],
                    'plan_start_time': DateTimeUtils.toUtc(defaultStartTime),
                    'plan_end_time': DateTimeUtils.toUtc(defaultEndTime),
                  },
                  'pending_requests': transformPendingRequests,
                  'approved_requests': transformApprovedRequests,
                };
              }
              return shift;
            }).toList();
          }

          groupedByMonth[month]!.add(transformedItem);
        }
      }

      // Convert each month's data to MonthlyShiftStatus entity
      final result = groupedByMonth.entries.map((entry) {
        try {
          // Create the structure that MonthlyShiftStatusModel expects
          final monthData = <String, dynamic>{
            'month': entry.key,
            'daily_shifts': entry.value,
            'statistics': <String, int>{},
          };

          final model = MonthlyShiftStatusModel.fromJson(monthData);
          return model.toEntity();
        } catch (e) {
          rethrow;
        }
      }).toList();

      return result;
    } catch (e) {
      if (e is ShiftStatusException) rethrow;
      throw ShiftStatusException(
        'Failed to fetch monthly shift status: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ManagerOverview> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final data = await _datasource.getManagerOverview(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
      );

      // Extract monthly_stats from the response structure
      // Response format: { stores: [{ monthly_stats: [{...}] }] }
      final stores = data['stores'] as List<dynamic>? ?? [];
      if (stores.isEmpty) {
        return const ManagerOverview(
          month: '',
          totalShifts: 0,
          totalApprovedRequests: 0,
          totalPendingRequests: 0,
          totalEmployees: 0,
          totalEstimatedCost: 0.0,
        );
      }

      final storeData = stores.first as Map<String, dynamic>;
      final monthlyStats = storeData['monthly_stats'] as List<dynamic>? ?? [];

      if (monthlyStats.isEmpty) {
        return const ManagerOverview(
          month: '',
          totalShifts: 0,
          totalApprovedRequests: 0,
          totalPendingRequests: 0,
          totalEmployees: 0,
          totalEstimatedCost: 0.0,
        );
      }

      final statsData = monthlyStats.first as Map<String, dynamic>;

      // Map the RPC response fields to model fields
      final mappedData = {
        'month': statsData['month'] ?? '',
        'total_shifts': statsData['total_requests'] ?? 0,  // Map total_requests to total_shifts
        'total_approved_requests': statsData['total_approved'] ?? 0,
        'total_pending_requests': statsData['total_pending'] ?? 0,
        'total_employees': statsData['total_employees'] ?? 0,
        'total_estimated_cost': statsData['total_estimated_cost'] ?? 0.0,
        'additional_stats': {
          'total_problems': statsData['total_problems'] ?? 0,  // Capture total_problems
        },
      };

      final model = ManagerOverviewModel.fromJson(mappedData);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch manager overview: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ManagerShiftCards> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final data = await _datasource.getManagerShiftCards(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
      );

      final model = ManagerShiftCardsModel.fromJson(data);
      final entity = model.toEntity();
      return entity;
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch manager shift cards: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ShiftApprovalResult> toggleShiftApproval({
    required String shiftRequestId,
    required bool newApprovalState,
  }) async {
    try {
      final data = await _datasource.toggleShiftApproval(
        shiftRequestId: shiftRequestId,
        newApprovalState: newApprovalState,
      );

      final model = ShiftApprovalResultModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is ShiftApprovalException) rethrow;
      throw ShiftApprovalException(
        'Failed to toggle shift approval: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<Shift> createShift({
    required CreateShiftParams params,
  }) async {
    try {
      // Validate parameters
      if (!params.isValid) {
        throw InvalidShiftParametersException(
          'Invalid shift parameters: ${params.validationErrors.join(", ")}',
        );
      }

      final data = await _datasource.createShift(params: params.toJson());
      final model = ShiftModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is ShiftCreationException || e is InvalidShiftParametersException) {
        rethrow;
      }
      throw ShiftCreationException(
        'Failed to create shift: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OperationResult> deleteShift({
    required String shiftId,
  }) async {
    try {
      await _datasource.deleteShift(shiftId: shiftId);
      return OperationResult.success(message: 'Shift deleted successfully');
    } catch (e) {
      if (e is ShiftDeletionException) rethrow;
      throw ShiftDeletionException(
        'Failed to delete shift: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OperationResult> deleteShiftTag({
    required String tagId,
    required String userId,
  }) async {
    try {
      final data = await _datasource.deleteShiftTag(tagId: tagId, userId: userId);
      final model = OperationResultModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to delete shift tag: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AvailableEmployeesData> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
  }) async {
    try {
      final data = await _datasource.getAvailableEmployees(
        storeId: storeId,
        shiftDate: shiftDate,
      );

      final model = AvailableEmployeesDataModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch employee list: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OperationResult> insertShiftSchedule({
    required String storeId,
    required String shiftId,
    required List<String> employeeIds,
  }) async {
    try {
      final data = await _datasource.insertShiftSchedule(
        storeId: storeId,
        shiftId: shiftId,
        employeeIds: employeeIds,
      );

      final model = OperationResultModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to add shift schedule: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ScheduleData> getScheduleData({
    required String storeId,
  }) async {
    try {
      final data = await _datasource.getScheduleData(storeId: storeId);
      final model = ScheduleDataModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch schedule data: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<BulkApprovalResult> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  }) async {
    try {
      final data = await _datasource.processBulkApproval(
        shiftRequestIds: shiftRequestIds,
        approvalStates: approvalStates,
      );

      final model = BulkApprovalResultModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to process bulk approval: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ShiftRequest> updateShift({
    required String shiftRequestId,
    String? startTime,
    String? endTime,
    bool? isProblemSolved,
  }) async {
    try {
      final data = await _datasource.updateShift(
        shiftRequestId: shiftRequestId,
        startTime: startTime,
        endTime: endTime,
        isProblemSolved: isProblemSolved,
      );

      final model = ShiftRequestModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to update shift: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OperationResult> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
    required String approvedBy,
  }) async {
    try {
      final data = await _datasource.insertSchedule(
        userId: userId,
        shiftId: shiftId,
        storeId: storeId,
        requestDate: requestDate,
        approvedBy: approvedBy,
      );

      final model = OperationResultModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to add schedule: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<CardInputResult> inputCard({
    required String managerId,
    required String shiftRequestId,
    required String confirmStartTime,
    required String confirmEndTime,
    String? newTagContent,
    String? newTagType,
    required bool isLate,
    required bool isProblemSolved,
  }) async {
    try {
      final data = await _datasource.inputCard(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmStartTime,
        confirmEndTime: confirmEndTime,
        newTagContent: newTagContent,
        newTagType: newTagType,
        isLate: isLate,
        isProblemSolved: isProblemSolved,
      );

      final model = CardInputResultModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to input card: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Tag>> getTagsByCardId({
    required String cardId,
  }) async {
    try {
      final data = await _datasource.getTagsByCardId(cardId: cardId);
      return data.map((json) => TagModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch tags: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OperationResult> addBonus({
    required String shiftRequestId,
    required double bonusAmount,
    required String bonusReason,
  }) async {
    try {
      final data = await _datasource.addBonus(
        shiftRequestId: shiftRequestId,
        bonusAmount: bonusAmount,
        bonusReason: bonusReason,
      );

      final model = OperationResultModel.fromJson(data);
      return model.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to add bonus: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateBonusAmount({
    required String shiftRequestId,
    required double bonusAmount,
  }) async {
    try {
      await _datasource.updateBonusAmount(
        shiftRequestId: shiftRequestId,
        bonusAmount: bonusAmount,
      );
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to update bonus: $e',
        originalError: e,
      );
    }
  }
}
