import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry_model.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';

class TransactionLineCard extends StatelessWidget {
  final TransactionLine line;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  const TransactionLineCard({
    super.key,
    required this.line,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });
  
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(amount);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: line.isDebit ? TossColors.primary.withOpacity(0.2) : TossColors.success.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: line.isDebit 
                ? TossColors.primary.withOpacity(0.05)
                : TossColors.success.withOpacity(0.05),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: line.isDebit ? TossColors.primary : TossColors.success,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    line.isDebit ? 'DEBIT' : 'CREDIT',
                    style: TossTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    line.accountName ?? 'No Account Selected',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatCurrency(line.amount),
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: line.isDebit ? TossColors.primary : TossColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(TossSpacing.space3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                if (line.description != null && line.description!.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes, size: 16, color: TossColors.gray500),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          line.description!,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space2),
                ],
                
                // Additional Details
                Wrap(
                  spacing: TossSpacing.space3,
                  runSpacing: TossSpacing.space2,
                  children: [
                    // Category Tag
                    if (line.categoryTag != null) 
                      _buildTag(
                        _getCategoryIcon(line.categoryTag!),
                        _formatCategoryTag(line.categoryTag!),
                        _getCategoryColor(line.categoryTag!),
                      ),
                    
                    // Cash Location
                    if (line.cashLocationName != null)
                      _buildTag(
                        Icons.account_balance_wallet,
                        line.cashLocationType != null 
                          ? '${line.cashLocationName!} (${line.cashLocationType!})'
                          : line.cashLocationName!,
                        TossColors.info,
                      ),
                    
                    // Counterparty
                    if (line.counterpartyName != null)
                      _buildTag(
                        Icons.business_center,
                        line.counterpartyName!,
                        TossColors.primary,
                      ),
                    
                    // Counterparty Store
                    if (line.counterpartyStoreName != null)
                      _buildTag(
                        Icons.store,
                        line.counterpartyStoreName!,
                        TossColors.info,
                      ),
                    
                    // Debt Info
                    if (line.debtCategory != null)
                      _buildTag(
                        Icons.receipt_long,
                        'Debt: ${line.debtCategory}',
                        TossColors.warning,
                      ),
                    
                    // Fixed Asset
                    if (line.fixedAssetName != null)
                      _buildTag(
                        Icons.business,
                        line.fixedAssetName!,
                        TossColors.primaryDark,
                      ),
                  ],
                ),
                
                // Actions
                SizedBox(height: TossSpacing.space3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit_outlined, size: 18),
                      label: Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: TossColors.gray600,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_outline, size: 18),
                      label: Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: TossColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTag(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(String categoryTag) {
    switch (categoryTag.toLowerCase()) {
      case 'cash':
        return Icons.payments;
      case 'payable':
        return Icons.arrow_upward;
      case 'receivable':
        return Icons.arrow_downward;
      case 'fixedasset':
        return Icons.business;
      case 'expense':
        return Icons.receipt;
      case 'revenue':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }
  
  String _formatCategoryTag(String categoryTag) {
    switch (categoryTag.toLowerCase()) {
      case 'fixedasset':
        return 'Fixed Asset';
      default:
        return categoryTag[0].toUpperCase() + categoryTag.substring(1);
    }
  }
  
  Color _getCategoryColor(String categoryTag) {
    switch (categoryTag.toLowerCase()) {
      case 'cash':
        return TossColors.info;
      case 'payable':
        return TossColors.warning;
      case 'receivable':
        return TossColors.success;
      case 'fixedasset':
        return TossColors.primaryDark;
      case 'expense':
        return TossColors.error;
      case 'revenue':
        return TossColors.success;
      default:
        return TossColors.gray600;
    }
  }
}