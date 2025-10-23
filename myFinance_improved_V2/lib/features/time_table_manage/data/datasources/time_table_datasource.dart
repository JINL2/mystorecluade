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
        '시프트 메타데이터 조회 실패: $e',
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
        '월별 시프트 상태 조회 실패: $e',
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
        '매니저 오버뷰 조회 실패: $e',
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
        return Map<String, dynamic>.from(response);
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        '매니저 시프트 카드 조회 실패: $e',
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
        '시프트 승인 토글 실패: $e',
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
        '시프트 생성 실패: $e',
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
        '시프트 삭제 실패: $e',
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
        '시프트 태그 삭제 실패: $e',
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
        '스케줄 추가 실패: $e',
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
        '카드 입력 실패: $e',
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
      final response = await _supabase.rpc<dynamic>(
        'get_employees_and_shifts',
        params: {
          'p_store_id': storeId,
          'p_shift_date': shiftDate,
        },
      );

      if (response == null) {
        return {'employees': <dynamic>[], 'shifts': <dynamic>[]};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {'employees': <dynamic>[], 'shifts': <dynamic>[]};
    } catch (e, stackTrace) {
      throw TimeTableException(
        '직원 목록 조회 실패: $e',
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
      final response = await _supabase.rpc<dynamic>(
        'insert_shift_schedule_bulk',
        params: {
          'p_store_id': storeId,
          'p_shift_id': shiftId,
          'p_employee_ids': employeeIds,
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
        '시프트 일정 추가 실패: $e',
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
        '스케줄 데이터 조회 실패: $e',
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
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_process_bulk_approval',
        params: {
          'p_shift_request_ids': shiftRequestIds,
          'p_approval_states': approvalStates,
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
        '일괄 승인 처리 실패: $e',
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
        '시프트 업데이트 실패: $e',
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
        '태그 조회 실패: $e',
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
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_add_bonus',
        params: {
          'p_shift_request_id': shiftRequestId,
          'p_bonus_amount': bonusAmount,
          'p_bonus_reason': bonusReason,
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
        '보너스 추가 실패: $e',
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
        '보너스 업데이트 실패: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
