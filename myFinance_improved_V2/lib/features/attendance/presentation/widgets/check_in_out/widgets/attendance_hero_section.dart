import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_loading_view.dart';
import '../utils/hero_section_helpers.dart';
import 'hero_salary_card.dart';
import 'hero_stat_card.dart';

/// Hero section widget displaying monthly attendance overview
///
/// Shows:
/// - Monthly overview with stats grid (total shifts, hours, overtime, late deductions)
/// - Estimated salary card
/// - Loading, error, and empty states
class AttendanceHeroSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic>? shiftOverviewData;
  final List<Map<String, dynamic>> allShiftCardsData;
  final String? currentDisplayedMonth;
  final String shiftStatus;
  final Color Function(String) getStatusColor;
  final String Function(String) getStatusText;

  const AttendanceHeroSection({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.shiftOverviewData,
    required this.allShiftCardsData,
    this.currentDisplayedMonth,
    required this.shiftStatus,
    required this.getStatusColor,
    required this.getStatusText,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (isLoading) {
      return _buildLoadingState();
    }

    // Show error state if there's an error
    if (errorMessage != null) {
      return _buildErrorState();
    }

    // If no data yet, show empty state
    if (shiftOverviewData == null) {
      return _buildEmptyState();
    }

    return _buildContent();
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TossColors.primary.withOpacity(0.05),
              TossColors.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        child: const TossLoadingView(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        decoration: BoxDecoration(
          color: TossColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        child: Text(
          errorMessage!,
          style: TossTextStyles.body.copyWith(color: TossColors.error),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        child: Center(
          child: Text(
            'No data available',
            style: TossTextStyles.body.copyWith(color: TossColors.gray600),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Parse data from the API response
    final requestMonth = (shiftOverviewData!['request_month'] ?? '') as String;
    final actualWorkHours = (shiftOverviewData!['actual_work_hours'] as num?)?.toDouble() ?? 0.0;
    final estimatedSalary = (shiftOverviewData!['estimated_salary'] ?? '0') as String;
    final currencySymbol = (shiftOverviewData!['currency_symbol'] ?? '₩') as String;
    final salaryAmount = (shiftOverviewData!['salary_amount'] as num?)?.toDouble() ?? 0.0;
    final lateDeductionTotal = shiftOverviewData!['late_deduction_total'] ?? 0;
    final overtimeTotal = shiftOverviewData!['overtime_total'] ?? 0;

    final totalShifts = HeroSectionHelpers.calculateTotalShifts(
      allShiftCardsData,
      currentDisplayedMonth,
    );

    final monthDisplay = HeroSectionHelpers.getMonthDisplay(requestMonth);
    final overtimeBonus = HeroSectionHelpers.calculateOvertimeBonus(
      overtimeTotal,
      salaryAmount,
      currencySymbol,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TossColors.primary.withOpacity(0.08),
              TossColors.primary.withOpacity(0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(monthDisplay),
              const SizedBox(height: TossSpacing.space6),
              _buildStatsGrid(
                totalShifts,
                actualWorkHours,
                overtimeTotal.toString(),
                lateDeductionTotal.toString(),
              ),
              const SizedBox(height: TossSpacing.space5),
              HeroSalaryCard(
                currencySymbol: currencySymbol,
                estimatedSalary: estimatedSalary,
                overtimeBonus: overtimeBonus.isNotEmpty ? overtimeBonus : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String monthDisplay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthDisplay,
              style: TossTextStyles.h2.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              'Monthly Overview',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: getStatusColor(shiftStatus),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            getStatusText(shiftStatus),
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    int totalShifts,
    double actualWorkHours,
    String overtimeTotal,
    String lateDeductionTotal,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HeroStatCard(
                icon: Icons.calendar_today_outlined,
                iconColor: TossColors.primary,
                backgroundColor: TossColors.primary.withOpacity(0.08),
                label: 'Total Shifts',
                value: totalShifts.toString(),
                unit: 'shifts',
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: HeroStatCard(
                icon: Icons.access_time,
                iconColor: TossColors.info,
                backgroundColor: TossColors.info.withOpacity(0.08),
                label: 'Total Hours',
                value: (actualWorkHours as num).toStringAsFixed(1),
                unit: 'hrs',
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: HeroStatCard(
                icon: Icons.trending_up,
                iconColor: TossColors.success,
                backgroundColor: TossColors.success.withOpacity(0.08),
                label: 'Overtime',
                value: overtimeTotal,
                unit: 'min',
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: HeroStatCard(
                icon: Icons.trending_down,
                iconColor: TossColors.warning,
                backgroundColor: TossColors.warning.withOpacity(0.08),
                label: 'Late Deduct',
                value: lateDeductionTotal,
                unit: 'min',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
