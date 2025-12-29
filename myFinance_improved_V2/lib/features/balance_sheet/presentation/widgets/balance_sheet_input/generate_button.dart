import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Generate button widget for balance sheet
class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const GenerateButton({
    super.key,
    required this.onPressed,
    this.buttonText = 'Generate Balance Sheet',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: TossColors.primary,
        foregroundColor: TossColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 20),
          const SizedBox(width: TossSpacing.space2),
          Text(
            buttonText,
            style: TossTextStyles.button,
          ),
        ],
      ),
    );
  }
}
