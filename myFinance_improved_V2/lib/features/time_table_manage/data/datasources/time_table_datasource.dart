
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/time_table_exceptions.dart';

/// Time Table Data Source
///
/// Handles all Supabase RPC calls and database queries for time table management.
class TimeTableDatasource {
  final SupabaseClient _supabase;

  TimeTableDatasource(this._supabase);

  /// Fetch shift metadata from Supabase RPC
  Future<dynamic> getShiftMetadata({
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_shift_metadata',
        params: {
          'p_store_id': storeId,
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
  Future<List<dynamic>> getMonthlyShiftStatus({
    required String requestDate,
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_monthly_shift_status_manager',
        params: {
          'p_store_id': storeId,
          'p_request_date': requestDate,
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

  /// Fetch manager overview data from Supabase RPC
  Future<Map<String, dynamic>> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_overview',
        params: {
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': storeId,
          'p_company_id': companyId,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      if (response is List && response.isNotEmpty) {
        return response.first as Map<String, dynamic>;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch manager overview: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch manager shift cards from Supabase RPC
  Future<Map<String, dynamic>> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_cards',
        params: {
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': storeId,
          'p_company_id': companyId,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      // Try to convert to Map if possible
      if (response is Map) {
        final converted = Map<String, dynamic>.from(response);
        return converted;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch manager shift cards: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Toggle shift request approval status
  Future<Map<String, dynamic>> toggleShiftApproval({
    required String shiftRequestId,
    required bool newApprovalState,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'toggle_shift_approval',
        params: {
          'p_shift_request_id': shiftRequestId,
          'p_new_approval_state': newApprovalState,
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
      throw ShiftApprovalException(
        'Failed to toggle shift approval: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Create a new shift
  Future<Map<String, dynamic>> createShift({
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'insert_shift_schedule',
        params: params,
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
    } catch (e, stackTrace) {
      throw ShiftCreationException(
        'Failed to create shift: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete a shift
  Future<void> deleteShift({
    required String shiftId,
  }) async {
    try {
      await _supabase.from('store_shifts').delete().eq('shift_id', shiftId);
    } catch (e, stackTrace) {
      throw ShiftDeletionException(
        'Failed to delete shift: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete a shift tag
  Future<Map<String, dynamic>> deleteShiftTag({
    required String tagId,
    required String userId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_delete_tag',
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

  /// Insert new schedule (assign employee to shift)
  Future<Map<String, dynamic>> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
    required String approvedBy,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_insert_schedule',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_store_id': storeId,
          'p_request_date': requestDate,
          'p_approved_by': approvedBy,
        },
      );

      if (response == null) return {};

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to add schedule: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Input card data (comprehensive shift update with tags)
  Future<Map<String, dynamic>> inputCard({
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
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_input_card',
        params: {
          'p_manager_id': managerId,
          'p_shift_request_id': shiftRequestId,
          'p_confirm_start_time': confirmStartTime,
          'p_confirm_end_time': confirmEndTime,
          'p_new_tag_content': newTagContent,
          'p_new_tag_type': newTagType,
          'p_is_late': isLate,
          'p_is_problem_solved': isProblemSolved,
        },
      );

      if (response == null) return {};

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to input card: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get available employees for shift assignment
  /// Uses manager_shift_get_schedule RPC
  Future<Map<String, dynamic>> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_schedule',
        params: {
          'p_store_id': storeId,
        },
      );

      if (response == null) {
        return {'employees': <dynamic>[], 'shifts': <dynamic>[]};
      }

      if (response is Map<String, dynamic>) {
        // manager_shift_get_schedule returns {store_employees: [], store_shifts: []}
        // Map to expected format {employees: [], shifts: []}
        return {
          'employees': response['store_employees'] ?? <dynamic>[],
          'shifts': response['store_shifts'] ?? <dynamic>[],
        };
      }

      return {'employees': <dynamic>[], 'shifts': <dynamic>[]};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch employee list: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get schedule data (employees and shifts)
  Future<Map<String, dynamic>> getScheduleData({
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_schedule',
        params: {
          'p_store_id': storeId,
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
        'Failed to fetch schedule data: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Process bulk shift approval using toggle_shift_approval
  ///
  /// Note: toggle_shift_approval returns void, so we manually construct the result
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

      // Call toggle_shift_approval (returns void)
      await _supabase.rpc<dynamic>(
        'toggle_shift_approval',
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
        'errors': [],
      };
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to process bulk approval: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Update shift details
  Future<Map<String, dynamic>> updateShift({
    required String shiftRequestId,
    String? startTime,
    String? endTime,
    bool? isProblemSolved,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_update_shift',
        params: {
          'p_shift_request_id': shiftRequestId,
          if (startTime != null) 'p_start_time': startTime,
          if (endTime != null) 'p_end_time': endTime,
          if (isProblemSolved != null) 'p_is_problem_solved': isProblemSolved,
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
        'Failed to update shift: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get tags by card ID
  Future<List<Map<String, dynamic>>> getTagsByCardId({
    required String cardId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_tags_by_card_id',
        params: {
          'p_card_id': cardId,
        },
      );

      if (response == null) {
        return [];
      }

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }

      return [];
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch tags: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Add bonus to shift
  /// Note: manager_shift_add_bonus RPC doesn't exist, using direct DB update instead
  Future<Map<String, dynamic>> addBonus({
    required String shiftRequestId,
    required double bonusAmount,
    required String bonusReason,
  }) async {
    try {
      // Update shift_requests table directly
      await _supabase
          .from('shift_requests')
          .update({
            'bonus_amount': bonusAmount,
            'bonus_reason': bonusReason,
          })
          .eq('shift_request_id', shiftRequestId);

      // Return success result in expected format
      return {
        'success': true,
        'message': 'Bonus added successfully',
        'data': {
          'shift_request_id': shiftRequestId,
          'bonus_amount': bonusAmount,
          'bonus_reason': bonusReason,
        },
      };
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to add bonus: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Update bonus amount for shift request
  Future<void> updateBonusAmount({
    required String shiftRequestId,
    required double bonusAmount,
  }) async {
    try {
      await _supabase
          .from('shift_requests')
          .update({'bonus_amount': bonusAmount})
          .eq('shift_request_id', shiftRequestId);
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to update bonus: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
