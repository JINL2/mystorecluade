import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Toss-style icon button with consistent styling
class TossIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final String? tooltip;
  final bool showBadge;
  final Color? badgeColor;

  const TossIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.tooltip,
    this.showBadge = false,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: iconColor ?? TossColors.gray700,
                size: iconSize ?? 24,
              ),
              if (showBadge)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: badgeColor ?? TossColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}