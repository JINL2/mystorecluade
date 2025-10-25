// lib/features/cash_ending/presentation/pages/cash_ending_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/currency.dart';
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
      appBar: TossAppBar1(
        title: 'Cash Ending',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TossTabBar1(
            tabs: const ['Cash', 'Bank', 'Vault'],
            controller: _tabController,
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

  /// Save Bank Balance (from legacy bank_service.dart)
  /// Uses bank_amount_insert_v2 RPC (different from Cash tab's RPC)
  Future<void> _saveBankBalance(
    BuildContext context,
    CashEndingState state,
    String currencyId,
  ) async {

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

    // Note: Allow saving even if amount is empty (defaults to 0)
    // Bank balance can be 0

    // Parse amount (remove commas if any) as integer
    final amountText = amount.replaceAll(',', '');
    final totalAmount = int.tryParse(amountText) ?? 0;

    // Get current date and time
    final now = DateTime.now();
    final recordDate = DateFormat('yyyy-MM-dd').format(now);

    // Format created_at with microseconds like "2025-06-07 23:40:55.948829"
    final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now) +
                     '.${now.microsecond.toString().padLeft(6, '0')}';

    // Prepare parameters for RPC call (from lib_old bank_service.dart lines 58-67)
    final Map<String, dynamic> params = {
      'p_company_id': companyId,
      'p_store_id': state.selectedStoreId == 'headquarter' ? null : state.selectedStoreId,
      'p_record_date': recordDate,
      'p_location_id': state.selectedBankLocationId,
      'p_currency_id': currencyId,
      'p_total_amount': totalAmount,
      'p_created_by': userId,
      'p_created_at': createdAt,
    };


    try {
      // Call bank_amount_insert_v2 RPC (from lib_old lines 70-71)
      await Supabase.instance.client
          .rpc<dynamic>('bank_amount_insert_v2', params: params);

      if (!mounted) return;

      // Trigger haptic feedback for success
      HapticFeedback.mediumImpact();

      await TossDialogs.showBankBalanceSaved(context: context);
      bankTabState?.clearAmount?.call();

      // Reload stock flows
      if (state.selectedBankLocationId != null &&
          state.selectedBankLocationId!.isNotEmpty) {
        bankTabState?.reloadStockFlows?.call();
      }
    } catch (e) {

      if (!mounted) return;

      // Parse error message for user-friendly display (from lib_old lines 91-101)
      String errorMessage = 'Failed to save bank balance';
      if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection and try again.';
      } else if (e.toString().contains('duplicate')) {
        errorMessage = 'Bank balance for today already exists.';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'You do not have permission to save bank balance.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      await TossDialogs.showCashEndingError(
        context: context,
        error: errorMessage,
      );
    }
  }

  /// Save Vault Transaction (from legacy vault_service.dart)
  Future<void> _saveVaultTransaction(
    BuildContext context,
    CashEndingState state,
    String currencyId,
    String transactionType,
  ) async {
    if (state.selectedVaultLocationId == null) {
      await TossDialogs.showCashEndingError(
        context: context,
        error: 'Please select a vault location',
      );
      return;
    }

    final dynamic vaultTabState = _vaultTabKey.currentState;
    final quantities = (vaultTabState?.denominationQuantities as Map<String, Map<String, int>>?)?[currencyId] ?? {};

    // Note: Unlike Cash tab, Vault allows empty denominations (saves as empty transaction)
    // This matches lib_old behavior where validation is not performed

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

    // Get current date and time
    final now = DateTime.now();
    final recordDate = DateFormat('yyyy-MM-dd').format(now);

    // Format created_at with microseconds (matching lib_old line 40)
    final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now) +
                     '.${now.microsecond.toString().padLeft(6, '0')}';

    // Build vault_amount_line_json with denomination details
    // This matches lib_old lines 43-66
    final List<Map<String, dynamic>> vaultAmountLineJson = [];

    // Get currency denominations from state
    final currency = state.currencies.firstWhere(
      (c) => c.currencyId == currencyId,
      orElse: () => state.currencies.first,
    );

    for (final denom in currency.denominations) {
      final denominationId = denom.denominationId;
      final quantity = quantities[denominationId];

      if (quantity != null && quantity > 0) {
        vaultAmountLineJson.add({
          'quantity': quantity.toString(),
          'denomination_id': denominationId,
          'denomination_value': denom.value.toString(),
          'denomination_type': 'BILL', // Default type as in lib_old line 61
        });
      }
    }

    // Prepare parameters for RPC call (matching lib_old lines 69-80)
    final Map<String, dynamic> params = {
      'p_location_id': state.selectedVaultLocationId,
      'p_company_id': companyId,
      'p_created_at': createdAt,
      'p_created_by': userId,
      'p_credit': transactionType == 'credit',
      'p_debit': transactionType == 'debit',
      'p_currency_id': currencyId,
      'p_record_date': recordDate,
      'p_store_id': state.selectedStoreId == 'headquarter' ? null : state.selectedStoreId,
      'p_vault_amount_line_json': vaultAmountLineJson,
    };


    try {
      // Call vault_amount_insert RPC (from lib_old line 83-84)
      await Supabase.instance.client
          .rpc<dynamic>('vault_amount_insert', params: params);

      if (!mounted) return;

      // Trigger haptic feedback for success
      HapticFeedback.mediumImpact();

      await TossDialogs.showVaultTransactionSaved(
        context: context,
        transactionType: transactionType,
      );

      vaultTabState?.clearQuantities?.call();

      // Reload stock flows
      if (state.selectedVaultLocationId != null &&
          state.selectedVaultLocationId!.isNotEmpty) {
        vaultTabState?.reloadStockFlows?.call();
      }
    } catch (e) {

      if (!mounted) return;

      String errorMessage;
      if (e.toString().contains('permission')) {
        errorMessage = 'You do not have permission to save vault transactions.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      await TossDialogs.showCashEndingError(
        context: context,
        error: errorMessage,
      );
    }
  }
}
