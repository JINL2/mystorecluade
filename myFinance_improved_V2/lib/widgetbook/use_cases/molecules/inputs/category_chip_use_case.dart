import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final categoryChipComponent = WidgetbookComponent(
  name: 'CategoryChip',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'CategoryChip\n(Category selection chip)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
