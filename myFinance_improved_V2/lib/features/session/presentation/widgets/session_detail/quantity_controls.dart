import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Quantity row with label and controls
class QuantityRow extends StatelessWidget {
  final String label;
  final int quantity;
  final Color color;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const QuantityRow({
    super.key,
    required this.label,
    required this.quantity,
    required this.color,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Label
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Controls
          QuantityButton(
            icon: Icons.remove,
            onTap: onDecrement,
            small: true,
          ),
          Container(
            width: 32,
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          QuantityButton(
            icon: Icons.add,
            onTap: onIncrement,
            small: true,
          ),
        ],
      ),
    );
  }
}

/// Quantity adjustment button
class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool small;

  const QuantityButton({
    super.key,
    required this.icon,
    this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 28.0 : 32.0;
    final iconSize = small ? 16.0 : 18.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: onTap != null ? TossColors.gray200 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: onTap != null ? TossColors.textPrimary : TossColors.textTertiary,
        ),
      ),
    );
  }
}
