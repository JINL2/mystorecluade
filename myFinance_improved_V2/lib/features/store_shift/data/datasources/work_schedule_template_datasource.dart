import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/exceptions/store_shift_exceptions.dart';

/// Work Schedule Template Data Source
///
/// Handles Supabase operations for work schedule templates
class WorkScheduleTemplateDataSource {
  final SupabaseService _supabaseService;

  WorkScheduleTemplateDataSource(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  /// Get all work schedule templates for a company
  ///
  /// Uses RPC function 'get_work_schedule_templates'
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
