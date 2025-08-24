// =====================================================
// AUTONOMOUS ACCOUNT SELECTOR
// Truly reusable account selector using entity providers
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../../data/services/supabase_service.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/entities/account_provider.dart';
import 'toss_base_selector.dart';
import 'enhanced_account_selector.dart';

/// Autonomous account selector that can be used anywhere in the app
/// Uses dedicated RPC function and entity providers
class AutonomousAccountSelector extends ConsumerWidget {
  final String? selectedAccountId;
  final SingleSelectionCallback? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? accountType; // Filter by specific account type (asset, liability, etc.)
  final String? contextType; // Track usage context ('transaction', 'template', 'journal_entry')
  final bool showQuickAccess; // Show frequently used accounts at top

  const AutonomousAccountSelector({
    super.key,
    this.selectedAccountId,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.accountType,
    this.contextType,
    this.showQuickAccess = true, // Enable by default for better UX
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use enhanced selector with quick access if enabled
    if (showQuickAccess) {
      return EnhancedAccountSelector(
        selectedAccountId: selectedAccountId,
        onChanged: onChanged,
        label: label,
        hint: hint,
        errorText: errorText,
        showSearch: showSearch,
        showTransactionCount: showTransactionCount,
        accountType: accountType,
        contextType: contextType,
        showQuickAccess: true,
        maxQuickItems: 5,
      );
    }
    
    // Otherwise use the regular selector
    // Choose the appropriate provider based on account type filter
    final accountsAsync = accountType != null
        ? ref.watch(currentAccountsByTypeProvider(accountType!))
        : ref.watch(currentAccountsProvider);

    // Find selected account
    AccountData? selectedAccount;
    if (selectedAccountId != null) {
      accountsAsync.whenData((accounts) {
        try {
          selectedAccount = accounts.firstWhere((account) => account.id == selectedAccountId);
        } catch (e) {
          selectedAccount = null;
        }
      });
    }

    return TossSingleSelector<AccountData>(
      items: accountsAsync.maybeWhen(
        data: (accounts) => accounts,
        orElse: () => [],
      ),
      selectedItem: selectedAccount,
      onChanged: (accountId) {
        // Track account selection before calling original callback
        if (accountId != null && contextType != null) {
          // Find the selected account data for tracking
          accountsAsync.whenData((accounts) {
            try {
              final account = accounts.firstWhere((a) => a.id == accountId);
              _trackAccountUsage(ref, account, contextType!);
            } catch (e) {
              // Account not found, track with minimal data
              _trackAccountUsageMinimal(ref, accountId, contextType!);
            }
          });
        }
        onChanged?.call(accountId);
      },
      isLoading: accountsAsync.isLoading,
      config: SelectorConfig(
        label: label ?? _getAccountTypeLabel(),
        hint: hint ?? _getAccountTypeHint(),
        errorText: errorText,
        showSearch: showSearch,
        showTransactionCount: showTransactionCount,
        icon: Icons.account_balance_wallet,
        emptyMessage: 'No ${_getAccountTypeLabel().toLowerCase()} available',
        searchHint: 'Search ${_getAccountTypeLabel().toLowerCase()}',
      ),
      itemTitleBuilder: (account) => account.displayName,
      itemSubtitleBuilder: (account) {
        // Only show category tag
        final parts = <String>[];
        if (account.categoryTag != null && account.categoryTag!.isNotEmpty) {
          parts.add(account.categoryTag!);
        }
        if (showTransactionCount && account.transactionCount > 0) {
          parts.add('${account.transactionCount} transactions');
        }
        return parts.isNotEmpty ? parts.join(' • ') : '';
      },
      itemIdBuilder: (account) => account.id,
      itemFilterBuilder: (account, query) {
        final queryLower = query.toLowerCase();
        return account.name.toLowerCase().contains(queryLower) ||
               account.type.toLowerCase().contains(queryLower) ||
               (account.categoryTag?.toLowerCase().contains(queryLower) ?? false);
      },
    );
  }

  String _getAccountTypeLabel() {
    if (accountType == null) return label ?? 'Account';
    switch (accountType!.toLowerCase()) {
      case 'asset':
        return 'Asset Account';
      case 'liability':
        return 'Liability Account';
      case 'equity':
        return 'Equity Account';
      case 'income':
        return 'Income Account';
      case 'expense':
        return 'Expense Account';
      default:
        return '${accountType!.capitalize()} Account';
    }
  }

  String _getAccountTypeHint() {
    if (accountType == null) return hint ?? 'All Accounts';
    switch (accountType!.toLowerCase()) {
      case 'asset':
        return 'Select Asset';
      case 'liability':
        return 'Select Liability';
      case 'equity':
        return 'Select Equity';
      case 'income':
        return 'Select Income';
      case 'expense':
        return 'Select Expense';
      default:
        return 'Select ${accountType!.capitalize()}';
    }
  }

  /// Track account usage for analytics - stores in accounts_preferences table
  void _trackAccountUsage(WidgetRef ref, AccountData account, String contextType) async {
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      // Use correct log_account_usage RPC parameters for accounts_preferences table
      await ref.read(supabaseServiceProvider).client.rpc('log_account_usage', params: {
        'p_account_id': account.id,
        'p_account_name': account.name,
        'p_company_id': appState.companyChoosen,
        'p_account_type': account.type,
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': contextType,
          'category_tag': account.categoryTag,
          'selection_source': 'autonomous_selector',
        },
      });
    } catch (e) {
      // Silent fail - don't interrupt user experience
    }
  }

  /// Track account usage with minimal data when account details not available
  void _trackAccountUsageMinimal(WidgetRef ref, String accountId, String contextType) async {
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      // Track with minimal data
      await ref.read(supabaseServiceProvider).client.rpc('log_account_usage', params: {
        'p_account_id': accountId,
        'p_account_name': 'Unknown Account',
        'p_company_id': appState.companyChoosen,
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': contextType,
          'selection_source': 'autonomous_selector',
          'note': 'minimal_tracking',
        },
      });
    } catch (e) {
      // Silent fail
    }
  }
}

/// Autonomous multi-account selector for multiple account selection
class AutonomousMultiAccountSelector extends ConsumerStatefulWidget {
  final List<String>? selectedAccountIds;
  final MultiSelectionCallback? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? accountType;

  const AutonomousMultiAccountSelector({
    super.key,
    this.selectedAccountIds,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.accountType,
  });

  @override
  ConsumerState<AutonomousMultiAccountSelector> createState() => _AutonomousMultiAccountSelectorState();
}

class _AutonomousMultiAccountSelectorState extends ConsumerState<AutonomousMultiAccountSelector> {
  List<String> _tempSelectedIds = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = widget.selectedAccountIds?.toList() ?? [];
  }

  @override
  void didUpdateWidget(AutonomousMultiAccountSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAccountIds != oldWidget.selectedAccountIds) {
      _tempSelectedIds = widget.selectedAccountIds?.toList() ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = widget.accountType != null
        ? ref.watch(currentAccountsByTypeProvider(widget.accountType!))
        : ref.watch(currentAccountsProvider);

    return TossMultiSelector<AccountData>(
      items: accountsAsync.maybeWhen(
        data: (accounts) => accounts,
        orElse: () => [],
      ),
      selectedIds: widget.selectedAccountIds ?? [],
      tempSelectedIds: _tempSelectedIds,
      onTempSelectionChanged: (ids) {
        setState(() {
          _tempSelectedIds = ids;
        });
      },
      onConfirm: () {
        widget.onChanged?.call(_tempSelectedIds);
      },
      onCancel: () {
        setState(() {
          _tempSelectedIds = widget.selectedAccountIds?.toList() ?? [];
        });
      },
      isLoading: accountsAsync.isLoading,
      config: SelectorConfig(
        label: widget.label ?? _getAccountTypeLabel(),
        hint: widget.hint ?? _getAccountTypeHint(),
        errorText: widget.errorText,
        showSearch: widget.showSearch,
        showTransactionCount: widget.showTransactionCount,
        icon: Icons.account_balance_wallet,
        emptyMessage: 'No ${_getAccountTypeLabel().toLowerCase()} available',
        searchHint: 'Search ${_getAccountTypeLabel().toLowerCase()}',
      ),
      itemTitleBuilder: (account) => account.displayName,
      itemSubtitleBuilder: (account) {
        // Only show category tag
        final parts = <String>[];
        if (account.categoryTag != null && account.categoryTag!.isNotEmpty) {
          parts.add(account.categoryTag!);
        }
        if (widget.showTransactionCount && account.transactionCount > 0) {
          parts.add('${account.transactionCount} transactions');
        }
        return parts.isNotEmpty ? parts.join(' • ') : '';
      },
      itemIdBuilder: (account) => account.id,
      itemFilterBuilder: (account, query) {
        final queryLower = query.toLowerCase();
        return account.name.toLowerCase().contains(queryLower) ||
               account.type.toLowerCase().contains(queryLower) ||
               (account.categoryTag?.toLowerCase().contains(queryLower) ?? false);
      },
    );
  }

  String _getAccountTypeLabel() {
    if (widget.accountType == null) return widget.label ?? 'Accounts';
    switch (widget.accountType!.toLowerCase()) {
      case 'asset':
        return 'Asset Accounts';
      case 'liability':
        return 'Liability Accounts';
      case 'equity':
        return 'Equity Accounts';
      case 'income':
        return 'Income Accounts';
      case 'expense':
        return 'Expense Accounts';
      default:
        return '${widget.accountType!.capitalize()} Accounts';
    }
  }

  String _getAccountTypeHint() {
    if (widget.accountType == null) return widget.hint ?? 'Select Accounts';
    return 'Select ${_getAccountTypeLabel()}';
  }
}

// Helper extension for string capitalization
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}