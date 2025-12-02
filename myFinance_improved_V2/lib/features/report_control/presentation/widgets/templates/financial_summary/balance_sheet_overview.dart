// lib/features/report_control/presentation/widgets/detail/balance_sheet_overview.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../domain/entities/templates/financial_summary/financial_report.dart';

/// Balance Sheet Overview with Visual Chart
///
/// Shows Assets, Liabilities, and Equity with a bar chart visualization
class BalanceSheetOverview extends StatelessWidget {
  final BalanceSheetSummary balanceSheet;

  const BalanceSheetOverview({
    super.key,
    required this.balanceSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title with health score
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Text(
                'Balance Sheet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              const Spacer(),
              _HealthScoreBadge(
                score: balanceSheet.healthScore,
                level: balanceSheet.healthLevel,
              ),
            ],
          ),
        ),

        // Main card with chart + metrics
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Bar Chart
              SizedBox(
                height: 180,
                child: _BalanceSheetBarChart(
                  assets: balanceSheet.totalAssets,
                  liabilities: balanceSheet.totalLiabilities,
                  equity: balanceSheet.totalEquity,
                ),
              ),

              const SizedBox(height: 24),

              // Metrics Grid
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      icon: LucideIcons.trendingUp,
                      iconColor: TossColors.success,
                      label: 'Assets',
                      value: balanceSheet.totalAssetsFormatted,
                      change: balanceSheet.assetsChangeFormatted,
                      isPositive: balanceSheet.assetsIncreased,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: LucideIcons.trendingDown,
                      iconColor: TossColors.error,
                      label: 'Liabilities',
                      value: balanceSheet.totalLiabilitiesFormatted,
                      change: balanceSheet.liabilitiesChangeFormatted,
                      isPositive: balanceSheet.liabilitiesIncreased,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: LucideIcons.pieChart,
                      iconColor: TossColors.primary,
                      label: 'Equity',
                      value: balanceSheet.totalEquityFormatted,
                      change: balanceSheet.equityChangeFormatted,
                      isPositive: balanceSheet.equityIncreased,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Health Score Badge
class _HealthScoreBadge extends StatelessWidget {
  final double score;
  final String level;

  const _HealthScoreBadge({
    required this.score,
    required this.level,
  });

  Color _getColor() {
    switch (level) {
      case 'excellent':
        return TossColors.success;
      case 'good':
        return const Color(0xFF52C41A);
      case 'fair':
        return TossColors.warning;
      default:
        return TossColors.error;
    }
  }

  String _getLabel() {
    switch (level) {
      case 'excellent':
        return 'Excellent';
      case 'good':
        return 'Good';
      case 'fair':
        return 'Fair';
      default:
        return 'Needs Attention';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.activity,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            '${score.toStringAsFixed(0)} - ${_getLabel()}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Balance Sheet Bar Chart
class _BalanceSheetBarChart extends StatelessWidget {
  final double assets;
  final double liabilities;
  final double equity;

  const _BalanceSheetBarChart({
    required this.assets,
    required this.liabilities,
    required this.equity,
  });

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    final maxValue = [assets.abs(), liabilities.abs(), equity.abs()]
        .reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue * 1.2, // Add 20% padding
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => TossColors.gray800,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label;
              switch (groupIndex) {
                case 0:
                  label = 'Assets';
                  break;
                case 1:
                  label = 'Liabilities';
                  break;
                case 2:
                  label = 'Equity';
                  break;
                default:
                  label = '';
              }
              return BarTooltipItem(
                '$label\n${_formatCurrency(rod.toY)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text;
                IconData icon;
                Color color;

                switch (value.toInt()) {
                  case 0:
                    text = 'Assets';
                    icon = LucideIcons.trendingUp;
                    color = TossColors.success;
                    break;
                  case 1:
                    text = 'Liabilities';
                    icon = LucideIcons.trendingDown;
                    color = TossColors.error;
                    break;
                  case 2:
                    text = 'Equity';
                    icon = LucideIcons.pieChart;
                    color = TossColors.primary;
                    break;
                  default:
                    return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 16, color: color),
                      const SizedBox(height: 4),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: TossColors.gray700,
                        ),
                      ),
                    ],
                  ),
                );
              },
              reservedSize: 50,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatShortCurrency(value),
                  style: const TextStyle(
                    fontSize: 10,
                    color: TossColors.gray600,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxValue / 5,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: TossColors.gray200,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          // Assets
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: assets.abs(),
                color: TossColors.success,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
          // Liabilities
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: liabilities.abs(),
                color: TossColors.error,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
          // Equity
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: equity.abs(),
                color: TossColors.primary,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '${isNegative ? '-' : ''}$formatted ₫';
  }

  String _formatShortCurrency(double amount) {
    final abs = amount.abs();
    if (abs >= 1000000) {
      return '${(abs / 1000000).toStringAsFixed(0)}M';
    } else if (abs >= 1000) {
      return '${(abs / 1000).toStringAsFixed(0)}K';
    }
    return abs.toStringAsFixed(0);
  }
}

/// Metric Card
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String change;
  final bool isPositive;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Label
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Change
          Row(
            children: [
              Icon(
                isPositive ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                size: 12,
                color: isPositive ? TossColors.success : TossColors.error,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isPositive ? TossColors.success : TossColors.error,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
