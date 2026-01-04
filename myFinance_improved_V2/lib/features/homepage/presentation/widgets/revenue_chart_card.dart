import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/revenue_period.dart';
import '../providers/homepage_providers.dart';

/// Provider for fetching revenue chart data using get_dashboard_revenue_v3 RPC
/// Auto-switches to thisYear if today has no data (only on initial load)
final revenueChartDataProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final repository = ref.read(homepageRepositoryProvider);
  final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
  final selectedTab = ref.watch(selectedRevenueTabProvider);
  final userManuallySelected = ref.watch(userManuallySelectedPeriodProvider);

  final companyId = appState.companyChoosen;
  final storeId = appState.storeChoosen;

  if (companyId.isEmpty) {
    return _defaultChartResponse();
  }

  final effectiveStoreId =
      (selectedTab == RevenueViewTab.store && storeId.isNotEmpty)
          ? storeId
          : null;

  try {
    final response = await repository.getRevenueChartData(
      companyId: companyId,
      timeFilter: selectedPeriod.apiValue,
      timezone: 'Asia/Ho_Chi_Minh',
      storeId: effectiveStoreId,
    );

    // Auto-switch to thisYear if today/yesterday has no revenue data
    // ONLY on initial load (userManuallySelected == false)
    // Once user manually selects a period, respect their choice
    if (!userManuallySelected &&
        (selectedPeriod == RevenuePeriod.today ||
            selectedPeriod == RevenuePeriod.yesterday)) {
      final dataList = response['data'] as List<dynamic>? ?? [];
      final hasRevenue = dataList.any((data) {
        final revenue = (data['revenue'] as num?)?.toDouble() ?? 0.0;
        return revenue > 0;
      });

      if (!hasRevenue) {
        // Switch to thisYear and fetch new data
        ref.read(selectedRevenuePeriodProvider.notifier).state =
            RevenuePeriod.thisYear;
        return await repository.getRevenueChartData(
          companyId: companyId,
          timeFilter: RevenuePeriod.thisYear.apiValue,
          timezone: 'Asia/Ho_Chi_Minh',
          storeId: effectiveStoreId,
        );
      }
    }

    return response;
  } catch (e) {
    return _defaultChartResponse();
  }
});

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

// ============================================================================
// Cached Chart Data for Smooth UI Transitions (Toss Style)
// ============================================================================

/// Holds the last successfully loaded chart data
final _cachedChartDataProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

/// Provider that returns cached chart data + loading state
/// Enables "show previous data with shimmer overlay" pattern
final chartDataWithCacheProvider = Provider<ChartDataWithLoadingState>((ref) {
  final asyncValue = ref.watch(revenueChartDataProvider);
  final cachedData = ref.watch(_cachedChartDataProvider);

  // Update cache when new data arrives successfully
  // Use ref.listen instead of whenData + Future.microtask to avoid disposed ref issues
  ref.listen(revenueChartDataProvider, (previous, next) {
    next.whenData((data) {
      final dataList = data['data'] as List<dynamic>? ?? [];
      if (dataList.isNotEmpty) {
        ref.read(_cachedChartDataProvider.notifier).state = data;
      }
    });
  });

  return ChartDataWithLoadingState(
    data: asyncValue.valueOrNull ?? cachedData,
    isLoading: asyncValue.isLoading,
    hasError: asyncValue.hasError,
    error: asyncValue.error,
  );
});

/// State class that holds chart data with loading status
class ChartDataWithLoadingState {
  final Map<String, dynamic>? data;
  final bool isLoading;
  final bool hasError;
  final Object? error;

  const ChartDataWithLoadingState({
    required this.data,
    required this.isLoading,
    required this.hasError,
    this.error,
  });

  /// True if we have data to display (either fresh or cached)
  bool get hasData => data != null && (data!['data'] as List<dynamic>?)?.isNotEmpty == true;

  /// True if showing cached data while loading new data
  bool get isRefreshing => isLoading && hasData;
}

/// Revenue Chart Card - fl_chart based bar chart
class RevenueChartCard extends ConsumerStatefulWidget {
  const RevenueChartCard({super.key});

  @override
  ConsumerState<RevenueChartCard> createState() => _RevenueChartCardState();
}

class _RevenueChartCardState extends ConsumerState<RevenueChartCard> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Use cached chart data provider (Toss style - prevents layout jump)
    final chartState = ref.watch(chartDataWithCacheProvider);
    final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: TossSpacing.space4),
          _buildLegend(),
          const SizedBox(height: TossSpacing.space4),
          SizedBox(
            height: 200,
            child: _buildChartContent(chartState, selectedPeriod),
          ),
        ],
      ),
    );
  }

  /// Builds chart content with Toss-style loading overlay
  Widget _buildChartContent(ChartDataWithLoadingState state, RevenuePeriod selectedPeriod) {
    // Case 1: Has data (fresh or cached) - show with optional loading overlay
    if (state.hasData) {
      return Stack(
        children: [
          // Actual chart (always visible)
          _buildBarChart(state.data!, selectedPeriod),

          // Shimmer overlay when refreshing
          if (state.isRefreshing)
            Positioned.fill(
              child: _ChartShimmerOverlay(),
            ),
        ],
      );
    }

    // Case 2: Initial loading (no cached data yet)
    if (state.isLoading) {
      return _buildLoadingState();
    }

    // Case 3: Error with no cached data
    if (state.hasError) {
      return _buildErrorState();
    }

    // Fallback - empty state
    return _buildEmptyState();
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

  Widget _buildBarChart(
      Map<String, dynamic> chartData, RevenuePeriod selectedPeriod) {
    final dataList = chartData['data'] as List<dynamic>? ?? [];

    if (dataList.isEmpty) {
      return _buildEmptyState();
    }

    // Convert to chart data - filter out days with no data (revenue = 0)
    final List<_ChartDataPoint> chartPoints = [];
    for (final data in dataList) {
      final map = data as Map<String, dynamic>;
      final revenue = (map['revenue'] as num?)?.toDouble() ?? 0.0;

      // Skip days with no revenue data
      if (revenue <= 0) continue;

      chartPoints.add(_ChartDataPoint(
        label: _formatLabel(map['label'] as String? ?? '', selectedPeriod),
        revenue: revenue,
        grossProfit: (map['gross_profit'] as num?)?.toDouble() ?? 0.0,
      ));
    }

    // If all data points were filtered out, show empty state
    if (chartPoints.isEmpty) {
      return _buildEmptyState();
    }

    // Calculate max value for Y-axis
    double maxY = 0;
    for (final point in chartPoints) {
      if (point.revenue > maxY) maxY = point.revenue;
    }
    maxY = _calculateNiceMaxY(maxY);

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true, // Prevent tooltip from being cut off
            fitInsideVertically: true,
            getTooltipColor: (group) => TossColors.gray800,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tooltipMargin: 8,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final point = chartPoints[group.x.toInt()];
              final formatter = NumberFormat.compact();
              return BarTooltipItem(
                '${point.label}\n',
                TossTextStyles.caption.copyWith(
                  color: TossColors.gray400,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                children: [
                  TextSpan(
                    text: 'Revenue: ${formatter.format(point.revenue)}\n',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: 'Gross Profit: ${formatter.format(point.grossProfit)}\n',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: 'Margin: ${point.marginPercent.toStringAsFixed(1)}%',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.warning,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= chartPoints.length) {
                  return const SizedBox.shrink();
                }
                final isSelected = _touchedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    chartPoints[index].label,
                    style: TossTextStyles.caption.copyWith(
                      fontSize: chartPoints.length > 12 ? 8 : 10,
                      color: isSelected
                          ? TossColors.primary
                          : TossColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatYAxisLabel(value),
                  style: TossTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: TossColors.textSecondary,
                    fontWeight: FontWeight.w500,
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
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: TossColors.gray200,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(chartPoints, maxY),
        alignment: BarChartAlignment.spaceAround,
      ),
      duration: TossAnimations.medium,
    );
  }

  List<BarChartGroupData> _buildBarGroups(
      List<_ChartDataPoint> points, double maxY) {
    return points.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      final isTouched = _touchedIndex == index;

      // Bar width based on data count
      final barWidth = points.length <= 7
          ? 20.0
          : points.length <= 12
              ? 14.0
              : 8.0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: point.revenue,
            width: barWidth,
            // Unified bar shape: slightly rounded top only
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
            ),
            rodStackItems: [
              // Gross Profit (bottom - green)
              BarChartRodStackItem(
                0,
                point.grossProfit,
                isTouched
                    ? TossColors.success.withValues(alpha: 0.85)
                    : TossColors.success,
              ),
              // Revenue - Gross Profit (top - blue)
              BarChartRodStackItem(
                point.grossProfit,
                point.revenue,
                isTouched
                    ? TossColors.primary.withValues(alpha: 0.85)
                    : TossColors.primary,
              ),
            ],
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    }).toList();
  }

  double _calculateNiceMaxY(double maxValue) {
    if (maxValue <= 0) return 100;

    // Find nice round number
    final magnitude = _getMagnitude(maxValue);
    final normalized = maxValue / magnitude;

    double niceMax;
    if (normalized <= 1) {
      niceMax = 1;
    } else if (normalized <= 2) {
      niceMax = 2;
    } else if (normalized <= 5) {
      niceMax = 5;
    } else {
      niceMax = 10;
    }

    return niceMax * magnitude;
  }

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

  String _formatYAxisLabel(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(value % 1e9 == 0 ? 0 : 1)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(value % 1e6 == 0 ? 0 : 1)}M';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(value % 1e3 == 0 ? 0 : 1)}K';
    }
    return value.toInt().toString();
  }

  String _formatLabel(String label, RevenuePeriod period) {
    if (label.isEmpty) return '';

    // Monthly format: "2025-12" -> "Dec"
    if (label.length == 7) {
      final month = int.tryParse(label.substring(5, 7)) ?? 1;
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return months[month - 1];
    }

    // Daily format: "2025-12-20"
    if (label.length == 10) {
      // Show day number for all daily periods (e.g., "20", "21", "22")
      final day = int.tryParse(label.substring(8, 10)) ?? 0;
      return day.toString();
    }

    return label;
  }

  Widget _buildLoadingState() {
    return const TossLoadingView();
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

class _ChartDataPoint {
  final String label;
  final double revenue;
  final double grossProfit;

  _ChartDataPoint({
    required this.label,
    required this.revenue,
    required this.grossProfit,
  });

  /// Gross Profit Margin = (Gross Profit / Revenue) * 100
  double get marginPercent {
    if (revenue <= 0) return 0.0;
    return (grossProfit / revenue) * 100;
  }
}

/// Shimmer overlay for chart using TossAnimations
class _ChartShimmerOverlay extends StatefulWidget {
  @override
  State<_ChartShimmerOverlay> createState() => _ChartShimmerOverlayState();
}

class _ChartShimmerOverlayState extends State<_ChartShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.loadingPulse, // 1200ms - Toss shimmer timing
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                TossColors.surface.withValues(alpha: 0.0),
                TossColors.surface.withValues(alpha: 0.6),
                TossColors.surface.withValues(alpha: 0.0),
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
