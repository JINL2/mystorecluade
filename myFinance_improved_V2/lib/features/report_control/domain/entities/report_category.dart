// lib/features/report_control/domain/entities/report_category.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_category.freezed.dart';

/// Domain entity representing a report category with statistics
@freezed
class ReportCategory with _$ReportCategory {
  const factory ReportCategory({
    required String categoryId,
    required String categoryName,
    String? categoryIcon,
    required int templateCount,
    required int reportCount,
    required int unreadCount,
    DateTime? latestReportDate,
  }) = _ReportCategory;

  const ReportCategory._();

  /// Check if category has unread reports
  bool get hasUnread => unreadCount > 0;
}
