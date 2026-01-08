// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/salary_insights_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../domain/entities/monthly_salary_report.dart';

/// AI Insights Card for Salary Report
class SalaryInsightsCard extends StatelessWidget {
  final SalaryInsights insights;

  const SalaryInsightsCard({
    super.key,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: TossDimensions.avatarMD,
                height: TossDimensions.avatarMD,
                decoration: BoxDecoration(
                  color: TossColors.purpleLight,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: TossSpacing.iconSM2,
                  color: TossColors.purple,
                ),
              ),
              SizedBox(width: TossSpacing.space2_5),
              Text(
                'AI Insights',
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space4),

          // Summary
          if (insights.summary.isNotEmpty) ...[
            Text(
              insights.summary,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
                height: 1.5,
              ),
            ),
            SizedBox(height: TossSpacing.space4),
          ],

          // Attention Required
          if (insights.attentionRequired.isNotEmpty) ...[
            _buildSection(
              title: 'Attention Required',
              icon: LucideIcons.alertTriangle,
              color: TossColors.red,
              items: insights.attentionRequired,
            ),
            SizedBox(height: TossSpacing.space3),
          ],

          // Recommendations
          if (insights.recommendations.isNotEmpty)
            _buildSection(
              title: 'Recommendations',
              icon: LucideIcons.lightbulb,
              color: TossColors.amber,
              items: insights.recommendations,
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: TossSpacing.iconXS, color: color),
            SizedBox(width: TossSpacing.space1_5),
            Text(
              title,
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space1 + TossSpacing.space1 / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: TossDimensions.timelineDotSmall,
                    height: TossDimensions.timelineDotSmall,
                    margin: EdgeInsets.only(top: TossSpacing.space1_5, right: TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: TossOpacity.scrim),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
