// lib/features/cash_ending/presentation/widgets/sheets/flow_detail_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../../domain/entities/stock_flow.dart';

/// Flow Detail Bottom Sheet - Shows cash/bank/vault transaction details
class FlowDetailBottomSheet extends StatelessWidget {
  final ActualFlow flow;
  final LocationSummary? locationSummary;
  final String baseCurrencySymbol;

  const FlowDetailBottomSheet({
    super.key,
    required this.flow,
    required this.locationSummary,
    required this.baseCurrencySymbol,
  });

  /// Show flow detail bottom sheet
  static void show({
    required BuildContext context,
    required ActualFlow flow,
    required LocationSummary? locationSummary,
    required String baseCurrencySymbol,
  }) {
    TossBottomSheet.show(
      context: context,
      title: 'Cash Count Details',
      content: FlowDetailBottomSheet(
        flow: flow,
        locationSummary: locationSummary,
        baseCurrencySymbol: baseCurrencySymbol,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = locationSummary?.baseCurrencySymbol ?? baseCurrencySymbol;

    // Filter denominations that have comparative data (previous vs current)
    final comparativeDenoms = flow.currentDenominations
        .where((denom) => denom.hasComparativeData)
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Info
          _buildTransactionInfo(currencySymbol),

          const SizedBox(height: TossSpacing.space5),

          // Denomination Details
          if (comparativeDenoms.isNotEmpty) ...[
            Text(
              'Denomination Breakdown',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            _buildDenominationSection(comparativeDenoms, currencySymbol),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.gray200, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: TossColors.gray500,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'No denomination breakdown available for this transaction',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo(String currencySymbol) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200, width: 1),
      ),
      child: Column(
        children: [
          _buildInfoRow('Amount', _formatCurrency(flow.flowAmount, currencySymbol),
              valueColor: flow.flowAmount >= 0 ? TossColors.primary : TossColors.error),
          const SizedBox(height: TossSpacing.space2),
          _buildInfoRow('Balance After', _formatCurrency(flow.balanceAfter, currencySymbol)),
          const SizedBox(height: TossSpacing.space2),
          _buildInfoRow('Counted By', flow.createdBy.fullName),
          const SizedBox(height: TossSpacing.space2),
          _buildInfoRow('Date', flow.getFormattedDate()),
          const SizedBox(height: TossSpacing.space2),
          _buildInfoRow('Time', flow.getFormattedTime()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: valueColor ?? TossColors.gray900,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }


  Widget _buildDenominationSection(
      List<DenominationDetail> denominations, String currencySymbol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: denominations
          .map((denom) => _buildDenominationItem(denom, currencySymbol))
          .toList(),
    );
  }

  Widget _buildDenominationItem(DenominationDetail denom, String currencySymbol) {
    // Safe access to nullable fields (should always have values due to filter)
    final qtyChange = denom.quantityChange ?? 0;
    final prevQty = denom.previousQuantity ?? 0;
    final currQty = denom.currentQuantity ?? 0;

    final changeColor = qtyChange > 0
        ? TossColors.primary
        : (qtyChange < 0 ? TossColors.error : TossColors.gray900);
    final changeText = qtyChange == 0
        ? '0'
        : (qtyChange > 0 ? '+$qtyChange' : '$qtyChange');

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Denomination value header with icon
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: const Icon(
                  Icons.attach_money,
                  size: 18,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                _formatCurrency(denom.denominationValue, currencySymbol),
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Quantity table
          Row(
            children: [
              // Previous Qty column
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Previous Qty',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      '$prevQty',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Change column
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Change',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      changeText,
                      style: TossTextStyles.h3.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Current Qty column
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Current Qty',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      '$currQty',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          const SizedBox(height: TossSpacing.space2),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                _formatCurrency(denom.subtotal, currencySymbol),
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Format currency amount
  String _formatCurrency(double amount, String symbol) {
    final formatter = NumberFormat('#,###');
    return '$symbol${formatter.format(amount.abs())}';
  }
}
