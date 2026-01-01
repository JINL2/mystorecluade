import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossExpandableCardComponent = WidgetbookComponent(
  name: 'TossExpandableCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossExpandableCard\n(Expandable card widget)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
