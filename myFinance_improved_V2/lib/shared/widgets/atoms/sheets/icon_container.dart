import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Container for icons with background color
class IconContainer extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final double size;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;

  const IconContainer({
    super.key,
    required this.icon,
    this.isSelected = false,
    this.size = 40,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected
            ? (selectedBackgroundColor ??
                TossColors.primary.withValues(alpha: 0.1))
            : (unselectedBackgroundColor ?? TossColors.gray50),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(
        icon,
        size: size * 0.45,
        color: isSelected
            ? (selectedColor ?? TossColors.primary)
            : (unselectedColor ?? TossColors.gray600),
      ),
    );
  }
}
