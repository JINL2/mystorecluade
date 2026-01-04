// lib/features/cash_ending/presentation/widgets/grand_total_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Grand total section displayed at the bottom
///
/// Shows the final total amount in base currency
/// Design: Toss-style expandable comparison section
///
/// When currency is foreign (not base currency):
/// - Shows total in local currency
/// - Shows converted amount in base currency for comparison with Journal
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

  /// Exchange rate from local currency to base currency (for foreign currency conversion)
  /// Only used when isBaseCurrency is false
  /// Example: CNY -> VND rate = 3731.34 means 1 CNY = 3731.34 VND
  final double? exchangeRateToBase;

  /// Base currency symbol (e.g., '₫' for VND)
  /// Only used when isBaseCurrency is false to show converted amount
  final String? baseCurrencySymbol;

  /// Whether this is a flow transaction (In/Out) vs stock (Recount)
  /// When true, shows expected balance after transaction instead of direct comparison
  final bool isFlowTransaction;

  /// The flow amount being added/removed (only for flow transactions)
  final double? flowAmount;

  /// Whether this is a debit (In) transaction - only for flow transactions
  final bool isDebit;

  /// Current real stock amount from database (for flow transactions)
  /// Used to calculate: Expected = Real + Flow, then compare with Journal
  final double? realAmount;

  const GrandTotalSection({
    super.key,
    required this.totalAmount,
    required this.currencySymbol,
    this.label = 'Grand total',
    this.isBaseCurrency = true,
    this.journalAmount,
    this.isLoadingJournal = false,
    this.onHistoryTap,
    this.exchangeRateToBase,
    this.baseCurrencySymbol,
    this.isFlowTransaction = false,
    this.flowAmount,
    this.isDebit = true,
    this.realAmount,
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

    // For foreign currency: check if we need to show converted amount for journal comparison
    final isForeignCurrency = !widget.isBaseCurrency &&
        widget.exchangeRateToBase != null &&
        widget.exchangeRateToBase! > 0 &&
        widget.baseCurrencySymbol != null;

    // Calculate converted amount to base currency (for journal comparison)
    final convertedAmountToBase = isForeignCurrency
        ? widget.totalAmount * widget.exchangeRateToBase!
        : widget.totalAmount;

    // Show journal comparison if:
    // 1. Base currency with journal data, OR
    // 2. Foreign currency with exchange rate (to compare converted amount with journal)
    final hasJournalData = (widget.journalAmount != null || widget.isLoadingJournal) &&
        (widget.isBaseCurrency || isForeignCurrency);

    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HERO: Main Total Row - minimal style like salary breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedAmount,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  // Show converted base currency amount for foreign currencies
                  if (isForeignCurrency) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${widget.baseCurrencySymbol}${formatter.format(convertedAmountToBase.toInt())}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
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
                    duration: TossAnimations.normal,
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
                child: _buildExpandedDetails(
                  formatter,
                  isForeignCurrency: isForeignCurrency,
                  convertedAmountToBase: convertedAmountToBase,
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: TossAnimations.normal,
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
  ///
  /// For foreign currencies:
  /// - Uses convertedAmountToBase for difference calculation
  /// - Shows both local currency amount and base currency conversion
  ///
  /// For flow transactions (In/Out):
  /// - Shows current Journal balance
  /// - Shows expected balance after transaction (Journal ± flowAmount)
  /// - Shows the flow amount being added/removed
  Widget _buildExpandedDetails(
    NumberFormat formatter, {
    required bool isForeignCurrency,
    required double convertedAmountToBase,
  }) {
    if (widget.isLoadingJournal) {
      return const Padding(
        padding: EdgeInsets.only(left: 12),
        child: TossLoadingView.inline(size: 16, color: TossColors.gray400),
      );
    }

    // For foreign currency: use base currency symbol and converted amount
    // For base currency: use local currency symbol and original amount
    final comparisonSymbol = isForeignCurrency
        ? widget.baseCurrencySymbol!
        : widget.currencySymbol;

    final journalAmount = widget.journalAmount!;
    final formattedJournal = '$comparisonSymbol${formatter.format(journalAmount.toInt())}';

    // Both Flow and Stock modes show Journal vs Real comparison
    // For Flow (In/Out): also show the transaction details as reference

    // Calculate Real amount (what user counted) for stock comparison
    final countedAmount = isForeignCurrency
        ? convertedAmountToBase
        : widget.totalAmount;

    // Calculate difference: Counted - Journal (for stock mode)
    final difference = countedAmount - journalAmount;
    final isBalanced = difference.abs() < 1;

    // Format difference with sign
    String formattedDifference;
    if (difference > 0) {
      formattedDifference = '+$comparisonSymbol${formatter.format(difference.toInt())}';
    } else if (difference < 0) {
      formattedDifference = '-$comparisonSymbol${formatter.format(difference.abs().toInt())}';
    } else {
      formattedDifference = '$comparisonSymbol${formatter.format(0)}';
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

    // Flow transaction: show Real + Flow = Expected, compare with Journal
    // Real = current actual stock from cash_amount_entries
    // Expected = Real ± Flow
    // Difference = Expected - Journal
    if (widget.isFlowTransaction && widget.flowAmount != null && widget.realAmount != null) {
      final flowAmount = widget.flowAmount!;
      final currentReal = widget.realAmount!;

      // Calculate expected stock after transaction
      final expectedAfterFlow = widget.isDebit
          ? currentReal + flowAmount  // In: Real + Flow
          : currentReal - flowAmount; // Out: Real - Flow

      // Calculate flow difference: Expected - Journal
      final flowDifference = expectedAfterFlow - journalAmount;
      final isFlowBalanced = flowDifference.abs() < 1;

      // Format values
      final formattedFlow = widget.isDebit
          ? '+$comparisonSymbol${formatter.format(flowAmount.toInt())}'
          : '-$comparisonSymbol${formatter.format(flowAmount.toInt())}';
      final formattedReal = '$comparisonSymbol${formatter.format(currentReal.toInt())}';
      final formattedExpected = '$comparisonSymbol${formatter.format(expectedAfterFlow.toInt())}';

      // Format flow difference with sign
      String formattedFlowDifference;
      if (flowDifference > 0) {
        formattedFlowDifference = '+$comparisonSymbol${formatter.format(flowDifference.toInt())}';
      } else if (flowDifference < 0) {
        formattedFlowDifference = '-$comparisonSymbol${formatter.format(flowDifference.abs().toInt())}';
      } else {
        formattedFlowDifference = '$comparisonSymbol${formatter.format(0)}';
      }

      // Determine color for flow difference
      Color flowDifferenceColor;
      if (isFlowBalanced) {
        flowDifferenceColor = TossColors.gray500;
      } else if (flowDifference < 0) {
        flowDifferenceColor = TossColors.error; // Shortage (red)
      } else {
        flowDifferenceColor = TossColors.success; // Surplus (green)
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
            // Current Real (actual stock before transaction)
            InfoRow.between(
              label: 'Current Real',
              value: formattedReal,
              valueColor: TossColors.gray600,
            ),
            const SizedBox(height: TossSpacing.space2),
            // Flow amount (In/Out)
            InfoRow.between(
              label: widget.isDebit ? 'Vault In' : 'Vault Out',
              value: formattedFlow,
              valueColor: widget.isDebit ? TossColors.success : TossColors.error,
              valueStyle: TossTextStyles.body.copyWith(
                color: widget.isDebit ? TossColors.success : TossColors.error,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            // Expected (Real ± Flow)
            InfoRow.between(
              label: 'Expected',
              value: formattedExpected,
              valueColor: TossColors.gray900,
              valueStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            // Divider
            Container(height: 1, color: TossColors.gray200),
            const SizedBox(height: TossSpacing.space3),
            // Journal (book balance)
            InfoRow.between(
              label: 'Journal',
              value: formattedJournal,
              valueColor: TossColors.gray600,
            ),
            const SizedBox(height: TossSpacing.space2),
            // Difference: Expected - Journal
            InfoRow.between(
              label: 'Difference',
              value: formattedFlowDifference,
              valueColor: flowDifferenceColor,
              valueStyle: TossTextStyles.body.copyWith(
                color: flowDifferenceColor,
                fontSize: 14,
                fontWeight: !isFlowBalanced ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

    // Stock comparison (Recount mode or Cash/Bank tabs)
    // Uses the same difference calculation from above
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
          InfoRow.between(
            label: 'Journal',
            value: formattedJournal,
            valueColor: TossColors.gray600,
          ),
          const SizedBox(height: TossSpacing.space2),
          // Difference row
          InfoRow.between(
            label: 'Difference',
            value: formattedDifference,
            valueColor: differenceColor,
            valueStyle: TossTextStyles.body.copyWith(
              color: differenceColor,
              fontSize: 14,
              fontWeight: !isBalanced ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

}
