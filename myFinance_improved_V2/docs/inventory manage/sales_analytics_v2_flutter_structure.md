# Sales Analytics V2 - Flutter Implementation Structure

> **Version**: 1.0
> **Date**: 2026-01-09
> **Status**: Ready for Implementation

---

## 1. File Structure Overview

```
lib/features/inventory_analysis/
├── domain/
│   └── entities/
│       ├── sales_analytics.dart              # NEW: TimeRange, Metric, Dimension enums
│       ├── sales_analytics.freezed.dart      # Generated
│       └── ... (existing files)
├── data/
│   ├── models/
│   │   ├── sales_analytics_model.dart        # NEW: JSON models
│   │   ├── sales_analytics_model.g.dart      # Generated
│   │   └── ... (existing files)
│   ├── datasources/
│   │   └── inventory_analytics_datasource.dart  # MODIFY: Add new RPC methods
│   └── repositories/
│       └── ... (existing)
├── presentation/
│   ├── providers/
│   │   ├── sales_analytics_v2_provider.dart  # NEW: Time range, Top N, Drill-down state
│   │   └── ... (existing)
│   ├── pages/
│   │   └── sales_dashboard_page.dart         # MODIFY: Add new sections
│   └── widgets/
│       ├── time_range_selector.dart          # NEW
│       ├── summary_cards.dart                # NEW
│       ├── time_series_chart.dart            # NEW
│       ├── top_products_list.dart            # NEW
│       ├── drill_down_section.dart           # NEW
│       ├── drill_down_breadcrumb.dart        # NEW
│       └── ... (existing)
└── di/
    └── analytics_providers.dart              # MODIFY: Register new providers
```

---

## 2. New Files to Create

### 2.1 Domain Layer

#### `sales_analytics.dart`

```dart
// lib/features/inventory_analysis/domain/entities/sales_analytics.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_analytics.freezed.dart';

/// Time range options for analytics
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

/// Metric type for sorting/display
enum Metric {
  revenue,
  quantity,
  margin,
}

/// Extension for TimeRange to get date range
extension TimeRangeExtension on TimeRange {
  (DateTime, DateTime) getDateRange({DateTime? customStart, DateTime? customEnd}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (this) {
      case TimeRange.today:
        return (today, today);
      case TimeRange.thisWeek:
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        return (startOfWeek, today);
      case TimeRange.thisMonth:
        return (DateTime(now.year, now.month, 1), today);
      case TimeRange.last30Days:
        return (today.subtract(const Duration(days: 30)), today);
      case TimeRange.last90Days:
        return (today.subtract(const Duration(days: 90)), today);
      case TimeRange.thisYear:
        return (DateTime(now.year, 1, 1), today);
      case TimeRange.custom:
        return (customStart ?? today, customEnd ?? today);
    }
  }

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

  GroupBy get suggestedGroupBy {
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

/// Analytics data point (single row from RPC)
@freezed
class AnalyticsDataPoint with _$AnalyticsDataPoint {
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

/// Analytics summary (aggregated totals)
@freezed
class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    required double totalRevenue,
    required double totalQuantity,
    required double totalMargin,
    required double avgMarginRate,
    required int recordCount,
  }) = _AnalyticsSummary;

  factory AnalyticsSummary.empty() => const AnalyticsSummary(
        totalRevenue: 0,
        totalQuantity: 0,
        totalMargin: 0,
        avgMarginRate: 0,
        recordCount: 0,
      );
}

/// Complete analytics response
@freezed
class SalesAnalyticsData with _$SalesAnalyticsData {
  const factory SalesAnalyticsData({
    required bool success,
    required AnalyticsSummary summary,
    required List<AnalyticsDataPoint> data,
    String? error,
  }) = _SalesAnalyticsData;

  factory SalesAnalyticsData.empty() => SalesAnalyticsData(
        success: true,
        summary: AnalyticsSummary.empty(),
        data: [],
      );

  factory SalesAnalyticsData.error(String message) => SalesAnalyticsData(
        success: false,
        summary: AnalyticsSummary.empty(),
        data: [],
        error: message,
      );
}

/// Drill-down item (category, brand, or product)
@freezed
class DrillDownItem with _$DrillDownItem {
  const factory DrillDownItem({
    required String id,
    required String name,
    required double totalQuantity,
    required double totalRevenue,
    required double totalMargin,
    required double marginRate,
    int? productCount,
    int? brandCount,
    int? invoiceCount,
    String? categoryId,
    String? categoryName,
    String? brandId,
    String? brandName,
  }) = _DrillDownItem;
}

/// Breadcrumb item for drill-down navigation
@freezed
class BreadcrumbItem with _$BreadcrumbItem {
  const factory BreadcrumbItem({
    String? id,
    required String name,
  }) = _BreadcrumbItem;
}
```

---

### 2.2 Data Layer

#### `sales_analytics_model.dart`

```dart
// lib/features/inventory_analysis/data/models/sales_analytics_model.dart

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/sales_analytics.dart';

part 'sales_analytics_model.g.dart';

/// Analytics data point model (JSON parsing)
@JsonSerializable(fieldRename: FieldRename.snake)
class AnalyticsDataPointModel {
  final String period;
  final String dimensionId;
  final String dimensionName;
  final num totalQuantity;
  final num totalRevenue;
  final num totalMargin;
  final num marginRate;
  final int invoiceCount;
  final num? revenueGrowth;
  final num? quantityGrowth;
  final num? marginGrowth;

  AnalyticsDataPointModel({
    required this.period,
    required this.dimensionId,
    required this.dimensionName,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.totalMargin,
    required this.marginRate,
    required this.invoiceCount,
    this.revenueGrowth,
    this.quantityGrowth,
    this.marginGrowth,
  });

  factory AnalyticsDataPointModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsDataPointModelToJson(this);

  AnalyticsDataPoint toEntity() => AnalyticsDataPoint(
        period: DateTime.parse(period),
        dimensionId: dimensionId,
        dimensionName: dimensionName,
        totalQuantity: totalQuantity.toDouble(),
        totalRevenue: totalRevenue.toDouble(),
        totalMargin: totalMargin.toDouble(),
        marginRate: marginRate.toDouble(),
        invoiceCount: invoiceCount,
        revenueGrowth: revenueGrowth?.toDouble(),
        quantityGrowth: quantityGrowth?.toDouble(),
        marginGrowth: marginGrowth?.toDouble(),
      );
}

/// Analytics summary model
@JsonSerializable(fieldRename: FieldRename.snake)
class AnalyticsSummaryModel {
  final num? totalRevenue;
  final num? totalQuantity;
  final num? totalMargin;
  final num? avgMarginRate;
  final int? recordCount;

  AnalyticsSummaryModel({
    this.totalRevenue,
    this.totalQuantity,
    this.totalMargin,
    this.avgMarginRate,
    this.recordCount,
  });

  factory AnalyticsSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsSummaryModelToJson(this);

  AnalyticsSummary toEntity() => AnalyticsSummary(
        totalRevenue: totalRevenue?.toDouble() ?? 0,
        totalQuantity: totalQuantity?.toDouble() ?? 0,
        totalMargin: totalMargin?.toDouble() ?? 0,
        avgMarginRate: avgMarginRate?.toDouble() ?? 0,
        recordCount: recordCount ?? 0,
      );
}

/// Complete analytics response model
@JsonSerializable(fieldRename: FieldRename.snake)
class SalesAnalyticsResponseModel {
  final bool success;
  final AnalyticsSummaryModel? summary;
  final List<dynamic>? data;
  final String? error;

  SalesAnalyticsResponseModel({
    required this.success,
    this.summary,
    this.data,
    this.error,
  });

  factory SalesAnalyticsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SalesAnalyticsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesAnalyticsResponseModelToJson(this);

  SalesAnalyticsData toEntity() {
    if (!success) {
      return SalesAnalyticsData.error(error ?? 'Unknown error');
    }

    return SalesAnalyticsData(
      success: true,
      summary: summary?.toEntity() ?? AnalyticsSummary.empty(),
      data: data
              ?.map((e) => AnalyticsDataPointModel.fromJson(e as Map<String, dynamic>).toEntity())
              .toList() ??
          [],
    );
  }
}

/// Drill-down item model
@JsonSerializable(fieldRename: FieldRename.snake)
class DrillDownItemModel {
  final String id;
  final String name;
  final num totalQuantity;
  final num totalRevenue;
  final num totalMargin;
  final num marginRate;
  final int? productCount;
  final int? brandCount;
  final int? invoiceCount;
  final String? categoryId;
  final String? categoryName;
  final String? brandId;
  final String? brandName;

  DrillDownItemModel({
    required this.id,
    required this.name,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.totalMargin,
    required this.marginRate,
    this.productCount,
    this.brandCount,
    this.invoiceCount,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
  });

  factory DrillDownItemModel.fromJson(Map<String, dynamic> json) =>
      _$DrillDownItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrillDownItemModelToJson(this);

  DrillDownItem toEntity() => DrillDownItem(
        id: id,
        name: name,
        totalQuantity: totalQuantity.toDouble(),
        totalRevenue: totalRevenue.toDouble(),
        totalMargin: totalMargin.toDouble(),
        marginRate: marginRate.toDouble(),
        productCount: productCount,
        brandCount: brandCount,
        invoiceCount: invoiceCount,
        categoryId: categoryId,
        categoryName: categoryName,
        brandId: brandId,
        brandName: brandName,
      );
}

/// Drill-down response model
@JsonSerializable(fieldRename: FieldRename.snake)
class DrillDownResponseModel {
  final bool success;
  final String? level;
  final String? parentId;
  final List<dynamic>? data;
  final String? error;

  DrillDownResponseModel({
    required this.success,
    this.level,
    this.parentId,
    this.data,
    this.error,
  });

  factory DrillDownResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DrillDownResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrillDownResponseModelToJson(this);

  List<DrillDownItem> toEntityList() {
    if (!success || data == null) return [];
    return data!
        .map((e) => DrillDownItemModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
  }
}
```

---

### 2.3 Datasource Update

#### Add to `inventory_analytics_datasource.dart`

```dart
// Add these methods to InventoryAnalyticsDatasource class

/// Sales Analytics V2 - 통합 분석
/// RPC: get_sales_analytics
Future<SalesAnalyticsResponseModel> getSalesAnalytics({
  required String companyId,
  required DateTime startDate,
  required DateTime endDate,
  String? storeId,
  String groupBy = 'daily',
  String dimension = 'total',
  String metric = 'revenue',
  String orderBy = 'DESC',
  int? topN,
  bool comparePrevious = false,
}) async {
  try {
    final params = {
      'p_company_id': companyId,
      'p_start_date': startDate.toIso8601String().substring(0, 10),
      'p_end_date': endDate.toIso8601String().substring(0, 10),
      if (storeId != null) 'p_store_id': storeId,
      'p_group_by': groupBy,
      'p_dimension': dimension,
      'p_metric': metric,
      'p_order_by': orderBy,
      if (topN != null) 'p_top_n': topN,
      'p_compare_previous': comparePrevious,
    };

    final response = await _client
        .rpc<Map<String, dynamic>>('get_sales_analytics', params: params)
        .single();

    // ignore: avoid_print
    print('📊 [SALES_ANALYTICS_V2] RPC Response: $response');

    return SalesAnalyticsResponseModel.fromJson(response);
  } on PostgrestException catch (e) {
    throw AnalyticsConnectionException(
      message: 'Database error: ${e.message}',
      details: {'code': e.code, 'details': e.details},
    );
  } catch (e) {
    if (e is AnalyticsException) rethrow;
    throw AnalyticsRepositoryException(
      message: 'Failed to fetch sales analytics: $e',
      details: e,
    );
  }
}

/// BCG Matrix V2 - 시간 범위 지원
/// RPC: get_bcg_matrix_v2
Future<BcgMatrixModel> getBcgMatrixV2({
  required String companyId,
  required DateTime startDate,
  required DateTime endDate,
  String? storeId,
}) async {
  try {
    final params = {
      'p_company_id': companyId,
      'p_start_date': startDate.toIso8601String().substring(0, 10),
      'p_end_date': endDate.toIso8601String().substring(0, 10),
      if (storeId != null) 'p_store_id': storeId,
    };

    final response = await _client
        .rpc<Map<String, dynamic>>('get_bcg_matrix_v2', params: params)
        .single();

    // ignore: avoid_print
    print('📈 [BCG_MATRIX_V2] RPC Response: $response');

    return BcgMatrixModel.fromJson(response);
  } on PostgrestException catch (e) {
    throw AnalyticsConnectionException(
      message: 'Database error: ${e.message}',
      details: {'code': e.code, 'details': e.details},
    );
  } catch (e) {
    if (e is AnalyticsException) rethrow;
    throw AnalyticsRepositoryException(
      message: 'Failed to fetch BCG matrix v2: $e',
      details: e,
    );
  }
}

/// Drill-down Analytics
/// RPC: get_drill_down_analytics
Future<DrillDownResponseModel> getDrillDownAnalytics({
  required String companyId,
  required DateTime startDate,
  required DateTime endDate,
  String? storeId,
  String level = 'category',
  String? parentId,
}) async {
  try {
    final params = {
      'p_company_id': companyId,
      'p_start_date': startDate.toIso8601String().substring(0, 10),
      'p_end_date': endDate.toIso8601String().substring(0, 10),
      if (storeId != null) 'p_store_id': storeId,
      'p_level': level,
      if (parentId != null) 'p_parent_id': parentId,
    };

    final response = await _client
        .rpc<Map<String, dynamic>>('get_drill_down_analytics', params: params)
        .single();

    // ignore: avoid_print
    print('🔍 [DRILL_DOWN] RPC Response: $response');

    return DrillDownResponseModel.fromJson(response);
  } on PostgrestException catch (e) {
    throw AnalyticsConnectionException(
      message: 'Database error: ${e.message}',
      details: {'code': e.code, 'details': e.details},
    );
  } catch (e) {
    if (e is AnalyticsException) rethrow;
    throw AnalyticsRepositoryException(
      message: 'Failed to fetch drill-down analytics: $e',
      details: e,
    );
  }
}
```

---

### 2.4 Provider Layer

#### `sales_analytics_v2_provider.dart`

```dart
// lib/features/inventory_analysis/presentation/providers/sales_analytics_v2_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/datasources/inventory_analytics_datasource.dart';
import '../../domain/entities/sales_analytics.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../features/auth/data/providers/auth_provider.dart';

part 'sales_analytics_v2_provider.freezed.dart';

/// Sales Analytics V2 State
@freezed
class SalesAnalyticsV2State with _$SalesAnalyticsV2State {
  const factory SalesAnalyticsV2State({
    // Loading states
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingTimeSeries,
    @Default(false) bool isLoadingTopProducts,
    @Default(false) bool isLoadingDrillDown,

    // Time range
    @Default(TimeRange.thisMonth) TimeRange selectedTimeRange,
    DateTime? customStartDate,
    DateTime? customEndDate,

    // Data
    SalesAnalyticsData? timeSeriesData,
    SalesAnalyticsData? topProductsData,
    @Default([]) List<DrillDownItem> drillDownData,

    // Drill-down navigation
    @Default([BreadcrumbItem(name: 'All')]) List<BreadcrumbItem> breadcrumbs,
    @Default('category') String currentLevel,
    String? currentParentId,

    // Selected metric for chart
    @Default(Metric.revenue) Metric selectedMetric,

    // Error
    String? error,
  }) = _SalesAnalyticsV2State;
}

/// Sales Analytics V2 Notifier
class SalesAnalyticsV2Notifier extends StateNotifier<SalesAnalyticsV2State> {
  final InventoryAnalyticsDatasource _datasource;
  final String _companyId;
  final String? _storeId;

  SalesAnalyticsV2Notifier({
    required InventoryAnalyticsDatasource datasource,
    required String companyId,
    String? storeId,
  })  : _datasource = datasource,
        _companyId = companyId,
        _storeId = storeId,
        super(const SalesAnalyticsV2State());

  /// Get current date range based on selected time range
  (DateTime, DateTime) get _dateRange {
    return state.selectedTimeRange.getDateRange(
      customStart: state.customStartDate,
      customEnd: state.customEndDate,
    );
  }

  /// Load all data
  Future<void> loadAllData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.wait([
        loadTimeSeries(),
        loadTopProducts(),
        loadDrillDown(),
      ]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Load time series data
  Future<void> loadTimeSeries() async {
    state = state.copyWith(isLoadingTimeSeries: true);

    try {
      final (startDate, endDate) = _dateRange;
      final groupBy = state.selectedTimeRange.suggestedGroupBy;

      final response = await _datasource.getSalesAnalytics(
        companyId: _companyId,
        startDate: startDate,
        endDate: endDate,
        storeId: _storeId,
        groupBy: groupBy.name,
        dimension: 'total',
        comparePrevious: true,
      );

      state = state.copyWith(
        timeSeriesData: response.toEntity(),
        isLoadingTimeSeries: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTimeSeries: false,
        error: e.toString(),
      );
    }
  }

  /// Load top products
  Future<void> loadTopProducts({int topN = 10}) async {
    state = state.copyWith(isLoadingTopProducts: true);

    try {
      final (startDate, endDate) = _dateRange;

      final response = await _datasource.getSalesAnalytics(
        companyId: _companyId,
        startDate: startDate,
        endDate: endDate,
        storeId: _storeId,
        dimension: 'product',
        metric: state.selectedMetric.name,
        topN: topN,
        comparePrevious: true,
      );

      state = state.copyWith(
        topProductsData: response.toEntity(),
        isLoadingTopProducts: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTopProducts: false,
        error: e.toString(),
      );
    }
  }

  /// Load drill-down data
  Future<void> loadDrillDown() async {
    state = state.copyWith(isLoadingDrillDown: true);

    try {
      final (startDate, endDate) = _dateRange;

      final response = await _datasource.getDrillDownAnalytics(
        companyId: _companyId,
        startDate: startDate,
        endDate: endDate,
        storeId: _storeId,
        level: state.currentLevel,
        parentId: state.currentParentId,
      );

      state = state.copyWith(
        drillDownData: response.toEntityList(),
        isLoadingDrillDown: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingDrillDown: false,
        error: e.toString(),
      );
    }
  }

  /// Change time range
  void setTimeRange(TimeRange range, {DateTime? customStart, DateTime? customEnd}) {
    state = state.copyWith(
      selectedTimeRange: range,
      customStartDate: customStart,
      customEndDate: customEnd,
    );
    loadAllData();
  }

  /// Change selected metric
  void setMetric(Metric metric) {
    state = state.copyWith(selectedMetric: metric);
    loadTopProducts();
  }

  /// Navigate drill-down forward
  void drillDown(String id, String name) {
    final nextLevel = state.currentLevel == 'category'
        ? 'brand'
        : state.currentLevel == 'brand'
            ? 'product'
            : 'product';

    if (state.currentLevel == 'product') return; // Already at deepest level

    state = state.copyWith(
      breadcrumbs: [...state.breadcrumbs, BreadcrumbItem(id: id, name: name)],
      currentLevel: nextLevel,
      currentParentId: id,
    );
    loadDrillDown();
  }

  /// Navigate drill-down back to specific level
  void navigateToBreadcrumb(int index) {
    if (index >= state.breadcrumbs.length) return;

    final newBreadcrumbs = state.breadcrumbs.sublist(0, index + 1);
    final levels = ['category', 'brand', 'product'];
    final newLevel = levels[index.clamp(0, 2)];

    state = state.copyWith(
      breadcrumbs: newBreadcrumbs,
      currentLevel: newLevel,
      currentParentId: newBreadcrumbs.last.id,
    );
    loadDrillDown();
  }

  /// Reset drill-down to root
  void resetDrillDown() {
    state = state.copyWith(
      breadcrumbs: const [BreadcrumbItem(name: 'All')],
      currentLevel: 'category',
      currentParentId: null,
    );
    loadDrillDown();
  }
}

/// Provider
final salesAnalyticsV2Provider = StateNotifierProvider.autoDispose
    .family<SalesAnalyticsV2Notifier, SalesAnalyticsV2State, String?>(
  (ref, storeId) {
    final supabase = ref.watch(supabaseClientProvider);
    final authState = ref.watch(authProvider);

    final companyId = authState.selectedCompanyId;
    if (companyId == null) {
      throw Exception('No company selected');
    }

    final datasource = InventoryAnalyticsDatasource(supabase);

    return SalesAnalyticsV2Notifier(
      datasource: datasource,
      companyId: companyId,
      storeId: storeId,
    );
  },
);
```

---

## 3. Widget Implementations

### 3.1 `time_range_selector.dart`

```dart
// lib/features/inventory_analysis/presentation/widgets/time_range_selector.dart

import 'package:flutter/material.dart';
import '../../domain/entities/sales_analytics.dart';
import '../../../../core/theme/toss_colors.dart';
import '../../../../core/theme/toss_text_styles.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onChanged;
  final VoidCallback? onCustomTap;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onChanged,
    this.onCustomTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: TimeRange.values
            .where((r) => r != TimeRange.custom)
            .map((range) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildChip(range),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildChip(TimeRange range) {
    final isSelected = selectedRange == range;

    return GestureDetector(
      onTap: () => onChanged(range),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.blue500 : TossColors.gray100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          range.label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
```

### 3.2 `summary_cards.dart`

```dart
// lib/features/inventory_analysis/presentation/widgets/summary_cards.dart

import 'package:flutter/material.dart';
import '../../domain/entities/sales_analytics.dart';
import '../../../../core/theme/toss_colors.dart';
import '../../../../core/theme/toss_text_styles.dart';
import '../../../../core/theme/toss_spacing.dart';
import '../../../core/widgets/toss_card.dart';
import '../../../../core/utils/number_formatter.dart';

class SummaryCards extends StatelessWidget {
  final AnalyticsSummary summary;
  final double? revenueGrowth;
  final double? marginGrowth;
  final double? quantityGrowth;

  const SummaryCards({
    super.key,
    required this.summary,
    this.revenueGrowth,
    this.marginGrowth,
    this.quantityGrowth,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildCard(
            label: 'Revenue',
            value: summary.totalRevenue,
            growth: revenueGrowth,
            isCurrency: true,
          ),
          const SizedBox(width: 12),
          _buildCard(
            label: 'Margin',
            value: summary.totalMargin,
            growth: marginGrowth,
            isCurrency: true,
          ),
          const SizedBox(width: 12),
          _buildCard(
            label: 'Quantity',
            value: summary.totalQuantity,
            growth: quantityGrowth,
            isCurrency: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String label,
    required double value,
    double? growth,
    required bool isCurrency,
  }) {
    return SizedBox(
      width: 140,
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
            const SizedBox(height: 4),
            Text(
              isCurrency ? formatCurrencyCompact(value) : formatNumber(value),
              style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            if (growth != null) ...[
              const SizedBox(height: 4),
              _buildGrowthIndicator(growth),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthIndicator(double growth) {
    final isPositive = growth >= 0;
    final color = isPositive ? TossColors.green500 : TossColors.red500;

    return Row(
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          '${growth.abs().toStringAsFixed(1)}%',
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'vs prev',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray400,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
```

### 3.3 Additional Widgets

See UI/UX spec document for detailed implementations of:
- `time_series_chart.dart`
- `top_products_list.dart`
- `drill_down_section.dart`
- `drill_down_breadcrumb.dart`

---

## 4. Implementation Sequence

### Step 1: Generate freezed files
```bash
cd myFinance_improved_V2
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Create files in order
1. `domain/entities/sales_analytics.dart`
2. `data/models/sales_analytics_model.dart`
3. Update `data/datasources/inventory_analytics_datasource.dart`
4. `presentation/providers/sales_analytics_v2_provider.dart`
5. Widget files

### Step 3: Update existing files
1. Add imports to `analytics_models.dart` barrel file
2. Register provider in `analytics_providers.dart`
3. Update `sales_dashboard_page.dart` to use new components

---

## 5. Testing Checklist

- [ ] Entity classes serialize/deserialize correctly
- [ ] RPC calls return expected data
- [ ] Time range changes trigger data reload
- [ ] Drill-down navigation works correctly
- [ ] Breadcrumb navigation works
- [ ] Chart renders with correct data
- [ ] Top products list displays correctly
- [ ] Growth indicators show correct colors
- [ ] Loading states display properly
- [ ] Error states display properly

---

**Document Created**: 2026-01-09
