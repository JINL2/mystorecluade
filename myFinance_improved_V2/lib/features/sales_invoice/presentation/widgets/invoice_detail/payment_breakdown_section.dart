import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/invoice_detail.dart';

/// Payment Breakdown Section for invoice detail
class PaymentBreakdownSection extends StatelessWidget {
  final Invoice invoice;
  final InvoiceDetail? detail;
  final String currencySymbol;

  const PaymentBreakdownSection({
    super.key,
    required this.invoice,
    this.detail,
    this.currencySymbol = '',
  });

  static final _currencyFormat =
      NumberFormat.currency(symbol: '', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final subtotal = detail?.subtotal ?? invoice.amounts.subtotal;
    final discountAmount = detail?.discountAmount ?? invoice.amounts.discountAmount;
    final taxAmount = detail?.taxAmount ?? invoice.amounts.taxAmount;
    final totalAmount = detail?.totalAmount ?? invoice.amounts.totalAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Payment breakdown',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          // Sub-total
          _buildPaymentRow('Sub-total', _formatAmount(subtotal)),

          // Discount (if any)
          if (discountAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildDiscountRow(subtotal, discountAmount),
          ],

          // Tax (if any)
          if (taxAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildPaymentRow('Tax', _formatAmount(taxAmount)),
          ],

          const SizedBox(height: TossSpacing.space4),

          // Divider before total
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          const SizedBox(height: TossSpacing.space4),

          // Total payment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total payment',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              Text(
                _formatAmount(totalAmount),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(double subtotal, double discountAmount) {
    final discountPercent = _calculateDiscountPercent(subtotal, discountAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Text(
              '-${_formatAmount(discountAmount)}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.error,
              ),
            ),
          ],
        ),
        if (discountPercent.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            '~$discountPercent discount',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  String _formatAmount(double amount) {
    final formatted = _currencyFormat.format(amount);
    if (currencySymbol.isEmpty || currencySymbol == '\$') {
      return '$formattedđ';
    }
    return '$currencySymbol$formatted';
  }

  String _calculateDiscountPercent(double subtotal, double discountAmount) {
    if (subtotal <= 0) return '';
    final percent = (discountAmount / subtotal) * 100;
    return '${percent.toStringAsFixed(1)}%';
  }
}
