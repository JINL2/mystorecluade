import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// A dialog for manually entering a barcode/SKU value
class BarcodeInputDialog {
  /// Shows the barcode input dialog
  static Future<void> show({
    required BuildContext context,
    String? initialValue,
    required ValueChanged<String> onValueEntered,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: TossColors.transparent,
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Enter SKU/Barcode Number',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: 24),
              // Text field with underline
              TossTextField.underline(
                controller: controller,
                hintText: '',
                autofocus: true,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Buttons row
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: TossButton.outlinedGray(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(dialogContext),
                      fullWidth: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Done button
                  Expanded(
                    child: TossButton.primary(
                      text: 'Done',
                      onPressed: () {
                        Navigator.pop(dialogContext, controller.text);
                      },
                      fullWidth: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      onValueEntered(result);
    }
  }
}
