import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../domain/entities/inventory_optimization.dart';
import '../providers/inventory_optimization_provider.dart';
import '../../../shared/presentation/widgets/analytics_widgets.dart';

/// Inventory Optimization Detail Page
class InventoryOptimizationPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;

  const InventoryOptimizationPage({
    super.key,
    required this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<InventoryOptimizationPage> createState() =>
      _InventoryOptimizationPageState();
}

class _InventoryOptimizationPageState
    extends ConsumerState<InventoryOptimizationPage> {
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryOptimizationProvider.notifier).loadData(
            companyId: widget.companyId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryOptimizationProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar(
        title: 'Inventory Optimization',
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(InventoryOptimizationState state) {
    if (state.isLoading && !state.hasData) {
      return const TossLoadingView();
    }

    if (state.hasError && !state.hasData) {
      return TossErrorView(
        error: Exception(state.errorMessage ?? 'Failed to load data'),
        onRetry: () =>
            ref.read(inventoryOptimizationProvider.notifier).loadData(
                  companyId: widget.companyId,
                ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(inventoryOptimizationProvider.notifier).refresh(
                companyId: widget.companyId,
              ),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // Overall Score
            if (state.dashboard != null) _buildScoreSection(state.dashboard!),

            const SizedBox(height: TossSpacing.space4),

            // Key Metrics
            if (state.dashboard != null) _buildMetricsSection(state.dashboard!),

            const SizedBox(height: TossSpacing.space4),

            // Reorder List
            _buildReorderSection(state.reorderList ?? []),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// Overall Score Section
  Widget _buildScoreSection(InventoryOptimization dashboard) {
    final statusColor = switch (dashboard.status) {
      'good' => TossColors.success,
      'warning' => TossColors.warning,
      _ => TossColors.error,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          children: [
            Text(
              'Optimization Score',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${dashboard.overallScore}',
                  style: TossTextStyles.h1.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                Text(
                  ' / 100',
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),
            AnalyticsStatusBadge(
              status: dashboard.status,
              large: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Key Metrics Section
  Widget _buildMetricsSection(InventoryOptimization dashboard) {
    final metrics = dashboard.metrics;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Metrics',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            _buildMetricRow(
              label: 'Stockout Rate',
              value: '${metrics.stockoutRate.toStringAsFixed(1)}%',
              status: metrics.stockoutStatus,
              description: 'Recommended: <= 3%',
            ),
            const Divider(height: TossSpacing.space4),
            _buildMetricRow(
              label: 'Overstock Rate',
              value: '${metrics.overstockRate.toStringAsFixed(1)}%',
              status: metrics.overstockStatus,
              description: 'Recommended: <= 5%',
            ),
            const Divider(height: TossSpacing.space4),
            _buildMetricRow(
              label: 'Avg Turnover',
              value: '${metrics.avgTurnover.toStringAsFixed(1)}x',
              status: metrics.turnoverStatus,
              description: 'Recommended: >= 5x',
            ),
            const Divider(height: TossSpacing.space4),
            _buildMetricRow(
              label: 'Reorder Needed',
              value: '${metrics.reorderNeeded}',
              status: metrics.reorderNeeded == 0 ? 'good' : 'warning',
              description: 'Products needing reorder',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required String label,
    required String value,
    required String status,
    required String description,
  }) {
    final statusColor = switch (status) {
      'good' => TossColors.success,
      'warning' => TossColors.warning,
      _ => TossColors.error,
    };

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TossTextStyles.h4.copyWith(
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Reorder List Section
  Widget _buildReorderSection(List<ReorderProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalyticsSectionHeader(
          title: 'Products to Reorder',
          subtitle: '${products.length} products',
          trailing: _buildPriorityFilter(),
        ),
        const SizedBox(height: TossSpacing.space2),
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: TossColors.success,
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'No products need reordering',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildReorderItem(product);
            },
          ),
      ],
    );
  }

  Widget _buildPriorityFilter() {
    return PopupMenuButton<String?>(
      initialValue: _selectedPriority,
      onSelected: (value) {
        setState(() => _selectedPriority = value);
        ref.read(inventoryOptimizationProvider.notifier).filterByPriority(
              companyId: widget.companyId,
              priority: value,
            );
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('All')),
        const PopupMenuItem(value: 'critical', child: Text('Critical')),
        const PopupMenuItem(value: 'warning', child: Text('Warning')),
        const PopupMenuItem(value: 'normal', child: Text('Normal')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: TossColors.gray300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedPriority == null
                  ? 'All'
                  : _selectedPriority == 'critical'
                      ? 'Critical'
                      : _selectedPriority == 'warning'
                          ? 'Warning'
                          : 'Normal',
              style: TossTextStyles.bodySmall,
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderItem(ReorderProduct product) {
    final numberFormat = NumberFormat('#,###');

    return AnalyticsListItem(
      title: product.productName,
      subtitle: product.categoryName ?? 'Uncategorized',
      status: product.priority,
      value: '${numberFormat.format(product.orderQty)} to order',
      subValue: product.daysLeftText,
    );
  }
}
