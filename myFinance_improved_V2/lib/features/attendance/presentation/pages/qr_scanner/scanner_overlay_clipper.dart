import 'package:flutter/material.dart';

/// Custom clipper for scanner overlay with cutout
/// Extracted from qr_scanner_page.dart for better modularity
class ScannerOverlayClipper extends CustomClipper<Path> {
  final double cutoutSize;
  final double borderRadius;

  const ScannerOverlayClipper({
    this.cutoutSize = 280.0,
    this.borderRadius = 16.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path()..fillType = PathFillType.evenOdd;

    // Add outer rectangle
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Calculate center cutout position
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Add rounded rectangle cutout
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: cutoutSize,
          height: cutoutSize,
        ),
        Radius.circular(borderRadius),
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant ScannerOverlayClipper oldClipper) {
    return oldClipper.cutoutSize != cutoutSize ||
        oldClipper.borderRadius != borderRadius;
  }
}
