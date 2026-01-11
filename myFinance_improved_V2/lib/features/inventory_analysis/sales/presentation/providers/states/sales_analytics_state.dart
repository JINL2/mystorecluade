import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/bcg_category.dart';
import '../../../domain/entities/sales_analytics.dart';

part 'sales_analytics_state.freezed.dart';

/// Category info for dropdown
@freezed
class CategoryInfo with _$CategoryInfo {
  const factory CategoryInfo({
    required String id,
    required String name,
  }) = _CategoryInfo;
}

/// Sales Analytics V2 State (freezed)
@freezed
class SalesAnalyticsV2State with _$SalesAnalyticsV2State {
  const SalesAnalyticsV2State._();

  const factory SalesAnalyticsV2State({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    @Default(false) bool isDrillDownLoading,
    @Default(false) bool isCategoryTrendLoading,
    SalesAnalyticsResponse? timeSeries,
    SalesAnalyticsResponse? topProducts,
    SalesAnalyticsResponse? categoryTrend,
    DrillDownResponse? drillDownData,
    BcgMatrix? bcgMatrix,
    @Default(DrillDownState()) DrillDownState drillDownState,
    String? error,
    @Default(TimeRange.thisMonth) TimeRange selectedTimeRange,
    required DateTime startDate,
    required DateTime endDate,
    @Default(Metric.revenue) Metric selectedMetric,
    String? selectedCategoryId,
    @Default([]) List<CategoryInfo> availableCategories,
    @Default('₫') String currencySymbol,
  }) = _SalesAnalyticsV2State;

  factory SalesAnalyticsV2State.initial() {
    final now = DateTime.now();
    return SalesAnalyticsV2State(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
      drillDownState: DrillDownState.initial(),
    );
  }

  bool get hasData => timeSeries != null || topProducts != null;
  AnalyticsSummary? get summary => timeSeries?.summary ?? topProducts?.summary;

  List<AnalyticsDataPoint> get trendData {
    if (selectedCategoryId != null && categoryTrend != null) {
      return categoryTrend!.data;
    }
    return timeSeries?.data ?? [];
  }

  String? get selectedCategoryName {
    if (selectedCategoryId == null) return null;
    return availableCategories.where((c) => c.id == selectedCategoryId).firstOrNull?.name;
  }
}
