// lib/features/report_control/domain/repositories/report_repository.dart

import '../entities/report_notification.dart';
import '../entities/report_category.dart';
import '../entities/template_with_subscription.dart';

/// Repository interface for Report Control operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class ReportRepository {
  /// Get user's received reports with full details
  ///
  /// Uses RPC: report_get_user_received_reports
  Future<List<ReportNotification>> getUserReceivedReports({
    required String userId,
    String? companyId,
    int limit = 50,
    int offset = 0,
  });

  /// Get report categories with statistics
  ///
  /// Uses RPC: report_get_categories_with_stats
  Future<List<ReportCategory>> getCategoriesWithStats({
    required String userId,
    required String companyId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get available templates with user subscription status
  ///
  /// Uses RPC: report_get_available_templates_with_status
  Future<List<TemplateWithSubscription>> getAvailableTemplatesWithStatus({
    required String userId,
    required String companyId,
  });

  /// Mark a report as read
  ///
  /// Uses RPC: report_mark_as_read
  Future<bool> markReportAsRead({
    required String notificationId,
    required String userId,
  });

  /// Subscribe to a report template
  ///
  /// Uses RPC: report_subscribe_to_template
  Future<String> subscribeToTemplate({
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
  });

  /// Update subscription settings
  ///
  /// Uses RPC: report_update_subscription
  Future<bool> updateSubscription({
    required String subscriptionId,
    required String userId,
    bool? enabled,
    String? scheduleTime,
    List<int>? scheduleDays,
    int? monthlySendDay,
    String? timezone,
  });

  /// Unsubscribe from a report template
  ///
  /// Uses RPC: report_unsubscribe_from_template
  Future<bool> unsubscribeFromTemplate({
    required String subscriptionId,
    required String userId,
  });

  /// Get report session content (리포트 클릭 시 상세 데이터 가져오기)
  ///
  /// Uses RPC: report_get_session_content
  Future<String> getSessionContent({
    required String sessionId,
    required String userId,
  });
}
