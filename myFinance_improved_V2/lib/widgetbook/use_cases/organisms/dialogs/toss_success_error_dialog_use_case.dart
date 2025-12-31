import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_success_error_dialog.dart';

final tossDialogComponent = WidgetbookComponent(
  name: 'TossDialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Success',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossDialog.success(
                title: context.knobs.string(
                  label: 'Title',
                  initialValue: 'Success!',
                ),
                message: context.knobs.string(
                  label: 'Message',
                  initialValue: 'Your action was completed successfully.',
                ),
                primaryButtonText: 'Continue',
              ),
            );
          },
          child: const Text('Show Success Dialog'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Error',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossDialog.error(
                title: 'Error Occurred',
                message: 'Something went wrong. Please try again.',
                primaryButtonText: 'Retry',
              ),
            );
          },
          child: const Text('Show Error Dialog'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Warning',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossDialog.warning(
                title: 'Warning',
                message: 'This action may have consequences.',
                primaryButtonText: 'Proceed',
                secondaryButtonText: 'Cancel',
              ),
            );
          },
          child: const Text('Show Warning Dialog'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Info',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossDialog.info(
                title: 'Information',
                message: 'Here is some useful information for you.',
                primaryButtonText: 'OK',
              ),
            );
          },
          child: const Text('Show Info Dialog'),
        ),
      ),
    ),
  ],
);
