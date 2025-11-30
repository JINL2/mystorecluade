import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../domain/entities/user_shift_stats.dart';
import '../providers/attendance_providers.dart';
import '../widgets/stats/hero_salary_display.dart';
import '../widgets/stats/performance_kpi_card.dart';
import '../widgets/stats/salary_breakdown_card.dart';
import '../widgets/stats/salary_trend_section.dart';

/// StatsTab - Attendance statistics and salary overview
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
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.alertCircle, size: 48, color: TossColors.gray400),
            const SizedBox(height: 16),
            const Text(
              'Failed to load stats',
              style: TextStyle(color: TossColors.gray600),
            ),
            const SizedBox(height: 8),
            TossButton1.secondary(
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

        // Debug log
        assert(() {
          debugPrint('📊 [StatsTab] Selected Period: $_selectedPeriod');
          debugPrint('📊 [StatsTab] totalPayment: ${periodStats.totalPayment}');
          debugPrint('📊 [StatsTab] changePercentage: ${periodStats.changePercentage}');
          debugPrint('📊 [StatsTab] totalConfirmedHours: ${periodStats.totalConfirmedHours}');
          return true;
        }());

        final symbol = stats.salaryInfo.currencySymbol;
        final salaryType = stats.salaryInfo.salaryType;
        final salaryAmount = stats.salaryInfo.salaryAmount;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Salary Display
              HeroSalaryDisplay(
                title: 'Estimated Salary $_selectedPeriod',
                amount: _formatCurrency(periodStats.totalPayment, symbol),
                growthText: '${periodStats.formattedChangePercentage} vs previous',
                isPositiveGrowth: periodStats.isPositiveChange,
                onTitleTap: _showPeriodSelector,
              ),

              const SizedBox(height: 20),

              // Performance KPI Card
              PerformanceKpiCard(
                ontimeRate: '${periodStats.onTimeRate.toStringAsFixed(0)}%',
                completedShifts: '${periodStats.completeShifts} shifts',
                reliabilityScore: '${periodStats.onTimeRate.toStringAsFixed(0)} / 100',
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 20),

              // Salary Trend Section (Interactive Chart)
              SalaryTrendSection(
                weeklyData: stats.weeklyPayments.toChartList(),
                footerNote:
                    'Attendance data is based on your check-in/out history.\nConfirmed attendance is approved by your manager.',
              ),

              const SizedBox(height: 24),

              // Report Issue Button
              TossButton1.secondary(
                text: 'Report an issue with this shift',
                leadingIcon: const Icon(LucideIcons.alertCircle, size: 18),
                fullWidth: true,
                textColor: TossColors.gray600,
                onPressed: () {
                  // TODO: Implement report issue functionality
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
