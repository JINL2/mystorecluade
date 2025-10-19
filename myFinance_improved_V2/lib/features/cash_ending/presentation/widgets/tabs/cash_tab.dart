// lib/features/cash_ending/presentation/widgets/tabs/cash_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_card.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/denomination.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../denomination_input.dart';
import '../location_selector.dart';
import '../sheets/currency_selector_sheet.dart';
import '../sheets/location_selector_sheet.dart';
import '../sheets/store_selector_sheet.dart';
import '../store_selector.dart';
import '../total_display.dart';

/// Cash Tab - Denomination-based cash counting
///
/// Structure from legacy:
/// - Card 1: Store + Location selection
/// - Card 2: Denomination inputs + Total + Submit
class CashTab extends ConsumerStatefulWidget {
  final String companyId;
  final Function(BuildContext, CashEndingState, String) onSave;

  const CashTab({
    super.key,
    required this.companyId,
    required this.onSave,
  });

  @override
  ConsumerState<CashTab> createState() => _CashTabState();
}

class _CashTabState extends ConsumerState<CashTab> {
  // Store TextEditingControllers for each denomination
  final Map<String, Map<String, TextEditingController>> _controllers = {};

  @override
  void dispose() {
    // Dispose all controllers
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  TextEditingController _getController(String currencyId, String denominationId) {
    _controllers.putIfAbsent(currencyId, () => {});
    _controllers[currencyId]!.putIfAbsent(
      denominationId,
      () => TextEditingController(),
    );
    return _controllers[currencyId]![denominationId]!;
  }

  double _calculateTotal(String currencyId, List<Denomination> denominations) {
    double total = 0.0;
    final currencyControllers = _controllers[currencyId] ?? {};

    for (final denom in denominations) {
      final controller = currencyControllers[denom.denominationId];
      if (controller != null) {
        final quantity = int.tryParse(controller.text.trim()) ?? 0;
        total += denom.value * quantity;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cashEndingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card 1: Store and Location Selection
          _buildLocationSelectionCard(state),

          // Card 2: Cash Counting (show if location selected)
          if (state.selectedCashLocationId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            _buildCashCountingCard(state),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationSelectionCard(CashEndingState state) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Selector
          StoreSelector(
            stores: state.stores,
            selectedStoreId: state.selectedStoreId,
            onTap: () {
              StoreSelectorSheet.show(
                context: context,
                ref: ref,
                stores: state.stores,
                selectedStoreId: state.selectedStoreId,
                companyId: widget.companyId,
              );
            },
          ),

          // Location Selector (show if store selected)
          if (state.selectedStoreId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            LocationSelector(
              locationType: 'cash',
              isLoading: false,
              locations: state.cashLocations,
              selectedLocationId: state.selectedCashLocationId,
              onTap: () {
                LocationSelectorSheet.show(
                  context: context,
                  ref: ref,
                  locationType: 'cash',
                  locations: state.cashLocations,
                  selectedLocationId: state.selectedCashLocationId,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCashCountingCard(CashEndingState state) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: _buildCashCountingSection(state),
    );
  }

  Widget _buildCashCountingSection(CashEndingState state) {
    if (state.isLoadingCurrencies) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space8),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.currencies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space8),
          child: Column(
            children: [
              const Icon(Icons.inbox, size: 64, color: TossColors.gray400),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No currencies available',
                style: TossTextStyles.bodyLarge
                    .copyWith(color: TossColors.gray600),
              ),
            ],
          ),
        ),
      );
    }

    final selectedCurrencyId =
        state.selectedCashCurrencyId ?? state.currencies.first.currencyId;
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == selectedCurrencyId,
      orElse: () => state.currencies.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: "Cash Count" title + Currency selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cash Count',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            if (state.currencies.length > 1)
              GestureDetector(
                onTap: () {
                  CurrencySelectorSheet.show(
                    context: context,
                    ref: ref,
                    currencies: state.currencies,
                    selectedCurrencyId: selectedCurrencyId,
                    tabType: 'cash',
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currency.currencyCode,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: TossColors.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: TossSpacing.space5),

        // Denomination Inputs
        if (currency.denominations.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space8),
              child: Text(
                'No denominations configured for this currency',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...currency.denominations.map((denom) {
            final controller = _getController(selectedCurrencyId, denom.denominationId);

            return DenominationInput(
              denomination: denom,
              controller: controller,
              currencySymbol: currency.symbol,
              onChanged: () {
                setState(() {}); // Update total display
              },
            );
          }),

        const SizedBox(height: TossSpacing.space8),

        // Total Display
        TotalDisplay(
          totalAmount: _calculateTotal(selectedCurrencyId, currency.denominations),
          currencySymbol: currency.symbol,
          label: 'Cash Total',
        ),

        const SizedBox(height: TossSpacing.space10),

        // Submit Button
        ElevatedButton(
          onPressed: state.isSaving
              ? null
              : () async {
                  await widget.onSave(context, state, selectedCurrencyId);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.primary,
            foregroundColor: TossColors.white,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state.isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(TossColors.white),
                  ),
                )
              : Text(
                  'Save Cash Ending',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.white,
                  ),
                ),
        ),
      ],
    );
  }

  // Expose quantities for parent to access
  Map<String, Map<String, int>> get denominationQuantities {
    final quantities = <String, Map<String, int>>{};
    for (final currencyId in _controllers.keys) {
      quantities[currencyId] = {};
      for (final denominationId in _controllers[currencyId]!.keys) {
        final controller = _controllers[currencyId]![denominationId]!;
        final quantity = int.tryParse(controller.text.trim()) ?? 0;
        if (quantity > 0) {
          quantities[currencyId]![denominationId] = quantity;
        }
      }
    }
    return quantities;
  }

  void clearQuantities() {
    setState(() {
      for (final currencyControllers in _controllers.values) {
        for (final controller in currencyControllers.values) {
          controller.clear();
        }
      }
    });
  }
}
