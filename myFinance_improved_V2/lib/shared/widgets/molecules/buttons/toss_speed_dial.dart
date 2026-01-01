import 'package:flutter/material.dart';

import 'toss_fab.dart';

/// @deprecated Use [TossFABAction] instead.
@Deprecated('Use TossFABAction instead')
class TossSpeedDialAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const TossSpeedDialAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

/// @deprecated Use [TossFAB.expandable] instead.
/// TossSpeedDial has been merged into TossFAB.
///
/// Migration:
/// ```dart
/// // Before:
/// TossSpeedDial(
///   actions: [
///     TossSpeedDialAction(icon: Icons.add, label: 'Add', onPressed: () {}),
///   ],
/// )
///
/// // After:
/// TossFAB.expandable(
///   actions: [
///     TossFABAction(icon: Icons.add, label: 'Add', onPressed: () {}),
///   ],
/// )
/// ```
@Deprecated('Use TossFAB.expandable() instead. TossSpeedDial has been merged into TossFAB.')
class TossSpeedDial extends StatelessWidget {
  const TossSpeedDial({
    super.key,
    required this.actions,
    this.backgroundColor,
    this.iconColor,
    this.size = 52,
    this.iconSize = 24,
    this.overlayOpacity = 0.5,
    this.enableHapticFeedback = true,
  });

  final List<TossSpeedDialAction> actions;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double overlayOpacity;
  final bool enableHapticFeedback;

  @override
  Widget build(BuildContext context) {
    // Convert TossSpeedDialAction to TossFABAction
    final fabActions = actions
        .map((a) => TossFABAction(
              icon: a.icon,
              label: a.label,
              onPressed: a.onPressed,
            ))
        .toList();

    return TossFAB.expandable(
      actions: fabActions,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      size: size,
      iconSize: iconSize,
      overlayOpacity: overlayOpacity,
      enableHapticFeedback: enableHapticFeedback,
    );
  }
}
