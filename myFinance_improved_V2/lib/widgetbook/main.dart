import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'use_cases/atoms/atoms_directory.dart';
import 'use_cases/molecules/molecules_directory.dart';
import 'use_cases/organisms/organisms_directory.dart';
import 'use_cases/selectors/selectors_directory.dart';
import 'use_cases/templates/templates_directory.dart';
import 'use_cases/ai/ai_directory.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
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
        TextScaleAddon(
          scales: [1.0, 1.25, 1.5, 2.0],
          initialScale: 1.0,
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light(useMaterial3: true),
            ),
          ],
        ),
      ],
      directories: [
        atomsDirectory,
        moleculesDirectory,
        organismsDirectory,
        selectorsDirectory,
        templatesDirectory,
        aiDirectory,
      ],
    );
  }
}
