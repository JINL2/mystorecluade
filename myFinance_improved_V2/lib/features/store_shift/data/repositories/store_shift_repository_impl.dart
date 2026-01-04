import '../../domain/entities/business_hours.dart';
import '../../domain/entities/store_shift.dart';
import '../../domain/entities/work_schedule_template.dart';
import '../../domain/repositories/store_shift_repository.dart';
import '../datasources/store_shift_data_source.dart';
import '../models/business_hours_dto.dart';
import '../models/store_shift_model.dart';
import '../models/work_schedule_template_model.dart';

/// Store Shift Repository Implementation
///
/// Implements the repository interface defined in the domain layer.
/// This class:
/// - Delegates data operations to the data source
/// - Converts between models (data layer) and entities (domain layer)
/// - Handles business logic related to data transformation
class StoreShiftRepositoryImpl implements StoreShiftRepository {
  final StoreShiftDataSource _dataSource;

  StoreShiftRepositoryImpl(this._dataSource);

  @override
  Future<List<StoreShift>> getShiftsByStoreId(String storeId) async {
    final shiftsData = await _dataSource.getShiftsByStoreId(storeId);

    return shiftsData
        .map((json) => StoreShiftModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<StoreShift> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    final shiftData = await _dataSource.createShift(
      storeId: storeId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      shiftBonus: shiftBonus,
    );

    // RPC returns {success, message, shift_id}, not full shift data
    // Create a minimal StoreShift with the returned shift_id
    return StoreShift(
      shiftId: shiftData['shift_id'] as String,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      shiftBonus: shiftBonus ?? 0,
      isActive: true,
      numberShift: numberShift ?? 1,
      isCanOvertime: isCanOvertime ?? true,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<StoreShift> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    await _dataSource.updateShift(
      shiftId: shiftId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      shiftBonus: shiftBonus,
    );

    // RPC returns {success, message} only
    // Return a StoreShift with the LOCAL time parameters that were sent
    // The RPC already converted these to UTC and saved to the database
    // When the UI refreshes (ref.invalidate), it will fetch the correct UTC times
    return StoreShift(
      shiftId: shiftId,
      shiftName: shiftName ?? '',
      startTime: startTime ?? '',  // Local time as sent by user
      endTime: endTime ?? '',      // Local time as sent by user
      shiftBonus: shiftBonus ?? 0,
      isActive: true,
      numberShift: numberShift ?? 1,
      isCanOvertime: isCanOvertime ?? true,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> deleteShift(String shiftId) async {
    await _dataSource.deleteShift(shiftId);
  }

  @override
  Future<Map<String, dynamic>> getStoreById(String storeId) async {
    return await _dataSource.getStoreById(storeId);
  }

  @override
  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    await _dataSource.updateStoreLocation(
      storeId: storeId,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }

  @override
  Future<void> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    await _dataSource.updateOperationalSettings(
      storeId: storeId,
      huddleTime: huddleTime,
      paymentTime: paymentTime,
      allowedDistance: allowedDistance,
    );
  }

  @override
  Future<void> updateStoreInfo({
    required String storeId,
    String? storeName,
    String? storeEmail,
    String? storePhone,
    String? storeAddress,
  }) async {
    await _dataSource.updateStoreInfo(
      storeId: storeId,
      storeName: storeName,
      storeEmail: storeEmail,
      storePhone: storePhone,
      storeAddress: storeAddress,
    );
  }

  /// ========================================
  /// Business Hours Operations
  /// ========================================

  @override
  Future<List<BusinessHours>> getBusinessHours(String storeId) async {
    final hoursData = await _dataSource.getBusinessHours(storeId);

    // DTO로 파싱 후 Entity로 변환
    return hoursData
        .map((json) => BusinessHoursDto.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<bool> updateBusinessHours({
    required String storeId,
    required List<BusinessHours> hours,
  }) async {
    // Entity를 DTO로 변환 후 JSON으로 직렬화
    final hoursJson = hours
        .map((h) => BusinessHoursDto.fromEntity(h).toJson())
        .toList();

    final success = await _dataSource.upsertBusinessHours(
      storeId: storeId,
      hours: hoursJson,
    );

    return success;
  }

  /// ========================================
  /// Work Schedule Template Operations (Company-level)
  /// ========================================

  @override
  Future<List<WorkScheduleTemplate>> getWorkScheduleTemplates(
    String companyId,
  ) async {
    final templatesData = await _dataSource.getWorkScheduleTemplates(companyId);

    return templatesData
        .map((json) => WorkScheduleTemplateModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<Map<String, dynamic>> createWorkScheduleTemplate({
    required String companyId,
    required String templateName,
    String workStartTime = '09:00',
    String workEndTime = '18:00',
    bool monday = true,
    bool tuesday = true,
    bool wednesday = true,
    bool thursday = true,
    bool friday = true,
    bool saturday = false,
    bool sunday = false,
    bool isDefault = false,
  }) async {
    return await _dataSource.createWorkScheduleTemplate(
      companyId: companyId,
      templateName: templateName,
      workStartTime: workStartTime,
      workEndTime: workEndTime,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
      isDefault: isDefault,
    );
  }

  @override
  Future<Map<String, dynamic>> updateWorkScheduleTemplate({
    required String templateId,
    String? templateName,
    String? workStartTime,
    String? workEndTime,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
    bool? isDefault,
  }) async {
    return await _dataSource.updateWorkScheduleTemplate(
      templateId: templateId,
      templateName: templateName,
      workStartTime: workStartTime,
      workEndTime: workEndTime,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
      isDefault: isDefault,
    );
  }

  @override
  Future<Map<String, dynamic>> deleteWorkScheduleTemplate(
    String templateId,
  ) async {
    return await _dataSource.deleteWorkScheduleTemplate(templateId);
  }
}
