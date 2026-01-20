import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Badge status types for semantic coloring
///
/// Includes both task/order statuses AND subscription plans
enum BadgeStatus {
  // Task/Order statuses
  success,
  warning,
  error,
  info,
  neutral,

  // Subscription plans (merged from SubscriptionBadge)
  free,
  basic,
  pro,
}

/// Unified badge component for labels and statuses
///
/// A non-interactive display atom with variants:
/// - **Default**: Basic badge with custom colors
/// - **Status**: Predefined semantic colors for statuses and plans
/// - **Growth**: Percentage change with arrow (↑12.5% / ↓3.2%)
///
/// Usage:
/// ```dart
/// // Default badge
/// TossBadge(label: 'New')
///
/// // Status badge - for order/task status
/// TossBadge.status(label: 'Active', status: BadgeStatus.success)
/// TossBadge.status(label: 'Pending', status: BadgeStatus.warning)
///
/// // Subscription plans - also use .status()
/// TossBadge.status(label: 'Free', status: BadgeStatus.free)
/// TossBadge.status(label: 'Basic', status: BadgeStatus.basic)
/// TossBadge.status(label: 'Pro', status: BadgeStatus.pro)
///
/// // Growth badge - for analytics
/// TossBadge.growth(value: 12.5)  // Shows ↑12.5%
/// ```
class TossBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Border? border;
  final double? fontSize;

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
    this.fontSize,
  });

  // ══════════════════════════════════════════════════════════════════════════
  // FACTORY: Status Badge
  // Use for: Order status, task status, alerts, subscription plans
  // ══════════════════════════════════════════════════════════════════════════

  /// Status badge with predefined semantic colors
  ///
  /// Includes both task statuses AND subscription plans:
  /// ```dart
  /// // Task/Order statuses
  /// TossBadge.status(label: 'Active', status: BadgeStatus.success)
  /// TossBadge.status(label: 'Pending', status: BadgeStatus.warning)
  /// TossBadge.status(label: 'Failed', status: BadgeStatus.error)
  ///
  /// // Subscription plans
  /// TossBadge.status(label: 'Free', status: BadgeStatus.free)
  /// TossBadge.status(label: 'Basic', status: BadgeStatus.basic)
  /// TossBadge.status(label: 'Pro', status: BadgeStatus.pro)
  /// ```
  factory TossBadge.status({
    Key? key,
    required String label,
    required BadgeStatus status,
    IconData? icon,
    bool compact = false,
  }) {
    final (bgColor, fgColor) = _getStatusColors(status);
    return TossBadge(
      key: key,
      label: label,
      backgroundColor: bgColor,
      textColor: fgColor,
      icon: icon,
      padding: compact
          ? const EdgeInsets.symmetric(
              horizontal: TossSpacing.space1 + 2,
              vertical: 2,
            )
          : null,
    );
  }

  static (Color, Color) _getStatusColors(BadgeStatus status) {
    return switch (status) {
      // Task/Order statuses
      BadgeStatus.success => (TossColors.success, TossColors.white),
      BadgeStatus.warning => (TossColors.warning, TossColors.white),
      BadgeStatus.error => (TossColors.error, TossColors.white),
      BadgeStatus.info => (TossColors.info, TossColors.white),
      BadgeStatus.neutral => (TossColors.gray500, TossColors.white),
      // Subscription plans
      BadgeStatus.free => (TossColors.gray100, TossColors.gray600),
      BadgeStatus.basic => (TossColors.success, TossColors.white),
      BadgeStatus.pro => (TossColors.info, TossColors.white),
    };
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FACTORY: Circle Badge
  // Use for: Leaderboards, rankings, numbered items, avatars, counters
  // ══════════════════════════════════════════════════════════════════════════

  /// Circular badge with centered text
  ///
  /// Perfect circle with centered content. Great for:
  /// - Rankings/leaderboards
  /// - Numbered items
  /// - Single letter avatars
  /// - Count indicators
  ///
  /// ```dart
  /// TossBadge.circle(text: '1')  // Default primary color
  /// TossBadge.circle(text: '1', backgroundColor: TossColors.success)  // Green
  /// TossBadge.circle(text: 'A', size: 32)  // Larger circle
  /// TossBadge.circle(text: '99+', size: 28)  // Counter badge
  /// ```
  factory TossBadge.circle({
    Key? key,
    required String text,
    double size = 24,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return _TossBadgeCircle(
      key: key,
      text: text,
      size: size,
      customBackgroundColor: backgroundColor,
      customTextColor: textColor,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FACTORY: Growth Badge
  // Use for: Analytics, percentage changes, metrics
  // ══════════════════════════════════════════════════════════════════════════

  /// Growth/change percentage badge with directional arrow
  ///
  /// Auto-colors: Green for positive, Red for negative
  /// ```dart
  /// TossBadge.growth(value: 12.5)   // Shows ↑12.5% in green
  /// TossBadge.growth(value: -3.2)   // Shows ↓3.2% in red
  /// TossBadge.growth(value: 5.0, compact: true)  // Smaller version
  /// ```
  factory TossBadge.growth({
    Key? key,
    required double value,
    bool compact = false,
    int decimalPlaces = 1,
  }) {
    final isPositive = value >= 0;
    return _TossBadgeGrowth(
      key: key,
      value: value,
      isPositive: isPositive,
      compact: compact,
      decimalPlaces: decimalPlaces,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? TossColors.gray50;
    final fgColor = textColor ?? TossColors.gray700;

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
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
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// INTERNAL: Circle Badge Implementation
// ══════════════════════════════════════════════════════════════════════════════

class _TossBadgeCircle extends TossBadge {
  final String text;
  final double size;
  final Color? customBackgroundColor;
  final Color? customTextColor;

  const _TossBadgeCircle({
    super.key,
    required this.text,
    required this.size,
    this.customBackgroundColor,
    this.customTextColor,
  }) : super(label: '');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: customBackgroundColor ?? TossColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: TossTextStyles.caption.copyWith(
            color: customTextColor ?? TossColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// INTERNAL: Growth Badge Implementation
// ══════════════════════════════════════════════════════════════════════════════

class _TossBadgeGrowth extends TossBadge {
  final double value;
  final bool isPositive;
  final bool compact;
  final int decimalPlaces;

  const _TossBadgeGrowth({
    super.key,
    required this.value,
    required this.isPositive,
    required this.compact,
    required this.decimalPlaces,
  }) : super(label: '');

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? TossColors.success : TossColors.error;
    final bgColor = isPositive ? TossColors.successLight : TossColors.errorLight;
    final iconData = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? TossSpacing.space1 + 2 : TossSpacing.space2,
        vertical: compact ? 2 : TossSpacing.space0_5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossSpacing.space2 + 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: compact ? 8 : 10,
            color: color,
          ),
          SizedBox(width: compact ? 1 : 2),
          Text(
            '${value.abs().toStringAsFixed(decimalPlaces)}%',
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 9 : 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY ALIASES (Deprecated - use TossBadge.status() instead)
// ══════════════════════════════════════════════════════════════════════════════

/// @Deprecated('Use TossBadge.status() instead')
typedef TossStatusBadge = _DeprecatedStatusBadge;

class _DeprecatedStatusBadge extends StatelessWidget {
  final String label;
  final BadgeStatus status;
  final IconData? icon;

  const _DeprecatedStatusBadge({
    super.key,
    required this.label,
    required this.status,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TossBadge.status(label: label, status: status, icon: icon);
  }
}

/// @Deprecated('Use TossBadge.status(status: BadgeStatus.free/basic/pro) instead')
typedef SubscriptionBadge = _DeprecatedSubscriptionBadge;

class _DeprecatedSubscriptionBadge extends StatelessWidget {
  final String planType;
  final bool compact;

  const _DeprecatedSubscriptionBadge({
    super.key,
    required this.planType,
    this.compact = false,
  });

  /// Factory constructor for backward compatibility
  factory _DeprecatedSubscriptionBadge.fromPlanType(String? planType,
      {bool compact = false}) {
    return _DeprecatedSubscriptionBadge(
      planType: planType ?? 'free',
      compact: compact,
    );
  }

  BadgeStatus get _status {
    return switch (planType.toLowerCase()) {
      'basic' => BadgeStatus.basic,
      'pro' => BadgeStatus.pro,
      _ => BadgeStatus.free,
    };
  }

  String get _label {
    return switch (planType.toLowerCase()) {
      'basic' => 'Basic',
      'pro' => 'Pro',
      _ => 'Free',
    };
  }

  @override
  Widget build(BuildContext context) {
    return TossBadge.status(label: _label, status: _status, compact: compact);
  }
}

/// @Deprecated('Use TossBadge.growth() instead')
typedef TossGrowthBadge = _DeprecatedGrowthBadge;

class _DeprecatedGrowthBadge extends StatelessWidget {
  final double growthValue;
  final bool compact;
  final int decimalPlaces;

  const _DeprecatedGrowthBadge({
    super.key,
    required this.growthValue,
    this.compact = false,
    this.decimalPlaces = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TossBadge.growth(
      value: growthValue,
      compact: compact,
      decimalPlaces: decimalPlaces,
    );
  }
}

