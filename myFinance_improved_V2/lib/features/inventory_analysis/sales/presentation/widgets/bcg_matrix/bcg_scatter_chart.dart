import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'bcg_chart_data.dart';
import 'bcg_quadrant_painter.dart';

/// BCG Scatter Chart with quadrant backgrounds
class BcgScatterChart extends StatelessWidget {
  final BcgChartData chartData;
  final double height;
  final String currencySymbol;

  const BcgScatterChart({
    super.key,
    required this.chartData,
    this.height = 300,
    this.currencySymbol = '₫',
  });

  @override
  Widget build(BuildContext context) {
    if (chartData.spotData.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No data')),
      );
    }

    final spots = chartData.spotData.map((data) {
      return ScatterSpot(
        data.xValue,
        data.yValue,
        dotPainter: FlDotCirclePainter(
          radius: 8 + (data.category.totalRevenue / 50000000).clamp(0, 10).toDouble(),
          color: _getQuadrantColor(data.quadrant).withValues(alpha: 0.85),
          strokeWidth: 2,
          strokeColor: TossColors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const leftPadding = 32.0;
          const bottomPadding = 24.0;
          const rightPadding = 8.0;
          const topPadding = 8.0;

          final chartWidth = constraints.maxWidth - leftPadding - rightPadding;
          final chartHeight = constraints.maxHeight - topPadding - bottomPadding;

          return Stack(
            children: [
              // Quadrant backgrounds
              Positioned(
                left: leftPadding,
                top: topPadding,
                child: SizedBox(
                  width: chartWidth,
                  height: chartHeight,
                  child: CustomPaint(
                    painter: BcgQuadrantPainter(
                      medianXRatio: chartData.medianX / 100,
                      medianYRatio: chartData.medianY / 100,
                    ),
                  ),
                ),
              ),
              // Quadrant labels
              _buildQuadrantLabel(
                left: leftPadding + (chartData.medianX / 100 * chartWidth) / 2 - 30,
                top: topPadding + ((100 - chartData.medianY) / 100 * chartHeight) / 2 - 12,
                name: 'Question',
                color: TossColors.warning,
              ),
              _buildQuadrantLabel(
                left: leftPadding + (chartData.medianX / 100 * chartWidth) +
                    ((100 - chartData.medianX) / 100 * chartWidth) / 2 - 16,
                top: topPadding + ((100 - chartData.medianY) / 100 * chartHeight) / 2 - 12,
                name: 'Star',
                color: TossColors.success,
              ),
              _buildQuadrantLabel(
                left: leftPadding + (chartData.medianX / 100 * chartWidth) / 2 - 12,
                top: topPadding + ((100 - chartData.medianY) / 100 * chartHeight) +
                    (chartData.medianY / 100 * chartHeight) / 2 - 12,
                name: 'Dog',
                color: TossColors.error,
              ),
              _buildQuadrantLabel(
                left: leftPadding + (chartData.medianX / 100 * chartWidth) +
                    ((100 - chartData.medianX) / 100 * chartWidth) / 2 - 30,
                top: topPadding + ((100 - chartData.medianY) / 100 * chartHeight) +
                    (chartData.medianY / 100 * chartHeight) / 2 - 12,
                name: 'Cash Cow',
                color: TossColors.primary,
              ),
              // Chart
              ScatterChart(
                ScatterChartData(
                  scatterSpots: spots,
                  minX: 0,
                  maxX: 100,
                  minY: 0,
                  maxY: 100,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      if ((value - chartData.medianY).abs() < 1) {
                        return const FlLine(color: TossColors.gray400, strokeWidth: 1);
                      }
                      return const FlLine(color: Colors.transparent);
                    },
                    getDrawingVerticalLine: (value) {
                      if ((value - chartData.medianX).abs() < 1) {
                        return const FlLine(color: TossColors.gray400, strokeWidth: 1);
                      }
                      return const FlLine(color: Colors.transparent);
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 50,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == 100) {
                            // Show actual margin rate (not percentile)
                            final actualMargin = value == 0
                                ? chartData.minMarginRate
                                : chartData.maxMarginRate;
                            return Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                '${actualMargin.toStringAsFixed(0)}%',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  // Chart axis label - smaller than caption
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        interval: 50,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == 100) {
                            final actualValue = value / 100 * chartData.maxX;
                            return Text(
                              '${actualValue.toStringAsFixed(0)}%',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                                // Chart axis label
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  scatterTouchData: ScatterTouchData(
                    enabled: true,
                    touchTooltipData: ScatterTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipColor: (_) => TossColors.gray900.withValues(alpha: 0.9),
                      tooltipRoundedRadius: TossBorderRadius.md,
                      tooltipPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
                      getTooltipItems: (spot) {
                        final index = spots.indexOf(spot);
                        if (index >= 0 && index < chartData.spotData.length) {
                          final data = chartData.spotData[index];
                          final cat = data.category;

                          // Format based on xAxisMode
                          final xValueText = chartData.xAxisMode == BcgXAxisMode.revenue
                              ? '${_formatCurrency(cat.totalRevenue.toDouble())} (${cat.revenuePct.toStringAsFixed(1)}%)'
                              : '${cat.totalQuantity} pcs (${cat.salesVolumePercentile.toStringAsFixed(1)}%)';

                          final xLabel = chartData.xAxisMode == BcgXAxisMode.revenue
                              ? 'Revenue'
                              : 'Qty';

                          return ScatterTooltipItem(
                            '${cat.categoryName}\n$xLabel: $xValueText\nMargin: ${cat.marginRatePct.toStringAsFixed(1)}%',
                            textStyle: TossTextStyles.caption.copyWith(
                              color: TossColors.white,
                              height: 1.4,
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              // Y-axis label
              Positioned(
                left: 0,
                top: constraints.maxHeight / 2 - 30,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'Margin Rate',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // X-axis label (dynamic based on mode)
              Positioned(
                left: constraints.maxWidth / 2 - 30,
                bottom: 0,
                child: Text(
                  chartData.xAxisLabel,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Format currency with symbol and abbreviation
  String _formatCurrency(double value) {
    if (value >= 1000000000) {
      return '$currencySymbol${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '$currencySymbol${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '$currencySymbol${(value / 1000).toStringAsFixed(1)}K';
    }
    return '$currencySymbol${value.toStringAsFixed(0)}';
  }

  Widget _buildQuadrantLabel({
    required double left,
    required double top,
    required String name,
    required Color color,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Text(
        name,
        style: TossTextStyles.caption.copyWith(
          color: color.withValues(alpha: 0.6),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
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
