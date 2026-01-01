// lib/features/cash_ending/presentation/widgets/tabs/cash_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import '../../../domain/entities/currency.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/cash_tab_provider.dart';
import 'cash_tab/cash_tab_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Cash Tab - Denomination-based cash counting
///
/// Structure:
/// - Card 1: Store + Location selection (LocationSelectionCard)
/// - Card 2: Denomination inputs + Total (CashCountingSection)
/// - Submit button (CashSubmitButton)
class CashTab extends ConsumerStatefulWidget {
  final String companyId;
  final Future<void> Function(BuildContext, CashEndingState, String) onSave;

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

  // Store FocusNodes for each denomination
  final Map<String, Map<String, FocusNode>> _focusNodes = {};

  // Keyboard toolbar controller
  KeyboardToolbarController? _toolbarController;

  String? _previousLocationId;
  int _previousResetCounter = 0;
  String? _expandedCurrencyId;
  final Set<String> _initializedCurrencies = {};
  String? _toolbarInitializedForCurrency;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(cashTabProvider.notifier).reset();

      final pageState = ref.read(cashEndingProvider);
      _previousLocationId = pageState.selectedCashLocationId;

      if (pageState.selectedCashLocationId != null &&
          pageState.selectedCashLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedCashLocationId!);
      }
    });
  }

  @override
  void dispose() {
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.dispose();
      }
    }

    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        focusNode.dispose();
      }
    }

    if (_toolbarController != null) {
      _toolbarController!.focusNodes.clear();
      _toolbarController!.dispose();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(CashTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;

    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedCashLocationId != _previousLocationId) {
      _previousLocationId = pageState.selectedCashLocationId;
      if (pageState.selectedCashLocationId != null &&
          pageState.selectedCashLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedCashLocationId!);

        final selectedIds = pageState.selectedCashCurrencyIds.isEmpty &&
                pageState.currencies.isNotEmpty
            ? [pageState.currencies.first.currencyId]
            : pageState.selectedCashCurrencyIds;
        if (selectedIds.isNotEmpty) {
          _expandedCurrencyId = selectedIds.first;
        }
      }
    }
  }

  void _loadStockFlowsFromProvider(String locationId) {
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedStoreId == null ||
        pageState.selectedStoreId!.isEmpty) {
      return;
    }

    ref.read(cashTabProvider.notifier).loadStockFlows(
          companyId: widget.companyId,
          storeId: pageState.selectedStoreId!,
          locationId: locationId,
        );
  }

  void _clearAllInputs() {
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.clear();
      }
    }
    setState(() {});
  }

  void _initializeToolbarController(Currency currency) {
    if (_toolbarController != null) {
      _toolbarController!.focusNodes.clear();
      _toolbarController!.dispose();
      _toolbarController = null;
    }

    _toolbarController = KeyboardToolbarController(
      fieldCount: currency.denominations.length,
    );

    for (int i = 0; i < currency.denominations.length; i++) {
      final denom = currency.denominations[i];
      _focusNodes.putIfAbsent(currency.currencyId, () => {});
      _focusNodes[currency.currencyId]!.putIfAbsent(
        denom.denominationId,
        () => FocusNode(),
      );

      final ourFocusNode = _focusNodes[currency.currencyId]![denom.denominationId]!;
      final defaultFocusNode = _toolbarController!.focusNodes[i];

      if (defaultFocusNode != ourFocusNode) {
        defaultFocusNode.dispose();
      }

      _toolbarController!.focusNodes[i] = ourFocusNode;
    }

    _toolbarInitializedForCurrency = currency.currencyId;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(cashEndingProvider);
    final tabState = ref.watch(cashTabProvider);

    // Clear all inputs when resetInputsCounter changes
    if (pageState.resetInputsCounter != _previousResetCounter) {
      _previousResetCounter = pageState.resetInputsCounter;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _clearAllInputs();
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Location Selection Card
          LocationSelectionCard(
            state: pageState,
            companyId: widget.companyId,
          ),

          // Cash Counting Section (show if location selected)
          if (pageState.selectedCashLocationId != null &&
              pageState.selectedCashLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space5),
            CashCountingSection(
              state: pageState,
              controllers: _controllers,
              focusNodes: _focusNodes,
              initializedCurrencies: _initializedCurrencies,
              expandedCurrencyId: _expandedCurrencyId,
              onExpandedChanged: (currencyId) {
                setState(() {
                  _expandedCurrencyId = currencyId;
                });
              },
              toolbarController: _toolbarController,
              onInitializeToolbar: (currency) {
                if (_toolbarInitializedForCurrency != currency.currencyId) {
                  _initializeToolbarController(currency);
                }
              },
              onStateChanged: () => setState(() {}),
            ),

            // Submit button
            const SizedBox(height: TossSpacing.space5),
            Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: CashSubmitButton(
                state: pageState,
                tabState: tabState,
                onSave: widget.onSave,
              ),
            ),
          ],
        ],
      ),
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
