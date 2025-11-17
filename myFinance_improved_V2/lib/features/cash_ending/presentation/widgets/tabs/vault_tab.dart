// lib/features/cash_ending/presentation/widgets/tabs/vault_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
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
import '../../providers/vault_tab_provider.dart';
import '../collapsible_currency_section.dart';
import '../currency_pill_selector.dart';
import '../denomination_grid_header.dart';
import '../denomination_input.dart';
import '../location_selector.dart';
import '../real_section_widget.dart';
import '../section_label.dart';
import '../sheets/cash_ending_selection_helpers.dart';
import '../sheets/currency_selector_sheet.dart';
import '../sheets/flow_detail_bottom_sheet.dart';
import '../store_selector.dart';
import '../total_display.dart';

/// Vault Tab - Denomination-based counting with Debit/Credit (In/Out)
///
/// Structure from legacy:
/// - Card 1: Store + Location selection
/// - Card 2: Denomination inputs + Debit/Credit toggle + Total + Submit
///
/// Key difference from Cash: Has Debit/Credit toggle (In/Out transaction type)
class VaultTab extends ConsumerStatefulWidget {
  final String companyId;
  final Function(BuildContext, CashEndingState, String, String) onSave;

  const VaultTab({
    super.key,
    required this.companyId,
    required this.onSave,
  });

  @override
  ConsumerState<VaultTab> createState() => _VaultTabState();
}

class _VaultTabState extends ConsumerState<VaultTab> {
  // Store TextEditingControllers for each denomination
  final Map<String, Map<String, TextEditingController>> _controllers = {};

  // Store FocusNodes for each denomination (for keyboard toolbar)
  final Map<String, Map<String, FocusNode>> _focusNodes = {};

  // Keyboard toolbar controller
  KeyboardToolbarController? _toolbarController;

  // Transaction type: 'debit' (In) or 'credit' (Out)
  String _transactionType = 'debit'; // Default to 'In'

  String? _previousLocationId;

  @override
  void initState() {
    super.initState();

    // Listen for location changes
    ref.listenManual(
      cashEndingProvider.select((state) => state.selectedVaultLocationId),
      (previous, next) {
        if (next != null && next.isNotEmpty && next != previous) {
          _previousLocationId = next;
          _loadStockFlowsFromProvider(next);
        }
      },
    );

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pageState = ref.read(cashEndingProvider);
      _previousLocationId = pageState.selectedVaultLocationId;

      if (pageState.selectedVaultLocationId != null &&
          pageState.selectedVaultLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedVaultLocationId!);
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
  void didUpdateWidget(VaultTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedVaultLocationId != _previousLocationId) {
      _previousLocationId = pageState.selectedVaultLocationId;
      if (pageState.selectedVaultLocationId != null &&
          pageState.selectedVaultLocationId!.isNotEmpty) {
        _loadStockFlowsFromProvider(pageState.selectedVaultLocationId!);
      }
    }
  }

  /// Load stock flows via provider
  void _loadStockFlowsFromProvider(String locationId) {
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedStoreId == null || pageState.selectedStoreId!.isEmpty) {
      return;
    }

    ref.read(vaultTabProvider.notifier).loadStockFlows(
      companyId: widget.companyId,
      storeId: pageState.selectedStoreId!,
      locationId: locationId,
    );
  }

  /// Load more flows for pagination
  void _loadMoreFlows() {
    final pageState = ref.read(cashEndingProvider);

    if (pageState.selectedVaultLocationId == null ||
        pageState.selectedStoreId == null) {
      return;
    }

    ref.read(vaultTabProvider.notifier).loadStockFlows(
      companyId: widget.companyId,
      storeId: pageState.selectedStoreId!,
      locationId: pageState.selectedVaultLocationId!,
      loadMore: true,
    );
  }

  void _showFlowDetails(ActualFlow flow) {
    final pageState = ref.read(cashEndingProvider);
    final tabState = ref.read(vaultTabProvider);
    FlowDetailBottomSheet.show(
      context: context,
      flow: flow,
      locationSummary: tabState.locationSummary,
      baseCurrencySymbol: pageState.currencies.isNotEmpty
          ? pageState.currencies.first.symbol
          : '\$',
    );
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

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(cashEndingProvider);
    final tabState = ref.watch(vaultTabProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card 1: Store and Location Selection
          _buildLocationSelectionCard(pageState),

          // Card 2: Vault Counting (show if location selected)
          if (pageState.selectedVaultLocationId != null &&
              pageState.selectedVaultLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space6),
            _buildVaultCountingCard(pageState),
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

        // Vault Location Selector (show if store selected)
        if (state.selectedStoreId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          LocationSelector(
            locationType: 'vault',
            isLoading: false,
            locations: state.vaultLocations,
            selectedLocationId: state.selectedVaultLocationId,
            onTap: () {
              CashEndingSelectionHelpers.showLocationSelector(
                context: context,
                ref: ref,
                locationType: 'vault',
                locations: state.vaultLocations,
                selectedLocationId: state.selectedVaultLocationId,
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildVaultCountingCard(CashEndingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Vault Transaction'),
        const SizedBox(height: TossSpacing.space2),
        _buildVaultCountingSection(state),
      ],
    );
  }

  Widget _buildVaultCountingSection(CashEndingState state) {
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

    // Get selected currencies (support multiple like cash tab)
    final selectedCurrencyIds = state.selectedVaultCurrencyIds.isEmpty
        ? [state.currencies.first.currencyId]
        : state.selectedVaultCurrencyIds;

    // Wrap in Stack to render toolbar separately from Column
    return Stack(
      children: [
        // Main content in Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        // Transaction Type Toggle
        _buildDebitCreditToggle(),

        const SizedBox(height: TossSpacing.space5),

        // Currency Pills
        CurrencyPillSelector(
          availableCurrencies: state.currencies,
          selectedCurrencyIds: selectedCurrencyIds,
          onAddCurrency: () {
            // Show only currencies not already selected
            final availableCurrencies = state.currencies.where((c) =>
              !state.selectedVaultCurrencyIds.contains(c.currencyId)
            ).toList();

            if (availableCurrencies.isEmpty) {
              return; // All currencies already added
            }

            CurrencySelectorSheet.show(
              context: context,
              ref: ref,
              currencies: availableCurrencies,
              selectedCurrencyId: null,
              tabType: 'vault',
            );
          },
          onRemoveCurrency: (currencyId) {
            ref.read(cashEndingProvider.notifier).removeVaultCurrency(currencyId);
          },
        ),

        const SizedBox(height: TossSpacing.space5),

        // Currency accordion sections - show all selected currencies
        ...state.currencies.where((currency) {
          return selectedCurrencyIds.contains(currency.currencyId);
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
            if (_toolbarController == null ||
                _toolbarController!.focusNodes.length != currency.denominations.length) {
              _initializeToolbarController(currency.denominations, currency.currencyId);
            }
          });

          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space4),
            child: CollapsibleCurrencySection(
              currency: currency,
              controllers: _controllers[currency.currencyId]!,
              focusNodes: _focusNodes[currency.currencyId]!,
              totalAmount: _calculateTotal(currency.currencyId, currency.denominations),
              onChanged: () => setState(() {}),
            ),
          );
        }),

        const SizedBox(height: TossSpacing.space6),

        // Submit Button
        Builder(
          builder: (context) {
            final tabState = ref.watch(vaultTabProvider);
            final firstCurrencyId = selectedCurrencyIds.first;
            return TossButton1.primary(
              text: 'Save Vault Transaction',
              isLoading: tabState.isSaving,
              isEnabled: !tabState.isSaving,
              fullWidth: true,
              onPressed: !tabState.isSaving
                  ? () async {
                      await widget.onSave(
                        context,
                        state,
                        firstCurrencyId,
                        _transactionType,
                      );
                    }
                  : null,
              textStyle: TossTextStyles.titleLarge.copyWith(
                color: TossColors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              borderRadius: 12,
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

  /// Debit/Credit toggle widget (from legacy lines 1095-1117)
  Widget _buildDebitCreditToggle() {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            label: 'In',
            value: 'debit',
            isSelected: _transactionType == 'debit',
            activeColor: TossColors.primary,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: _buildToggleButton(
            label: 'Out',
            value: 'credit',
            isSelected: _transactionType == 'credit',
            activeColor: TossColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required String value,
    required bool isSelected,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _transactionType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? activeColor : TossColors.gray200,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? TossColors.white : TossColors.gray600,
            ),
          ),
        ),
      ),
    );
  }

  // Expose quantities and transaction type for parent to access
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

  String get transactionType => _transactionType;

  void clearQuantities() {
    setState(() {
      for (final currencyControllers in _controllers.values) {
        for (final controller in currencyControllers.values) {
          controller.clear();
        }
      }
      _transactionType = 'debit'; // Reset to default
    });
  }
}
