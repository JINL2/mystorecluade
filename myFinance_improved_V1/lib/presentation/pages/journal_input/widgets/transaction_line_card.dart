import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry_model.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../widgets/common/toss_white_card.dart';

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
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }
  
  @override
  Widget build(BuildContext context) {
    return TossWhiteCard(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.zero,
      showBorder: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: line.isDebit ? TossColors.primary : TossColors.success,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                line.accountName ?? 'No Account',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (line.description != null && line.description!.isNotEmpty) ...[
                                SizedBox(height: 2),
                                Text(
                                  line.description!,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatCurrency(line.amount),
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: line.isDebit ? TossColors.primary : TossColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              line.isDebit ? 'Debit' : 'Credit',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_hasAnyTags()) ...[
                      SizedBox(height: TossSpacing.space2),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (line.categoryTag != null) 
                              _buildCompactTag(_formatCategoryTag(line.categoryTag!)),
                            if (line.cashLocationName != null)
                              _buildCompactTag(line.cashLocationName!),
                            if (line.counterpartyName != null)
                              _buildCompactTag(line.counterpartyName!),
                            if (line.debtCategory != null)
                              _buildCompactTag('Debt'),
                            if (line.fixedAssetName != null)
                              _buildCompactTag('Asset'),
                          ],
                        ),
                      ),
                    ],
                  ],
                          ),
                        ),
                        IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: TossColors.gray400,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  bool _hasAnyTags() {
    return line.categoryTag != null ||
           line.cashLocationName != null ||
           line.counterpartyName != null ||
           line.debtCategory != null ||
           line.fixedAssetName != null;
  }
  
  Widget _buildCompactTag(String label) {
    return Container(
      margin: EdgeInsets.only(right: TossSpacing.space1),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray600,
          fontSize: 11,
        ),
      ),
    );
  }
  
  String _formatCategoryTag(String categoryTag) {
    switch (categoryTag.toLowerCase()) {
      case 'fixedasset':
        return 'Fixed Asset';
      default:
        return categoryTag[0].toUpperCase() + categoryTag.substring(1);
    }
  }
}