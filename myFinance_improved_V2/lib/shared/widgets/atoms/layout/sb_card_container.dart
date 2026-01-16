import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

/// SBCardContainer - Basic card container atom
///
/// A simple bordered container with consistent styling:
/// - White background
/// - Light gray border (gray100)
/// - 12px border radius (lg)
/// - No shadow
///
/// Use this as the base container for cards throughout the app.
///
/// Example:
/// ```dart
/// SBCardContainer(
///   child: Text('Card content'),
/// )
/// ```
///
/// Example with custom padding:
/// ```dart
/// SBCardContainer(
///   padding: EdgeInsets.all(16),
///   child: Column(
///     children: [
///       Text('Title'),
///       Text('Description'),
///     ],
///   ),
/// )
/// ```
class SBCardContainer extends StatelessWidget {
  /// The content of the container
  final Widget child;

  /// Padding inside the container
  /// Default: EdgeInsets.all(TossSpacing.space4) = 16
  final EdgeInsets? padding;

  /// Background color
  /// Default: TossColors.white
  final Color? backgroundColor;

  /// Border color
  /// Default: TossColors.gray100
  final Color? borderColor;

  /// Border width
  /// Default: 1.0
  final double borderWidth;

  /// Border radius
  /// Default: TossBorderRadius.lg (12)
  final double borderRadius;

  const SBCardContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = TossBorderRadius.lg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.white,
        border: Border.all(
          color: borderColor ?? TossColors.gray100,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
