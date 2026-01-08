import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/core/constants/ui_constants.dart';

/// Error view component that displays error state with optional retry action.
///
/// This is an **Atom** - it uses only Flutter primitives and theme constants.
/// For custom action buttons, pass them via [actionButton] parameter.
///
/// Example usage:
/// ```dart
/// // Simple usage with default retry button
/// TossErrorView(
///   error: exception,
///   onRetry: () => refresh(),
/// )
///
/// // With custom action button (inject any button)
/// TossErrorView(
///   error: exception,
///   actionButton: TossButton.primary(
///     text: 'Go Back',
///     onPressed: () => Navigator.pop(context),
///   ),
/// )
///
/// // Error display only (no button)
/// TossErrorView(
///   error: exception,
///   showRetryButton: false,
/// )
/// ```
class TossErrorView extends StatelessWidget {
  const TossErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.title = 'Something went wrong',
    this.showRetryButton = true,
    this.retryButtonText = 'Try Again',
    this.actionButton,
  });

  final Object error;

  /// Callback when retry button is pressed.
  /// Only used when [actionButton] is null.
  final VoidCallback? onRetry;

  final String title;

  /// Whether to show the retry/action button.
  final bool showRetryButton;

  /// Text for the default retry button.
  /// Only used when [actionButton] is null.
  final String retryButtonText;

  /// Custom action button widget.
  /// When provided, this replaces the default retry button.
  /// Use this to inject any button type (TossPrimaryButton, TextButton, etc.)
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              width: UIConstants.avatarSizeLarge,
              height: UIConstants.avatarSizeLarge,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: UIConstants.iconSizeHuge,
                color: TossColors.error,
              ),
            ),
            
            const SizedBox(height: TossSpacing.space5),
            
            // Title
            Text(
              title,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: TossSpacing.space3),
            
            // Error Message
            Text(
              _getErrorMessage(error),
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            if (showRetryButton && (actionButton != null || onRetry != null)) ...[
              const SizedBox(height: TossSpacing.space6),

              // Action Button - custom or default
              SizedBox(
                width: double.infinity,
                child: actionButton ?? _buildDefaultRetryButton(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the default retry button using Flutter primitives only.
  /// This ensures TossErrorView remains a true Atom (no other Atom imports).
  Widget _buildDefaultRetryButton() {
    return SizedBox(
      height: TossSpacing.buttonHeightLG,
      child: ElevatedButton(
        onPressed: onRetry,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: TossColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.button),
          ),
        ),
        child: Text(
          retryButtonText,
          style: TossTextStyles.button.copyWith(
            color: TossColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (kDebugMode) {
      // In debug mode, show the actual error
      if (error is Exception) {
        return error.toString().replaceAll('Exception: ', '');
      }
      return error.toString();
    }
    
    // Production mode - user-friendly messages
    if (error is Exception) {
      final message = error.toString().replaceAll('Exception: ', '');
      // Check for specific error patterns in the message
      if (message.contains('No company selected')) {
        return 'Please select a company first.';
      }
      if (message.contains('Failed to fetch transactions')) {
        return 'Unable to load transactions. Please try again.';
      }
      return message;
    }
    
    final errorString = error.toString();
    
    // Common error patterns
    if (errorString.toLowerCase().contains('network')) {
      return 'Please check your internet connection and try again.';
    }
    
    if (errorString.toLowerCase().contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (errorString.toLowerCase().contains('unauthorized')) {
      return 'You are not authorized to perform this action.';
    }
    
    if (errorString.toLowerCase().contains('not found')) {
      return 'The requested data could not be found.';
    }
    
    // Default message
    return 'An unexpected error occurred. Please try again.';
  }
}