import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// A small horizontal bar indicating the bottom sheet can be dragged
class DragHandle extends StatelessWidget {
  final Color? color;
  final double width;
  final double height;

  const DragHandle({
    super.key,
    this.color,
    this.width = 36,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? TossColors.gray300,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
