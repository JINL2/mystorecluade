// lib/features/cash_ending/presentation/pages/cash_ending_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/ai_chat/ai_chat_fab.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../../homepage/domain/entities/top_feature.dart';
import '../../domain/entities/bank_balance.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/entities/vault_transaction.dart';
import '../../domain/entities/vault_recount.dart';
import '../providers/cash_ending_provider.dart';
import '../providers/cash_ending_state.dart';
import '../providers/cash_tab_provider.dart';
import '../providers/bank_tab_provider.dart';
import '../providers/vault_tab_provider.dart';
import '../widgets/tabs/bank_tab.dart';
import '../widgets/tabs/cash_tab.dart';
import '../widgets/tabs/vault_tab.dart';
import 'cash_ending_completion_page.dart';

/// Cash Ending Page
///
/// Main page with 3 tabs based on legacy structure:
/// - Cash Tab: Denomination-based counting
/// - Bank Tab: Single amount input (no denominations)
/// - Vault Tab: Denomination-based with In/Out toggle
class CashEndingPage extends ConsumerStatefulWidget {
  final dynamic feature;

  const CashEndingPage({super.key, this.feature});

  @override
  ConsumerState<CashEndingPage> createState() => _CashEndingPageState();
}

class _CashEndingPageState extends ConsumerState<CashEndingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ConsumerState<CashTab>> _cashTabKey = GlobalKey();
  final GlobalKey<ConsumerState<BankTab>> _bankTabKey = GlobalKey();
  final GlobalKey<ConsumerState<VaultTab>> _vaultTabKey = GlobalKey();

  // Feature info extracted once
  String? _featureName;
  String? _featureId;
  bool _featureInfoExtracted = false;

  // AI Chat session ID - persists while page is active
  late final String _aiChatSessionId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Generate AI Chat session ID
    _aiChatSessionId = const Uuid().v4();

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Unfocus to close keyboard when switching tabs
        FocusScope.of(context).unfocus();

        ref
            .read(cashEndingProvider.notifier)
            .setCurrentTab(_tabController.index);
      }
    });

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isNotEmpty) {
        ref.read(cashEndingProvider.notifier).loadStores(companyId);
        ref.read(cashEndingProvider.notifier).loadCurrencies(companyId);

        // Auto-select store from AppState (like lib_old)
        if (storeId.isNotEmpty) {
          ref.read(cashEndingProvider.notifier).selectStore(storeId, companyId);
        }
      }

      // Extract feature info for AI Chat
      _extractFeatureInfo();
    });
  }

  /// Extract feature name and ID from widget.feature (once)
  void _extractFeatureInfo() {
    if (_featureInfoExtracted) return;
    _featureInfoExtracted = true;

    if (widget.feature == null) {
      _featureName = 'Cash Ending';
      debugPrint('[CashEnding] ⚠️  No feature provided - AI Chat will not have feature_id');
      return;
    }

    try {
      if (widget.feature is TopFeature) {
        final topFeature = widget.feature as TopFeature;
        _featureName = topFeature.featureName;
        _featureId = topFeature.featureId;
        debugPrint('[CashEnding] ✅ TopFeature extracted: $_featureName (ID: $_featureId)');
      } else if (widget.feature is Feature) {
        final feature = widget.feature as Feature;
        _featureName = feature.featureName;
        _featureId = feature.featureId;
        debugPrint('[CashEnding] ✅ Feature extracted: $_featureName (ID: $_featureId)');
      } else if (widget.feature is Map<String, dynamic>) {
        final featureMap = widget.feature as Map<String, dynamic>;
        _featureName = featureMap['feature_name'] as String? ?? featureMap['featureName'] as String?;
        _featureId = featureMap['feature_id'] as String? ?? featureMap['featureId'] as String?;
        debugPrint('[CashEnding] ✅ Map extracted: $_featureName (ID: $_featureId)');
      } else {
        debugPrint('[CashEnding] ⚠️  Unknown feature type: ${widget.feature.runtimeType}');
      }
    } catch (e) {
      debugPrint('[CashEnding] ❌ Error extracting feature: $e');
      _featureName = 'Cash Ending';
    }

    _featureName ??= 'Cash Ending';

    if (_featureId == null) {
      debugPrint('[CashEnding] ⚠️  Feature ID is null - AI Chat will not work properly');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Type-safe getter for cash tab denomination quantities
  /// Avoids unsafe dynamic casting
  Map<String, Map<String, int>> _getCashTabQuantities() {
    final state = _cashTabKey.currentState;
    if (state != null && state.mounted) {
      // Access the public getter - state is always _CashTabState here
      return (state as dynamic).denominationQuantities as Map<String, Map<String, int>>? ?? {};
    }
    return {};
  }

  /// Type-safe getter for bank tab amount
  String _getBankTabAmount() {
    final state = _bankTabKey.currentState;
    if (state != null && state.mounted) {
      return (state as dynamic).bankAmount as String? ?? '0';
    }
    return '0';
  }

  /// Type-safe getter for vault tab denomination quantities
  Map<String, Map<String, int>> _getVaultTabQuantities() {
    final state = _vaultTabKey.currentState;
    if (state != null && state.mounted) {
      return (state as dynamic).denominationQuantities as Map<String, Map<String, int>>? ?? {};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final companyId = ref.read(appStateProvider).companyChoosen;
    final state = ref.watch(cashEndingProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar1(
        title: 'Cash Ending',
        backgroundColor: TossColors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: TossColors.white,
            child: TossTabBar1(
              tabs: const ['Cash', 'Bank', 'Vault'],
              controller: _tabController,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CashTab(
            key: _cashTabKey,
            companyId: companyId,
            onSave: _saveCashEnding,
          ),
          BankTab(
            key: _bankTabKey,
            companyId: companyId,
            onSave: _saveBankBalance,
          ),
          VaultTab(
            key: _vaultTabKey,
            companyId: companyId,
            onSave: _saveVaultTransaction,
          ),
        ],
      ),
      floatingActionButton: AiChatFab(
        featureName: _featureName ?? 'Cash Ending',
        sessionId: _aiChatSessionId,
        pageContext: _buildPageContext(state),
        featureId: _featureId,
      ),
    );
  }

  /// Build page context for AI Chat
  ///
  /// Returns clean JSON structure for Edge Function:
  /// {
  ///   "store_id": "uuid" | null,
  ///   "cash_location_id": "uuid" | null,
  ///   "location_type": "cash" | "bank" | "vault"
  /// }
  Map<String, dynamic> _buildPageContext(CashEndingState state) {
    // Determine location type based on current tab
    final locationTypes = ['cash', 'bank', 'vault'];
    final locationType = _tabController.index < locationTypes.length
        ? locationTypes[_tabController.index]
        : 'cash';

    // Get current location ID based on tab
    String? cashLocationId;
    if (_tabController.index == 0) {
      cashLocationId = state.selectedCashLocationId;
    } else if (_tabController.index == 1) {
      cashLocationId = state.selectedBankLocationId;
    } else if (_tabController.index == 2) {
      cashLocationId = state.selectedVaultLocationId;
    }

    // Build clean context (only non-null values)
    final context = <String, dynamic>{
      'location_type': locationType,
    };

    // Add store_id if selected
    if (state.selectedStoreId != null) {
      context['store_id'] = state.selectedStoreId;
    }

    // Add cash_location_id if selected
    if (cashLocationId != null) {
      context['cash_location_id'] = cashLocationId;
    }

    debugPrint('[CashEnding] Context for AI: $context');
    return context;
  }

  /// Save Cash Ending (from legacy cash_service.dart)
  Future<void> _saveCashEnding(
    BuildContext context,
    CashEndingState state,
    String currencyId,
  ) async {

    // Validation
    if (state.selectedCashLocationId == null) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a cash location',
      );
      return;
    }

    final companyId = ref.read(appStateProvider).companyChoosen;
    final userId = ref.read(appStateProvider).user['user_id']?.toString() ?? '';


    if (companyId.isEmpty || userId.isEmpty) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Invalid company or user',
      );
      return;
    }

    // Get quantities from widget using type-safe getter
    final allQuantities = _getCashTabQuantities();

    // Validate currencies list is not empty
    if (state.currencies.isEmpty) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'No currencies available. Please reload the page.',
      );
      return;
    }

    // Process ALL selected currencies (fallback to currencyId parameter if selectedCashCurrencyIds is empty)
    final currencyIdsToProcess = state.selectedCashCurrencyIds.isNotEmpty
        ? state.selectedCashCurrencyIds
        : [currencyId];

    final currenciesWithData = currencyIdsToProcess.map((currId) {
      final currency = state.currencies.firstWhere(
        (c) => c.currencyId == currId,
        orElse: () => state.currencies.first,
      );

      final quantities = allQuantities[currId] ?? {};

      final denominationsWithQuantity = currency.denominations.map((denom) {
        final quantity = quantities[denom.denominationId] ?? 0;
        return denom.copyWith(quantity: quantity);
      }).toList();

      return Currency(
        currencyId: currency.currencyId,
        currencyCode: currency.currencyCode,
        currencyName: currency.currencyName,
        symbol: currency.symbol,
        denominations: denominationsWithQuantity,
        exchangeRateToBase: currency.exchangeRateToBase,
        isBaseCurrency: currency.isBaseCurrency,
      );
    }).toList();

    // Create CashEnding entity
    final now = DateTime.now();
    final cashEnding = CashEnding(
      companyId: companyId,
      locationId: state.selectedCashLocationId!,
      storeId: state.selectedStoreId,
      userId: userId,
      recordDate: now,
      createdAt: now,
      currencies: currenciesWithData,
    );

    // Save via CashTabProvider
    final success = await ref.read(cashTabProvider.notifier).saveCashEnding(cashEnding);

    if (!mounted) {
      return;
    }

    if (success) {
      // Calculate grand total across all currencies (converted to base currency)
      double grandTotal = 0.0;
      final Map<String, Map<String, int>> denominationQuantitiesMap = {};

      for (final currencyData in currenciesWithData) {
        // Calculate total for this currency
        final currencyTotal = currencyData.denominations.fold<double>(
          0,
          (sum, denom) => sum + (denom.value * denom.quantity),
        );
        // Convert to base currency using exchange rate
        grandTotal += currencyTotal * currencyData.exchangeRateToBase;

        // Build denomination quantities map for this currency
        final currencyQuantities = <String, int>{};
        for (final denom in currencyData.denominations) {
          if (denom.quantity > 0) {
            currencyQuantities[denom.value.toString()] = denom.quantity;
          }
        }
        denominationQuantitiesMap[currencyData.currencyId] = currencyQuantities;
      }

      // ✅ Fetch balance summary for this location
      await ref.read(cashTabProvider.notifier).submitCashEnding(
        locationId: state.selectedCashLocationId!,
      );

      // Check mounted after async operation
      if (!mounted) return;

      // Get balance summary from state
      final cashTabState = ref.read(cashTabProvider);
      final balanceSummary = cashTabState.balanceSummary;

      // Navigate to completion page
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CashEndingCompletionPage(
            tabType: 'cash',
            grandTotal: grandTotal,
            currencies: currenciesWithData,
            storeName: state.stores.firstWhere((s) => s.storeId == state.selectedStoreId).storeName,
            locationName: state.cashLocations.firstWhere((l) => l.locationId == state.selectedCashLocationId).locationName,
            denominationQuantities: denominationQuantitiesMap,
            balanceSummary: balanceSummary,  // ✅ Add balance summary
            companyId: companyId,
            userId: userId,
            cashLocationId: state.selectedCashLocationId!,
            storeId: state.selectedStoreId,
          ),
        ),
      );

      // Check mounted after async navigation
      if (!mounted) return;
      // Reset is handled in completion page's close button
    } else {
      // Check mounted before showing dialog
      if (!mounted) return;

      final tabState = ref.read(cashTabProvider);
      await TossDialogs.showCashEndingError(
        context: context,
        error: tabState.errorMessage ?? 'Failed to save cash ending',
      );
    }
  }

  /// Save Bank Balance (Clean Architecture)
  /// Uses BankRepository instead of direct Supabase call
  Future<void> _saveBankBalance(
    BuildContext context,
    CashEndingState state,
    String currencyId,
  ) async {
    // Validation
    if (state.selectedBankLocationId == null) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a bank location',
      );
      return;
    }

    // Get company and user IDs
    final companyId = ref.read(appStateProvider).companyChoosen;
    final userId = ref.read(appStateProvider).user['user_id'] as String?;

    if (companyId.isEmpty || userId == null) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Invalid company or user',
      );
      return;
    }

    // Get amount from widget using type-safe getter
    final amount = _getBankTabAmount();

    // Parse amount (remove commas if any) as integer
    final amountText = amount.replaceAll(',', '');
    final totalAmount = int.tryParse(amountText) ?? 0;

    // Create BankBalance entity (Clean Architecture - Multi-Currency)
    final now = DateTime.now();

    // Get currency info from state
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == currencyId,
      orElse: () => throw Exception('Currency not found'),
    );

    final bankBalance = BankBalance(
      companyId: companyId,
      storeId: state.selectedStoreId,
      locationId: state.selectedBankLocationId!,
      userId: userId,
      recordDate: now,
      createdAt: now,
      currencies: [
        currency.copyWith(
          denominations: [
            // Bank uses single "virtual" denomination with total amount
            Denomination(
              denominationId: 'bank-total-$currencyId',
              currencyId: currencyId,
              value: 1,
              quantity: totalAmount,
            ),
          ],
        ),
      ],
    );

    // Save via BankTabProvider
    final success = await ref.read(bankTabProvider.notifier).saveBankBalance(bankBalance);

    if (!mounted) return;

    if (success) {
      // Trigger haptic feedback for success
      HapticFeedback.mediumImpact();

      // Get currency for completion page
      final currency = state.currencies.firstWhere((c) => c.currencyId == currencyId);

      // ✅ Fetch balance summary for this location
      await ref.read(bankTabProvider.notifier).submitBankEnding(
        locationId: state.selectedBankLocationId!,
      );

      // Check mounted after async operation
      if (!mounted) return;

      // Get balance summary from state
      final bankTabState = ref.read(bankTabProvider);
      final balanceSummary = bankTabState.balanceSummary;

      // Navigate to completion page
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CashEndingCompletionPage(
            tabType: 'bank',
            grandTotal: totalAmount.toDouble(),
            currencies: [currency],
            storeName: state.stores.firstWhere((s) => s.storeId == state.selectedStoreId).storeName,
            locationName: state.bankLocations.firstWhere((l) => l.locationId == state.selectedBankLocationId).locationName,
            balanceSummary: balanceSummary,  // ✅ Add balance summary
            companyId: companyId,
            userId: userId,
            cashLocationId: state.selectedBankLocationId!,
            storeId: state.selectedStoreId,
          ),
        ),
      );

      // Check mounted after async navigation
      if (!mounted) return;

      // Clear amount via state if available
      final currentBankTabState = _bankTabKey.currentState;
      if (currentBankTabState != null && currentBankTabState.mounted) {
        (currentBankTabState as dynamic).clearAmount?.call();
      }
      // Stock flows are automatically reloaded by the notifier
    } else {
      // Check mounted before showing dialog
      if (!mounted) return;

      final tabState = ref.read(bankTabProvider);
      await TossDialogs.showCashEndingError(
        context: context,
        error: tabState.errorMessage ?? 'Failed to save bank balance',
      );
    }
  }

  /// Save Vault Transaction (Clean Architecture)
  /// Uses VaultRepository instead of direct Supabase call
  Future<void> _saveVaultTransaction(
    BuildContext context,
    CashEndingState state,
    String currencyId,
    String transactionType,
  ) async {
    debugPrint('\n');
    debugPrint('╔═══════════════════════════════════════════════════════╗');
    debugPrint('║  🎯 [CashEndingPage] _saveVaultTransaction 호출    ║');
    debugPrint('╠═══════════════════════════════════════════════════════╣');
    debugPrint('║  📋 transactionType: $transactionType');
    debugPrint('║  💰 currencyId: $currencyId');
    debugPrint('║  🏢 companyId: ${ref.read(appStateProvider).companyChoosen}');
    debugPrint('║  👤 userId: ${ref.read(appStateProvider).user['user_id']}');
    debugPrint('╚═══════════════════════════════════════════════════════╝');
    debugPrint('\n');

    // Validation
    if (state.selectedVaultLocationId == null) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a vault location',
      );
      return;
    }

    // Get quantities from widget using type-safe getter
    final allQuantities = _getVaultTabQuantities();

    // Get user ID and company ID
    final appState = ref.read(appStateProvider);
    final userId = appState.user['user_id'] as String?;
    final companyId = appState.companyChoosen;

    if (userId == null || companyId.isEmpty) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Missing user or company information',
      );
      return;
    }

    // Validate currencies list is not empty
    if (state.currencies.isEmpty) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'No currencies available. Please reload the page.',
      );
      return;
    }

    // Process ALL selected currencies (same as cash tab)
    final currencyIdsToProcess = state.selectedVaultCurrencyIds.isNotEmpty
        ? state.selectedVaultCurrencyIds
        : [currencyId];

    final currenciesWithData = currencyIdsToProcess.map((currId) {
      final currency = state.currencies.firstWhere(
        (c) => c.currencyId == currId,
        orElse: () => state.currencies.first,
      );

      final quantities = allQuantities[currId] ?? {};

      final denominationsWithQuantity = currency.denominations.map((denom) {
        final quantity = quantities[denom.denominationId] ?? 0;
        return denom.copyWith(quantity: quantity);
      }).toList();

      return Currency(
        currencyId: currency.currencyId,
        currencyCode: currency.currencyCode,
        currencyName: currency.currencyName,
        symbol: currency.symbol,
        denominations: denominationsWithQuantity,
        exchangeRateToBase: currency.exchangeRateToBase,
        isBaseCurrency: currency.isBaseCurrency,
      );
    }).toList();

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Recount vs Normal Transaction 분기 (Clean Architecture)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    final now = DateTime.now();
    bool success;
    Map<String, dynamic>? recountResult;

    if (transactionType == 'recount') {
      debugPrint('🟢 [CashEndingPage] ✨ RECOUNT 분기 진입! (Stock → Flow 변환)');
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // RECOUNT: Stock → Flow 변환
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // Use first currency for recount (recount is per currency)
      final currency = currenciesWithData.first;
      final vaultRecount = VaultRecount(
        companyId: companyId,
        storeId: state.selectedStoreId,
        locationId: state.selectedVaultLocationId!,
        currencyId: currency.currencyId,
        userId: userId,
        recordDate: now,
        createdAt: now,
        denominations: currency.denominations, // Stock 수량
      );

      debugPrint('📦 [CashEndingPage] VaultRecount entity 생성:');
      debugPrint('   - locationId: ${vaultRecount.locationId}');
      debugPrint('   - currencyId: ${vaultRecount.currencyId}');
      debugPrint('   - denominations: ${vaultRecount.denominations.length}개');
      debugPrint('   - totalAmount: ${vaultRecount.totalAmount}');

      try {
        debugPrint('🚀 [CashEndingPage] VaultTabNotifier.recountVault() 호출...');
        // Call recount RPC via VaultTabNotifier
        recountResult = await ref.read(vaultTabProvider.notifier).recountVault(vaultRecount);
        success = recountResult['success'] == true;

        debugPrint('✅ [CashEndingPage] Recount 성공!');
        debugPrint('   - adjustment_count: ${recountResult['adjustment_count']}');
        debugPrint('   - total_variance: ${recountResult['total_variance']}');
        debugPrint('   - adjustments: ${recountResult['adjustments']}');
      } catch (e) {
        debugPrint('❌ [CashEndingPage] Recount 실패: $e');
        success = false;
        if (mounted) {
          await TossDialogs.showCashEndingError(
            context: context,
            error: 'Recount failed: ${e.toString()}',
          );
        }
        return;
      }
    } else {
      debugPrint('🔵🟠 [CashEndingPage] ✨ NORMAL 분기 진입! (In/Out Transaction)');
      debugPrint('   - isCredit: ${transactionType == 'credit'}');
      debugPrint('   - currencies: ${currenciesWithData.length}개');
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // NORMAL: In/Out Transaction (다중 통화 지원)
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

      // ✅ Filter out currencies with no quantities
      final currenciesWithQuantities = currenciesWithData
          .where((currency) => currency.denominations.any((d) => d.quantity > 0))
          .toList();

      if (currenciesWithQuantities.isEmpty) {
        debugPrint('⚠️ [CashEndingPage] No currencies with quantities!');
        success = false;
        if (mounted) {
          await TossDialogs.showCashEndingError(
            context: context,
            error: 'Please enter quantities for at least one currency',
          );
        }
        return;
      }

      // ✅ Create single VaultTransaction with ALL currencies
      final vaultTransaction = VaultTransaction(
        companyId: companyId,
        storeId: state.selectedStoreId,
        locationId: state.selectedVaultLocationId!,
        userId: userId,
        recordDate: now,
        createdAt: now,
        isCredit: transactionType == 'credit',
        currencies: currenciesWithQuantities, // ✅ ALL currencies at once
      );

      debugPrint('📦 [CashEndingPage] VaultTransaction entity 생성 (Multi-Currency):');
      debugPrint('   - currencies: ${vaultTransaction.currencies.length}개');
      for (final currency in currenciesWithQuantities) {
        debugPrint('   - ${currency.currencyCode}: ${currency.denominations.where((d) => d.quantity > 0).length}개 denominations');
        debugPrint('     totalAmount: ${currency.totalAmount}');
      }

      // ✅ Save ALL currencies in one RPC call
      success = await ref.read(vaultTabProvider.notifier).saveVaultTransaction(vaultTransaction);

      debugPrint('✅ [CashEndingPage] 모든 통화 저장 ${success ? '성공' : '실패'}!');
    }

    if (!mounted) return;

    if (success) {
      // Trigger haptic feedback for success
      HapticFeedback.mediumImpact();

      // Calculate grand total and build denomination quantities map for ALL currencies (converted to base currency)
      double grandTotal = 0.0;
      final Map<String, Map<String, int>> denominationQuantitiesMap = {};

      for (final currencyData in currenciesWithData) {
        // Calculate total for this currency
        final currencyTotal = currencyData.denominations.fold<double>(
          0,
          (sum, denom) => sum + (denom.value * denom.quantity),
        );
        // Convert to base currency using exchange rate
        grandTotal += currencyTotal * currencyData.exchangeRateToBase;

        // Build denomination quantities map for this currency
        final currencyQuantities = <String, int>{};
        for (final denom in currencyData.denominations) {
          if (denom.quantity > 0) {
            currencyQuantities[denom.value.toString()] = denom.quantity;
          }
        }
        denominationQuantitiesMap[currencyData.currencyId] = currencyQuantities;
      }

      // ✅ Fetch balance summary for this location
      await ref.read(vaultTabProvider.notifier).submitVaultEnding(
        locationId: state.selectedVaultLocationId!,
      );

      // Check mounted after async operation
      if (!mounted) return;

      // Get balance summary from state
      final vaultTabState = ref.read(vaultTabProvider);
      final balanceSummary = vaultTabState.balanceSummary;

      // Navigate to completion page
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CashEndingCompletionPage(
            tabType: 'vault',
            grandTotal: grandTotal,
            currencies: currenciesWithData,
            storeName: state.stores.firstWhere((s) => s.storeId == state.selectedStoreId).storeName,
            locationName: state.vaultLocations.firstWhere((l) => l.locationId == state.selectedVaultLocationId).locationName,
            denominationQuantities: denominationQuantitiesMap,
            transactionType: transactionType,
            balanceSummary: balanceSummary,  // ✅ Add balance summary
            companyId: companyId,
            userId: userId,
            cashLocationId: state.selectedVaultLocationId!,
            storeId: state.selectedStoreId,
          ),
        ),
      );

      // Check mounted after async navigation
      if (!mounted) return;

      // Clear quantities via state if available
      final currentVaultTabState = _vaultTabKey.currentState;
      if (currentVaultTabState != null && currentVaultTabState.mounted) {
        (currentVaultTabState as dynamic).clearQuantities?.call();
      }
      // Stock flows are automatically reloaded by the notifier
    } else {
      // Check mounted before showing dialog
      if (!mounted) return;

      final tabState = ref.read(vaultTabProvider);
      await TossDialogs.showCashEndingError(
        context: context,
        error: tabState.errorMessage ?? 'Failed to save vault transaction',
      );
    }
  }
}
