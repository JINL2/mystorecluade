import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';

/// Action buttons widget for dialogs (Cancel + Confirm)
class DialogActionButtons extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final bool isLoading;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const DialogActionButtons({
    super.key,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.confirmColor = TossColors.primary,
    this.isLoading = false,
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
            ),
            child: Text(cancelText),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TossColors.white,
                    ),
                  )
                : Text(confirmText),
          ),
        ),
      ],
    );
  }
}
