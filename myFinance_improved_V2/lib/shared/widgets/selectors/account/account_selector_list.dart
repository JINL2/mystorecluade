/// Account Selector List
///
/// List widget that displays all available accounts.
/// For single-selection mode only.
/// For multi-selection, use widgets from account_multi_select.dart.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'account_selector_item.dart';

/// Account list for single selection mode
class AccountSelectorList extends StatelessWidget {
  final List<AccountData> accounts;
  final String? selectedAccountId;
  final void Function(AccountData account) onAccountSelected;
  final bool showTransactionCount;
  final ScrollController? scrollController;

  const AccountSelectorList({
    super.key,
    required this.accounts,
    required this.selectedAccountId,
    required this.onAccountSelected,
    this.showTransactionCount = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return AccountSelectorItem(
          account: account,
          isSelected: account.id == selectedAccountId,
          onTap: () => onAccountSelected(account),
          showTransactionCount: showTransactionCount,
        );
      },
    );
  }

  Widget _buildEmptyState() {
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
}
