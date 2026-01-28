import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/time_table_exceptions.dart';

/// Shift Data Source
///
/// Handles Supabase RPC calls for shift metadata, status, approval, and deletion operations.
class ShiftDatasource {
  final SupabaseClient _supabase;

  ShiftDatasource(this._supabase);

  /// Fetch shift metadata from Supabase RPC
  ///
  /// Uses get_shift_metadata_v2_utc RPC with timezone parameter
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  /// - Returns shift times converted to local timezone
  Future<dynamic> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_shift_metadata_v2_utc',
        params: {
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return [];
      }

      // RPC can return List or Map
      return response;
    } catch (e, stackTrace) {
      throw ShiftMetadataException(
        'Failed to fetch shift metadata: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch monthly shift status for manager from Supabase RPC
  ///
  /// Uses get_monthly_shift_status_manager_v4 RPC with timezone parameters
  /// - p_request_time must be user's LOCAL timestamp in "yyyy-MM-dd HH:mm:ss" format
  ///   (no timezone info, local time as-is)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// - Returns shift data based on actual work date (start_time_utc converted to timezone)
  Future<List<dynamic>> getMonthlyShiftStatus({
    required String requestTime,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_monthly_shift_status_manager_v4',
        params: {
          'p_store_id': storeId,
          'p_request_time': requestTime,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return [];
      }

      if (response is List) {
        return response;
      }

      return [];
    } catch (e, stackTrace) {
      throw ShiftStatusException(
        'Failed to fetch monthly shift status: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Toggle shift request approval status using v3 RPC
  ///
  /// Uses toggle_shift_approval_v3 RPC
  /// - Toggles is_approved state (TRUE ↔ FALSE)
  /// - Updates approved_by and updated_at_utc
  /// - No longer recalculates start_time_utc/end_time_utc (already set by insert_shift_request_v6)
  /// - Returns void
  Future<void> toggleShiftApproval({
    required List<String> shiftRequestIds,
    required String userId,
  }) async {
    try {
      await _supabase.rpc<dynamic>(
        'toggle_shift_approval_v3',
        params: {
          'p_shift_request_ids': shiftRequestIds,
          'p_user_id': userId,
        },
      );
    } catch (e, stackTrace) {
      throw ShiftApprovalException(
        'Failed to toggle shift approval: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete a shift tag using v2 RPC
  ///
  /// Uses manager_shift_delete_tag_v2 RPC
  /// - Uses notice_tag_v2 column (not notice_tag)
  /// - Updates updated_at_utc (not updated_at)
  /// - Validates permissions (manager or tag owner)
  /// - Protects special tag types (resolution tags require manager permission)
  Future<Map<String, dynamic>> deleteShiftTag({
    required String tagId,
    required String userId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_delete_tag_v2',
        params: {
          'p_tag_id': tagId,
          'p_user_id': userId,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to delete shift tag: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Process bulk shift approval using toggle_shift_approval_v3
  ///
  /// Uses toggle_shift_approval_v3 RPC
  /// - Toggles approval state for multiple shift requests
  /// - Returns void, so we manually construct the result
  Future<Map<String, dynamic>> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  }) async {
    try {
      // Get current user ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const TimeTableException('User not authenticated');
      }

      // Call toggle_shift_approval_v3 (returns void)
      await _supabase.rpc<dynamic>(
        'toggle_shift_approval_v3',
        params: {
          'p_shift_request_ids': shiftRequestIds,
          'p_user_id': userId,
        },
      );

      // Manually construct success result
      return {
        'total_processed': shiftRequestIds.length,
        'success_count': shiftRequestIds.length,
        'failure_count': 0,
        'successful_ids': shiftRequestIds,
        'errors': <String>[],
      };
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to process bulk approval: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
