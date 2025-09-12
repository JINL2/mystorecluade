import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/supply_chain_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class IntegralValueChartWidget extends StatefulWidget {
  final List<IntegralDataPoint> data;
  final bool isMobile;
  final VoidCallback? onFullScreen;

  const IntegralValueChartWidget({
    super.key,
    required this.data,
    this.isMobile = false,
    this.onFullScreen,
  });

  @override
  State<IntegralValueChartWidget> createState() => _IntegralValueChartWidgetState();
}

class _IntegralValueChartWidgetState extends State<IntegralValueChartWidget> {
  String selectedPeriod = '7D';
  bool showFinancialImpact = true;

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();
    
    return Container(
      constraints: BoxConstraints(
        minWidth: widget.isMobile ? 300 : 450,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildChart(context, filteredData),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TossColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.show_chart,
              color: TossColors.info,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Integral Value Analysis',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Gap × Time × Financial Impact',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Period selector
          _buildPeriodSelector(context),
          SizedBox(width: TossSpacing.space2),
          // Toggle financial impact
          _buildToggleButton(context),
          if (widget.onFullScreen != null) ...[
            SizedBox(width: TossSpacing.space2),
            IconButton(
              onPressed: widget.onFullScreen,
              icon: Icon(
                Icons.fullscreen,
                color: TossColors.gray600,
                size: 20,
              ),
              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final periods = ['7D', '30D', '90D', '1Y'];
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = selectedPeriod == period;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPeriod = period;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: isSelected ? TossColors.primary : TossColors.transparent,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                period,
                style: TossTextStyles.caption.copyWith(
                  color: isSelected ? TossColors.white : TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showFinancialImpact = !showFinancialImpact;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: showFinancialImpact 
              ? TossColors.success.withValues(alpha: 0.1)
              : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(
            color: showFinancialImpact 
                ? TossColors.success.withValues(alpha: 0.3)
                : TossColors.gray300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_money,
              size: 16,
              color: showFinancialImpact ? TossColors.success : TossColors.gray600,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              'Impact',
              style: TossTextStyles.caption.copyWith(
                color: showFinancialImpact ? TossColors.success : TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<IntegralDataPoint> data) {
    if (data.isEmpty) {
      return Container(
        height: widget.isMobile ? 200 : 300,
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart,
                color: TossColors.gray400,
                size: 48,
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                'No data available for selected period',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: widget.isMobile ? 200 : 300,
      padding: EdgeInsets.all(TossSpacing.space4),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(data),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: TossColors.gray200,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (data.length / 5).ceil().toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: TossSpacing.space1),
                      child: Text(
                        _formatDate(data[index].date),
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatChartValue(value),
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray600,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: _getMaxValue(data),
          lineBarsData: _buildChartLines(data),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildChartLines(List<IntegralDataPoint> data) {
    final lines = <LineChartBarData>[];

    // Order stage (blue)
    lines.add(LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.orderValue);
      }).toList(),
      isCurved: true,
      color: TossColors.primary,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: TossColors.primary.withValues(alpha: 0.2),
      ),
    ));

    // Send stage (orange)
    lines.add(LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.shipValue);
      }).toList(),
      isCurved: true,
      color: TossColors.warning,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: TossColors.warning.withValues(alpha: 0.2),
      ),
    ));

    // Receive stage (green)
    lines.add(LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.receiveValue);
      }).toList(),
      isCurved: true,
      color: TossColors.success,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: TossColors.success.withValues(alpha: 0.2),
      ),
    ));

    // Sell stage (info/blue)
    lines.add(LineChartBarData(
      spots: data.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.saleValue);
      }).toList(),
      isCurved: true,
      color: TossColors.info,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: TossColors.info.withValues(alpha: 0.2),
      ),
    ));

    // Financial impact overlay (if enabled)
    if (showFinancialImpact) {
      lines.add(LineChartBarData(
        spots: data.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.financialImpact);
        }).toList(),
        isCurved: true,
        color: TossColors.error,
        barWidth: 2,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(show: false),
        dashArray: [5, 5],
      ));
    }

    return lines;
  }

  Widget _buildLegend(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Wrap(
        spacing: TossSpacing.space3,
        runSpacing: TossSpacing.space2,
        children: [
          _buildLegendItem('Order', TossColors.primary),
          _buildLegendItem('Send', TossColors.warning),
          _buildLegendItem('Receive', TossColors.success),
          _buildLegendItem('Sell', TossColors.info),
          if (showFinancialImpact)
            _buildLegendItem('Financial Impact', TossColors.error, isDashed: true),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {bool isDashed = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
          child: isDashed 
              ? CustomPaint(
                  painter: DashedLinePainter(color: color),
                )
              : null,
        ),
        SizedBox(width: TossSpacing.space1),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<IntegralDataPoint> _getFilteredData() {
    final now = DateTime.now();
    DateTime cutoffDate;
    
    switch (selectedPeriod) {
      case '7D':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case '30D':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case '90D':
        cutoffDate = now.subtract(const Duration(days: 90));
        break;
      case '1Y':
        cutoffDate = now.subtract(const Duration(days: 365));
        break;
      default:
        cutoffDate = now.subtract(const Duration(days: 7));
    }
    
    return widget.data
        .where((point) => point.date.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  double _getMaxValue(List<IntegralDataPoint> data) {
    if (data.isEmpty) return 100;
    
    double maxIntegral = 0;
    double maxFinancial = 0;
    
    for (final point in data) {
      final maxIntegralValue = [
        point.orderValue,
        point.shipValue,
        point.receiveValue,
      ].reduce((a, b) => a > b ? a : b);
      
      if (maxIntegralValue > maxIntegral) {
        maxIntegral = maxIntegralValue;
      }
      
      if (showFinancialImpact && point.financialImpact > maxFinancial) {
        maxFinancial = point.financialImpact;
      }
    }
    
    final overallMax = showFinancialImpact 
        ? [maxIntegral, maxFinancial].reduce((a, b) => a > b ? a : b)
        : maxIntegral;
    
    return (overallMax * 1.1); // Add 10% padding
  }

  double _calculateInterval(List<IntegralDataPoint> data) {
    final maxValue = _getMaxValue(data);
    return maxValue / 5; // 5 horizontal grid lines
  }

  String _formatDate(DateTime date) {
    switch (selectedPeriod) {
      case '7D':
        return DateFormat('E').format(date); // Mon, Tue, Wed
      case '30D':
        return DateFormat('M/d').format(date); // 1/15, 1/16
      case '90D':
        return DateFormat('M/d').format(date); // 1/15, 2/15
      case '1Y':
        return DateFormat('MMM').format(date); // Jan, Feb, Mar
      default:
        return DateFormat('M/d').format(date);
    }
  }

  String _formatChartValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}

// Custom painter for dashed line in legend
class DashedLinePainter extends CustomPainter {
  final Color color;
  
  DashedLinePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    const dashWidth = 3.0;
    const dashSpace = 2.0;
    double startX = 0;
    
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}