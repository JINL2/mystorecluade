import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../toss/toss_primary_button.dart';

class TossErrorView extends StatelessWidget {
  const TossErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.title = 'Something went wrong',
    this.showRetryButton = true,
  });

  final Object error;
  final VoidCallback? onRetry;
  final String title;
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TossColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
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
            
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: TossSpacing.space6),
              
              // Retry Button
              SizedBox(
                width: double.infinity,
                child: TossPrimaryButton(
                  text: 'Try Again',
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
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