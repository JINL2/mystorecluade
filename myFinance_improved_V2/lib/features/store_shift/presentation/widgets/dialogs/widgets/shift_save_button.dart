import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Shift Save Button Widget
///
/// Primary action button for shift form submission
class ShiftSaveButton extends StatelessWidget {
  final String buttonText;
  final bool isSubmitting;
  final VoidCallback? onPressed;

  const ShiftSaveButton({
    super.key,
    required this.buttonText,
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: TossColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: TossColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                buttonText,
                style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
