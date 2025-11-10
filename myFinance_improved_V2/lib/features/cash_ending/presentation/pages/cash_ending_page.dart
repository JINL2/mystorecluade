// lib/features/cash_ending/presentation/pages/cash_ending_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/bank_balance.dart';
import '../../domain/entities/vault_transaction.dart';
import '../providers/cash_ending_provider.dart';
import '../providers/cash_ending_state.dart';
import '../widgets/tabs/bank_tab.dart';
import '../widgets/tabs/cash_tab.dart';
import '../widgets/tabs/vault_tab.dart';

/// Cash Ending Page
///
/// Main page with 3 tabs based on legacy structure:
/// - Cash Tab: Denomination-based counting
/// - Bank Tab: Single amount input (no denominations)
/// - Vault Tab: Denomination-based with In/Out toggle
class CashEndingPage extends ConsumerStatefulWidget {
  const CashEndingPage({super.key});

  @override
  ConsumerState<CashEndingPage> createState() => _CashEndingPageState();
}

class _CashEndingPageState extends ConsumerState<CashEndingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ConsumerState<CashTab>> _cashTabKey = GlobalKey();
  final GlobalKey<ConsumerState<BankTab>> _bankTabKey = GlobalKey();
  final GlobalKey<ConsumerState<VaultTab>> _vaultTabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      debugPrint('🔍 [CashEndingPage] Initial load');
      debugPrint('   Company ID: $companyId');
      debugPrint('   Store ID: $storeId');

      if (companyId.isNotEmpty) {
        debugPrint('✅ [CashEndingPage] Loading stores and currencies...');
        ref.read(cashEndingProvider.notifier).loadStores(companyId);
        ref.read(cashEndingProvider.notifier).loadCurrencies(companyId);

        // Auto-select store from AppState (like lib_old)
        if (storeId.isNotEmpty) {
          debugPrint('✅ [CashEndingPage] Auto-selecting store: $storeId');
          ref.read(cashEndingProvider.notifier).selectStore(storeId, companyId);
        } else {
          debugPrint('⚠️ [CashEndingPage] No store selected in AppState');
        }
      } else {
        debugPrint('❌ [CashEndingPage] Company ID is empty!');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyId = ref.read(appStateProvider).companyChoosen;

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
    );
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

    // Get currency
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == currencyId,
      orElse: () => state.currencies.first,
    );

    // Get quantities from tab (accessing via currentState as dynamic to get the property)
    final dynamic cashTabState = _cashTabKey.currentState;
    final quantities = (cashTabState?.denominationQuantities as Map<String, Map<String, int>>?)?[currencyId] ?? {};

    // Note: Allow saving even if quantities are empty or all zeros
    // This is valid - it records that cash count is 0

    final denominationsWithQuantity = currency.denominations.map((denom) {
      final quantity = quantities[denom.denominationId] ?? 0;
      return denom.copyWith(quantity: quantity);
    }).toList();

    final currenciesWithData = [
      Currency(
        currencyId: currency.currencyId,
        currencyCode: currency.currencyCode,
        currencyName: currency.currencyName,
        symbol: currency.symbol,
        denominations: denominationsWithQuantity,
      )
    ];

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

    // Save
    final success =
        await ref.read(cashEndingProvider.notifier).saveCashEnding(cashEnding);

    if (!mounted) {
      return;
    }

    if (success) {
      await TossDialogs.showCashEndingSaved(context: context);
      cashTabState?.clearQuantities?.call();

      // Refresh Real section data (like lib_old lines 1234-1236)
      // Reload stock flows to show the newly saved cash ending
      if (state.selectedCashLocationId != null && state.selectedCashLocationId!.isNotEmpty) {
        cashTabState?.reloadStockFlows?.call();
      }
    } else {
      await TossDialogs.showCashEndingError(
        context: context,
        error: state.errorMessage ?? 'Failed to save cash ending',
      );
    }
  }

  /// Save Bank Balance
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

    final companyId = ref.read(appStateProvider).companyChoosen;
    final userId = ref.read(appStateProvider).user['user_id']?.toString() ?? '';

    if (companyId.isEmpty || userId.isEmpty) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Invalid company or user',
      );
      return;
    }

    final dynamic bankTabState = _bankTabKey.currentState;
    final amount = bankTabState?.bankAmount as String? ?? '0';

    // Parse amount (remove commas) as integer
    final amountText = amount.replaceAll(',', '');
    final totalAmount = int.tryParse(amountText) ?? 0;

    // Create BankBalance entity
    final now = DateTime.now();
    final bankBalance = BankBalance(
      companyId: companyId,
      locationId: state.selectedBankLocationId!,
      storeId: state.selectedStoreId,
      userId: userId,
      currencyId: currencyId,
      totalAmount: totalAmount,
      recordDate: now,
      createdAt: now,
    );

    // Save through repository
    final success = await ref.read(cashEndingProvider.notifier).saveBankBalance(bankBalance);

    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      await TossDialogs.showBankBalanceSaved(context: context);
      bankTabState?.clearAmount?.call();

      // Reload stock flows
      if (state.selectedBankLocationId != null && state.selectedBankLocationId!.isNotEmpty) {
        bankTabState?.reloadStockFlows?.call();
      }
    } else {
      await TossDialogs.showCashEndingError(
        context: context,
        error: state.errorMessage ?? 'Failed to save bank balance',
      );
    }
  }

  /// Save Vault Transaction
  Future<void> _saveVaultTransaction(
    BuildContext context,
    CashEndingState state,
    String currencyId,
    String transactionType,
  ) async {
    // Validation
    if (state.selectedVaultLocationId == null) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a vault location',
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

    // Get currency and quantities
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == currencyId,
      orElse: () => state.currencies.first,
    );

    final dynamic vaultTabState = _vaultTabKey.currentState;
    final quantities = (vaultTabState?.denominationQuantities as Map<String, Map<String, int>>?)?[currencyId] ?? {};

    // Build denominations with quantities
    final denominationsWithQuantity = currency.denominations.map((denom) {
      final quantity = quantities[denom.denominationId] ?? 0;
      return denom.copyWith(quantity: quantity);
    }).toList();

    final currencyWithData = Currency(
      currencyId: currency.currencyId,
      currencyCode: currency.currencyCode,
      currencyName: currency.currencyName,
      symbol: currency.symbol,
      denominations: denominationsWithQuantity,
    );

    // Create VaultTransaction entity
    final now = DateTime.now();
    final vaultTransaction = VaultTransaction(
      companyId: companyId,
      locationId: state.selectedVaultLocationId!,
      storeId: state.selectedStoreId,
      userId: userId,
      currencyId: currencyId,
      isCredit: transactionType == 'credit',
      isDebit: transactionType == 'debit',
      recordDate: now,
      createdAt: now,
      currency: currencyWithData,
    );

    // Save through repository
    final success = await ref.read(cashEndingProvider.notifier).saveVaultTransaction(vaultTransaction);

    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      await TossDialogs.showVaultTransactionSaved(
        context: context,
        transactionType: transactionType,
      );
      vaultTabState?.clearQuantities?.call();

      // Reload stock flows
      if (state.selectedVaultLocationId != null && state.selectedVaultLocationId!.isNotEmpty) {
        vaultTabState?.reloadStockFlows?.call();
      }
    } else {
      await TossDialogs.showCashEndingError(
        context: context,
        error: state.errorMessage ?? 'Failed to save vault transaction',
      );
    }
  }
}
