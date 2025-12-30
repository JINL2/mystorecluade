/// Account Selector Bottom Sheet
///
/// Bottom sheet container for account selection.
/// Contains search, quick access, and account list sections.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/core/utils/account_type_utils.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';

import 'account_quick_access.dart';

/// Bottom sheet for single account selection
class AccountSelectorSheet extends StatefulWidget {
  final List<AccountData> accounts;
  final List<QuickAccessAccount> quickAccessAccounts;
  final String? selectedAccountId;
  final void Function(AccountData account) onAccountSelected;
  final String? label;
  final String? accountType;
  final bool showSearch;
  final bool showQuickAccess;
  final bool showTransactionCount;

  const AccountSelectorSheet({
    super.key,
    required this.accounts,
    required this.quickAccessAccounts,
    required this.selectedAccountId,
    required this.onAccountSelected,
    this.label,
    this.accountType,
    this.showSearch = true,
    this.showQuickAccess = true,
    this.showTransactionCount = true,
  });

  @override
  State<AccountSelectorSheet> createState() => _AccountSelectorSheetState();
}

class _AccountSelectorSheetState extends State<AccountSelectorSheet> {
  String _searchQuery = '';
  List<AccountData> _filteredAccounts = [];

  @override
  void initState() {
    super.initState();
    _filteredAccounts = widget.accounts;
  }

  void _updateFilteredAccounts() {
    if (_searchQuery.isEmpty) {
      _filteredAccounts = widget.accounts;
    } else {
      final queryLower = _searchQuery.toLowerCase();
      _filteredAccounts = widget.accounts.where((account) {
        return account.name.toLowerCase().contains(queryLower) ||
               account.type.toLowerCase().contains(queryLower) ||
               (account.categoryTag?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => TossBottomSheet(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: TossSpacing.space3),
            if (widget.showSearch) ...[
              _buildSearchField(),
              const SizedBox(height: TossSpacing.space3),
            ],
            Flexible(
              child: _buildContent(scrollController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Select ${widget.label ?? AccountTypeUtils.getAccountTypeLabel(widget.accountType, widget.label, isPlural: false)}',
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
    );
  }

  Widget _buildSearchField() {
    return TossSearchField(
      hintText: 'Search accounts...',
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          _updateFilteredAccounts();
        });
      },
    );
  }

  Widget _buildContent(ScrollController scrollController) {
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
        // Quick Access Section
        if (widget.showQuickAccess &&
            _searchQuery.isEmpty &&
            widget.quickAccessAccounts.isNotEmpty) ...[
          AccountQuickAccessSection(
            quickAccounts: widget.quickAccessAccounts,
            allAccounts: widget.accounts,
            selectedAccountId: widget.selectedAccountId,
            onAccountSelected: (account) {
              widget.onAccountSelected(account);
              Navigator.pop(context);
            },
            showTransactionCount: widget.showTransactionCount,
          ),
          const SizedBox(height: TossSpacing.space2),
          Container(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space2),
        ],

        // Section header
        if (_searchQuery.isEmpty && widget.quickAccessAccounts.isNotEmpty)
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

        // Accounts list
        ..._filteredAccounts.map((account) => _buildAccountItem(account)),
      ],
    );
  }

  Widget _buildAccountItem(AccountData account) {
    final isSelected = account.id == widget.selectedAccountId;

    return InkWell(
      onTap: () {
        widget.onAccountSelected(account);
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
            Icon(
              Icons.account_balance_wallet,
              size: TossSpacing.iconSM,
              color: isSelected ? TossColors.primary : TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.displayName,
                    style: TossTextStyles.body.copyWith(
                      color: isSelected ? TossColors.primary : TossColors.gray900,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
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
}
