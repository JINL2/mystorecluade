import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_info_dialog.dart';

final tossInfoDialogComponent = WidgetbookComponent(
  name: 'TossInfoDialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossInfoDialog.show(
              context: context,
              title: context.knobs.string(
                label: 'Title',
                initialValue: 'What is an SKU?',
              ),
              bulletPoints: [
                'An SKU (Stock Keeping Unit) is a unique code.',
                'You can enter your own or have one generated.',
                'SKUs help you find items quickly.',
              ],
            );
          },
          child: const Text('Show Info Dialog'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Help Guide',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossInfoDialog.show(
              context: context,
              title: 'How to use this feature',
              bulletPoints: [
                'Step 1: Enter your information',
                'Step 2: Review your entries',
                'Step 3: Click submit to save',
                'You can edit your entries anytime',
              ],
              buttonText: 'Got it!',
            );
          },
          child: const Text('Show Help Dialog'),
        ),
      ),
    ),
  ],
);
