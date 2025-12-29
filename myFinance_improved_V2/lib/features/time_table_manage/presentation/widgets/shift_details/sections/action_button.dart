import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Reusable action button for bottom sheet actions
class ShiftDetailsActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final bool outlined;
  final bool disabled;

  const ShiftDetailsActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    this.onTap,
    this.outlined = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = disabled ? TossColors.gray300 : color;

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: outlined
                ? TossColors.transparent
                : (disabled ? TossColors.gray100 : effectiveColor),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: outlined
                  ? (disabled
                      ? TossColors.gray200
                      : effectiveColor.withValues(alpha: 0.3))
                  : (disabled ? TossColors.gray200 : effectiveColor),
              width: outlined ? 1.5 : 0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: disabled
                    ? TossColors.gray400
                    : (outlined ? effectiveColor : TossColors.white),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: disabled
                      ? TossColors.gray400
                      : (outlined ? effectiveColor : TossColors.white),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
