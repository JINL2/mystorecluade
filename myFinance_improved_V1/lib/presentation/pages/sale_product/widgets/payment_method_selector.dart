import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../models/sale_product_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final Function(PaymentMethod) onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            // Cash
            _buildPaymentMethodButton(
              PaymentMethod.cash,
              'Cash',
              selectedMethod == PaymentMethod.cash,
            ),
            const SizedBox(width: TossSpacing.space3),
            
            // Bank Transfer
            _buildPaymentMethodButton(
              PaymentMethod.bankTransfer,
              'Bank transfer',
              selectedMethod == PaymentMethod.bankTransfer,
            ),
            const SizedBox(width: TossSpacing.space3),
            
            // Card
            _buildPaymentMethodButton(
              PaymentMethod.card,
              'Card',
              selectedMethod == PaymentMethod.card,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodButton(PaymentMethod method, String label, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () => onMethodChanged(method),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: isSelected ? TossColors.primary : TossColors.transparent,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: isSelected ? TossColors.primary : TossColors.gray300,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TossTextStyles.bodySmall.copyWith(
                  color: isSelected ? TossColors.white : TossColors.gray700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 20,
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs / 4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}