import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Monthly/Annual toggle with savings badge
class PricingToggle extends StatelessWidget {
  final bool isAnnual;
  final ValueChanged<bool> onToggle;

  const PricingToggle({
    super.key,
    required this.isAnnual,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      padding: const EdgeInsets.all(TossSpacing.space1),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onToggle(false);
              },
              child: AnimatedContainer(
                duration: TossAnimations.normal,
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: !isAnnual ? TossColors.white : TossColors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !isAnnual
                      ? [
                          BoxShadow(
                            color: TossColors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Monthly',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: !isAnnual ? FontWeight.w700 : FontWeight.w500,
                      color: !isAnnual ? TossColors.gray900 : TossColors.gray500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onToggle(true);
              },
              child: AnimatedContainer(
                duration: TossAnimations.normal,
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: isAnnual ? TossColors.white : TossColors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isAnnual
                      ? [
                          BoxShadow(
                            color: TossColors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Annual',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: isAnnual ? FontWeight.w700 : FontWeight.w500,
                        color: isAnnual ? TossColors.gray900 : TossColors.gray500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Savings badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1 + 2, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                      child: Text(
                        '-40%',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
