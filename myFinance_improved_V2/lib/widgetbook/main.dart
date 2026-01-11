import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'use_cases/ai/ai_directory.dart';
import 'use_cases/ai_chat/ai_chat_directory.dart';
import 'use_cases/atoms/atoms_directory.dart';
import 'use_cases/molecules/molecules_directory.dart';
import 'use_cases/organisms/organisms_directory.dart';
import 'use_cases/selectors/selectors_directory.dart';
import 'use_cases/templates/templates_directory.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // Remember selected component and navigation state via URL
      initialRoute: '?path=atoms/buttons/tossbutton/primary',
      addons: [
        // Inspector addon - toggle to show/hide panels
        InspectorAddon(),
        // Viewport addon (replaces deprecated DeviceFrameAddon)
        ViewportAddon([
          IosViewports.iPhone13,
          IosViewports.iPhone13ProMax,
          IosViewports.iPhoneSE,
          IosViewports.iPadPro11Inches,
          AndroidViewports.samsungGalaxyS20,
        ]),
        // Text scale for accessibility testing
        TextScaleAddon(
          min: 1.0,
          max: 2.0,
          initialScale: 1.0,
        ),
        // Theme switching
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light(useMaterial3: true),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData.dark(useMaterial3: true),
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
        aiChatDirectory,
      ],
    );
  }
}
