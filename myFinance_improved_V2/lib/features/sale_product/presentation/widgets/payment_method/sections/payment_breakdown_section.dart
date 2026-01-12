import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../../../shared/themes/toss_animations.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/sales_product.dart';
import '../../../providers/payment_providers.dart';
import '../helpers/payment_helpers.dart';

/// Unified adjustable row widget for Discount and Tax/Fees
/// Shared UI pattern: Label + Toggle + Input + Suffix + Subtext
class _AdjustableAmountRow extends StatelessWidget {
  final String label;
  final String currencySymbol;
  final bool isPercentageMode;
  final TextEditingController controller;
  final FocusNode focusNode;
  final double currentAmount;
  final Color activeColor;
  final void Function(String) onToggle;
  final void Function(String) onChanged;
  final String? subText; // e.g., "~0.1% discount" or "-1,520,000đ"

  const _AdjustableAmountRow({
    required this.label,
    required this.currencySymbol,
    required this.isPercentageMode,
    required this.controller,
    required this.focusNode,
    required this.currentAmount,
    required this.activeColor,
    required this.onToggle,
    required this.onChanged,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    // Check if input has actual value (not empty, not just "0")
    final inputText = controller.text.replaceAll(',', '').trim();
    final inputValue = double.tryParse(inputText) ?? 0;
    final hasValue = inputText.isNotEmpty && inputValue > 0;
    final displayColor = hasValue ? activeColor : TossColors.gray400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            // Label
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            // Toggle button
            ToggleButtonGroup(
              height: 28,
              items: [
                ToggleButtonItem(id: 'amount', label: currencySymbol),
                const ToggleButtonItem(id: 'percent', label: '%'),
              ],
              selectedId: isPercentageMode ? 'percent' : 'amount',
              onToggle: onToggle,
            ),
            // Fixed width container for input + suffix (right-aligned)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Input field with flexible width
                  Flexible(
                    child: TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: displayColor,
                      ),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: displayColor,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: onChanged,
                    ),
                  ),
                  const SizedBox(width: 2),
                  // Suffix label (₫ or %) - fixed position
                  SizedBox(
                    width: 16,
                    child: Text(
                      isPercentageMode ? '%' : currencySymbol,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: displayColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Subtext row (e.g., "~0.1% discount" or "-1,520,000đ")
        if (subText != null && subText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subText!,
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: activeColor,
              ),
            ),
          ),
      ],
    );
  }
}

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
      PaymentBreakdownSectionState();
}

class PaymentBreakdownSectionState
    extends ConsumerState<PaymentBreakdownSection> {
  final TextEditingController _discountController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  bool _isPercentageDiscount = false;
  bool _isDiscountFocused = false;
  /// Track if we need to sync from provider (e.g., Apply as Total)
  double _lastSyncedDiscountAmount = 0.0;

  // Tax/Fees state
  final TextEditingController _taxFeesController = TextEditingController();
  final FocusNode _taxFeesFocusNode = FocusNode();
  bool _isPercentageTaxFees = false;
  double _taxFeesAmount = 0.0;
  double _taxFeesPercentage = 0.0;

  // Collapsible state for each section
  bool _isDiscountExpanded = false;
  bool _isTaxFeesExpanded = false;

  /// Public method to apply target Total from Exchange Rate Panel
  /// Clears existing discount/tax and calculates the required adjustment
  /// [targetTotal] - the final total amount user wants
  /// Logic: difference = subtotal - targetTotal
  ///   - Positive: need discount to reduce from subtotal to targetTotal
  ///   - Negative: need tax/fees to increase from subtotal to targetTotal
  void applyAsTotal(double targetTotal) {
    final subtotal = _cartTotal;
    final difference = subtotal - targetTotal;

    // Clear both discount and tax/fees first
    _clearAllAdjustments();

    if (difference > 0) {
      // Need discount: subtotal > targetTotal
      final percentage = subtotal > 0 ? (difference / subtotal) * 100 : 0.0;

      setState(() {
        _isPercentageDiscount = false;
        _discountController.text = PaymentHelpers.formatNumber(difference.round());
        _isDiscountExpanded = true; // Auto-expand discount section
      });

      _lastSyncedDiscountAmount = difference;
      ref.read(paymentMethodNotifierProvider.notifier).updateDiscountWithSync(
        amount: difference,
        percentage: percentage,
        isPercentageMode: false,
      );
    } else if (difference < 0) {
      // Need tax/fees: subtotal < targetTotal (surcharge)
      final surcharge = difference.abs();
      final percentage = subtotal > 0 ? (surcharge / subtotal) * 100 : 0.0;

      setState(() {
        _taxFeesAmount = surcharge;
        _taxFeesPercentage = percentage;
        _isPercentageTaxFees = false;
        _taxFeesController.text = PaymentHelpers.formatNumber(surcharge.round());
        _isTaxFeesExpanded = true; // Auto-expand tax/fees section
      });

      // Sync to provider for journal entry calculation
      ref.read(paymentMethodNotifierProvider.notifier).updateTaxFeesAmount(
        amount: surcharge,
        percentage: percentage,
      );
    }
    // If difference == 0, both stay cleared (no adjustment needed)
  }

  /// Clear all adjustments (discount and tax/fees)
  void _clearAllAdjustments() {
    // Clear discount
    _discountController.clear();
    _isPercentageDiscount = false;
    _lastSyncedDiscountAmount = 0.0;
    ref.read(paymentMethodNotifierProvider.notifier).updateDiscountWithSync(
      amount: 0,
      percentage: 0,
      isPercentageMode: false,
    );

    // Clear tax/fees
    _taxFeesController.clear();
    _taxFeesAmount = 0.0;
    _taxFeesPercentage = 0.0;
    _isPercentageTaxFees = false;
    ref.read(paymentMethodNotifierProvider.notifier).updateTaxFeesAmount(
      amount: 0,
      percentage: 0,
    );
  }

  @override
  void initState() {
    super.initState();
    _discountFocusNode.addListener(_onFocusChange);
    _taxFeesFocusNode.addListener(_onTaxFeesFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isDiscountFocused = _discountFocusNode.hasFocus;
    });
  }

  void _onTaxFeesFocusChange() {
    setState(() {});
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
    _taxFeesFocusNode.removeListener(_onTaxFeesFocusChange);
    _discountController.dispose();
    _discountFocusNode.dispose();
    _taxFeesController.dispose();
    _taxFeesFocusNode.dispose();
    super.dispose();
  }

  double get _cartTotal {
    double total = 0;
    for (final product in widget.selectedProducts) {
      // Use uniqueId (variantId or productId) for quantity lookup
      final uniqueId = product.variantId ?? product.productId;
      final quantity = widget.productQuantities[uniqueId] ?? 0;
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
    final netTotal = _cartTotal - discountAmount;
    final grandTotal = netTotal + _taxFeesAmount;

    // Sync UI with provider state when discount changes externally
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWithProviderState(discountAmount, discountPercentage, isPercentageMode);
    });

    // Calculate discount subtext (show opposite value)
    String? discountSubText;
    if (discountAmount > 0) {
      if (_isPercentageDiscount) {
        // % mode: show amount below
        discountSubText = '-${PaymentHelpers.formatNumber(discountAmount.round())}${widget.currencySymbol}';
      } else {
        // đ mode: show percentage below
        final percent = _cartTotal > 0 ? (discountAmount / _cartTotal) * 100 : 0.0;
        discountSubText = '~${percent.toStringAsFixed(1)}% discount';
      }
    }

    // Calculate tax/fees subtext (show opposite value)
    String? taxFeesSubText;
    if (_taxFeesAmount > 0) {
      if (_isPercentageTaxFees) {
        // % mode: show amount below
        taxFeesSubText = '+${PaymentHelpers.formatNumber(_taxFeesAmount.round())}${widget.currencySymbol}';
      } else {
        // đ mode: show percentage below
        final percent = netTotal > 0 ? (_taxFeesAmount / netTotal) * 100 : 0.0;
        taxFeesSubText = '~${percent.toStringAsFixed(1)}%';
      }
    }

    // Check if each adjustment has value (can't collapse if has value)
    final hasDiscount = discountAmount > 0;
    final hasTaxFees = _taxFeesAmount > 0;

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

        // Sub-total row with expand/collapse indicator for Discount
        _buildExpandableRow(
          label: 'Sub-total',
          amount: _cartTotal,
          isExpanded: _isDiscountExpanded,
          hasValue: hasDiscount,
          onToggle: () => _handleDiscountSectionToggle(hasDiscount),
        ),

        // Collapsible Discount section (indented)
        TossAnimations.expandContent(
          isExpanded: _isDiscountExpanded,
          child: Padding(
            padding: const EdgeInsets.only(
              top: TossSpacing.space2,
              left: TossSpacing.space4, // Indent for hierarchy
            ),
            child: _AdjustableAmountRow(
              label: 'Discount',
              currencySymbol: widget.currencySymbol,
              isPercentageMode: _isPercentageDiscount,
              controller: _discountController,
              focusNode: _discountFocusNode,
              currentAmount: discountAmount,
              activeColor: TossColors.error,
              onToggle: _onDiscountToggle,
              onChanged: _onDiscountChanged,
              subText: discountSubText,
            ),
          ),
        ),

        // Divider before Net total
        Container(
          height: 1,
          color: TossColors.gray100,
          margin: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        ),

        // Net total row with expand/collapse indicator for Tax/Fees
        _buildExpandableRow(
          label: 'Net total',
          amount: netTotal,
          isExpanded: _isTaxFeesExpanded,
          hasValue: hasTaxFees,
          onToggle: () => _handleTaxFeesSectionToggle(hasTaxFees),
        ),

        // Collapsible Tax/Fees section (indented)
        TossAnimations.expandContent(
          isExpanded: _isTaxFeesExpanded,
          child: Padding(
            padding: const EdgeInsets.only(
              top: TossSpacing.space2,
              left: TossSpacing.space4, // Indent for hierarchy
            ),
            child: _AdjustableAmountRow(
              label: 'Tax/Fees',
              currencySymbol: widget.currencySymbol,
              isPercentageMode: _isPercentageTaxFees,
              controller: _taxFeesController,
              focusNode: _taxFeesFocusNode,
              currentAmount: _taxFeesAmount,
              activeColor: TossColors.primary,
              onToggle: _onTaxFeesToggle,
              onChanged: (value) => _onTaxFeesChanged(value, netTotal),
              subText: taxFeesSubText,
            ),
          ),
        ),

        // Divider before TOTAL
        Container(
          height: 1,
          color: TossColors.gray100,
          margin: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        ),

        // TOTAL row
        _buildGrandTotalRow(grandTotal),
      ],
    );
  }

  // ==================== Callback Methods ====================

  void _onDiscountToggle(String id) {
    final paymentState = ref.read(paymentMethodNotifierProvider);
    final currentAmount = paymentState.discountAmount;
    final currentPercentage = paymentState.discountPercentage;
    final switchingToPercent = id == 'percent';

    setState(() {
      _isPercentageDiscount = switchingToPercent;
      // Convert value to new mode
      if (currentAmount > 0) {
        if (switchingToPercent) {
          // đ → %: show percentage (only if meaningful, >= 1%)
          if (currentPercentage >= 1) {
            // Format: remove trailing zeros (e.g., 20.0 → 20)
            final percentStr = currentPercentage.truncateToDouble() == currentPercentage
                ? currentPercentage.toInt().toString()
                : currentPercentage.toStringAsFixed(1);
            _discountController.text = percentStr;
          } else {
            // Small percentage (< 1%), clear and let user input fresh
            _discountController.clear();
          }
        } else {
          // % → đ: show calculated amount
          _discountController.text = PaymentHelpers.formatNumber(currentAmount.round());
        }
      } else {
        _discountController.clear();
      }
    });

    _lastSyncedDiscountAmount = currentAmount;
    ref.read(paymentMethodNotifierProvider.notifier).updateDiscountWithSync(
      amount: currentAmount,
      percentage: currentPercentage,
      isPercentageMode: switchingToPercent,
    );
  }

  void _onDiscountChanged(String value) {
    final rawValue = value.replaceAll(',', '');
    final inputValue = double.tryParse(rawValue) ?? 0;
    double discountAmt = 0;
    double percentage = 0;

    if (_isPercentageDiscount) {
      percentage = inputValue.clamp(0, 100).toDouble();
      discountAmt = (_cartTotal * percentage) / 100;
    } else {
      // Clamp discount to max of cart total to prevent negative amounts
      discountAmt = inputValue.clamp(0, _cartTotal).toDouble();
      percentage = _cartTotal > 0 ? (discountAmt / _cartTotal) * 100 : 0;

      // Format with commas for amount mode
      if (rawValue.isNotEmpty) {
        final formatted = PaymentHelpers.formatNumber(inputValue.round());
        if (formatted != value) {
          _discountController.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      }
    }

    _lastSyncedDiscountAmount = discountAmt;
    ref.read(paymentMethodNotifierProvider.notifier).updateDiscountWithSync(
      amount: discountAmt,
      percentage: percentage,
      isPercentageMode: _isPercentageDiscount,
    );
  }

  void _onTaxFeesToggle(String id) {
    final switchingToPercent = id == 'percent';

    setState(() {
      _isPercentageTaxFees = switchingToPercent;
      // Convert value to new mode
      if (_taxFeesAmount > 0) {
        if (switchingToPercent) {
          // đ → %: show percentage (only if meaningful, >= 1%)
          if (_taxFeesPercentage >= 1) {
            // Format: remove trailing zeros (e.g., 20.0 → 20)
            final percentStr = _taxFeesPercentage.truncateToDouble() == _taxFeesPercentage
                ? _taxFeesPercentage.toInt().toString()
                : _taxFeesPercentage.toStringAsFixed(1);
            _taxFeesController.text = percentStr;
          } else {
            // Small percentage (< 1%), clear and let user input fresh
            _taxFeesController.clear();
          }
        } else {
          // % → đ: show calculated amount
          _taxFeesController.text = PaymentHelpers.formatNumber(_taxFeesAmount.round());
        }
      } else {
        _taxFeesController.clear();
      }
    });
  }

  void _onTaxFeesChanged(String value, double netTotal) {
    final rawValue = value.replaceAll(',', '');
    final inputValue = double.tryParse(rawValue) ?? 0;
    double taxAmount = 0;
    double percentage = 0;

    if (_isPercentageTaxFees) {
      percentage = inputValue.clamp(0, 100).toDouble();
      taxAmount = (netTotal * percentage) / 100;
    } else {
      taxAmount = inputValue;
      percentage = netTotal > 0 ? (taxAmount / netTotal) * 100 : 0;
      // Format with commas
      if (rawValue.isNotEmpty) {
        final formatted = PaymentHelpers.formatNumber(inputValue.round());
        if (formatted != value) {
          _taxFeesController.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      }
    }

    setState(() {
      _taxFeesAmount = taxAmount;
      _taxFeesPercentage = percentage;
    });

    // Sync to provider for journal entry calculation
    ref.read(paymentMethodNotifierProvider.notifier).updateTaxFeesAmount(
      amount: taxAmount,
      percentage: percentage,
    );
  }

  // ==================== Section Toggle Handlers ====================

  /// Handle discount section toggle with confirmation dialog
  void _handleDiscountSectionToggle(bool hasDiscount) {
    if (!_isDiscountExpanded) {
      // Expanding: just open
      setState(() => _isDiscountExpanded = true);
    } else if (hasDiscount) {
      // Collapsing with value: show confirmation
      _showClearConfirmationDialog(
        title: 'Remove Discount?',
        message: 'This will clear the discount amount.',
        onConfirm: () {
          _clearDiscount();
          setState(() => _isDiscountExpanded = false);
        },
      );
    } else {
      // Collapsing without value: just close
      setState(() => _isDiscountExpanded = false);
    }
  }

  /// Handle tax/fees section toggle with confirmation dialog
  void _handleTaxFeesSectionToggle(bool hasTaxFees) {
    if (!_isTaxFeesExpanded) {
      // Expanding: just open
      setState(() => _isTaxFeesExpanded = true);
    } else if (hasTaxFees) {
      // Collapsing with value: show confirmation
      _showClearConfirmationDialog(
        title: 'Remove Tax/Fees?',
        message: 'This will clear the tax/fees amount.',
        onConfirm: () {
          _clearTaxFees();
          setState(() => _isTaxFeesExpanded = false);
        },
      );
    } else {
      // Collapsing without value: just close
      setState(() => _isTaxFeesExpanded = false);
    }
  }

  /// Show confirmation dialog before clearing adjustment
  void _showClearConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog<bool>(
      context: context,
      builder: (context) => TossDialog.warning(
        title: title,
        message: message,
        icon: Icons.delete_outline,
        primaryButtonText: 'Remove',
        secondaryButtonText: 'Cancel',
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          onConfirm();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Clear only discount
  void _clearDiscount() {
    _discountController.clear();
    _isPercentageDiscount = false;
    _lastSyncedDiscountAmount = 0.0;
    ref.read(paymentMethodNotifierProvider.notifier).updateDiscountWithSync(
      amount: 0,
      percentage: 0,
      isPercentageMode: false,
    );
  }

  /// Clear only tax/fees
  void _clearTaxFees() {
    _taxFeesController.clear();
    _taxFeesAmount = 0.0;
    _taxFeesPercentage = 0.0;
    _isPercentageTaxFees = false;
    ref.read(paymentMethodNotifierProvider.notifier).updateTaxFeesAmount(
      amount: 0,
      percentage: 0,
    );
  }

  // ==================== UI Build Methods ====================

  /// Expandable row with toggle indicator
  /// Used for Sub-total (toggles Discount) and Net total (toggles Tax/Fees)
  Widget _buildExpandableRow({
    required String label,
    required double amount,
    required bool isExpanded,
    required bool hasValue,
    required VoidCallback onToggle,
  }) {
    final rowContent = Row(
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(width: 4),
        // Expand/collapse indicator with TossAnimations
        AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: TossAnimations.fast,
          curve: TossAnimations.standard,
          child: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: TossColors.gray500,
          ),
        ),
        const Spacer(),
        Text(
          '${PaymentHelpers.formatNumber(amount.round())}${widget.currencySymbol}',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
      ],
    );

    // Always tappable - handler decides what to do
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        splashColor: TossColors.gray200,
        highlightColor: TossColors.gray100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: rowContent,
        ),
      ),
    );
  }

  /// Grand total row
  Widget _buildGrandTotalRow(double grandTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray700,
          ),
        ),
        Text(
          '${PaymentHelpers.formatNumber(grandTotal.round())}${widget.currencySymbol}',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.primary,
          ),
        ),
      ],
    );
  }

}
