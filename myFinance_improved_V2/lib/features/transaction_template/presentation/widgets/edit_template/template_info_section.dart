/// Template Info Section - Read-only template information display
///
/// Purpose: Displays non-editable template summary
/// - Shows debit/credit account flow
/// - Visual indicator for editing mode
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Displays template info card showing non-editable information
class TemplateInfoSection extends StatelessWidget {
  final Map<String, dynamic> template;

  const TemplateInfoSection({
    super.key,
    required this.template,
  });

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

    final debitAccount = debit['account_name']?.toString() ?? '';
    final creditAccount = credit['account_name']?.toString() ?? '';

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
            child: const Icon(
              Icons.edit_note,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editing Template',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                if (debitAccount.isNotEmpty && creditAccount.isNotEmpty)
                  Text(
                    '$debitAccount → $creditAccount',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w500,
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
