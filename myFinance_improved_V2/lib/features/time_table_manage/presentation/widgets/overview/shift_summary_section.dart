import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/manager_overview.dart';
import 'manager_stats_card.dart';

/// Shift Summary Section
///
/// Displays summary statistics for shifts
class ShiftSummarySection extends StatelessWidget {
  final ManagerOverview overview;

  const ShiftSummarySection({
    super.key,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Month Summary',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: TossSpacing.marginMD),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: TossSpacing.marginMD,
          crossAxisSpacing: TossSpacing.marginMD,
          childAspectRatio: 1.5,
          children: [
            ManagerStatsCard(
              title: 'Total Shifts',
              value: '${overview.totalShifts}',
              icon: Icons.calendar_today,
              color: TossColors.primary,
            ),
            ManagerStatsCard(
              title: 'Pending Requests',
              value: '${overview.totalPendingRequests}',
              icon: Icons.pending_actions,
              color: TossColors.warning,
            ),
            ManagerStatsCard(
              title: 'Approved Requests',
              value: '${overview.totalApprovedRequests}',
              icon: Icons.check_circle,
              color: TossColors.success,
            ),
            ManagerStatsCard(
              title: 'Approval Rate',
              value: '${overview.approvalRate.toStringAsFixed(1)}%',
              subtitle: 'Of Total Requests',
              icon: Icons.trending_up,
              color: TossColors.info,
            ),
          ],
        ),
      ],
    );
  }
}
