// lib/features/cash_ending/presentation/widgets/tabs/cash_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/keyboard_toolbar_1.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../../shared/widgets/toss/toss_card.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../domain/entities/denomination.dart';
import '../../../domain/entities/stock_flow.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/cash_tab_provider.dart';
import '../../providers/cash_tab_state.dart';
import '../collapsible_currency_section.dart';
import '../currency_pill_selector.dart';
import '../denomination_grid_header.dart';
import '../denomination_input.dart';
import '../grand_total_section.dart';
import '../real_section_widget.dart';
import '../section_label.dart';
import '../sheets/cash_ending_selection_helpers.dart';
import '../sheets/currency_selector_sheet.dart';
import '../sheets/flow_detail_bottom_sheet.dart';
import '../store_selector.dart';
import '../total_display.dart';

/// Cash Tab - Denomination-based cash counting
///
/// Structure from legacy:
/// - Card 1: Store + Location selection
/// - Card 2: Denomination inputs + Total + Submit
/// - Card 3: Real section (transaction history)
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

  // Store FocusNodes for each denomination (for keyboard toolbar)
  final Map<String, Map<String, FocusNode>> _focusNodes = {};

  // Keyboard toolbar controller
  KeyboardToolbarController? _toolbarController;

  String? _previousLocationId;

  // Track which currency is currently expanded (accordion behavior)
  String? _expandedCurrencyId;

  @override
  void initState() {
    super.initState();

    // Load initial data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

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
    // Dispose all controllers
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.dispose();
      }
    }

    // Dispose all focus nodes BEFORE disposing toolbar
    // (toolbar controller references these focus nodes but doesn't own them)
    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        focusNode.dispose();
      }
    }

    // Dispose toolbar controller last
    // Note: We already disposed its focus nodes above, so we need to clear them first
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

    // Reload flows if location changed
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedCashLocationId != _previousLocationId) {
      _previousLocationId = pageState.selectedCashLocationId;
      if (pageState.selectedCashLocationId != null &&
          pageState.selectedCashLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedCashLocationId!);

        // Auto-expand first currency when location is selected
        final selectedIds = pageState.selectedCashCurrencyIds.isEmpty
            ? [pageState.currencies.first.currencyId]
            : pageState.selectedCashCurrencyIds;
        if (selectedIds.isNotEmpty) {
          _expandedCurrencyId = selectedIds.first;
        }
      }
    }
  }

  TextEditingController _getController(String currencyId, String denominationId) {
    _controllers.putIfAbsent(currencyId, () => {});
    _controllers[currencyId]!.putIfAbsent(
      denominationId,
      () => TextEditingController(),
    );
    return _controllers[currencyId]![denominationId]!;
  }

  FocusNode _getFocusNode(String currencyId, String denominationId) {
    _focusNodes.putIfAbsent(currencyId, () => {});
    _focusNodes[currencyId]!.putIfAbsent(
      denominationId,
      () => FocusNode(),
    );
    return _focusNodes[currencyId]![denominationId]!;
  }

  void _initializeToolbarController(List<Denomination> denominations, String currencyId) {
    // Dispose existing controller if any
    if (_toolbarController != null) {
      // Clear focus nodes before disposing to prevent double-dispose
      _toolbarController!.focusNodes.clear();
      _toolbarController!.dispose();
    }

    // Create new controller with denomination count
    _toolbarController = KeyboardToolbarController(
      fieldCount: denominations.length,
    );

    // Map our focus nodes to toolbar controller
    for (int i = 0; i < denominations.length; i++) {
      final denom = denominations[i];
      final focusNode = _getFocusNode(currencyId, denom.denominationId);

      // Dispose the default focus node created by KeyboardToolbarController
      _toolbarController!.focusNodes[i].dispose();

      // Replace with our focus node (we own this, toolbar just references it)
      _toolbarController!.focusNodes[i] = focusNode;
    }
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

  /// Load stock flows via provider
  void _loadStockFlowsFromProvider(String locationId) {
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedStoreId == null || pageState.selectedStoreId!.isEmpty) {
      return;
    }

    ref.read(cashTabProvider.notifier).loadStockFlows(
      companyId: widget.companyId,
      storeId: pageState.selectedStoreId!,
      locationId: locationId,
    );
  }

  /// Load more flows for pagination
  void _loadMoreFlows() {
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedCashLocationId == null ||
        pageState.selectedStoreId == null) {
      return;
    }

    ref.read(cashTabProvider.notifier).loadStockFlows(
      companyId: widget.companyId,
      storeId: pageState.selectedStoreId!,
      locationId: pageState.selectedCashLocationId!,
      loadMore: true,
    );
  }

  /// Show flow details in bottom sheet
  void _showFlowDetails(ActualFlow flow) {
    final pageState = ref.read(cashEndingProvider);
    final tabState = ref.read(cashTabProvider);
    FlowDetailBottomSheet.show(
      context: context,
      flow: flow,
      locationSummary: tabState.locationSummary,
      baseCurrencySymbol: pageState.currencies.isNotEmpty
          ? pageState.currencies.first.symbol
          : '\$',
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(cashEndingProvider);
    final tabState = ref.watch(cashTabProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Store and Location Selection
          _buildLocationSelectionCard(pageState),

          // Cash Counting (show if location selected)
          if (pageState.selectedCashLocationId != null &&
              pageState.selectedCashLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space5),
            _buildCashCountingSection(pageState),

            // Submit button at end of content (inside scroll)
            const SizedBox(height: TossSpacing.space5),
            Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: _buildSubmitButton(pageState, tabState),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationSelectionCard(CashEndingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store Selector
        StoreSelector(
          stores: state.stores,
          selectedStoreId: state.selectedStoreId,
          onChanged: (storeId) async {
            if (storeId != null) {
              await ref.read(cashEndingProvider.notifier).selectStore(
                storeId,
                widget.companyId,
              );
            }
          },
        ),

        const SizedBox(height: TossSpacing.space4),
        TossDropdown<String>(
          label: 'Cash Location',
          hint: 'Select Cash Location',
          value: state.selectedCashLocationId,
          isLoading: false,
          items: state.cashLocations.map((location) =>
            TossDropdownItem<String>(
              value: location.locationId,
              label: location.locationName,
            )
          ).toList(),
          onChanged: (locationId) {
            if (locationId != null) {
              ref.read(cashEndingProvider.notifier).setSelectedCashLocation(locationId);
            }
          },
        ),
      ],
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

    // Calculate grand total across all currencies (in base currency)
    double grandTotal = 0.0;
    for (final currency in state.currencies) {
      grandTotal += _calculateTotal(currency.currencyId, currency.denominations);
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Currency Pills
            CurrencyPillSelector(
              availableCurrencies: state.currencies,
              selectedCurrencyIds: state.selectedCashCurrencyIds.isEmpty
                ? [state.currencies.first.currencyId]
                : state.selectedCashCurrencyIds,
              onAddCurrency: () {
                // Show only currencies not already selected
                final availableCurrencies = state.currencies.where((c) =>
                  !state.selectedCashCurrencyIds.contains(c.currencyId)
                ).toList();

                if (availableCurrencies.isEmpty) {
                  return; // All currencies already added
                }

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
            ),

            const SizedBox(height: TossSpacing.space5),

            // Currency accordion sections - show all selected currencies
            ...state.currencies.where((currency) {
              final selectedIds = state.selectedCashCurrencyIds.isEmpty
                ? [state.currencies.first.currencyId]
                : state.selectedCashCurrencyIds;
              return selectedIds.contains(currency.currencyId);
            }).map((currency) {
              // Initialize controllers and focus nodes for this currency
              _controllers.putIfAbsent(currency.currencyId, () => {});
              _focusNodes.putIfAbsent(currency.currencyId, () => {});

              for (final denom in currency.denominations) {
                _controllers[currency.currencyId]!.putIfAbsent(
                  denom.denominationId,
                  () => TextEditingController(),
                );
                _focusNodes[currency.currencyId]!.putIfAbsent(
                  denom.denominationId,
                  () => FocusNode(),
                );
              }

              // Initialize toolbar controller for this currency
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                if (_toolbarController == null ||
                    _toolbarController!.focusNodes.length != currency.denominations.length) {
                  _initializeToolbarController(currency.denominations, currency.currencyId);
                }
              });

              // Get selected currency IDs
              final selectedIds = state.selectedCashCurrencyIds.isEmpty
                ? [state.currencies.first.currencyId]
                : state.selectedCashCurrencyIds;

              return Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.space4),
                child: CollapsibleCurrencySection(
                  currency: currency,
                  controllers: _controllers[currency.currencyId]!,
                  focusNodes: _focusNodes[currency.currencyId]!,
                  totalAmount: _calculateTotal(currency.currencyId, currency.denominations),
                  onChanged: () => setState(() {}),
                  isExpanded: _expandedCurrencyId == currency.currencyId,
                  onToggle: () {
                    setState(() {
                      // Toggle: if this currency is expanded, collapse it; otherwise expand it
                      if (_expandedCurrencyId == currency.currencyId) {
                        _expandedCurrencyId = null;
                      } else {
                        _expandedCurrencyId = currency.currencyId;
                      }
                    });
                  },
                ),
              );
            }),

            const SizedBox(height: TossSpacing.space5),

            // Grand Total
            GrandTotalSection(
              totalAmount: grandTotal,
              currencySymbol: state.currencies.first.symbol,
              label: 'Grand total ${state.currencies.first.currencyCode}',
            ),

            const SizedBox(height: TossSpacing.space2),
          ],
        ),

        // Keyboard toolbar
        if (_toolbarController != null)
          KeyboardToolbar1(
            controller: _toolbarController,
            showToolbar: true,
            onPrevious: () => _toolbarController!.focusPrevious?.call(),
            onNext: () => _toolbarController!.focusNext?.call(),
            onDone: () => _toolbarController!.unfocusAll(),
          ),
      ],
    );
  }

  Widget _buildSubmitButton(CashEndingState state, CashTabState tabState) {
    final selectedCurrencyId = state.selectedCashCurrencyIds.isNotEmpty
      ? state.selectedCashCurrencyIds.first
      : state.currencies.first.currencyId;

    return TossButton1.primary(
      text: 'Submit Ending',
      isLoading: tabState.isSaving,
      isEnabled: !tabState.isSaving,
      fullWidth: true,
      onPressed: !tabState.isSaving
          ? () async {
              try {
                await widget.onSave(context, state, selectedCurrencyId);
              } catch (e) {
                // Error handled by parent
              }
            }
          : null,
      textStyle: TossTextStyles.titleLarge.copyWith(
        color: TossColors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space4,
      ),
      borderRadius: 12,
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
