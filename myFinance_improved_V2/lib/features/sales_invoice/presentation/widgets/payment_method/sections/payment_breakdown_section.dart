import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/toss/toggle_button.dart';
import '../../../../../sale_product/domain/entities/sales_product.dart';
import '../../../providers/payment_providers.dart';
import '../helpers/payment_helpers.dart';

/// Payment breakdown section with subtotal, discount, and total
class PaymentBreakdownSection extends ConsumerStatefulWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;

  const PaymentBreakdownSection({
    super.key,
    required this.selectedProducts,
    required this.productQuantities,
  });

  @override
  ConsumerState<PaymentBreakdownSection> createState() =>
      _PaymentBreakdownSectionState();
}

class _PaymentBreakdownSectionState
    extends ConsumerState<PaymentBreakdownSection> {
  final TextEditingController _discountController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  bool _isPercentageDiscount = false;
  bool _isDiscountFocused = false;

  @override
  void initState() {
    super.initState();
    _discountFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isDiscountFocused = _discountFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _discountFocusNode.removeListener(_onFocusChange);
    _discountController.dispose();
    _discountFocusNode.dispose();
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
    final paymentState = ref.watch(paymentMethodProvider);
    final discountAmount = paymentState.discountAmount;
    final finalTotal = _cartTotal - discountAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Payment breakdown',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space5),

        // Sub-total row
        _buildSubtotalRow(),
        const SizedBox(height: TossSpacing.space3 + 2),

        // Discount row
        _buildDiscountRow(discountAmount),

        // Discount hint - show percentage when amount mode, show amount when percentage mode
        if (discountAmount > 0 && _cartTotal > 0) ...[
          const SizedBox(height: TossSpacing.space1),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _isPercentageDiscount
                  ? '-${PaymentHelpers.formatNumber(discountAmount.round())}đ'
                  : '~${((discountAmount / _cartTotal) * 100).toStringAsFixed(1)}% discount',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w400,
                color: TossColors.error,
              ),
            ),
          ),
        ],

        // Divider
        Container(
          height: 1,
          color: TossColors.gray100,
          margin: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        ),

        // Total payment row
        _buildTotalRow(finalTotal),
      ],
    );
  }

  Widget _buildSubtotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sub-total',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        Text(
          '${PaymentHelpers.formatNumber(_cartTotal.round())}đ',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(double discountAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Discount label + toggle
        Row(
          children: [
            Text(
              'Discount',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            _buildDiscountToggle(),
          ],
        ),
        // Discount value + edit icon
        Row(
          children: [
            _buildDiscountInput(discountAmount),
            const SizedBox(width: TossSpacing.space1),
            GestureDetector(
              onTap: () {
                _discountFocusNode.requestFocus();
              },
              child: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountToggle() {
    return ToggleButtonGroup(
      height: 32,
      items: const [
        ToggleButtonItem(id: 'amount', label: '\$'),
        ToggleButtonItem(id: 'percent', label: '%'),
      ],
      selectedId: _isPercentageDiscount ? 'percent' : 'amount',
      onToggle: (id) {
        setState(() {
          _isPercentageDiscount = id == 'percent';
          _discountController.clear();
        });
        ref.read(paymentMethodProvider.notifier).updateDiscountAmount(0);
      },
    );
  }

  Widget _buildDiscountInput(double discountAmount) {
    // Display formatted discount with input field
    // Hide hint when focused to avoid cursor overlap
    final String? displayText;
    if (_isDiscountFocused || _isPercentageDiscount) {
      displayText = null; // No hint when focused or in percentage mode
    } else {
      displayText = discountAmount > 0
          ? '-${PaymentHelpers.formatNumber(discountAmount.round())}đ'
          : '0';
    }

    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: _discountController,
        focusNode: _discountFocusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TossTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: discountAmount > 0 ? TossColors.error : TossColors.gray400,
        ),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: displayText,
          hintStyle: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: discountAmount > 0 ? TossColors.error : TossColors.gray400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffixText: _isPercentageDiscount ? '%' : null,
          suffixStyle: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: discountAmount > 0 ? TossColors.error : TossColors.gray400,
          ),
        ),
        onChanged: (value) {
          // Remove existing commas to get raw number
          final rawValue = value.replaceAll(',', '');
          final inputValue = double.tryParse(rawValue) ?? 0;
          double discountAmt = 0;

          if (_isPercentageDiscount) {
            final percentage = inputValue.clamp(0, 100);
            discountAmt = (_cartTotal * percentage) / 100;
          } else {
            discountAmt = inputValue;

            // Format with commas for amount mode
            if (rawValue.isNotEmpty && !_isPercentageDiscount) {
              final formatted = PaymentHelpers.formatNumber(inputValue.round());
              if (formatted != value) {
                _discountController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            }
          }

          ref
              .read(paymentMethodProvider.notifier)
              .updateDiscountAmount(discountAmt);
        },
      ),
    );
  }

  Widget _buildTotalRow(double finalTotal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total payment',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          Text(
            '${PaymentHelpers.formatNumber(finalTotal.round())}đ',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
