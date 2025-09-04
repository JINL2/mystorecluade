import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../toss/toss_primary_button.dart';
import '../toss/toss_secondary_button.dart';

class TossErrorDialog extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final List<ErrorAction>? actions;
  final bool dismissible;
  final ErrorSeverity severity;

  const TossErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline,
    this.iconColor = TossColors.error,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.actions,
    this.dismissible = true,
    this.severity = ErrorSeverity.error,
  });

  @override
  State<TossErrorDialog> createState() => _TossErrorDialogState();
}

class _TossErrorDialogState extends State<TossErrorDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _severityColor {
    switch (widget.severity) {
      case ErrorSeverity.warning:
        return TossColors.warning;
      case ErrorSeverity.info:
        return TossColors.info;
      case ErrorSeverity.error:
      default:
        return TossColors.error;
    }
  }

  IconData get _severityIcon {
    switch (widget.severity) {
      case ErrorSeverity.warning:
        return Icons.warning_amber_rounded;
      case ErrorSeverity.info:
        return Icons.info_outline;
      case ErrorSeverity.error:
      default:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.transparent,
      elevation: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space6),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _severityColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconSection(),
                SizedBox(height: TossSpacing.space4),
                _buildContentSection(),
                SizedBox(height: TossSpacing.space6),
                _buildActionSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            _severityColor.withOpacity(0.2),
            _severityColor.withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.icon != Icons.error_outline ? widget.icon : _severityIcon,
        size: 36,
        color: widget.iconColor != TossColors.error ? widget.iconColor : _severityColor,
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      children: [
        Text(
          widget.title,
          style: TossTextStyles.h3.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: TossSpacing.space3),
        Text(
          widget.message,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      return Column(
        children: widget.actions!
            .map((action) => Padding(
                  padding: EdgeInsets.only(bottom: TossSpacing.space2),
                  child: SizedBox(
                    width: double.infinity,
                    child: action.isPrimary
                        ? TossPrimaryButton(
                            text: action.text,
                            onPressed: action.onPressed,
                            fullWidth: true,
                          )
                        : TossSecondaryButton(
                            text: action.text,
                            onPressed: action.onPressed,
                            fullWidth: true,
                          ),
                  ),
                ))
            .toList(),
      );
    }

    // Default action buttons
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TossPrimaryButton(
            text: widget.primaryButtonText ?? 'OK',
            onPressed: widget.onPrimaryPressed ?? () => Navigator.of(context).pop(),
            fullWidth: true,
          ),
        ),
        if (widget.secondaryButtonText != null) ...[
          SizedBox(height: TossSpacing.space3),
          TextButton(
            onPressed: widget.onSecondaryPressed ?? () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
            ),
            child: Text(
              widget.secondaryButtonText!,
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ErrorAction {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const ErrorAction({
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
  });
}

enum ErrorSeverity {
  error,
  warning,
  info,
}

// Utility methods for common error scenarios
class TossErrorDialogs {
  /// Show network error dialog
  static Future<bool?> showNetworkError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossErrorDialog(
        title: 'Connection Error',
        message: 'Please check your internet connection and try again.',
        severity: ErrorSeverity.warning,
        actions: [
          if (onRetry != null)
            ErrorAction(
              text: 'Retry',
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              isPrimary: true,
            ),
          ErrorAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  /// Show validation error dialog
  static Future<bool?> showValidationError({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossErrorDialog(
        title: title ?? 'Validation Error',
        message: message,
        severity: ErrorSeverity.warning,
        icon: Icons.warning_amber_rounded,
        primaryButtonText: 'OK',
      ),
    );
  }

  /// Show business creation failed dialog
  static Future<bool?> showBusinessCreationFailed({
    required BuildContext context,
    required String error,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossErrorDialog(
        title: 'Failed to Create Business',
        message: _parseErrorMessage(error),
        actions: [
          if (onRetry != null)
            ErrorAction(
              text: 'Try Again',
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              isPrimary: true,
            ),
          ErrorAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  /// Show store creation failed dialog
  static Future<bool?> showStoreCreationFailed({
    required BuildContext context,
    required String error,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossErrorDialog(
        title: 'Failed to Create Store',
        message: _parseErrorMessage(error),
        actions: [
          if (onRetry != null)
            ErrorAction(
              text: 'Try Again',
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              isPrimary: true,
            ),
          ErrorAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  /// Show business join failed dialog
  static Future<bool?> showBusinessJoinFailed({
    required BuildContext context,
    required String error,
    VoidCallback? onRetry,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossErrorDialog(
        title: 'Failed to Join Business',
        message: _parseBusinessJoinError(error),
        actions: [
          if (onRetry != null)
            ErrorAction(
              text: 'Try Again',
              onPressed: () {
                Navigator.of(context).pop(true);
                onRetry();
              },
              isPrimary: true,
            ),
          ErrorAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  /// Parse generic error messages into user-friendly text
  static String _parseErrorMessage(String error) {
    if (error.toLowerCase().contains('network') || 
        error.toLowerCase().contains('connection')) {
      return 'Please check your internet connection and try again.';
    }
    
    if (error.toLowerCase().contains('timeout')) {
      return 'The operation took too long. Please try again.';
    }
    
    if (error.toLowerCase().contains('server')) {
      return 'Server error occurred. Please try again later.';
    }
    
    if (error.toLowerCase().contains('duplicate') || 
        error.toLowerCase().contains('already exists')) {
      return 'This name is already taken. Please choose a different name.';
    }
    
    // Default fallback with sanitized error
    return error.replaceAll('Exception:', '').trim();
  }

  /// Parse business join specific errors
  static String _parseBusinessJoinError(String error) {
    if (error.toLowerCase().contains('invalid company code') || 
        error.toLowerCase().contains('invalid code')) {
      return 'The business code is invalid. Please check with your manager and try again.';
    }
    
    if (error.toLowerCase().contains('already a member')) {
      return 'You are already a member of this business.';
    }
    
    if (error.toLowerCase().contains('owner cannot join')) {
      return 'You cannot join your own business as an employee.';
    }
    
    if (error.toLowerCase().contains('not found')) {
      return 'Business not found. Please verify the code and try again.';
    }
    
    return _parseErrorMessage(error);
  }
}