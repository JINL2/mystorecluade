// lib/features/report_control/presentation/widgets/detail/ai_insights_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../domain/entities/templates/financial_summary/financial_report.dart';

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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary.withOpacity(0.05),
            TossColors.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: 20,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Analysis',
                style: TextStyle(
                  fontSize: 16,
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
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: TossColors.gray700,
            ),
          ),

          if (insights.trends.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Trends
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.trendingUp,
                  size: 16,
                  color: TossColors.gray600,
                ),
                SizedBox(width: 8),
                Text(
                  'Key Trends',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...insights.trends.map((trend) => Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 14,
                          color: TossColors.gray600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          trend,
                          style: const TextStyle(
                            fontSize: 13,
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
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.lightbulb,
                  size: 16,
                  color: TossColors.warning,
                ),
                SizedBox(width: 8),
                Text(
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...insights.recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 14,
                          color: TossColors.warning,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          rec,
                          style: const TextStyle(
                            fontSize: 13,
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
