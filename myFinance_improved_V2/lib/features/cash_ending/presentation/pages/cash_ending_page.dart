// lib/features/cash_ending/presentation/pages/cash_ending_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/ai_chat/ai_chat.dart';
import '../../../homepage/domain/entities/top_feature.dart';
import '../providers/cash_ending_provider.dart';
import '../providers/cash_ending_state.dart';
import '../widgets/tabs/bank_tab.dart';
import '../widgets/tabs/cash_tab.dart';
import '../widgets/tabs/vault_tab.dart';

// Handlers
import 'handlers/handlers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen to tab changes
    _tabController.addListener(_onTabChanged);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadInitialData();
      _extractFeatureInfo();
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      FocusScope.of(context).unfocus();
      ref.read(cashEndingProvider.notifier).setCurrentTab(_tabController.index);
    }
  }

  void _loadInitialData() {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isNotEmpty) {
      ref.read(cashEndingProvider.notifier).loadStores(companyId);
      ref.read(cashEndingProvider.notifier).loadCurrencies(companyId);

      if (storeId.isNotEmpty) {
        ref.read(cashEndingProvider.notifier).selectStore(storeId, companyId);
      }
    }
  }

  void _extractFeatureInfo() {
    if (_featureInfoExtracted) return;
    _featureInfoExtracted = true;

    if (widget.feature == null) {
      _featureName = 'Cash Ending';
      return;
    }

    try {
      if (widget.feature is TopFeature) {
        final topFeature = widget.feature as TopFeature;
        _featureName = topFeature.featureName;
        _featureId = topFeature.featureId;
      } else if (widget.feature is Feature) {
        final feature = widget.feature as Feature;
        _featureName = feature.featureName;
        _featureId = feature.featureId;
      } else if (widget.feature is Map<String, dynamic>) {
        final featureMap = widget.feature as Map<String, dynamic>;
        _featureName = featureMap['feature_name'] as String? ??
            featureMap['featureName'] as String?;
        _featureId = featureMap['feature_id'] as String? ??
            featureMap['featureId'] as String?;
      }
    } catch (e) {
      _featureName = 'Cash Ending';
    }

    _featureName ??= 'Cash Ending';
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyId = ref.read(appStateProvider).companyChoosen;
    final state = ref.watch(cashEndingProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar(
        title: 'Cash Ending',
        backgroundColor: TossColors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: TossColors.white,
            child: TossTabBar(
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
        pageContext: _buildPageContext(state),
        featureId: _featureId,
      ),
    );
  }

  Map<String, dynamic> _buildPageContext(CashEndingState state) {
    final locationTypes = ['cash', 'bank', 'vault'];
    final locationType = _tabController.index < locationTypes.length
        ? locationTypes[_tabController.index]
        : 'cash';

    String? cashLocationId;
    if (_tabController.index == 0) {
      cashLocationId = state.selectedCashLocationId;
    } else if (_tabController.index == 1) {
      cashLocationId = state.selectedBankLocationId;
    } else if (_tabController.index == 2) {
      cashLocationId = state.selectedVaultLocationId;
    }

    final context = <String, dynamic>{
      'location_type': locationType,
    };

    if (state.selectedStoreId != null) {
      context['store_id'] = state.selectedStoreId;
    }

    if (cashLocationId != null) {
      context['cash_location_id'] = cashLocationId;
    }

    return context;
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Tab State Getters (for accessing child widget state)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Map<String, Map<String, int>> _getCashTabQuantities() {
    final state = _cashTabKey.currentState;
    if (state != null && state.mounted) {
      return (state as dynamic).denominationQuantities
              as Map<String, Map<String, int>>? ??
          {};
    }
    return {};
  }

  String _getBankTabAmount() {
    final state = _bankTabKey.currentState;
    if (state != null && state.mounted) {
      return (state as dynamic).bankAmount as String? ?? '0';
    }
    return '0';
  }

  Map<String, Map<String, int>> _getVaultTabQuantities() {
    final state = _vaultTabKey.currentState;
    if (state != null && state.mounted) {
      return (state as dynamic).denominationQuantities
              as Map<String, Map<String, int>>? ??
          {};
    }
    return {};
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // Save Handlers (delegated to handler classes)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> _saveCashEnding(
    BuildContext context,
    CashEndingState state,
    String currencyId,
  ) async {
    final handler = CashSaveHandler(
      ref: ref,
      context: context,
      isMounted: () => mounted,
    );

    await handler.saveCashEnding(
      state: state,
      currencyId: currencyId,
      allQuantities: _getCashTabQuantities(),
    );
  }

  Future<void> _saveBankBalance(
    BuildContext context,
    CashEndingState state,
    String currencyId,
  ) async {
    final handler = BankSaveHandler(
      ref: ref,
      context: context,
      isMounted: () => mounted,
    );

    await handler.saveBankBalance(
      state: state,
      currencyId: currencyId,
      amount: _getBankTabAmount(),
      onClearAmount: () {
        final currentState = _bankTabKey.currentState;
        if (currentState != null && currentState.mounted) {
          (currentState as dynamic).clearAmount?.call();
        }
      },
    );
  }

  Future<void> _saveVaultTransaction(
    BuildContext context,
    CashEndingState state,
    String currencyId,
    String transactionType,
  ) async {
    final handler = VaultSaveHandler(
      ref: ref,
      context: context,
      isMounted: () => mounted,
    );

    await handler.saveVaultTransaction(
      state: state,
      currencyId: currencyId,
      transactionType: transactionType,
      allQuantities: _getVaultTabQuantities(),
      onClearQuantities: () {
        final currentState = _vaultTabKey.currentState;
        if (currentState != null && currentState.mounted) {
          (currentState as dynamic).clearQuantities?.call();
        }
      },
    );
  }
}
