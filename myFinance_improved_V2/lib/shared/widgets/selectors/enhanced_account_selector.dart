// =====================================================
// ENHANCED ACCOUNT SELECTOR WITH QUICK ACCESS
// Modern, intuitive account selector with frequently used accounts
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/account_provider.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/core/utils/account_type_utils.dart';
import 'package:myfinance_improved/core/utils/quick_access_helper.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';

/// Enhanced account selector with quick access to frequently used accounts
class EnhancedAccountSelector extends ConsumerStatefulWidget {
  final String? selectedAccountId;
  final List<String>? selectedAccountIds;  // For multi-selection
  final Function(String?)? onChanged;
  final Function(List<String>?)? onMultiChanged;  // For multi-selection
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? accountType;
  final String? contextType;
  final bool showQuickAccess;
  final int maxQuickItems;
  final bool isMultiSelect;  // Enable multi-selection mode

  const EnhancedAccountSelector({
    super.key,
    this.selectedAccountId,
    this.selectedAccountIds,
    this.onChanged,
    this.onMultiChanged,
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

  @override
  ConsumerState<EnhancedAccountSelector> createState() => _EnhancedAccountSelectorState();
}

class _EnhancedAccountSelectorState extends ConsumerState<EnhancedAccountSelector> {
  String _searchQuery = '';
  List<AccountData> _filteredAccounts = [];
  List<Map<String, dynamic>> _quickAccessAccounts = [];
  List<String> _tempSelectedIds = [];  // For multi-selection

  @override
  void initState() {
    super.initState();
    if (widget.showQuickAccess) {
      _loadQuickAccessAccounts();
    }
    // Initialize temp selection for multi-select mode
    if (widget.isMultiSelect) {
      _tempSelectedIds = List<String>.from(widget.selectedAccountIds ?? []);
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
    // Get accounts based on type filter
    final accountsAsync = widget.accountType != null
        ? ref.watch(currentAccountsByTypeProvider(widget.accountType!))
        : ref.watch(currentAccountsProvider);

    // Handle loading state
    if (accountsAsync.isLoading) {
      return _buildLoadingSelector();
    }

    // Handle error state
    if (accountsAsync.hasError) {
      return _buildErrorSelector(accountsAsync.error.toString());
    }

    // Update filtered accounts
    final allAccounts = accountsAsync.maybeWhen(
      data: (accounts) => accounts,
      orElse: () => <AccountData>[],
    );

    _updateFilteredAccounts(allAccounts);

    // For multi-selection mode
    if (widget.isMultiSelect) {
      final selectedIds = widget.selectedAccountIds ?? [];

      return GestureDetector(
        onTap: () => _showSelectionBottomSheet(allAccounts),
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
                        color: selectedIds.isNotEmpty
                            ? TossColors.gray900
                            : TossColors.gray400,
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

    // Single selection mode (original behavior)
    AccountData? selectedAccount;
    if (widget.selectedAccountId != null) {
      accountsAsync.whenData((accounts) {
        try {
          selectedAccount = accounts.firstWhere((account) => account.id == widget.selectedAccountId);
        } catch (e) {
          selectedAccount = null;
        }
      });
    }

    return GestureDetector(
      onTap: () => _showSelectionBottomSheet(allAccounts),
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
                    selectedAccount?.displayName ?? widget.hint ?? AccountTypeUtils.getAccountTypeHint(widget.accountType, widget.hint, isPlural: false),
                    style: TossTextStyles.body.copyWith(
                      color: selectedAccount != null ? TossColors.textPrimary : TossColors.textTertiary,
                      fontWeight: selectedAccount != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (selectedAccount?.categoryTag != null && selectedAccount!.categoryTag!.isNotEmpty)
                    Text(
                      selectedAccount!.categoryTag!,
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

  void _updateFilteredAccounts(List<AccountData> allAccounts) {
    List<AccountData> filtered;
    if (_searchQuery.isEmpty) {
      filtered = allAccounts;
    } else {
      final queryLower = _searchQuery.toLowerCase();
      filtered = allAccounts.where((account) {
        return account.name.toLowerCase().contains(queryLower) ||
               account.type.toLowerCase().contains(queryLower) ||
               (account.categoryTag?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    }

    // Sort accounts by type for proper grouping in multi-select mode
    if (widget.isMultiSelect) {
      _filteredAccounts = filtered..sort((a, b) {
        int typeCompare = a.type.compareTo(b.type);
        if (typeCompare != 0) return typeCompare;
        return a.name.compareTo(b.name);
      });
    } else {
      _filteredAccounts = filtered;
    }
  }

  void _showSelectionBottomSheet(List<AccountData> allAccounts) {
    // Initialize temp selection for multi-select mode
    if (widget.isMultiSelect) {
      _tempSelectedIds = List<String>.from(widget.selectedAccountIds ?? []);
    }
    _searchQuery = '';
    _updateFilteredAccounts(allAccounts);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => TossBottomSheet(
          content: StatefulBuilder(
            builder: (context, setModalState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.isMultiSelect
                            ? 'Select Accounts'
                            : 'Select ${widget.label ?? AccountTypeUtils.getAccountTypeLabel(widget.accountType, widget.label, isPlural: false)}',
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: TossColors.gray700),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: TossSpacing.space3),

                // Search field
                if (widget.showSearch) ...[
                  TossSearchField(
                    hintText: 'Search accounts...',
                    onChanged: (value) {
                      setModalState(() {
                        _searchQuery = value;
                        _updateFilteredAccounts(allAccounts);
                      });
                    },
                  ),
                  const SizedBox(height: TossSpacing.space3),
                ],

                // Multi-select controls
                if (widget.isMultiSelect) ...[
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _tempSelectedIds = _filteredAccounts.map((a) => a.id).toList();
                          });
                        },
                        child: Text(
                          'Select All',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _tempSelectedIds.clear();
                          });
                        },
                        child: Text(
                          'Deselect All',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_tempSelectedIds.length} selected',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space2),
                ],

                // Main content with quick access and regular list
                Flexible(
                  child: _buildAccountList(allAccounts, scrollController, setModalState),
                ),

                // Action buttons for multi-select
                if (widget.isMultiSelect) ...[
                  const SizedBox(height: TossSpacing.space4),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            widget.onMultiChanged?.call(null);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Clear',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onMultiChanged?.call(
                              _tempSelectedIds.isEmpty ? null : _tempSelectedIds,
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            foregroundColor: TossColors.white,
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                          ),
                          child: Text(
                            'Apply (${_tempSelectedIds.length})',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountList(List<AccountData> allAccounts, ScrollController scrollController, [StateSetter? setModalState]) {
    if (_filteredAccounts.isEmpty && _searchQuery.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Center(
          child: Text(
            'No results found',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      controller: scrollController,
      shrinkWrap: true,
      children: [
        // Quick Access Section (only show when not searching)
        if (widget.showQuickAccess && _searchQuery.isEmpty && _quickAccessAccounts.isNotEmpty && !widget.isMultiSelect) ...[
          _buildQuickAccessSection(allAccounts),
          const SizedBox(height: TossSpacing.space2),
          Container(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space2),
        ],

        // Quick Access for Multi-Select Mode
        if (widget.showQuickAccess && _searchQuery.isEmpty && _quickAccessAccounts.isNotEmpty && widget.isMultiSelect) ...[
          _buildQuickAccessSectionMultiSelect(allAccounts, setModalState),
          const SizedBox(height: TossSpacing.space2),
          Container(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space2),
        ],

        // Regular accounts section header
        if (_searchQuery.isEmpty && _quickAccessAccounts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            child: Text(
              'All Accounts',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Regular accounts list
        if (!widget.isMultiSelect) ...[
          // Single selection mode - simple list
          ..._filteredAccounts.map((account) => _buildAccountItem(account, false)),
        ] else ...[
          // Multi-selection mode - with group headers
          ..._buildGroupedAccountsList(setModalState),
        ],
      ],
    );
  }

  Widget _buildQuickAccessSectionMultiSelect(List<AccountData> allAccounts, StateSetter? setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space2,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.flash_on,
                size: TossSpacing.iconXS,
                color: TossColors.warning,
              ),
              const SizedBox(width: TossSpacing.space1),
              Text(
                'Frequently Used',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ..._quickAccessAccounts.map((quickAccount) {
          final accountId = quickAccount['account_id'] as String?;
          if (accountId == null) return const SizedBox.shrink();

          try {
            final account = allAccounts.firstWhere((a) => a.id == accountId);
            final usageCount = quickAccount['usage_count'] as int? ?? 0;
            final isSelected = _tempSelectedIds.contains(account.id);

            return InkWell(
              onTap: () {
                setModalState?.call(() {
                  if (isSelected) {
                    _tempSelectedIds.remove(account.id);
                  } else {
                    _tempSelectedIds.add(account.id);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: TossSpacing.iconSM,
                          color: isSelected ? TossColors.primary : TossColors.gray500,
                        ),
                        if (usageCount > 5)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: TossColors.warning,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  account.name,
                                  style: TossTextStyles.body.copyWith(
                                    color: isSelected ? TossColors.primary : TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (usageCount > 0) ...[
                                const SizedBox(width: TossSpacing.space2),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TossColors.warning.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  ),
                                  child: Text(
                                    '$usageCount×',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.warning,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            account.categoryTag ?? account.type,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setModalState?.call(() {
                          if (value == true) {
                            _tempSelectedIds.add(account.id);
                          } else {
                            _tempSelectedIds.remove(account.id);
                          }
                        });
                      },
                      activeColor: TossColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
            );
          } catch (e) {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  Widget _buildQuickAccessSection(List<AccountData> allAccounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space2,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.flash_on,
                size: TossSpacing.iconXS,
                color: TossColors.warning,
              ),
              const SizedBox(width: TossSpacing.space1),
              Text(
                'Frequently Used',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ..._quickAccessAccounts.map((quickAccount) {
          // Find the full account data
          final accountId = quickAccount['account_id'] as String?;
          if (accountId == null) return const SizedBox.shrink();

          try {
            final account = allAccounts.firstWhere((a) => a.id == accountId);
            return _buildAccountItem(
              account,
              true,
              usageCount: quickAccount['usage_count'] as int? ?? 0,
            );
          } catch (e) {
            // Account not found in current list, show basic info
            return _buildQuickAccountItem(quickAccount);
          }
        }),
      ],
    );
  }

  List<Widget> _buildGroupedAccountsList(StateSetter? setModalState) {
    final List<Widget> widgets = [];
    String? currentType;

    for (int i = 0; i < _filteredAccounts.length; i++) {
      final account = _filteredAccounts[i];

      // Add group header if account type changes
      if (currentType != account.type) {
        currentType = account.type;

        // Add spacing before new section (except first)
        if (widgets.isNotEmpty) {
          widgets.add(const SizedBox(height: TossSpacing.space2));
          widgets.add(Container(height: 1, color: TossColors.gray200));
          widgets.add(const SizedBox(height: TossSpacing.space2));
        }

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            child: Text(
              _getAccountTypeLabel(account.type),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }

      // Add account item with checkbox
      final isSelected = _tempSelectedIds.contains(account.id);
      widgets.add(
        InkWell(
          onTap: () {
            setModalState?.call(() {
              if (isSelected) {
                _tempSelectedIds.remove(account.id);
              } else {
                _tempSelectedIds.add(account.id);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
            child: Row(
              children: [
                Icon(
                  _getAccountTypeIcon(account.type),
                  size: TossSpacing.iconSM,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: TossTextStyles.body.copyWith(
                          color: isSelected ? TossColors.primary : TossColors.gray900,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      Text(
                        account.categoryTag ?? account.type,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setModalState?.call(() {
                      if (value == true) {
                        _tempSelectedIds.add(account.id);
                      } else {
                        _tempSelectedIds.remove(account.id);
                      }
                    });
                  },
                  activeColor: TossColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  // Helper method to get account type label
  String _getAccountTypeLabel(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'asset':
        return 'Assets';
      case 'liability':
        return 'Liabilities';
      case 'equity':
        return 'Equity';
      case 'income':
        return 'Income';
      case 'expense':
        return 'Expenses';
      default:
        return accountType[0].toUpperCase() + accountType.substring(1);
    }
  }

  // Helper method to get account type icon
  IconData _getAccountTypeIcon(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'asset':
        return Icons.account_balance_wallet;
      case 'liability':
        return Icons.credit_card;
      case 'equity':
        return Icons.balance;
      case 'income':
        return Icons.trending_up;
      case 'expense':
        return Icons.trending_down;
      default:
        return Icons.account_balance;
    }
  }

  Widget _buildAccountItem(AccountData account, bool isQuickAccess, {int usageCount = 0}) {
    // For multi-select mode, this is handled in _buildGroupedAccountsList
    if (widget.isMultiSelect) return const SizedBox.shrink();

    final isSelected = account.id == widget.selectedAccountId;

    return InkWell(
      onTap: () {
        _trackAccountUsage(account, isQuickAccess ? 'quick_access' : 'regular_list');
        widget.onChanged?.call(account.id);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
        child: Row(
          children: [
            // Icon with frequency indicator
            Stack(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: TossSpacing.iconSM,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
                if (isQuickAccess && usageCount > 5)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: TossColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: TossSpacing.space3),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          account.displayName,
                          style: TossTextStyles.body.copyWith(
                            color: isSelected ? TossColors.primary : TossColors.gray900,
                            fontWeight: isSelected || isQuickAccess ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isQuickAccess && usageCount > 0) ...[
                        const SizedBox(width: TossSpacing.space2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Text(
                            '$usageCount×',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.warning,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (account.categoryTag != null && account.categoryTag!.isNotEmpty)
                    Text(
                      account.categoryTag!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  if (widget.showTransactionCount && account.transactionCount > 0)
                    Text(
                      '${account.transactionCount} transactions',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray400,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: TossSpacing.iconSM,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccountItem(Map<String, dynamic> quickAccount) {
    final accountName = (quickAccount['account_name'] ?? 'Unknown Account') as String;
    final accountId = quickAccount['account_id'] as String?;
    final usageCount = quickAccount['usage_count'] as int? ?? 0;
    final isSelected = accountId == widget.selectedAccountId;

    return InkWell(
      onTap: () {
        if (accountId != null) {
          _trackQuickAccountUsage(quickAccount);
          widget.onChanged?.call(accountId);
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
        child: Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: TossSpacing.iconSM,
              color: isSelected ? TossColors.primary : TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                accountName,
                style: TossTextStyles.body.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (usageCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Text(
                  '$usageCount×',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
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

  void _trackQuickAccountUsage(Map<String, dynamic> quickAccount) async {
    await QuickAccessHelper.trackQuickAccountUsage(
      ref,
      quickAccount,
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
          const SizedBox(
            width: 16,
            height: 16,
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
        // Try to refresh the data
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
