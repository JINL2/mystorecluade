import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_analytics.freezed.dart';

/// Time range for analytics queries
enum TimeRange {
  today,
  thisWeek,
  thisMonth,
  last30Days,
  last90Days,
  thisYear,
  custom,
}

/// Grouping granularity
enum GroupBy {
  daily,
  weekly,
  monthly,
}

/// Analysis dimension
enum Dimension {
  total,
  category,
  brand,
  product,
}

/// Metric type
enum Metric {
  revenue,
  quantity,
  margin,
}

/// Extension for TimeRange
extension TimeRangeExtension on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.today:
        return 'Today';
      case TimeRange.thisWeek:
        return 'This Week';
      case TimeRange.thisMonth:
        return 'This Month';
      case TimeRange.last30Days:
        return 'Last 30 Days';
      case TimeRange.last90Days:
        return 'Last 90 Days';
      case TimeRange.thisYear:
        return 'This Year';
      case TimeRange.custom:
        return 'Custom';
    }
  }

  (DateTime, DateTime) getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (this) {
      case TimeRange.today:
        return (today, today);
      case TimeRange.thisWeek:
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        return (weekStart, today);
      case TimeRange.thisMonth:
        return (DateTime(now.year, now.month, 1), today);
      case TimeRange.last30Days:
        return (today.subtract(const Duration(days: 30)), today);
      case TimeRange.last90Days:
        return (today.subtract(const Duration(days: 90)), today);
      case TimeRange.thisYear:
        return (DateTime(now.year, 1, 1), today);
      case TimeRange.custom:
        return (today.subtract(const Duration(days: 30)), today);
    }
  }

  GroupBy get recommendedGroupBy {
    switch (this) {
      case TimeRange.today:
      case TimeRange.thisWeek:
        return GroupBy.daily;
      case TimeRange.thisMonth:
      case TimeRange.last30Days:
        return GroupBy.daily;
      case TimeRange.last90Days:
        return GroupBy.weekly;
      case TimeRange.thisYear:
      case TimeRange.custom:
        return GroupBy.monthly;
    }
  }
}

/// Analytics data point - Pure Entity (NO JSON)
@freezed
class AnalyticsDataPoint with _$AnalyticsDataPoint {
  const AnalyticsDataPoint._();

  const factory AnalyticsDataPoint({
    required DateTime period,
    required String dimensionId,
    required String dimensionName,
    required double totalQuantity,
    required double totalRevenue,
    required double totalMargin,
    required double marginRate,
    required int invoiceCount,
    double? revenueGrowth,
    double? quantityGrowth,
    double? marginGrowth,
  }) = _AnalyticsDataPoint;
}

/// Analytics summary - Pure Entity (NO JSON)
@freezed
class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    required double totalRevenue,
    required double totalQuantity,
    required double totalMargin,
    required double avgMarginRate,
    required int recordCount,
  }) = _AnalyticsSummary;
}

/// Complete analytics response - Pure Entity (NO JSON)
@freezed
class SalesAnalyticsResponse with _$SalesAnalyticsResponse {
  const SalesAnalyticsResponse._();

  const factory SalesAnalyticsResponse({
    required bool success,
    required AnalyticsSummary summary,
    required List<AnalyticsDataPoint> data,
    String? error,
  }) = _SalesAnalyticsResponse;

  bool get hasData => data.isNotEmpty;
}

/// Drill-down item - Pure Entity (NO JSON)
@freezed
class DrillDownItem with _$DrillDownItem {
  const DrillDownItem._();

  const factory DrillDownItem({
    required String id,
    required String name,
    required double totalQuantity,
    required double totalRevenue,
    required double totalMargin,
    required double marginRate,
    int? productCount,
    int? brandCount,
    String? categoryId,
    String? categoryName,
    String? brandId,
    String? brandName,
  }) = _DrillDownItem;
}

/// Drill-down response - Pure Entity (NO JSON)
@freezed
class DrillDownResponse with _$DrillDownResponse {
  const factory DrillDownResponse({
    required bool success,
    required String level,
    required List<DrillDownItem> data,
    String? parentId,
    String? error,
  }) = _DrillDownResponse;
}

/// Breadcrumb item for drill-down navigation
@freezed
class BreadcrumbItem with _$BreadcrumbItem {
  const factory BreadcrumbItem({
    String? id,
    required String name,
    required String level,
  }) = _BreadcrumbItem;
}

/// Drill-down state for navigation
@freezed
class DrillDownState with _$DrillDownState {
  const DrillDownState._();

  const factory DrillDownState({
    @Default([]) List<BreadcrumbItem> breadcrumbs,
    @Default('category') String currentLevel,
    String? parentId,
  }) = _DrillDownState;

  factory DrillDownState.initial() {
    return const DrillDownState(
      breadcrumbs: [BreadcrumbItem(id: null, name: 'All', level: 'category')],
      currentLevel: 'category',
      parentId: null,
    );
  }

  DrillDownState drillDown(String id, String name) {
    final nextLevel = currentLevel == 'category' ? 'brand' : 'product';
    return DrillDownState(
      breadcrumbs: [
        ...breadcrumbs,
        BreadcrumbItem(id: id, name: name, level: nextLevel)
      ],
      currentLevel: nextLevel,
      parentId: id,
    );
  }

  DrillDownState navigateTo(int index) {
    if (index >= breadcrumbs.length) return this;
    final newBreadcrumbs = breadcrumbs.sublist(0, index + 1);
    final targetItem = newBreadcrumbs.last;
    return DrillDownState(
      breadcrumbs: newBreadcrumbs,
      currentLevel: targetItem.level,
      parentId: targetItem.id,
    );
  }

  bool get canDrillDown => currentLevel != 'product';
  bool get canGoBack => breadcrumbs.length > 1;
}
