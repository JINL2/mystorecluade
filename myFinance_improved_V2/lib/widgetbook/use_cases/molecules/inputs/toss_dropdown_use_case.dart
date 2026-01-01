import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossDropdownComponent = WidgetbookComponent(
  name: 'TossDropdown',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossDropdown\n(Dropdown selector)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
