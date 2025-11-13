import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// White card container with consistent styling
class TossWhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final bool showBorder;
  final bool showShadow;

  const TossWhiteCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showBorder = true,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(
          borderRadius ?? TossBorderRadius.lg,
        ),
        border: showBorder
            ? Border.all(color: TossColors.gray200, width: 1)
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: TossColors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}