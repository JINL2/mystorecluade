import 'package:flutter/material.dart';

/// Debug widget to display current screen dimensions
class ScreenSizeDebug extends StatelessWidget {
  const ScreenSizeDebug({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black87,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Screen Debug Info',
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          _buildInfoRow('Width', '${size.width.toStringAsFixed(1)} dp'),
          _buildInfoRow('Height', '${size.height.toStringAsFixed(1)} dp'),
          _buildInfoRow('Pixel Ratio', devicePixelRatio.toStringAsFixed(2)),
          _buildInfoRow('Safe Area Top', '${padding.top.toStringAsFixed(1)}'),
          _buildInfoRow('Safe Area Bottom', '${padding.bottom.toStringAsFixed(1)}'),
          _buildInfoRow('Category', _getScreenCategory(size.width)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getScreenCategory(double width) {
    if (width < 360) return 'Extra Small';
    if (width < 375) return 'Small';
    if (width < 414) return 'Medium';
    if (width < 768) return 'Large';
    return 'Extra Large';
  }
}

/// Floating debug overlay
class FloatingScreenDebug extends StatelessWidget {
  const FloatingScreenDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 0,
      child: ScreenSizeDebug(),
    );
  }
}
