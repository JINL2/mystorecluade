import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/daily_pnl.dart';

/// Net income trend chart widget
class NetIncomeChart extends StatelessWidget {
  final List<DailyPnl> data;
  final String currencySymbol;

  const NetIncomeChart({
    super.key,
    required this.data,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.netIncome / 1000000);
    }).toList();

    final values = data.map((d) => d.netIncome / 1000000).toList();
    final minY =
        values.isEmpty ? -100.0 : (values.reduce((a, b) => a < b ? a : b) - 10);
    final maxY =
        values.isEmpty ? 100.0 : (values.reduce((a, b) => a > b ? a : b) + 10);

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
          Text(
            'Net Income Trend',
            style: TossTextStyles.bodyMediumBold,
          ),
          Text(
            'in millions (${currencySymbol}M)',
            style: TossTextStyles.captionGray500,
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
                        style: TossTextStyles.captionGray500,
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
                        if (index < 0 || index >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          DateFormat('d').format(data[index].date),
                          style: TossTextStyles.captionGray500,
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
                          TossColors.gray900.withValues(alpha: 0.1),
                          TossColors.gray900.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(TossSpacing.space2),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.spotIndex;
                        if (index < 0 || index >= data.length) return null;
                        final item = data[index];
                        final formatter = NumberFormat('#,##0', 'en_US');
                        return LineTooltipItem(
                          '${DateFormat('MMM d').format(item.date)}\n$currencySymbol${formatter.format(item.netIncome)}',
                          TossTextStyles.captionWhite,
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
}
