// lib/features/cash_ending/presentation/widgets/tabs/cash_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_icons.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/keyboard_toolbar_1.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../../shared/widgets/selectors/toss_base_selector.dart';
import '../../../../cash_location/presentation/pages/account_detail_page.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/denomination.dart';
import '../../../domain/entities/location.dart';
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

  // Track previous resetInputsCounter to detect changes
  int _previousResetCounter = 0;

  // Track which currency is currently expanded (accordion behavior)
  String? _expandedCurrencyId;

  // Track which currencies have been initialized (avoid re-initialization in build)
  final Set<String> _initializedCurrencies = {};

  // Track which currency's toolbar has been initialized
  String? _toolbarInitializedForCurrency;

  @override
  void initState() {
    super.initState();

    // Reset cash tab state to clear any previous isSaving/error state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Reset to ensure clean state
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

  /// Clear all denomination input fields
  void _clearAllInputs() {
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.clear();
      }
    }
    setState(() {
      // Force rebuild to update UI
    });
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
        final selectedIds = pageState.selectedCashCurrencyIds.isEmpty && pageState.currencies.isNotEmpty
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

  /// Initialize controllers and focus nodes for a currency
  /// Called once per currency to avoid repeated initialization in build()
  void _ensureCurrencyInitialized(Currency currency) {
    if (_initializedCurrencies.contains(currency.currencyId)) {
      return; // Already initialized
    }

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

    _initializedCurrencies.add(currency.currencyId);
  }

  void _initializeToolbarController(List<Denomination> denominations, String currencyId) {
    // Safely dispose existing controller (we don't own the focus nodes)
    if (_toolbarController != null) {
      _toolbarController!.focusNodes.clear();
      _toolbarController!.dispose();
      _toolbarController = null;
    }

    // Create new controller with denomination count
    _toolbarController = KeyboardToolbarController(
      fieldCount: denominations.length,
    );

    // Map our focus nodes to toolbar controller
    for (int i = 0; i < denominations.length; i++) {
      final denom = denominations[i];
      final ourFocusNode = _getFocusNode(currencyId, denom.denominationId);
      final defaultFocusNode = _toolbarController!.focusNodes[i];

      // Only dispose if it's NOT our focus node (avoid double-dispose)
      if (defaultFocusNode != ourFocusNode) {
        defaultFocusNode.dispose();
      }

      // Replace with our focus node (we own this, toolbar just references it)
      _toolbarController!.focusNodes[i] = ourFocusNode;
    }
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

    // ✅ Clear all inputs when resetInputsCounter changes
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
              // ✅ Sync global app state for Account Detail Page
              final store = state.stores.firstWhere(
                (s) => s.storeId == storeId,
                orElse: () => state.stores.first,
              );
              ref.read(appStateProvider.notifier).selectStore(
                storeId,
                storeName: store.storeName,
              );

              await ref.read(cashEndingProvider.notifier).selectStore(
                storeId,
                widget.companyId,
              );
            }
          },
        ),

        const SizedBox(height: TossSpacing.space4),
        if (state.cashLocations.isEmpty)
          // Show disabled state when no cash locations available
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TossColors.gray300, width: 1),
            ),
            child: Row(
              children: [
                Icon(TossIcons.wallet, size: 20, color: TossColors.gray400),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cash Location',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'No cash locations available',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          TossSingleSelector<Location>(
            items: state.cashLocations,
            selectedItem: state.selectedCashLocationId != null
                ? state.cashLocations.firstWhere(
                    (loc) => loc.locationId == state.selectedCashLocationId,
                    orElse: () => state.cashLocations.first,
                  )
                : null,
            onChanged: (locationId) {
              if (locationId != null) {
                ref.read(cashEndingProvider.notifier).setSelectedCashLocation(locationId);
              }
            },
            config: const SelectorConfig(
              label: 'Cash Location',
              hint: 'Select Cash Location',
              showSearch: false,
            ),
            itemIdBuilder: (location) => location.locationId,
            itemTitleBuilder: (location) => location.locationName,
            itemSubtitleBuilder: (location) => '',
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

    // ✅ Calculate grand total using Domain Entity method
    double grandTotal = 0.0;
    for (final currency in state.currencies) {
      grandTotal += currency.totalAmount;
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Currency Pills
            CurrencyPillSelector(
              availableCurrencies: state.currencies,
              selectedCurrencyIds: state.selectedCashCurrencyIds.isEmpty && state.currencies.isNotEmpty
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
              final selectedIds = state.selectedCashCurrencyIds.isEmpty && state.currencies.isNotEmpty
                ? [state.currencies.first.currencyId]
                : state.selectedCashCurrencyIds;
              return selectedIds.contains(currency.currencyId);
            }).map((currency) {
              // Initialize controllers and focus nodes ONCE per currency
              _ensureCurrencyInitialized(currency);

              // Get selected currency IDs
              final selectedIds = state.selectedCashCurrencyIds.isEmpty && state.currencies.isNotEmpty
                ? [state.currencies.first.currencyId]
                : state.selectedCashCurrencyIds;

              return Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.space4),
                child: CollapsibleCurrencySection(
                  currency: currency,
                  controllers: _controllers[currency.currencyId]!,
                  focusNodes: _focusNodes[currency.currencyId]!,
                  totalAmount: _calculateCurrencySubtotal(
                    currency.currencyId,
                    currency.denominations,
                  ),
                  onChanged: () => setState(() {}),
                  isExpanded: _expandedCurrencyId == currency.currencyId,
                  baseCurrencySymbol: state.baseCurrencySymbol,
                  onToggle: () {
                    final willBeExpanded = _expandedCurrencyId != currency.currencyId;

                    setState(() {
                      // Toggle: if this currency is expanded, collapse it; otherwise expand it
                      if (_expandedCurrencyId == currency.currencyId) {
                        _expandedCurrencyId = null;
                      } else {
                        _expandedCurrencyId = currency.currencyId;
                      }
                    });

                    // Initialize toolbar only when expanding AND not already initialized for this currency
                    if (willBeExpanded && _toolbarInitializedForCurrency != currency.currencyId) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        _initializeToolbarController(currency.denominations, currency.currencyId);
                        _toolbarInitializedForCurrency = currency.currencyId;
                      });
                    }
                  },
                ),
              );
            }),

            const SizedBox(height: TossSpacing.space5),

            // Grand Total (converted to base currency)
            // Use ListenableBuilder to update when any controller changes
            ListenableBuilder(
              listenable: Listenable.merge(
                _controllers.values
                    .expand((map) => map.values)
                    .toList(),
              ),
              builder: (context, _) {
                final grandTotal = _calculateGrandTotal(state);
                return GrandTotalSection(
                  totalAmount: grandTotal,
                  currencySymbol: state.baseCurrencySymbol,
                  label: 'Grand total ${state.baseCurrency?.currencyCode ?? ""}',
                  isBaseCurrency: true,
                  journalAmount: state.cashLocationJournalAmount,
                  isLoadingJournal: state.isLoadingJournalAmount,
                  onHistoryTap: state.selectedCashLocationId != null
                      ? () => _navigateToAccountDetail(state, grandTotal)
                      : null,
                );
              },
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
    // Get selected currency ID safely
    String? selectedCurrencyId;
    if (state.selectedCashCurrencyIds.isNotEmpty) {
      selectedCurrencyId = state.selectedCashCurrencyIds.first;
    } else if (state.currencies.isNotEmpty) {
      selectedCurrencyId = state.currencies.first.currencyId;
    }

    // If no currency available, disable submit button
    if (selectedCurrencyId == null) {
      return TossButton1.primary(
        text: 'Submit Ending',
        isLoading: false,
        isEnabled: false,
        fullWidth: true,
        onPressed: null,
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

    // At this point selectedCurrencyId is guaranteed to be non-null
    final currencyId = selectedCurrencyId; // Make it non-nullable for the closure

    return TossButton1.primary(
      text: 'Submit Ending',
      isLoading: tabState.isSaving,
      isEnabled: !tabState.isSaving,
      fullWidth: true,
      onPressed: !tabState.isSaving
          ? () async {
              // Let onSave handle errors and display to user
              await widget.onSave(context, state, currencyId);
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

  /// Calculate Grand Total in base currency from controller values
  /// This reads the actual user input instead of relying on Currency entity
  double _calculateGrandTotal(CashEndingState state) {
    double grandTotal = 0.0;

    for (final currency in state.currencies) {
      final currencyControllers = _controllers[currency.currencyId];
      if (currencyControllers == null) continue;

      // Calculate subtotal for this currency
      double currencySubtotal = 0.0;
      for (final denomination in currency.denominations) {
        final controller = currencyControllers[denomination.denominationId];
        if (controller == null) continue;

        final quantity = int.tryParse(controller.text.trim()) ?? 0;
        currencySubtotal += denomination.value * quantity;
      }

      // Convert to base currency using exchange rate
      final amountInBaseCurrency = currencySubtotal * currency.exchangeRateToBase;
      grandTotal += amountInBaseCurrency;
    }

    return grandTotal;
  }

  /// Calculate subtotal for a specific currency from controller values
  double _calculateCurrencySubtotal(String currencyId, List<Denomination> denominations) {
    final currencyControllers = _controllers[currencyId];
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

  /// Navigate to AccountDetailPage for transaction history
  void _navigateToAccountDetail(CashEndingState state, double grandTotal) {
    if (state.selectedCashLocationId == null) return;

    // Find the selected location
    final selectedLocation = state.cashLocations.firstWhere(
      (loc) => loc.locationId == state.selectedCashLocationId,
      orElse: () => state.cashLocations.first,
    );

    // Calculate difference
    final journalAmount = state.cashLocationJournalAmount ?? 0.0;
    final difference = grandTotal - journalAmount;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailPage(
          locationId: state.selectedCashLocationId,
          accountName: selectedLocation.locationName,
          locationType: 'cash',
          balance: journalAmount.toInt(),
          errors: difference.toInt().abs(),
          totalJournal: journalAmount.toInt(),
          totalReal: grandTotal.toInt(),
          cashDifference: difference.toInt(),
          currencySymbol: state.baseCurrencySymbol,
        ),
      ),
    );
  }
}
