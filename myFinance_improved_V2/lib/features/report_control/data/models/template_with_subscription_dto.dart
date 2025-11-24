// lib/features/report_control/data/models/template_with_subscription_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/template_with_subscription.dart';

part 'template_with_subscription_dto.freezed.dart';
part 'template_with_subscription_dto.g.dart';

/// Data Transfer Object for TemplateWithSubscription
///
/// Maps RPC result from report_get_available_templates_with_status to domain entity
@freezed
class TemplateWithSubscriptionDto with _$TemplateWithSubscriptionDto {
  const factory TemplateWithSubscriptionDto({
    // Template fields
    @JsonKey(name: 'template_id') required String templateId,
    @JsonKey(name: 'template_name') required String templateName,
    @JsonKey(name: 'template_code') required String templateCode,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'frequency') required String frequency,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'display_order') int? displayOrder,
    @JsonKey(name: 'default_schedule_time') String? defaultScheduleTime,
    @JsonKey(name: 'default_schedule_days') List<int>? defaultScheduleDays,
    @JsonKey(name: 'default_monthly_day') int? defaultMonthlyDay,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,

    // Subscription status
    @JsonKey(name: 'is_subscribed') required bool isSubscribed,
    @JsonKey(name: 'subscription_id') String? subscriptionId,
    @JsonKey(name: 'subscription_enabled') bool? subscriptionEnabled,
    @JsonKey(name: 'subscription_schedule_time')
    String? subscriptionScheduleTime,
    @JsonKey(name: 'subscription_schedule_days')
    List<int>? subscriptionScheduleDays,
    @JsonKey(name: 'subscription_monthly_send_day')
    int? subscriptionMonthlySendDay,
    @JsonKey(name: 'subscription_timezone') String? subscriptionTimezone,
    @JsonKey(name: 'subscription_last_sent_at')
    DateTime? subscriptionLastSentAt,
    @JsonKey(name: 'subscription_next_scheduled_at')
    DateTime? subscriptionNextScheduledAt,
    @JsonKey(name: 'subscription_created_at') DateTime? subscriptionCreatedAt,

    // Store info
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'store_name') String? storeName,

    // Recent stats
    @JsonKey(name: 'recent_reports_count') @Default(0) int recentReportsCount,
    @JsonKey(name: 'last_report_date') DateTime? lastReportDate,
    @JsonKey(name: 'last_report_status') String? lastReportStatus,
  }) = _TemplateWithSubscriptionDto;

  const TemplateWithSubscriptionDto._();

  factory TemplateWithSubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$TemplateWithSubscriptionDtoFromJson(json);

  /// Convert DTO to domain entity
  ///
  /// **중요**: DB의 UTC DateTime을 Local로 변환합니다
  TemplateWithSubscription toDomain() {
    return TemplateWithSubscription(
      templateId: templateId,
      templateName: templateName,
      templateCode: templateCode,
      description: description,
      frequency: frequency,
      icon: icon,
      displayOrder: displayOrder,
      defaultScheduleTime: defaultScheduleTime,
      defaultScheduleDays: defaultScheduleDays,
      defaultMonthlyDay: defaultMonthlyDay,
      categoryId: categoryId,
      categoryName: categoryName,
      isSubscribed: isSubscribed,
      subscriptionId: subscriptionId,
      subscriptionEnabled: subscriptionEnabled,
      subscriptionScheduleTime: subscriptionScheduleTime,
      subscriptionScheduleDays: subscriptionScheduleDays,
      subscriptionMonthlySendDay: subscriptionMonthlySendDay,
      subscriptionTimezone: subscriptionTimezone,
      // ✅ UTC → Local 변환
      subscriptionLastSentAt: subscriptionLastSentAt != null
          ? _toLocal(subscriptionLastSentAt!)
          : null,
      subscriptionNextScheduledAt: subscriptionNextScheduledAt != null
          ? _toLocal(subscriptionNextScheduledAt!)
          : null,
      subscriptionCreatedAt: subscriptionCreatedAt != null
          ? _toLocal(subscriptionCreatedAt!)
          : null,
      storeId: storeId,
      storeName: storeName,
      recentReportsCount: recentReportsCount,
      // ✅ UTC → Local 변환
      lastReportDate: lastReportDate != null ? _toLocal(lastReportDate!) : null,
      lastReportStatus: lastReportStatus,
    );
  }

  /// Helper: UTC DateTime to Local DateTime
  static DateTime _toLocal(DateTime utc) {
    return utc.toLocal();
  }
}
