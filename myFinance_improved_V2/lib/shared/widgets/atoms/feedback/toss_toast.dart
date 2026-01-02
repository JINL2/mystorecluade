import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Unified toast/snackbar utility for consistent feedback messages
///
/// Provides static methods for showing success, error, info, and warning toasts
/// with consistent styling across the application.
///
/// ## Usage
/// ```dart
/// TossToast.success(context, 'Saved successfully');
/// TossToast.error(context, 'Failed to save');
/// TossToast.info(context, 'Processing...');
/// TossToast.warning(context, 'Please check your input');
/// ```
class TossToast {
  TossToast._();

  static const Duration _defaultDuration = Duration(seconds: 3);

  /// Shows a success toast with green background
  static void success(
    BuildContext context,
    String message, {
    Duration duration = _defaultDuration,
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: TossColors.success,
      duration: duration,
      action: action,
    );
  }

  /// Shows an error toast with red background
  static void error(
    BuildContext context,
    String message, {
    Duration duration = _defaultDuration,
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: TossColors.error,
      duration: duration,
      action: action,
    );
  }

  /// Shows an info toast with blue/primary background
  static void info(
    BuildContext context,
    String message, {
    Duration duration = _defaultDuration,
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: TossColors.primary,
      duration: duration,
      action: action,
    );
  }

  /// Shows a warning toast with orange/warning background
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = _defaultDuration,
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      backgroundColor: TossColors.warning,
      duration: duration,
      action: action,
    );
  }

  /// Shows a custom toast with specified parameters
  static void custom(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = _defaultDuration,
    SnackBarAction? action,
  }) {
    _show(
      context,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Duration duration,
    SnackBarAction? action,
  }) {
    // Clear any existing snackbars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: TossColors.white,
              size: 20,
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        margin: const EdgeInsets.all(TossSpacing.space4),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Hides the current snackbar if visible
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
