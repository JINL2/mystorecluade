import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossSelectionBottomSheetComponent = WidgetbookComponent(
  name: 'TossSelectionBottomSheet',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossSelectionBottomSheet\n(Selection bottom sheet)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
