import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Import domain entities
import '../../../domain/entities/bank_real_entry.dart' as bank;

// Import presentation display model
import '../../providers/cash_location_providers.dart' show CashRealDisplay;

/// Bottom sheet for displaying cash count denomination breakdown
/// Uses domain entity: CashRealDisplay (from presentation providers)
class DenominationDetailSheet extends StatelessWidget {
  final CashRealDisplay cashRealItem;

  const DenominationDetailSheet({
    super.key,
    required this.cashRealItem,
  });

  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final realEntry = cashRealItem.realEntry;
    final currencySymbol = realEntry.getCurrencySymbol();

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: TossDimensions.dragHandleWidth,
            height: TossDimensions.dragHandleHeight,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Cash Count Details',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: TossFontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: TossSpacing.iconMD2),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Amount
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: TossOpacity.light),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Counted',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              _formatCurrency(realEntry.totalAmount, currencySymbol),
                              style: TossTextStyles.h1.copyWith(
                                fontWeight: TossFontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.attach_money,
                          color: Theme.of(context).colorScheme.primary,
                          size: TossSpacing.iconLG2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space6),

                  // Details
                  _buildDetailRow('Date', _formatDate(realEntry.recordDate)),
                  _buildDetailRow('Time', _formatTime(realEntry.createdAt)),
                  _buildDetailRow('Location', realEntry.locationName),

                  const SizedBox(height: TossSpacing.space6),

                  // Denomination Breakdown
                  if (realEntry.currencySummary.isNotEmpty) ...[
                    Text(
                      'Denomination Breakdown',
                      style: TossTextStyles.h4,
                    ),
                    const SizedBox(height: TossSpacing.space3),

                    ...realEntry.currencySummary.expand((currency) {
                      return currency.denominations
                        .where((d) => d.quantity > 0)
                        .map((denomination) => _buildDenominationItem(denomination, currency.symbol));
                    }),
                  ],

                  // Bottom padding
                  const SizedBox(height: TossSpacing.space5),
                ],
              ),
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: InfoRow.fixed(
        label: label,
        value: value,
        labelWidth: 80,
      ),
    );
  }

  Widget _buildDenominationItem(bank.Denomination denomination, String symbol) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Denomination value
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  _formatCurrency(denomination.denominationValue, symbol),
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: TossColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                '× ${denomination.quantity}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.medium,
                ),
              ),
            ],
          ),

          // Subtotal
          Text(
            _formatCurrency(denomination.subtotal, symbol),
            style: TossTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
