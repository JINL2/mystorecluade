import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../auth/presentation/providers/session_manager_provider.dart';
import '../../providers/homepage_providers.dart';

/// Utility class for showing consistent snackbars throughout the app
class SnackbarHelpers {
  /// Show a loading snackbar with consistent styling
  static void showLoading(ScaffoldMessengerState? messenger, String message) {
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
              ),
            ),
            SizedBox(width: TossSpacing.space4),
            Text(message),
          ],
        ),
        backgroundColor: TossColors.primary,
        duration: Duration(seconds: 30),
      ),
    );
  }

  /// Show a success snackbar with optional action
  static void showSuccess(
    ScaffoldMessengerState? messenger,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.success,
        duration: duration ?? Duration(seconds: 3),
        action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: TossColors.white,
              onPressed: onAction,
            )
          : null,
      ),
    );
  }

  /// Show an error snackbar with optional retry
  static void showError(
    ScaffoldMessengerState? messenger,
    String message, {
    VoidCallback? onRetry,
    Duration? duration,
  }) {
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
        duration: duration ?? Duration(seconds: 4),
        action: onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              textColor: TossColors.white,
              onPressed: onRetry,
            )
          : null,
      ),
    );
  }

  /// Dismiss current snackbar if any
  static void dismiss(ScaffoldMessengerState? messenger) {
    messenger?.hideCurrentSnackBar();
  }

  /// Copy text to clipboard and show feedback
  static void copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    final messenger = ScaffoldMessenger.maybeOf(context);
    showSuccess(
      messenger,
      '$label "$text" copied!',
      duration: Duration(seconds: 2),
    );
  }

  /// Navigate to dashboard with proper state refresh
  static Future<void> navigateToDashboard(BuildContext context, WidgetRef ref) async {
    debugPrint('🔄 [NavigateToDashboard] Starting dashboard navigation with data refresh...');

    // First expire the cache to ensure fresh data
    await ref.read(sessionManagerProvider.notifier).expireCache();

    // Invalidate providers to force refresh
    debugPrint('🔄 [NavigateToDashboard] Invalidating all data providers...');
    ref.invalidate(userCompaniesProvider);
    ref.invalidate(categoriesWithFeaturesProvider);

    // Force immediate fetch of fresh data
    debugPrint('🔄 [NavigateToDashboard] Forcing immediate data fetch...');
    try {
      await ref.read(userCompaniesProvider.future);
      await ref.read(categoriesWithFeaturesProvider.future);
      debugPrint('✅ [NavigateToDashboard] Fresh data fetched successfully');
    } catch (e) {
      debugPrint('❌ [NavigateToDashboard] Error fetching fresh data: $e');
    }

    // Navigate
    debugPrint('🔄 [NavigateToDashboard] Navigating to homepage...');
    context.go('/');
  }
}
