import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_info_dialog.dart';

final tossInfoDialogComponent = WidgetbookComponent(
  name: 'TossInfoDialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              TossInfoDialog.show(
                context: context,
                title: 'Information',
                bulletPoints: const [
                  'First point of information',
                  'Second point of information',
                  'Third point of information',
                ],
              );
            },
            child: const Text('Show Info Dialog'),
          ),
        ),
      ),
    ),
  ],
);
