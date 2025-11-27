import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../widgets/stats/hero_salary_display.dart';
import '../widgets/stats/performance_kpi_card.dart';
import '../widgets/stats/salary_breakdown_card.dart';
import '../widgets/stats/salary_trend_section.dart';

/// StatsTab - Attendance statistics and salary overview
class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  String _selectedPeriod = 'This Month';

  final List<String> _periods = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  void _showPeriodSelector() {
    // Convert periods to TossSelectionItem
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Salary Display
          HeroSalaryDisplay(
            title: 'Estimated Salary $_selectedPeriod',
            amount: '12,450,000đ',
            growthText: '+4.2% vs last month',
            isPositiveGrowth: true,
            onTitleTap: _showPeriodSelector,
          ),

          const SizedBox(height: 20),

          // Performance KPI Card
          const PerformanceKpiCard(
            ontimeRate: '92%',
            completedShifts: '38 shifts',
            reliabilityScore: '81 / 100',
          ),

          const SizedBox(height: 20),

          // Salary Breakdown Card
          const SalaryBreakdownCard(
            totalConfirmedTime: '120h 30m',
            hourlySalary: '85,000đ',
            basePay: '10,200,000đ',
            bonusPay: '1,450,000đ',
            totalPayment: '12,700,000đ',
          ),

          const SizedBox(height: 20),

          // Salary Trend Section (Interactive Chart)
          SalaryTrendSection(
            weeklyData: const [
              11500000, // W1
              11200000, // W2
              12100000, // W3
              12400000, // W4
              12700000, // W5 (current)
            ],
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
  }
}
