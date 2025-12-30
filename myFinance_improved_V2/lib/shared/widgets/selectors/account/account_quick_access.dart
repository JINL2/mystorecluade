/// Account Quick Access Section
///
/// Displays frequently used accounts for quick selection.
/// Uses usage tracking to show most used accounts first.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'account_selector_item.dart';

/// Quick access section showing frequently used accounts
class AccountQuickAccessSection extends StatelessWidget {
  final List<QuickAccessAccount> quickAccounts;
  final List<AccountData> allAccounts;
  final String? selectedAccountId;
  final void Function(AccountData account) onAccountSelected;
  final bool showTransactionCount;

  const AccountQuickAccessSection({
    super.key,
    required this.quickAccounts,
    required this.allAccounts,
    required this.selectedAccountId,
    required this.onAccountSelected,
    this.showTransactionCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        ...quickAccounts.map((quickAccount) => _buildQuickAccessItem(quickAccount)),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
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
    );
  }

  Widget _buildQuickAccessItem(QuickAccessAccount quickAccount) {
    try {
      final account = allAccounts.firstWhere(
        (a) => a.id == quickAccount.accountId,
        orElse: () => throw StateError('Account not found'),
      );

      return AccountSelectorItem(
        account: account,
        isSelected: account.id == selectedAccountId,
        onTap: () => onAccountSelected(account),
        isQuickAccess: true,
        usageCount: quickAccount.usageCount,
        showTransactionCount: showTransactionCount,
      );
    } catch (e) {
      // Account not found, show fallback
      return _buildFallbackItem(quickAccount);
    }
  }

  Widget _buildFallbackItem(QuickAccessAccount quickAccount) {
    final isSelected = quickAccount.accountId == selectedAccountId;

    return InkWell(
      onTap: () {
        // Convert to AccountData for callback
        final accountData = quickAccount.toAccountData();
        onAccountSelected(accountData);
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
                quickAccount.displayName,
                style: TossTextStyles.body.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (quickAccount.usageCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Text(
                  '${quickAccount.usageCount}\u00d7',
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
}

/// Quick access section for multi-select mode
class AccountQuickAccessMultiSelect extends StatelessWidget {
  final List<QuickAccessAccount> quickAccounts;
  final List<AccountData> allAccounts;
  final List<String> selectedIds;
  final void Function(String accountId, bool isSelected) onSelectionChanged;

  const AccountQuickAccessMultiSelect({
    super.key,
    required this.quickAccounts,
    required this.allAccounts,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        ...quickAccounts.map((quickAccount) => _buildQuickAccessItem(quickAccount)),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
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
    );
  }

  Widget _buildQuickAccessItem(QuickAccessAccount quickAccount) {
    try {
      final account = allAccounts.firstWhere(
        (a) => a.id == quickAccount.accountId,
        orElse: () => throw StateError('Account not found'),
      );
      final isSelected = selectedIds.contains(account.id);

      return InkWell(
        onTap: () => onSelectionChanged(account.id, !isSelected),
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
                  if (quickAccount.isHighlyUsed)
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
                        if (quickAccount.usageCount > 0) ...[
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
                              '${quickAccount.usageCount}\u00d7',
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
                onChanged: (value) => onSelectionChanged(account.id, value ?? false),
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
  }
}
