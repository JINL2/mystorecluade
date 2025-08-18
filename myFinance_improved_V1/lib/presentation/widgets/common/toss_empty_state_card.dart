import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Empty state card widget for displaying messages in a styled container
class TossEmptyStateCard extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const TossEmptyStateCard({
    super.key,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor ?? TossColors.gray500,
                size: 24,
              ),
              const SizedBox(height: TossSpacing.space2),
            ],
            Text(
              message,
              style: TossTextStyles.body.copyWith(
                color: textColor ?? TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}