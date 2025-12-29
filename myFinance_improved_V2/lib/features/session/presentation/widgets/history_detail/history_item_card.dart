import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// Individual item card for history detail
class HistoryItemCard extends StatelessWidget {
  final SessionHistoryItemDetail item;
  final bool isCounting;

  const HistoryItemCard({
    super.key,
    required this.item,
    required this.isCounting,
  });

  @override
  Widget build(BuildContext context) {
    final hasConfirmed = item.hasConfirmed;
    final wasEdited = item.wasEdited;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: wasEdited ? TossColors.primary.withValues(alpha: 0.3) : TossColors.gray100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product info header
          _buildProductHeader(hasConfirmed, wasEdited),

          // Counting specific: Expected vs Difference
          if (isCounting && item.quantityExpected != null) _buildCountingInfo(),

          // Scanned by breakdown
          if (item.scannedBy.isNotEmpty) ...[
            _buildScannedByHeader(),
            ...item.scannedBy.map((scanner) => _buildScannerRow(scanner)),
          ],
        ],
      ),
    );
  }

  Widget _buildProductHeader(bool hasConfirmed, bool wasEdited) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
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
                      child: Text(
                        item.productName,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.textPrimary,
                        ),
                      ),
                    ),
                    if (wasEdited)
                      Container(
                        margin: const EdgeInsets.only(left: TossSpacing.space2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit, size: 10, color: TossColors.primary),
                            const SizedBox(width: 2),
                            Text(
                              'Edited',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (item.sku != null && item.sku!.isNotEmpty)
                  Text(
                    'SKU: ${item.sku}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Show final quantity (confirmed if available)
              Row(
                children: [
                  Text(
                    hasConfirmed ? 'Confirmed: ' : 'Qty: ',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                  Text(
                    '${item.finalQuantity}',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: wasEdited ? TossColors.primary : TossColors.success,
                    ),
                  ),
                ],
              ),
              // Show scanned if different from confirmed
              if (wasEdited)
                Row(
                  children: [
                    Text(
                      'Scanned: ',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                    Text(
                      '${item.scannedQuantity}',
                      style: TossTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TossColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              if (item.finalRejected > 0)
                Row(
                  children: [
                    Text(
                      'Rejected: ',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                    Text(
                      '${item.finalRejected}',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.error,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountingInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Expected: ${item.quantityExpected}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (item.quantityDifference != null) _buildDifferenceBadge(),
        ],
      ),
    );
  }

  Widget _buildDifferenceBadge() {
    final diff = item.quantityDifference!;
    final isNegative = diff < 0;
    final isPositive = diff > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isNegative
            ? TossColors.error.withValues(alpha: 0.1)
            : isPositive
                ? TossColors.success.withValues(alpha: 0.1)
                : TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        'Diff: ${diff >= 0 ? '+' : ''}$diff',
        style: TossTextStyles.caption.copyWith(
          color: isNegative
              ? TossColors.error
              : isPositive
                  ? TossColors.success
                  : TossColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildScannedByHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: Text(
        'Scanned by',
        style: TossTextStyles.caption.copyWith(
          color: TossColors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildScannerRow(ScannedByInfo scanner) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray50),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: TossColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                scanner.userName.isNotEmpty ? scanner.userName[0].toUpperCase() : '?',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              scanner.userName,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${scanner.quantity}',
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.success,
            ),
          ),
          if (scanner.quantityRejected > 0) ...[
            Text(
              ' / ',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textTertiary,
              ),
            ),
            Text(
              '${scanner.quantityRejected}',
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
