import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../toss/toss_primary_button.dart';

/// A success popup dialog component that displays a success message with an amount.
/// 
/// Example usage:
/// ```dart
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (context) => PopUpSuccess(
///     title: 'Success!',
///     message: 'Bank balance saved',
///     amount: 'Fr12,312,212',
///     onDone: () => Navigator.of(context).pop(),
///   ),
/// );
/// ```
class PopUpSuccess extends StatelessWidget {
  /// The main title of the success dialog (optional, defaults to 'Success!')
  final String? title;
  
  /// The descriptive message below the title
  final String message;
  
  /// The amount to display (optional)
  final String? amount;
  
  /// Callback when the done button is pressed
  final VoidCallback onDone;
  
  /// Custom icon widget (defaults to green checkmark)
  final Widget? icon;
  
  /// Button text (defaults to 'Done')
  final String buttonText;
  
  /// Whether to show the amount in a highlighted box
  final bool showAmountBox;
  
  /// Custom amount text style
  final TextStyle? amountTextStyle;
  
  /// Custom amount text color
  final Color? amountColor;
  
  const PopUpSuccess({
    super.key,
    this.title,
    required this.message,
    this.amount,
    required this.onDone,
    this.icon,
    this.buttonText = 'Done',
    this.showAmountBox = true,
    this.amountTextStyle,
    this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 24,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            icon ?? _buildDefaultIcon(),
            
            if (title != null) ...[
              const SizedBox(height: 20),
              // Title
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: 8),
            
            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            // Amount (if provided)
            if (amount != null) ...[
              const SizedBox(height: 24),
              if (showAmountBox)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    amount!,
                    style: amountTextStyle ?? TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: amountColor ?? const Color(0xFF0066FF),
                    ),
                  ),
                )
              else
                Text(
                  amount!,
                  style: amountTextStyle ?? TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: amountColor ?? const Color(0xFF0066FF),
                  ),
                ),
            ],
            
            const SizedBox(height: 32),
            
            // Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDefaultIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          size: 28,
          color: Color(0xFF4CAF50),
        ),
      ),
    );
  }
}

/// Helper function to show the success popup
Future<void> showSuccessPopup({
  required BuildContext context,
  String? title,
  required String message,
  String? amount,
  VoidCallback? onDone,
  Widget? icon,
  String buttonText = 'Done',
  bool barrierDismissible = false,
  bool showAmountBox = true,
  TextStyle? amountTextStyle,
  Color? amountColor,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return PopUpSuccess(
        title: title,
        message: message,
        amount: amount,
        onDone: onDone ?? () => Navigator.of(context).pop(),
        icon: icon,
        buttonText: buttonText,
        showAmountBox: showAmountBox,
        amountTextStyle: amountTextStyle,
        amountColor: amountColor,
      );
    },
  );
}