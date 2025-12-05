// lib/features/cash_ending/presentation/widgets/grand_total_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Grand total section displayed at the bottom
///
/// Shows the final total amount in base currency
/// Updated: Now supports multi-currency Grand Total
/// Updated: Now shows Journal amount and Difference for verification
/// Updated: Added history button for viewing transaction history
class GrandTotalSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final formattedAmount = '$currencySymbol${formatter.format(totalAmount.toInt())}';

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Label + History Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontSize: 13,
                ),
              ),
              // History button (top-right corner)
              if (onHistoryTap != null)
                GestureDetector(
                  onTap: onHistoryTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: TossColors.gray200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          size: 16,
                          color: TossColors.gray700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'History',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: TossSpacing.space2),

          // PRIMARY: The counted amount (Grand Total) - Right aligned as HERO
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formattedAmount,
              style: TossTextStyles.h2.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),

          // SECONDARY: Journal comparison (only show when available)
          if (isBaseCurrency && (journalAmount != null || isLoadingJournal)) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildJournalComparison(formatter),
          ],
        ],
      ),
    );
  }

  /// Build vertical comparison section with right-aligned numbers
  /// Shows Real, Journal, and Difference in a table format for easy comparison
  Widget _buildJournalComparison(NumberFormat formatter) {
    if (isLoadingJournal) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: TossColors.gray400,
          ),
        ),
      );
    }

    final formattedJournal = '$currencySymbol${formatter.format(journalAmount!.toInt())}';
    final difference = totalAmount - journalAmount!;
    final isBalanced = difference.abs() < 1;

    // Format difference with sign
    String formattedDifference;
    if (difference > 0) {
      formattedDifference = '+$currencySymbol${formatter.format(difference.toInt())}';
    } else if (difference < 0) {
      formattedDifference = '-$currencySymbol${formatter.format(difference.abs().toInt())}';
    } else {
      formattedDifference = '$currencySymbol${formatter.format(0)}';
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

    return Column(
      children: [
        // Journal row
        _buildComparisonRow(
          label: 'Journal',
          value: formattedJournal,
          valueColor: TossColors.gray600,
          valueFontWeight: FontWeight.w500,
        ),
        const SizedBox(height: TossSpacing.space2),
        // Divider
        Container(
          height: 1,
          color: TossColors.gray200,
        ),
        const SizedBox(height: TossSpacing.space2),
        // Difference row
        _buildComparisonRow(
          label: 'Difference',
          value: formattedDifference,
          valueColor: differenceColor,
          valueFontWeight: isBalanced ? FontWeight.w500 : FontWeight.bold,
        ),
      ],
    );
  }

  /// Build a single row with label on left and value on right
  Widget _buildComparisonRow({
    required String label,
    required String value,
    required Color valueColor,
    required FontWeight valueFontWeight,
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
            fontSize: 16,
            fontWeight: valueFontWeight,
          ),
        ),
      ],
    );
  }

}
