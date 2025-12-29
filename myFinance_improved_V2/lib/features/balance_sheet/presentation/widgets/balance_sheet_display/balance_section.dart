import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Generic section widget for Assets, Liabilities, Equity sections
class BalanceSection extends StatelessWidget {
  final String title;
  final dynamic total;
  final String currencySymbol;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const BalanceSection({
    super.key,
    required this.title,
    required this.total,
    required this.currencySymbol,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    title,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Container(
                  constraints:
                      const BoxConstraints(minWidth: 80, maxWidth: 140),
                  child: Text(
                    _formatCurrency(total),
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space4,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '$currencySymbol 0';

    final num numAmount = (amount is num) ? amount : 0;
    final formatter = NumberFormat('#,##0', 'en_US');
    final absAmount = numAmount.abs();
    final formatted = formatter.format(absAmount);

    if (numAmount < 0) {
      return '-$currencySymbol$formatted';
    }
    return '$currencySymbol$formatted';
  }
}

/// Sub-section widget for Current/Non-Current Assets/Liabilities
class BalanceSubSection extends StatelessWidget {
  final String title;
  final dynamic total;
  final String currencySymbol;
  final List<dynamic> accounts;

  const BalanceSubSection({
    super.key,
    required this.title,
    required this.total,
    required this.currencySymbol,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BalanceItem(
          label: title,
          value: '',
          isBold: true,
          isSubtotal: false,
        ),
        ...accounts.map(
          (account) => AccountItem(
            account: account as Map<String, dynamic>,
            currencySymbol: currencySymbol,
          ),
        ),
        const Divider(color: TossColors.gray100, height: TossSpacing.space4),
        BalanceItem(
          label: 'Total $title',
          value: _formatCurrency(total),
          isBold: true,
          isSubtotal: true,
        ),
      ],
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '$currencySymbol 0';

    final num numAmount = (amount is num) ? amount : 0;
    final formatter = NumberFormat('#,##0', 'en_US');
    final absAmount = numAmount.abs();
    final formatted = formatter.format(absAmount);

    if (numAmount < 0) {
      return '-$currencySymbol$formatted';
    }
    return '$currencySymbol$formatted';
  }
}

/// Single account item widget
class AccountItem extends StatelessWidget {
  final Map<String, dynamic> account;
  final String currencySymbol;

  const AccountItem({
    super.key,
    required this.account,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final balance = account['balance'] ?? 0;
    final hasTransactions = (account['has_transactions'] as bool?) ?? false;

    return BalanceItem(
      label: '  ${account['account_name']}',
      value: _formatCurrency(balance),
      isBold: false,
      isSubtotal: false,
      hasTransactions: hasTransactions,
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '$currencySymbol 0';

    final num numAmount = (amount is num) ? amount : 0;
    final formatter = NumberFormat('#,##0', 'en_US');
    final absAmount = numAmount.abs();
    final formatted = formatter.format(absAmount);

    if (numAmount < 0) {
      return '-$currencySymbol$formatted';
    }
    return '$currencySymbol$formatted';
  }
}

/// Generic balance item row widget
class BalanceItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isSubtotal;
  final bool hasTransactions;

  const BalanceItem({
    super.key,
    required this.label,
    required this.value,
    required this.isBold,
    required this.isSubtotal,
    this.hasTransactions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: isBold
                        ? TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          )
                        : TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                            fontSize: 13,
                          ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (hasTransactions && !isBold && !isSubtotal) ...[
                  const SizedBox(width: TossSpacing.space1),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: TossColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          if (value.isNotEmpty)
            Container(
              constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
              child: Text(
                value,
                style: isSubtotal
                    ? TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      )
                    : TossTextStyles.body.copyWith(
                        color: value.startsWith('-')
                            ? TossColors.error
                            : TossColors.gray700,
                        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                      ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
        ],
      ),
    );
  }
}
