// lib/features/report_control/domain/entities/report_notification.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_notification.freezed.dart';

/// Domain entity representing a received report notification
///
/// Maps to `notifications` table where category = 'report'
@freezed
class ReportNotification with _$ReportNotification {
  const factory ReportNotification({
    required String notificationId,
    required String title,
    required String body, // Full report content in markdown
    required bool isRead,
    DateTime? sentAt,
    required DateTime createdAt,

    // Report details
    required DateTime reportDate,
    required String sessionId,
    required String templateId,
    String? subscriptionId,

    // Template info
    required String templateName,
    required String templateCode,
    String? templateIcon,
    required String templateFrequency,

    // Category info
    String? categoryId,
    String? categoryName,

    // Session status
    required String
        sessionStatus, // 'pending', 'processing', 'completed', 'failed'
    DateTime? sessionStartedAt,
    DateTime? sessionCompletedAt,
    String? sessionErrorMessage,
    int? processingTimeMs,

    // Subscription info
    bool? subscriptionEnabled,
    String? subscriptionScheduleTime,
    List<int>? subscriptionScheduleDays,

    // Store info
    String? storeId,
    String? storeName,
  }) = _ReportNotification;

  const ReportNotification._();

  /// Check if report generation was successful
  bool get isCompleted => sessionStatus == 'completed';

  /// Check if report generation failed
  bool get isFailed => sessionStatus == 'failed';

  /// Check if report is pending or processing
  bool get isPending =>
      sessionStatus == 'pending' || sessionStatus == 'processing';
}
