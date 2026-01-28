// lib/features/report_control/presentation/providers/report_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/report_repository.dart';
import 'report_state.dart';

/// Notifier for Report Control state
///
/// Manages received reports and available templates with subscriptions
class ReportNotifier extends StateNotifier<ReportState> {
  final ReportRepository _repository;

  ReportNotifier(this._repository) : super(const ReportState());

  /// Load user's received reports
  ///
  /// Calls RPC: report_get_user_received_reports
  Future<void> loadReceivedReports({
    required String userId,
    String? companyId,
    int limit = 50,
    int offset = 0,
  }) async {
    state = state.copyWith(
      isLoadingReceivedReports: true,
      receivedReportsError: null,
    );

    try {
      final reports = await _repository.getUserReceivedReports(
        userId: userId,
        companyId: companyId,
        limit: limit,
        offset: offset,
      );

      state = state.copyWith(
        receivedReports: reports,
        isLoadingReceivedReports: false,
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoadingReceivedReports: false,
        receivedReportsError: e.toString(),
      );
    }
  }

  /// Load available templates with subscription status
  ///
  /// Calls RPC: report_get_available_templates_with_status
  Future<void> loadAvailableTemplates({
    required String userId,
    required String companyId,
  }) async {
    state = state.copyWith(
      isLoadingTemplates: true,
      templatesError: null,
    );

    try {
      final templates = await _repository.getAvailableTemplatesWithStatus(
        userId: userId,
        companyId: companyId,
      );

      state = state.copyWith(
        availableTemplates: templates,
        isLoadingTemplates: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTemplates: false,
        templatesError: e.toString(),
      );
    }
  }

  /// Load report categories with statistics
  ///
  /// Calls RPC: report_get_categories_with_stats
  Future<void> loadCategories({
    required String userId,
    required String companyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(
      isLoadingCategories: true,
      categoriesError: null,
    );

    try {
      final categories = await _repository.getCategoriesWithStats(
        userId: userId,
        companyId: companyId,
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        categories: categories,
        isLoadingCategories: false,
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoadingCategories: false,
        categoriesError: e.toString(),
      );
    }
  }

  /// Load all data (received reports + available templates + categories)
  Future<void> loadAllData({
    required String userId,
    required String companyId,
  }) async {
    await Future.wait(
      [
        loadReceivedReports(userId: userId, companyId: companyId),
        loadAvailableTemplates(userId: userId, companyId: companyId),
        loadCategories(userId: userId, companyId: companyId),
      ],
      eagerError: false, // ✅ 하나 실패해도 나머지 계속 실행
    );
  }

  /// Mark a report as read
  ///
  /// Calls RPC: report_mark_as_read
  Future<bool> markReportAsRead({
    required String notificationId,
    required String userId,
  }) async {
    try {
      final success = await _repository.markReportAsRead(
        notificationId: notificationId,
        userId: userId,
      );

      if (success) {
        // Update local state
        final updatedReports = state.receivedReports.map((report) {
          if (report.notificationId == notificationId) {
            return report.copyWith(isRead: true);
          }
          return report;
        }).toList();

        state = state.copyWith(receivedReports: updatedReports);
      }

      return success;
    } catch (e) {
      state = state.copyWith(receivedReportsError: e.toString());
      return false;
    }
  }

  /// Subscribe to a template
  ///
  /// Calls RPC: report_subscribe_to_template
  Future<String?> subscribeToTemplate({
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
    state = state.copyWith(isLoadingTemplates: true, templatesError: null);

    try {
      final subscriptionId = await _repository.subscribeToTemplate(
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        templateId: templateId,
        subscriptionName: subscriptionName,
        scheduleTime: scheduleTime,
        scheduleDays: scheduleDays,
        monthlySendDay: monthlySendDay,
        timezone: timezone,
        notificationChannels: notificationChannels,
      );

      // Reload templates to get updated subscription status
      await loadAvailableTemplates(userId: userId, companyId: companyId);

      return subscriptionId;
    } catch (e) {
      state = state.copyWith(
        isLoadingTemplates: false,
        templatesError: e.toString(),
      );
      return null;
    }
  }

  /// Update subscription settings
  ///
  /// Calls RPC: report_update_subscription
  Future<bool> updateSubscription({
    required String subscriptionId,
    required String userId,
    bool? enabled,
    String? scheduleTime,
    List<int>? scheduleDays,
    int? monthlySendDay,
    String? timezone,
  }) async {
    state = state.copyWith(isLoadingTemplates: true, templatesError: null);

    try {
      final success = await _repository.updateSubscription(
        subscriptionId: subscriptionId,
        userId: userId,
        enabled: enabled,
        scheduleTime: scheduleTime,
        scheduleDays: scheduleDays,
        monthlySendDay: monthlySendDay,
        timezone: timezone,
      );

      if (success) {
        // Update local state
        final updatedTemplates = state.availableTemplates.map((template) {
          if (template.subscriptionId == subscriptionId) {
            return template.copyWith(
              subscriptionEnabled: enabled ?? template.subscriptionEnabled,
              subscriptionScheduleTime:
                  scheduleTime ?? template.subscriptionScheduleTime,
              subscriptionScheduleDays:
                  scheduleDays ?? template.subscriptionScheduleDays,
              subscriptionMonthlySendDay:
                  monthlySendDay ?? template.subscriptionMonthlySendDay,
              subscriptionTimezone: timezone ?? template.subscriptionTimezone,
            );
          }
          return template;
        }).toList();

        state = state.copyWith(
          availableTemplates: updatedTemplates,
          isLoadingTemplates: false,
        );
      } else {
        state = state.copyWith(isLoadingTemplates: false);
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoadingTemplates: false,
        templatesError: e.toString(),
      );
      return false;
    }
  }

  /// Unsubscribe from a template
  ///
  /// Calls RPC: report_unsubscribe_from_template
  Future<bool> unsubscribeFromTemplate({
    required String subscriptionId,
    required String userId,
    required String companyId,
  }) async {
    state = state.copyWith(isLoadingTemplates: true, templatesError: null);

    try {
      final success = await _repository.unsubscribeFromTemplate(
        subscriptionId: subscriptionId,
        userId: userId,
      );

      if (success) {
        // Reload templates to get updated subscription status
        await loadAvailableTemplates(userId: userId, companyId: companyId);
      } else {
        state = state.copyWith(isLoadingTemplates: false);
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoadingTemplates: false,
        templatesError: e.toString(),
      );
      return false;
    }
  }

  /// Set selected tab index
  void setSelectedTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  /// Set filter for category
  void setCategoryFilter(String? categoryId) {
    state = state.copyWith(categoryFilter: categoryId);
  }

  /// Toggle show unread only filter
  void toggleShowUnreadOnly() {
    state = state.copyWith(showUnreadOnly: !state.showUnreadOnly);
  }

  /// Set date range filter
  void setDateRangeFilter(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      categoryFilter: null,
      templateFilter: null,
      showUnreadOnly: false,
      startDate: null,
      endDate: null,
    );
  }

  /// Get session content by session_id
  ///
  /// 리포트 클릭 시 호출되어 content를 가져옴
  Future<String> getSessionContent({
    required String sessionId,
  }) async {
    // userId는 현재 로그인한 유저의 ID를 사용해야 함
    // 이 부분은 AuthProvider나 다른 방법으로 가져와야 할 수 있습니다
    // 임시로 여기서는 repository를 직접 호출
    final userId = await _getUserId();

    return await _repository.getSessionContent(
      sessionId: sessionId,
      userId: userId,
    );
  }

  /// Get current user ID from Supabase Auth
  Future<String> _getUserId() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.id;
  }
}
