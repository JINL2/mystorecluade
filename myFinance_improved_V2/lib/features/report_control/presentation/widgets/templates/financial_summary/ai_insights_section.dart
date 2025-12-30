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
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary.withOpacity(0.05),
            TossColors.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.1),
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
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: 20,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AI Analysis',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Summary
          Text(
            insights.summary,
            style: TossTextStyles.body.copyWith(
              height: 1.6,
              color: TossColors.gray700,
            ),
          ),

          if (insights.trends.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Trends
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.trendingUp,
                  size: 16,
                  color: TossColors.gray600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Key Trends',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Recommendations
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  LucideIcons.lightbulb,
                  size: 16,
                  color: TossColors.warning,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recommendations',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
