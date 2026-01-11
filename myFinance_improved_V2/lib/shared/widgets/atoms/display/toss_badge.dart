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

/// Growth Indicator Badge
///
/// Displays growth/change percentage with directional arrow.
/// Green for positive, Red for negative.
///
/// Usage:
/// ```dart
/// TossGrowthBadge(growthValue: 12.5)  // Shows ↑12.5% in green
/// TossGrowthBadge(growthValue: -3.2)  // Shows ↓3.2% in red
/// TossGrowthBadge.compact(growthValue: 5.0)  // Smaller version
/// ```
class TossGrowthBadge extends StatelessWidget {
  final double growthValue;
  final bool compact;
  final int decimalPlaces;

  const TossGrowthBadge({
    super.key,
    required this.growthValue,
    this.compact = false,
    this.decimalPlaces = 1,
  });

  /// Compact version for tight spaces
  factory TossGrowthBadge.compact({
    Key? key,
    required double growthValue,
    int decimalPlaces = 1,
  }) {
    return TossGrowthBadge(
      key: key,
      growthValue: growthValue,
      compact: true,
      decimalPlaces: decimalPlaces,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = growthValue >= 0;
    final color = isPositive ? TossColors.success : TossColors.error;
    final bgColor = isPositive ? TossColors.successLight : TossColors.errorLight;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

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
            icon,
            size: compact ? 8 : 10,
            color: color,
          ),
          SizedBox(width: compact ? 1 : 2),
          Text(
            '${growthValue.abs().toStringAsFixed(decimalPlaces)}%',
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

/// Rank Badge for leaderboard/ranking display
///
/// Gold for #1, Silver for #2, Bronze for #3, Gray for others.
///
/// Usage:
/// ```dart
/// TossRankBadge(rank: 1)  // Gold badge
/// TossRankBadge(rank: 2)  // Silver badge
/// TossRankBadge(rank: 3)  // Bronze badge
/// TossRankBadge(rank: 5)  // Gray badge with "5"
/// ```
class TossRankBadge extends StatelessWidget {
  final int rank;
  final double size;

  const TossRankBadge({
    super.key,
    required this.rank,
    this.size = 20,
  });

  /// Standard medal colors
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);

  @override
  Widget build(BuildContext context) {
    if (rank <= 3) {
      return _buildMedalBadge();
    }
    return _buildNumberBadge();
  }

  Widget _buildMedalBadge() {
    final color = switch (rank) {
      1 => gold,
      2 => silver,
      3 => bronze,
      _ => TossColors.gray400,
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.white,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberBadge() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
            fontSize: size * 0.5,
          ),
        ),
      ),
    );
  }
}