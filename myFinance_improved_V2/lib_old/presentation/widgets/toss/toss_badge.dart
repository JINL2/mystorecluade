import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';

/// Non-interactive badge component for labels, statuses, and categories
class TossBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Border? border;
  
  const TossBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.iconSize,
    this.padding,
    this.borderRadius,
    this.border,
  });
  
  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? TossColors.gray50;
    final fgColor = textColor ?? TossColors.gray700;
    
    return Container(
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 6),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? 14,
              color: fgColor,
            ),
            SizedBox(width: TossSpacing.space1),
          ],
          Text(
            label,
            style: TossTextStyles.small.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge with predefined styles for common use cases
class TossStatusBadge extends StatelessWidget {
  final String label;
  final BadgeStatus status;
  final IconData? icon;
  
  const TossStatusBadge({
    super.key,
    required this.label,
    required this.status,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return TossBadge(
      label: label,
      backgroundColor: _getBackgroundColor(),
      textColor: _getTextColor(),
      icon: icon,
    );
  }
  
  Color _getBackgroundColor() {
    switch (status) {
      case BadgeStatus.success:
        return TossColors.success.withValues(alpha: 0.1);
      case BadgeStatus.warning:
        return TossColors.warning.withValues(alpha: 0.1);
      case BadgeStatus.error:
        return TossColors.error.withValues(alpha: 0.1);
      case BadgeStatus.info:
        return TossColors.info.withValues(alpha: 0.1);
      case BadgeStatus.neutral:
        return TossColors.gray50;
    }
  }
  
  Color _getTextColor() {
    switch (status) {
      case BadgeStatus.success:
        return TossColors.success;
      case BadgeStatus.warning:
        return TossColors.warning;
      case BadgeStatus.error:
        return TossColors.error;
      case BadgeStatus.info:
        return TossColors.info;
      case BadgeStatus.neutral:
        return TossColors.gray700;
    }
  }
}

enum BadgeStatus {
  success,
  warning,
  error,
  info,
  neutral,
}