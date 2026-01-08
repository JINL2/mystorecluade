import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_opacity.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/invoice_detail.dart';

/// Payment Method Section for invoice detail
class PaymentMethodSection extends StatelessWidget {
  final Invoice invoice;
  final InvoiceDetail? detail;

  const PaymentMethodSection({
    super.key,
    required this.invoice,
    this.detail,
  });

  /// Get payment method icon based on cash location type
  IconData _getPaymentIcon() {
    final locationType = detail?.cashLocationType?.toLowerCase() ??
        invoice.cashLocation?.locationType.toLowerCase() ??
        '';
    final paymentMethod =
        detail?.paymentMethod.toLowerCase() ?? invoice.paymentMethod.toLowerCase();

    if (locationType == 'cash' || paymentMethod == 'cash') {
      return Icons.payments_outlined;
    } else if (locationType == 'bank' || paymentMethod == 'bank') {
      return Icons.account_balance_outlined;
    } else if (locationType == 'vault' || paymentMethod == 'vault') {
      return Icons.grid_view_outlined;
    }
    return Icons.payments_outlined;
  }

  /// Get payment method display name
  String _getPaymentMethodName() {
    final locationType = detail?.cashLocationType?.toLowerCase() ??
        invoice.cashLocation?.locationType.toLowerCase() ??
        '';
    final paymentMethod =
        detail?.paymentMethod.toLowerCase() ?? invoice.paymentMethod.toLowerCase();

    if (locationType == 'cash' || paymentMethod == 'cash') {
      return 'Cash';
    } else if (locationType == 'bank' || paymentMethod == 'bank') {
      return 'Bank Transfer';
    } else if (locationType == 'vault' || paymentMethod == 'vault') {
      return 'Vault';
    }
    return detail?.paymentMethod ?? invoice.paymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    final locationName =
        detail?.cashLocationName ?? invoice.cashLocation?.locationName;
    final isPaid = detail?.isPaid ?? invoice.isPaid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Payment method',
            style: TossTextStyles.body.copyWith(
              fontWeight: TossFontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              // Payment icon
              Icon(
                _getPaymentIcon(),
                color: TossColors.gray700,
                size: TossSpacing.iconMD2,
              ),
              const SizedBox(width: TossSpacing.space3),
              // Payment method name
              Text(
                _getPaymentMethodName(),
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: TossColors.gray900,
                ),
              ),
              const Spacer(),
              // Location name or status
              if (locationName != null)
                Text(
                  locationName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                )
              else
                // Payment status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? TossColors.success.withValues(alpha: TossOpacity.light)
                        : TossColors.warning.withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    isPaid ? 'Paid' : 'Pending',
                    style: TossTextStyles.small.copyWith(
                      color: isPaid ? TossColors.success : TossColors.warning,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
