import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../helpers/navigation_helper.dart';
import 'models/sale_product_models.dart';
import 'sale_product_page.dart';
import 'widgets/delivery_toggle.dart';
import 'package:myfinance_improved/core/themes/index.dart';


// Payment State Provider
final paymentStateProvider = StateNotifierProvider<PaymentStateNotifier, PaymentState>((ref) {
  return PaymentStateNotifier();
});

class PaymentState {
  final PaymentMethod selectedMethod;
  final double customerPay;
  final bool isDelivery;
  final DeliveryInfo? deliveryInfo;
  final double discountPercent;
  final double discountAmount;
  final bool isPercentageDiscount;
  final double receivedAmount;

  PaymentState({
    this.selectedMethod = PaymentMethod.cash,
    this.customerPay = 0,
    this.isDelivery = false,
    this.deliveryInfo,
    this.discountPercent = 0,
    this.discountAmount = 0,
    this.isPercentageDiscount = true,
    this.receivedAmount = 0,
  });

  PaymentState copyWith({
    PaymentMethod? selectedMethod,
    double? customerPay,
    bool? isDelivery,
    DeliveryInfo? deliveryInfo,
    double? discountPercent,
    double? discountAmount,
    bool? isPercentageDiscount,
    double? receivedAmount,
  }) {
    return PaymentState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      customerPay: customerPay ?? this.customerPay,
      isDelivery: isDelivery ?? this.isDelivery,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      isPercentageDiscount: isPercentageDiscount ?? this.isPercentageDiscount,
      receivedAmount: receivedAmount ?? this.receivedAmount,
    );
  }
}

class PaymentStateNotifier extends StateNotifier<PaymentState> {
  PaymentStateNotifier() : super(PaymentState());

  void setPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  void setCustomerPay(double amount) {
    state = state.copyWith(customerPay: amount);
  }

  void toggleDelivery(bool isDelivery) {
    state = state.copyWith(isDelivery: isDelivery);
    if (!isDelivery) {
      state = state.copyWith(deliveryInfo: null);
    } else {
      state = state.copyWith(
        deliveryInfo: DeliveryInfo(
          isDelivery: true,
          address: 'Delivery Address',
          district: 'District',
          city: 'City',
          phone: '0333578879',
        ),
      );
    }
  }

  void setDeliveryInfo(DeliveryInfo info) {
    state = state.copyWith(deliveryInfo: info);
  }

  void setDiscountPercent(double percent) {
    state = state.copyWith(discountPercent: percent, isPercentageDiscount: true);
  }

  void setDiscountAmount(double amount) {
    state = state.copyWith(discountAmount: amount, isPercentageDiscount: false);
  }

  void toggleDiscountType() {
    state = state.copyWith(isPercentageDiscount: !state.isPercentageDiscount);
  }

  void setReceivedAmount(double amount) {
    state = state.copyWith(receivedAmount: amount);
  }
}

class SalePaymentPage extends ConsumerStatefulWidget {
  const SalePaymentPage({super.key});

  @override
  ConsumerState<SalePaymentPage> createState() => _SalePaymentPageState();
}

class _SalePaymentPageState extends ConsumerState<SalePaymentPage> {
  final TextEditingController _customerPayController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _receivedAmountController = TextEditingController();
  final FocusNode _paymentFocusNode = FocusNode();
  final FocusNode _discountFocusNode = FocusNode();
  final FocusNode _receivedFocusNode = FocusNode();

  @override
  void dispose() {
    _customerPayController.dispose();
    _discountController.dispose();
    _receivedAmountController.dispose();
    _paymentFocusNode.dispose();
    _discountFocusNode.dispose();
    _receivedFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = <String, int>{};
    final paymentState = ref.watch(paymentStateProvider);
    final subtotal = 0.0;
    final totalItems = 0;
    final formatter = NumberFormat('#,###');

    if (cart.isEmpty) {
      // If cart is empty, go back to product selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/saleProduct');
      });
      return const SizedBox.shrink();
    }

    // Calculate discount with cap to prevent negative total
    double discountValue = 0;
    if (paymentState.isPercentageDiscount) {
      discountValue = subtotal * (paymentState.discountPercent / 100);
    } else {
      discountValue = paymentState.discountAmount;
    }
    
    // Cap discount so total never goes negative
    discountValue = discountValue > subtotal ? subtotal : discountValue;
    
    final total = subtotal - discountValue;
    
    // Calculate change (simplified - only KRW)
    final receivedInKRW = paymentState.receivedAmount;
    final change = receivedInKRW - total;

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            NavigationHelper.safeGoBack(context);
          },
        ),
        title: Text(
          'Payment',
          style: TossTextStyles.h3,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.print_outlined, color: TossColors.gray600),
            onPressed: () {
              HapticFeedback.lightImpact();
              // Print action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: TossSpacing.space3),
            
            // Order Summary - Simple and Clean
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: TossWhiteCard(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          color: TossColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          'Order Summary',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.full),
                          ),
                          child: Text(
                            '$totalItems items',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    Divider(color: TossColors.gray100),
                    SizedBox(height: TossSpacing.space3),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          '₩${formatter.format(subtotal.round())}',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    
                    if (discountValue > 0) ...[
                      SizedBox(height: TossSpacing.space2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.success,
                            ),
                          ),
                          Text(
                            '-₩${formatter.format(discountValue.round())}',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.success,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Divider(color: TossColors.gray100),
                    ],
                    
                    SizedBox(height: TossSpacing.space2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TossTextStyles.h4.copyWith(
                            fontWeight: FontWeight.bold,
                            color: TossColors.gray900,
                          ),
                        ),
                        Text(
                          '₩${formatter.format(total.round())}',
                          style: TossTextStyles.h4.copyWith(
                            fontWeight: FontWeight.bold,
                            color: TossColors.primary,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: Text(
                        'View order details ▼',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Discount Calculator - Simple Design  
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: TossWhiteCard(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          color: TossColors.success,
                          size: 20,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          'Discount Calculator',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    Divider(color: TossColors.gray100),
                    SizedBox(height: TossSpacing.space3),
                    
                    // Discount Type Toggle - Clean Two Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!paymentState.isPercentageDiscount) {
                                ref.read(paymentStateProvider.notifier).toggleDiscountType();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: paymentState.isPercentageDiscount 
                                    ? TossColors.success 
                                    : TossColors.gray100,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Text(
                                'Percentage (%)',
                                textAlign: TextAlign.center,
                                style: TossTextStyles.body.copyWith(
                                  color: paymentState.isPercentageDiscount 
                                      ? TossColors.white 
                                      : TossColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (paymentState.isPercentageDiscount) {
                                ref.read(paymentStateProvider.notifier).toggleDiscountType();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: !paymentState.isPercentageDiscount 
                                    ? TossColors.success 
                                    : TossColors.gray100,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Text(
                                'Amount (₩)',
                                textAlign: TextAlign.center,
                                style: TossTextStyles.body.copyWith(
                                  color: !paymentState.isPercentageDiscount 
                                      ? TossColors.white 
                                      : TossColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Simple Discount Input
                    TextField(
                      controller: _discountController,
                      focusNode: _discountFocusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.gray900,
                      ),
                      decoration: InputDecoration(
                        hintText: paymentState.isPercentageDiscount ? '0%' : '₩0',
                        hintStyle: TossTextStyles.h2.copyWith(
                          color: TossColors.gray300,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0;
                        if (paymentState.isPercentageDiscount) {
                          // Cap percentage at 100%
                          final cappedPercent = amount > 100 ? 100.0 : amount;
                          ref.read(paymentStateProvider.notifier).setDiscountPercent(cappedPercent);
                        } else {
                          ref.read(paymentStateProvider.notifier).setDiscountAmount(amount);
                        }
                      },
                    ),
                    
                    // Quick Percentage Buttons - Only show for percentage mode
                    if (paymentState.isPercentageDiscount) ...[
                      SizedBox(height: TossSpacing.space3),
                      Row(
                        children: [5, 10, 15, 20].map((percent) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                              child: GestureDetector(
                                onTap: () {
                                  _discountController.text = percent.toString();
                                  ref.read(paymentStateProvider.notifier).setDiscountPercent(percent.toDouble());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                                  decoration: BoxDecoration(
                                    color: TossColors.gray100,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  ),
                                  child: Text(
                                    '$percent%',
                                    textAlign: TextAlign.center,
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Payment Method Section - Clean Design
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: TossWhiteCard(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.payment,
                          color: TossColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          'Payment Method',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    Divider(color: TossColors.gray100),
                    SizedBox(height: TossSpacing.space3),
                    
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(paymentStateProvider.notifier).setPaymentMethod(PaymentMethod.cash);
                            },
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space4),
                              decoration: BoxDecoration(
                                color: paymentState.selectedMethod == PaymentMethod.cash
                                    ? TossColors.primary.withValues(alpha: 0.1)
                                    : TossColors.gray50,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                border: Border.all(
                                  color: paymentState.selectedMethod == PaymentMethod.cash
                                      ? TossColors.primary
                                      : TossColors.gray200,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.money,
                                    color: paymentState.selectedMethod == PaymentMethod.cash
                                        ? TossColors.primary
                                        : TossColors.gray600,
                                    size: 20,
                                  ),
                                  SizedBox(width: TossSpacing.space2),
                                  Text(
                                    'Cash',
                                    style: TossTextStyles.body.copyWith(
                                      color: paymentState.selectedMethod == PaymentMethod.cash
                                          ? TossColors.primary
                                          : TossColors.gray700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(paymentStateProvider.notifier).setPaymentMethod(PaymentMethod.card);
                            },
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space4),
                              decoration: BoxDecoration(
                                color: paymentState.selectedMethod == PaymentMethod.card
                                    ? TossColors.primary.withValues(alpha: 0.1)
                                    : TossColors.gray50,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                border: Border.all(
                                  color: paymentState.selectedMethod == PaymentMethod.card
                                      ? TossColors.primary
                                      : TossColors.gray200,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    color: paymentState.selectedMethod == PaymentMethod.card
                                        ? TossColors.primary
                                        : TossColors.gray600,
                                    size: 20,
                                  ),
                                  SizedBox(width: TossSpacing.space2),
                                  Text(
                                    'Card',
                                    style: TossTextStyles.body.copyWith(
                                      color: paymentState.selectedMethod == PaymentMethod.card
                                          ? TossColors.primary
                                          : TossColors.gray700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Amount Received - Simple Design  
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: TossWhiteCard(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          color: TossColors.info,
                          size: 20,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          'Amount Received',
                          style: TossTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    Divider(color: TossColors.gray100),
                    SizedBox(height: TossSpacing.space3),
                    
                    // Simple Amount Input  
                    TextField(
                      controller: _receivedAmountController,
                      focusNode: _receivedFocusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.gray900,
                      ),
                      decoration: InputDecoration(
                        hintText: '₩0',
                        hintStyle: TossTextStyles.h2.copyWith(
                          color: TossColors.gray300,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value.replaceAll(',', '')) ?? 0;
                        ref.read(paymentStateProvider.notifier).setReceivedAmount(amount);
                      },
                    ),
                    
                    // Quick Amount Buttons - Only for cash
                    if (paymentState.selectedMethod == PaymentMethod.cash) ...[
                      SizedBox(height: TossSpacing.space3),
                      Row(
                        children: [total.toInt(), 50000, 100000].map((amount) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                              child: GestureDetector(
                                onTap: () {
                                  _receivedAmountController.text = formatter.format(amount);
                                  ref.read(paymentStateProvider.notifier).setReceivedAmount(amount.toDouble());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                                  decoration: BoxDecoration(
                                    color: amount == total.toInt() ? TossColors.info.withValues(alpha: 0.1) : TossColors.gray100,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  ),
                                  child: Text(
                                    amount == total.toInt() ? 'Exact' : '₩${formatter.format(amount)}',
                                    textAlign: TextAlign.center,
                                    style: TossTextStyles.caption.copyWith(
                                      color: amount == total.toInt() ? TossColors.info : TossColors.gray700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Change Calculation - Clean Design
            if (receivedInKRW > 0)
              Container(
                margin: EdgeInsets.all(TossSpacing.space4),
                child: TossWhiteCard(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  child: Row(
                    children: [
                      Container(
                        width: TossSpacing.space10,
                        height: TossSpacing.space10,
                        decoration: BoxDecoration(
                          color: change >= 0 
                              ? TossColors.success.withValues(alpha: 0.1)
                              : TossColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Icon(
                          change >= 0 
                              ? Icons.check
                              : Icons.info_outline,
                          color: change >= 0 
                              ? TossColors.success
                              : TossColors.warning,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              change >= 0 ? 'Change' : 'Amount Needed',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            Text(
                              '₩${formatter.format(change.abs().round())}',
                              style: TossTextStyles.h4.copyWith(
                                fontWeight: FontWeight.bold,
                                color: change >= 0 
                                    ? TossColors.success
                                    : TossColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Delivery Toggle
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: DeliveryToggle(
                isDelivery: paymentState.isDelivery,
                deliveryInfo: paymentState.deliveryInfo,
                onToggle: (isDelivery) {
                  HapticFeedback.lightImpact();
                  ref.read(paymentStateProvider.notifier).toggleDelivery(isDelivery);
                },
              ),
            ),
            
            // Bottom padding for fixed button
            SizedBox(height: 120),
          ],
        ),
      ),
      
      // Complete Payment Button using TossPrimaryButton
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          border: Border(
            top: BorderSide(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: TossPrimaryButton(
            text: 'Complete',
            fullWidth: true,
            isEnabled: receivedInKRW > 0 && !(paymentState.selectedMethod == PaymentMethod.cash && change < 0),
            leadingIcon: Icon(
              Icons.check_circle_outline,
              color: TossColors.white,
              size: 20,
            ),
            onPressed: () {
              _completePayment(context, total, change);
            },
          ),
        ),
      ),
    );
  }


  void _showOrderDetails(BuildContext context, List<CartItem> cart, NumberFormat formatter) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: TossSpacing.space12,
              height: TossSpacing.space1,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
            
            // Title
            Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Order Details',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Items List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                itemCount: cart.length,
                separatorBuilder: (context, index) => Divider(
                  color: TossColors.gray100,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '₩${_formatCurrency(item.price)} × ${item.quantity}',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₩${_formatCurrency(item.subtotal)}',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Close Button
            Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.gray100,
                  foregroundColor: TossColors.gray700,
                  minimumSize: Size(double.infinity, TossSpacing.buttonHeightLG),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.button),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completePayment(BuildContext context, double total, double change) {
    final paymentState = ref.read(paymentStateProvider);
    
    // Show success animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.dialog),
        ),
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon with Animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: TossSpacing.space20,
                      height: TossSpacing.space20,
                      decoration: BoxDecoration(
                        color: TossColors.success.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: TossColors.success,
                        size: TossSpacing.space12,
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              Text(
                'Payment Successful!',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: TossSpacing.space2),
              
              Text(
                '₩${NumberFormat('#,###').format(total.round())}',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              if (paymentState.selectedMethod == PaymentMethod.cash && change > 0) ...[
                SizedBox(height: TossSpacing.space3),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: TossColors.success,
                        size: TossSpacing.iconSM,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        'Change: ₩${NumberFormat('#,###').format(change.round())}',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              SizedBox(height: TossSpacing.space6),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Print receipt logic
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        side: BorderSide(color: TossColors.gray300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.button),
                        ),
                      ),
                      child: Text(
                        'Print',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        // Clear cart and start new sale
                        // ref.read(cartProvider.notifier).clearCart();
                        Navigator.pop(context);
                        context.go('/saleProduct');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.button),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'New Sale',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    // Format with commas for exact numbers, no K or M abbreviations
    final formatter = NumberFormat('#,##0', 'en_US');
    
    // For zero values, you can return a dash or just 0
    if (value == 0) {
      return '0';
    }
    
    // Format the value with commas
    String formatted = formatter.format(value.round());
    return formatted;
  }

}