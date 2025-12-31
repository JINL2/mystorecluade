import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'use_cases/atoms/atoms_directory.dart';
import 'use_cases/molecules/molecules_directory.dart';
import 'use_cases/organisms/organisms_directory.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // App info
      addons: [
        // Device frame addon - test different screen sizes
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.ios.iPhone13ProMax,
            Devices.ios.iPhoneSE,
            Devices.android.samsungGalaxyS20,
            Devices.android.smallPhone,
          ],
          initialDevice: Devices.ios.iPhone13,
        ),
        // Text scale addon - test accessibility
        TextScaleAddon(
          scales: [1.0, 1.25, 1.5, 2.0],
          initialScale: 1.0,
        ),
        // Theme addon - for future dark mode
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light(useMaterial3: true),
            ),
          ],
        ),
      ],
      // Widget directories
      directories: [
        // Atoms - Basic building blocks
        atomsDirectory,
        // Molecules - Combined widgets
        moleculesDirectory,
        // Organisms - Complex components
        organismsDirectory,
      ],
    );
  }
}
