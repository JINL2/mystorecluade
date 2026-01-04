import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

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
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 100),
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
            const SizedBox(width: TossSpacing.space1),
          ],
          Text(
            label,
            style: TossTextStyles.small.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
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
        return TossColors.success;
      case BadgeStatus.warning:
        return TossColors.warning;
      case BadgeStatus.error:
        return TossColors.error;
      case BadgeStatus.info:
        return TossColors.info;
      case BadgeStatus.neutral:
        return TossColors.gray500;
    }
  }

  Color _getTextColor() {
    return TossColors.white;
  }
}

enum BadgeStatus {
  success,
  warning,
  error,
  info,
  neutral,
}

/// Subscription Plan Badge
///
/// Displays subscription plan as a small badge.
/// Colors: Free=Gray, Basic=Green, Pro=Blue
class SubscriptionBadge extends StatelessWidget {
  final String planType;
  final bool compact;

  const SubscriptionBadge({
    super.key,
    required this.planType,
    this.compact = false,
  });

  /// Create badge from plan type string
  factory SubscriptionBadge.fromPlanType(String? planType, {bool compact = false}) {
    return SubscriptionBadge(
      planType: planType ?? 'free',
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossBadge(
      label: _displayName,
      backgroundColor: _backgroundColor,
      textColor: _textColor,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? TossSpacing.space1 + 2 : TossSpacing.space2,
        vertical: compact ? 2 : TossSpacing.space1 - 2,
      ),
      // No border for cleaner look
    );
  }

  bool get _isFree => planType.toLowerCase() == 'free';
  bool get _isBasic => planType.toLowerCase() == 'basic';

  String get _displayName {
    switch (planType.toLowerCase()) {
      case 'basic':
        return 'Basic';
      case 'pro':
        return 'Pro';
      default:
        return 'Free';
    }
  }

  Color get _backgroundColor {
    if (_isFree) {
      return TossColors.gray100;
    } else if (_isBasic) {
      return TossColors.success;
    }
    return TossColors.info;
  }

  Color get _textColor {
    if (_isFree) {
      return TossColors.gray600;
    }
    return TossColors.white;
  }
}