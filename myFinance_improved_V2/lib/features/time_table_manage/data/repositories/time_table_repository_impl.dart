import 'package:flutter/foundation.dart';

import '../../../../core/data/base_repository.dart';
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
import '../../domain/repositories/time_table_repository.dart';
import '../../domain/value_objects/create_shift_params.dart';
import '../datasources/time_table_datasource.dart';
import '../mappers/manager_overview_mapper.dart';
import '../mappers/manager_shift_cards_mapper.dart';
import '../mappers/monthly_shift_status_mapper.dart';

/// Time Table Repository Implementation
///
/// Implements the repository interface using the datasource.
/// Extends BaseRepository for standardized error handling.
class TimeTableRepositoryImpl extends BaseRepository
    implements TimeTableRepository {
  final TimeTableDatasource _datasource;

  TimeTableRepositoryImpl(this._datasource);

  @override
  Future<ShiftMetadata> getShiftMetadata({
    required String storeId,
  }) async {
    return executeFetch(
      () async {
        final data = await _datasource.getShiftMetadata(storeId: storeId);
        return ShiftMetadata.fromJson(data);
      },
      operationName: 'shift metadata',
    );
  }

  @override
  Future<List<MonthlyShiftStatus>> getMonthlyShiftStatus({
    required String requestDate,
    required String companyId,
    required String storeId,
  }) async {
    return executeFetch(
      () async {
        final rpcData = await _datasource.getMonthlyShiftStatus(
          requestDate: requestDate,
          storeId: storeId,
        );

        // Delegate complex transformation to Mapper
        return MonthlyShiftStatusMapper.fromRpcResponse(rpcData);
      },
      operationName: 'monthly shift status',
    );
  }

  @override
  Future<ManagerOverview> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) async {
    return executeFetch(
      () async {
        final data = await _datasource.getManagerOverview(
          startDate: startDate,
          endDate: endDate,
          companyId: companyId,
          storeId: storeId,
        );

        // Delegate complex transformation to Mapper
        return ManagerOverviewMapper.fromRpcResponse(data);
      },
      operationName: 'manager overview',
    );
  }

  @override
  Future<ManagerShiftCards> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) async {
    return executeFetch(
      () async {
        final rpcData = await _datasource.getManagerShiftCards(
          startDate: startDate,
          endDate: endDate,
          companyId: companyId,
          storeId: storeId,
        );

        // Delegate complex transformation to Mapper
        return ManagerShiftCardsMapper.fromRpcResponse(
          rpcData,
          storeId: storeId,
          startDate: startDate,
          endDate: endDate,
        );
      },
      operationName: 'manager shift cards',
    );
  }

  @override
  Future<ShiftApprovalResult> toggleShiftApproval({
    required String shiftRequestId,
    required bool newApprovalState,
  }) async {
    return executeWithErrorHandling(
      () async {
        final data = await _datasource.toggleShiftApproval(
          shiftRequestId: shiftRequestId,
          newApprovalState: newApprovalState,
        );

        return ShiftApprovalResult.fromJson(data);
      },
      operationName: 'toggle shift approval',
    );
  }

  @override
  Future<Shift> createShift({
    required CreateShiftParams params,
  }) async {
    return executeWithErrorHandling(
      () async {
        // Note: Validation is performed in the UseCase layer
        // Repository only handles data operations
        final data = await _datasource.createShift(params: params.toJson());
        return Shift.fromJsonWithTimeContext(data);
      },
      operationName: 'create shift',
    );
  }

  @override
  Future<OperationResult> deleteShift({
    required String shiftId,
  }) async {
    return executeWithErrorHandling(
      () async {
        await _datasource.deleteShift(shiftId: shiftId);
        return OperationResult.success(message: 'Shift deleted successfully');
      },
      operationName: 'delete shift',
    );
  }

  @override
  Future<OperationResult> deleteShiftTag({
    required String tagId,
    required String userId,
  }) async {
    return executeWithErrorHandling(
      () async {
        final data =
            await _datasource.deleteShiftTag(tagId: tagId, userId: userId);
        return OperationResult.fromJson(data);
      },
      operationName: 'delete shift tag',
    );
  }

  @override
  Future<AvailableEmployeesData> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
  }) async {
    return executeFetch(
      () async {
        final data = await _datasource.getAvailableEmployees(
          storeId: storeId,
          shiftDate: shiftDate,
        );

        return AvailableEmployeesData.fromJson(data);
      },
      operationName: 'employee list',
    );
  }

  @override
  Future<OperationResult> insertShiftSchedule({
    required String storeId,
    required String shiftId,
    required List<String> employeeIds,
  }) async {
    return executeWithErrorHandling(
      () async {
        final data = await _datasource.insertShiftSchedule(
          storeId: storeId,
          shiftId: shiftId,
          employeeIds: employeeIds,
        );

        return OperationResult.fromJson(data);
      },
      operationName: 'add shift schedule',
    );
  }

  @override
  Future<ScheduleData> getScheduleData({
    required String storeId,
  }) async {
    return executeFetch(
      () async {
        final data = await _datasource.getScheduleData(storeId: storeId);
        return ScheduleData.fromJson(data);
      },
      operationName: 'schedule data',
    );
  }

  @override
  Future<BulkApprovalResult> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  }) async {
    return executeWithErrorHandling(
      () async {
        final data = await _datasource.processBulkApproval(
          shiftRequestIds: shiftRequestIds,
          approvalStates: approvalStates,
        );

        return BulkApprovalResult.fromJson(data);
      },
      operationName: 'process bulk approval',
    );
  }

  @override
  Future<ShiftRequest> updateShift({
    required String shiftRequestId,
    String? startTime,
    String? endTime,
    bool? isProblemSolved,
  }) async {
    return executeWithErrorHandling(
      () async {
        final data = await _datasource.updateShift(
          shiftRequestId: shiftRequestId,
          startTime: startTime,
          endTime: endTime,
          isProblemSolved: isProblemSolved,
        );

        return ShiftRequest.fromJson(data);
      },
      operationName: 'update shift',
    );
  }

  @override
  Future<OperationResult> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
    required String approvedBy,
  }) async {
    return executeWithErrorHandling(
      () async {
        final data = await _datasource.insertSchedule(
          userId: userId,
          shiftId: shiftId,
          storeId: storeId,
          requestDate: requestDate,
          approvedBy: approvedBy,
        );

        return OperationResult.fromJson(data);
      },
      operationName: 'add schedule',
    );
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
    return executeWithErrorHandling(
      () async {
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

        return CardInputResult.fromJson(data);
      },
      operationName: 'input card',
    );
  }

  @override
  Future<List<Tag>> getTagsByCardId({
    required String cardId,
  }) async {
    return executeFetch(
      () async {
        final data = await _datasource.getTagsByCardId(cardId: cardId);
        return data.map((json) => Tag.fromJson(json)).toList();
      },
      operationName: 'tags',
    );
  }

  @override
  Future<OperationResult> addBonus({
    required String shiftRequestId,
    required double bonusAmount,
    required String bonusReason,
  }) async {
    return executeWithErrorHandling(
      () async {
        final data = await _datasource.addBonus(
          shiftRequestId: shiftRequestId,
          bonusAmount: bonusAmount,
          bonusReason: bonusReason,
        );

        return OperationResult.fromJson(data);
      },
      operationName: 'add bonus',
    );
  }

  @override
  Future<void> updateBonusAmount({
    required String shiftRequestId,
    required double bonusAmount,
  }) async {
    return executeWithErrorHandling(
      () async {
        await _datasource.updateBonusAmount(
          shiftRequestId: shiftRequestId,
          bonusAmount: bonusAmount,
        );
      },
      operationName: 'update bonus',
    );
  }
}
