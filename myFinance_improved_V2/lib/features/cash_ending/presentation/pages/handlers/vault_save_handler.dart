// lib/features/cash_ending/presentation/pages/handlers/vault_save_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/monitoring/sentry_config.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/vault_recount.dart';
import '../../../domain/entities/vault_transaction.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/vault_tab_provider.dart';
import '../cash_ending_completion_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Handler for saving Vault Transaction
/// Extracted from CashEndingPage to reduce file size
class VaultSaveHandler {
  final WidgetRef ref;
  final BuildContext context;
  final bool Function() isMounted;

  VaultSaveHandler({
    required this.ref,
    required this.context,
    required this.isMounted,
  });

  /// Save Vault Transaction (Clean Architecture)
  Future<void> saveVaultTransaction({
    required CashEndingState state,
    required String currencyId,
    required String transactionType,
    required Map<String, Map<String, int>> allQuantities,
    required VoidCallback? onClearQuantities,
  }) async {
    // Immediately set saving state to prevent double-tap
    ref.read(vaultTabProvider.notifier).setSaving(true);

    // Validation
    if (state.selectedVaultLocationId == null) {
      ref.read(vaultTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a vault location',
      );
      return;
    }

    // Get user ID and company ID
    final appState = ref.read(appStateProvider);
    final userId = appState.user['user_id'] as String?;
    final companyId = appState.companyChoosen;

    if (userId == null || companyId.isEmpty) {
      ref.read(vaultTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Missing user or company information',
      );
      return;
    }

    // Validate currencies list is not empty
    if (state.currencies.isEmpty) {
      ref.read(vaultTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'No currencies available. Please reload the page.',
      );
      return;
    }

    // Process ALL selected currencies
    final currencyIdsToProcess = state.selectedVaultCurrencyIds.isNotEmpty
        ? state.selectedVaultCurrencyIds
        : [currencyId];

    final currenciesWithData = _buildCurrenciesWithData(
      state: state,
      currencyIdsToProcess: currencyIdsToProcess,
      allQuantities: allQuantities,
    );

    // Recount vs Normal Transaction
    final now = DateTime.now();
    bool success;

    if (transactionType == 'recount') {
      success = await _handleRecount(
        state: state,
        currenciesWithData: currenciesWithData,
        companyId: companyId,
        userId: userId,
        now: now,
      );
      if (!success) return;
    } else {
      success = await _handleNormalTransaction(
        state: state,
        currenciesWithData: currenciesWithData,
        transactionType: transactionType,
        companyId: companyId,
        userId: userId,
        now: now,
      );
      if (!success) return;
    }

    if (!isMounted()) return;

    if (success) {
      await _handleSuccess(
        state: state,
        currenciesWithData: currenciesWithData,
        transactionType: transactionType,
        companyId: companyId,
        userId: userId,
        onClearQuantities: onClearQuantities,
      );
    } else {
      await _handleError();
    }
  }

  List<Currency> _buildCurrenciesWithData({
    required CashEndingState state,
    required List<String> currencyIdsToProcess,
    required Map<String, Map<String, int>> allQuantities,
  }) {
    return currencyIdsToProcess.map((currId) {
      final currency = state.currencies.firstWhere(
        (c) => c.currencyId == currId,
        orElse: () => state.currencies.first,
      );

      final quantities = allQuantities[currId] ?? {};

      final denominationsWithQuantity = currency.denominations.map((denom) {
        final quantity = quantities[denom.denominationId] ?? 0;
        return denom.copyWith(quantity: quantity);
      }).toList();

      return Currency(
        currencyId: currency.currencyId,
        currencyCode: currency.currencyCode,
        currencyName: currency.currencyName,
        symbol: currency.symbol,
        denominations: denominationsWithQuantity,
        exchangeRateToBase: currency.exchangeRateToBase,
        isBaseCurrency: currency.isBaseCurrency,
      );
    }).toList();
  }

  Future<bool> _handleRecount({
    required CashEndingState state,
    required List<Currency> currenciesWithData,
    required String companyId,
    required String userId,
    required DateTime now,
  }) async {
    final currency = currenciesWithData.first;
    final vaultRecount = VaultRecount(
      companyId: companyId,
      storeId: state.selectedStoreId,
      locationId: state.selectedVaultLocationId!,
      currencyId: currency.currencyId,
      userId: userId,
      recordDate: now,
      createdAt: now,
      denominations: currency.denominations,
    );

    try {
      final recountResult = await ref.read(vaultTabProvider.notifier).recountVault(vaultRecount);
      return recountResult['success'] == true;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEndingPage vault recount failed',
        extra: {
          'locationId': state.selectedVaultLocationId,
          'currencyId': currency.currencyId,
        },
      );
      if (isMounted()) {
        await TossDialogs.showCashEndingError(
          context: context,
          error: 'Recount failed: ${e.toString()}',
        );
      }
      return false;
    }
  }

  Future<bool> _handleNormalTransaction({
    required CashEndingState state,
    required List<Currency> currenciesWithData,
    required String transactionType,
    required String companyId,
    required String userId,
    required DateTime now,
  }) async {
    // Filter out currencies with no quantities
    final currenciesWithQuantities = currenciesWithData
        .where((currency) => currency.denominations.any((d) => d.quantity > 0))
        .toList();

    if (currenciesWithQuantities.isEmpty) {
      ref.read(vaultTabProvider.notifier).setSaving(false);
      if (isMounted()) {
        await TossDialogs.showCashEndingError(
          context: context,
          error: 'Please enter quantities for at least one currency',
        );
      }
      return false;
    }

    // For Vault Out (credit): validate sufficient stock for each denomination
    if (transactionType == 'credit') {
      final validationError = _validateOutTransaction(
        currenciesWithQuantities: currenciesWithQuantities,
      );
      if (validationError != null) {
        ref.read(vaultTabProvider.notifier).setSaving(false);
        if (isMounted()) {
          TossToast.error(context, validationError);
        }
        return false;
      }
    }

    // Create single VaultTransaction with ALL currencies
    final vaultTransaction = VaultTransaction(
      companyId: companyId,
      storeId: state.selectedStoreId,
      locationId: state.selectedVaultLocationId!,
      userId: userId,
      recordDate: now,
      createdAt: now,
      isCredit: transactionType == 'credit',
      currencies: currenciesWithQuantities,
    );

    return await ref.read(vaultTabProvider.notifier).saveVaultTransaction(vaultTransaction);
  }

  /// Validate Vault Out transaction - check if we have enough stock
  /// Returns error message if validation fails, null if OK
  String? _validateOutTransaction({
    required List<Currency> currenciesWithQuantities,
  }) {
    final vaultTabState = ref.read(vaultTabProvider);
    final stockFlows = vaultTabState.stockFlows;

    // Build a map of current stock by denomination
    // From the most recent flow, get currentDenominations
    if (stockFlows.isEmpty) {
      // No stock data available - allow transaction (backend will validate)
      return null;
    }

    // Get current stock from the latest flow's currentDenominations
    final latestFlow = stockFlows.first;
    final currentStock = <String, int>{};
    for (final denom in latestFlow.currentDenominations) {
      currentStock[denom.denominationId] = denom.currentQuantity ?? 0;
    }

    // Check each currency's denominations
    for (final currency in currenciesWithQuantities) {
      for (final denom in currency.denominations) {
        if (denom.quantity <= 0) continue;

        final availableQty = currentStock[denom.denominationId] ?? 0;
        if (denom.quantity > availableQty) {
          final denomValue = denom.value.toInt();
          return 'Insufficient stock: ${currency.symbol}$denomValue (available: $availableQty, requested: ${denom.quantity})';
        }
      }
    }

    return null; // All validations passed
  }

  Future<void> _handleSuccess({
    required CashEndingState state,
    required List<Currency> currenciesWithData,
    required String transactionType,
    required String companyId,
    required String userId,
    required VoidCallback? onClearQuantities,
  }) async {
    // Trigger haptic feedback for success
    HapticFeedback.mediumImpact();

    // Calculate grand total and build denomination quantities map
    double grandTotal = 0.0;
    final Map<String, Map<String, int>> denominationQuantitiesMap = {};

    for (final currencyData in currenciesWithData) {
      final currencyTotal = currencyData.denominations.fold<double>(
        0,
        (sum, denom) => sum + (denom.value * denom.quantity),
      );
      grandTotal += currencyTotal * currencyData.exchangeRateToBase;

      final currencyQuantities = <String, int>{};
      for (final denom in currencyData.denominations) {
        if (denom.quantity > 0) {
          currencyQuantities[denom.value.toString()] = denom.quantity;
        }
      }
      denominationQuantitiesMap[currencyData.currencyId] = currencyQuantities;
    }

    // Fetch balance summary for this location
    await ref.read(vaultTabProvider.notifier).submitVaultEnding(
      locationId: state.selectedVaultLocationId!,
    );

    if (!isMounted()) return;

    final vaultTabState = ref.read(vaultTabProvider);
    final balanceSummary = vaultTabState.balanceSummary;

    // Navigate to completion page
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CashEndingCompletionPage(
          tabType: 'vault',
          grandTotal: grandTotal,
          currencies: currenciesWithData,
          storeName: state.stores
              .firstWhere((s) => s.storeId == state.selectedStoreId)
              .storeName,
          locationName: state.vaultLocations
              .firstWhere((l) => l.locationId == state.selectedVaultLocationId)
              .locationName,
          denominationQuantities: denominationQuantitiesMap,
          transactionType: transactionType,
          balanceSummary: balanceSummary,
          companyId: companyId,
          userId: userId,
          cashLocationId: state.selectedVaultLocationId!,
          storeId: state.selectedStoreId,
        ),
      ),
    );

    if (!isMounted()) return;

    // Clear quantities via callback
    onClearQuantities?.call();
  }

  Future<void> _handleError() async {
    if (!isMounted()) return;

    final tabState = ref.read(vaultTabProvider);
    await TossDialogs.showCashEndingError(
      context: context,
      error: tabState.errorMessage ?? 'Failed to save vault transaction',
    );
  }
}
