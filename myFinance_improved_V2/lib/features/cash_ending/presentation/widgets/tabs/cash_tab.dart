// lib/features/cash_ending/presentation/widgets/tabs/cash_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/keyboard_toolbar_1.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../../shared/widgets/toss/toss_card.dart';
import '../../../domain/entities/denomination.dart';
import '../../../domain/entities/stock_flow.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/cash_tab_provider.dart';
import '../denomination_input.dart';
import '../location_selector.dart';
import '../real_section_widget.dart';
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

  @override
  void initState() {
    super.initState();

    // Add listener for location changes
    ref.listenManual(
      cashEndingProvider.select((state) => state.selectedCashLocationId),
      (previous, next) {
        if (next != null && next.isNotEmpty && next != previous) {
          _previousLocationId = next;
          _loadStockFlowsFromProvider(next);
        }
      },
    );

    // Load initial data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    // Dispose toolbar controller first (it may hold references to focus nodes)
    _toolbarController?.dispose();

    // Dispose all controllers
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.dispose();
      }
    }
    // Dispose all focus nodes
    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(CashTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload flows if location changed
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedCashLocationId != _previousLocationId) {
      _previousLocationId = pageState.selectedCashLocationId;
      if (pageState.selectedCashLocationId != null &&
          pageState.selectedCashLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedCashLocationId!);
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
    _toolbarController?.dispose();

    // Create new controller with denomination count
    _toolbarController = KeyboardToolbarController(
      fieldCount: denominations.length,
    );

    // Map focus nodes to toolbar controller
    for (int i = 0; i < denominations.length; i++) {
      final denom = denominations[i];
      final focusNode = _getFocusNode(currencyId, denom.denominationId);

      // Replace toolbar's focus node with our focus node
      _toolbarController!.focusNodes[i].dispose();
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
          // Card 1: Store and Location Selection
          _buildLocationSelectionCard(pageState),

          // Card 2: Cash Counting (show if location selected)
          if (pageState.selectedCashLocationId != null &&
              pageState.selectedCashLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space6),
            _buildCashCountingCard(pageState),

            // Card 3: Real Section
            const SizedBox(height: TossSpacing.space6),
            RealSectionWidget(
              actualFlows: tabState.stockFlows,
              locationSummary: tabState.locationSummary,
              isLoading: tabState.isLoadingFlows,
              hasMore: tabState.hasMoreFlows,
              baseCurrencySymbol: pageState.currencies.isNotEmpty
                  ? pageState.currencies.first.symbol
                  : '\$',
              onLoadMore: _loadMoreFlows,
              onItemTap: _showFlowDetails,
            ),
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
              CashEndingSelectionHelpers.showStoreSelector(
                context: context,
                ref: ref,
                stores: state.stores,
                selectedStoreId: state.selectedStoreId,
                companyId: widget.companyId,
              );
            },
          ),

          // Location Selector (always show like lib_old)
          const SizedBox(height: TossSpacing.space6),
          LocationSelector(
            locationType: 'cash',
            isLoading: false,
            locations: state.cashLocations,
            selectedLocationId: state.selectedCashLocationId,
            onTap: () {
              CashEndingSelectionHelpers.showLocationSelector(
                context: context,
                ref: ref,
                locationType: 'cash',
                locations: state.cashLocations,
                selectedLocationId: state.selectedCashLocationId,
              );
            },
          ),
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

    // Wrap in Stack to render toolbar separately from Column
    return Stack(
      children: [
        // Main content in Column
        Column(
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
        else ...[
          // Initialize toolbar controller for this currency
          Builder(
            builder: (context) {
              // Initialize toolbar controller when building denominations
              if (_toolbarController == null ||
                  _toolbarController!.focusNodes.length != currency.denominations.length) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _initializeToolbarController(currency.denominations, selectedCurrencyId);
                });
              }
              return const SizedBox.shrink();
            },
          ),
          ...currency.denominations.asMap().entries.map((entry) {
            final denom = entry.value;
            final controller = _getController(selectedCurrencyId, denom.denominationId);
            final focusNode = _getFocusNode(selectedCurrencyId, denom.denominationId);

            return DenominationInput(
              denomination: denom,
              controller: controller,
              focusNode: focusNode,
              currencySymbol: currency.symbol,
              onChanged: () {
                setState(() {}); // Update total display
              },
            );
          }),
        ],

        const SizedBox(height: TossSpacing.space8),

        // Total Display
        TotalDisplay(
          totalAmount: _calculateTotal(selectedCurrencyId, currency.denominations),
          currencySymbol: currency.symbol,
          label: 'Cash Total',
        ),

        const SizedBox(height: TossSpacing.space10),

        // Submit Button
        Builder(
          builder: (context) {
            final tabState = ref.watch(cashTabProvider);
            return Center(
              child: TossButton1.primary(
                text: 'Save Cash Ending',
                isLoading: tabState.isSaving,
                isEnabled: !tabState.isSaving,
                fullWidth: false,
                onPressed: !tabState.isSaving
                    ? () async {
                        try {
                          await widget.onSave(context, state, selectedCurrencyId);
                        } catch (e) {
                          // Error handled by parent
                        }
                      }
                    : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                borderRadius: 12,
              ),
            );
          },
        ),
          ],
        ), // End of Column

        // Single shared keyboard toolbar - rendered separately in Stack
        if (_toolbarController != null)
          KeyboardToolbar1(
            controller: _toolbarController,
            showToolbar: true,
            // Callbacks will be evaluated when buttons are pressed
            onPrevious: () {
              final callback = _toolbarController!.focusPrevious;
              callback?.call();
            },
            onNext: () {
              final callback = _toolbarController!.focusNext;
              callback?.call();
            },
            onDone: () => _toolbarController!.unfocusAll(),
          ),
      ],
    ); // End of Stack
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
