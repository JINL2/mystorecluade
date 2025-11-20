// lib/features/report_control/presentation/providers/report_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/report_category.dart';
import '../../domain/entities/report_notification.dart';
import '../../domain/entities/template_with_subscription.dart';

part 'report_state.freezed.dart';

/// State for Report Control feature
///
/// Manages two main data sets:
/// 1. receivedReports: Reports that the user has received (from notifications)
/// 2. availableTemplates: Available templates with subscription status
@freezed
class ReportState with _$ReportState {
  const factory ReportState({
    // Received reports tab data
    @Default([]) List<ReportNotification> receivedReports,
    @Default(false) bool isLoadingReceivedReports,
    String? receivedReportsError,

    // Available templates tab data
    @Default([]) List<TemplateWithSubscription> availableTemplates,
    @Default(false) bool isLoadingTemplates,
    String? templatesError,

    // Categories data
    @Default([]) List<ReportCategory> categories,
    @Default(false) bool isLoadingCategories,
    String? categoriesError,

    // Selected tab index
    @Default(0) int selectedTabIndex,

    // Filters for received reports
    @Default(null) String? categoryFilter, // Filter by category_id
    @Default(null) String? templateFilter, // Filter by template_id
    @Default(false) bool showUnreadOnly,
    DateTime? startDate, // Date range filter start
    DateTime? endDate, // Date range filter end
  }) = _ReportState;

  const ReportState._();

  /// Check if user is subscribed to a specific template
  bool isSubscribedTo(String templateId) {
    return availableTemplates.any(
        (template) => template.templateId == templateId && template.isActive);
  }

  /// Get template with subscription for a specific template
  TemplateWithSubscription? getTemplate(String templateId) {
    for (final template in availableTemplates) {
      if (template.templateId == templateId) {
        return template;
      }
    }
    return null;
  }

  /// Get filtered received reports based on current filters
  /// Optimized to O(n) with single-pass filtering
  List<ReportNotification> get filteredReceivedReports {
    if (!hasActiveFilters) return receivedReports;

    return receivedReports.where((report) {
      // Filter by read status
      if (showUnreadOnly && report.isRead) return false;

      // Filter by category
      if (categoryFilter != null && report.categoryId != categoryFilter) {
        return false;
      }

      // Filter by template
      if (templateFilter != null && report.templateId != templateFilter) {
        return false;
      }

      // Filter by date range
      if (startDate != null &&
          (report.reportDate == null ||
              report.reportDate!.isBefore(startDate!))) {
        return false;
      }
      if (endDate != null &&
          (report.reportDate == null || report.reportDate!.isAfter(endDate!))) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get count of unread reports
  int get unreadCount {
    return receivedReports.where((report) => !report.isRead).length;
  }

  /// Get subscribed templates only
  List<TemplateWithSubscription> get subscribedTemplates {
    return availableTemplates.where((t) => t.isSubscribed).toList();
  }

  /// Get non-subscribed templates only
  List<TemplateWithSubscription> get nonSubscribedTemplates {
    return availableTemplates.where((t) => !t.isSubscribed).toList();
  }

  /// Check if any data is loading
  bool get isLoading =>
      isLoadingReceivedReports || isLoadingTemplates || isLoadingCategories;

  /// Get combined error message
  String? get errorMessage {
    if (receivedReportsError != null) return receivedReportsError;
    if (templatesError != null) return templatesError;
    if (categoriesError != null) return categoriesError;
    return null;
  }

  /// Check if any filter is active
  bool get hasActiveFilters {
    return categoryFilter != null ||
        templateFilter != null ||
        showUnreadOnly ||
        startDate != null ||
        endDate != null;
  }
}
