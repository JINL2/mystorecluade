// lib/features/report_control/presentation/pages/templates/cash_location/widgets/ai_recommendations_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../domain/entities/cash_location_report.dart';

/// AI recommendations card
///
/// Shows summary and actionable recommendations
class AiRecommendationsCard extends StatelessWidget {
  final CashLocationInsights insights;

  const AiRecommendationsCard({
    super.key,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: const Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'AI Recommendations',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Summary
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Text(
              insights.summary,
              style: TossTextStyles.bodySmall.copyWith(
                height: 1.5,
                color: TossColors.gray700,
              ),
            ),
          ),

          // Recommendations
          Container(
            margin: const EdgeInsets.fromLTRB(TossSpacing.space4, 0, TossSpacing.space4, TossSpacing.space4),
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF), // Light purple
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.lightbulb,
                      size: 14,
                      color: const Color(0xFF7C3AED),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Next Steps',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...insights.recommendations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rec = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: TossSpacing.space2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TossTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF7C3AED),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rec,
                            style: TossTextStyles.bodySmall.copyWith(
                              height: 1.4,
                              color: TossColors.gray700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
