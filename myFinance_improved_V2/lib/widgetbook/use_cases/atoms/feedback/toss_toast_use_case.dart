import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_toast.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

final tossToastComponent = WidgetbookComponent(
  name: 'TossToast',
  useCases: [
    WidgetbookUseCase(
      name: 'All Variants',
      builder: (context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TossToast Utility',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: TossSpacing.space2),
                const Text(
                  'Tap buttons to show different toast types',
                  style: TextStyle(color: TossColors.gray500),
                ),
                SizedBox(height: TossSpacing.space6),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => TossToast.success(
                        context,
                        context.knobs.string(
                          label: 'Success Message',
                          initialValue: 'Saved successfully!',
                        ),
                      ),
                      icon: const Icon(Icons.check_circle, color: TossColors.success),
                      label: const Text('Success'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.white,
                        foregroundColor: TossColors.success,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => TossToast.error(
                        context,
                        context.knobs.string(
                          label: 'Error Message',
                          initialValue: 'Failed to save',
                        ),
                      ),
                      icon: const Icon(Icons.error, color: TossColors.error),
                      label: const Text('Error'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.white,
                        foregroundColor: TossColors.error,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => TossToast.info(
                        context,
                        context.knobs.string(
                          label: 'Info Message',
                          initialValue: 'Processing your request...',
                        ),
                      ),
                      icon: const Icon(Icons.info, color: TossColors.primary),
                      label: const Text('Info'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.white,
                        foregroundColor: TossColors.primary,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => TossToast.warning(
                        context,
                        context.knobs.string(
                          label: 'Warning Message',
                          initialValue: 'Please check your input',
                        ),
                      ),
                      icon: const Icon(Icons.warning, color: TossColors.warning),
                      label: const Text('Warning'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.white,
                        foregroundColor: TossColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ],
);
