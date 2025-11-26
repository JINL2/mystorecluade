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
// Freezed DTOs
import '../models/freezed/available_employees_data_dto.dart';
import '../models/freezed/available_employees_data_dto_mapper.dart';
import '../models/freezed/bulk_approval_result_dto.dart';
import '../models/freezed/bulk_approval_result_dto_mapper.dart';
import '../models/freezed/card_input_result_dto.dart';
import '../models/freezed/card_input_result_dto_mapper.dart';
import '../models/freezed/manager_overview_dto.dart';
import '../models/freezed/manager_overview_dto_mapper.dart';
import '../models/freezed/manager_shift_cards_dto.dart';
import '../models/freezed/manager_shift_cards_dto_mapper.dart';
import '../models/freezed/monthly_shift_status_dto.dart';
import '../models/freezed/monthly_shift_status_dto_mapper.dart';
import '../models/freezed/operation_result_dto.dart';
import '../models/freezed/operation_result_dto_mapper.dart';
import '../models/freezed/schedule_data_dto.dart';
import '../models/freezed/schedule_data_dto_mapper.dart';
import '../models/freezed/shift_approval_result_dto.dart';
import '../models/freezed/shift_approval_result_dto_mapper.dart';
import '../models/freezed/shift_card_dto.dart';
import '../models/freezed/shift_card_dto_mapper.dart';
import '../models/freezed/shift_dto.dart';
import '../models/freezed/shift_dto_mapper.dart';
import '../models/freezed/shift_metadata_dto.dart';
import '../models/freezed/shift_metadata_dto_mapper.dart';
import '../models/freezed/shift_request_dto.dart';
import '../models/freezed/shift_request_dto_mapper.dart';

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
  Future<dynamic> getShiftMetadataRaw({
    required String storeId,
  }) async {
    try {
      return await _datasource.getShiftMetadata(storeId: storeId);
    } catch (e) {
      if (e is ShiftMetadataException) rethrow;
      throw ShiftMetadataException(
        'Failed to fetch raw shift metadata: $e',
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

      // ✅ FREEZED: Simple DTO conversion (100+ lines → 10 lines!)
      final dtos = data
          .map((item) =>
              MonthlyShiftStatusDto.fromJson(item as Map<String, dynamic>),)
          .toList();

      // Group by month and convert to entities
      final Map<String, List<MonthlyShiftStatusDto>> groupedByMonth = {};
      for (final dto in dtos) {
        final month = dto.requestDate.substring(0, 7); // yyyy-MM
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
  }) async {
    try {
      final data = await _datasource.getManagerOverview(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
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
  }) async {
    try {
      final data = await _datasource.getManagerShiftCards(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
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
  Future<ShiftApprovalResult> toggleShiftApproval({
    required String shiftRequestId,
    required bool newApprovalState,
  }) async {
    try {
      final data = await _datasource.toggleShiftApproval(
        shiftRequestId: shiftRequestId,
        newApprovalState: newApprovalState,
      );

      final dto = ShiftApprovalResultDto.fromJson(data);
      return dto.toEntity();
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
      final dto = ShiftDto.fromJson(data);
      return dto.toEntity();
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
  Future<AvailableEmployeesData> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
  }) async {
    try {
      final data = await _datasource.getAvailableEmployees(
        storeId: storeId,
        shiftDate: shiftDate,
      );

      final dto = AvailableEmployeesDataDto.fromJson(data);
      return dto.toEntity();
    } catch (e) {
      if (e is TimeTableException) rethrow;
      throw TimeTableException(
        'Failed to fetch employee list: $e',
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

      final dto = ShiftRequestDto.fromJson(data);
      return dto.toEntity();
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

      final dto = CardInputResultDto.fromJson(data);
      return dto.toEntity();
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
      return data.map((json) => TagDto.fromJson(json).toEntity()).toList();
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

      // ✅ FREEZED: Direct DTO conversion
      final dto = OperationResultDto.fromJson(data);
      return dto.toEntity();
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
