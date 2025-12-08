// lib/features/cash_ending/presentation/widgets/grand_total_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Grand total section displayed at the bottom
///
/// Shows the final total amount in base currency
/// Design: Toss-style expandable comparison section
class GrandTotalSection extends StatefulWidget {
  final double totalAmount;
  final String currencySymbol;
  final String label;
  final bool isBaseCurrency;

  /// Journal amount from database (optional)
  /// When provided, shows journal balance and difference for user verification
  final double? journalAmount;

  /// Whether journal amount is being loaded
  final bool isLoadingJournal;

  /// Callback when history button is tapped
  /// Used to navigate to AccountDetailPage
  final VoidCallback? onHistoryTap;

  const GrandTotalSection({
    super.key,
    required this.totalAmount,
    required this.currencySymbol,
    this.label = 'Grand total',
    this.isBaseCurrency = true,
    this.journalAmount,
    this.isLoadingJournal = false,
    this.onHistoryTap,
  });

  @override
  State<GrandTotalSection> createState() => _GrandTotalSectionState();
}

class _GrandTotalSectionState extends State<GrandTotalSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final formattedAmount = '${widget.currencySymbol}${formatter.format(widget.totalAmount.toInt())}';
    final hasJournalData = widget.isBaseCurrency && (widget.journalAmount != null || widget.isLoadingJournal);

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: widget.isBaseCurrency
            ? TossColors.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HERO: Main Total Row - The counted amount (most important)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedAmount,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),

          // Journal comparison section (expandable)
          if (hasJournalData) ...[
            const SizedBox(height: TossSpacing.space3),

            // Expandable header
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Compare with Journal',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Expanded details
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: TossSpacing.space2),
                child: _buildExpandedDetails(formatter),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],

          // View History link (only show if available)
          if (widget.onHistoryTap != null) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(height: 1, color: TossColors.gray200),
            const SizedBox(height: TossSpacing.space3),
            GestureDetector(
              onTap: widget.onHistoryTap,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View History',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                      fontSize: 14,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build expanded details section (Toss style)
  /// Shows Journal and Difference with left border indicator
  Widget _buildExpandedDetails(NumberFormat formatter) {
    if (widget.isLoadingJournal) {
      return const Padding(
        padding: EdgeInsets.only(left: 12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: TossColors.gray400,
          ),
        ),
      );
    }

    final formattedJournal = '${widget.currencySymbol}${formatter.format(widget.journalAmount!.toInt())}';
    final difference = widget.totalAmount - widget.journalAmount!;
    final isBalanced = difference.abs() < 1;

    // Format difference with sign
    String formattedDifference;
    if (difference > 0) {
      formattedDifference = '+${widget.currencySymbol}${formatter.format(difference.toInt())}';
    } else if (difference < 0) {
      formattedDifference = '-${widget.currencySymbol}${formatter.format(difference.abs().toInt())}';
    } else {
      formattedDifference = '${widget.currencySymbol}${formatter.format(0)}';
    }

    // Determine color for difference
    Color differenceColor;
    if (isBalanced) {
      differenceColor = TossColors.gray500;
    } else if (difference < 0) {
      differenceColor = TossColors.error; // Shortage (red)
    } else {
      differenceColor = TossColors.success; // Surplus (green)
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: TossColors.gray300,
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        children: [
          // Journal row
          _buildDetailRow(
            label: 'Journal',
            value: formattedJournal,
            valueColor: TossColors.gray600,
          ),
          const SizedBox(height: TossSpacing.space2),
          // Difference row
          _buildDetailRow(
            label: 'Difference',
            value: formattedDifference,
            valueColor: differenceColor,
            isBold: !isBalanced,
          ),
        ],
      ),
    );
  }

  /// Build a single detail row (Toss style - subtle)
  Widget _buildDetailRow({
    required String label,
    required String value,
    required Color valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: valueColor,
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

}
