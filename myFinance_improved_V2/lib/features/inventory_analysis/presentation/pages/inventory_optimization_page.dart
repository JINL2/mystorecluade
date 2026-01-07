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
import '../widgets/analytics_widgets.dart';

/// 재고 최적화 상세 페이지
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
      appBar: TossAppBar(
        title: '재고 최적화',
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
        error: Exception(state.errorMessage ?? '데이터를 불러올 수 없습니다'),
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

            // 전체 점수
            if (state.dashboard != null) _buildScoreSection(state.dashboard!),

            const SizedBox(height: TossSpacing.space4),

            // 핵심 지표
            if (state.dashboard != null) _buildMetricsSection(state.dashboard!),

            const SizedBox(height: TossSpacing.space4),

            // 주문 필요 목록
            _buildReorderSection(state.reorderList ?? []),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// 전체 점수 섹션
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
              '재고 최적화 점수',
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

  /// 핵심 지표 섹션
  Widget _buildMetricsSection(InventoryOptimization dashboard) {
    final metrics = dashboard.metrics;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '핵심 지표',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            _buildMetricRow(
              label: '품절률',
              value: '${metrics.stockoutRate.toStringAsFixed(1)}%',
              status: metrics.stockoutStatus,
              description: '3% 이하 권장',
            ),
            const Divider(height: TossSpacing.space4),
            _buildMetricRow(
              label: '과잉재고율',
              value: '${metrics.overstockRate.toStringAsFixed(1)}%',
              status: metrics.overstockStatus,
              description: '5% 이하 권장',
            ),
            const Divider(height: TossSpacing.space4),
            _buildMetricRow(
              label: '평균 재고회전율',
              value: '${metrics.avgTurnover.toStringAsFixed(1)}회',
              status: metrics.turnoverStatus,
              description: '5회 이상 권장',
            ),
            const Divider(height: TossSpacing.space4),
            _buildMetricRow(
              label: '주문 필요',
              value: '${metrics.reorderNeeded}개',
              status: metrics.reorderNeeded == 0 ? 'good' : 'warning',
              description: '재주문 필요 제품 수',
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

  /// 주문 필요 목록 섹션
  Widget _buildReorderSection(List<ReorderProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalyticsSectionHeader(
          title: '주문 필요 제품',
          subtitle: '${products.length}개 제품',
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
                    '주문이 필요한 제품이 없습니다',
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
        const PopupMenuItem(value: null, child: Text('전체')),
        const PopupMenuItem(value: 'critical', child: Text('긴급')),
        const PopupMenuItem(value: 'warning', child: Text('주의')),
        const PopupMenuItem(value: 'normal', child: Text('보통')),
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
                  ? '전체'
                  : _selectedPriority == 'critical'
                      ? '긴급'
                      : _selectedPriority == 'warning'
                          ? '주의'
                          : '보통',
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
      subtitle: product.categoryName ?? '카테고리 없음',
      status: product.priority,
      value: '${numberFormat.format(product.orderQty)}개 주문',
      subValue: product.daysLeftText,
    );
  }
}
