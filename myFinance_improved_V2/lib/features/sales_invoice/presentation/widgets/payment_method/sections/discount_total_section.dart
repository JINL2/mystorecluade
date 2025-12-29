import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../../sale_product/domain/entities/sales_product.dart';
import '../../../providers/payment_providers.dart';
import '../helpers/payment_helpers.dart';

/// Unified discount and total section widget
class DiscountTotalSection extends ConsumerStatefulWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;

  const DiscountTotalSection({
    super.key,
    required this.selectedProducts,
    required this.productQuantities,
  });

  @override
  ConsumerState<DiscountTotalSection> createState() =>
      _DiscountTotalSectionState();
}

class _DiscountTotalSectionState extends ConsumerState<DiscountTotalSection> {
  late TextEditingController _discountController;
  bool _isPercentageDiscount = false;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController();
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  double get _cartTotal {
    double total = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final price = product.pricing.sellingPrice ?? 0;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentMethodNotifierProvider);
    final discountAmount = paymentState.discountAmount;
    final finalTotal = _cartTotal - discountAmount;

    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtotalRow(),
          _buildDiscountRow(discountAmount),
          if (discountAmount > 0) _buildDivider(),
          _buildTotalRow(finalTotal),
        ],
      ),
    );
  }

  Widget _buildSubtotalRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: TossSpacing.space3,
        horizontal: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Sub-total',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: const BoxDecoration(
                  color: TossColors.gray400,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.selectedProducts.length}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Text(
            PaymentHelpers.formatNumber(_cartTotal.round()),
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountRow(double discountAmount) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: TossSpacing.space3,
        horizontal: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Discount',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    _buildDiscountToggle(),
                  ],
                ),
              ),
              _buildDiscountInput(),
            ],
          ),
          // Show percentage indicator below the toggle when discount is applied
          if (discountAmount > 0 && _cartTotal > 0) ...[
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Saving ${((discountAmount / _cartTotal) * 100).toStringAsFixed(1)}% off subtotal',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscountToggle() {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            label: 'Amount',
            isSelected: !_isPercentageDiscount,
            onTap: () {
              setState(() {
                _isPercentageDiscount = false;
                _discountController.clear();
              });
              ref.read(paymentMethodNotifierProvider.notifier).updateDiscountAmount(0);
            },
          ),
          _buildToggleButton(
            label: '%',
            isSelected: _isPercentageDiscount,
            onTap: () {
              setState(() {
                _isPercentageDiscount = true;
                _discountController.clear();
              });
              ref.read(paymentMethodNotifierProvider.notifier).updateDiscountAmount(0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? TossColors.white : TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountInput() {
    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: _discountController,
        keyboardType:
            TextInputType.numberWithOptions(decimal: !_isPercentageDiscount),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: TossColors.gray900,
        ),
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(
            fontSize: 15,
            color: TossColors.gray400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          final inputValue =
              double.tryParse(value.replaceAll(',', '')) ?? 0;
          double discountAmount = 0;

          if (_isPercentageDiscount) {
            final percentage = inputValue.clamp(0, 100);
            discountAmount = (_cartTotal * percentage) / 100;
          } else {
            discountAmount = inputValue;
          }

          ref
              .read(paymentMethodNotifierProvider.notifier)
              .updateDiscountAmount(discountAmount);
        },
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Divider(
        color: TossColors.gray300,
        height: 1,
      ),
    );
  }

  Widget _buildTotalRow(double finalTotal) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: TossSpacing.space3,
        horizontal: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            PaymentHelpers.formatNumber(finalTotal.round()),
            style: TossTextStyles.h2.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
