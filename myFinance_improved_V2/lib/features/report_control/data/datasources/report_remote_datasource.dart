// lib/features/report_control/data/datasources/report_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_notification_dto.dart';
import '../models/report_category_dto.dart';
import '../models/template_with_subscription_dto.dart';
import '../models/subscription_response_dto.dart';

/// Remote data source for Report operations
///
/// Handles all Supabase RPC function calls for reports
class ReportRemoteDataSource {
  final SupabaseClient _supabase;

  ReportRemoteDataSource(this._supabase);

  /// Call RPC: report_get_user_received_reports
  Future<List<ReportNotificationDto>> getUserReceivedReports({
    required String userId,
    String? companyId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'report_get_user_received_reports',
        params: {
          'p_user_id': userId,
          if (companyId != null) 'p_company_id': companyId,
          'p_limit': limit,
          'p_offset': offset,
        },
      );

      if (response == null) {
        return [];
      }

      if (response is! List) {
        return [];
      }

      final List<dynamic> data = response;

      final reports = <ReportNotificationDto>[];
      int errorCount = 0;

      for (var i = 0; i < data.length; i++) {
        try {
          final item = data[i];
          if (item is! Map<String, dynamic>) {
            errorCount++;
            print('[ReportDataSource] ⚠️  Invalid item type at index $i: ${item.runtimeType}');
            continue;
          }
          reports.add(ReportNotificationDto.fromJson(item));
        } catch (e, stackTrace) {
          errorCount++;
          print('[ReportDataSource] ❌ Error parsing report at index $i: $e');
          print('[ReportDataSource] Stack trace: $stackTrace');
          continue;
        }
      }

      if (errorCount > 0) {
        print('[ReportDataSource] ⚠️  $errorCount items failed to parse out of ${data.length}');
      }

      return reports;
    } catch (e, stackTrace) {
      print('[ReportDataSource] ❌ Error fetching reports: $e');
      print('[ReportDataSource] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Call RPC: report_get_categories_with_stats
  Future<List<ReportCategoryDto>> getCategoriesWithStats({
    required String userId,
    required String companyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'report_get_categories_with_stats',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          if (startDate != null)
            'p_start_date': startDate.toIso8601String().split('T')[0],
          if (endDate != null)
            'p_end_date': endDate.toIso8601String().split('T')[0],
        },
      );

      if (response == null) {
        return [];
      }

      if (response is! List) {
        return [];
      }

      final List<dynamic> data = response;

      final categories = <ReportCategoryDto>[];
      int errorCount = 0;

      for (var i = 0; i < data.length; i++) {
        try {
          final item = data[i];
          if (item is! Map<String, dynamic>) {
            errorCount++;
            print('[ReportDataSource] ⚠️  Invalid category item type at index $i: ${item.runtimeType}');
            continue;
          }
          categories.add(ReportCategoryDto.fromJson(item));
        } catch (e, stackTrace) {
          errorCount++;
          print('[ReportDataSource] ❌ Error parsing category at index $i: $e');
          print('[ReportDataSource] Stack trace: $stackTrace');
          continue;
        }
      }

      if (errorCount > 0) {
        print('[ReportDataSource] ⚠️  $errorCount category items failed to parse out of ${data.length}');
      }

      return categories;
    } catch (e, stackTrace) {
      print('[ReportDataSource] ❌ Error fetching categories: $e');
      print('[ReportDataSource] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Call RPC: report_get_available_templates_with_status
  Future<List<TemplateWithSubscriptionDto>> getAvailableTemplatesWithStatus({
    required String userId,
    required String companyId,
  }) async {
    final response = await _supabase.rpc<List<dynamic>>(
      'report_get_available_templates_with_status',
      params: {
        'p_user_id': userId,
        'p_company_id': companyId,
      },
    );

    if (response == null) return [];

    if (response is! List) return [];

    final List<dynamic> data = response;
    final templates = <TemplateWithSubscriptionDto>[];

    for (var i = 0; i < data.length; i++) {
      try {
        final item = data[i];
        if (item is! Map<String, dynamic>) continue;
        templates.add(TemplateWithSubscriptionDto.fromJson(item));
      } catch (e) {
        continue;
      }
    }

    return templates;
  }

  /// Call RPC: report_mark_as_read
  Future<bool> markReportAsRead({
    required String notificationId,
    required String userId,
  }) async {
    final response = await _supabase.rpc<bool>(
      'report_mark_as_read',
      params: {
        'p_notification_id': notificationId,
        'p_user_id': userId,
      },
    );

    return response == true;
  }

  /// Call RPC: report_subscribe_to_template
  Future<SubscriptionResponseDto?> subscribeToTemplate({
    required String userId,
    required String companyId,
    String? storeId,
    required String templateId,
    String? subscriptionName,
    String? scheduleTime,
    List<int>? scheduleDays,
    int? monthlySendDay,
    String timezone = 'UTC',
    List<String> notificationChannels = const ['push'],
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'report_subscribe_to_template',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id':
              storeId, // ✅ Always include, even if null (company-wide subscription)
          'p_template_id': templateId,
          'p_subscription_name':
              subscriptionName, // ✅ Always include, even if null
          'p_schedule_time': scheduleTime,
          'p_schedule_days': scheduleDays,
          'p_monthly_send_day': monthlySendDay,
          'p_timezone': timezone,
          'p_notification_channels': notificationChannels,
        },
      );

      // ✅ RPC returns TABLE, so response is a List with one row
      if (response == null) {
        return null;
      }

      if (response is List && response.isNotEmpty) {
        final firstRow = response.first as Map<String, dynamic>;
        return SubscriptionResponseDto.fromJson(firstRow);
      } else if (response is Map<String, dynamic>) {
        // Fallback for direct Map response (shouldn't happen with TABLE return type)
        return SubscriptionResponseDto.fromJson(response);
      }

      return null;
    } catch (e) {
      rethrow; // Re-throw to preserve stack trace
    }
  }

  /// Call RPC: report_update_subscription
  Future<bool> updateSubscription({
    required String subscriptionId,
    required String userId,
    bool? enabled,
    String? scheduleTime,
    List<int>? scheduleDays,
    int? monthlySendDay,
    String? timezone,
  }) async {
    try {
      final response = await _supabase.rpc<bool>(
        'report_update_subscription',
        params: {
          'p_subscription_id': subscriptionId,
          'p_user_id': userId,
          if (enabled != null) 'p_enabled': enabled,
          if (scheduleTime != null) 'p_schedule_time': scheduleTime,
          if (scheduleDays != null) 'p_schedule_days': scheduleDays,
          if (monthlySendDay != null) 'p_monthly_send_day': monthlySendDay,
          if (timezone != null) 'p_timezone': timezone,
        },
      );

      return response == true;
    } catch (e) {
      rethrow; // Re-throw to preserve stack trace
    }
  }

  /// Call RPC: report_unsubscribe_from_template
  Future<bool> unsubscribeFromTemplate({
    required String subscriptionId,
    required String userId,
  }) async {
    try {
      final response = await _supabase.rpc<bool>(
        'report_unsubscribe_from_template',
        params: {
          'p_subscription_id': subscriptionId,
          'p_user_id': userId,
        },
      );

      return response == true;
    } catch (e) {
      rethrow; // Re-throw to preserve stack trace
    }
  }
}
