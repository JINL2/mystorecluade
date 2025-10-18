import 'package:flutter/material.dart';
import 'toss_button.dart';

/// Toss-style primary button - now using unified TossButton
/// This is a compatibility wrapper for gradual migration
class TossPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final bool fullWidth;
  
  const TossPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.fullWidth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return TossButton.primary(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
    );
  }
}