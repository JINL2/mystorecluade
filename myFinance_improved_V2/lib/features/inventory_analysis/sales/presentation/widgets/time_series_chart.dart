import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../domain/entities/sales_analytics.dart';
import '../providers/states/sales_analytics_state.dart';

/// Time Series Chart Widget
/// Line chart showing trends over time with metric toggle and category filter
class TimeSeriesChart extends StatefulWidget {
  final List<AnalyticsDataPoint> data;
  final Metric selectedMetric;
  final ValueChanged<Metric> onMetricChanged;
  final bool isLoading;
  // Category filter
  final List<CategoryInfo> availableCategories;
  final String? selectedCategoryId;
  final ValueChanged<String?>? onCategoryChanged;
  final String? selectedCategoryName;
  // Total time series data for calculating daily percentage
  final List<AnalyticsDataPoint>? totalTimeSeriesData;

  const TimeSeriesChart({
    super.key,
    required this.data,
    required this.selectedMetric,
    required this.onMetricChanged,
    this.isLoading = false,
    this.availableCategories = const [],
    this.selectedCategoryId,
    this.onCategoryChanged,
    this.selectedCategoryName,
    this.totalTimeSeriesData,
  });

  @override
  State<TimeSeriesChart> createState() => _TimeSeriesChartState();
}

class _TimeSeriesChartState extends State<TimeSeriesChart> {
  @override
  Widget build(BuildContext context) {
    final hasCategories = widget.availableCategories.isNotEmpty;
    final title = widget.selectedCategoryName != null
        ? '${widget.selectedCategoryName} Trend'
        : 'Category Trend';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row 1: Title + Metric Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 20,
                      color: TossColors.primary,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Metric Toggle
                Flexible(child: _buildMetricToggle()),
              ],
            ),

            // Category Selector (if available)
            if (hasCategories) ...[
              const SizedBox(height: TossSpacing.space3),
              _buildCategorySelector(),
            ],

            const SizedBox(height: TossSpacing.space4),

            // Chart
            if (widget.isLoading)
              _buildShimmer()
            else if (widget.data.isEmpty)
              _buildEmptyState()
            else
              SizedBox(
                height: 200,
                child: _buildChart(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "All" option
          _buildCategoryChip(
            id: null,
            name: 'All',
            isSelected: widget.selectedCategoryId == null,
          ),
          const SizedBox(width: TossSpacing.space2),
          // Category chips
          ...widget.availableCategories.take(10).map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space2),
              child: _buildCategoryChip(
                id: category.id,
                name: _shortenCategoryName(category.name),
                isSelected: widget.selectedCategoryId == category.id,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String? id,
    required String name,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.onCategoryChanged?.call(id),
      child: AnimatedContainer(
        duration: TossAnimations.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space1_5,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        child: Text(
          name,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _shortenCategoryName(String name) {
    // Handle names like "Bag>>Bag S" -> "Bag S"
    if (name.contains('>>')) {
      return name.split('>>').last;
    }
    // Truncate long names
    if (name.length > 12) {
      return '${name.substring(0, 10)}...';
    }
    return name;
  }

  Widget _buildMetricToggle() {
    return CupertinoSlidingSegmentedControl<Metric>(
      groupValue: widget.selectedMetric,
      backgroundColor: TossColors.gray100,
      thumbColor: TossColors.white,
      children: const {
        Metric.revenue: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Revenue', style: TextStyle(fontSize: 12)),
        ),
        Metric.margin: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Margin', style: TextStyle(fontSize: 12)),
        ),
        Metric.quantity: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Qty', style: TextStyle(fontSize: 12)),
        ),
      },
      onValueChanged: (value) {
        if (value != null) {
          widget.onMetricChanged(value);
        }
      },
    );
  }

  Widget _buildChart() {
    // When category is selected, show percentage; otherwise show absolute values
    final isPercentageMode = widget.selectedCategoryId != null &&
                             widget.totalTimeSeriesData != null &&
                             widget.totalTimeSeriesData!.isNotEmpty;

    final spots = isPercentageMode ? _getPercentageSpots() : _getSpots();
    final maxY = isPercentageMode
        ? (spots.isEmpty ? 100.0 : (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2).clamp(0.0, 100.0))
        : (spots.isEmpty ? 100.0 : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.1);
    const minY = 0.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: isPercentageMode ? 10.0 : _calculateInterval(maxY),
          getDrawingHorizontalLine: (value) => FlLine(
            color: TossColors.gray200,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                if (value == minY || value == maxY) return const SizedBox();
                return Text(
                  isPercentageMode ? '${value.toInt()}%' : _formatCompact(value),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _calculateBottomInterval(spots.length),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= widget.data.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatPeriodLabel(widget.data[index].period),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: TossColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 4,
                color: TossColors.white,
                strokeWidth: 2,
                strokeColor: TossColors.primary,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  TossColors.primary.withValues(alpha: 0.3),
                  TossColors.primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => TossColors.gray900,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final dataPoint = widget.data[index];
                // In percentage mode, show % and actual value
                final tooltipText = isPercentageMode
                    ? '${_formatPeriodLabel(dataPoint.period)}\n${spot.y.toStringAsFixed(1)}%\n${_formatValue(_getAbsoluteValue(index))}'
                    : '${_formatPeriodLabel(dataPoint.period)}\n${_formatValue(spot.y)}';
                return LineTooltipItem(
                  tooltipText,
                  TossTextStyles.caption.copyWith(
                    color: TossColors.white,
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
        minY: minY,
        maxY: maxY.toDouble(),
      ),
      duration: const Duration(milliseconds: 500),
    );
  }

  List<FlSpot> _getSpots() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final y = switch (widget.selectedMetric) {
        Metric.revenue => data.totalRevenue,
        Metric.margin => data.totalMargin,
        Metric.quantity => data.totalQuantity,
      };
      return FlSpot(index.toDouble(), y);
    }).toList();
  }

  /// Get spots as percentage of daily total
  List<FlSpot> _getPercentageSpots() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final categoryValue = switch (widget.selectedMetric) {
        Metric.revenue => data.totalRevenue,
        Metric.margin => data.totalMargin,
        Metric.quantity => data.totalQuantity,
      };

      // Find matching total for the same period
      final totalDataPoint = widget.totalTimeSeriesData?.where(
        (d) => d.period.year == data.period.year &&
               d.period.month == data.period.month &&
               d.period.day == data.period.day,
      ).firstOrNull;

      if (totalDataPoint == null) return FlSpot(index.toDouble(), 0);

      final totalValue = switch (widget.selectedMetric) {
        Metric.revenue => totalDataPoint.totalRevenue,
        Metric.margin => totalDataPoint.totalMargin,
        Metric.quantity => totalDataPoint.totalQuantity,
      };

      final percentage = totalValue > 0 ? (categoryValue / totalValue) * 100 : 0.0;
      return FlSpot(index.toDouble(), percentage);
    }).toList();
  }

  /// Get the absolute value for tooltip display
  double _getAbsoluteValue(int index) {
    if (index < 0 || index >= widget.data.length) return 0;
    final data = widget.data[index];
    return switch (widget.selectedMetric) {
      Metric.revenue => data.totalRevenue,
      Metric.margin => data.totalMargin,
      Metric.quantity => data.totalQuantity,
    };
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 0) return 1;
    return (maxY / 4).ceilToDouble();
  }

  double _calculateBottomInterval(int dataLength) {
    if (dataLength <= 7) return 1;
    if (dataLength <= 14) return 2;
    if (dataLength <= 30) return 5;
    return 7;
  }

  String _formatCompact(double value) {
    if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatValue(double value) {
    if (widget.selectedMetric == Metric.quantity) {
      return _formatCompact(value);
    }
    return '\$${_formatCompact(value)}';
  }

  String _formatPeriodLabel(DateTime date) {
    return DateFormat('M/d').format(date);
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 48,
              color: TossColors.gray300,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'No data available',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
