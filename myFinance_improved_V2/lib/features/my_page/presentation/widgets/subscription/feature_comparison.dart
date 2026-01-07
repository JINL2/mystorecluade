import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';

import 'subscription_models.dart';

/// Feature comparison table showing Free vs Basic vs Pro
class FeatureComparison extends StatelessWidget {
  const FeatureComparison({super.key});

  static const _features = [
    FeatureRowData('Stores', 'Free', '1', 'Basic', '5', 'Pro', '∞'),
    FeatureRowData('Employees', 'Free', '3', 'Basic', '10', 'Pro', '∞'),
    FeatureRowData('AI Reports', 'Free', '5/day', 'Basic', '20/day', 'Pro', '∞'),
    FeatureRowData('Analytics', 'Free', 'Basic', 'Basic', 'Advanced', 'Pro', 'All'),
    FeatureRowData('Support', 'Free', 'Email', 'Basic', 'Priority', 'Pro', '24/7'),
    FeatureRowData('API Access', 'Free', '✗', 'Basic', '✗', 'Pro', '✓'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compare Plans',
            style: TossTextStyles.h3.copyWith(
              fontWeight: TossFontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: TossColors.gray200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: SizedBox()),
                      Expanded(
                        child: Text(
                          'Free',
                          textAlign: TextAlign.center,
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray500,
                            fontWeight: TossFontWeight.semibold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Basic',
                          textAlign: TextAlign.center,
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.emerald,
                            fontWeight: TossFontWeight.semibold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Pro',
                          textAlign: TextAlign.center,
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.primary,
                            fontWeight: TossFontWeight.semibold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Rows
                ..._features.asMap().entries.map((entry) {
                  final index = entry.key;
                  final feature = entry.value;
                  final isLast = index == _features.length - 1;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(color: TossColors.gray200),
                            ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            feature.name,
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.gray700,
                              fontWeight: TossFontWeight.medium,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature.freeValue,
                            textAlign: TextAlign.center,
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature.basicValue,
                            textAlign: TextAlign.center,
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature.proValue,
                            textAlign: TextAlign.center,
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.primary,
                              fontWeight: TossFontWeight.semibold,
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
