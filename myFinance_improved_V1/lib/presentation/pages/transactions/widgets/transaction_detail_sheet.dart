import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../data/models/transaction_history_model.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/toss/toss_icon_button.dart';
import '../../../widgets/toss/toss_card.dart';
import '../../../widgets/toss/toss_chip.dart';

class TransactionDetailSheet extends StatelessWidget {
  final TransactionData transaction;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final debitLines = transaction.lines.where((l) => l.isDebit).toList();
    final creditLines = transaction.lines.where((l) => !l.isDebit).toList();

    return TossBottomSheet(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          
          SizedBox(height: TossSpacing.space4),
          
          // Transaction Info Card
          _buildTransactionInfoCard(),
          
          SizedBox(height: TossSpacing.space4),
          
          // Debit Section
          if (debitLines.isNotEmpty) ...[
            _buildSectionHeader('Debit', TossColors.success, debitLines),
            SizedBox(height: TossSpacing.space3),
            ...debitLines.map((line) => _buildLineDetail(line, true)),
            SizedBox(height: TossSpacing.space4),
          ],
          
          // Credit Section
          if (creditLines.isNotEmpty) ...[
            _buildSectionHeader('Credit', TossColors.loss, creditLines),
            SizedBox(height: TossSpacing.space3),
            ...creditLines.map((line) => _buildLineDetail(line, false)),
            SizedBox(height: TossSpacing.space4),
          ],
          
          // Balance Check
          _buildBalanceCheck(),
          
          SizedBox(height: TossSpacing.space4),
          
          // Metadata
          _buildMetadata(),
          
          // Attachments
          if (transaction.attachments.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space4),
            _buildAttachments(),
          ],
          
          SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, yyyy • HH:mm').format(transaction.entryDate),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Row(
                children: [
                  Text(
                    'JRN-${transaction.journalNumber.substring(0, 8).toUpperCase()}',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  _buildStatusBadge(
                    transaction.journalType.toUpperCase(),
                    _getTypeColor(transaction.journalType),
                  ),
                  if (transaction.isDraft) ...[
                    SizedBox(width: TossSpacing.space1),
                    _buildStatusBadge('DRAFT', TossColors.warning),
                  ],
                ],
              ),
            ],
          ),
        ),
        TossIconButton(
          icon: Icons.copy,
          iconSize: 20,
          iconColor: TossColors.gray500,
          tooltip: 'Copy journal number',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: 'JRN-${transaction.journalNumber.substring(0, 8).toUpperCase()}'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Journal number copied'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        TossIconButton(
          icon: Icons.close,
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTransactionInfoCard() {
    return TossCard(
      backgroundColor: TossColors.gray50,
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transaction.description.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.description_outlined, size: 16, color: TossColors.gray500),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    transaction.description,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space2),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              Text(
                '${transaction.currencySymbol}${_formatCurrency(transaction.totalAmount)}',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, List<TransactionLine> lines) {
    final total = lines.fold(0.0, (sum, line) => sum + (line.isDebit ? line.debit : line.credit));
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${lines.length} items',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        Text(
          '${transaction.currencySymbol}${_formatCurrency(total)}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLineDetail(TransactionLine line, bool isDebit) {
    final amount = isDebit ? line.debit : line.credit;
    final color = isDebit ? TossColors.success : TossColors.loss;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.gray100,
          width: 1,
        ),
      ),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getAccountTypeLabel(line.accountType),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isDebit ? '+' : '-'}${_formatCurrency(amount)}',
                style: TossTextStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          // Cash Location
          if (line.cashLocation != null) ...[
            SizedBox(height: TossSpacing.space2),
            Container(
              padding: EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCashLocationIcon(line.cashLocation!['type'] as String? ?? ''),
                    size: 14,
                    color: TossColors.primary,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Cash Location: ',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontSize: 11,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line.displayLocation,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Counterparty
          if (line.counterparty != null) ...[
            SizedBox(height: TossSpacing.space2),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: TossColors.gray400,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  '${line.counterparty!['type'] as String? ?? ''}: ',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
                Text(
                  line.displayCounterparty,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
          
          // Line Description
          if (line.description != null && line.description!.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space2),
            Text(
              line.description!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceCheck() {
    final totalDebit = transaction.totalDebit;
    final totalCredit = transaction.totalCredit;
    final isBalanced = (totalDebit - totalCredit).abs() < 0.01;
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: isBalanced ? TossColors.success.withOpacity(0.05) : TossColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: isBalanced ? TossColors.success.withOpacity(0.2) : TossColors.error.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isBalanced ? Icons.check_circle : Icons.error,
                size: 16,
                color: isBalanced ? TossColors.success : TossColors.error,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                isBalanced ? 'Balanced' : 'Unbalanced',
                style: TossTextStyles.caption.copyWith(
                  color: isBalanced ? TossColors.success : TossColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            'D: ${_formatCurrency(totalDebit)} | C: ${_formatCurrency(totalCredit)}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontSize: 11,
              fontFamily: 'JetBrains Mono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metadata',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        _buildMetadataRow('Created by', transaction.createdByName),
        _buildMetadataRow('Currency', '${transaction.currencyCode} (${transaction.currencySymbol})'),
        _buildMetadataRow('Type', transaction.journalType),
        if (transaction.isDraft)
          _buildMetadataRow('Status', 'Draft', color: TossColors.warning),
      ],
    );
  }

  Widget _buildMetadataRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            value,
            style: TossTextStyles.caption.copyWith(
              color: color ?? TossColors.gray700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        ...transaction.attachments.map((attachment) => 
          Container(
            margin: EdgeInsets.only(bottom: TossSpacing.space2),
            padding: EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              border: Border.all(
                color: TossColors.gray100,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getFileIcon(attachment.fileType),
                  size: 16,
                  color: TossColors.gray500,
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    attachment.fileName,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray700,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatFileSize(attachment.fileSize),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'sales':
        return TossColors.success;
      case 'purchase':
        return TossColors.loss;
      case 'payment':
        return TossColors.blue;
      case 'receipt':
        return TossColors.info;
      default:
        return TossColors.gray600;
    }
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

  IconData _getFileIcon(String type) {
    if (type.contains('image')) return Icons.image;
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('document')) return Icons.description;
    return Icons.attach_file;
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}