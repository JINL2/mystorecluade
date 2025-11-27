// lib/features/cash_ending/presentation/widgets/tabs/vault_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_icons.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/keyboard_toolbar_1.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../di/injection.dart';
import '../../../domain/entities/denomination.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/vault_recount.dart';
import '../../../domain/entities/multi_currency_recount.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/vault_tab_provider.dart';
import '../collapsible_currency_section.dart';
import '../currency_pill_selector.dart';
import '../grand_total_section.dart';
import '../section_label.dart';
import '../sheets/currency_selector_sheet.dart';
import '../store_selector.dart';
import '../../pages/cash_ending_completion_page.dart';

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

  // Track previous resetInputsCounter to detect changes
  int _previousResetCounter = 0;

  // Track which currency is currently expanded (accordion behavior)
  String? _expandedCurrencyId;

  // Track which currency's toolbar has been initialized
  String? _initializedToolbarCurrencyId;

  // Track which currencies have been initialized (avoid re-initialization in build)
  final Set<String> _initializedCurrencies = {};

  @override
  void initState() {
    super.initState();

    // Reset vault tab state to clear any previous isSaving/error state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Reset to ensure clean state
      ref.read(vaultTabProvider.notifier).reset();

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
    // 1. Dispose toolbar controller FIRST (releases focus node references)
    //    This prevents accessing disposed focus nodes during cleanup
    if (_toolbarController != null) {
      _toolbarController!.dispose();
      _toolbarController = null;
    }

    // 2. Dispose all focus nodes
    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        focusNode.dispose();
      }
    }
    _focusNodes.clear();

    // 3. Dispose all text editing controllers
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.dispose();
      }
    }
    _controllers.clear();

    super.dispose();
  }

  /// Clear all denomination input fields
  void _clearAllInputs() {
    debugPrint('🧹 [VaultTab] Clearing all input fields');
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
  void didUpdateWidget(VaultTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;

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

    // Auto-expand first currency when location is selected
    final selectedIds = pageState.selectedVaultCurrencyIds.isEmpty && pageState.currencies.isNotEmpty
        ? [pageState.currencies.first.currencyId]
        : pageState.selectedVaultCurrencyIds;
    if (selectedIds.isNotEmpty) {
      setState(() {
        _expandedCurrencyId = selectedIds.first;
      });
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

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(cashEndingProvider);
    final tabState = ref.watch(vaultTabProvider);

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
          onChanged: (storeId) async {
            if (storeId != null) {
              await ref.read(cashEndingProvider.notifier).selectStore(
                storeId,
                widget.companyId,
              );
            }
          },
        ),

        // Vault Location Selector (show if store selected)
        if (state.selectedStoreId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          if (state.vaultLocations.isEmpty)
            // Show disabled state when no vault locations available
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TossColors.gray300, width: 1),
              ),
              child: Row(
                children: [
                  Icon(TossIcons.lock, size: 20, color: TossColors.gray400),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vault Location',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'No vault locations available',
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
            TossDropdown<String>(
              label: 'Vault Location',
              hint: 'Select Vault Location',
              value: state.selectedVaultLocationId,
              isLoading: false,
              items: state.vaultLocations.map((location) =>
                TossDropdownItem<String>(
                  value: location.locationId,
                  label: location.locationName,
                )
              ).toList(),
              onChanged: (locationId) {
                if (locationId != null) {
                  ref.read(cashEndingProvider.notifier).setSelectedVaultLocation(locationId);
                }
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
          // Initialize controllers and focus nodes ONCE per currency
          _ensureCurrencyInitialized(currency);

          // Capture currency info in local variables to avoid closure issues
          final currencyId = currency.currencyId;
          final denominations = currency.denominations;

          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space4),
            child: CollapsibleCurrencySection(
              currency: currency,
              controllers: _controllers[currencyId]!,
              focusNodes: _focusNodes[currencyId]!,
              totalAmount: _calculateCurrencySubtotal(
                currency.currencyId,
                currency.denominations,
              ),
              onChanged: () => setState(() {}),
              isExpanded: _expandedCurrencyId == currencyId,
              baseCurrencySymbol: state.baseCurrencySymbol,
              onToggle: () {
                final willBeExpanded = _expandedCurrencyId != currencyId;

                setState(() {
                  // Toggle: if this currency is expanded, collapse it; otherwise expand it
                  if (_expandedCurrencyId == currencyId) {
                    _expandedCurrencyId = null;
                  } else {
                    _expandedCurrencyId = currencyId;
                  }
                });

                // Initialize toolbar controller when expanding this currency (outside setState)
                if (willBeExpanded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;

                    if (_toolbarController == null ||
                        _toolbarController!.focusNodes.length != denominations.length ||
                        _initializedToolbarCurrencyId != currencyId) {
                      _initializeToolbarController(denominations, currencyId);
                      _initializedToolbarCurrencyId = currencyId;
                    }
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
            );
          },
        ),

        const SizedBox(height: TossSpacing.space2),

        // Submit Button
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Builder(
            builder: (context) {
              final tabState = ref.watch(vaultTabProvider);
              final firstCurrencyId = selectedCurrencyIds.first;

              // Show recount summary if "Recount" is selected
              if (_transactionType == 'recount') {
                return TossButton1.primary(
                  text: 'Show Recount Summary',
                  isLoading: false,
                  isEnabled: true,
                  fullWidth: true,
                  onPressed: () {
                    _showRecountSummary(context, state, selectedCurrencyIds);
                  },
                  textStyle: TossTextStyles.titleLarge.copyWith(
                    color: TossColors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  borderRadius: 12,
                );
              }

              // Normal save button for In/Out
              return TossButton1.primary(
                text: 'Submit Ending',
                isLoading: tabState.isSaving,
                isEnabled: !tabState.isSaving,
                fullWidth: true,
                onPressed: !tabState.isSaving
                    ? () async {
                        debugPrint('═══════════════════════════════════════════════════════');
                        debugPrint('🚀 [VaultTab] Submit Ending 버튼 클릭!');
                        debugPrint('📋 [VaultTab] transactionType: $_transactionType');
                        debugPrint('💰 [VaultTab] currencyId: $firstCurrencyId');
                        debugPrint('📊 [VaultTab] Quantities: ${denominationQuantities}');
                        debugPrint('═══════════════════════════════════════════════════════');

                        await widget.onSave(
                          context,
                          state,
                          firstCurrencyId,
                          _transactionType,
                        );

                        debugPrint('✅ [VaultTab] onSave 콜백 완료');
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
          child: _transactionType == 'debit'
              ? TossButton1.outlined(
                  text: 'In',
                  leadingIcon: const Icon(LucideIcons.arrowDownCircle, size: 20),
                  onPressed: () {
                    debugPrint('🔵 [VaultTab] In 버튼 클릭 - transactionType: debit');
                    setState(() {
                      _transactionType = 'debit';
                    });
                    debugPrint('🔵 [VaultTab] State 업데이트 완료 - _transactionType: $_transactionType');
                  },
                  fullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  borderRadius: TossBorderRadius.lg,
                )
              : TossButton1.outlinedGray(
                  text: 'In',
                  leadingIcon: const Icon(LucideIcons.arrowDownCircle, size: 20),
                  onPressed: () {
                    debugPrint('🔵 [VaultTab] In 버튼 클릭 - transactionType: debit');
                    setState(() {
                      _transactionType = 'debit';
                    });
                    debugPrint('🔵 [VaultTab] State 업데이트 완료 - _transactionType: $_transactionType');
                  },
                  fullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  borderRadius: TossBorderRadius.lg,
                ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: _transactionType == 'credit'
              ? TossButton1.outlined(
                  text: 'Out',
                  leadingIcon: const Icon(LucideIcons.arrowUpCircle, size: 20),
                  onPressed: () {
                    debugPrint('🟠 [VaultTab] Out 버튼 클릭 - transactionType: credit');
                    setState(() {
                      _transactionType = 'credit';
                    });
                    debugPrint('🟠 [VaultTab] State 업데이트 완료 - _transactionType: $_transactionType');
                  },
                  fullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  borderRadius: TossBorderRadius.lg,
                )
              : TossButton1.outlinedGray(
                  text: 'Out',
                  leadingIcon: const Icon(LucideIcons.arrowUpCircle, size: 20),
                  onPressed: () {
                    debugPrint('🟠 [VaultTab] Out 버튼 클릭 - transactionType: credit');
                    setState(() {
                      _transactionType = 'credit';
                    });
                    debugPrint('🟠 [VaultTab] State 업데이트 완료 - _transactionType: $_transactionType');
                  },
                  fullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  borderRadius: TossBorderRadius.lg,
                ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: _transactionType == 'recount'
              ? TossButton1.outlined(
                  text: 'Recount',
                  leadingIcon: const Icon(LucideIcons.refreshCw, size: 20),
                  onPressed: () {
                    debugPrint('🟢 [VaultTab] Recount 버튼 클릭 - transactionType: recount');
                    setState(() {
                      _transactionType = 'recount';
                    });
                    debugPrint('🟢 [VaultTab] State 업데이트 완료 - _transactionType: $_transactionType');
                  },
                  fullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  borderRadius: TossBorderRadius.lg,
                )
              : TossButton1.outlinedGray(
                  text: 'Recount',
                  leadingIcon: const Icon(LucideIcons.refreshCw, size: 20),
                  onPressed: () {
                    debugPrint('🟢 [VaultTab] Recount 버튼 클릭 - transactionType: recount');
                    setState(() {
                      _transactionType = 'recount';
                    });
                    debugPrint('🟢 [VaultTab] State 업데이트 완료 - _transactionType: $_transactionType');
                  },
                  fullWidth: true,
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  borderRadius: TossBorderRadius.lg,
                ),
        ),
      ],
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

  /// Show recount summary page
  Future<void> _showRecountSummary(
    BuildContext context,
    CashEndingState state,
    List<String> selectedCurrencyIds,
  ) async {
    // Calculate grand total and build denomination quantities map
    double grandTotal = 0.0;
    final Map<String, Map<String, int>> denominationQuantitiesMap = {};
    final List<Currency> currenciesWithData = [];

    for (final currencyId in selectedCurrencyIds) {
      final currency = state.currencies.firstWhere(
        (c) => c.currencyId == currencyId,
        orElse: () => state.currencies.first,
      );

      final quantities = _controllers[currencyId] ?? {};
      final currencyQuantities = <String, int>{};

      // Create denominations with quantities
      final denominationsWithQuantity = currency.denominations.map((denom) {
        final controller = quantities[denom.denominationId];
        final quantity = controller != null ? (int.tryParse(controller.text.trim()) ?? 0) : 0;

        if (quantity > 0) {
          currencyQuantities[denom.value.toString()] = quantity;
          grandTotal += denom.value * quantity;
        }

        return denom.copyWith(quantity: quantity);
      }).toList();

      // Only add currency if it has quantities
      if (currencyQuantities.isNotEmpty) {
        denominationQuantitiesMap[currencyId] = currencyQuantities;
        currenciesWithData.add(Currency(
          currencyId: currency.currencyId,
          currencyCode: currency.currencyCode,
          currencyName: currency.currencyName,
          symbol: currency.symbol,
          denominations: denominationsWithQuantity,
        ));
      }
    }

    // ✅ Execute Multi-Currency RECOUNT (ALL currencies in ONE RPC call)
    final vaultTabNotifier = ref.read(vaultTabProvider.notifier);

    try {
      debugPrint('═══════════════════════════════════════════════════════');
      debugPrint('🔄 [VaultTab] Executing Multi-Currency RECOUNT');
      debugPrint('   - Location: ${state.selectedVaultLocationId}');
      debugPrint('   - Total Currencies: ${currenciesWithData.length}');

      for (final curr in currenciesWithData) {
        final total = curr.denominations.fold(
          0.0,
          (sum, d) => sum + (d.value * d.quantity),
        );
        debugPrint('   - ${curr.currencyCode}: ${curr.symbol}$total (${curr.denominations.where((d) => d.quantity > 0).length} denoms)');
      }
      debugPrint('═══════════════════════════════════════════════════════');

      // Build multi-currency recount entity
      final multiCurrencyRecount = _buildMultiCurrencyRecountEntity(
        state: state,
        currenciesWithData: currenciesWithData,
      );

      debugPrint('🚀 [VaultTab] Calling insert_amount_multi_currency RPC...');
      // Execute RECOUNT RPC (single call for all currencies)
      await vaultTabNotifier.executeMultiCurrencyRecount(multiCurrencyRecount);
      debugPrint('✅ [VaultTab] RECOUNT RPC complete!');

      // After recount, fetch balance summary
      debugPrint('📊 [VaultTab] Fetching balance summary...');
      await vaultTabNotifier.submitVaultEnding(
        locationId: state.selectedVaultLocationId!,
      );

      // Get the balance summary from state
      final vaultTabState = ref.read(vaultTabProvider);
      final balanceSummary = vaultTabState.balanceSummary;

      if (!context.mounted) return;

      // ✅ Get userId via UseCase (Clean Architecture compliant)
      final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
      final userId = getCurrentUserUseCase.executeOrNull() ?? '';

      // Navigate to completion page with recount data
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CashEndingCompletionPage(
            tabType: 'cash', // Use 'cash' to show currency breakdown
            grandTotal: grandTotal,
            currencies: currenciesWithData,
            storeName: state.stores
                .firstWhere((s) => s.storeId == state.selectedStoreId)
                .storeName,
            locationName: state.vaultLocations
                .firstWhere((l) => l.locationId == state.selectedVaultLocationId)
                .locationName,
            denominationQuantities: denominationQuantitiesMap,
            transactionType: 'recount',
            balanceSummary: balanceSummary, // ✅ Add balance summary
            companyId: widget.companyId,
            userId: userId,
            cashLocationId: state.selectedVaultLocationId!,
            storeId: state.selectedStoreId,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ [VaultTab] RECOUNT 에러: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to execute recount: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Calculate currency subtotal from controller values
  /// This reads the actual user input for a specific currency
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

  /// Build multi-currency recount entity
  ///
  /// ✅ Clean Architecture compliant - creates domain entity instead of Map
  MultiCurrencyRecount _buildMultiCurrencyRecountEntity({
    required CashEndingState state,
    required List<Currency> currenciesWithData,
  }) {
    // ✅ Get user ID via UseCase (Clean Architecture compliant)
    final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
    final userId = getCurrentUserUseCase.execute(); // Will throw if not authenticated

    // ✅ Get current time via TimeProvider (testable)
    final timeProvider = ref.read(timeProviderProvider);
    final now = timeProvider.now();

    // Build VaultRecount entities for each currency
    final currencyRecounts = currenciesWithData.map((currency) {
      return VaultRecount(
        companyId: widget.companyId,
        storeId: state.selectedStoreId == 'headquarter' ? null : state.selectedStoreId,
        locationId: state.selectedVaultLocationId!,
        currencyId: currency.currencyId,
        userId: userId,
        recordDate: now,
        createdAt: now,
        denominations: currency.denominations
            .where((d) => d.quantity > 0)
            .toList(),
      );
    }).toList();

    // Create MultiCurrencyRecount entity
    return MultiCurrencyRecount(
      companyId: widget.companyId,
      storeId: state.selectedStoreId == 'headquarter' ? null : state.selectedStoreId,
      locationId: state.selectedVaultLocationId!,
      userId: userId,
      recordDate: now,
      currencyRecounts: currencyRecounts,
    );
  }
}
