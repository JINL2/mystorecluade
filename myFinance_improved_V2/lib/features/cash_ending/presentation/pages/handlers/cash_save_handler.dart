// lib/features/cash_ending/presentation/pages/handlers/cash_save_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../domain/entities/cash_ending.dart';
import '../../../domain/entities/currency.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/cash_tab_provider.dart';
import '../cash_ending_completion_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Handler for saving Cash Ending
/// Extracted from CashEndingPage to reduce file size
class CashSaveHandler {
  final WidgetRef ref;
  final BuildContext context;
  final bool Function() isMounted;

  CashSaveHandler({
    required this.ref,
    required this.context,
    required this.isMounted,
  });

  /// Save Cash Ending (from legacy cash_service.dart)
  Future<void> saveCashEnding({
    required CashEndingState state,
    required String currencyId,
    required Map<String, Map<String, int>> allQuantities,
  }) async {
    // Immediately set saving state to prevent double-tap
    ref.read(cashTabProvider.notifier).setSaving(true);

    // Validation
    if (state.selectedCashLocationId == null) {
      ref.read(cashTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a cash location',
      );
      return;
    }

    final companyId = ref.read(appStateProvider).companyChoosen;
    final userId = ref.read(appStateProvider).user['user_id']?.toString() ?? '';

    if (companyId.isEmpty || userId.isEmpty) {
      ref.read(cashTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Invalid company or user',
      );
      return;
    }

    // Validate currencies list is not empty
    if (state.currencies.isEmpty) {
      ref.read(cashTabProvider.notifier).setSaving(false);
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'No currencies available. Please reload the page.',
      );
      return;
    }

    // Process ALL selected currencies
    final currencyIdsToProcess = state.selectedCashCurrencyIds.isNotEmpty
        ? state.selectedCashCurrencyIds
        : [currencyId];

    final currenciesWithData = _buildCurrenciesWithData(
      state: state,
      currencyIdsToProcess: currencyIdsToProcess,
      allQuantities: allQuantities,
    );

    // Create CashEnding entity
    final now = DateTime.now();
    final cashEnding = CashEnding(
      companyId: companyId,
      locationId: state.selectedCashLocationId!,
      storeId: state.selectedStoreId,
      userId: userId,
      recordDate: now,
      createdAt: now,
      currencies: currenciesWithData,
    );

    // Save via CashTabProvider
    final success = await ref.read(cashTabProvider.notifier).saveCashEnding(cashEnding);

    if (!isMounted()) return;

    if (success) {
      await _handleSuccess(
        state: state,
        currenciesWithData: currenciesWithData,
        companyId: companyId,
        userId: userId,
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

  Future<void> _handleSuccess({
    required CashEndingState state,
    required List<Currency> currenciesWithData,
    required String companyId,
    required String userId,
  }) async {
    // Calculate grand total across all currencies
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
    await ref.read(cashTabProvider.notifier).submitCashEnding(
      locationId: state.selectedCashLocationId!,
    );

    if (!isMounted()) return;

    final cashTabState = ref.read(cashTabProvider);
    final balanceSummary = cashTabState.balanceSummary;

    // Navigate to completion page
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CashEndingCompletionPage(
          tabType: 'cash',
          grandTotal: grandTotal,
          currencies: currenciesWithData,
          storeName: state.stores
              .firstWhere((s) => s.storeId == state.selectedStoreId)
              .storeName,
          locationName: state.cashLocations
              .firstWhere((l) => l.locationId == state.selectedCashLocationId)
              .locationName,
          denominationQuantities: denominationQuantitiesMap,
          balanceSummary: balanceSummary,
          companyId: companyId,
          userId: userId,
          cashLocationId: state.selectedCashLocationId!,
          storeId: state.selectedStoreId,
        ),
      ),
    );
  }

  Future<void> _handleError() async {
    if (!isMounted()) return;

    final tabState = ref.read(cashTabProvider);
    await TossDialogs.showCashEndingError(
      context: context,
      error: tabState.errorMessage ?? 'Failed to save cash ending',
    );
  }
}
