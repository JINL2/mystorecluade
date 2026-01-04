import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/sales_product.dart';
import '../../../providers/payment_providers.dart';
import '../helpers/payment_helpers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Payment breakdown section with subtotal, discount, and total
class PaymentBreakdownSection extends ConsumerStatefulWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;
  final String currencySymbol;

  const PaymentBreakdownSection({
    super.key,
    required this.selectedProducts,
    required this.productQuantities,
    this.currencySymbol = '₫',
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
  /// Track if we need to sync from provider (e.g., Apply as Total)
  double _lastSyncedDiscountAmount = 0.0;

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

  /// Sync UI with provider state when discount changes externally (e.g., Apply as Total)
  void _syncWithProviderState(double discountAmount, double discountPercentage, bool isPercentageMode) {
    // Only sync if discount amount changed externally and not currently editing
    if (!_isDiscountFocused && discountAmount != _lastSyncedDiscountAmount) {
      _lastSyncedDiscountAmount = discountAmount;

      // Update toggle mode
      if (_isPercentageDiscount != isPercentageMode) {
        _isPercentageDiscount = isPercentageMode;
      }

      // Update text field with synced value
      if (isPercentageMode && discountPercentage > 0) {
        _discountController.text = discountPercentage.toStringAsFixed(1);
      } else if (!isPercentageMode && discountAmount > 0) {
        _discountController.text = PaymentHelpers.formatNumber(discountAmount.round());
      } else {
        _discountController.clear();
      }
    }
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
    final paymentState = ref.watch(paymentMethodNotifierProvider);
    final discountAmount = paymentState.discountAmount;
    final discountPercentage = paymentState.discountPercentage;
    final isPercentageMode = paymentState.isPercentageMode;
    final finalTotal = _cartTotal - discountAmount;

    // Sync UI with provider state when discount changes externally
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWithProviderState(discountAmount, discountPercentage, isPercentageMode);
    });

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
                  ? '-${PaymentHelpers.formatNumber(discountAmount.round())}${widget.currencySymbol}'
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
          '${PaymentHelpers.formatNumber(_cartTotal.round())}${widget.currencySymbol}',
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
      items: [
        ToggleButtonItem(id: 'amount', label: widget.currencySymbol),
        const ToggleButtonItem(id: 'percent', label: '%'),
      ],
      selectedId: _isPercentageDiscount ? 'percent' : 'amount',
      onToggle: (id) {
        setState(() {
          _isPercentageDiscount = id == 'percent';
          _discountController.clear();
        });
        // Reset last synced amount
        _lastSyncedDiscountAmount = 0;
        ref.read(paymentMethodNotifierProvider.notifier).updateDiscountWithSync(
          amount: 0,
          percentage: 0,
          isPercentageMode: id == 'percent',
        );
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
          ? '-${PaymentHelpers.formatNumber(discountAmount.round())}${widget.currencySymbol}'
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
          double percentage = 0;

          if (_isPercentageDiscount) {
            percentage = inputValue.clamp(0, 100).toDouble();
            discountAmt = (_cartTotal * percentage) / 100;
          } else {
            discountAmt = inputValue;
            // Calculate percentage from amount
            percentage = _cartTotal > 0 ? (discountAmt / _cartTotal) * 100 : 0;

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

          // Update last synced amount to prevent re-sync
          _lastSyncedDiscountAmount = discountAmt;

          ref
              .read(paymentMethodNotifierProvider.notifier)
              .updateDiscountWithSync(
                amount: discountAmt,
                percentage: percentage,
                isPercentageMode: _isPercentageDiscount,
              );
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
            '${PaymentHelpers.formatNumber(finalTotal.round())}${widget.currencySymbol}',
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
