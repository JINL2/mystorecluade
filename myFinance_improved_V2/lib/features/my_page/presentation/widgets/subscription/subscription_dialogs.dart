import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';

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
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: planColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
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
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          'Your $planDisplayName subscription is now active. Enjoy all the features!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDismiss();
            },
            child: const Text('Got it!'),
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
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: planColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isProPlan ? LucideIcons.crown : LucideIcons.checkCircle,
                color: planColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Purchases Restored!',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          'Your $currentPlanName subscription has been restored successfully.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
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
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('No Purchases Found'),
        content: const Text(
          'We couldn\'t find any previous purchases to restore. '
          'If you believe this is an error, please contact support.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
