/// Account Selector
///
/// Autonomous account selector widget with quick access to frequently used accounts.
/// Uses Riverpod providers internally for automatic data fetching.
///
/// ## Basic Usage
/// ```dart
/// AccountSelector(
///   selectedAccountId: _selectedId,
///   onAccountSelected: (account) {
///     setState(() {
///       _selectedId = account.id;
///       _accountName = account.name;
///     });
///   },
/// )
/// ```
///
/// ## Multi-Selection
/// ```dart
/// AccountSelector.multi(
///   selectedAccountIds: _selectedIds,
///   onMultiAccountSelected: (accounts) {
///     setState(() {
///       _selectedIds = accounts.map((a) => a.id).toList();
///     });
///   },
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/account_provider.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/core/utils/account_type_utils.dart';
import 'package:myfinance_improved/core/utils/quick_access_helper.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'account_selector_sheet.dart';
import 'account_multi_select.dart';

/// Type definitions for callbacks
typedef OnAccountSelectedCallback = void Function(AccountData account);
typedef OnMultiAccountSelectedCallback = void Function(List<AccountData> accounts);

/// Account selector widget with quick access to frequently used accounts
class AccountSelector extends ConsumerStatefulWidget {
  final String? selectedAccountId;
  final List<String>? selectedAccountIds;

  // Legacy callbacks (deprecated but maintained for backward compatibility)
  final void Function(String?)? onChanged;
  final void Function(String?, Map<String, dynamic>?)? onChangedWithData;
  final void Function(List<String>?)? onMultiChanged;

  // NEW: Type-safe callbacks
  final OnAccountSelectedCallback? onAccountSelected;
  final OnMultiAccountSelectedCallback? onMultiAccountSelected;

  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? accountType;
  final String? contextType;
  final bool showQuickAccess;
  final int maxQuickItems;
  final bool isMultiSelect;

  const AccountSelector({
    super.key,
    this.selectedAccountId,
    this.selectedAccountIds,
    this.onChanged,
    this.onChangedWithData,
    this.onMultiChanged,
    this.onAccountSelected,
    this.onMultiAccountSelected,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.accountType,
    this.contextType,
    this.showQuickAccess = true,
    this.maxQuickItems = 5,
    this.isMultiSelect = false,
  });

  /// Multi-selection mode constructor
  const AccountSelector.multi({
    super.key,
    this.selectedAccountIds,
    this.onMultiChanged,
    this.onMultiAccountSelected,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.accountType,
    this.contextType,
    this.showQuickAccess = true,
    this.maxQuickItems = 5,
  })  : selectedAccountId = null,
        onChanged = null,
        onChangedWithData = null,
        onAccountSelected = null,
        isMultiSelect = true;

  @override
  ConsumerState<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends ConsumerState<AccountSelector> {
  List<QuickAccessAccount> _quickAccessAccounts = [];

  @override
  void initState() {
    super.initState();
    if (widget.showQuickAccess) {
      _loadQuickAccessAccounts();
    }
  }

  Future<void> _loadQuickAccessAccounts() async {
    if (!widget.showQuickAccess) return;

    final quickAccounts = await QuickAccessHelper.loadQuickAccessAccounts(
      ref,
      contextType: widget.contextType,
      maxQuickItems: widget.maxQuickItems,
    );

    if (mounted) {
      setState(() {
        _quickAccessAccounts = quickAccounts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = widget.accountType != null
        ? ref.watch(currentAccountsByTypeProvider(widget.accountType!))
        : ref.watch(currentAccountsProvider);

    if (accountsAsync.isLoading) {
      return _buildLoadingSelector();
    }

    if (accountsAsync.hasError) {
      return _buildErrorSelector(accountsAsync.error.toString());
    }

    final allAccounts = accountsAsync.maybeWhen(
      data: (accounts) => accounts,
      orElse: () => <AccountData>[],
    );

    if (widget.isMultiSelect) {
      return _buildMultiSelectTrigger(allAccounts);
    }

    return _buildSingleSelectTrigger(allAccounts);
  }

  Widget _buildSingleSelectTrigger(List<AccountData> allAccounts) {
    AccountData? selectedAccount;
    if (widget.selectedAccountId != null) {
      try {
        selectedAccount = allAccounts.firstWhere(
          (account) => account.id == widget.selectedAccountId,
        );
      } catch (e) {
        selectedAccount = null;
      }
    }

    return GestureDetector(
      onTap: () => _showSingleSelectionSheet(allAccounts),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: widget.errorText != null ? TossColors.error : TossColors.border,
            width: widget.errorText != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: TossSpacing.iconSM,
              color: selectedAccount != null ? TossColors.primary : TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  Text(
                    selectedAccount?.displayName ??
                        widget.hint ??
                        AccountTypeUtils.getAccountTypeHint(widget.accountType, widget.hint, isPlural: false),
                    style: TossTextStyles.body.copyWith(
                      color: selectedAccount != null ? TossColors.textPrimary : TossColors.textTertiary,
                      fontWeight: selectedAccount != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (selectedAccount?.categoryTag != null && selectedAccount!.categoryTag!.isNotEmpty)
                    Text(
                      selectedAccount.categoryTag!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: TossColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectTrigger(List<AccountData> allAccounts) {
    final selectedIds = widget.selectedAccountIds ?? [];

    return GestureDetector(
      onTap: () => _showMultiSelectionSheet(allAccounts),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: widget.errorText != null ? TossColors.error : TossColors.border,
            width: widget.errorText != null ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  Text(
                    selectedIds.isNotEmpty
                        ? '${selectedIds.length} accounts selected'
                        : widget.hint ?? 'All Accounts',
                    style: TossTextStyles.body.copyWith(
                      color: selectedIds.isNotEmpty ? TossColors.gray900 : TossColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: TossColors.gray500,
            ),
          ],
        ),
      ),
    );
  }

  void _showSingleSelectionSheet(List<AccountData> allAccounts) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      builder: (context) => AccountSelectorSheet(
        accounts: allAccounts,
        quickAccessAccounts: _quickAccessAccounts,
        selectedAccountId: widget.selectedAccountId,
        onAccountSelected: (account) {
          _trackAccountUsage(account, 'regular_list');
          widget.onAccountSelected?.call(account);
          widget.onChanged?.call(account.id);
          widget.onChangedWithData?.call(account.id, account.toJson());
        },
        label: widget.label,
        accountType: widget.accountType,
        showSearch: widget.showSearch,
        showQuickAccess: widget.showQuickAccess,
        showTransactionCount: widget.showTransactionCount,
      ),
    );
  }

  void _showMultiSelectionSheet(List<AccountData> allAccounts) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => AccountMultiSelectSheet(
          accounts: allAccounts,
          quickAccessAccounts: _quickAccessAccounts,
          selectedIds: widget.selectedAccountIds ?? [],
          onSelectionConfirmed: (ids) {
            if (ids.isEmpty) {
              widget.onMultiChanged?.call(null);
            } else {
              widget.onMultiChanged?.call(ids);

              // Build full account list for type-safe callback
              final selectedAccounts = allAccounts
                  .where((a) => ids.contains(a.id))
                  .toList();
              widget.onMultiAccountSelected?.call(selectedAccounts);
            }
          },
          label: widget.label,
          showSearch: widget.showSearch,
          showQuickAccess: widget.showQuickAccess,
        ),
      ),
    );
  }

  void _trackAccountUsage(AccountData account, String selectionSource) async {
    await QuickAccessHelper.trackAccountUsage(
      ref,
      account,
      selectionSource,
      contextType: widget.contextType,
    );
  }

  Widget _buildLoadingSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: TossSpacing.iconSM2,
            height: TossSpacing.iconSM2,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Text(
            'Loading accounts...',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSelector(String error) {
    return GestureDetector(
      onTap: () {
        ref.invalidate(currentAccountsProvider);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.errorLight,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.error,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              size: TossSpacing.iconSM,
              color: TossColors.error,
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Failed to load accounts',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Tap to retry',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.refresh,
              size: TossSpacing.iconSM,
              color: TossColors.error,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY
// ═══════════════════════════════════════════════════════════════

/// @Deprecated: Use [AccountSelector] instead. Will be removed in v2.0
@Deprecated('Use AccountSelector instead. Will be removed in v2.0')
typedef EnhancedAccountSelector = AccountSelector;
