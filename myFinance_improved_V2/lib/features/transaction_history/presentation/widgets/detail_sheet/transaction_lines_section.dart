// lib/features/transaction_history/presentation/widgets/detail_sheet/transaction_lines_section.dart
//
// Transaction lines section extracted from transaction_detail_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../core/utils/text_utils.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/transaction.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Transaction lines section showing debit/credit entries
class TransactionLinesSection extends StatelessWidget {
  final List<TransactionLine> debitLines;
  final List<TransactionLine> creditLines;
  final String currencySymbol;

  const TransactionLinesSection({
    super.key,
    required this.debitLines,
    required this.creditLines,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Debit Section
        if (debitLines.isNotEmpty) ...[
          _SectionHeader(
            title: 'Debit',
            color: TossColors.primary,
            lines: debitLines,
            currencySymbol: currencySymbol,
          ),
          const SizedBox(height: TossSpacing.space3),
          ...debitLines.map((line) => _LineDetailCard(line: line, isDebit: true)),
          const SizedBox(height: TossSpacing.space4),
        ],

        // Credit Section
        if (creditLines.isNotEmpty) ...[
          _SectionHeader(
            title: 'Credit',
            color: TossColors.textPrimary,
            lines: creditLines,
            currencySymbol: currencySymbol,
          ),
          const SizedBox(height: TossSpacing.space3),
          ...creditLines.map((line) => _LineDetailCard(line: line, isDebit: false)),
          const SizedBox(height: TossSpacing.space4),
        ],
      ],
    );
  }
}

/// Section header for debit/credit
class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  final List<TransactionLine> lines;
  final String currencySymbol;

  const _SectionHeader({
    required this.title,
    required this.color,
    required this.lines,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final total = lines.fold(
      0.0,
      (sum, line) => sum + (line.isDebit ? line.debit : line.credit),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: TossSpacing.space1,
              height: TossSpacing.space4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1 / 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
              child: Text(
                '${lines.length} items',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
          ],
        ),
        Text(
          '$currencySymbol${_formatCurrency(total)}',
          style: TossTextStyles.body.copyWith(
            fontWeight: TossFontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormatter.formatCurrencyDecimal(
      amount.abs(),
      '',
      decimalPlaces: 2,
    );
  }
}

/// Line detail card
class _LineDetailCard extends StatelessWidget {
  final TransactionLine line;
  final bool isDebit;

  const _LineDetailCard({
    required this.line,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    final amount = isDebit ? line.debit : line.credit;
    final color = isDebit ? TossColors.primary : TossColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.accountName,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: TossFontWeight.semibold,
                        ),
                      ),
                      Text(
                        _getAccountTypeLabel(line.accountType),
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isDebit ? '+' : '-'}${_formatCurrency(amount)}',
                  style: TossTextStyles.body.copyWith(
                    color: color,
                    fontWeight: TossFontWeight.bold,
                  ),
                ),
              ],
            ),

            // Cash Location
            if (line.cashLocation != null) ...[
              const SizedBox(height: TossSpacing.space2),
              _CashLocationRow(line: line),
            ],

            // Counterparty
            if (line.counterparty != null) ...[
              const SizedBox(height: TossSpacing.space2),
              _CounterpartyRow(line: line),
            ],

            // Line Description
            if (line.description != null && line.description!.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space2),
              Text(
                line.description!.withoutTrailingDate,
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormatter.formatCurrencyDecimal(
      amount.abs(),
      '',
      decimalPlaces: 2,
    );
  }

  String _getAccountTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'asset':
        return 'Asset';
      case 'liability':
        return 'Liability';
      case 'equity':
        return 'Equity';
      case 'income':
        return 'Income';
      case 'expense':
        return 'Expense';
      default:
        return type;
    }
  }
}

/// Cash location row
class _CashLocationRow extends StatelessWidget {
  final TransactionLine line;

  const _CashLocationRow({required this.line});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Row(
        children: [
          Icon(
            _getCashLocationIcon(line.cashLocation!['type'] as String? ?? ''),
            size: TossSpacing.iconXXS,
            color: TossColors.primary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Cash Location: ',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Expanded(
            child: Text(
              line.displayLocation,
              style: TossTextStyles.small.copyWith(
                color: TossColors.primary,
                fontWeight: TossFontWeight.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCashLocationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bank':
        return Icons.account_balance;
      case 'register':
        return Icons.point_of_sale;
      case 'vault':
        return Icons.lock;
      case 'wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.place;
    }
  }
}

/// Counterparty row
class _CounterpartyRow extends StatelessWidget {
  final TransactionLine line;

  const _CounterpartyRow({required this.line});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: TossSpacing.iconXXS,
          color: TossColors.gray400,
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          '${line.counterparty!['type'] as String? ?? ''}: ',
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          line.displayCounterparty,
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray700,
            fontWeight: TossFontWeight.medium,
          ),
        ),
      ],
    );
  }
}
