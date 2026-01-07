import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../domain/entities/discrepancy_overview.dart';
import '../providers/discrepancy_provider.dart';
import '../widgets/analytics_widgets.dart';

/// 재고 불일치 분석 상세 페이지
class DiscrepancyPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;

  const DiscrepancyPage({
    super.key,
    required this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<DiscrepancyPage> createState() => _DiscrepancyPageState();
}

class _DiscrepancyPageState extends ConsumerState<DiscrepancyPage> {
  final _currencyFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(discrepancyProvider.notifier).loadData(
            companyId: widget.companyId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discrepancyProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: '재고 불일치',
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(DiscrepancyState state) {
    if (state.isLoading && !state.hasData) {
      return const TossLoadingView();
    }

    if (state.hasError && !state.hasData) {
      return TossErrorView(
        error: Exception(state.errorMessage ?? '데이터를 불러올 수 없습니다'),
        onRetry: () => ref.read(discrepancyProvider.notifier).loadData(
              companyId: widget.companyId,
            ),
      );
    }

    final data = state.data;

    // 데이터 부족 상태 처리
    if (data?.isInsufficientData == true) {
      return _buildInsufficientData(data!);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(discrepancyProvider.notifier).refresh(
            companyId: widget.companyId,
          ),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // 기간 필터
            _buildPeriodFilter(state.selectedPeriod),

            const SizedBox(height: TossSpacing.space4),

            // 요약 카드
            if (data != null) _buildSummaryCard(data),

            const SizedBox(height: TossSpacing.space4),

            // 매장별 현황
            if (data != null && data.stores.isNotEmpty) _buildStoreList(data),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// 데이터 부족 상태
  Widget _buildInsufficientData(DiscrepancyOverview data) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.analytics_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              '분석 데이터 부족',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              data.message ?? '재고 불일치 분석을 위한 데이터가 충분하지 않습니다',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.infoLight,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, color: TossColors.primary, size: 20),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    '재고 실사를 진행하면 분석이 가능합니다',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.primary,
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

  /// 기간 필터
  Widget _buildPeriodFilter(String selectedPeriod) {
    final periods = [
      ('7d', '7일'),
      ('30d', '30일'),
      ('all', '전체'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: periods.map((period) {
          final isSelected = selectedPeriod == period.$1;
          return Padding(
            padding: const EdgeInsets.only(right: TossSpacing.space2),
            child: GestureDetector(
              onTap: () => ref.read(discrepancyProvider.notifier).changePeriod(
                    companyId: widget.companyId,
                    period: period.$1,
                  ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.primary : TossColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? TossColors.primary : TossColors.gray300,
                  ),
                ),
                child: Text(
                  period.$2,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: isSelected ? TossColors.white : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 요약 카드
  Widget _buildSummaryCard(DiscrepancyOverview data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '불일치 현황',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: AnalyticsMetricTile(
                    label: '총 이벤트',
                    value: '${_currencyFormat.format(data.totalEvents)}건',
                    icon: Icons.event_note_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: TossColors.gray200,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: TossSpacing.space4),
                    child: AnalyticsMetricTile(
                      label: '순손익',
                      value: '${_currencyFormat.format(data.netValue)}원',
                      valueColor: data.netValue < 0 ? TossColors.error : TossColors.success,
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            _buildValueRow('증가 금액', data.totalIncreaseValue, TossColors.success),
            const SizedBox(height: TossSpacing.space2),
            _buildValueRow('감소 금액', data.totalDecreaseValue, TossColors.error),
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: _getStatusColor(data.analysisStatus).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '분석 상태',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  AnalyticsStatusBadge(
                    label: _getStatusLabel(data.analysisStatus),
                    status: data.analysisStatus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueRow(String label, num value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          '${_currencyFormat.format(value)}원',
          style: TossTextStyles.body.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      'critical' => TossColors.error,
      'warning' => TossColors.warning,
      'good' => TossColors.success,
      _ => TossColors.gray500,
    };
  }

  String _getStatusLabel(String status) {
    return switch (status) {
      'critical' => '주의 필요',
      'warning' => '관찰 필요',
      'good' => '양호',
      'insufficient' => '데이터 부족',
      _ => '알 수 없음',
    };
  }

  /// 매장별 현황
  Widget _buildStoreList(DiscrepancyOverview data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalyticsSectionHeader(
          title: '매장별 현황',
          subtitle: '${data.totalStores}개 매장',
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.stores.length,
          itemBuilder: (context, index) {
            final store = data.stores[index];
            return _buildStoreItem(store, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildStoreItem(StoreDiscrepancy store, int rank) {
    final status = store.status ?? 'normal';
    final statusForDisplay = switch (status) {
      'abnormal' => 'critical',
      'warning' => 'warning',
      _ => 'good',
    };

    return AnalyticsListItem(
      leading: RankIcon(rank: rank),
      title: store.storeName,
      subtitle: '${store.totalEvents}건 (증가: ${store.increaseCount}, 감소: ${store.decreaseCount})',
      value: '${_currencyFormat.format(store.netValue)}원',
      subValue: store.statusLabel,
      status: statusForDisplay,
    );
  }
}
