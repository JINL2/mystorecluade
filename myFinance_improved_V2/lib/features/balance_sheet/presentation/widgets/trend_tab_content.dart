import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../data/models/pnl_summary_dto.dart';
import '../providers/financial_statements_provider.dart';

/// Trend Tab Content - P&L Charts
class TrendTabContent extends ConsumerStatefulWidget {
  final String companyId;
  final String? storeId;
  final String currencySymbol;

  const TrendTabContent({
    super.key,
    required this.companyId,
    this.storeId,
    required this.currencySymbol,
  });

  @override
  ConsumerState<TrendTabContent> createState() => _TrendTabContentState();
}

class _TrendTabContentState extends ConsumerState<TrendTabContent> {
  int _selectedPeriodDays = 7; // 7, 30, 90

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: _selectedPeriodDays - 1));

    final params = TrendParams(
      companyId: widget.companyId,
      startDate: startDate,
      endDate: today,
      storeId: widget.storeId,
    );

    final trendAsync = ref.watch(dailyPnlTrendProvider(params));

    return Column(
      children: [
        // Period Selector
        _buildPeriodSelector(),

        // Content
        Expanded(
          child: trendAsync.when(
            data: (data) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(dailyPnlTrendProvider(params));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        children: [
                          // Net Income Chart
                          _buildNetIncomeChart(data),

                          const SizedBox(height: TossSpacing.space4),

                          // Revenue vs Expense Chart
                          _buildRevenueExpenseChart(data),

                          const SizedBox(height: TossSpacing.space4),

                          // Daily Summary List
                          _buildDailySummaryList(data),

                          const SizedBox(height: TossSpacing.space8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const TossLoadingView(),
            error: (error, _) => _buildError(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          _buildPeriodChip(7, '7 Days'),
          const SizedBox(width: TossSpacing.space2),
          _buildPeriodChip(30, '30 Days'),
          const SizedBox(width: TossSpacing.space2),
          _buildPeriodChip(90, '90 Days'),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(int days, String label) {
    final isSelected = _selectedPeriodDays == days;

    return GestureDetector(
      onTap: () => setState(() => _selectedPeriodDays = days),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.gray900 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNetIncomeChart(List<DailyPnlModel> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.netIncome / 1000000);
    }).toList();

    // Calculate min/max for Y axis
    final values = data.map((d) => d.netIncome / 1000000).toList();
    final minY = values.isEmpty ? -100.0 : (values.reduce((a, b) => a < b ? a : b) - 10);
    final maxY = values.isEmpty ? 100.0 : (values.reduce((a, b) => a > b ? a : b) + 10);

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Income Trend',
            style: TossTextStyles.bodyMedium.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'in millions (${widget.currencySymbol}M)',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(minY, maxY),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: TossColors.gray100,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}M',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: _calculateXInterval(data.length),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= data.length) return const SizedBox.shrink();
                        return Text(
                          DateFormat('d').format(data[index].date),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: TossColors.gray900,
                    barWidth: 2,
                    dotData: FlDotData(
                      show: data.length <= 14,
                      getDotPainter: (spot, percent, barData, index) {
                        final isProfit = spot.y >= 0;
                        return FlDotCirclePainter(
                          radius: 3,
                          color: isProfit ? TossColors.success : TossColors.error,
                          strokeWidth: 0,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          TossColors.gray900.withOpacity(0.1),
                          TossColors.gray900.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.spotIndex;
                        if (index < 0 || index >= data.length) return null;
                        final item = data[index];
                        final formatter = NumberFormat('#,##0', 'en_US');
                        return LineTooltipItem(
                          '${DateFormat('MMM d').format(item.date)}\n${widget.currencySymbol}${formatter.format(item.netIncome)}',
                          TossTextStyles.caption.copyWith(
                            color: TossColors.white,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueExpenseChart(List<DailyPnlModel> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Revenue vs Expenses',
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildChartLegend(),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                barGroups: _buildBarGroups(data),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateBarInterval(data),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: TossColors.gray100,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}M',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= data.length) return const SizedBox.shrink();
                        if (data.length > 14 && index % 2 != 0) return const SizedBox.shrink();
                        return Text(
                          DateFormat('d').format(data[index].date),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (groupIndex < 0 || groupIndex >= data.length) return null;
                      final item = data[groupIndex];
                      final formatter = NumberFormat('#,##0', 'en_US');
                      final label = rodIndex == 0 ? 'Revenue' : 'Expenses';
                      final value = rodIndex == 0 ? item.revenue : (item.cogs + item.opex);
                      return BarTooltipItem(
                        '$label\n${widget.currencySymbol}${formatter.format(value)}',
                        TossTextStyles.caption.copyWith(color: TossColors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLegendItem('Revenue', TossColors.gray300),
        const SizedBox(width: TossSpacing.space3),
        _buildLegendItem('Expenses', TossColors.gray600),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<DailyPnlModel> data) {
    return data.asMap().entries.map((entry) {
      final revenue = entry.value.revenue / 1000000;
      final expenses = (entry.value.cogs + entry.value.opex) / 1000000;

      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: revenue,
            color: TossColors.gray300,
            width: data.length > 14 ? 4 : 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
          BarChartRodData(
            toY: expenses,
            color: TossColors.gray600,
            width: data.length > 14 ? 4 : 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildDailySummaryList(List<DailyPnlModel> data) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final reversed = data.reversed.toList();

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Daily Summary',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(height: 1, color: TossColors.gray100),
          ...reversed.take(10).map((item) {
            final isProfit = item.netIncome >= 0;
            final isToday = _isToday(item.date);

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: TossColors.gray100),
                ),
              ),
              child: Row(
                children: [
                  // Date
                  SizedBox(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM d').format(item.date),
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray900,
                            fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        if (isToday)
                          Text(
                            'Today',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Revenue
                  Expanded(
                    child: Text(
                      '${widget.currencySymbol}${formatter.format(item.revenue)}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  const SizedBox(width: TossSpacing.space2),

                  // Arrow
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: TossColors.gray400,
                  ),

                  const SizedBox(width: TossSpacing.space2),

                  // Net Income
                  SizedBox(
                    width: 100,
                    child: Text(
                      '${isProfit ? '' : '-'}${widget.currencySymbol}${formatter.format(item.netIncome.abs())}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: isProfit ? TossColors.gray900 : TossColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  double _calculateInterval(double min, double max) {
    final range = max - min;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    if (range <= 200) return 50;
    return 100;
  }

  double _calculateXInterval(int dataLength) {
    if (dataLength <= 7) return 1;
    if (dataLength <= 14) return 2;
    if (dataLength <= 30) return 5;
    return 10;
  }

  double _calculateBarInterval(List<DailyPnlModel> data) {
    if (data.isEmpty) return 10;
    final maxRevenue = data.map((d) => d.revenue / 1000000).reduce((a, b) => a > b ? a : b);
    if (maxRevenue <= 50) return 10;
    if (maxRevenue <= 100) return 20;
    return 50;
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load trend data',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
