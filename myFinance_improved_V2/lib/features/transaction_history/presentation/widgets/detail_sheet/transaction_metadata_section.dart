// lib/features/transaction_history/presentation/widgets/detail_sheet/transaction_metadata_section.dart
//
// Transaction metadata section extracted from transaction_detail_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/transaction.dart';

/// Metadata section for transaction
class TransactionMetadataSection extends StatelessWidget {
  final Transaction transaction;

  const TransactionMetadataSection({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: TossSpacing.space2),
        _MetadataRow(label: 'Created by', value: transaction.createdByName),
        if (transaction.storeName != null && transaction.storeName!.isNotEmpty)
          _MetadataRow(
            label: 'Store',
            value: transaction.storeName!,
            valueColor: TossColors.gray700,
          ),
        _MetadataRow(
          label: 'Currency',
          value: '${transaction.currencyCode} (${transaction.currencySymbol})',
        ),
        _MetadataRow(label: 'Type', value: transaction.journalType),
        if (transaction.isDraft)
          const _MetadataRow(
            label: 'Status',
            value: 'Draft',
            valueColor: TossColors.gray700,
          ),
      ],
    );
  }
}

/// Metadata row
class _MetadataRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetadataRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
              color: valueColor ?? TossColors.gray700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
