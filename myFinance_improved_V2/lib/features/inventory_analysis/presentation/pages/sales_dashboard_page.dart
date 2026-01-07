import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';

import '../../domain/entities/analytics_entities.dart';
import '../providers/sales_dashboard_provider.dart';
import '../widgets/analytics_widgets.dart';

/// 수익률 분석 상세 페이지
class SalesDashboardPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;

  const SalesDashboardPage({
    super.key,
    required this.companyId,
    this.storeId,
  });

  @override
  ConsumerState<SalesDashboardPage> createState() => _SalesDashboardPageState();
}

class _SalesDashboardPageState extends ConsumerState<SalesDashboardPage> {
  final _currencyFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesDashboardProvider.notifier).loadData(
            companyId: widget.companyId,
            storeId: widget.storeId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesDashboardProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: '수익률 분석',
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(SalesDashboardState state) {
    if (state.isLoading && !state.hasData) {
      return const TossLoadingView();
    }

    if (state.hasError && !state.hasData) {
      return TossErrorView(
        error: Exception(state.errorMessage ?? '데이터를 불러올 수 없습니다'),
        onRetry: () => ref.read(salesDashboardProvider.notifier).loadData(
              companyId: widget.companyId,
              storeId: widget.storeId,
            ),
      );
    }

    final data = state.data;
    final bcgMatrix = state.bcgMatrix;

    return RefreshIndicator(
      onRefresh: () => ref.read(salesDashboardProvider.notifier).refresh(
            companyId: widget.companyId,
            storeId: widget.storeId,
          ),
      color: TossColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space4),

            // 핵심 지표 요약
            if (data != null) _buildMetricsSummary(data),

            const SizedBox(height: TossSpacing.space4),

            // 월간 비교
            if (data != null) _buildMonthlyComparison(data),

            const SizedBox(height: TossSpacing.space4),

            // BCG Matrix
            if (bcgMatrix != null) _buildBcgMatrix(bcgMatrix),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// 핵심 지표 요약
  Widget _buildMetricsSummary(SalesDashboard data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이번 달 실적',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: AnalyticsMetricTile(
                    label: '총 매출',
                    value: '${_currencyFormat.format(data.thisMonth.revenue)}원',
                    trend: data.growth.revenuePct != 0
                        ? '${data.growth.revenuePct > 0 ? '+' : ''}${data.growth.revenuePct.toStringAsFixed(1)}%'
                        : null,
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
                      label: '총 마진',
                      value: '${_currencyFormat.format(data.thisMonth.margin)}원',
                      trend: data.growth.marginPct != 0
                          ? '${data.growth.marginPct > 0 ? '+' : ''}${data.growth.marginPct.toStringAsFixed(1)}%'
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: AnalyticsMetricTile(
                    label: '마진율',
                    value: '${data.thisMonth.marginRate.toStringAsFixed(1)}%',
                    valueColor: data.thisMonth.marginRate >= 20
                        ? TossColors.success
                        : data.thisMonth.marginRate >= 10
                            ? TossColors.warning
                            : TossColors.error,
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
                      label: '판매량',
                      value: '${_currencyFormat.format(data.thisMonth.quantity)}개',
                      trend: data.growth.quantityPct != 0
                          ? '${data.growth.quantityPct > 0 ? '+' : ''}${data.growth.quantityPct.toStringAsFixed(1)}%'
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 월간 비교 섹션
  Widget _buildMonthlyComparison(SalesDashboard data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '전월 대비',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            _buildComparisonRow(
              label: '매출',
              thisMonth: data.thisMonth.revenue,
              lastMonth: data.lastMonth.revenue,
              growth: data.growth.revenuePct,
            ),
            const SizedBox(height: TossSpacing.space3),
            _buildComparisonRow(
              label: '마진',
              thisMonth: data.thisMonth.margin,
              lastMonth: data.lastMonth.margin,
              growth: data.growth.marginPct,
            ),
            const SizedBox(height: TossSpacing.space3),
            _buildComparisonRow(
              label: '판매량',
              thisMonth: data.thisMonth.quantity.toDouble(),
              lastMonth: data.lastMonth.quantity.toDouble(),
              growth: data.growth.quantityPct,
              isQuantity: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow({
    required String label,
    required num thisMonth,
    required num lastMonth,
    required num growth,
    bool isQuantity = false,
  }) {
    final thisValue = isQuantity
        ? '${_currencyFormat.format(thisMonth)}개'
        : '${_currencyFormat.format(thisMonth)}원';
    final lastValue = isQuantity
        ? '${_currencyFormat.format(lastMonth)}개'
        : '${_currencyFormat.format(lastMonth)}원';

    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이번 달',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  Text(
                    thisValue,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '지난 달',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  Text(
                    lastValue,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: growth >= 0
                      ? TossColors.successLight
                      : TossColors.errorLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                  style: TossTextStyles.caption.copyWith(
                    color: growth >= 0 ? TossColors.success : TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// BCG Matrix 섹션
  Widget _buildBcgMatrix(BcgMatrix bcgMatrix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalyticsSectionHeader(
          title: 'BCG 매트릭스',
          subtitle: '카테고리별 성장률 × 시장점유율 분석',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: TossCard(
            child: SizedBox(
              height: 300,
              child: _buildBcgChart(bcgMatrix),
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        _buildBcgLegend(bcgMatrix),
      ],
    );
  }

  Widget _buildBcgChart(BcgMatrix bcgMatrix) {
    final spots = bcgMatrix.categories.map((cat) {
      return ScatterSpot(
        cat.salesVolumePercentile.toDouble(),
        cat.marginPercentile.toDouble(),
        dotPainter: FlDotCirclePainter(
          radius: 8 + (cat.totalRevenue / 1000000).clamp(2, 12).toDouble(),
          color: _getQuadrantColor(cat.quadrant),
          strokeWidth: 2,
          strokeColor: TossColors.white,
        ),
      );
    }).toList();

    return ScatterChart(
      ScatterChartData(
        scatterSpots: spots,
        minX: -50,
        maxX: 50,
        minY: 0,
        maxY: 50,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: 25,
          verticalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: TossColors.gray200,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: value == 0 ? TossColors.gray400 : TossColors.gray200,
            strokeWidth: value == 0 ? 2 : 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: Text(
              '시장점유율(%)',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
            sideTitles: const SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(
              '성장률(%)',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
            sideTitles: const SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        scatterTouchData: ScatterTouchData(
          enabled: true,
          touchTooltipData: ScatterTouchTooltipData(
            getTooltipColor: (_) => TossColors.gray800,
            getTooltipItems: (spot) {
              final index = spots.indexOf(spot);
              if (index >= 0 && index < bcgMatrix.categories.length) {
                final cat = bcgMatrix.categories[index];
                return ScatterTooltipItem(
                  '${cat.categoryName}\n판매량: ${cat.salesVolumePercentile.toStringAsFixed(1)}%\n마진율: ${cat.marginPercentile.toStringAsFixed(1)}%',
                  textStyle: TossTextStyles.caption.copyWith(
                    color: TossColors.white,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBcgLegend(BcgMatrix bcgMatrix) {
    final quadrants = [
      ('star', '스타', '고성장 · 고점유', TossColors.success),
      ('cash_cow', '캐시카우', '저성장 · 고점유', TossColors.primary),
      ('problem_child', '문제아', '고성장 · 저점유', TossColors.warning),
      ('dog', '도그', '저성장 · 저점유', TossColors.error),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Wrap(
        spacing: TossSpacing.space3,
        runSpacing: TossSpacing.space2,
        children: quadrants.map((q) {
          final count = bcgMatrix.categories
              .where((c) => c.quadrant == q.$1)
              .length;
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: q.$4.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: q.$4,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${q.$2} ($count)',
                  style: TossTextStyles.caption.copyWith(
                    color: q.$4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getQuadrantColor(String quadrant) {
    return switch (quadrant) {
      'star' => TossColors.success,
      'cash_cow' => TossColors.primary,
      'problem_child' => TossColors.warning,
      'dog' => TossColors.error,
      _ => TossColors.gray500,
    };
  }
}
