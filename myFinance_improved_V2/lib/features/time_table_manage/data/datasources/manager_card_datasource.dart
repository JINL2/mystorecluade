import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/time_table_exceptions.dart';

/// Manager Card Data Source
///
/// Handles Supabase RPC calls for manager-specific operations:
/// - Manager overview and shift cards
/// - Input card (manager updates shift)
class ManagerCardDatasource {
  final SupabaseClient _supabase;

  ManagerCardDatasource(this._supabase);

  /// Fetch manager overview data from Supabase RPC
  ///
  /// Uses manager_shift_get_overview_v3 RPC with timezone parameter
  /// - p_start_date and p_end_date are user's local dates (yyyy-MM-dd)
  /// - p_store_id is optional (NULL for all stores)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// - Filters by start_time_utc converted to timezone (actual work date)
  Future<Map<String, dynamic>> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_overview_v3',
        params: {
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': storeId,
          'p_company_id': companyId,
          'p_timezone': timezone,
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
  ///
  /// Uses manager_shift_get_cards_v6 RPC with timezone parameter
  /// - p_company_id is the company UUID
  /// - p_start_date and p_end_date are user's local dates (yyyy-MM-dd)
  /// - p_store_id is optional (NULL for all stores)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// - Filters by start_time_utc converted to timezone (actual work date)
  /// - v6: problem_details is Single Source of Truth (removed legacy problem columns)
  Future<Map<String, dynamic>> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_cards_v6',
        params: {
          'p_company_id': companyId,
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': storeId,
          'p_timezone': timezone,
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

  /// Input card data (manager updates shift) using v5 RPC
  ///
  /// Uses manager_shift_input_card_v5 RPC
  /// - Simplified parameters: confirm times, report solved status, bonus amount, manager memo
  /// - Times must be in user's LOCAL timezone (HH:mm:ss format with timezone)
  /// - RPC converts local times to UTC internally
  /// - Returns simple success/error response
  ///
  /// Parameters:
  /// - [managerId] - Manager user ID performing the update
  /// - [shiftRequestId] - Shift request ID to update
  /// - [confirmStartTime] - Confirmed start time (HH:mm:ss format), null to keep existing
  /// - [confirmEndTime] - Confirmed end time (HH:mm:ss format), null to keep existing
  /// - [isProblemSolved] - Problem solved status (for Late/Overtime), null to keep existing
  /// - [isReportedSolved] - Report solved status (for employee reports), null to keep existing
  /// - [bonusAmount] - Bonus amount, null to keep existing
  /// - [managerMemo] - Manager memo text, null to keep existing (new in v5)
  /// - [timezone] - User's local timezone (e.g., "Asia/Ho_Chi_Minh")
  Future<Map<String, dynamic>> inputCardV5({
    required String managerId,
    required String shiftRequestId,
    String? confirmStartTime,
    String? confirmEndTime,
    bool? isProblemSolved,
    bool? isReportedSolved,
    double? bonusAmount,
    String? managerMemo,
    required String timezone,
  }) async {
    try {
      final rpcParams = {
        'p_manager_id': managerId,
        'p_shift_request_id': shiftRequestId,
        'p_confirm_start_time': confirmStartTime,
        'p_confirm_end_time': confirmEndTime,
        'p_is_problem_solved': isProblemSolved,
        'p_is_reported_solved': isReportedSolved,
        'p_bonus_amount': bonusAmount,
        'p_manager_memo': managerMemo,
        'p_timezone': timezone,
      };

      final response = await _supabase.rpc<dynamic>(
        'manager_shift_input_card_v5',
        params: rpcParams,
      );

      if (response == null) {
        return {'success': false, 'error': 'NULL_RESPONSE', 'message': 'No response from server'};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {'success': false, 'error': 'INVALID_RESPONSE', 'message': 'Invalid response format'};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to input card v5: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
