import 'package:flutter/material.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';

/// Full-width gray divider for section separation
///
/// Creates a full-width gray background space used to visually separate
/// different sections of content. Commonly used in list views and scrollable pages.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     // Content section 1
///     Padding(...),
///
///     // Divider
///     const GrayDividerSpace(),
///
///     // Content section 2
///     Padding(...),
///   ],
/// )
/// ```
class GrayDividerSpace extends StatelessWidget {
  /// Height of the divider space
  final double height;

  /// Background color of the divider
  final Color? color;

  const GrayDividerSpace({
    super.key,
    this.height = 15,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        height: height,
        width: double.infinity,
        color: color ?? TossColors.gray50,
      ),
    );
  }
}

/// Vertical gray divider for inline content separation
///
/// Creates a thin vertical line used to separate content horizontally,
/// such as metrics in a row or navigation items.
///
/// Example:
/// ```dart
/// Row(
///   children: [
///     Text('Metric 1'),
///     const GrayVerticalDivider(),
///     Text('Metric 2'),
///     const GrayVerticalDivider(),
///     Text('Metric 3'),
///   ],
/// )
/// ```
class GrayVerticalDivider extends StatelessWidget {
  /// Width of the divider line
  final double width;

  /// Height of the divider
  final double height;

  /// Horizontal margin around the divider
  final double horizontalMargin;

  /// Color of the divider
  final Color? color;

  const GrayVerticalDivider({
    super.key,
    this.width = 1,
    this.height = 40,
    this.horizontalMargin = TossSpacing.space3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      color: color ?? TossColors.gray200,
    );
  }
}
