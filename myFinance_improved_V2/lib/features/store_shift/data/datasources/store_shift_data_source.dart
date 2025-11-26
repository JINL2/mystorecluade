import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
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

  /// Fetch all shifts for a specific store
  ///
  /// Uses direct table query on 'store_shifts'
  /// Filters: store_id, is_active = true
  /// Order: start_time ascending
  ///
  /// Note: created_at and updated_at are fetched as UTC and will be
  /// converted to local time in the model layer using DateTimeUtils.toLocal()
  Future<List<Map<String, dynamic>>> getShiftsByStoreId(String storeId) async {
    try {
      final response = await _client
          .from('store_shifts')
          .select('shift_id, shift_name, start_time, end_time, shift_bonus, is_active, created_at, updated_at')
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('start_time', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e, stackTrace) {
      throw ShiftNotFoundException(
        'Failed to fetch shifts for store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Create a new shift
  ///
  /// Uses INSERT on 'store_shifts' table
  Future<Map<String, dynamic>> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    required int shiftBonus,
  }) async {
    try {
      final insertData = {
        'store_id': storeId,
        'shift_name': shiftName,
        'start_time': startTime,
        'end_time': endTime,
        'shift_bonus': shiftBonus,
        'is_active': true,
      };

      final response = await _client
          .from('store_shifts')
          .insert(insertData)
          .select()
          .single();

      return response;
    } catch (e, stackTrace) {
      throw ShiftCreationException(
        'Failed to create shift: $e',
        stackTrace,
      );
    }
  }

  /// Update an existing shift
  ///
  /// Uses UPDATE on 'store_shifts' table
  Future<Map<String, dynamic>> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? shiftBonus,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (shiftName != null) updateData['shift_name'] = shiftName;
      if (startTime != null) updateData['start_time'] = startTime;
      if (endTime != null) updateData['end_time'] = endTime;
      if (shiftBonus != null) updateData['shift_bonus'] = shiftBonus;

      if (updateData.isEmpty) {
        throw const InvalidShiftDataException('No fields to update');
      }

      final response = await _client
          .from('store_shifts')
          .update(updateData)
          .eq('shift_id', shiftId)
          .select()
          .single();

      return response;
    } catch (e, stackTrace) {
      if (e is InvalidShiftDataException) rethrow;

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
  /// Parameters: p_store_id, p_store_lat, p_store_lng
  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _client.rpc<void>('update_store_location', params: {
        'p_store_id': storeId,
        'p_store_lat': latitude,
        'p_store_lng': longitude,
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
  /// Returns JSON response with success status and message
  Future<Map<String, dynamic>> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
    String? localTime,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    try {
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

      if (response['success'] != true) {
        throw OperationalSettingsUpdateException(
          response['message'] as String? ?? 'Unknown error',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is OperationalSettingsUpdateException) rethrow;

      throw OperationalSettingsUpdateException(
        'Failed to update operational settings: $e',
        stackTrace,
      );
    }
  }
}
