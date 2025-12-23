import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/revenue_period.dart';
import '../providers/homepage_providers.dart';

/// Provider for fetching revenue chart data using get_dashboard_revenue_v3 RPC
///
/// Uses the same period selection as RevenueCard (selectedRevenuePeriodProvider).
/// Uses HomepageRepository (Clean Architecture) instead of direct DataSource access.
final revenueChartDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final repository = ref.read(homepageRepositoryProvider);
  final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
  final selectedTab = ref.watch(selectedRevenueTabProvider);

  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;

  if (companyId.isEmpty) {
    return _defaultChartResponse();
  }

  // Determine storeId based on selected tab
  final effectiveStoreId = (selectedTab == RevenueViewTab.store && storeId.isNotEmpty)
      ? storeId
      : null;

  try {
    final response = await repository.getRevenueChartData(
      companyId: companyId,
      timeFilter: selectedPeriod.apiValue,
      timezone: 'Asia/Ho_Chi_Minh', // TODO: Get from device
      storeId: effectiveStoreId,
    );

    return response;
  } catch (e) {
    return _defaultChartResponse();
  }
});

/// Default chart response when no data available
Map<String, dynamic> _defaultChartResponse() {
  return {
    'data': <Map<String, dynamic>>[],
    'summary': {
      'revenue': {'total': 0, 'average': 0, 'min': 0, 'max': 0},
      'gross_profit': {'total': 0, 'average': 0, 'min': 0, 'max': 0},
      'net_income': {'total': 0, 'average': 0, 'min': 0, 'max': 0},
    },
    'currency_symbol': '\$',
  };
}

/// Revenue Chart Card - Shows revenue & gross profit bar chart
///
/// Displayed only for managers with revenue permission.
/// Shows bar chart with Revenue (blue) and Gross Profit (green).
/// Uses the same period selection as RevenueCard (no separate dropdown).
class RevenueChartCard extends ConsumerStatefulWidget {
  const RevenueChartCard({super.key});

  @override
  ConsumerState<RevenueChartCard> createState() => _RevenueChartCardState();
}

class _RevenueChartCardState extends ConsumerState<RevenueChartCard> {
  int? _selectedBarIndex;
  _ChartDataPoint? _selectedDataPoint;
  RevenuePeriod? _lastPeriod;
  RevenueViewTab? _lastTab;
  String? _lastStoreId;

  @override
  Widget build(BuildContext context) {
    final chartDataAsync = ref.watch(revenueChartDataProvider);
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
    final selectedTab = ref.watch(selectedRevenueTabProvider);
    final appState = ref.watch(appStateProvider);
    final currentStoreId = appState.storeChoosen;

    // Reset selection when period, tab, or store changes
    if (_lastPeriod != selectedPeriod || _lastTab != selectedTab || _lastStoreId != currentStoreId) {
      _lastPeriod = selectedPeriod;
      _lastTab = selectedTab;
      _lastStoreId = currentStoreId;
      _selectedBarIndex = null;
      _selectedDataPoint = null;
    }

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          _buildHeader(),

          const SizedBox(height: TossSpacing.space5),

          // Legend
          _buildLegend(),

          const SizedBox(height: TossSpacing.space4),

          // Bar Chart with tooltip overlay
          SizedBox(
            height: 220, // Increased height for tooltip space
            child: chartDataAsync.when(
              data: (chartData) => _buildBarChartWithTooltip(chartData, selectedPeriod),
              loading: () => _buildLoadingState(),
              error: (error, _) => _buildErrorState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Revenue Overview',
      style: TossTextStyles.h3.copyWith(
        fontSize: 15,
        color: TossColors.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem('Revenue', TossColors.primary),
        const SizedBox(width: TossSpacing.space4),
        _buildLegendItem('Gross Profit', TossColors.success),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            fontSize: 12,
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChartWithTooltip(Map<String, dynamic> chartData, RevenuePeriod selectedPeriod) {
    final dataList = chartData['data'] as List<dynamic>? ?? [];

    if (dataList.isEmpty) {
      return _buildEmptyState();
    }

    // Convert to chart data points
    final chartPoints = dataList.asMap().entries.map((entry) {
      final data = entry.value as Map<String, dynamic>;
      return _ChartDataPoint(
        label: _formatLabel(data['label'] as String? ?? '', selectedPeriod),
        revenue: (data['revenue'] as num?)?.toDouble() ?? 0.0,
        grossProfit: (data['gross_profit'] as num?)?.toDouble() ?? 0.0,
        netIncome: (data['net_income'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();

    // Find max value for scaling
    final maxValue = chartPoints.fold<double>(
      0,
      (max, point) => point.revenue > max ? point.revenue : max,
    );

    // Calculate nice Y-axis scale
    final yAxisScale = _calculateYAxisScale(maxValue);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Reserve space for Y-axis labels
        const yAxisWidth = 38.0;
        final barAreaWidth = constraints.maxWidth - yAxisWidth;
        final barCount = chartPoints.length;
        final barSlotWidth = barAreaWidth / barCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Y-axis labels
            Positioned(
              left: 0,
              top: 0,
              bottom: 20, // Leave space for X-axis labels
              child: SizedBox(
                width: yAxisWidth,
                child: _buildYAxisLabels(yAxisScale),
              ),
            ),

            // Bar chart row
            Positioned(
              left: yAxisWidth,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: chartPoints.asMap().entries.map((entry) {
                    final index = entry.key;
                    final point = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: _buildBar(point, yAxisScale, chartPoints.length, index),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Tooltip positioned above selected bar
            if (_selectedBarIndex != null && _selectedDataPoint != null)
              Positioned(
                top: 0,
                left: yAxisWidth,
                right: 0,
                child: _buildPositionedTooltip(
                  _selectedDataPoint!,
                  _selectedBarIndex!,
                  barSlotWidth,
                  barAreaWidth,
                ),
              ),
          ],
        );
      },
    );
  }

  /// Calculate nice Y-axis scale based on max value
  /// Returns scale info with max value and tick values
  _YAxisScale _calculateYAxisScale(double maxValue) {
    if (maxValue <= 0) {
      return _YAxisScale(maxValue: 100, tickValues: [0, 25, 50, 75, 100], suffix: '');
    }

    // Determine the magnitude and nice interval
    final magnitude = _getMagnitude(maxValue);
    final normalizedMax = maxValue / magnitude;

    // Find nice max value (round up to nice number)
    double niceMax;
    if (normalizedMax <= 1) {
      niceMax = 1;
    } else if (normalizedMax <= 2) {
      niceMax = 2;
    } else if (normalizedMax <= 5) {
      niceMax = 5;
    } else {
      niceMax = 10;
    }

    final actualMax = niceMax * magnitude;

    // Generate 5 tick values (0, 25%, 50%, 75%, 100%)
    final tickValues = <double>[
      0,
      actualMax * 0.25,
      actualMax * 0.5,
      actualMax * 0.75,
      actualMax,
    ];

    // Determine suffix based on magnitude
    String suffix;
    double divisor;
    if (magnitude >= 1e9) {
      suffix = 'B';
      divisor = 1e9;
    } else if (magnitude >= 1e6) {
      suffix = 'M';
      divisor = 1e6;
    } else if (magnitude >= 1e3) {
      suffix = 'K';
      divisor = 1e3;
    } else {
      suffix = '';
      divisor = 1;
    }

    return _YAxisScale(
      maxValue: actualMax,
      tickValues: tickValues,
      suffix: suffix,
      divisor: divisor,
    );
  }

  /// Get magnitude (power of 10) for a value
  double _getMagnitude(double value) {
    if (value <= 0) return 1;
    if (value < 10) return 1;
    if (value < 100) return 10;
    if (value < 1000) return 100;
    if (value < 10000) return 1000;
    if (value < 100000) return 10000;
    if (value < 1000000) return 100000;
    if (value < 10000000) return 1000000;
    if (value < 100000000) return 10000000;
    if (value < 1000000000) return 100000000;
    return 1000000000;
  }

  /// Build Y-axis labels
  Widget _buildYAxisLabels(_YAxisScale scale) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: scale.tickValues.reversed.map((double value) {
        final displayValue = scale.divisor > 0 ? value / scale.divisor : value;
        final label = displayValue == displayValue.roundToDouble()
            ? '${displayValue.toInt()}${scale.suffix}'
            : '${displayValue.toStringAsFixed(1)}${scale.suffix}';

        return Text(
          label,
          style: TossTextStyles.caption.copyWith(
            fontSize: 10,
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPositionedTooltip(
    _ChartDataPoint data,
    int barIndex,
    double barSlotWidth,
    double totalWidth,
  ) {
    final formatter = NumberFormat.compact();

    // Calculate the center position of the selected bar
    final barCenterX = (barIndex * barSlotWidth) + (barSlotWidth / 2);

    return Row(
      children: [
        // Use Spacer-like approach to position tooltip
        SizedBox(
          width: (barCenterX - 70).clamp(0, totalWidth - 140),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedBarIndex = null;
              _selectedDataPoint = null;
            });
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 160),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date label
                Text(
                  data.label,
                  style: TossTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Revenue
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: TossColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatter.format(data.revenue),
                      style: TossTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Gross Profit
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: TossColors.success,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatter.format(data.grossProfit),
                      style: TossTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Format label for display based on selected period
  /// - past_7_days: "2025-12-20" -> "M" (day of week)
  /// - this_month/last_month: "2025-12-20" -> "20" (day number)
  /// - this_year: "2025-12" -> "Dec" (month name)
  String _formatLabel(String label, RevenuePeriod period) {
    if (label.isEmpty) return '';

    // Monthly format: "2025-12" -> "Dec" (for this_year)
    if (label.length == 7) {
      final month = int.tryParse(label.substring(5, 7)) ?? 1;
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return months[month - 1];
    }

    // Daily format: "2025-12-20"
    if (label.length == 10) {
      // For past 7 days, show day of week (M, T, W, T, F, S, S)
      if (period == RevenuePeriod.past7Days) {
        try {
          final date = DateTime.parse(label);
          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          return days[date.weekday - 1];
        } catch (_) {
          return label.substring(8, 10);
        }
      }
      // For monthly periods, show day number (1, 2, 3, ... 31)
      else {
        final day = int.tryParse(label.substring(8, 10)) ?? 0;
        return day.toString();
      }
    }

    return label;
  }

  Widget _buildBar(_ChartDataPoint data, _YAxisScale scale, int dataCount, int index) {
    // Calculate heights proportionally using Y-axis scale max (max height 140)
    // Use scale.maxValue to ensure bar height matches Y-axis labels
    final maxValue = scale.maxValue;
    final revenueHeight = maxValue > 0 ? (data.revenue / maxValue) * 140 : 0.0;
    final grossProfitHeight = maxValue > 0 ? (data.grossProfit / maxValue) * 140 : 0.0;

    // Dynamic sizing based on data count
    // 7 days: wide bars, large font
    // 12 months: medium bars, medium font
    // 30+ days: narrow bars, small font
    final double barWidth;
    final double fontSize;
    final double borderRadius;

    if (dataCount <= 7) {
      barWidth = 28;
      fontSize = 11;
      borderRadius = 6;
    } else if (dataCount <= 12) {
      barWidth = 20;
      fontSize = 9;
      borderRadius = 5;
    } else {
      barWidth = 8;
      fontSize = 7;
      borderRadius = 3;
    }

    final isSelected = _selectedBarIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedBarIndex == index) {
            // Deselect if same bar tapped
            _selectedBarIndex = null;
            _selectedDataPoint = null;
          } else {
            _selectedBarIndex = index;
            _selectedDataPoint = data;
          }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Stacked bar (Revenue > Gross Profit)
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Revenue bar (full height, blue)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: barWidth,
                  height: revenueHeight.clamp(0, 140),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? TossColors.primary.withValues(alpha: 0.8)
                        : TossColors.primary,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: TossColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
                // Gross Profit bar (green)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: barWidth,
                  height: grossProfitHeight.clamp(0, 140),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? TossColors.success.withValues(alpha: 0.8)
                        : TossColors.success,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Day/Month label
          Text(
            data.label,
            style: TossTextStyles.caption.copyWith(
              fontSize: fontSize,
              color: isSelected ? TossColors.primary : TossColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: TossColors.primary,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            size: 48,
            color: TossColors.gray300,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No data available',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: TossColors.error,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Failed to load chart',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data point for chart
class _ChartDataPoint {
  final String label;
  final double revenue;
  final double grossProfit;
  final double netIncome;

  _ChartDataPoint({
    required this.label,
    required this.revenue,
    required this.grossProfit,
    required this.netIncome,
  });
}

/// Y-axis scale configuration
class _YAxisScale {
  final double maxValue;
  final List<double> tickValues;
  final String suffix;
  final double divisor;

  _YAxisScale({
    required this.maxValue,
    required this.tickValues,
    required this.suffix,
    this.divisor = 1,
  });
}
