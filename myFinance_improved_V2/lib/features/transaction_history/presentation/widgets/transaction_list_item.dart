import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/utils/number_formatter.dart';
import 'package:myfinance_improved/core/utils/text_utils.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/ai/index.dart';

import '../../domain/entities/transaction.dart';
import 'transaction_detail_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class TransactionListItem extends ConsumerWidget {
  final Transaction transaction;

  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showTransactionDetail(context),
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header with time and creator/store chips (JRN REMOVED FOR SPACE)
          Row(
            children: [
              // Time - Fixed width to prevent expansion
              SizedBox(
                width: TossDimensions.timeColumnWidth,
                child: Text(
                  DateFormat('HH:mm').format(transaction.createdAt),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ),

              // Expanded content area with optimized spacing
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: TossSpacing.space1 / 2,
                    runSpacing: TossSpacing.space1 / 2,
                    children: [
                      if (transaction.createdByName.isNotEmpty && transaction.createdByName != 'Unknown')
                        _buildCreatorChip(transaction.createdByName),
                      if (transaction.storeName != null && transaction.storeName!.isNotEmpty)
                        _buildStoreChip(transaction.storeName!),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Transaction Lines - Sort debits first, then credits
          ...() {
            // Separate debits and credits
            final debitLines = transaction.lines.where((line) => line.isDebit).toList();
            final creditLines = transaction.lines.where((line) => !line.isDebit).toList();

            // Combine with debits first
            final sortedLines = [...debitLines, ...creditLines];

            return sortedLines.asMap().entries.map((entry) {
              final index = entry.key;
              final line = entry.value;
              return Column(
                children: [
                  _buildTransactionLine(line),
                  if (index < sortedLines.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                      child: Divider(
                        color: TossColors.gray100,
                        height: TossDimensions.dividerThickness,
                      ),
                    ),
                ],
              );
            });
          }(),

          // Description (if exists and different from line descriptions)
          if (transaction.description.isNotEmpty &&
              !transaction.lines.any((l) => l.description == transaction.description))
            Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space3),
              child: Text(
                transaction.description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // AI Description (if exists)
          if (transaction.aiDescription != null && transaction.aiDescription!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space2),
              child: AiDescriptionRow(
                text: transaction.aiDescription!,
                maxLines: 2,
                alignment: CrossAxisAlignment.start,
              ),
            ),

          // Attachments indicator
          if (transaction.attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space3),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: TossSpacing.iconXXS,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    '${transaction.attachments.length} attachment${transaction.attachments.length > 1 ? 's' : ''}',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray400,
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

  Widget _buildTransactionLine(TransactionLine line) {
    final isDebit = line.isDebit;
    final amount = isDebit ? line.debit : line.credit;
    final color = isDebit ? TossColors.primary : TossColors.textPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon - Optimized size for space efficiency
        Container(
          width: TossDimensions.transactionIconSize,
          height: TossDimensions.transactionIconSize,
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(
            isDebit ? Icons.arrow_downward : Icons.arrow_upward,
            color: TossColors.gray500,
            size: TossSpacing.iconXXS,
          ),
        ),

        const SizedBox(width: TossSpacing.space2),

        // Main Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Name (FIXED OVERFLOW - simplified layout)
              Text(
                line.accountName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: TossColors.gray900,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),

              // Cash Location as separate row to prevent overflow
              if (line.cashLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: TossSpacing.space1 / 2),
                  child: Row(
                    children: [
                      Icon(
                        _getCashLocationIcon(line.cashLocation!['type'] as String? ?? ''),
                        size: TossSpacing.iconXXS,
                        color: TossColors.primary,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Expanded(
                        child: Text(
                          line.displayLocation,
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.primary,
                            fontWeight: TossFontWeight.medium,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),

              // Counterparty (fixed overflow)
              if (line.counterparty != null)
                Padding(
                  padding: const EdgeInsets.only(top: TossSpacing.space1 / 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: TossSpacing.iconXXS,
                        color: TossColors.gray400,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Expanded(
                        child: Text(
                          line.displayCounterparty,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),

              // Line Description (fixed overflow)
              if (line.description != null && line.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: TossSpacing.space1 / 2),
                  child: Text(
                    line.description!.withoutTrailingDate,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
            ],
          ),
        ),

        // Amount - No fixed width to show full numbers
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isDebit ? '+' : '-'}${_formatCurrency(amount)}',
              style: TossTextStyles.body.copyWith(
                color: color,
                fontWeight: TossFontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            if (line.accountType.isNotEmpty)
              Text(
                _getAccountTypeLabel(line.accountType),
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray400,
                ),
                textAlign: TextAlign.right,
              ),
          ],
        ),
      ],
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

  String _formatCurrency(double amount) {
    final absAmount = amount.abs();
    // Only show decimals if non-zero
    if (absAmount == absAmount.roundToDouble()) {
      return NumberFormatter.formatWithCommas(absAmount.round());
    }
    return NumberFormatter.formatCurrencyDecimal(absAmount, '', decimalPlaces: 2);
  }

  void _showTransactionDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => TransactionDetailSheet(
        transaction: transaction,
      ),
    );
  }

  // Helper method to build creator chip (expanded width with JRN removal)
  Widget _buildCreatorChip(String creatorName) {
    return Container(
      constraints: BoxConstraints(maxWidth: TossDimensions.chipMaxWidthSM),
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: TossSpacing.space1 / 4,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200, width: TossDimensions.dividerThicknessThin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_outline,
            size: TossSpacing.iconXXS,
            color: TossColors.gray400,
          ),
          const SizedBox(width: TossSpacing.space1 / 2),
          Flexible(
            child: Text(
              creatorName,
              style: TossTextStyles.micro.copyWith(
                color: TossColors.gray500,
                fontWeight: TossFontWeight.medium,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build store chip (expanded width with JRN removal)
  Widget _buildStoreChip(String storeName) {
    return Container(
      constraints: BoxConstraints(maxWidth: TossDimensions.chipMaxWidthMD),
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: TossSpacing.space1 / 4,
      ),
      decoration: BoxDecoration(
        color: TossColors.primarySurface.withValues(alpha: TossOpacity.light),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: TossOpacity.overlay),
          width: TossDimensions.dividerThicknessThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.store,
            size: TossSpacing.iconXXS,
            color: TossColors.primary,
          ),
          const SizedBox(width: TossSpacing.space1 / 2),
          Flexible(
            child: Text(
              storeName,
              style: TossTextStyles.micro.copyWith(
                color: TossColors.primary,
                fontWeight: TossFontWeight.medium,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
