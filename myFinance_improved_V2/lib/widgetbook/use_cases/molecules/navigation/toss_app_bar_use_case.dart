import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossAppBarComponent = WidgetbookComponent(
  name: 'TossAppBar',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossAppBar\n(Application bar)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
