// lib/features/report_control/presentation/pages/templates/daily_attendance/widgets/overview_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../../shared/themes/toss_shadows.dart';
import '../../../../../domain/entities/templates/daily_attendance/attendance_report.dart';

/// Overview Section - Minimal one-line summary
class OverviewSection extends StatelessWidget {
  final DateTime reportDate;
  final HeroStats heroStats;
  final String? aiSummary;

  const OverviewSection({
    super.key,
    required this.reportDate,
    required this.heroStats,
    this.aiSummary,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(reportDate);

    final solvedCount = heroStats.solvedCount ?? 0;
    final unsolvedCount = heroStats.unsolvedCount ?? 0;

    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Date + Stats
          Row(
            children: [
              // Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: TossTextStyles.h4.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      '${heroStats.totalShifts} shifts',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              // Stats summary
              Row(
                children: [
                  // Total Issues
                  Icon(
                    LucideIcons.alertCircle,
                    size: 16,
                    color: heroStats.totalIssues > 0
                        ? TossColors.error
                        : TossColors.gray400,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '${heroStats.totalIssues}',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: heroStats.totalIssues > 0
                          ? TossColors.error
                          : TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(width: TossSpacing.space3),

                  // Resolved
                  Icon(
                    LucideIcons.checkCircle,
                    size: 16,
                    color: TossColors.success,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '$solvedCount',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(width: TossSpacing.space3),

                  // Pending
                  Icon(
                    LucideIcons.clock,
                    size: 16,
                    color:
                        unsolvedCount > 0 ? TossColors.warning : TossColors.gray400,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '$unsolvedCount',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: unsolvedCount > 0
                          ? TossColors.warning
                          : TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // AI Summary (if available)
          if (aiSummary != null) ...[
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.paddingSM),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: TossColors.primary,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      aiSummary!,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
