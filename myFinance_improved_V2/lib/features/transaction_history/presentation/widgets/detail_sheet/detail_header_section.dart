// lib/features/transaction_history/presentation/widgets/detail_sheet/detail_header_section.dart
//
// Transaction detail header extracted from transaction_detail_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/transaction.dart';

/// Header section for transaction detail sheet
class DetailHeaderSection extends StatelessWidget {
  final Transaction transaction;

  const DetailHeaderSection({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, yyyy • HH:mm').format(transaction.createdAt),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Row(
                children: [
                  Text(
                    'JRN-${transaction.journalNumber.substring(0, 8).toUpperCase()}',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  _StatusBadge(
                    label: transaction.journalType.toUpperCase(),
                    color: TossColors.gray600,
                  ),
                  if (transaction.isDraft) ...[
                    const SizedBox(width: TossSpacing.space1),
                    const _StatusBadge(
                      label: 'DRAFT',
                      color: TossColors.warning,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.copy,
            size: 20,
            color: TossColors.gray500,
          ),
          tooltip: 'Copy journal number',
          onPressed: () => _copyJournalNumber(context),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            color: TossColors.gray700,
          ),
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _copyJournalNumber(BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: 'JRN-${transaction.journalNumber.substring(0, 8).toUpperCase()}',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal number copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
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
}
