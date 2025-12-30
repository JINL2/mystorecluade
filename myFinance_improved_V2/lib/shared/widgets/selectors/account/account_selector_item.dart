/// Account Selector Item
///
/// Individual account item widget used in the account selector list.
/// Displays account name, category, transaction count, and selection state.
/// For single-selection mode only.
/// For multi-selection items, use widgets from account_multi_select.dart.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Account selector item widget for single selection mode
class AccountSelectorItem extends StatelessWidget {
  final AccountData account;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isQuickAccess;
  final int usageCount;
  final bool showTransactionCount;

  const AccountSelectorItem({
    super.key,
    required this.account,
    required this.isSelected,
    required this.onTap,
    this.isQuickAccess = false,
    this.usageCount = 0,
    this.showTransactionCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                        _buildUsageBadge(),
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
                  if (showTransactionCount && account.transactionCount > 0)
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

  Widget _buildUsageBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Text(
        '$usageCount\u00d7',
        style: TossTextStyles.caption.copyWith(
          color: TossColors.warning,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
