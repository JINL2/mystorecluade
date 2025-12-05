// lib/features/report_control/data/models/report_notification_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/report_notification.dart';

part 'report_notification_dto.freezed.dart';
part 'report_notification_dto.g.dart';

/// Data Transfer Object for ReportNotification
///
/// Maps RPC result from report_get_user_received_reports to domain entity
@freezed
class ReportNotificationDto with _$ReportNotificationDto {
  const factory ReportNotificationDto({
    @JsonKey(name: 'notification_id') required String notificationId,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'body') required String body,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,

    // Report details
    @JsonKey(name: 'report_date') required DateTime reportDate,
    @JsonKey(name: 'session_id') String? sessionId,
    @JsonKey(name: 'template_id') String? templateId,
    @JsonKey(name: 'subscription_id') String? subscriptionId,

    // Template info (nullable - may not exist if template was deleted)
    @JsonKey(name: 'template_name') String? templateName,
    @JsonKey(name: 'template_code') String? templateCode,
    @JsonKey(name: 'template_icon') String? templateIcon,
    @JsonKey(name: 'template_frequency') String? templateFrequency,

    // Category info
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'category_name') String? categoryName,

    // Session status (nullable - may not exist for old reports)
    @JsonKey(name: 'session_status') String? sessionStatus,
    @JsonKey(name: 'session_started_at') DateTime? sessionStartedAt,
    @JsonKey(name: 'session_completed_at') DateTime? sessionCompletedAt,
    @JsonKey(name: 'session_error_message') String? sessionErrorMessage,
    @JsonKey(name: 'processing_time_ms') int? processingTimeMs,

    // Subscription info
    @JsonKey(name: 'subscription_enabled') bool? subscriptionEnabled,
    @JsonKey(name: 'subscription_schedule_time')
    String? subscriptionScheduleTime,
    @JsonKey(name: 'subscription_schedule_days')
    List<int>? subscriptionScheduleDays,

    // Store info
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'store_name') String? storeName,

    // Company info
    @JsonKey(name: 'company_id') String? companyId,
  }) = _ReportNotificationDto;

  const ReportNotificationDto._();

  factory ReportNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$ReportNotificationDtoFromJson(json);

  /// Convert DTO to domain entity
  ///
  /// **중요**: DB의 UTC DateTime을 Local로 변환합니다
  ReportNotification toDomain() {
    return ReportNotification(
      notificationId: notificationId,
      title: title,
      body: body,
      isRead: isRead,
      // ✅ UTC → Local 변환
      sentAt: sentAt != null ? _toLocal(sentAt!) : null,
      createdAt: _toLocal(createdAt),
      reportDate: _toLocal(reportDate),
      sessionId: sessionId ?? '',
      templateId: templateId ?? '',
      subscriptionId: subscriptionId,
      // Provide fallbacks for nullable template fields
      templateName: templateName ?? 'Unknown Report',
      templateCode: templateCode ?? 'unknown',
      templateIcon: templateIcon,
      templateFrequency: templateFrequency ?? 'unknown',
      // Category info
      categoryId: categoryId,
      categoryName: categoryName,
      sessionStatus: sessionStatus ?? 'unknown',
      // ✅ UTC → Local 변환
      sessionStartedAt:
          sessionStartedAt != null ? _toLocal(sessionStartedAt!) : null,
      sessionCompletedAt:
          sessionCompletedAt != null ? _toLocal(sessionCompletedAt!) : null,
      sessionErrorMessage: sessionErrorMessage,
      processingTimeMs: processingTimeMs,
      subscriptionEnabled: subscriptionEnabled,
      subscriptionScheduleTime: subscriptionScheduleTime,
      subscriptionScheduleDays: subscriptionScheduleDays,
      storeId: storeId,
      storeName: storeName,
      companyId: companyId,
    );
  }

  /// Helper: UTC DateTime to Local DateTime
  ///
  /// json_serializable이 UTC string을 DateTime으로 파싱하면 isUtc=true로 설정됨
  /// 하지만 timezone offset은 0이므로 toLocal()로 변환 필요
  static DateTime _toLocal(DateTime utc) {
    return utc.toLocal();
  }
}
