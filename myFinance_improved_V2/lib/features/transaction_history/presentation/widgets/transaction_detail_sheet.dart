// lib/features/transaction_history/presentation/widgets/transaction_detail_sheet.dart
//
// Transaction Detail Sheet - Refactored following Clean Architecture 2025
// Single Responsibility Principle applied
//
// Extracted widgets:
// - detail_sheet/detail_header_section.dart
// - detail_sheet/transaction_info_card.dart
// - detail_sheet/transaction_lines_section.dart
// - detail_sheet/balance_check_section.dart
// - detail_sheet/transaction_metadata_section.dart
// - detail_sheet/transaction_attachments_section.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../domain/entities/transaction.dart';
import 'detail_sheet/balance_check_section.dart';
import 'detail_sheet/detail_header_section.dart';
import 'detail_sheet/transaction_attachments_section.dart';
import 'detail_sheet/transaction_info_card.dart';
import 'detail_sheet/transaction_lines_section.dart';
import 'detail_sheet/transaction_metadata_section.dart';

/// Transaction detail bottom sheet
class TransactionDetailSheet extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final debitLines = transaction.lines.where((l) => l.isDebit).toList();
    final creditLines = transaction.lines.where((l) => !l.isDebit).toList();

    return TossBottomSheet(
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            DetailHeaderSection(transaction: transaction),

            const SizedBox(height: TossSpacing.space4),

            // Transaction Info Card
            TransactionInfoCard(transaction: transaction),

            const SizedBox(height: TossSpacing.space4),

            // Debit/Credit Lines Section
            TransactionLinesSection(
              debitLines: debitLines,
              creditLines: creditLines,
              currencySymbol: transaction.currencySymbol,
            ),

            // Balance Check
            BalanceCheckSection(
              totalDebit: transaction.totalDebit,
              totalCredit: transaction.totalCredit,
            ),

            const SizedBox(height: TossSpacing.space4),

            // Metadata
            TransactionMetadataSection(transaction: transaction),

            // Attachments
            if (transaction.attachments.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space4),
              TransactionAttachmentsSection(
                attachments: transaction.attachments,
              ),
            ],

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }
}
