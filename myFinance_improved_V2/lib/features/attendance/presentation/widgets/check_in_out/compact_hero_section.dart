import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../domain/entities/shift_card_data.dart';
import '../../../domain/value_objects/shift_status.dart';

class CompactHeroSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic>? shiftOverviewData;
  final List<ShiftCardData> allShiftCardsData;
  final String? currentDisplayedMonth;
  final ShiftStatus shiftStatus;

  const CompactHeroSection({
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

    // Show error state
    if (errorMessage != null) {
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

    // Show empty state
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

    // Parse data
    final requestMonth = shiftOverviewData!['request_month']?.toString() ?? '';
    final actualWorkDays = (shiftOverviewData!['actual_work_days'] as int?) ?? 0;
    final actualWorkHours = ((shiftOverviewData!['actual_work_hours'] ?? 0.0) as num).toDouble();
    final estimatedSalary = (shiftOverviewData!['estimated_salary'] as String?) ?? '0';
    final currencySymbol = (shiftOverviewData!['currency_symbol'] as String?) ?? '₩';
    final lateDeductionTotal = (shiftOverviewData!['late_deduction_total'] as int?) ?? 0;
    final overtimeTotal = (shiftOverviewData!['overtime_total'] as int?) ?? 0;

    // Calculate total shifts
    final currentMonthShifts = allShiftCardsData.where((card) {
      return card.requestDate.startsWith(currentDisplayedMonth ?? '');
    }).toList();
    final totalShifts = currentMonthShifts.length;

    // Parse month display
    String monthDisplay = 'Current Month';
    if (requestMonth.isNotEmpty) {
      final parts = requestMonth.split('-');
      if (parts.length == 2) {
        final year = parts[0];
        final month = int.tryParse(parts[1]) ?? DateTime.now().month;
        const monthNames = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        monthDisplay = '${monthNames[month - 1]} $year';
      }
    }

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
              // Header
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
                            color: shiftStatus.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          shiftStatus.displayText,
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
              _buildStatsGrid(
                totalShifts,
                actualWorkHours,
                actualWorkDays,
                estimatedSalary,
                currencySymbol,
              ),
              const SizedBox(height: TossSpacing.space5),
              // Additional Info
              if (lateDeductionTotal > 0 || overtimeTotal > 0)
                _buildAdditionalInfo(lateDeductionTotal, overtimeTotal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    int totalShifts,
    double actualWorkHours,
    int actualWorkDays,
    String estimatedSalary,
    String currencySymbol,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.calendar_today_outlined,
                label: 'Total Shifts',
                value: totalShifts.toString(),
                unit: 'shifts',
                color: TossColors.primary,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildStatCard(
                icon: Icons.access_time,
                label: 'Total Hours',
                value: actualWorkHours.toStringAsFixed(1),
                unit: 'hrs',
                color: TossColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.event_available,
                label: 'Work Days',
                value: actualWorkDays.toString(),
                unit: 'days',
                color: TossColors.success,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: _buildStatCard(
                icon: Icons.attach_money,
                label: 'Estimated',
                value: currencySymbol + estimatedSalary,
                unit: '',
                color: TossColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: TossSpacing.space2),
              Text(
                label,
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
                value,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: TossSpacing.space1),
                Text(
                  unit,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(int lateDeductionTotal, int overtimeTotal) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (lateDeductionTotal > 0)
            Column(
              children: [
                Text(
                  'Late',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.error,
                  ),
                ),
                Text(
                  '${lateDeductionTotal}min',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          if (overtimeTotal > 0)
            Column(
              children: [
                Text(
                  'Overtime',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.success,
                  ),
                ),
                Text(
                  '${overtimeTotal}min',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
