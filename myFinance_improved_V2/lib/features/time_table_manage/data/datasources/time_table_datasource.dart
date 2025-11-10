import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/time_table_exceptions.dart';
import '../../presentation/services/time_table_logger.dart';

/// Time Table Data Source
///
/// Handles all Supabase RPC calls and database queries for time table management.
class TimeTableDatasource {
  final SupabaseClient _supabase;

  TimeTableDatasource(this._supabase);

  /// Fetch shift metadata from Supabase RPC
  /// Returns Map<String, dynamic> containing shift metadata
  Future<Map<String, dynamic>> getShiftMetadata({
    required String storeId,
  }) async {
    try {
      final params = {'p_store_id': storeId};
      final response = await _supabase
          .rpc<dynamic>('get_shift_metadata', params: params)
          .logRpc('get_shift_metadata', params);

      if (response == null) {
        return {'shifts': <dynamic>[]};
      }

      // Validate response type
      if (response is Map<String, dynamic>) {
        return response;
      }

      // Handle TABLE response (returns as List)
      if (response is List) {
        return {'shifts': response};
      }

      // Handle unexpected type - FAIL LOUDLY
      throw ShiftMetadataException(
        'RPC returned unexpected type: ${response.runtimeType}. Expected Map<String, dynamic> or List',
        originalError: response,
      );
    } catch (e, stackTrace) {
      if (e is ShiftMetadataException) rethrow;
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
      final params = {
        'p_store_id': storeId,
        'p_request_date': requestDate,
      };
      final response = await _supabase
          .rpc<dynamic>('get_monthly_shift_status_manager', params: params)
          .logRpc('get_monthly_shift_status_manager', params);

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
      final params = {
        'p_start_date': startDate,
        'p_end_date': endDate,
        'p_store_id': storeId,
        'p_company_id': companyId,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_get_overview', params: params)
          .logRpc('manager_shift_get_overview', params);

      if (response == null) {
        TimeTableLogger.logInfo('manager_shift_get_overview returned null');
        return {};
      }

      TimeTableLogger.logInfo('manager_shift_get_overview response type: ${response.runtimeType}');

      if (response is Map<String, dynamic>) {
        TimeTableLogger.logInfo('Response keys: ${response.keys.toList()}');
        return response;
      }

      if (response is List && response.isNotEmpty) {
        TimeTableLogger.logInfo('Response is List with ${response.length} items');
        TimeTableLogger.logInfo('First item: ${response.first}');
        return response.first as Map<String, dynamic>;
      }

      TimeTableLogger.logInfo('manager_shift_get_overview returning empty');
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
      final params = {
        'p_start_date': startDate,
        'p_end_date': endDate,
        'p_store_id': storeId,
        'p_company_id': companyId,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_get_cards', params: params)
          .logRpc('manager_shift_get_cards', params);

      if (response == null) {
        TimeTableLogger.logInfo('manager_shift_get_cards returned null');
        return {};
      }

      TimeTableLogger.logInfo('manager_shift_get_cards response type: ${response.runtimeType}');

      if (response is Map<String, dynamic>) {
        TimeTableLogger.logInfo('Response keys: ${response.keys.toList()}');
        TimeTableLogger.logInfo('Response: $response');
        return response;
      }

      // Handle unexpected type - FAIL LOUDLY
      throw TimeTableException(
        'RPC returned unexpected type: ${response.runtimeType}. Expected Map<String, dynamic>',
        originalError: response,
      );
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
      final params = {
        'p_shift_request_id': shiftRequestId,
        'p_new_approval_state': newApprovalState,
      };
      final response = await _supabase
          .rpc<dynamic>('toggle_shift_approval', params: params)
          .logRpc('toggle_shift_approval', params);

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
      final response = await _supabase
          .rpc<dynamic>('insert_shift_schedule', params: params)
          .logRpc('insert_shift_schedule', params);

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
      final params = {
        'p_tag_id': tagId,
        'p_user_id': userId,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_delete_tag', params: params)
          .logRpc('manager_shift_delete_tag', params);

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
      final params = {
        'p_user_id': userId,
        'p_shift_id': shiftId,
        'p_store_id': storeId,
        'p_request_date': requestDate,
        'p_approved_by': approvedBy,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_insert_schedule', params: params)
          .logRpc('manager_shift_insert_schedule', params);

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
      final params = {
        'p_manager_id': managerId,
        'p_shift_request_id': shiftRequestId,
        'p_confirm_start_time': confirmStartTime,
        'p_confirm_end_time': confirmEndTime,
        'p_new_tag_content': newTagContent,
        'p_new_tag_type': newTagType,
        'p_is_late': isLate,
        'p_is_problem_solved': isProblemSolved,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_input_card', params: params)
          .logRpc('manager_shift_input_card', params);

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
  Future<Map<String, dynamic>> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
  }) async {
    try {
      final params = {
        'p_store_id': storeId,
        'p_shift_date': shiftDate,
      };
      final response = await _supabase
          .rpc<dynamic>('get_employees_and_shifts', params: params)
          .logRpc('get_employees_and_shifts', params);

      if (response == null) {
        return {'employees': <dynamic>[], 'shifts': <dynamic>[]};
      }

      if (response is Map<String, dynamic>) {
        return response;
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

  /// Insert shift schedule for selected employees
  Future<Map<String, dynamic>> insertShiftSchedule({
    required String storeId,
    required String shiftId,
    required List<String> employeeIds,
  }) async {
    try {
      final params = {
        'p_store_id': storeId,
        'p_shift_id': shiftId,
        'p_employee_ids': employeeIds,
      };
      final response = await _supabase
          .rpc<dynamic>('insert_shift_schedule_bulk', params: params)
          .logRpc('insert_shift_schedule_bulk', params);

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to add shift schedule: $e',
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
      final params = {'p_store_id': storeId};
      final response = await _supabase
          .rpc<dynamic>('manager_shift_get_schedule', params: params)
          .logRpc('manager_shift_get_schedule', params);

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

  /// Process bulk shift approval
  Future<Map<String, dynamic>> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  }) async {
    try {
      final params = {
        'p_shift_request_ids': shiftRequestIds,
        'p_approval_states': approvalStates,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_process_bulk_approval', params: params)
          .logRpc('manager_shift_process_bulk_approval', params);

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
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
      final params = {
        'p_shift_request_id': shiftRequestId,
        if (startTime != null) 'p_start_time': startTime,
        if (endTime != null) 'p_end_time': endTime,
        if (isProblemSolved != null) 'p_is_problem_solved': isProblemSolved,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_update_shift', params: params)
          .logRpc('manager_shift_update_shift', params);

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
      final params = {'p_card_id': cardId};
      final response = await _supabase
          .rpc<dynamic>('get_tags_by_card_id', params: params)
          .logRpc('get_tags_by_card_id', params);

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
  Future<Map<String, dynamic>> addBonus({
    required String shiftRequestId,
    required double bonusAmount,
    required String bonusReason,
  }) async {
    try {
      final params = {
        'p_shift_request_id': shiftRequestId,
        'p_bonus_amount': bonusAmount,
        'p_bonus_reason': bonusReason,
      };
      final response = await _supabase
          .rpc<dynamic>('manager_shift_add_bonus', params: params)
          .logRpc('manager_shift_add_bonus', params);

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
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
