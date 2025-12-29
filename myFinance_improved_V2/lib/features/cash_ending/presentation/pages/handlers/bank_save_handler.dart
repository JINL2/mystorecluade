// lib/features/cash_ending/presentation/pages/handlers/bank_save_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/bank_balance.dart';
import '../../../domain/entities/denomination.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/bank_tab_provider.dart';
import '../cash_ending_completion_page.dart';

/// Handler for saving Bank Balance
/// Extracted from CashEndingPage to reduce file size
class BankSaveHandler {
  final WidgetRef ref;
  final BuildContext context;
  final bool Function() isMounted;

  BankSaveHandler({
    required this.ref,
    required this.context,
    required this.isMounted,
  });

  /// Save Bank Balance (Clean Architecture)
  Future<void> saveBankBalance({
    required CashEndingState state,
    required String currencyId,
    required String amount,
    required VoidCallback? onClearAmount,
  }) async {
    // Immediately set saving state to prevent double-tap
    ref.read(bankTabProvider.notifier).setSaving(true);

    // Validation
    if (state.selectedBankLocationId == null) {
      ref.read(bankTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a bank location',
      );
      return;
    }

    // Get company and user IDs
    final companyId = ref.read(appStateProvider).companyChoosen;
    final userId = ref.read(appStateProvider).user['user_id'] as String?;

    if (companyId.isEmpty || userId == null) {
      ref.read(bankTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Invalid company or user',
      );
      return;
    }

    // Check if user has explicitly entered a value
    final isExplicitlySet = amount.isNotEmpty;

    // Parse amount (remove commas if any) as integer
    final amountText = amount.replaceAll(',', '');
    final totalAmount = int.tryParse(amountText) ?? 0;

    // Create BankBalance entity
    final now = DateTime.now();

    // Get currency info from state
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == currencyId,
      orElse: () => throw Exception('Currency not found'),
    );

    final bankBalance = BankBalance(
      companyId: companyId,
      storeId: state.selectedStoreId,
      locationId: state.selectedBankLocationId!,
      userId: userId,
      recordDate: now,
      createdAt: now,
      currencies: [
        currency.copyWith(
          denominations: [
            Denomination(
              denominationId: 'bank-total-$currencyId',
              currencyId: currencyId,
              value: 1,
              quantity: totalAmount,
            ),
          ],
        ),
      ],
      isExplicitlySet: isExplicitlySet,
    );

    // Save via BankTabProvider
    final success = await ref.read(bankTabProvider.notifier).saveBankBalance(bankBalance);

    if (!isMounted()) return;

    if (success) {
      await _handleSuccess(
        state: state,
        currencyId: currencyId,
        totalAmount: totalAmount,
        companyId: companyId,
        userId: userId,
        onClearAmount: onClearAmount,
      );
    } else {
      await _handleError();
    }
  }

  Future<void> _handleSuccess({
    required CashEndingState state,
    required String currencyId,
    required int totalAmount,
    required String companyId,
    required String userId,
    required VoidCallback? onClearAmount,
  }) async {
    // Trigger haptic feedback for success
    HapticFeedback.mediumImpact();

    // Get currency for completion page
    final currency = state.currencies.firstWhere((c) => c.currencyId == currencyId);

    // Fetch balance summary for this location
    await ref.read(bankTabProvider.notifier).submitBankEnding(
      locationId: state.selectedBankLocationId!,
    );

    if (!isMounted()) return;

    final bankTabState = ref.read(bankTabProvider);
    final balanceSummary = bankTabState.balanceSummary;

    // Navigate to completion page
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CashEndingCompletionPage(
          tabType: 'bank',
          grandTotal: totalAmount.toDouble(),
          currencies: [currency],
          storeName: state.stores
              .firstWhere((s) => s.storeId == state.selectedStoreId)
              .storeName,
          locationName: state.bankLocations
              .firstWhere((l) => l.locationId == state.selectedBankLocationId)
              .locationName,
          balanceSummary: balanceSummary,
          companyId: companyId,
          userId: userId,
          cashLocationId: state.selectedBankLocationId!,
          storeId: state.selectedStoreId,
        ),
      ),
    );

    if (!isMounted()) return;

    // Clear amount via callback
    onClearAmount?.call();
  }

  Future<void> _handleError() async {
    if (!isMounted()) return;

    final tabState = ref.read(bankTabProvider);
    await TossDialogs.showCashEndingError(
      context: context,
      error: tabState.errorMessage ?? 'Failed to save bank balance',
    );
  }
}
