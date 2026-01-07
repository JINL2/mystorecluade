import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../domain/entities/supply_chain_status.dart';
import '../providers/supply_chain_provider.dart';
import '../widgets/analytics_widgets.dart';

/// 공급망 분석 상세 페이지
class SupplyChainPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;

  const SupplyChainPage({
    super.key,
    required this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<SupplyChainPage> createState() => _SupplyChainPageState();
}

class _SupplyChainPageState extends ConsumerState<SupplyChainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(supplyChainProvider.notifier).loadData(
            companyId: widget.companyId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplyChainProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: '공급망 분석',
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(SupplyChainState state) {
    if (state.isLoading && !state.hasData) {
      return const TossLoadingView();
    }

    if (state.hasError && !state.hasData) {
      return TossErrorView(
        error: Exception(state.errorMessage ?? '데이터를 불러올 수 없습니다'),
        onRetry: () => ref.read(supplyChainProvider.notifier).loadData(
              companyId: widget.companyId,
            ),
      );
    }

    final data = state.data;

    return RefreshIndicator(
      onRefresh: () => ref.read(supplyChainProvider.notifier).refresh(
            companyId: widget.companyId,
          ),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // 상태 요약
            if (data != null) _buildStatusSummary(data),

            const SizedBox(height: TossSpacing.space4),

            // 문제 제품 목록
            if (data != null) _buildProductList(data),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// 상태 요약 섹션
  Widget _buildStatusSummary(SupplyChainStatus data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  label: '심각',
                  count: data.criticalCount,
                  color: TossColors.error,
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: TossColors.gray200,
                ),
                _buildStatItem(
                  label: '주의',
                  count: data.warningCount,
                  color: TossColors.warning,
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: TossColors.gray200,
                ),
                _buildStatItem(
                  label: '전체',
                  count: data.urgentProducts.length,
                  color: TossColors.gray700,
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: data.status == 'critical'
                    ? TossColors.errorLight
                    : data.status == 'warning'
                        ? TossColors.warningLight
                        : TossColors.successLight,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    data.status == 'critical'
                        ? Icons.error_outline
                        : data.status == 'warning'
                            ? Icons.warning_amber_outlined
                            : Icons.check_circle_outline,
                    color: data.status == 'critical'
                        ? TossColors.error
                        : data.status == 'warning'
                            ? TossColors.warning
                            : TossColors.success,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      data.isEmpty
                          ? '공급망에 문제가 없습니다'
                          : data.criticalCount > 0
                              ? '${data.criticalCount}개 제품이 심각한 공급 문제를 겪고 있습니다'
                              : '${data.warningCount}개 제품에 주의가 필요합니다',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: data.status == 'critical'
                            ? TossColors.error
                            : data.status == 'warning'
                                ? TossColors.warning
                                : TossColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          '$count',
          style: TossTextStyles.h2.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }

  /// 문제 제품 목록 섹션
  Widget _buildProductList(SupplyChainStatus data) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: TossColors.success,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                '공급망에 문제가 없습니다',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                '모든 제품이 원활하게 공급되고 있습니다',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AnalyticsSectionHeader(
          title: '공급 문제 제품',
          subtitle: 'Error Integral 기준 정렬',
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.urgentProducts.length,
          itemBuilder: (context, index) {
            final product = data.urgentProducts[index];
            return _buildProductItem(product, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildProductItem(SupplyChainProduct product, int rank) {
    final numberFormat = NumberFormat('#,###');

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space1,
      ),
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RankIcon(rank: rank),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product.integralDescription,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                AnalyticsStatusBadge(
                  status: product.riskLevel.toLowerCase(),
                  label: product.riskLabel,
                ),
              ],
            ),
            const Divider(height: TossSpacing.space4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  label: '지연일수',
                  value: '${product.shortageDays}일',
                ),
                _buildDetailItem(
                  label: '평균 부족',
                  value: '${product.avgShortagePerDay.toStringAsFixed(1)}개/일',
                ),
                _buildDetailItem(
                  label: 'Error Integral',
                  value: numberFormat.format(product.errorIntegral),
                  valueColor: TossColors.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? TossColors.gray900,
          ),
        ),
      ],
    );
  }
}
