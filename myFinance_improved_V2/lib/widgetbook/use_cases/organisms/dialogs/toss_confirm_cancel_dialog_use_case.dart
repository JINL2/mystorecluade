import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog.dart';

final tossConfirmCancelDialogComponent = WidgetbookComponent(
  name: 'TossConfirmCancelDialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossConfirmCancelDialog(
                title: context.knobs.string(
                  label: 'Title',
                  initialValue: 'Confirm Action',
                ),
                message: context.knobs.string(
                  label: 'Message',
                  initialValue: 'Are you sure you want to proceed?',
                ),
                confirmButtonText: 'OK',
                cancelButtonText: 'Cancel',
              ),
            );
          },
          child: const Text('Show Dialog'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Delete Confirmation',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossConfirmCancelDialog.delete(
                title: 'Delete Item',
                message: 'This action cannot be undone.',
              ),
            );
          },
          child: const Text('Show Delete Dialog'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Save Confirmation',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossConfirmCancelDialog.save(
                title: 'Save Changes',
                message: 'Do you want to save your changes?',
              ),
            );
          },
          child: const Text('Show Save Dialog'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Discard Confirmation',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => TossConfirmCancelDialog.discard(
                title: 'Discard Changes',
                message: 'Are you sure you want to discard your changes?',
              ),
            );
          },
          child: const Text('Show Discard Dialog'),
        ),
      ),
    ),
  ],
);
