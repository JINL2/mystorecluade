import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../../shared/themes/toss_colors.dart';

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
    return TossButton.primary(
      text: buttonText,
      onPressed: onPressed,
      leadingIcon: const Icon(Icons.receipt_long_outlined, size: 20, color: TossColors.white),
      fullWidth: true,
    );
  }
}
