import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/index.dart';
import '../../../shared/presentation/widgets/analytics_widgets.dart';
import '../../domain/entities/inventory_health_dashboard.dart';
import '../providers/inventory_optimization_providers.dart';

/// Inventory Health Dashboard Page (V2)
///
/// Sales Analytics와 동일한 디자인 패턴 사용:
/// - StoreSelector (View: dropdown)
/// - SummaryCards (수평 스크롤)
/// - SectionHeader + ListItems
class InventoryOptimizationPage extends ConsumerStatefulWidget {
  final String? companyId;
  final String? storeId;

  const InventoryOptimizationPage({
    super.key,
    this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<InventoryOptimizationPage> createState() =>
      _InventoryOptimizationPageState();
}

class _InventoryOptimizationPageState
    extends ConsumerState<InventoryOptimizationPage> {
  late String _companyId;
  String? _selectedStoreId;
  List<Map<String, dynamic>> _stores = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final appState = ref.read(appStateProvider);
    _companyId = widget.companyId?.isNotEmpty == true
        ? widget.companyId!
        : appState.companyChoosen;

    _initializeStores();
    _selectedStoreId = widget.storeId;
  }

  void _initializeStores() {
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    final companies = userData['companies'] as List<dynamic>? ?? [];

    for (final company in companies) {
      final companyData = company as Map<String, dynamic>;
      if (companyData['company_id'] == _companyId) {
        final storesList = companyData['stores'] as List<dynamic>? ?? [];
        _stores = storesList.map((s) => s as Map<String, dynamic>).toList();
        break;
      }
    }
  }

  HealthDashboardFilter get _filter => HealthDashboardFilter(
        companyId: _companyId,
        storeId: _selectedStoreId,
      );

  void _onStoreChanged(String? storeId) {
    setState(() {
      _selectedStoreId = storeId;
    });
    ref.invalidate(inventoryHealthDashboardProvider(_filter));
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = widget.companyId?.isNotEmpty == true
        ? widget.companyId!
        : appState.companyChoosen;

    if (companyId.isEmpty) {
      return const TossScaffold(
        appBar: TossAppBar(title: 'Inventory Health'),
        body: TossEmptyView(
          icon: Icon(Icons.business_outlined, size: 48),
          title: 'No Company Selected',
          description: 'Please select a company first',
        ),
      );
    }

    _companyId = companyId;
    if (_stores.isEmpty) {
      _initializeStores();
    }

    final dashboardAsync = ref.watch(inventoryHealthDashboardProvider(_filter));

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Inventory Health',
      ),
      body: Column(
        children: [
          // Store Selector (Sales Analytics와 동일)
          _buildStoreSelector(),
          // Main Content
          Expanded(
            child: dashboardAsync.when(
              loading: () => const TossLoadingView(),
              error: (error, stack) => TossErrorView(
                error: error,
                onRetry: () {
                  ref.invalidate(inventoryHealthDashboardProvider(_filter));
                },
              ),
              data: (dashboard) => _buildContent(dashboard),
            ),
          ),
        ],
      ),
    );
  }

  /// Store Selector (Sales Analytics와 동일한 스타일)
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
          Icon(
            Icons.store_outlined,
            size: 20,
            color: TossColors.textSecondary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.button),
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
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 16,
                            color: TossColors.primary,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'All Stores',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._stores.map((store) {
                      final storeId = store['store_id'] as String;
                      final storeName =
                          store['store_name'] as String? ?? 'Store';
                      return DropdownMenuItem<String?>(
                        value: storeId,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space2),
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

  Widget _buildContent(InventoryHealthDashboard dashboard) {
    final summary = dashboard.summary;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(inventoryHealthDashboardProvider(_filter));
      },
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // 1. Overview Section Header
            const AnalyticsSectionHeader(title: 'Overview'),

            // 2. Summary Cards (Sales Analytics와 동일한 수평 스크롤)
            _buildSummaryCards(summary),
            const SizedBox(height: TossSpacing.space4),

            // 3. Status Breakdown Cards (6개 카드를 2열 그리드로)
            _buildStatusGrid(summary),
            const SizedBox(height: TossSpacing.space4),

            // 4. Urgent Products Section
            if (dashboard.urgentProducts.isNotEmpty) ...[
              _buildProductsSection(
                title: 'Urgent Reorder',
                subtitle: 'High sales velocity, low stock',
                products: dashboard.urgentProducts,
                status: 'critical',
              ),
              const SizedBox(height: TossSpacing.space4),
            ],

            // 5. Normal Products Section
            if (dashboard.normalProducts.isNotEmpty) ...[
              _buildProductsSection(
                title: 'Normal Reorder',
                subtitle: 'Low sales velocity, plan ahead',
                products: dashboard.normalProducts,
                status: 'warning',
              ),
              const SizedBox(height: TossSpacing.space4),
            ],

            // 6. Overstock Products
            if (dashboard.overstockProducts.isNotEmpty) ...[
              _buildOverstockSection(dashboard.overstockProducts),
              const SizedBox(height: TossSpacing.space4),
            ],

            // 8. Recount Products (음수 재고 - 제일 하단)
            if (dashboard.recountProducts.isNotEmpty) ...[
              _buildRecountSection(dashboard.recountProducts),
              const SizedBox(height: TossSpacing.space4),
            ],

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// Summary Cards (3개 카드를 한 줄에 균등 배치)
  Widget _buildSummaryCards(HealthSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: _InventorySummaryCard(
              title: 'Total Products',
              value: summary.totalProducts,
              icon: Icons.inventory_2_outlined,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: _InventorySummaryCard(
              title: 'Reorder Needed',
              value: summary.totalReorderNeeded,
              icon: Icons.shopping_cart_outlined,
              color: TossColors.amber,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: _InventorySummaryCard(
              title: 'Sufficient',
              value: summary.sufficientCount,
              percentage: summary.sufficientPct,
              icon: Icons.check_circle_outline,
              color: TossColors.success,
            ),
          ),
        ],
      ),
    );
  }

  /// Status Grid (6개 카드를 2열로 배치)
  Widget _buildStatusGrid(HealthSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatusCard(
                  title: 'Urgent',
                  count: summary.urgentCount,
                  percentage: summary.urgentPct,
                  icon: Icons.warning_amber_outlined,
                  status: 'critical',
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _StatusCard(
                  title: 'Normal',
                  count: summary.normalCount,
                  percentage: summary.normalPct,
                  icon: Icons.schedule_outlined,
                  status: 'warning',
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Expanded(
                child: _StatusCard(
                  title: 'Sufficient',
                  count: summary.sufficientCount,
                  percentage: summary.sufficientPct,
                  icon: Icons.check_circle_outline,
                  status: 'good',
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _StatusCard(
                  title: 'Overstock',
                  count: summary.overstockCount,
                  percentage: summary.overstockPct,
                  icon: Icons.inventory_outlined,
                  status: 'info',
                ),
              ),
            ],
          ),
          if (summary.recountCount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _StatusCard(
              title: 'Recount Needed',
              count: summary.recountCount,
              percentage: summary.recountPct,
              icon: Icons.error_outline,
              status: 'critical',
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }

  /// Recount Section (음수 재고 - 특별 강조)
  Widget _buildRecountSection(List<RecountProduct> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        backgroundColor: TossColors.errorLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TossColors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: TossColors.error,
                    size: 24,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory Recount Needed',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.error,
                        ),
                      ),
                      Text(
                        'Negative stock detected - physical count required',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.error.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),
            const Divider(height: 1, color: TossColors.error),
            const SizedBox(height: TossSpacing.space3),
            ...products.take(10).map((p) => _RecountItem(product: p)),
            if (products.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: TossSpacing.space2),
                child: Text(
                  '+${products.length - 10} more items',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Products Section (AnalyticsListItem 사용)
  Widget _buildProductsSection({
    required String title,
    required String subtitle,
    required List<HealthProduct> products,
    required String status,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalyticsSectionHeader(
          title: title,
          subtitle: subtitle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: TossCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: products.take(5).map((p) {
                final displayName = _buildProductDisplayName(
                  p.productName,
                  p.variantName,
                );
                return AnalyticsListItem(
                  title: displayName,
                  sku: p.sku,
                  subtitle: p.categoryName,
                  value: '${p.currentStock}',
                  subValue: p.daysOfInventory > 0
                      ? '${p.daysOfInventory.toStringAsFixed(0)}d left'
                      : 'in stock',
                  status: status,
                  orderQty: p.recommendedOrderQty,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// Overstock Section
  Widget _buildOverstockSection(List<OverstockProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AnalyticsSectionHeader(
          title: 'Overstock',
          subtitle: 'Excess inventory, consider promotions',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: TossCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: products.take(5).map((p) {
                final displayName = _buildProductDisplayName(
                  p.productName,
                  p.variantName,
                );
                return AnalyticsListItem(
                  title: displayName,
                  sku: p.sku,
                  subtitle: p.categoryName,
                  value: '${p.currentStock}',
                  subValue: '${p.monthsOfInventory.toStringAsFixed(1)}mo supply',
                  leading: Container(
                    width: 8,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TossColors.purple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// 제품명 표시 포맷: "제품명" 또는 "제품명 - variant"
  /// SKU는 별도 행으로 표시됨
  String _buildProductDisplayName(
    String productName,
    String? variantName,
  ) {
    final buffer = StringBuffer(productName);
    if (variantName?.isNotEmpty == true) {
      buffer.write(' - $variantName');
    }
    return buffer.toString();
  }
}

// =============================================================================
// Helper Widgets (Sales Analytics 스타일)
// =============================================================================

/// Summary Card (Sales Analytics의 _SummaryCard와 동일)
class _InventorySummaryCard extends StatelessWidget {
  final String title;
  final int value;
  final double? percentage;
  final IconData icon;
  final Color color;

  const _InventorySummaryCard({
    required this.title,
    required this.value,
    this.percentage,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            _formatNumber(value),
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          if (percentage != null)
            TossBadge(
              label: '${percentage!.toStringAsFixed(1)}%',
              backgroundColor: color.withValues(alpha: 0.1),
              textColor: color,
            )
          else
            Icon(icon, size: 16, color: color),
        ],
      ),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return '$value';
  }
}

/// Status Card (AnalyticsSummaryCardWidget와 유사)
class _StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final double percentage;
  final IconData icon;
  final String status;
  final bool fullWidth;

  const _StatusCard({
    required this.title,
    required this.count,
    required this.percentage,
    required this.icon,
    required this.status,
    this.fullWidth = false,
  });

  Color get _statusColor {
    return switch (status) {
      'good' => TossColors.success,
      'warning' => TossColors.warning,
      'critical' => TossColors.error,
      'info' => TossColors.purple,
      _ => TossColors.gray500,
    };
  }

  Color get _statusBgColor {
    return switch (status) {
      'good' => TossColors.successLight,
      'warning' => TossColors.warningLight,
      'critical' => TossColors.errorLight,
      'info' => TossColors.purpleLight,
      _ => TossColors.gray100,
    };
  }

  @override
  Widget build(BuildContext context) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _statusBgColor,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              icon,
              color: _statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$count',
                      style: TossTextStyles.h4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${percentage.toStringAsFixed(1)}%)',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Recount Item
class _RecountItem extends StatelessWidget {
  final RecountProduct product;

  const _RecountItem({required this.product});

  String _buildDisplayName() {
    final buffer = StringBuffer(product.productName);
    if (product.variantName?.isNotEmpty == true) {
      buffer.write(' - ${product.variantName}');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildDisplayName(),
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // SKU (제품명 아래 별도 줄)
                if (product.sku?.isNotEmpty == true)
                  Text(
                    product.sku!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                Text(
                  product.categoryName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: TossColors.error,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Text(
              '${product.currentStock}',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
