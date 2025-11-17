import 'package:flutter/material.dart';

/// Responsive testing wrapper - test different screen sizes without changing simulators
class ResponsiveTester extends StatefulWidget {
  final Widget child;

  const ResponsiveTester({
    super.key,
    required this.child,
  });

  @override
  State<ResponsiveTester> createState() => _ResponsiveTesterState();
}

class _ResponsiveTesterState extends State<ResponsiveTester> {
  DevicePreset _currentPreset = DevicePreset.iPhoneSE;
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled) {
      return widget.child;
    }

    return Stack(
      children: [
        Center(
          child: Container(
            width: _currentPreset.width,
            height: _currentPreset.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: Size(_currentPreset.width, _currentPreset.height),
              ),
              child: widget.child,
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: _buildControls(),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Screen Tester',
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          ...DevicePreset.values.map((preset) {
            return GestureDetector(
              onTap: () => setState(() => _currentPreset = preset),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: _currentPreset == preset
                      ? Colors.blue
                      : Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${preset.name} (${preset.width.toInt()}x${preset.height.toInt()})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _isEnabled = !_isEnabled),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _isEnabled ? 'Disable' : 'Enable',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Common device screen size presets
enum DevicePreset {
  iPhoneSE(375, 667, 'iPhone SE'),
  iPhoneMini(375, 812, 'iPhone 13 mini'),
  iPhone14(390, 844, 'iPhone 14'),
  iPhone14Pro(393, 852, 'iPhone 14 Pro'),
  iPhone14ProMax(430, 932, 'iPhone 14 Pro Max'),
  smallAndroid(320, 568, 'Small Android'),
  mediumAndroid(360, 640, 'Medium Android'),
  largeAndroid(412, 915, 'Large Android');

  final double width;
  final double height;
  final String displayName;

  const DevicePreset(this.width, this.height, this.displayName);

  String get name => displayName;
}
