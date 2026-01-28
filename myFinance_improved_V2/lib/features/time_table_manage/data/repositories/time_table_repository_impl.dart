import '../../domain/entities/bulk_approval_result.dart';
import '../../domain/entities/card_input_result.dart';
import '../../domain/entities/employee_info.dart';
import '../../domain/entities/employee_monthly_detail.dart';
import '../../domain/entities/manager_overview.dart';
import '../../domain/entities/manager_shift_cards.dart';
import '../../domain/entities/monthly_shift_status.dart';
import '../../domain/entities/operation_result.dart';
import '../../domain/entities/reliability_score.dart';
import '../../domain/entities/schedule_data.dart';
import '../../domain/entities/shift_audit_log.dart';
import '../../domain/entities/shift_metadata.dart';
import '../../domain/entities/shift_request.dart';
import '../../domain/entities/store_employee.dart';
import '../../domain/exceptions/time_table_exceptions.dart';
import '../models/employee_monthly_detail_model.dart';
import '../../domain/repositories/time_table_repository.dart';
import '../datasources/time_table_datasource.dart';
// Freezed DTOs
import '../models/freezed/bulk_approval_result_dto.dart';
import '../models/freezed/bulk_approval_result_dto_mapper.dart';
import '../models/freezed/manager_overview_dto.dart';
import '../models/freezed/manager_overview_dto_mapper.dart';
import '../models/freezed/manager_shift_cards_dto.dart';
import '../models/freezed/manager_shift_cards_dto_mapper.dart';
import '../models/freezed/monthly_shift_status_dto.dart';
import '../models/freezed/monthly_shift_status_dto_mapper.dart';
import '../models/freezed/operation_result_dto.dart';
import '../models/freezed/operation_result_dto_mapper.dart';
import '../models/freezed/reliability_score_dto.dart';
import '../models/freezed/reliability_score_dto_mapper.dart';
import '../models/freezed/schedule_data_dto.dart';
import '../models/freezed/schedule_data_dto_mapper.dart';
import '../models/freezed/shift_audit_log_dto.dart';
import '../models/freezed/shift_audit_log_dto_mapper.dart';
import '../models/freezed/shift_metadata_dto.dart';
import '../models/freezed/shift_metadata_dto_mapper.dart';
import '../models/freezed/store_employee_dto.dart';
import '../models/freezed/store_employee_dto_mapper.dart';

/// Time Table Repository Implementation
///
/// Implements the repository interface using the datasource.
class TimeTableRepositoryImpl implements TimeTableRepository {
  final TimeTableDatasource _datasource;

  TimeTableRepositoryImpl(this._datasource);

  @override
  Future<ShiftMetadata> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) async {
    try {
      final data = await _datasource.getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      // RPC returns TABLE format (List of rows), convert to List<ShiftMetadataDto>
      final List<ShiftMetadataDto> dtos = (data as List)
          .map((item) => ShiftMetadataDto.fromJson(item as Map<String, dynamic>))
          .toList();

      // Convert DTOs to entity using mapper
      return ShiftMetadataDtoMapper.toEntity(dtos);
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
    required String requestTime,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final data = await _datasource.getMonthlyShiftStatus(
        requestTime: requestTime,
        storeId: storeId,
        timezone: timezone,
      );

      // Pre-process data to handle null arrays before DTO conversion
      final processedData = data.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        // Handle null shifts array
        if (map['shifts'] == null) {
          map['shifts'] = <dynamic>[];
        } else if (map['shifts'] is List) {
          // Process each shift to handle null employee arrays
          map['shifts'] = (map['shifts'] as List).map((shift) {
            final shiftMap = Map<String, dynamic>.from(shift as Map);
            // Handle null employee arrays
            if (shiftMap['approved_employees'] == null) {
              shiftMap['approved_employees'] = <dynamic>[];
            }
            if (shiftMap['pending_employees'] == null) {
              shiftMap['pending_employees'] = <dynamic>[];
            }
            return shiftMap;
          }).toList();
        }
        return map;
      }).toList();

      // Convert to DTOs
      final dtos = processedData
          .map((item) => MonthlyShiftStatusDto.fromJson(item))
          .toList();

      // Group by month and convert to entities
      // v4: shiftDate (from start_time_utc) instead of requestDate
      final Map<String, List<MonthlyShiftStatusDto>> groupedByMonth = {};
      for (final dto in dtos) {
        final month = dto.shiftDate.substring(0, 7); // yyyy-MM
        groupedByMonth.putIfAbsent(month, () => []).add(dto);
      }

      // Convert to entities
      return groupedByMonth.entries
          .map((entry) => _createMonthlyStatus(entry.key, entry.value))
          .toList();
    } catch (e) {
      if (e is ShiftStatusException) rethrow;
      throw ShiftStatusException(
        'Failed to fetch monthly shift status: $e',
        originalError: e,
      );
    }
  }

  /// Helper to create MonthlyShiftStatus from grouped DTOs
  MonthlyShiftStatus _createMonthlyStatus(
      String month,
      List<MonthlyShiftStatusDto> dtos,) {
    final dailyShifts = dtos.map((dto) => dto.toEntity(month: month)).toList();

    // Aggregate statistics
    final totalRequired = dtos.fold<int>(0, (sum, dto) => sum + dto.totalRequired);
    final totalApproved = dtos.fold<int>(0, (sum, dto) => sum + dto.totalApproved);
    final totalPending = dtos.fold<int>(0, (sum, dto) => sum + dto.totalPending);

    return MonthlyShiftStatus(
      month: month,
      dailyShifts: dailyShifts.expand((status) => status.dailyShifts).toList(),
      statistics: {
        'total_required': totalRequired,
        'total_approved': totalApproved,
        'total_pending': totalPending,
      },
    );
  }

  @override
  Future<ManagerOverview> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final data = await _datasource.getManagerOverview(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      // ✅ FREEZED: Direct DTO conversion
      final dto = ManagerOverviewDto.fromJson(data);
      return dto.toEntity();
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
    required String timezone,
  }) async {
    try {
      final data = await _datasource.getManagerShiftCards(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      final dto = ManagerShiftCardsDto.fromJson(data);
      final entity = dto.toEntity(
        storeId: storeId,
        startDate: startDate,
        endDate: endDate,
      );
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
  Future<void> toggleShiftApproval({
    required List<String> shiftRequestIds,
    required String userId,
  }) async {
    try {
      await _datasource.toggleShiftApproval(
        shiftRequestIds: shiftRequestIds,
        userId: userId,
      );
    } catch (e) {
      if (e is ShiftApprovalException) rethrow;
      throw ShiftApprovalException(
        'Failed to toggle shift approval: $e',
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
      // ✅ FREEZED: Direct DTO conversion
      final dto = OperationResultDto.fromJson(data);
      return dto.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to delete shift tag: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ScheduleData> getScheduleData({
    required String storeId,
    required String timezone,
  }) async {
    try {
      final data = await _datasource.getScheduleData(
        storeId: storeId,
        timezone: timezone,
      );
      final dto = ScheduleDataDto.fromJson(data);
      return dto.toEntity(storeId: storeId);
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

      // ✅ FREEZED: Direct DTO conversion
      final dto = BulkApprovalResultDto.fromJson(data);
      return dto.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to process bulk approval: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OperationResult> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String approvedBy,
    required String timezone,
  }) async {
    try {
      final data = await _datasource.insertSchedule(
        userId: userId,
        shiftId: shiftId,
        storeId: storeId,
        startTime: startTime,
        endTime: endTime,
        approvedBy: approvedBy,
        timezone: timezone,
      );

      // ✅ FREEZED: Direct DTO conversion
      final dto = OperationResultDto.fromJson(data);
      return dto.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to add schedule: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ReliabilityScore> getReliabilityScore({
    required String companyId,
    required String storeId,
    required String time,
    required String timezone,
  }) async {
    try {
      final data = await _datasource.getReliabilityScore(
        companyId: companyId,
        storeId: storeId,
        time: time,
        timezone: timezone,
      );

      // ✅ FREEZED: Direct DTO conversion
      final dto = ReliabilityScoreDto.fromJson(data);
      return dto.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch reliability score: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<List<StoreEmployee>> getStoreEmployees({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final data = await _datasource.getStoreEmployees(
        companyId: companyId,
        storeId: storeId,
      );

      // ✅ FREEZED: DTO → Entity conversion via mapper
      return data
          .map((item) => StoreEmployeeDto.fromJson(item as Map<String, dynamic>))
          .map((dto) => dto.toStoreEmployee())
          .toList();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch store employees: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> inputCardV5({
    required String managerId,
    required String shiftRequestId,
    String? confirmStartTime,
    String? confirmEndTime,
    bool? isProblemSolved,
    bool? isReportedSolved,
    double? bonusAmount,
    String? managerMemo,
    required String timezone,
  }) async {
    try {
      return await _datasource.inputCardV5(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmStartTime,
        confirmEndTime: confirmEndTime,
        isProblemSolved: isProblemSolved,
        isReportedSolved: isReportedSolved,
        bonusAmount: bonusAmount,
        managerMemo: managerMemo,
        timezone: timezone,
      );
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to input card v5: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<EmployeeMonthlyDetail> getEmployeeMonthlyDetailLog({
    required String userId,
    required String companyId,
    required String yearMonth,
    required String timezone,
  }) async {
    try {
      final data = await _datasource.getEmployeeMonthlyDetailLog(
        userId: userId,
        companyId: companyId,
        yearMonth: yearMonth,
        timezone: timezone,
      );

      return EmployeeMonthlyDetailModel.fromJson(data);
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch employee monthly detail: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<CardInputResult> inputCard({
    required String managerId,
    required String shiftRequestId,
    String? confirmStartTime,
    String? confirmEndTime,
    String? newTagContent,
    String? newTagType,
    required bool isLate,
    required bool isProblemSolved,
    required String timezone,
  }) async {
    try {
      // Call inputCardV5 which is the current implementation
      final result = await _datasource.inputCardV5(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmStartTime,
        confirmEndTime: confirmEndTime,
        isProblemSolved: isProblemSolved,
        timezone: timezone,
      );

      // Convert result to CardInputResult entity
      // Since inputCardV5 returns basic success/error info,
      // we create a minimal CardInputResult
      if (result['success'] != true) {
        throw TimeTableException(
          result['error']?.toString() ?? 'Failed to input card',
        );
      }

      // Return a basic CardInputResult
      // The actual implementation should parse the full response
      return CardInputResult(
        shiftRequestId: shiftRequestId,
        confirmedStartTime: DateTime.now(), // Placeholder
        confirmedEndTime: DateTime.now(), // Placeholder
        isLate: isLate,
        isProblemSolved: isProblemSolved,
        updatedRequest: ShiftRequest(
          shiftRequestId: shiftRequestId,
          shiftId: '',
          employee: const EmployeeInfo(userId: '', userName: ''),
          isApproved: true,
          createdAt: DateTime.now(),
        ),
        message: result['message']?.toString(),
      );
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to input card: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ShiftAuditLog>> getShiftAuditLogs({
    required String shiftRequestId,
  }) async {
    try {
      final data = await _datasource.getShiftAuditLogs(
        shiftRequestId: shiftRequestId,
      );

      // ✅ FREEZED: DTO → Entity conversion via mapper
      return data
          .map((item) => ShiftAuditLogDto.fromJson(item as Map<String, dynamic>))
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch shift audit logs: $e',
        originalError: e,
      );
    }
  }
}
