import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/bcg_category.dart';
import '../../domain/entities/sales_analytics.dart';
import '../../domain/repositories/sales_repository.dart';
import 'sales_di_provider.dart';
import 'states/sales_analytics_state.dart';

part 'sales_analytics_v2_notifier.g.dart';

/// Sales Analytics V2 Notifier (2025 @riverpod)
///
/// Repository 패턴을 사용하여 Clean Architecture를 준수합니다.
@riverpod
class SalesAnalyticsV2Notifier extends _$SalesAnalyticsV2Notifier {
  SalesRepository get _repository => ref.read(salesRepositoryProvider);

  void _log(String message, [Object? data]) {
    debugPrint('🔵 [SalesAnalyticsV2] $message');
    if (data != null) {
      debugPrint('   → $data');
    }
  }

  @override
  SalesAnalyticsV2State build() {
    return SalesAnalyticsV2State.initial();
  }

  /// Load all analytics data
  Future<void> loadData({
    required String companyId,
    String? storeId,
  }) async {
    _log('loadData() called', {
      'companyId': companyId,
      'storeId': storeId,
      'dateRange': '${state.startDate} ~ ${state.endDate}',
    });

    // Reset drillDownState FIRST before API calls
    state = state.copyWith(
      isLoading: true,
      error: null,
      drillDownState: DrillDownState.initial(),
      selectedCategoryId: null,
      categoryTrend: null,
    );

    try {
      _log('Starting parallel API calls...');
      final results = await Future.wait([
        _getTimeSeries(companyId, storeId),
        _getTopProducts(companyId, storeId),
        _getDrillDownData(companyId, storeId),
        _getBcgMatrix(companyId, storeId),
        _getAvailableCategories(companyId, storeId),
        _getCurrencySymbol(companyId),
      ]);

      _log('All API calls completed', {
        'timeSeries.dataCount': (results[0] as SalesAnalyticsResponse).data.length,
        'topProducts.dataCount': (results[1] as SalesAnalyticsResponse).data.length,
        'drillDown.dataCount': (results[2] as DrillDownResponse).data.length,
        'bcgMatrix.categoriesCount': (results[3] as BcgMatrix).categories.length,
        'availableCategories': (results[4] as List<CategoryInfo>).length,
      });

      state = state.copyWith(
        isLoading: false,
        timeSeries: results[0] as SalesAnalyticsResponse,
        topProducts: results[1] as SalesAnalyticsResponse,
        drillDownData: results[2] as DrillDownResponse,
        bcgMatrix: results[3] as BcgMatrix,
        availableCategories: results[4] as List<CategoryInfo>,
        currencySymbol: results[5] as String,
      );
    } catch (e, stackTrace) {
      _log('❌ ERROR in loadData()', {'error': e.toString()});
      debugPrint('   Stack trace: $stackTrace');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh data
  Future<void> refresh({
    required String companyId,
    String? storeId,
  }) async {
    _log('refresh() called');
    state = state.copyWith(isRefreshing: true);
    await loadData(companyId: companyId, storeId: storeId);
    state = state.copyWith(isRefreshing: false);
  }

  /// Change time range
  Future<void> setTimeRange(
    TimeRange range, {
    required String companyId,
    String? storeId,
    DateTime? customStart,
    DateTime? customEnd,
  }) async {
    final (startDate, endDate) = range == TimeRange.custom
        ? (customStart ?? state.startDate, customEnd ?? state.endDate)
        : range.getDateRange();

    _log('setTimeRange()', {
      'range': range.name,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
    });

    state = state.copyWith(
      selectedTimeRange: range,
      startDate: startDate,
      endDate: endDate,
    );

    await loadData(companyId: companyId, storeId: storeId);
  }

  /// Change metric
  Future<void> setMetric(
    Metric metric, {
    required String companyId,
    String? storeId,
  }) async {
    _log('setMetric()', {'metric': metric.name});
    state = state.copyWith(selectedMetric: metric);
    await loadData(companyId: companyId, storeId: storeId);
  }

  /// Set selected category for trend chart
  Future<void> setCategory(
    String? categoryId, {
    required String companyId,
    String? storeId,
  }) async {
    _log('setCategory()', {'categoryId': categoryId});

    if (categoryId == null) {
      state = state.copyWith(
        selectedCategoryId: null,
        categoryTrend: null,
      );
      return;
    }

    state = state.copyWith(
      selectedCategoryId: categoryId,
      isCategoryTrendLoading: true,
    );

    try {
      final categoryTrend = await _getCategoryTrend(companyId, storeId, categoryId);
      state = state.copyWith(
        isCategoryTrendLoading: false,
        categoryTrend: categoryTrend,
      );
    } catch (e) {
      _log('ERROR in setCategory()', {'error': e.toString()});
      state = state.copyWith(
        isCategoryTrendLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Drill down into a category/brand
  Future<void> drillDown({
    required String id,
    required String name,
    required String companyId,
    String? storeId,
  }) async {
    if (!state.drillDownState.canDrillDown) return;

    _log('drillDown()', {'id': id, 'name': name});

    final newState = state.drillDownState.drillDown(id, name);
    state = state.copyWith(drillDownState: newState, isDrillDownLoading: true);

    try {
      final drillDownData = await _getDrillDownData(companyId, storeId);
      state = state.copyWith(isDrillDownLoading: false, drillDownData: drillDownData);
    } catch (e) {
      _log('ERROR in drillDown()', {'error': e.toString()});
      state = state.copyWith(isDrillDownLoading: false, error: e.toString());
    }
  }

  /// Navigate to breadcrumb item
  Future<void> navigateToBreadcrumb({
    required int index,
    required String companyId,
    String? storeId,
  }) async {
    _log('navigateToBreadcrumb()', {'index': index});

    final newState = state.drillDownState.navigateTo(index);
    state = state.copyWith(drillDownState: newState, isDrillDownLoading: true);

    try {
      final drillDownData = await _getDrillDownData(companyId, storeId);
      state = state.copyWith(isDrillDownLoading: false, drillDownData: drillDownData);
    } catch (e) {
      _log('ERROR in navigateToBreadcrumb()', {'error': e.toString()});
      state = state.copyWith(isDrillDownLoading: false, error: e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Private API Methods (using Repository)
  // ═══════════════════════════════════════════════════════════════

  Future<SalesAnalyticsResponse> _getTimeSeries(String companyId, String? storeId) async {
    final params = SalesAnalyticsParams(
      companyId: companyId,
      storeId: storeId,
      startDate: state.startDate,
      endDate: state.endDate,
      groupBy: state.selectedTimeRange.recommendedGroupBy.name,
      dimension: 'total',
      metric: state.selectedMetric.name,
      comparePrevious: true,
    );

    final result = await _repository.getSalesAnalytics(params);
    return result.fold(
      (failure) {
        _log('_getTimeSeries() ERROR', {'error': failure.message});
        return _emptyResponse(failure.message);
      },
      (response) => response,
    );
  }

  Future<SalesAnalyticsResponse> _getTopProducts(String companyId, String? storeId) async {
    final params = SalesAnalyticsParams(
      companyId: companyId,
      storeId: storeId,
      startDate: state.startDate,
      endDate: state.endDate,
      groupBy: 'total',
      dimension: 'product',
      metric: 'revenue',
      topN: 10,
      comparePrevious: true,
    );

    final result = await _repository.getSalesAnalytics(params);
    return result.fold(
      (failure) {
        _log('_getTopProducts() ERROR', {'error': failure.message});
        return _emptyResponse(failure.message);
      },
      (response) => response,
    );
  }

  Future<DrillDownResponse> _getDrillDownData(String companyId, String? storeId) async {
    final params = DrillDownParams(
      companyId: companyId,
      storeId: storeId,
      startDate: state.startDate,
      endDate: state.endDate,
      level: state.drillDownState.currentLevel,
      parentId: state.drillDownState.parentId,
    );

    _log('_getDrillDownData()', {
      'level': state.drillDownState.currentLevel,
      'parentId': state.drillDownState.parentId,
      'breadcrumbs': state.drillDownState.breadcrumbs.map((b) => b.name).toList(),
    });

    final result = await _repository.getDrillDownAnalytics(params);
    return result.fold(
      (failure) {
        _log('_getDrillDownData() ERROR', {'error': failure.message});
        return DrillDownResponse(
          success: false,
          level: state.drillDownState.currentLevel,
          data: [],
          error: failure.message,
        );
      },
      (response) => response,
    );
  }

  Future<SalesAnalyticsResponse> _getCategoryTrend(
    String companyId,
    String? storeId,
    String categoryId,
  ) async {
    final params = SalesAnalyticsParams(
      companyId: companyId,
      storeId: storeId,
      startDate: state.startDate,
      endDate: state.endDate,
      groupBy: state.selectedTimeRange.recommendedGroupBy.name,
      dimension: 'category',
      metric: state.selectedMetric.name,
      comparePrevious: true,
      categoryId: categoryId,
    );

    final result = await _repository.getSalesAnalytics(params);
    return result.fold(
      (failure) {
        _log('_getCategoryTrend() ERROR', {'error': failure.message});
        return _emptyResponse(failure.message);
      },
      (response) => response,
    );
  }

  Future<List<CategoryInfo>> _getAvailableCategories(String companyId, String? storeId) async {
    final params = SalesAnalyticsParams(
      companyId: companyId,
      storeId: storeId,
      startDate: state.startDate,
      endDate: state.endDate,
      groupBy: 'total',
      dimension: 'category',
      metric: 'revenue',
      topN: 20,
    );

    final result = await _repository.getSalesAnalytics(params);
    return result.fold(
      (failure) {
        _log('_getAvailableCategories() ERROR', {'error': failure.message});
        return [];
      },
      (response) => response.data.map((item) => CategoryInfo(
        id: item.dimensionId,
        name: item.dimensionName,
      )).toList(),
    );
  }

  Future<BcgMatrix> _getBcgMatrix(String companyId, String? storeId) async {
    final result = await _repository.getBcgMatrixV2(
      companyId: companyId,
      startDate: state.startDate,
      endDate: state.endDate,
      storeId: storeId,
    );

    return result.fold(
      (failure) {
        _log('_getBcgMatrix() ERROR', {'error': failure.message});
        return const BcgMatrix(categories: []);
      },
      (matrix) => matrix,
    );
  }

  Future<String> _getCurrencySymbol(String companyId) async {
    final result = await _repository.getCurrencySymbol(companyId: companyId);
    return result.fold(
      (failure) {
        _log('_getCurrencySymbol() ERROR', {'error': failure.message});
        return '₫'; // Default to VND
      },
      (symbol) => symbol,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Helper Methods
  // ═══════════════════════════════════════════════════════════════

  SalesAnalyticsResponse _emptyResponse(String error) {
    return SalesAnalyticsResponse(
      success: false,
      summary: const AnalyticsSummary(
        totalRevenue: 0,
        totalQuantity: 0,
        totalMargin: 0,
        avgMarginRate: 0,
        recordCount: 0,
      ),
      data: [],
      error: error,
    );
  }
}
