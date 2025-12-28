import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/store_shift_exceptions.dart';

/// Store Shift Data Source
///
/// Handles all Supabase database operations for store shifts.
/// This layer is responsible for:
/// - Direct Supabase client calls
/// - RPC function calls
/// - Table queries (INSERT, UPDATE, DELETE, SELECT)
/// - Error handling and exception throwing
class StoreShiftDataSource {
  final SupabaseService _supabaseService;

  StoreShiftDataSource(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  /// Fetch all shifts for a specific store with employee count
  ///
  /// Uses RPC function 'get_shift_metadata_with_employee_count'
  /// Parameters:
  /// - p_store_id: uuid (required)
  /// - p_timezone: text (IANA timezone, e.g., 'Asia/Seoul')
  ///
  /// Returns shifts with time converted to user's local timezone and employee count
  Future<List<Map<String, dynamic>>> getShiftsByStoreId(String storeId) async {
    try {
      // Get IANA timezone name (e.g., 'Asia/Seoul', 'Asia/Ho_Chi_Minh')
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<List<dynamic>>(
        'get_shift_metadata_with_employee_count',
        params: {
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      throw ShiftNotFoundException(
        'Failed to fetch shifts for store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Create a new shift
  ///
  /// Uses RPC function 'create_store_shift'
  /// Parameters:
  /// - p_store_id: uuid (required)
  /// - p_shift_name: text (required)
  /// - p_start_time: text (local time, HH:mm format)
  /// - p_end_time: text (local time, HH:mm format)
  /// - p_number_shift: integer (optional, default: 1)
  /// - p_is_can_overtime: boolean (optional, default: true)
  /// - p_shift_bonus: numeric (optional, default: 0)
  /// - p_time: text (local timestamp, 'yyyy-MM-dd HH:mm:ss')
  /// - p_timezone: text (IANA timezone, e.g., 'Asia/Seoul')
  Future<Map<String, dynamic>> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    try {
      // Get current local time and timezone using DateTimeUtils
      final localTime = DateTimeUtils.formatLocalTimestamp();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'create_store_shift',
        params: {
          'p_store_id': storeId,
          'p_shift_name': shiftName,
          'p_start_time': startTime,
          'p_end_time': endTime,
          'p_number_shift': numberShift,
          'p_is_can_overtime': isCanOvertime,
          'p_shift_bonus': shiftBonus,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      // Check RPC response for success
      if (response['success'] == false) {
        throw ShiftCreationException(
          response['message'] as String? ?? 'Unknown error',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is ShiftCreationException) rethrow;

      throw ShiftCreationException(
        'Failed to create shift: $e',
        stackTrace,
      );
    }
  }

  /// Update an existing shift
  ///
  /// Uses RPC function 'edit_store_shift'
  /// Parameters:
  /// - p_shift_id: uuid (required)
  /// - p_shift_name: text (optional)
  /// - p_start_time: text (local time, HH:mm format)
  /// - p_end_time: text (local time, HH:mm format)
  /// - p_number_shift: integer (optional, required employees)
  /// - p_is_can_overtime: boolean (optional)
  /// - p_shift_bonus: numeric (optional)
  /// - p_time: text (local timestamp, 'yyyy-MM-dd HH:mm:ss')
  /// - p_timezone: text (IANA timezone, e.g., 'Asia/Seoul')
  Future<Map<String, dynamic>> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    try {
      // Get current local time and timezone using DateTimeUtils
      final localTime = DateTimeUtils.formatLocalTimestamp();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'edit_store_shift',
        params: {
          'p_shift_id': shiftId,
          'p_shift_name': shiftName,
          'p_start_time': startTime,
          'p_end_time': endTime,
          'p_number_shift': numberShift,
          'p_is_can_overtime': isCanOvertime,
          'p_shift_bonus': shiftBonus,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      // Check RPC response for success
      if (response['success'] == false) {
        throw ShiftUpdateException(
          response['message'] as String? ?? 'Unknown error',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is ShiftUpdateException) rethrow;

      throw ShiftUpdateException(
        'Failed to update shift $shiftId: $e',
        stackTrace,
      );
    }
  }

  /// Delete a shift (soft delete)
  ///
  /// Sets is_active to false instead of hard delete
  Future<void> deleteShift(String shiftId) async {
    try {
      await _client
          .from('store_shifts')
          .update({'is_active': false})
          .eq('shift_id', shiftId);
    } catch (e, stackTrace) {
      throw ShiftDeletionException(
        'Failed to delete shift $shiftId: $e',
        stackTrace,
      );
    }
  }

  /// Get detailed store information by ID
  ///
  /// Uses direct table query on 'stores'
  Future<Map<String, dynamic>> getStoreById(String storeId) async {
    try {
      final response = await _client
          .from('stores')
          .select()
          .eq('store_id', storeId)
          .single();

      return response;
    } catch (e, stackTrace) {
      throw StoreNotFoundException(
        'Failed to fetch store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Update store location
  ///
  /// Uses RPC function 'update_store_location'
  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      await _client.rpc<void>('update_store_location', params: {
        'p_store_id': storeId,
        'p_latitude': latitude,
        'p_longitude': longitude,
        'p_address': address,
      },);
    } catch (e, stackTrace) {
      throw StoreLocationUpdateException(
        'Failed to update store location: $e',
        stackTrace,
      );
    }
  }

  /// Update operational settings
  ///
  /// Uses RPC function 'update_store_setting'
  /// Parameters:
  /// - p_store_id: uuid (required)
  /// - p_huddle_time: integer (optional)
  /// - p_payment_time: integer (optional)
  /// - p_allowed_distance: integer (optional)
  /// - p_time: text (local time, e.g., '2025-11-26 16:30:00')
  /// - p_timezone: text (e.g., 'Asia/Ho_Chi_Minh')
  Future<void> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    try {
      // Get current local time and timezone using DateTimeUtils
      final localTime = DateTimeUtils.formatLocalTimestamp();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'update_store_setting',
        params: {
          'p_store_id': storeId,
          'p_huddle_time': huddleTime,
          'p_payment_time': paymentTime,
          'p_allowed_distance': allowedDistance,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      // Check RPC response for success
      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Unknown error');
      }
    } catch (e, stackTrace) {
      throw StoreLocationUpdateException(
        'Failed to update operational settings: $e',
        stackTrace,
      );
    }
  }

  /// ========================================
  /// Business Hours Operations
  /// ========================================

  /// Get business hours for a store
  ///
  /// Uses RPC function 'get_store_business_hours'
  /// Parameters:
  /// - p_store_id: uuid (required)
  ///
  /// Returns list of business hours for each day of the week
  Future<List<Map<String, dynamic>>> getBusinessHours(String storeId) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_store_business_hours',
        params: {
          'p_store_id': storeId,
        },
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      throw StoreNotFoundException(
        'Failed to fetch business hours for store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Upsert business hours for a store
  ///
  /// Uses RPC function 'upsert_store_business_hours'
  /// Parameters:
  /// - p_store_id: uuid (required)
  /// - p_hours: jsonb array of business hours
  ///
  /// Example hours array:
  /// [
  ///   {"day_of_week": 1, "is_open": true, "open_time": "09:00", "close_time": "22:00"},
  ///   {"day_of_week": 0, "is_open": false, "open_time": null, "close_time": null}
  /// ]
  Future<bool> upsertBusinessHours({
    required String storeId,
    required List<Map<String, dynamic>> hours,
  }) async {
    try {
      final response = await _client.rpc<bool>(
        'upsert_store_business_hours',
        params: {
          'p_store_id': storeId,
          'p_hours': hours,
        },
      );

      return response;
    } catch (e, stackTrace) {
      throw StoreLocationUpdateException(
        'Failed to update business hours: $e',
        stackTrace,
      );
    }
  }

  /// ========================================
  /// Work Schedule Template Operations
  /// ========================================

  /// Get all work schedule templates for a company
  ///
  /// Uses RPC function 'get_work_schedule_templates'
  /// Parameters:
  /// - p_company_id: uuid (required)
  ///
  /// Returns templates with employee count
  Future<List<Map<String, dynamic>>> getWorkScheduleTemplates(
    String companyId,
  ) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_work_schedule_templates',
        params: {
          'p_company_id': companyId,
        },
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      throw StoreNotFoundException(
        'Failed to fetch work schedule templates: $e',
        stackTrace,
      );
    }
  }

  /// Create a new work schedule template
  ///
  /// Uses RPC function 'create_work_schedule_template'
  /// Returns JSONB with success status and template_id
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
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'create_work_schedule_template',
        params: {
          'p_company_id': companyId,
          'p_template_name': templateName,
          'p_work_start_time': workStartTime,
          'p_work_end_time': workEndTime,
          'p_monday': monday,
          'p_tuesday': tuesday,
          'p_wednesday': wednesday,
          'p_thursday': thursday,
          'p_friday': friday,
          'p_saturday': saturday,
          'p_sunday': sunday,
          'p_is_default': isDefault,
        },
      );

      if (response['success'] == false) {
        throw ShiftCreationException(
          response['message'] as String? ?? 'Failed to create template',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is ShiftCreationException) rethrow;

      throw ShiftCreationException(
        'Failed to create work schedule template: $e',
        stackTrace,
      );
    }
  }

  /// Update an existing work schedule template
  ///
  /// Uses RPC function 'update_work_schedule_template'
  /// Only non-null parameters will be updated
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
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'update_work_schedule_template',
        params: {
          'p_template_id': templateId,
          'p_template_name': templateName,
          'p_work_start_time': workStartTime,
          'p_work_end_time': workEndTime,
          'p_monday': monday,
          'p_tuesday': tuesday,
          'p_wednesday': wednesday,
          'p_thursday': thursday,
          'p_friday': friday,
          'p_saturday': saturday,
          'p_sunday': sunday,
          'p_is_default': isDefault,
        },
      );

      if (response['success'] == false) {
        throw ShiftUpdateException(
          response['message'] as String? ?? 'Failed to update template',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is ShiftUpdateException) rethrow;

      throw ShiftUpdateException(
        'Failed to update work schedule template: $e',
        stackTrace,
      );
    }
  }

  /// Delete a work schedule template
  ///
  /// Uses RPC function 'delete_work_schedule_template'
  /// Will fail if any employees are assigned to this template
  Future<Map<String, dynamic>> deleteWorkScheduleTemplate(
    String templateId,
  ) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'delete_work_schedule_template',
        params: {
          'p_template_id': templateId,
        },
      );

      if (response['success'] == false) {
        throw ShiftDeletionException(
          response['message'] as String? ?? 'Failed to delete template',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is ShiftDeletionException) rethrow;

      throw ShiftDeletionException(
        'Failed to delete work schedule template: $e',
        stackTrace,
      );
    }
  }
}
