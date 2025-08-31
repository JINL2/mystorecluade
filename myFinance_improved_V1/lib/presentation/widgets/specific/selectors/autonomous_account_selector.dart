// =====================================================
// AUTONOMOUS ACCOUNT SELECTOR
// Truly reusable account selector using entity providers
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../providers/entities/account_provider.dart';
import 'toss_base_selector.dart';
import 'selector_utils.dart';

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
        label: label ?? AccountTypeUtils.getAccountTypeLabel(accountType, label, isPlural: false),
        hint: hint ?? AccountTypeUtils.getAccountTypeHint(accountType, hint, isPlural: false),
        errorText: errorText,
        showSearch: showSearch,
        showTransactionCount: showTransactionCount,
        icon: Icons.account_balance_wallet,
        emptyMessage: 'No ${AccountTypeUtils.getAccountTypeLabel(accountType, label, isPlural: false).toLowerCase()} available',
        searchHint: 'Search ${AccountTypeUtils.getAccountTypeLabel(accountType, label, isPlural: false).toLowerCase()}',
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
    );
  }


  /// Track account usage for analytics
  void _trackAccountUsage(WidgetRef ref, AccountData account, String contextType) async {
    await QuickAccessHelper.trackAccountUsage(
      ref,
      account,
      'autonomous_selector',
      contextType: contextType,
    );
  }

  /// Track account usage with minimal data when account details not available
  void _trackAccountUsageMinimal(WidgetRef ref, String accountId, String contextType) async {
    await QuickAccessHelper.trackAccountUsageMinimal(
      ref,
      accountId,
      contextType: contextType,
    );
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
        label: widget.label ?? AccountTypeUtils.getAccountTypeLabel(widget.accountType, widget.label, isPlural: true),
        hint: widget.hint ?? AccountTypeUtils.getAccountTypeHint(widget.accountType, widget.hint, isPlural: true),
        errorText: widget.errorText,
        showSearch: widget.showSearch,
        showTransactionCount: widget.showTransactionCount,
        icon: Icons.account_balance_wallet,
        emptyMessage: 'No ${AccountTypeUtils.getAccountTypeLabel(widget.accountType, widget.label, isPlural: true).toLowerCase()} available',
        searchHint: 'Search ${AccountTypeUtils.getAccountTypeLabel(widget.accountType, widget.label, isPlural: true).toLowerCase()}',
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
    );
  }

}