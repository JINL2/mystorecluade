import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_success_error_dialog.dart';

final tossSuccessErrorDialogComponent = WidgetbookComponent(
  name: 'TossDialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Success',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => TossDialog.success(
                  title: 'Success!',
                  message: 'Operation completed successfully.',
                  primaryButtonText: 'OK',
                  onPrimaryPressed: () => Navigator.pop(context),
                ),
              );
            },
            child: const Text('Show Success Dialog'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Error',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => TossDialog.error(
                  title: 'Error',
                  message: 'Something went wrong.',
                  primaryButtonText: 'Retry',
                  onPrimaryPressed: () => Navigator.pop(context),
                ),
              );
            },
            child: const Text('Show Error Dialog'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Warning',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => TossDialog.warning(
                  title: 'Warning',
                  message: 'This action may have consequences.',
                  primaryButtonText: 'Proceed',
                  secondaryButtonText: 'Cancel',
                  onPrimaryPressed: () => Navigator.pop(context),
                  onSecondaryPressed: () => Navigator.pop(context),
                ),
              );
            },
            child: const Text('Show Warning Dialog'),
          ),
        ),
      ),
    ),
  ],
);
