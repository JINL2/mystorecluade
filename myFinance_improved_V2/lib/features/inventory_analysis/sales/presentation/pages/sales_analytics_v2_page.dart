import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../providers/sales_analytics_v2_notifier.dart';
import '../providers/states/sales_analytics_state.dart';
import '../widgets/bcg_matrix_chart.dart';
import '../widgets/category_preview.dart';
import '../widgets/global_filter_bar.dart';
import '../widgets/summary_cards.dart';
import '../widgets/time_series_chart.dart';
import '../widgets/top_products_preview.dart';
import 'category_analysis_page.dart';
import 'top_products_page.dart';

/// Sales Analytics V2 Page
/// Complete sales analysis with time range, charts, and drill-down
class SalesAnalyticsV2Page extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;

  const SalesAnalyticsV2Page({
    super.key,
    required this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<SalesAnalyticsV2Page> createState() =>
      _SalesAnalyticsV2PageState();
}

class _SalesAnalyticsV2PageState extends ConsumerState<SalesAnalyticsV2Page> {
  late String _companyId;

  /// Currently selected store ID (null = All Stores / Company-wide)
  String? _selectedStoreId;

  /// List of stores for the current company
  List<Map<String, dynamic>> _stores = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      _companyId = widget.companyId.isNotEmpty
          ? widget.companyId
          : appState.companyChoosen;

      _initializeStores();

      debugPrint('🟢 [SalesAnalyticsV2Page] initState - companyId: $_companyId, storeId: $_selectedStoreId');

      _loadData();
    });
  }

  /// Initialize stores list from app state
  void _initializeStores() {
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    final companies = userData['companies'] as List<dynamic>? ?? [];

    // Find current company and get its stores
    for (final company in companies) {
      final companyData = company as Map<String, dynamic>;
      if (companyData['company_id'] == _companyId) {
        final storesList = companyData['stores'] as List<dynamic>? ?? [];
        _stores = storesList
            .map((s) => s as Map<String, dynamic>)
            .toList();
        break;
      }
    }

    // Set initial store selection (null = All Stores)
    _selectedStoreId = widget.storeId;
  }

  /// Load data with current store selection
  void _loadData() {
    ref.read(salesAnalyticsV2NotifierProvider.notifier).loadData(
      companyId: _companyId,
      storeId: _selectedStoreId,
    );
  }

  /// Handle store selection change
  void _onStoreChanged(String? storeId) {
    setState(() {
      _selectedStoreId = storeId;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesAnalyticsV2NotifierProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Sales Analytics',
      ),
      body: Column(
        children: [
          // Store Selector
          _buildStoreSelector(),
          // Global Filter Bar (TimeRange + Metric)
          GlobalFilterBar(
            selectedTimeRange: state.selectedTimeRange,
            selectedMetric: state.selectedMetric,
            onTimeRangeChanged: (range) {
              ref.read(salesAnalyticsV2NotifierProvider.notifier).setTimeRange(
                    range,
                    companyId: _companyId,
                    storeId: _selectedStoreId,
                  );
            },
            onMetricChanged: (metric) {
              ref.read(salesAnalyticsV2NotifierProvider.notifier).setMetric(metric);
            },
          ),
          // Main Content
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  /// Store selector dropdown
  Widget _buildStoreSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Label
          Text(
            'View:',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Dropdown
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TossColors.gray200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedStoreId,
                  isExpanded: true,
                  isDense: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                  items: [
                    // "All Stores" option (company-wide)
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 16,
                            color: TossColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'All Stores (Company-wide)',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Individual stores
                    ..._stores.map((store) {
                      final storeId = store['store_id'] as String;
                      final storeName = store['store_name'] as String? ?? 'Store';
                      return DropdownMenuItem<String?>(
                        value: storeId,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                storeName,
                                style: TossTextStyles.body,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: _onStoreChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SalesAnalyticsV2State state) {
    debugPrint('🟡 [SalesAnalyticsV2Page] _buildBody - isLoading: ${state.isLoading}, hasData: ${state.hasData}');
    debugPrint('   → timeSeries.dataCount: ${state.timeSeries?.data.length ?? 0}');
    debugPrint('   → topProducts.dataCount: ${state.topProducts?.data.length ?? 0}');
    debugPrint('   → bcgMatrix.categoriesCount: ${state.bcgMatrix?.categories.length ?? 0}');
    debugPrint('   → error: ${state.error}');

    if (state.isLoading && !state.hasData) {
      return const TossLoadingView();
    }

    if (state.error != null && !state.hasData) {
      return TossErrorView(
        error: Exception(state.error),
        onRetry: _loadData,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(salesAnalyticsV2NotifierProvider.notifier).refresh(
            companyId: _companyId,
            storeId: _selectedStoreId,
          ),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // Summary Cards (with selected metric highlight)
            SummaryCards(
              summary: state.summary,
              revenueGrowth: state.timeSeries?.data.isNotEmpty == true
                  ? state.timeSeries!.data.first.revenueGrowth
                  : null,
              marginGrowth: state.timeSeries?.data.isNotEmpty == true
                  ? state.timeSeries!.data.first.marginGrowth
                  : null,
              quantityGrowth: state.timeSeries?.data.isNotEmpty == true
                  ? state.timeSeries!.data.first.quantityGrowth
                  : null,
              isLoading: state.isLoading,
              selectedMetric: state.selectedMetric,
            ),
            const SizedBox(height: TossSpacing.space4),

            // Time Series Chart (Category Trend)
            TimeSeriesChart(
              data: state.trendData,
              selectedMetric: state.selectedMetric,
              isLoading: state.isLoading || state.isCategoryTrendLoading,
              // Category filter
              availableCategories: state.availableCategories,
              selectedCategoryId: state.selectedCategoryId,
              selectedCategoryName: state.selectedCategoryName,
              onCategoryChanged: (categoryId) {
                ref.read(salesAnalyticsV2NotifierProvider.notifier).setCategory(
                      categoryId,
                      companyId: _companyId,
                      storeId: _selectedStoreId,
                    );
              },
              // Total time series data for daily percentage calculation
              totalTimeSeriesData: state.timeSeries?.data,
            ),
            const SizedBox(height: TossSpacing.space4),

            // BCG Matrix
            BcgMatrixChart(
              bcgMatrix: state.bcgMatrix,
              isLoading: state.isLoading,
              currencySymbol: state.currencySymbol,
              selectedMetric: state.selectedMetric,
            ),
            const SizedBox(height: TossSpacing.space4),

            // Top Products Preview (Phase 2: replaced Expand/Collapse with View All)
            TopProductsPreview(
              products: state.topProducts?.data ?? [],
              isLoading: state.isLoading,
              selectedMetric: state.selectedMetric,
              onViewAll: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => TopProductsPage(
                      products: state.topProducts?.data ?? [],
                      selectedMetric: state.selectedMetric,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: TossSpacing.space4),

            // Category Preview (Phase 3: replaced Expand/Collapse with View All)
            CategoryPreview(
              drillDownState: state.drillDownState,
              items: state.drillDownData?.data ?? [],
              isLoading: state.isDrillDownLoading,
              selectedMetric: state.selectedMetric,
              onBreadcrumbTap: (index) {
                ref.read(salesAnalyticsV2NotifierProvider.notifier).navigateToBreadcrumb(
                      index: index,
                      companyId: _companyId,
                      storeId: _selectedStoreId,
                    );
              },
              onViewAll: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => CategoryAnalysisPage(
                      companyId: _companyId,
                      storeId: _selectedStoreId,
                      initialDrillDownState: state.drillDownState,
                      initialItems: state.drillDownData?.data ?? [],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }
}
