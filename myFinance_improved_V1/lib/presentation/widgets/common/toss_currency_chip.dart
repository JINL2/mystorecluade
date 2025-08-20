import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';

/// Currency chip selector widget for displaying currency options
class TossCurrencyChip extends StatelessWidget {
  final String currencyId;
  final String symbol;
  final String currencyCode;
  final bool isSelected;
  final VoidCallback onTap;
  final bool enableHaptic;

  const TossCurrencyChip({
    super.key,
    required this.currencyId,
    required this.symbol,
    required this.currencyCode,
    required this.isSelected,
    required this.onTap,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enableHaptic) {
          HapticFeedback.selectionClick();
        }
        onTap();
      },
      child: AnimatedContainer(
        duration: TossAnimations.normal,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              symbol,
              style: TossTextStyles.body.copyWith(
                color: isSelected ? TossColors.white : TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              currencyCode,
              style: TossTextStyles.caption.copyWith(
                color: isSelected
                    ? TossColors.white.withOpacity(0.9)
                    : TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}