import '../entities/business_hours.dart';
import '../entities/store_shift.dart';
import '../entities/work_schedule_template.dart';

/// Store Shift Repository Interface
///
/// Defines the contract for store shift data operations.
/// This is an abstraction that allows the domain layer to remain
/// independent of data layer implementation details.
abstract class StoreShiftRepository {
  /// Fetch all shifts for a specific store
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  ///
  /// Returns a list of [StoreShift] entities
  /// Throws an exception if the operation fails
  Future<List<StoreShift>> getShiftsByStoreId(String storeId);

  /// Create a new shift
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [shiftName]: Name of the shift
  /// - [startTime]: Start time in HH:mm format (local time)
  /// - [endTime]: End time in HH:mm format (local time)
  /// - [numberShift]: Required number of employees (optional, default: 1)
  /// - [isCanOvertime]: Whether overtime is allowed (optional, default: true)
  /// - [shiftBonus]: Bonus amount for this shift (optional, default: 0)
  ///
  /// Returns the created [StoreShift] entity
  /// Throws an exception if the operation fails
  Future<StoreShift> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  });

  /// Update an existing shift
  ///
  /// Parameters:
  /// - [shiftId]: The ID of the shift to update
  /// - [shiftName]: Updated name (optional)
  /// - [startTime]: Updated start time (optional)
  /// - [endTime]: Updated end time (optional)
  /// - [numberShift]: Required number of employees (optional)
  /// - [isCanOvertime]: Whether overtime is allowed (optional)
  /// - [shiftBonus]: Updated bonus amount (optional)
  ///
  /// Returns the updated [StoreShift] entity
  /// Throws an exception if the operation fails
  Future<StoreShift> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  });

  /// Delete a shift (soft delete by setting is_active to false)
  ///
  /// Parameters:
  /// - [shiftId]: The ID of the shift to delete
  ///
  /// Throws an exception if the operation fails
  Future<void> deleteShift(String shiftId);

  /// Get detailed store information by ID
  ///
  /// Uses RPC function 'get_store_info_v2' to fetch store with latitude/longitude
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [companyId]: The ID of the company
  ///
  /// Returns a Map containing store details
  /// Throws an exception if the operation fails
  Future<Map<String, dynamic>> getStoreById({
    required String storeId,
    required String companyId,
  });

  /// Update store location
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [latitude]: Latitude coordinate
  /// - [longitude]: Longitude coordinate
  /// - [address]: Store address
  ///
  /// Throws an exception if the operation fails
  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  });

  /// Update operational settings
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [huddleTime]: Huddle time in minutes (optional)
  /// - [paymentTime]: Payment time in minutes (optional)
  /// - [allowedDistance]: Check-in distance in meters (optional)
  ///
  /// Throws an exception if the operation fails
  Future<void> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  });

  /// Update store information
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [storeName]: Store name (optional)
  /// - [storeEmail]: Store email (optional)
  /// - [storePhone]: Store phone number (optional)
  /// - [storeAddress]: Store address (optional)
  ///
  /// Throws an exception if the operation fails
  Future<void> updateStoreInfo({
    required String storeId,
    String? storeName,
    String? storeEmail,
    String? storePhone,
    String? storeAddress,
  });

  /// ========================================
  /// Business Hours Operations
  /// ========================================

  /// Get business hours for a store
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  ///
  /// Returns a list of [BusinessHours] for each day of the week
  /// Returns empty list if no hours configured
  /// Throws an exception if the operation fails
  Future<List<BusinessHours>> getBusinessHours(String storeId);

  /// Update business hours for a store
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [hours]: List of [BusinessHours] to upsert
  ///
  /// Returns true if successful
  /// Throws an exception if the operation fails
  Future<bool> updateBusinessHours({
    required String storeId,
    required List<BusinessHours> hours,
  });

  /// ========================================
  /// Work Schedule Template Operations (Company-level)
  /// ========================================

  /// Get all work schedule templates for a company
  ///
  /// Parameters:
  /// - [companyId]: The ID of the company
  ///
  /// Returns a list of [WorkScheduleTemplate] entities
  /// Throws an exception if the operation fails
  Future<List<WorkScheduleTemplate>> getWorkScheduleTemplates(String companyId);

  /// Create a new work schedule template
  ///
  /// Parameters:
  /// - [companyId]: The ID of the company
  /// - [templateName]: Name of the template
  /// - [workStartTime]: Start time in HH:mm format
  /// - [workEndTime]: End time in HH:mm format
  /// - [monday] - [sunday]: Working days
  /// - [isDefault]: Whether this is the default template
  ///
  /// Returns a Map with success status and template_id
  /// Throws an exception if the operation fails
  Future<Map<String, dynamic>> createWorkScheduleTemplate({
    required String companyId,
    required String templateName,
    String workStartTime,
    String workEndTime,
    bool monday,
    bool tuesday,
    bool wednesday,
    bool thursday,
    bool friday,
    bool saturday,
    bool sunday,
    bool isDefault,
  });

  /// Update an existing work schedule template
  ///
  /// Parameters:
  /// - [templateId]: The ID of the template to update
  /// - Other parameters are optional and only non-null values will be updated
  ///
  /// Returns a Map with success status
  /// Throws an exception if the operation fails
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
  });

  /// Delete a work schedule template
  ///
  /// Parameters:
  /// - [templateId]: The ID of the template to delete
  ///
  /// Returns a Map with success status
  /// Will fail if any employees are assigned to this template
  /// Throws an exception if the operation fails
  Future<Map<String, dynamic>> deleteWorkScheduleTemplate(String templateId);
}
