import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossWhiteCardComponent = WidgetbookComponent(
  name: 'TossWhiteCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossWhiteCard\n(White background card)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
