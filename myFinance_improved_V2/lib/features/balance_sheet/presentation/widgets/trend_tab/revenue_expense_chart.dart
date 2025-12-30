import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/daily_pnl.dart';

/// Revenue vs Expense bar chart widget
class RevenueExpenseChart extends StatelessWidget {
  final List<DailyPnl> data;
  final String currencySymbol;

  const RevenueExpenseChart({
    super.key,
    required this.data,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
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
                barGroups: _buildBarGroups(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateBarInterval(),
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
                        if (index < 0 || index >= data.length) {
                          return const SizedBox.shrink();
                        }
                        if (data.length > 14 && index % 2 != 0) {
                          return const SizedBox.shrink();
                        }
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
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(TossSpacing.space2),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (groupIndex < 0 || groupIndex >= data.length) {
                        return null;
                      }
                      final item = data[groupIndex];
                      final formatter = NumberFormat('#,##0', 'en_US');
                      final label = rodIndex == 0 ? 'Revenue' : 'Expenses';
                      final value =
                          rodIndex == 0 ? item.revenue : (item.cogs + item.opex);
                      return BarTooltipItem(
                        '$label\n$currencySymbol${formatter.format(value)}',
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

  List<BarChartGroupData> _buildBarGroups() {
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

  double _calculateBarInterval() {
    if (data.isEmpty) return 10;
    final maxRevenue =
        data.map((d) => d.revenue / 1000000).reduce((a, b) => a > b ? a : b);
    if (maxRevenue <= 50) return 10;
    if (maxRevenue <= 100) return 20;
    return 50;
  }
}
