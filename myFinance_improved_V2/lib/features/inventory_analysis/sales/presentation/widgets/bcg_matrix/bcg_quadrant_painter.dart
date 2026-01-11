import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Custom painter for BCG quadrant background colors
class BcgQuadrantPainter extends CustomPainter {
  final double medianXRatio;
  final double medianYRatio;

  const BcgQuadrantPainter({
    required this.medianXRatio,
    required this.medianYRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final medianX = size.width * medianXRatio;
    final medianY = size.height * (1 - medianYRatio);

    // Question Mark (Top-Left): High Margin, Low Sales
    canvas.drawRect(
      Rect.fromLTRB(0, 0, medianX, medianY),
      Paint()
        ..color = TossColors.warning.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    // Star (Top-Right): High Margin, High Sales
    canvas.drawRect(
      Rect.fromLTRB(medianX, 0, size.width, medianY),
      Paint()
        ..color = TossColors.success.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    // Dog (Bottom-Left): Low Margin, Low Sales
    canvas.drawRect(
      Rect.fromLTRB(0, medianY, medianX, size.height),
      Paint()
        ..color = TossColors.error.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    // Cash Cow (Bottom-Right): Low Margin, High Sales
    canvas.drawRect(
      Rect.fromLTRB(medianX, medianY, size.width, size.height),
      Paint()
        ..color = TossColors.primary.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant BcgQuadrantPainter oldDelegate) {
    return oldDelegate.medianXRatio != medianXRatio ||
        oldDelegate.medianYRatio != medianYRatio;
  }
}
