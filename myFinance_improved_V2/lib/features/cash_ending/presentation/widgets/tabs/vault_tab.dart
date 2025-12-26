// lib/features/cash_ending/presentation/widgets/tabs/vault_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/monitoring/sentry_config.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/keyboard_toolbar_1.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';
import '../../../../cash_location/presentation/pages/account_detail_page.dart';
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
    if (_toolbarController != null) {
      _toolbarController!.dispose();
      _toolbarController = null;
    }

    for (final currencyFocusNodes in _focusNodes.values) {
      for (final focusNode in currencyFocusNodes.values) {
        focusNode.dispose();
      }
    }
    _focusNodes.clear();

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

  void _ensureCurrencyInitialized(Currency currency) {
    if (_initializedCurrencies.contains(currency.currencyId)) {
      return;
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
    if (_toolbarController != null) {
      _toolbarController!.focusNodes.clear();
      _toolbarController!.dispose();
      _toolbarController = null;
    }

    _toolbarController = KeyboardToolbarController(
      fieldCount: denominations.length,
    );

    for (int i = 0; i < denominations.length; i++) {
      final denom = denominations[i];
      final ourFocusNode = _getFocusNode(currencyId, denom.denominationId);
      final defaultFocusNode = _toolbarController!.focusNodes[i];

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
                style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
              ),
            ],
          ),
        ),
      );
    }

    final selectedCurrencyIds = state.selectedVaultCurrencyIds.isEmpty
        ? [state.currencies.first.currencyId]
        : state.selectedVaultCurrencyIds;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DebitCreditToggle(
              selectedType: _transactionType,
              onTypeChanged: (type) {
                setState(() {
                  _transactionType = type;
                });
              },
            ),

            const SizedBox(height: TossSpacing.space5),

            CurrencyPillSelector(
              availableCurrencies: state.currencies,
              selectedCurrencyIds: selectedCurrencyIds,
              onAddCurrency: () {
                final availableCurrencies = state.currencies.where((c) =>
                  !state.selectedVaultCurrencyIds.contains(c.currencyId)
                ).toList();

                if (availableCurrencies.isEmpty) return;

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

            ...state.currencies.where((currency) {
              return selectedCurrencyIds.contains(currency.currencyId);
            }).map((currency) {
              _ensureCurrencyInitialized(currency);

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
                      if (_expandedCurrencyId == currencyId) {
                        _expandedCurrencyId = null;
                      } else {
                        _expandedCurrencyId = currencyId;
                      }
                    });

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

            ListenableBuilder(
              listenable: Listenable.merge(
                _controllers.values.expand((map) => map.values).toList(),
              ),
              builder: (context, _) {
                final grandTotal = _calculateGrandTotal(state);
                return GrandTotalSection(
                  totalAmount: grandTotal,
                  currencySymbol: state.baseCurrencySymbol,
                  label: 'Grand total ${state.baseCurrency?.currencyCode ?? ""}',
                  isBaseCurrency: true,
                  journalAmount: state.vaultLocationJournalAmount,
                  isLoadingJournal: state.isLoadingVaultJournalAmount,
                  onHistoryTap: state.selectedVaultLocationId != null
                      ? () => _navigateToAccountDetail(state, grandTotal)
                      : null,
                );
              },
            ),

            const SizedBox(height: TossSpacing.space2),

            _buildSubmitButton(state, selectedCurrencyIds),
          ],
        ),

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

  Widget _buildSubmitButton(CashEndingState state, List<String> selectedCurrencyIds) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Builder(
        builder: (context) {
          final tabState = ref.watch(vaultTabProvider);
          final firstCurrencyId = selectedCurrencyIds.first;

          if (_transactionType == VaultTransactionType.recount) {
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

          return TossButton1.primary(
            text: 'Submit Ending',
            isLoading: tabState.isSaving,
            isEnabled: !tabState.isSaving,
            fullWidth: true,
            onPressed: !tabState.isSaving
                ? () async {
                    await widget.onSave(
                      context,
                      state,
                      firstCurrencyId,
                      _transactionType.stringValue,
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
    );
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
          grandTotal += denom.value * quantity;
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

      await vaultTabNotifier.submitVaultEnding(
        locationId: state.selectedVaultLocationId!,
      );

      final vaultTabState = ref.read(vaultTabProvider);
      final balanceSummary = vaultTabState.balanceSummary;

      if (!context.mounted) return;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to execute recount: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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

  double _calculateGrandTotal(CashEndingState state) {
    double grandTotal = 0.0;

    for (final currency in state.currencies) {
      final currencyControllers = _controllers[currency.currencyId];
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

  void _navigateToAccountDetail(CashEndingState state, double grandTotal) {
    if (state.selectedVaultLocationId == null) return;

    final selectedLocation = state.vaultLocations.firstWhere(
      (loc) => loc.locationId == state.selectedVaultLocationId,
      orElse: () => state.vaultLocations.first,
    );

    final journalAmount = state.vaultLocationJournalAmount ?? 0.0;
    final difference = grandTotal - journalAmount;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailPage(
          locationId: state.selectedVaultLocationId,
          accountName: selectedLocation.locationName,
          locationType: 'vault',
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
