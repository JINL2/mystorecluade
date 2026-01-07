/// Template Info Card - Template information display
///
/// Purpose: Displays template name and transaction type flow
/// Shows debit → credit category tags with icon
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Displays template info card with name and transaction flow
class TemplateInfoCard extends StatelessWidget {
  final Map<String, dynamic> template;

  const TemplateInfoCard({
    super.key,
    required this.template,
  });

  static String _formatTagName(String tag) {
    switch (tag.toLowerCase()) {
      case 'payable':
        return 'Payable';
      case 'receivable':
        return 'Receivable';
      case 'cash':
        return 'Cash';
      case 'expense':
        return 'Expense';
      case 'revenue':
        return 'Revenue';
      default:
        return tag.substring(0, 1).toUpperCase() + tag.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = template['data'] as List? ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    final debit = data.firstWhere(
      (e) => e['type'] == 'debit',
      orElse: () => <String, dynamic>{},
    );
    final credit = data.firstWhere(
      (e) => e['type'] == 'credit',
      orElse: () => <String, dynamic>{},
    );

    final debitTag = debit['category_tag']?.toString() ?? '';
    final creditTag = credit['category_tag']?.toString() ?? '';

    if (debitTag.isEmpty || creditTag.isEmpty) return const SizedBox.shrink();

    final templateName = template['name']?.toString() ?? 'Template';

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(
              Icons.receipt_long,
              color: TossColors.primary,
              size: TossSpacing.iconMD,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  templateName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  '${_formatTagName(debitTag)} → ${_formatTagName(creditTag)}',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
