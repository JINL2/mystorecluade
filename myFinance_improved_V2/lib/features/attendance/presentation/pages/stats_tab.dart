import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/themes/index.dart';
import '../../domain/entities/user_shift_stats.dart';
import '../providers/attendance_providers.dart';
import '../widgets/stats/hero_salary_display.dart';
import '../widgets/stats/performance_kpi_card.dart';
import '../widgets/stats/salary_breakdown_card.dart';
import '../widgets/stats/salary_trend_section.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// StatsTab - Attendance statistics and salary overview
/// Shows company-wide salary data (not store-specific)
class StatsTab extends ConsumerStatefulWidget {
  const StatsTab({super.key});

  @override
  ConsumerState<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends ConsumerState<StatsTab> {
  String _selectedPeriod = 'This Month';

  final List<String> _periods = [
    'Today',
    'This Week',
    'This Month',
    'Last Month',
    'This Year',
  ];

  void _showPeriodSelector() {
    final items = _periods.map((period) {
      return TossSelectionItem.fromGeneric(
        id: period,
        title: period,
        icon: LucideIcons.calendar,
      );
    }).toList();

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Select Period',
      items: items,
      selectedId: _selectedPeriod,
      showSubtitle: false,
      checkIcon: Icons.check,
      onItemSelected: (item) {
        setState(() {
          _selectedPeriod = item.id;
        });
      },
    );
  }

  /// Get period stats based on selected period
  PeriodStats? _getPeriodStats(UserShiftStats stats) {
    switch (_selectedPeriod) {
      case 'Today':
        return stats.today;
      case 'This Week':
        return stats.thisWeek;
      case 'This Month':
        return stats.thisMonth;
      case 'Last Month':
        return stats.lastMonth;
      case 'This Year':
        return stats.thisYear;
      default:
        return stats.thisMonth;
    }
  }

  /// Get the previous period label for comparison text
  String _getPreviousPeriodLabel() {
    switch (_selectedPeriod) {
      case 'Today':
        return 'yesterday';
      case 'This Week':
        return 'last week';
      case 'This Month':
        return 'last month';
      case 'Last Month':
        return 'previous month';
      case 'This Year':
        return 'last year';
      default:
        return 'previous';
    }
  }

  /// Format currency amount with symbol
  String _formatCurrency(double amount, String symbol) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '${isNegative ? '-' : ''}$formatted$symbol';
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(userShiftStatsProvider);

    return statsAsync.when(
      loading: () => const TossLoadingView(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.alertCircle, size: TossSpacing.iconXXL, color: TossColors.gray400),
            SizedBox(height: TossSpacing.space4),
            const Text(
              'Failed to load stats',
              style: TextStyle(color: TossColors.gray600),
            ),
            SizedBox(height: TossSpacing.space2),
            TossButton.secondary(
              text: 'Retry',
              onPressed: () => ref.invalidate(userShiftStatsProvider),
            ),
          ],
        ),
      ),
      data: (stats) {
        if (stats == null) {
          return const Center(
            child: Text('No data available'),
          );
        }

        final periodStats = _getPeriodStats(stats);
        if (periodStats == null) {
          return const Center(
            child: Text('No period data available'),
          );
        }

        final symbol = stats.salaryInfo.currencySymbol;
        final salaryType = stats.salaryInfo.salaryType;
        final salaryAmount = stats.salaryInfo.salaryAmount;

        // Format date for subtitle (e.g., "As of Dec/05")
        final now = DateTime.now();
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final dateSubtitle = 'As of ${months[now.month - 1]}/${now.day.toString().padLeft(2, '0')}';

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Extra spacing above content (matching MyScheduleTab)
              const SizedBox(height: TossSpacing.space4),
              // Hero Salary Display (company-wide data)
              Padding(
                padding: EdgeInsets.all(TossSpacing.paddingMD),
                child: HeroSalaryDisplay(
                  title: 'Estimated Salary $_selectedPeriod',
                  amount: _formatCurrency(periodStats.totalPayment, symbol),
                  growthText: '${periodStats.formattedChangePercentage} vs ${_getPreviousPeriodLabel()}',
                  isPositiveGrowth: periodStats.isPositiveChange,
                  onTitleTap: _showPeriodSelector,
                ),
              ),

              SizedBox(height: TossSpacing.space2),

              // Performance KPI Card
              Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
                child: PerformanceKpiCard(
                  ontimeRate: '${periodStats.onTimeRate.toStringAsFixed(0)}%',
                  ontimeRateChange: '+1.5%', // TODO: Get from backend - format: "+1.5%" or "-0.2%"
                  completedShifts: '${periodStats.completeShifts}',
                  completedShiftsChange: '+0.8%', // TODO: Get from backend - format: "+0.8%" or "-0.5%"
                  reliabilityScore: stats.reliabilityScore.finalScore.toStringAsFixed(1),
                  reliabilityScoreChange: '-0.2%', // TODO: Get from backend - format: "+2.1%" or "-0.2%"
                  scoreBreakdown: stats.reliabilityScore.scoreBreakdown,
                ),
              ),

              SizedBox(height: TossSpacing.space4),

              // Gray Divider before Salary Breakdown
              const GrayDividerSpace(),

              // Salary Breakdown Section
              Padding(
                padding: EdgeInsets.all(TossSpacing.paddingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      'Salary Breakdown $_selectedPeriod',
                      style: TossTextStyles.h4.copyWith(
                        fontWeight: TossFontWeight.bold,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      dateSubtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space5),

                    // Salary Breakdown Card
                    SalaryBreakdownCard(
                      totalConfirmedTime: periodStats.formattedHours,
                      hourlySalary: salaryType == 'hourly'
                          ? _formatCurrency(salaryAmount, symbol)
                          : '-',
                      basePay: _formatCurrency(periodStats.basePay, symbol),
                      bonusPay: _formatCurrency(periodStats.bonusPay, symbol),
                      totalPayment: _formatCurrency(periodStats.totalPayment, symbol),
                    ),
                  ],
                ),
              ),

              // Gray Divider before Salary Trend
              const GrayDividerSpace(),

              // Salary Trend Section (Interactive Chart)
              Padding(
                padding: EdgeInsets.all(TossSpacing.paddingMD),
                child: SalaryTrendSection(
                  weeklyData: stats.weeklyPayments.toChartList(),
                  footerNote:
                      'Attendance data is based on your check-in/out history.\nConfirmed attendance is approved by your manager.',
                ),
              ),

              SizedBox(height: TossSpacing.paddingMD),
            ],
          ),
        );
      },
    );
  }
}
