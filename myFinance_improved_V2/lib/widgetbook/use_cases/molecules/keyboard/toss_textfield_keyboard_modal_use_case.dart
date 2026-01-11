import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/keyboard/toss_textfield_keyboard_modal.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossTextFieldKeyboardModalComponent = WidgetbookComponent(
  name: 'TossTextFieldKeyboardModal',
  useCases: [
    WidgetbookUseCase(
      name: 'Basic Modal',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossTextFieldKeyboardModal.show(
                context: context,
                title: context.knobs.string(
                  label: 'Title',
                  initialValue: 'Enter Details',
                ),
                content: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                actionButtons: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              );
            },
            child: const Text('Open Modal'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Amount Input',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossTextFieldKeyboardModal.showAmountInput(
                context: context,
                title: 'Enter Amount',
                hint: '0',
                currency: '₩',
                onSubmit: (amount) {},
              );
            },
            child: const Text('Open Amount Input'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Initial Value',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossTextFieldKeyboardModal.showAmountInput(
                context: context,
                title: 'Edit Amount',
                initialValue: '25000',
                currency: '₩',
                onSubmit: (amount) {},
              );
            },
            child: const Text('Edit Existing Amount'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Content',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossTextFieldKeyboardModal.show(
                context: context,
                title: 'Add Note',
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Note',
                      style: TossTextStyles.labelLarge.copyWith(
                        color: TossColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter a note for this transaction...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actionButtons: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                      ),
                      child: const Text('Save Note'),
                    ),
                  ),
                ],
              );
            },
            child: const Text('Open Note Modal'),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Without Close Button',
      builder: (context) => Container(
        color: TossColors.gray100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              TossTextFieldKeyboardModal.show(
                context: context,
                title: 'Required Input',
                dismissOnTapOutside: false,
                content: const TextField(
                  decoration: InputDecoration(
                    labelText: 'Required Field',
                    border: OutlineInputBorder(),
                  ),
                ),
                actionButtons: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              );
            },
            child: const Text('Open Required Modal'),
          ),
        ),
      ),
    ),
  ],
);
