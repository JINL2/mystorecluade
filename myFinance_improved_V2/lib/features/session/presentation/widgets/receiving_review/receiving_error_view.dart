import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Error view for receiving review
class ReceivingErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ReceivingErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load items',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            TossButton.textButton(
              text: 'Retry',
              onPressed: onRetry,
              leadingIcon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
