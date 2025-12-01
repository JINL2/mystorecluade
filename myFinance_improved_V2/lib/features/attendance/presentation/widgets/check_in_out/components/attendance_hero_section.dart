import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_loading_view.dart';

class AttendanceHeroSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic>? shiftOverviewData;
  final List<Map<String, dynamic>> allShiftCardsData;
  final String? currentDisplayedMonth;
  final String shiftStatus;

  const AttendanceHeroSection({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.shiftOverviewData,
    required this.allShiftCardsData,
    this.currentDisplayedMonth,
    required this.shiftStatus,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TossColors.primary.withValues(alpha: 0.05),
                TossColors.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: const TossLoadingView(),
        ),
      );
    }

    // Show error state if there's an error
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: Text(
            errorMessage!,
            style: TossTextStyles.body.copyWith(color: TossColors.error),
          ),
        ),
      );
    }

    // If no data yet, show empty state
    if (shiftOverviewData == null) {
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

    // Parse data from the API response
    final requestMonth = shiftOverviewData!['request_month'] ?? '';
    final actualWorkHours = (shiftOverviewData!['actual_work_hours'] ?? 0).toDouble();
    final estimatedSalary = shiftOverviewData!['estimated_salary'] ?? '0';
    final currencySymbol = shiftOverviewData!['currency_symbol'] ?? '₩';
    final salaryAmount = (shiftOverviewData!['salary_amount'] ?? 0).toDouble();
    final lateDeductionTotal = shiftOverviewData!['late_deduction_total'] ?? 0;
    final overtimeTotal = shiftOverviewData!['overtime_total'] ?? 0;

    // Calculate total unique shifts from the shift cards data for the current month
    final currentMonthShifts = allShiftCardsData.where((card) {
      final requestDate = card['request_date']?.toString() ?? '';
      return requestDate.startsWith(currentDisplayedMonth ?? '');
    }).toList();

    final totalShifts = currentMonthShifts.length;

    // Parse month and year from request_month (format: "2025-08")
    String monthDisplay = 'Current Month';
    if (requestMonth != null && requestMonth.toString().isNotEmpty) {
      final parts = requestMonth.toString().split('-');
      if (parts.length == 2) {
        final year = parts[0];
        final month = int.tryParse(parts[1]) ?? DateTime.now().month;
        final monthNames = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        monthDisplay = '${monthNames[month - 1]} $year';
      }
    }

    // Toss-style overview section
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TossColors.primary.withValues(alpha: 0.08),
              TossColors.primary.withValues(alpha: 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Month and Status
              Row(
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
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(shiftStatus),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          _getStatusText(shiftStatus),
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space6),

              // Stats Grid - 2x2 layout
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: TossColors.primary,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Total Shifts',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                totalShifts.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'shifts',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.info.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: TossColors.info,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Total Hours',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                (actualWorkHours as num).toStringAsFixed(1),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'hrs',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space3),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.success.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 18,
                                color: TossColors.success,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Overtime',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                overtimeTotal.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'min',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.trending_down,
                                size: 18,
                                color: TossColors.warning,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Late Deduct',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                lateDeductionTotal.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'min',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space5),

              // Estimated Salary Card
              Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          decoration: BoxDecoration(
                            color: TossColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 20,
                            color: TossColors.primary,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Text(
                          'Estimated Salary',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$currencySymbol$estimatedSalary',
                          style: TossTextStyles.display.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                          ),
                        ),
                        if (overtimeTotal != null && (overtimeTotal as num) > 0) ...[
                          const SizedBox(height: TossSpacing.space1),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space2,
                                  vertical: TossSpacing.space1,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: Text(
                                  '+$currencySymbol${((overtimeTotal as num) * (salaryAmount as num) / 60).toStringAsFixed(0)}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.success,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'overtime bonus',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.success; // Green for currently working
      case 'finished':
        return TossColors.primary; // Blue for finished shift
      case 'scheduled':
        return TossColors.warning; // Orange for has shift today
      case 'off_duty':
      default:
        return TossColors.gray400; // Gray for off duty
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'working':
        return 'Working';
      case 'finished':
        return 'Finished';
      case 'scheduled':
        return 'Shift Today';
      case 'off_duty':
      default:
        return 'Off Duty';
    }
  }
}
