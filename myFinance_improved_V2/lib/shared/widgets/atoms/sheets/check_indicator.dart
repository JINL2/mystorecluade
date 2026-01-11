import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Animated check icon for selected state
class CheckIndicator extends StatelessWidget {
  final bool isVisible;
  final IconData icon;
  final Color color;
  final double size;

  const CheckIndicator({
    super.key,
    required this.isVisible,
    this.icon = LucideIcons.check,
    this.color = TossColors.primary,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 150),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
