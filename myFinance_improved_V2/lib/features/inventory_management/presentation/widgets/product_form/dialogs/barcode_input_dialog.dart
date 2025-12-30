import 'package:flutter/material.dart';

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
              TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                ),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: TossColors.gray300),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: TossColors.gray300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: TossColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                ),
              ),
              const SizedBox(height: 24),
              // Buttons row
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TossColors.gray700,
                        side: const BorderSide(color: TossColors.gray300),
                        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Done button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext, controller.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: TossColors.white,
                        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Done',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TossColors.white,
                        ),
                      ),
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
