// lib/features/cash_ending/presentation/widgets/error_banner.dart

import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_button_1.dart';

/// Error banner widget for displaying error messages
///
/// Provides user-friendly error display with retry and dismiss options
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.errorLight,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.error),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: TossColors.error,
            size: 24,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  message,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          if (onRetry != null)
            TossButton1(
              text: 'Retry',
              onPressed: onRetry!,
            ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, size: 20, color: TossColors.gray700),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}
