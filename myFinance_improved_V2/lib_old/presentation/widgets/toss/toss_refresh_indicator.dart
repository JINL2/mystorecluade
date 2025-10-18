import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/index.dart';

/// Toss-style refresh indicator wrapper
class TossRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;
  final Color? backgroundColor;

  const TossRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? TossColors.primary,
      backgroundColor: backgroundColor ?? TossColors.white,
      strokeWidth: 2.5,
      child: child,
    );
  }
}