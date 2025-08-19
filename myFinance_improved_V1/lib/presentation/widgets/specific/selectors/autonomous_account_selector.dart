// =====================================================
// AUTONOMOUS ACCOUNT SELECTOR
// Truly reusable account selector using entity providers
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../providers/entities/account_provider.dart';
import 'toss_base_selector.dart';

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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onChanged: onChanged,
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