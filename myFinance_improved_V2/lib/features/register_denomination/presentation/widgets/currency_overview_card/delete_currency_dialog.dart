import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../di/providers.dart';
import '../../../domain/entities/currency.dart';
import '../../providers/currency_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Dialog helper for deleting currencies
class DeleteCurrencyDialog {
  final Currency currency;
  final BuildContext context;

  DeleteCurrencyDialog({
    required this.currency,
    required this.context,
  });

  /// Show the delete currency dialog with proper validation
  Future<void> show() async {
    final ref = ProviderScope.containerOf(context);
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      await _showErrorDialog('No company selected');
      return;
    }

    try {
      final repository = ref.read(currencyRepositoryProvider);
      final hasDenominations = await repository.hasDenominations(companyId, currency.id);

      if (hasDenominations) {
        HapticFeedback.heavyImpact();
        _showCannotDeleteDialog();
        return;
      }

      _showConfirmDeleteDialog();
    } catch (e) {
      await _showErrorDialog('Failed to check currency status: $e');
    }
  }

  void _showCannotDeleteDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: TossColors.error, size: 24),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Cannot Remove Currency',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cannot remove ${currency.code} - ${currency.name} because it has denominations.',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: TossColors.primary, size: 20),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Please delete all denominations first by expanding the currency card and removing each denomination.',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Understood',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDeleteDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Remove Currency',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        content: Text(
          'Are you sure you want to remove ${currency.code} - ${currency.name} from your company?',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final currencyOperations = ref.watch(currencyOperationsProvider);

              return currencyOperations.maybeWhen(
                loading: () => const TextButton(
                  onPressed: null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text('Removing...'),
                    ],
                  ),
                ),
                orElse: () => TextButton(
                  onPressed: () {
                    final operationState = ref.read(currencyOperationsProvider);
                    if (!operationState.isLoading) {
                      _deleteCurrency(dialogContext, ref);
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.error,
                  ),
                  child: Text(
                    'Remove',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCurrency(BuildContext dialogContext, WidgetRef ref) async {
    HapticFeedback.lightImpact();

    if (!dialogContext.mounted) return;
    dialogContext.pop();

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }

      await ref.read(currencyOperationsProvider.notifier).removeCompanyCurrency(currency.id);

      if (!context.mounted) return;

      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.success(
          title: 'Success',
          message: '${currency.code} currency removed successfully!',
          primaryButtonText: 'OK',
        ),
      );

      HapticFeedback.selectionClick();

      if (ref.exists(availableCurrenciesToAddProvider)) {
        ref.invalidate(availableCurrenciesToAddProvider);
      }
    } catch (e) {
      HapticFeedback.heavyImpact();

      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }

      if (!context.mounted) return;

      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: errorMessage,
          primaryButtonText: 'OK',
        ),
      );
    }
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: 'Error',
        message: message,
        primaryButtonText: 'OK',
      ),
    );
  }
}
