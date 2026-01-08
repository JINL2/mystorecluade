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
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Container(
                  width: TossDimensions.avatarMD,
                  height: TossDimensions.avatarMD,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [TossColors.violet, TossColors.purpleDark],
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    LucideIcons.sparkles,
                    size: TossSpacing.iconSM2,
                    color: TossColors.white,
                  ),
                ),
                SizedBox(width: TossSpacing.space2_5),
                Text(
                  'AI Recommendations',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Summary
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
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
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.purpleSurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.lightbulb,
                      size: TossSpacing.iconXS,
                      color: TossColors.purple,
                    ),
                    SizedBox(width: TossSpacing.space1_5),
                    Text(
                      'Next Steps',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space2_5),
                ...insights.recommendations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rec = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: TossSpacing.space2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: TossSpacing.iconSM,
                          height: TossSpacing.iconSM,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            color: TossColors.purple.withValues(alpha: TossOpacity.light),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TossTextStyles.labelSmall.copyWith(
                                fontWeight: TossFontWeight.semibold,
                                color: TossColors.purple,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
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
