// lib/features/cash_ending/presentation/widgets/tabs/cash_tab/cash_counting_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../cash_location/presentation/pages/account_detail_page.dart';
import '../../../../domain/entities/currency.dart';
import '../../../../domain/entities/denomination.dart';
import '../../../providers/cash_ending_provider.dart';
import '../../../providers/cash_ending_state.dart';
import '../../collapsible_currency_section.dart';
import '../../currency_pill_selector.dart';
import '../../grand_total_section.dart';
import '../../sheets/currency_selector_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Cash Counting Section Widget
/// Displays currency selection and denomination inputs
class CashCountingSection extends ConsumerStatefulWidget {
  final CashEndingState state;
  final Map<String, Map<String, TextEditingController>> controllers;
  final Map<String, Map<String, FocusNode>> focusNodes;
  final Set<String> initializedCurrencies;
  final String? expandedCurrencyId;
  final ValueChanged<String?> onExpandedChanged;
  final KeyboardToolbarController? toolbarController;
  final ValueChanged<Currency> onInitializeToolbar;
  final VoidCallback onStateChanged;

  const CashCountingSection({
    super.key,
    required this.state,
    required this.controllers,
    required this.focusNodes,
    required this.initializedCurrencies,
    required this.expandedCurrencyId,
    required this.onExpandedChanged,
    required this.toolbarController,
    required this.onInitializeToolbar,
    required this.onStateChanged,
  });

  @override
  ConsumerState<CashCountingSection> createState() => _CashCountingSectionState();
}

class _CashCountingSectionState extends ConsumerState<CashCountingSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoadingCurrencies) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space8),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.state.currencies.isEmpty) {
      return _buildEmptyState();
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Currency Pills
            _buildCurrencyPills(),

            const SizedBox(height: TossSpacing.space5),

            // Currency accordion sections
            ..._buildCurrencySections(),

            const SizedBox(height: TossSpacing.space5),

            // Grand Total
            _buildGrandTotal(),

            const SizedBox(height: TossSpacing.space2),
          ],
        ),

        // Keyboard toolbar
        if (widget.toolbarController != null)
          KeyboardToolbar1(
            controller: widget.toolbarController,
            showToolbar: true,
            onPrevious: () => widget.toolbarController!.focusPrevious?.call(),
            onNext: () => widget.toolbarController!.focusNext?.call(),
            onDone: () => widget.toolbarController!.unfocusAll(),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space8),
        child: Column(
          children: [
            const Icon(Icons.inbox, size: 64, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No currencies available',
              style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyPills() {
    final selectedIds = _getSelectedCurrencyIds();

    return CurrencyPillSelector(
      availableCurrencies: widget.state.currencies,
      selectedCurrencyIds: selectedIds,
      onAddCurrency: () {
        // Show only currencies not already selected
        final availableCurrencies = widget.state.currencies
            .where((c) => !widget.state.selectedCashCurrencyIds.contains(c.currencyId))
            .toList();

        if (availableCurrencies.isEmpty) return;

        CurrencySelectorSheet.show(
          context: context,
          ref: ref,
          currencies: availableCurrencies,
          selectedCurrencyId: null,
          tabType: 'cash',
        );
      },
      onRemoveCurrency: (currencyId) {
        ref.read(cashEndingProvider.notifier).removeCashCurrency(currencyId);
      },
    );
  }

  List<Widget> _buildCurrencySections() {
    final selectedIds = _getSelectedCurrencyIds();

    return widget.state.currencies
        .where((currency) => selectedIds.contains(currency.currencyId))
        .map((currency) {
      _ensureCurrencyInitialized(currency);

      return Padding(
        padding: const EdgeInsets.only(bottom: TossSpacing.space4),
        child: CollapsibleCurrencySection(
          currency: currency,
          controllers: widget.controllers[currency.currencyId]!,
          focusNodes: widget.focusNodes[currency.currencyId]!,
          totalAmount: _calculateCurrencySubtotal(currency.currencyId, currency.denominations),
          onChanged: widget.onStateChanged,
          isExpanded: widget.expandedCurrencyId == currency.currencyId,
          baseCurrencySymbol: widget.state.baseCurrencySymbol,
          onToggle: () => _handleCurrencyToggle(currency),
        ),
      );
    }).toList();
  }

  Widget _buildGrandTotal() {
    return ListenableBuilder(
      listenable: Listenable.merge(
        widget.controllers.values.expand((map) => map.values).toList(),
      ),
      builder: (context, _) {
        final grandTotal = _calculateGrandTotal();
        return GrandTotalSection(
          totalAmount: grandTotal,
          currencySymbol: widget.state.baseCurrencySymbol,
          label: 'Grand total ${widget.state.baseCurrency?.currencyCode ?? ""}',
          isBaseCurrency: true,
          journalAmount: widget.state.cashLocationJournalAmount,
          isLoadingJournal: widget.state.isLoadingJournalAmount,
          onHistoryTap: widget.state.selectedCashLocationId != null
              ? () => _navigateToAccountDetail(grandTotal)
              : null,
        );
      },
    );
  }

  List<String> _getSelectedCurrencyIds() {
    if (widget.state.selectedCashCurrencyIds.isEmpty && widget.state.currencies.isNotEmpty) {
      return [widget.state.currencies.first.currencyId];
    }
    return widget.state.selectedCashCurrencyIds;
  }

  void _ensureCurrencyInitialized(Currency currency) {
    if (widget.initializedCurrencies.contains(currency.currencyId)) {
      return;
    }

    widget.controllers.putIfAbsent(currency.currencyId, () => {});
    widget.focusNodes.putIfAbsent(currency.currencyId, () => {});

    for (final denom in currency.denominations) {
      widget.controllers[currency.currencyId]!.putIfAbsent(
        denom.denominationId,
        () => TextEditingController(),
      );
      widget.focusNodes[currency.currencyId]!.putIfAbsent(
        denom.denominationId,
        () => FocusNode(),
      );
    }

    widget.initializedCurrencies.add(currency.currencyId);
  }

  void _handleCurrencyToggle(Currency currency) {
    final willBeExpanded = widget.expandedCurrencyId != currency.currencyId;

    if (widget.expandedCurrencyId == currency.currencyId) {
      widget.onExpandedChanged(null);
    } else {
      widget.onExpandedChanged(currency.currencyId);
    }

    if (willBeExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onInitializeToolbar(currency);
      });
    }
  }

  double _calculateGrandTotal() {
    double grandTotal = 0.0;

    for (final currency in widget.state.currencies) {
      final currencyControllers = widget.controllers[currency.currencyId];
      if (currencyControllers == null) continue;

      double currencySubtotal = 0.0;
      for (final denomination in currency.denominations) {
        final controller = currencyControllers[denomination.denominationId];
        if (controller == null) continue;

        final quantity = int.tryParse(controller.text.trim()) ?? 0;
        currencySubtotal += denomination.value * quantity;
      }

      final amountInBaseCurrency = currencySubtotal * currency.exchangeRateToBase;
      grandTotal += amountInBaseCurrency;
    }

    return grandTotal;
  }

  double _calculateCurrencySubtotal(String currencyId, List<Denomination> denominations) {
    final currencyControllers = widget.controllers[currencyId];
    if (currencyControllers == null) return 0.0;

    double subtotal = 0.0;
    for (final denomination in denominations) {
      final controller = currencyControllers[denomination.denominationId];
      if (controller == null) continue;

      final quantity = int.tryParse(controller.text.trim()) ?? 0;
      subtotal += denomination.value * quantity;
    }

    return subtotal;
  }

  void _navigateToAccountDetail(double grandTotal) {
    if (widget.state.selectedCashLocationId == null) return;

    final selectedLocation = widget.state.cashLocations.firstWhere(
      (loc) => loc.locationId == widget.state.selectedCashLocationId,
      orElse: () => widget.state.cashLocations.first,
    );

    final journalAmount = widget.state.cashLocationJournalAmount ?? 0.0;
    final difference = grandTotal - journalAmount;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailPage(
          locationId: widget.state.selectedCashLocationId,
          accountName: selectedLocation.locationName,
          locationType: 'cash',
          balance: journalAmount.toInt(),
          errors: difference.toInt().abs(),
          totalJournal: journalAmount.toInt(),
          totalReal: grandTotal.toInt(),
          cashDifference: difference.toInt(),
          currencySymbol: widget.state.baseCurrencySymbol,
        ),
      ),
    );
  }
}
