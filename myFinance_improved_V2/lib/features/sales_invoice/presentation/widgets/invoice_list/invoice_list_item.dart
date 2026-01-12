import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/ai/ai_description_row.dart';
import '../../../domain/entities/invoice.dart';
import '../../extensions/invoice_display_extension.dart';
import '../../pages/invoice_detail_page.dart';
import '../../providers/invoice_list_provider.dart';

/// Individual invoice list item - matches the screenshot design
class InvoiceListItem extends ConsumerWidget {
  final Invoice invoice;
  final void Function(Invoice invoice)? onRefundPressed;

  const InvoiceListItem({
    super.key,
    required this.invoice,
    this.onRefundPressed,
  });

  static final _currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

  /// Get payment method icon based on cash location type or payment method
  IconData get _paymentIcon {
    final locationType = invoice.cashLocation?.locationType.toLowerCase() ?? '';
    final paymentMethod = invoice.paymentMethod.toLowerCase();

    if (locationType == 'cash' || paymentMethod == 'cash') {
      return Icons.payments_outlined;
    } else if (locationType == 'bank' || paymentMethod == 'bank') {
      return Icons.account_balance_outlined;
    } else if (locationType == 'vault' || paymentMethod == 'vault') {
      return Icons.lock_outline;
    }
    return Icons.payments_outlined; // default to cash icon
  }

  /// Check if invoice is cancelled
  bool get _isCancelled => invoice.isCancelled;

  /// Get product summary text - shows first item name + remaining count
  String get _productSummary {
    final summary = invoice.itemsSummary;
    final itemCount = summary.itemCount;
    final totalQuantity = summary.totalQuantity;
    final firstProductName = summary.firstProductName;

    if (itemCount <= 0) {
      return 'No products';
    }

    // Show first product name if available
    if (firstProductName != null && firstProductName.isNotEmpty) {
      if (totalQuantity == 1) {
        // Only 1 item total
        return firstProductName;
      }
      // More than 1 item: show first name + remaining items
      final remaining = totalQuantity - 1;
      return '$firstProductName + $remaining item${remaining > 1 ? 's' : ''}';
    }

    // Fallback to just item count
    return '$totalQuantity item${totalQuantity > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(invoiceListNotifierProvider).response?.currency;

    return InkWell(
      onTap: () {
        InvoiceDetailPage.navigate(
          context,
          invoice,
          currency?.symbol,
          onRefundPressed: onRefundPressed,
        );
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment method icon
          SizedBox(
            width: TossSpacing.iconMD2,
            height: TossSpacing.iconMD2,
            child: Icon(
              _paymentIcon,
              size: TossSpacing.iconSM2,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(width: TossSpacing.space3),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invoice number and time
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: invoice.invoiceNumber,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.gray900,
                        ),
                      ),
                      TextSpan(
                        text: ' · ${invoice.timeString}',
                        style: TossTextStyles.caption.copyWith(
                          fontWeight: TossFontWeight.regular,
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                // Product summary
                Text(
                  _productSummary,
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: TossFontWeight.regular,
                    color: TossColors.gray600,
                    height: 1.4,
                  ),
                ),
                // AI Summary (if available)
                if (invoice.aiDescription != null &&
                    invoice.aiDescription!.isNotEmpty) ...[
                  SizedBox(height: TossSpacing.space1),
                  AiDescriptionRow(text: invoice.aiDescription!),
                ],
              ],
            ),
          ),
          SizedBox(width: TossSpacing.space3),

          // Amount and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount
              Text(
                _formatAmount(invoice.amounts.totalAmount, currency?.symbol ?? ''),
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: _isCancelled ? TossColors.error : TossColors.primary,
                ),
              ),
              // Cancelled pill (if cancelled)
              if (_isCancelled) ...[
                SizedBox(height: TossSpacing.space1),
                _buildCancelledPill(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledPill() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.badgePaddingHorizontalSM,
        vertical: TossSpacing.badgePaddingVerticalSM,
      ),
      decoration: BoxDecoration(
        color: TossColors.error,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      child: Text(
        'Cancelled',
        style: TossTextStyles.small.copyWith(
          fontWeight: TossFontWeight.medium,
          color: TossColors.white,
        ),
      ),
    );
  }

  String _formatAmount(double amount, String symbol) {
    final formatted = _currencyFormat.format(amount);
    // Add currency symbol at end with đ for VND style
    if (symbol.isEmpty || symbol == '\$') {
      return '$formattedđ';
    }
    return '$symbol$formatted';
  }
}
