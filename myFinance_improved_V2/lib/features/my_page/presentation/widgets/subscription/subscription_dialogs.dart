import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Helper class for subscription-related dialogs
class SubscriptionDialogs {
  /// Shows success dialog after successful subscription
  static void showSuccessDialog(
    BuildContext context, {
    required String planName,
    required VoidCallback onDismiss,
  }) {
    final isPro = planName == 'pro';
    final planDisplayName = isPro ? 'Pro' : 'Basic';
    final planColor = isPro ? const Color(0xFF3B82F6) : const Color(0xFF10B981);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: planColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                isPro ? LucideIcons.crown : LucideIcons.checkCircle,
                color: planColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Welcome to $planDisplayName!',
                style: TossTextStyles.h4,
              ),
            ),
          ],
        ),
        content: Text(
          'Your $planDisplayName subscription is now active. Enjoy all the features!',
        ),
        actions: [
          TossButton.textButton(
            text: 'Got it!',
            onPressed: () {
              Navigator.pop(context);
              onDismiss();
            },
          ),
        ],
      ),
    );
  }

  /// Shows error dialog
  static void showErrorDialog(
    BuildContext context, {
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: const Icon(
                LucideIcons.alertCircle,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Oops!'),
          ],
        ),
        content: Text(message),
        actions: [
          TossButton.textButton(
            text: 'OK',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Shows restore success dialog
  static void showRestoreSuccessDialog(
    BuildContext context, {
    required bool isProPlan,
    required String currentPlanName,
  }) {
    final planColor = isProPlan ? const Color(0xFF3B82F6) : const Color(0xFF10B981);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: planColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                isProPlan ? LucideIcons.crown : LucideIcons.checkCircle,
                color: planColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Purchases Restored!',
                style: TossTextStyles.h4,
              ),
            ),
          ],
        ),
        content: Text(
          'Your $currentPlanName subscription has been restored successfully.',
        ),
        actions: [
          TossButton.textButton(
            text: 'Got it!',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Shows no purchases found dialog
  static void showNoPurchasesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        title: const Text('No Purchases Found'),
        content: const Text(
          'We couldn\'t find any previous purchases to restore. '
          'If you believe this is an error, please contact support.',
        ),
        actions: [
          TossButton.textButton(
            text: 'OK',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
