// lib/features/report_control/domain/entities/template_with_subscription.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_with_subscription.freezed.dart';

/// Domain entity combining template and subscription status
///
/// Used in "Subscribe to Reports" tab to show which templates are subscribed
@freezed
class TemplateWithSubscription with _$TemplateWithSubscription {
  const factory TemplateWithSubscription({
    // Template fields
    required String templateId,
    required String templateName,
    required String templateCode,
    String? description,
    required String frequency,
    String? icon,
    int? displayOrder,
    String? defaultScheduleTime,
    List<int>? defaultScheduleDays,
    int? defaultMonthlyDay,
    String? categoryId,
    String? categoryName,

    // Subscription status
    required bool isSubscribed, // KEY FIELD: whether user is subscribed
    String? subscriptionId,
    bool? subscriptionEnabled,
    String? subscriptionScheduleTime,
    List<int>? subscriptionScheduleDays,
    int? subscriptionMonthlySendDay,
    String? subscriptionTimezone,
    DateTime? subscriptionLastSentAt,
    DateTime? subscriptionNextScheduledAt,
    DateTime? subscriptionCreatedAt,

    // Store info (if subscription is store-specific)
    String? storeId,
    String? storeName,

    // Recent stats (last 30 days)
    @Default(0) int recentReportsCount,
    DateTime? lastReportDate,
    String? lastReportStatus,
  }) = _TemplateWithSubscription;

  const TemplateWithSubscription._();

  /// Check if subscription is active (subscribed AND enabled)
  bool get isActive => isSubscribed && (subscriptionEnabled ?? false);
}
