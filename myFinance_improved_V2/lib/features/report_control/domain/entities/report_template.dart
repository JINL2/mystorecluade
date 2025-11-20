// lib/features/report_control/domain/entities/report_template.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_template.freezed.dart';

/// Domain entity representing a report template
///
/// Maps to `report_templates` table in database.
@freezed
class ReportTemplate with _$ReportTemplate {
  const factory ReportTemplate({
    required String templateId,
    required String templateName,
    required String templateCode,
    String? description,
    required String frequency, // 'daily', 'weekly', 'monthly'
    String? icon,
    int? displayOrder,
    String? defaultScheduleTime,
    List<int>? defaultScheduleDays, // [0-6]
    int? defaultMonthlyDay,
    String? categoryId,
  }) = _ReportTemplate;

  const ReportTemplate._();
}
