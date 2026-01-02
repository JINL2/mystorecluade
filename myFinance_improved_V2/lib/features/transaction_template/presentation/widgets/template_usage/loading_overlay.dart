/// Loading Overlay - Transaction creation loading state
///
/// Purpose: Displays loading overlay when transaction is being created
/// Shows spinner with "Creating transaction..." message
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Loading overlay for transaction creation
class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({
    super.key,
    this.message = 'Creating transaction...',
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: TossColors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TossLoadingView.inline(size: 40),
              const SizedBox(height: TossSpacing.space3),
              Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
