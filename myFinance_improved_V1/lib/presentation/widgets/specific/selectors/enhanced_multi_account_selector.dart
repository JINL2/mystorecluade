// =====================================================
// ENHANCED MULTI ACCOUNT SELECTOR WITH QUICK ACCESS
// Multi-select account selector with frequently used accounts
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/entities/account_provider.dart';
import '../../toss/toss_bottom_sheet.dart';
import '../../toss/toss_search_field.dart';
import '../../toss/toss_primary_button.dart';
import '../../toss/toss_secondary_button.dart';
import 'selector_utils.dart';

typedef MultiSelectionCallback = void Function(List<String>?);

/// Enhanced multi-account selector with quick access to frequently used accounts
class EnhancedMultiAccountSelector extends ConsumerStatefulWidget {
  final List<String>? selectedAccountIds;
  final MultiSelectionCallback? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? accountType;
  final String? contextType;
  final bool showQuickAccess;
  final int maxQuickItems;

  const EnhancedMultiAccountSelector({
    super.key,
    this.selectedAccountIds,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.accountType,
    this.contextType,
    this.showQuickAccess = true,
    this.maxQuickItems = 5,
  });

  @override
  ConsumerState<EnhancedMultiAccountSelector> createState() => _EnhancedMultiAccountSelectorState();
}

class _EnhancedMultiAccountSelectorState extends ConsumerState<EnhancedMultiAccountSelector> {
  String _searchQuery = '';
  List<AccountData> _filteredAccounts = [];
  List<Map<String, dynamic>> _quickAccessAccounts = [];
  List<String> _tempSelectedIds = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = widget.selectedAccountIds?.toList() ?? [];
    if (widget.showQuickAccess) {
      _loadQuickAccessAccounts();
    }
  }

  @override
  void didUpdateWidget(EnhancedMultiAccountSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAccountIds != oldWidget.selectedAccountIds) {
      _tempSelectedIds = widget.selectedAccountIds?.toList() ?? [];
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

    // Find selected accounts
    List<AccountData> selectedAccounts = [];
    if (widget.selectedAccountIds != null && widget.selectedAccountIds!.isNotEmpty) {
      accountsAsync.whenData((accounts) {
        selectedAccounts = accounts.where((account) => 
          widget.selectedAccountIds!.contains(account.id)
        ).toList();
      });
    }

    // Update filtered accounts
    final allAccounts = accountsAsync.maybeWhen(
      data: (accounts) => accounts,
      orElse: () => <AccountData>[],
    );
    
    _updateFilteredAccounts(allAccounts);

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
              color: selectedAccounts.isNotEmpty ? TossColors.primary : TossColors.gray500,
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
                    selectedAccounts.isNotEmpty 
                        ? '${selectedAccounts.length} account${selectedAccounts.length > 1 ? 's' : ''} selected'
                        : widget.hint ?? AccountTypeUtils.getAccountTypeHint(widget.accountType, widget.hint, isPlural: true),
                    style: TossTextStyles.body.copyWith(
                      color: selectedAccounts.isNotEmpty ? TossColors.textPrimary : TossColors.textTertiary,
                      fontWeight: selectedAccounts.isNotEmpty ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (selectedAccounts.length == 1 && selectedAccounts.first.categoryTag != null && selectedAccounts.first.categoryTag!.isNotEmpty)
                    Text(
                      selectedAccounts.first.categoryTag!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: TossColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _updateFilteredAccounts(List<AccountData> allAccounts) {
    if (_searchQuery.isEmpty) {
      _filteredAccounts = allAccounts;
    } else {
      final queryLower = _searchQuery.toLowerCase();
      _filteredAccounts = allAccounts.where((account) {
        return account.name.toLowerCase().contains(queryLower) ||
               account.type.toLowerCase().contains(queryLower) ||
               (account.categoryTag?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    }
  }

  void _showSelectionBottomSheet(List<AccountData> allAccounts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
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
                        'Select ${widget.label ?? AccountTypeUtils.getAccountTypeLabel(widget.accountType, widget.label, isPlural: true)}',
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
                    hintText: 'Search accounts',
                    onChanged: (value) {
                      setModalState(() {
                        _searchQuery = value;
                        _updateFilteredAccounts(allAccounts);
                      });
                    },
                  ),
                  const SizedBox(height: TossSpacing.space3),
                ],
                
                // Main content with quick access and regular list
                Flexible(
                  child: _buildAccountList(allAccounts, scrollController, setModalState),
                ),
                
                const SizedBox(height: TossSpacing.space4),
                
                // Action buttons for multi-select
                Row(
                  children: [
                    Expanded(
                      child: TossSecondaryButton(
                        text: 'Cancel',
                        onPressed: () {
                          setState(() {
                            _tempSelectedIds = widget.selectedAccountIds?.toList() ?? [];
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: TossPrimaryButton(
                        text: 'Apply (${_tempSelectedIds.length})',
                        onPressed: () {
                          widget.onChanged?.call(_tempSelectedIds);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountList(List<AccountData> allAccounts, ScrollController scrollController, StateSetter setModalState) {
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
        if (widget.showQuickAccess && _searchQuery.isEmpty && _quickAccessAccounts.isNotEmpty) ...[
          _buildQuickAccessSection(allAccounts, setModalState),
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
        ..._filteredAccounts.map((account) => _buildAccountItem(account, false, setModalState)),
      ],
    );
  }

  Widget _buildQuickAccessSection(List<AccountData> allAccounts, StateSetter setModalState) {
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
              Icon(
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
              setModalState,
              usageCount: quickAccount['usage_count'] as int? ?? 0,
            );
          } catch (e) {
            // Account not found in current list, show basic info
            return _buildQuickAccountItem(quickAccount, setModalState);
          }
        }).toList(),
      ],
    );
  }

  Widget _buildAccountItem(AccountData account, bool isQuickAccess, StateSetter setModalState, {int usageCount = 0}) {
    final isSelected = _tempSelectedIds.contains(account.id);
    
    return InkWell(
      onTap: () {
        setModalState(() {
          if (isSelected) {
            _tempSelectedIds.remove(account.id);
          } else {
            _tempSelectedIds.add(account.id);
          }
        });
        setState(() {}); // Update main widget display
        
        if (!isSelected) { // Only track when selecting, not deselecting
          _trackAccountUsage(account, isQuickAccess ? 'quick_access' : 'regular_list');
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
            // Selection checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? TossColors.primary : TossColors.white,
                border: Border.all(
                  color: isSelected ? TossColors.primary : TossColors.gray300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: TossSpacing.iconXS - 2,
                      color: TossColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: TossSpacing.space3),
            
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
                      decoration: BoxDecoration(
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${usageCount}×',
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccountItem(Map<String, dynamic> quickAccount, StateSetter setModalState) {
    final accountName = quickAccount['account_name'] ?? 'Unknown Account';
    final accountId = quickAccount['account_id'] as String?;
    final usageCount = quickAccount['usage_count'] as int? ?? 0;
    final isSelected = accountId != null && _tempSelectedIds.contains(accountId);
    
    return InkWell(
      onTap: () {
        if (accountId != null) {
          setModalState(() {
            if (isSelected) {
              _tempSelectedIds.remove(accountId);
            } else {
              _tempSelectedIds.add(accountId);
            }
          });
          setState(() {}); // Update main widget display
          
          if (!isSelected) { // Only track when selecting, not deselecting
            _trackQuickAccountUsage(quickAccount);
          }
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
            // Selection checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? TossColors.primary : TossColors.white,
                border: Border.all(
                  color: isSelected ? TossColors.primary : TossColors.gray300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: TossSpacing.iconXS - 2,
                      color: TossColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: TossSpacing.space3),
            
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${usageCount}×',
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
      selectionType: 'multi_select',
    );
  }

  void _trackQuickAccountUsage(Map<String, dynamic> quickAccount) async {
    await QuickAccessHelper.trackQuickAccountUsage(
      ref,
      quickAccount,
      contextType: widget.contextType,
      selectionType: 'multi_select',
    );
  }

}