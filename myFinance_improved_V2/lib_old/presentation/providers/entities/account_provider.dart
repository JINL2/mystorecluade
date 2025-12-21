// =====================================================
// ACCOUNT ENTITY RIVERPOD PROVIDERS
// Autonomous data providers for account selectors
// =====================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/selector_entities.dart';
import '../../../data/services/supabase_service.dart';
import '../app_state_provider.dart';

part 'account_provider.g.dart';

// =====================================================
// ACCOUNT LIST PROVIDER
// Base provider that fetches accounts from RPC
// =====================================================
@riverpod
class AccountList extends _$AccountList {
  @override
  Future<List<AccountData>> build([
    String? accountType,
  ]) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    try {
      final response = await supabase.client.rpc(
        'get_accounts',
        params: {
          'p_account_type': accountType,
        },
      );

      if (response == null) return [];

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => AccountData.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Log error but don't throw to prevent UI crashes
      print('Error fetching accounts: $e');
      return [];
    }
  }

  // Helper methods for specific account types
  Future<List<AccountData>> getAssets() async {
    final accounts = await future;
    return accounts.assets;
  }

  Future<List<AccountData>> getLiabilities() async {
    final accounts = await future;
    return accounts.liabilities;
  }

  Future<List<AccountData>> getExpenses() async {
    final accounts = await future;
    return accounts.expenses;
  }

  Future<List<AccountData>> getIncome() async {
    final accounts = await future;
    return accounts.income;
  }
}

// =====================================================
// AUTO-CONTEXT ACCOUNT PROVIDERS
// Automatically watch app state and refresh data
// =====================================================

/// Current accounts (global - no company/store filter needed)
@riverpod
Future<List<AccountData>> currentAccounts(CurrentAccountsRef ref) async {
  return ref.watch(accountListProvider().future);
}

/// Current accounts filtered by type
@riverpod
Future<List<AccountData>> currentAccountsByType(
  CurrentAccountsByTypeRef ref,
  String accountType,
) async {
  return ref.watch(accountListProvider(accountType).future);
}

/// Asset accounts only
@riverpod
Future<List<AccountData>> currentAssetAccounts(CurrentAssetAccountsRef ref) async {
  return ref.watch(currentAccountsByTypeProvider('asset').future);
}

/// Liability accounts only
@riverpod
Future<List<AccountData>> currentLiabilityAccounts(CurrentLiabilityAccountsRef ref) async {
  return ref.watch(currentAccountsByTypeProvider('liability').future);
}

/// Income accounts only
@riverpod
Future<List<AccountData>> currentIncomeAccounts(CurrentIncomeAccountsRef ref) async {
  return ref.watch(currentAccountsByTypeProvider('income').future);
}

/// Expense accounts only
@riverpod
Future<List<AccountData>> currentExpenseAccounts(CurrentExpenseAccountsRef ref) async {
  return ref.watch(currentAccountsByTypeProvider('expense').future);
}

/// Equity accounts only
@riverpod
Future<List<AccountData>> currentEquityAccounts(CurrentEquityAccountsRef ref) async {
  return ref.watch(currentAccountsByTypeProvider('equity').future);
}

// =====================================================
// ACCOUNT SELECTION STATE PROVIDERS
// Manage selected account state
// =====================================================

/// Single account selection state
@riverpod
class SelectedAccount extends _$SelectedAccount {
  @override
  String? build() => null;

  void select(String? accountId) {
    state = accountId;
  }

  void clear() {
    state = null;
  }
}

/// Multiple account selection state
@riverpod
class SelectedAccounts extends _$SelectedAccounts {
  @override
  List<String> build() => [];

  void select(List<String> accountIds) {
    state = accountIds;
  }

  void add(String accountId) {
    if (!state.contains(accountId)) {
      state = [...state, accountId];
    }
  }

  void remove(String accountId) {
    state = state.where((id) => id != accountId).toList();
  }

  void toggle(String accountId) {
    if (state.contains(accountId)) {
      remove(accountId);
    } else {
      add(accountId);
    }
  }

  void clear() {
    state = [];
  }
}

// =====================================================
// ACCOUNT DATA HELPERS
// Helper providers for finding specific accounts
// =====================================================

/// Find account by ID
@riverpod
Future<AccountData?> accountById(
  AccountByIdRef ref,
  String accountId,
) async {
  final accounts = await ref.watch(currentAccountsProvider.future);
  try {
    return accounts.firstWhere((account) => account.id == accountId);
  } catch (e) {
    return null;
  }
}

/// Find accounts by IDs
@riverpod
Future<List<AccountData>> accountsByIds(
  AccountsByIdsRef ref,
  List<String> accountIds,
) async {
  final accounts = await ref.watch(currentAccountsProvider.future);
  return accounts.where((account) => accountIds.contains(account.id)).toList();
}