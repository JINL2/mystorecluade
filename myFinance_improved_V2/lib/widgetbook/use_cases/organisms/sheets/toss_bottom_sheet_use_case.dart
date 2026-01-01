import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossBottomSheetComponent = WidgetbookComponent(
  name: 'TossBottomSheet',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossBottomSheet\n(Bottom sheet modal)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
