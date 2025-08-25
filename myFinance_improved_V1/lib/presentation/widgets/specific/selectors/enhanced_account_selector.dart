// =====================================================
// ENHANCED ACCOUNT SELECTOR WITH QUICK ACCESS
// Modern, intuitive account selector with frequently used accounts
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../../data/services/supabase_service.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/entities/account_provider.dart';
import '../../../providers/quick_access_provider.dart';
import '../../toss/toss_bottom_sheet.dart';
import '../../toss/toss_search_field.dart';

/// Enhanced account selector with quick access to frequently used accounts
class EnhancedAccountSelector extends ConsumerStatefulWidget {
  final String? selectedAccountId;
  final Function(String?)? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? accountType;
  final String? contextType;
  final bool showQuickAccess;
  final int maxQuickItems;

  const EnhancedAccountSelector({
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
    this.showQuickAccess = true,
    this.maxQuickItems = 5,
  });

  @override
  ConsumerState<EnhancedAccountSelector> createState() => _EnhancedAccountSelectorState();
}

class _EnhancedAccountSelectorState extends ConsumerState<EnhancedAccountSelector> {
  String _searchQuery = '';
  List<AccountData> _filteredAccounts = [];
  List<Map<String, dynamic>> _quickAccessAccounts = [];
  bool _isLoadingQuickAccess = false;

  @override
  void initState() {
    super.initState();
    if (widget.showQuickAccess) {
      _loadQuickAccessAccounts();
    }
  }

  Future<void> _loadQuickAccessAccounts() async {
    if (!widget.showQuickAccess) return;
    
    setState(() => _isLoadingQuickAccess = true);
    
    try {
      final quickAccessAsync = await ref.read(
        quickAccessAccountsProvider(
          contextType: widget.contextType,
          limit: widget.maxQuickItems,
        ).future,
      );
      
      if (mounted) {
        setState(() {
          _quickAccessAccounts = quickAccessAsync;
          _isLoadingQuickAccess = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingQuickAccess = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get accounts based on type filter
    final accountsAsync = widget.accountType != null
        ? ref.watch(currentAccountsByTypeProvider(widget.accountType!))
        : ref.watch(currentAccountsProvider);

    // Find selected account
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
              size: 20,
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
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Text(
                    selectedAccount?.displayName ?? widget.hint ?? _getAccountTypeHint(),
                    style: TossTextStyles.body.copyWith(
                      color: selectedAccount != null ? TossColors.gray900 : TossColors.gray500,
                      fontWeight: selectedAccount != null ? FontWeight.w500 : FontWeight.normal,
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
            Icon(
              Icons.arrow_drop_down,
              color: TossColors.gray700,
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
                        'Select ${widget.label ?? _getAccountTypeLabel()}',
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
                  child: _buildAccountList(allAccounts, scrollController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountList(List<AccountData> allAccounts, ScrollController scrollController) {
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
          _buildQuickAccessSection(allAccounts),
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
        ..._filteredAccounts.map((account) => _buildAccountItem(account, false)),
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
              Icon(
                Icons.flash_on,
                size: 16,
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
        }).toList(),
      ],
    );
  }

  Widget _buildAccountItem(AccountData account, bool isQuickAccess, {int usageCount = 0}) {
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
                  size: 20,
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
            
            // Selection indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccountItem(Map<String, dynamic> quickAccount) {
    final accountName = quickAccount['account_name'] ?? 'Unknown Account';
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
              size: 20,
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
    if (widget.contextType == null) return;
    
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      await ref.read(supabaseServiceProvider).client.rpc('log_account_usage', params: {
        'p_account_id': account.id,
        'p_account_name': account.name,
        'p_company_id': appState.companyChoosen,
        'p_account_type': account.type,
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': widget.contextType!,
          'category_tag': account.categoryTag,
          'selection_source': selectionSource,
        },
      });
    } catch (e) {
      // Silent fail
    }
  }

  void _trackQuickAccountUsage(Map<String, dynamic> quickAccount) async {
    if (widget.contextType == null) return;
    
    try {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isEmpty) return;

      await ref.read(supabaseServiceProvider).client.rpc('log_account_usage', params: {
        'p_account_id': quickAccount['account_id'],
        'p_account_name': quickAccount['account_name'] ?? 'Quick Access Account',
        'p_company_id': appState.companyChoosen,
        'p_account_type': quickAccount['account_type'],
        'p_usage_type': 'selected',
        'p_metadata': {
          'context': widget.contextType!,
          'selection_source': 'quick_access',
        },
      });
    } catch (e) {
      // Silent fail
    }
  }

  String _getAccountTypeLabel() {
    if (widget.accountType == null) return widget.label ?? 'Account';
    switch (widget.accountType!.toLowerCase()) {
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
        return '${widget.accountType!} Account';
    }
  }

  String _getAccountTypeHint() {
    if (widget.accountType == null) return widget.hint ?? 'Select account';
    return 'Select ${widget.accountType}';
  }
}

// Extension for string capitalization
extension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}