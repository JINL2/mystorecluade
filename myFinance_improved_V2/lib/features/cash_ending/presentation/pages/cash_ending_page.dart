// lib/features/cash_ending/presentation/pages/cash_ending_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/bank_balance.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/vault_transaction.dart';
import '../providers/cash_ending_provider.dart';
import '../providers/cash_ending_state.dart';
import '../providers/cash_tab_provider.dart';
import '../providers/bank_tab_provider.dart';
import '../providers/vault_tab_provider.dart';
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

      if (companyId.isNotEmpty) {
        ref.read(cashEndingProvider.notifier).loadStores(companyId);
        ref.read(cashEndingProvider.notifier).loadCurrencies(companyId);

        // Auto-select store from AppState (like lib_old)
        if (storeId.isNotEmpty) {
          ref.read(cashEndingProvider.notifier).selectStore(storeId, companyId);
        }
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

    // Get quantities from widget (accessing via currentState)
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
      ),
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

    // Save via CashTabProvider
    final success = await ref.read(cashTabProvider.notifier).saveCashEnding(cashEnding);

    if (!mounted) {
      return;
    }

    if (success) {
      await TossDialogs.showCashEndingSaved(context: context);
      cashTabState?.clearQuantities?.call();
      // Stock flows are automatically reloaded by the notifier
    } else {
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

    final dynamic bankTabState = _bankTabKey.currentState;
    final amount = bankTabState?.bankAmount as String? ?? '0';

    // Parse amount (remove commas if any) as integer
    final amountText = amount.replaceAll(',', '');
    final totalAmount = int.tryParse(amountText) ?? 0;

    // Create BankBalance entity (Clean Architecture)
    final now = DateTime.now();
    final bankBalance = BankBalance(
      companyId: companyId,
      storeId: state.selectedStoreId,
      locationId: state.selectedBankLocationId!,
      currencyId: currencyId,
      totalAmount: totalAmount,
      userId: userId,
      recordDate: now,
      createdAt: now,
    );

    // Save via BankTabProvider
    final success = await ref.read(bankTabProvider.notifier).saveBankBalance(bankBalance);

    if (!mounted) return;

    if (success) {
      // Trigger haptic feedback for success
      HapticFeedback.mediumImpact();

      await TossDialogs.showBankBalanceSaved(context: context);
      bankTabState?.clearAmount?.call();
      // Stock flows are automatically reloaded by the notifier
    } else {
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
    // Validation
    if (state.selectedVaultLocationId == null) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a vault location',
      );
      return;
    }

    final dynamic vaultTabState = _vaultTabKey.currentState;
    final quantities = (vaultTabState?.denominationQuantities as Map<String, Map<String, int>>?)?[currencyId] ?? {};

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

    // Get currency denominations from state
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == currencyId,
      orElse: () => state.currencies.first,
    );

    // Create denominations with quantities (Clean Architecture)
    final denominationsWithQuantity = currency.denominations.map((denom) {
      final quantity = quantities[denom.denominationId] ?? 0;
      return denom.copyWith(quantity: quantity);
    }).toList();

    // Create VaultTransaction entity (Clean Architecture)
    final now = DateTime.now();
    final vaultTransaction = VaultTransaction(
      companyId: companyId,
      storeId: state.selectedStoreId,
      locationId: state.selectedVaultLocationId!,
      currencyId: currencyId,
      userId: userId,
      recordDate: now,
      createdAt: now,
      isCredit: transactionType == 'credit',
      denominations: denominationsWithQuantity,
    );

    // Save via VaultTabProvider
    final success = await ref.read(vaultTabProvider.notifier).saveVaultTransaction(vaultTransaction);

    if (!mounted) return;

    if (success) {
      // Trigger haptic feedback for success
      HapticFeedback.mediumImpact();

      await TossDialogs.showVaultTransactionSaved(
        context: context,
        transactionType: transactionType,
      );

      vaultTabState?.clearQuantities?.call();
      // Stock flows are automatically reloaded by the notifier
    } else {
      final tabState = ref.read(vaultTabProvider);
      await TossDialogs.showCashEndingError(
        context: context,
        error: tabState.errorMessage ?? 'Failed to save vault transaction',
      );
    }
  }
}
