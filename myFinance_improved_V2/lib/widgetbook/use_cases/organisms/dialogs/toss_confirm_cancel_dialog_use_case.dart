import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog.dart';

final tossConfirmCancelDialogComponent = WidgetbookComponent(
  name: 'TossConfirmCancelDialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => TossConfirmCancelDialog(
                  title: 'Confirm Action',
                  message: 'Are you sure you want to proceed?',
                  onConfirm: () => Navigator.pop(context),
                  onCancel: () => Navigator.pop(context),
                ),
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Delete',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => TossConfirmCancelDialog.delete(
                  title: 'Delete Item',
                  message: 'This action cannot be undone.',
                  onConfirm: () => Navigator.pop(context),
                  onCancel: () => Navigator.pop(context),
                ),
              );
            },
            child: const Text('Show Delete Dialog'),
          ),
        ),
      ),
    ),
  ],
);
