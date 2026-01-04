import '../../../../core/services/supabase_service.dart';
import 'business_hours_datasource.dart';
import 'shift_datasource.dart';
import 'store_datasource.dart';
import 'work_schedule_template_datasource.dart';

/// Store Shift Data Source (Facade)
///
/// Provides unified access to all store shift related data sources.
/// This is a facade pattern that delegates to specialized data sources
/// while maintaining backward compatibility.
///
/// Composed of:
/// - ShiftDataSource: Shift CRUD operations
/// - StoreDataSource: Store info and settings
/// - BusinessHoursDataSource: Business hours operations
/// - WorkScheduleTemplateDataSource: Work schedule template operations
class StoreShiftDataSource {
  final ShiftDataSource _shiftDataSource;
  final StoreDataSource _storeDataSource;
  final BusinessHoursDataSource _businessHoursDataSource;
  final WorkScheduleTemplateDataSource _workScheduleTemplateDataSource;

  StoreShiftDataSource(SupabaseService supabaseService)
      : _shiftDataSource = ShiftDataSource(supabaseService),
        _storeDataSource = StoreDataSource(supabaseService),
        _businessHoursDataSource = BusinessHoursDataSource(supabaseService),
        _workScheduleTemplateDataSource =
            WorkScheduleTemplateDataSource(supabaseService);

  // ========================================
  // Shift Operations (delegated to ShiftDataSource)
  // ========================================

  Future<List<Map<String, dynamic>>> getShiftsByStoreId(String storeId) =>
      _shiftDataSource.getShiftsByStoreId(storeId);

  Future<Map<String, dynamic>> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) =>
      _shiftDataSource.createShift(
        storeId: storeId,
        shiftName: shiftName,
        startTime: startTime,
        endTime: endTime,
        numberShift: numberShift,
        isCanOvertime: isCanOvertime,
        shiftBonus: shiftBonus,
      );

  Future<Map<String, dynamic>> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) =>
      _shiftDataSource.updateShift(
        shiftId: shiftId,
        shiftName: shiftName,
        startTime: startTime,
        endTime: endTime,
        numberShift: numberShift,
        isCanOvertime: isCanOvertime,
        shiftBonus: shiftBonus,
      );

  Future<void> deleteShift(String shiftId) =>
      _shiftDataSource.deleteShift(shiftId);

  // ========================================
  // Store Operations (delegated to StoreDataSource)
  // ========================================

  Future<Map<String, dynamic>> getStoreById(String storeId) =>
      _storeDataSource.getStoreById(storeId);

  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  }) =>
      _storeDataSource.updateStoreLocation(
        storeId: storeId,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

  Future<void> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) =>
      _storeDataSource.updateOperationalSettings(
        storeId: storeId,
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      );

  Future<void> updateStoreInfo({
    required String storeId,
    String? storeName,
    String? storeEmail,
    String? storePhone,
    String? storeAddress,
  }) =>
      _storeDataSource.updateStoreInfo(
        storeId: storeId,
        storeName: storeName,
        storeEmail: storeEmail,
        storePhone: storePhone,
        storeAddress: storeAddress,
      );

  // ========================================
  // Business Hours Operations (delegated to BusinessHoursDataSource)
  // ========================================

  Future<List<Map<String, dynamic>>> getBusinessHours(String storeId) =>
      _businessHoursDataSource.getBusinessHours(storeId);

  Future<bool> upsertBusinessHours({
    required String storeId,
    required List<Map<String, dynamic>> hours,
  }) =>
      _businessHoursDataSource.upsertBusinessHours(
        storeId: storeId,
        hours: hours,
      );

  // ========================================
  // Work Schedule Template Operations (delegated to WorkScheduleTemplateDataSource)
  // ========================================

  Future<List<Map<String, dynamic>>> getWorkScheduleTemplates(
    String companyId,
  ) =>
      _workScheduleTemplateDataSource.getWorkScheduleTemplates(companyId);

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
  }) =>
      _workScheduleTemplateDataSource.createWorkScheduleTemplate(
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
  }) =>
      _workScheduleTemplateDataSource.updateWorkScheduleTemplate(
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

  Future<Map<String, dynamic>> deleteWorkScheduleTemplate(
    String templateId,
  ) =>
      _workScheduleTemplateDataSource.deleteWorkScheduleTemplate(templateId);
}
