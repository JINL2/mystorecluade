// lib/features/report_control/data/models/report_category_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/report_category.dart';

part 'report_category_dto.freezed.dart';
part 'report_category_dto.g.dart';

/// Data Transfer Object for ReportCategory
///
/// Maps RPC result from report_get_categories_with_stats to domain entity
@freezed
class ReportCategoryDto with _$ReportCategoryDto {
  const factory ReportCategoryDto({
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'category_name') required String categoryName,
    @JsonKey(name: 'category_icon') String? categoryIcon,
    @JsonKey(name: 'template_count') required int templateCount,
    @JsonKey(name: 'report_count') required int reportCount,
    @JsonKey(name: 'unread_count') required int unreadCount,
    @JsonKey(name: 'latest_report_date') DateTime? latestReportDate,
  }) = _ReportCategoryDto;

  const ReportCategoryDto._();

  factory ReportCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$ReportCategoryDtoFromJson(json);

  /// Convert DTO to domain entity
  ReportCategory toDomain() {
    return ReportCategory(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      templateCount: templateCount,
      reportCount: reportCount,
      unreadCount: unreadCount,
      latestReportDate: latestReportDate?.toLocal(),
    );
  }
}
