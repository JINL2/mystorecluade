import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
      child: TossButton.primary(
        onPressed: isSubmitting ? null : onPressed,
        text: buttonText,
        isLoading: isSubmitting,
      ),
    );
  }
}
