import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../sale_product/domain/entities/sales_product.dart';
import '../../providers/payment_providers.dart';

/// Bottom button widget for payment method page
class PaymentBottomButton extends ConsumerWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;
  final VoidCallback onPressed;

  const PaymentBottomButton({
    super.key,
    required this.selectedProducts,
    required this.productQuantities,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentMethodNotifierProvider);

    // Calculate cart total from selected products
    double cartTotal = 0;
    for (final product in selectedProducts) {
      final quantity = productQuantities[product.productId] ?? 0;
      final price = product.pricing.sellingPrice ?? 0;
      cartTotal += price * quantity;
    }

    // Calculate final total after discount
    final discountAmount = paymentState.discountAmount;
    final finalTotal = cartTotal - discountAmount;

    // Check if can proceed: need cash location selected AND non-negative total
    final canProceed =
        paymentState.selectedCashLocation != null && finalTotal >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: ElevatedButton(
        onPressed: canProceed ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canProceed ? TossColors.primary : TossColors.gray300,
          foregroundColor: TossColors.white,
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          elevation: 0,
        ),
        child: Text(
          'Create Invoice',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.white,
          ),
        ),
      ),
    );
  }
}
