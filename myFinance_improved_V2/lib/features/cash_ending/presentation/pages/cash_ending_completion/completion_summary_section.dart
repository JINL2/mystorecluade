// lib/features/cash_ending/presentation/pages/cash_ending_completion/completion_summary_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/balance_summary.dart';
import '../../../domain/entities/currency.dart';
import '../../extensions/balance_summary_formatting.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Summary section for cash ending completion page
///
/// Displays Total Journal, Total Real, Difference with Auto-Balance option
class CompletionSummarySection extends StatelessWidget {
  final BalanceSummary? currentBalanceSummary;
  final BalanceSummary? previousBalanceSummary;
  final String? appliedAdjustmentType;
  final double grandTotal;
  final List<Currency> currencies;
  final VoidCallback onAutoBalancePressed;

  const CompletionSummarySection({
    super.key,
    this.currentBalanceSummary,
    this.previousBalanceSummary,
    this.appliedAdjustmentType,
    required this.grandTotal,
    required this.currencies,
    required this.onAutoBalancePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Use balance summary data if available, otherwise use defaults
    final totalJournal = currentBalanceSummary?.totalJournal ?? 0.0;
    final totalReal = currentBalanceSummary?.totalReal ?? grandTotal;
    final difference = currentBalanceSummary?.difference ?? (totalReal - totalJournal);
    final isBalanced = currentBalanceSummary?.isBalanced ?? (difference.abs() < 0.01);

    // Determine difference color
    Color differenceColor = TossColors.gray900;
    if (!isBalanced) {
      if (difference < 0) {
        differenceColor = TossColors.loss; // Shortage (red)
      } else {
        differenceColor = TossColors.warning; // Surplus (orange)
      }
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Show adjustment details if auto-balance was applied
          if (appliedAdjustmentType != null && previousBalanceSummary != null) ...[
            _AdjustmentInfoSection(
              previousBalanceSummary: previousBalanceSummary!,
              appliedAdjustmentType: appliedAdjustmentType!,
              formatAmount: _formatAmount,
            ),
            const SizedBox(height: TossSpacing.space4),
            const Divider(color: TossColors.gray200, height: 1),
            const SizedBox(height: TossSpacing.space4),
          ],

          _buildSummaryRow(
            'Total Journal',
            currentBalanceSummary != null
              ? currentBalanceSummary!.formattedTotalJournal
              : _formatAmount(totalJournal)
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow(
            'Total Real',
            currentBalanceSummary != null
              ? currentBalanceSummary!.formattedTotalReal
              : _formatAmount(totalReal)
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow(
            'Difference',
            currentBalanceSummary != null
              ? currentBalanceSummary!.formattedDifference
              : _formatAmount(difference),
            valueColor: differenceColor,
            isLarge: true,
            subtitle: currentBalanceSummary?.formattedPercentage,
            subtitleColor: _getPercentageColor(currentBalanceSummary),
          ),

          // Only show Auto-Balance if there's a difference
          if (!isBalanced) ...[
            const SizedBox(height: TossSpacing.space4),

            // Auto-Balance to Match text button
            Align(
              alignment: Alignment.centerLeft,
              child: TossButton.textButton(
                text: 'Auto-Balance to Match',
                onPressed: onAutoBalancePressed,
                leadingIcon: const Icon(Icons.sync, size: 18),
                textColor: TossColors.primary,
                fontWeight: FontWeight.w600,
                padding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: TossSpacing.space2),

            // Helper text
            Text(
              'Make sure today\'s Journal entries are complete before using Auto-Balance - missing entries often cause differences.',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    bool isLarge = false,
    String? subtitle,
    Color? subtitleColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: (isLarge ? TossTextStyles.bodyMedium : TossTextStyles.body).copyWith(
            color: TossColors.gray600,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: (isLarge ? TossTextStyles.bodyMedium : TossTextStyles.body).copyWith(
                color: valueColor ?? TossColors.gray900,
                fontWeight: isLarge ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            // Show subtitle (percentage) if provided
            if (subtitle != null) ...[
              SizedBox(height: TossSpacing.space1 / 2),
              Text(
                subtitle,
                style: TossTextStyles.small.copyWith(
                  color: subtitleColor ?? TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat.currency(
      symbol: currencies.isNotEmpty ? currencies.first.symbol : '',
      decimalDigits: 2,
    ).format(amount);
  }

  /// Get color for percentage based on level
  Color _getPercentageColor(BalanceSummary? summary) {
    if (summary == null) return TossColors.gray500;

    switch (summary.percentageLevel) {
      case PercentageLevel.safe:
        return TossColors.success;
      case PercentageLevel.warning:
        return TossColors.warning;
      case PercentageLevel.critical:
        return TossColors.error;
    }
  }
}

/// Internal widget for displaying adjustment info
class _AdjustmentInfoSection extends StatelessWidget {
  final BalanceSummary previousBalanceSummary;
  final String appliedAdjustmentType;
  final String Function(double) formatAmount;

  const _AdjustmentInfoSection({
    required this.previousBalanceSummary,
    required this.appliedAdjustmentType,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    final adjustmentAmount = previousBalanceSummary.difference;

    // Determine color based on adjustment type and direction
    final bool isNegativeAdjustment = adjustmentAmount < 0;
    final bool isErrorAdjustment = appliedAdjustmentType == 'Error Adjustment';

    final Color boxColor;
    final IconData boxIcon;

    if (isErrorAdjustment && isNegativeAdjustment) {
      boxColor = TossColors.error;
      boxIcon = Icons.warning;
    } else if (isErrorAdjustment && !isNegativeAdjustment) {
      boxColor = TossColors.success;
      boxIcon = Icons.check_circle;
    } else {
      boxColor = TossColors.primary;
      boxIcon = Icons.currency_exchange;
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: boxColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: boxColor.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon
          Row(
            children: [
              Icon(
                boxIcon,
                size: 18,
                color: boxColor,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Auto-Balance Applied',
                style: TossTextStyles.bodySmall.copyWith(
                  color: boxColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Old Total Journal
          _buildAdjustmentRow(
            'Old Total Journal',
            previousBalanceSummary.formattedTotalJournal,
            TossColors.gray600,
          ),
          const SizedBox(height: TossSpacing.space2),

          // Adjustment Type & Amount
          _buildAdjustmentRow(
            appliedAdjustmentType,
            adjustmentAmount >= 0
                ? '+${formatAmount(adjustmentAmount.abs())}'
                : '-${formatAmount(adjustmentAmount.abs())}',
            boxColor,
            isBold: true,
          ),
          const SizedBox(height: TossSpacing.space2),

          // Total Real (target)
          _buildAdjustmentRow(
            'Total Real',
            previousBalanceSummary.formattedTotalReal,
            TossColors.primary,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
