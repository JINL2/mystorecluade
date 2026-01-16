// lib/features/cash_ending/presentation/widgets/tabs/vault_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/monitoring/sentry_config.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../di/injection.dart';
import '../../../domain/entities/denomination.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/vault_recount.dart';
import '../../../domain/entities/vault_transaction_type.dart';
import '../../../domain/entities/multi_currency_recount.dart';
import '../../providers/cash_ending_provider.dart';
import '../../providers/cash_ending_state.dart';
import '../../providers/vault_tab_provider.dart';
import '../section_label.dart';
import '../store_selector.dart';
import '../../pages/cash_ending_completion_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Extracted widgets
import 'vault_tab/vault_tab_widgets.dart';

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

  // Transaction type using extracted enum
  VaultTransactionType _transactionType = VaultTransactionType.debit;

  String? _previousLocationId;
  int _previousResetCounter = 0;
  String? _expandedCurrencyId;
  String? _initializedToolbarCurrencyId;
  final Set<String> _initializedCurrencies = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

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
    // Clear toolbar controller's focus nodes list first to prevent double disposal
    // since those focus nodes are managed by _focusNodes map
    // Don't dispose _toolbarController here - just clear the reference
    if (_toolbarController != null) {
      _toolbarController!.focusNodes.clear();
      _toolbarController = null;
    }

    // Dispose all focus nodes from our map
    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        if (focusNode.canRequestFocus) {
          focusNode.dispose();
        }
      }
    }
    _focusNodes.clear();

    // Dispose all text controllers
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.dispose();
      }
    }
    _controllers.clear();

    super.dispose();
  }

  void _clearAllInputs() {
    for (final currencyControllers in _controllers.values) {
      for (final controller in currencyControllers.values) {
        controller.clear();
      }
    }
    setState(() {});
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

    final selectedIds = pageState.selectedVaultCurrencyIds.isEmpty && pageState.currencies.isNotEmpty
        ? [pageState.currencies.first.currencyId]
        : pageState.selectedVaultCurrencyIds;
    if (selectedIds.isNotEmpty) {
      setState(() {
        _expandedCurrencyId = selectedIds.first;
      });
    }
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
    // Clear previous controller's focus nodes list (don't dispose - we manage them)
    if (_toolbarController != null) {
      _toolbarController!.focusNodes.clear();
      _toolbarController = null;
    }

    _toolbarController = KeyboardToolbarController(
      fieldCount: denominations.length,
    );

    for (int i = 0; i < denominations.length; i++) {
      final denom = denominations[i];
      final ourFocusNode = _getFocusNode(currencyId, denom.denominationId);
      final defaultFocusNode = _toolbarController!.focusNodes[i];

      // Dispose the default focus node created by KeyboardToolbarController
      // only if it's different from our managed focus node
      if (defaultFocusNode != ourFocusNode) {
        defaultFocusNode.dispose();
      }

      _toolbarController!.focusNodes[i] = ourFocusNode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(cashEndingProvider);

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
          _buildLocationSelectionCard(pageState),

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
        StoreSelector(
          stores: state.stores,
          selectedStoreId: state.selectedStoreId,
          onChanged: (storeId) async {
            if (storeId != null) {
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

        if (state.selectedStoreId != null) ...[
          const SizedBox(height: TossSpacing.space4),
          VaultLocationSelector(
            vaultLocations: state.vaultLocations,
            selectedLocationId: state.selectedVaultLocationId,
            onLocationChanged: (locationId) {
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
    final selectedCurrencyIds = _getSelectedCurrencyIds(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Vault Transaction'),
        const SizedBox(height: TossSpacing.space2),
        VaultCountingSection(
          state: state,
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
            if (_toolbarController == null ||
                _toolbarController!.focusNodes.length != currency.denominations.length ||
                _initializedToolbarCurrencyId != currency.currencyId) {
              _initializeToolbarController(currency.denominations, currency.currencyId);
              _initializedToolbarCurrencyId = currency.currencyId;
            }
          },
          onStateChanged: () => setState(() {}),
          transactionType: _transactionType,
          onTransactionTypeChanged: (type) {
            setState(() {
              _transactionType = type;
            });
          },
          submitButton: VaultSubmitButton(
            state: state,
            selectedCurrencyIds: selectedCurrencyIds,
            transactionType: _transactionType,
            onRecountPressed: () => _showRecountSummary(context, state, selectedCurrencyIds),
            onSubmitPressed: () async {
              await widget.onSave(
                context,
                state,
                selectedCurrencyIds.first,
                _transactionType.stringValue,
              );
            },
          ),
        ),
      ],
    );
  }

  List<String> _getSelectedCurrencyIds(CashEndingState state) {
    if (state.selectedVaultCurrencyIds.isEmpty && state.currencies.isNotEmpty) {
      return [state.currencies.first.currencyId];
    }
    return state.selectedVaultCurrencyIds;
  }

  // Public getters for parent to access
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

  String get transactionType => _transactionType.stringValue;

  void clearQuantities() {
    setState(() {
      for (final currencyControllers in _controllers.values) {
        for (final controller in currencyControllers.values) {
          controller.clear();
        }
      }
      _transactionType = VaultTransactionType.debit;
    });
  }

  Future<void> _showRecountSummary(
    BuildContext context,
    CashEndingState state,
    List<String> selectedCurrencyIds,
  ) async {
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

      final denominationsWithQuantity = currency.denominations.map((denom) {
        final controller = quantities[denom.denominationId];
        final quantity = controller != null ? (int.tryParse(controller.text.trim()) ?? 0) : 0;

        if (quantity > 0) {
          currencyQuantities[denom.value.toString()] = quantity;
          // Apply exchange rate to convert to base currency
          grandTotal += denom.value * quantity * currency.exchangeRateToBase;
        }

        return denom.copyWith(quantity: quantity);
      }).toList();

      denominationQuantitiesMap[currencyId] = currencyQuantities;
      currenciesWithData.add(Currency(
        currencyId: currency.currencyId,
        currencyCode: currency.currencyCode,
        currencyName: currency.currencyName,
        symbol: currency.symbol,
        denominations: denominationsWithQuantity,
      ));
    }

    final vaultTabNotifier = ref.read(vaultTabProvider.notifier);

    try {
      final multiCurrencyRecount = _buildMultiCurrencyRecountEntity(
        state: state,
        currenciesWithData: currenciesWithData,
      );

      await vaultTabNotifier.executeMultiCurrencyRecount(multiCurrencyRecount);

      if (!mounted) return;

      await vaultTabNotifier.submitVaultEnding(
        locationId: state.selectedVaultLocationId!,
      );

      if (!mounted) return;

      final vaultTabState = ref.read(vaultTabProvider);
      final balanceSummary = vaultTabState.balanceSummary;

      if (!mounted || !context.mounted) return;

      final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
      final userId = getCurrentUserUseCase.executeOrNull() ?? '';

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CashEndingCompletionPage(
            tabType: 'cash',
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
            balanceSummary: balanceSummary,
            companyId: widget.companyId,
            userId: userId,
            cashLocationId: state.selectedVaultLocationId!,
            storeId: state.selectedStoreId,
          ),
        ),
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'VaultTab RECOUNT failed',
        extra: {
          'locationId': state.selectedVaultLocationId,
          'currencyCount': currenciesWithData.length,
        },
      );
      if (context.mounted) {
        TossToast.error(context, 'Failed to execute recount: $e');
      }
    }
  }

  MultiCurrencyRecount _buildMultiCurrencyRecountEntity({
    required CashEndingState state,
    required List<Currency> currenciesWithData,
  }) {
    final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
    final userId = getCurrentUserUseCase.execute();

    final timeProvider = ref.read(timeProviderProvider);
    final now = timeProvider.now();

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
