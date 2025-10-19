// lib/features/cash_ending/presentation/pages/cash_ending_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
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
        ref
            .read(cashEndingProvider.notifier)
            .setCurrentTab(_tabController.index);
      }
    });

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companyId = ref.read(appStateProvider).companyChoosen;
      if (companyId.isNotEmpty) {
        ref.read(cashEndingProvider.notifier).loadStores(companyId);
        ref.read(cashEndingProvider.notifier).loadCurrencies(companyId);
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
      appBar: AppBar(
        title: const Text('Cash Ending'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Cash'),
            Tab(text: 'Bank'),
            Tab(text: 'Vault'),
          ],
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
      _showSnackBar(context, 'Please select a cash location', isError: true);
      return;
    }

    final companyId = ref.read(appStateProvider).companyChoosen;
    final userId = ref.read(appStateProvider).user['user_id']?.toString() ?? '';

    if (companyId.isEmpty || userId.isEmpty) {
      _showSnackBar(context, 'Invalid company or user', isError: true);
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

    if (quantities.isEmpty || !quantities.values.any((q) => q > 0)) {
      _showSnackBar(context, 'Please enter at least one denomination quantity',
          isError: true);
      return;
    }

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

    if (!mounted) return;

    if (success) {
      _showSnackBar(context, 'Cash ending saved successfully');
      cashTabState?.clearQuantities?.call();
    } else {
      _showSnackBar(context, state.error ?? 'Failed to save cash ending',
          isError: true);
    }
  }

  /// Save Bank Balance (from legacy bank_service.dart)
  Future<void> _saveBankBalance(
    BuildContext context,
    CashEndingState state,
    String currencyId,
  ) async {
    if (state.selectedBankLocationId == null) {
      _showSnackBar(context, 'Please select a bank location', isError: true);
      return;
    }

    final dynamic bankTabState = _bankTabKey.currentState;
    final amount = bankTabState?.bankAmount as String? ?? '';

    if (amount.isEmpty) {
      _showSnackBar(context, 'Please enter bank balance amount', isError: true);
      return;
    }

    // TODO: Implement bank balance save via RPC
    _showSnackBar(
      context,
      'Bank balance: $amount (RPC save not yet implemented)',
      isWarning: true,
    );

    bankTabState?.clearAmount?.call();
  }

  /// Save Vault Transaction (from legacy vault_service.dart)
  Future<void> _saveVaultTransaction(
    BuildContext context,
    CashEndingState state,
    String currencyId,
    String transactionType,
  ) async {
    if (state.selectedVaultLocationId == null) {
      _showSnackBar(context, 'Please select a vault location', isError: true);
      return;
    }

    final dynamic vaultTabState = _vaultTabKey.currentState;
    final quantities = (vaultTabState?.denominationQuantities as Map<String, Map<String, int>>?)?[currencyId] ?? {};

    if (quantities.isEmpty || !quantities.values.any((q) => q > 0)) {
      _showSnackBar(context, 'Please enter at least one denomination quantity',
          isError: true);
      return;
    }

    // TODO: Implement vault transaction save via RPC
    final label = transactionType == 'debit' ? 'In' : 'Out';
    _showSnackBar(
      context,
      'Vault $label transaction recorded (RPC save not yet implemented)',
      isWarning: true,
    );

    vaultTabState?.clearQuantities?.call();
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false, bool isWarning = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? TossColors.error
            : isWarning
                ? TossColors.warning
                : TossColors.success,
      ),
    );
  }
}
