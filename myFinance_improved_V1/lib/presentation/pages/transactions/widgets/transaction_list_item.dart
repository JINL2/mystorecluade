import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../data/models/transaction_history_model.dart';
import '../../../widgets/toss/toss_card.dart';
import 'transaction_detail_sheet.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionData transaction;
  
  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: () => _showTransactionDetail(context),
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with time, journal number, and creator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(transaction.createdAt),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    if (transaction.createdByName.isNotEmpty && transaction.createdByName != 'Unknown') ...[
                      SizedBox(width: TossSpacing.space2),
                      Icon(
                        Icons.person_outline,
                        size: 12,
                        color: TossColors.gray400,
                      ),
                      SizedBox(width: 4),
                      Text(
                        transaction.createdByName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'JRN-${transaction.journalNumber.substring(0, 8).toUpperCase()}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontSize: 11,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Transaction Lines
          ...transaction.lines.asMap().entries.map((entry) {
            final index = entry.key;
            final line = entry.value;
            return Column(
              children: [
                _buildTransactionLine(line),
                if (index < transaction.lines.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                    child: Divider(
                      color: TossColors.gray100,
                      height: 1,
                    ),
                  ),
              ],
            );
          }),
          
          // Description (if exists and different from line descriptions)
          if (transaction.description.isNotEmpty && 
              !transaction.lines.any((l) => l.description == transaction.description))
            Padding(
              padding: EdgeInsets.only(top: TossSpacing.space3),
              child: Text(
                transaction.description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          
          // Attachments indicator
          if (transaction.attachments.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: TossSpacing.space3),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 14,
                    color: TossColors.gray400,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '${transaction.attachments.length} attachment${transaction.attachments.length > 1 ? 's' : ''}',
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
    );
  }

  Widget _buildTransactionLine(TransactionLine line) {
    final isDebit = line.isDebit;
    final amount = isDebit ? line.debit : line.credit;
    final color = isDebit ? TossColors.success : TossColors.loss;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(
            isDebit ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
            size: 16,
          ),
        ),
        
        SizedBox(width: TossSpacing.space3),
        
        // Main Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Name with Cash Location
              Row(
                children: [
                  Flexible(
                    child: Text(
                      line.accountName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (line.cashLocation != null) ...[
                    SizedBox(width: TossSpacing.space2),
                    Container(
                      constraints: BoxConstraints(maxWidth: 120),
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCashLocationIcon(line.cashLocation!['type'] as String? ?? ''),
                            size: 10,
                            color: TossColors.primary,
                          ),
                          SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              line.displayLocation,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              
              // Counterparty
              if (line.counterparty != null)
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 12,
                        color: TossColors.gray400,
                      ),
                      SizedBox(width: 4),
                      Text(
                        line.displayCounterparty,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Line Description
              if (line.description != null && line.description!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    line.description!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray400,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Amount
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isDebit ? '+' : '-'}${_formatCurrency(amount)}',
              style: TossTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (line.accountType.isNotEmpty)
              Text(
                _getAccountTypeLabel(line.accountType),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray400,
                  fontSize: 10,
                ),
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
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount.abs());
  }

  void _showTransactionDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionDetailSheet(
        transaction: transaction,
      ),
    );
  }
}