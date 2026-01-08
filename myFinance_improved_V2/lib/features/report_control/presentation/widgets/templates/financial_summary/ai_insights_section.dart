// lib/features/report_control/presentation/widgets/detail/ai_insights_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/report_detail.dart';

/// AI Insights Section
///
/// Displays AI-generated summary, trends, and recommendations.
class AiInsightsSection extends StatelessWidget {
  final AiInsights insights;

  const AiInsightsSection({
    super.key,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary.withValues(alpha: TossOpacity.subtle),
            TossColors.primary.withValues(alpha: TossOpacity.subtle),
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: TossOpacity.light),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: TossSpacing.iconMD,
                  color: TossColors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                'AI Analysis',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: TossFontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space4),

          // Summary
          Text(
            insights.summary,
            style: TossTextStyles.body.copyWith(
              height: 1.6,
              color: TossColors.gray700,
            ),
          ),

          if (insights.trends.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space4),
            const Divider(),
            SizedBox(height: TossSpacing.space4),

            // Trends
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.trendingUp,
                  size: TossSpacing.iconSM2,
                  color: TossColors.gray600,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Key Trends',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space2),
            ...insights.trends.map((trend) => Padding(
                  padding: const EdgeInsets.only(left: TossSpacing.space6, bottom: TossSpacing.space2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          trend,
                          style: TossTextStyles.bodySmall.copyWith(
                            height: 1.5,
                            color: TossColors.gray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),),
          ],

          if (insights.recommendations.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space4),
            const Divider(),
            SizedBox(height: TossSpacing.space4),

            // Recommendations
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.lightbulb,
                  size: TossSpacing.iconSM2,
                  color: TossColors.warning,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Recommendations',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space2),
            ...insights.recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(left: TossSpacing.space6, bottom: TossSpacing.space2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.warning,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          rec,
                          style: TossTextStyles.bodySmall.copyWith(
                            height: 1.5,
                            color: TossColors.gray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),),
          ],
        ],
      ),
    );
  }
}
