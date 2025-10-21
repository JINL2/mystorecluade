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
import '../../providers/repository_providers.dart';
import '../denomination_input.dart';
import '../location_selector.dart';
import '../real_section_widget.dart';
import '../sheets/cash_ending_selection_helpers.dart';
import '../sheets/currency_selector_sheet.dart';
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

  // Stock flow data for Real section
  List<ActualFlow> _actualFlows = [];
  LocationSummary? _locationSummary;
  bool _isLoadingFlows = false;
  bool _hasMoreFlows = false;
  int _flowsOffset = 0;
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
          _loadStockFlows();
        }
      },
    );

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(cashEndingProvider);
      _previousLocationId = state.selectedVaultLocationId;

      if (state.selectedVaultLocationId != null &&
          state.selectedVaultLocationId!.isNotEmpty) {
        _loadStockFlows();
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
    // Dispose all focus nodes
    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        focusNode.dispose();
      }
    }
    // Dispose toolbar controller
    _toolbarController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VaultTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    final state = ref.read(cashEndingProvider);

    if (state.selectedVaultLocationId != _previousLocationId) {
      _previousLocationId = state.selectedVaultLocationId;
      _loadStockFlows();
    }
  }

  /// Load stock flows for the selected location
  Future<void> _loadStockFlows({bool loadMore = false}) async {
    final state = ref.read(cashEndingProvider);

    if (state.selectedVaultLocationId == null ||
        state.selectedVaultLocationId!.isEmpty ||
        state.selectedStoreId == null) {
      return;
    }

    if (_isLoadingFlows) return;

    setState(() {
      _isLoadingFlows = true;
      if (!loadMore) {
        _flowsOffset = 0;
        _actualFlows = [];
      }
    });

    try {
      final repository = ref.read(stockFlowRepositoryProvider);

      final result = await repository.getLocationStockFlow(
        companyId: widget.companyId,
        storeId: state.selectedStoreId!,
        cashLocationId: state.selectedVaultLocationId!,
        offset: _flowsOffset,
        limit: 20,
      );

      if (result.success) {
        setState(() {
          if (loadMore) {
            _actualFlows.addAll(result.actualFlows);
          } else {
            _actualFlows = result.actualFlows;
            _locationSummary = result.locationSummary;
          }
          _hasMoreFlows = result.pagination?.hasMore ?? false;
          _flowsOffset += result.actualFlows.length;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading stock flows: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFlows = false;
        });
      }
    }
  }

  void _loadMoreFlows() {
    _loadStockFlows(loadMore: true);
  }

  void reloadStockFlows() {
    _loadStockFlows();
  }

  void _showFlowDetails(ActualFlow flow) {
    debugPrint('Show details for flow: ${flow.flowId}');
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

          // Card 2: Vault Counting (show if location selected)
          if (state.selectedVaultLocationId != null &&
              state.selectedVaultLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space6),
            _buildVaultCountingCard(state),

            // Card 3: Real Section
            const SizedBox(height: TossSpacing.space6),
            RealSectionWidget(
              actualFlows: _actualFlows,
              locationSummary: _locationSummary,
              isLoading: _isLoadingFlows,
              hasMore: _hasMoreFlows,
              baseCurrencySymbol: state.currencies.isNotEmpty
                  ? state.currencies.first.symbol
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

          // Vault Location Selector (show if store selected)
          if (state.selectedStoreId != null) ...[
            const SizedBox(height: TossSpacing.space6),
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
      ),
    );
  }

  Widget _buildVaultCountingCard(CashEndingState state) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: _buildVaultCountingSection(state),
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

    final selectedCurrencyId =
        state.selectedVaultCurrencyId ?? state.currencies.first.currencyId;
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
        // Header: "Vault Count" title + Currency selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vault Count',
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
                    tabType: 'vault',
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
            final index = entry.key;
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

        // Debit/Credit Toggle (In/Out) - From legacy lines 1095-1117
        _buildDebitCreditToggle(),

        const SizedBox(height: TossSpacing.space8),

        // Total Display
        TotalDisplay(
          totalAmount:
              _calculateTotal(selectedCurrencyId, currency.denominations),
          currencySymbol: currency.symbol,
          label: _transactionType == 'debit' ? 'In Total' : 'Out Total',
        ),

        const SizedBox(height: TossSpacing.space10),

        // Submit Button
        Center(
          child: TossButton1.primary(
            text: 'Save Vault Transaction',
            isLoading: state.isSaving,
            isEnabled: !state.isSaving,
            fullWidth: false,
            onPressed: !state.isSaving
                ? () async {
                    await widget.onSave(
                      context,
                      state,
                      selectedCurrencyId,
                      _transactionType,
                    );
                  }
                : null,
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            borderRadius: 12,
          ),
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
            activeColor: TossColors.success,
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
