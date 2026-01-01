import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final avatarStackInteractComponent = WidgetbookComponent(
  name: 'AvatarStackInteract',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'AvatarStackInteract\n(Interactive avatar stack)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
