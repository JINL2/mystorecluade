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
import '../../widgets/common/toss_section_header.dart';
import '../../widgets/common/toss_toggle_button.dart';
import '../../widgets/common/toss_number_input.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_chip.dart';
import '../../helpers/navigation_helper.dart';
import 'models/sale_product_models.dart';
import 'sale_product_page.dart';
import 'widgets/delivery_toggle.dart';

// Currency enum
enum Currency {
  KRW,
  USD,
  EUR,
  JPY,
  CNY,
  VND,
  THB,
  SGD,
}

// Mock exchange rates (UI only - would come from API in production)
final Map<Currency, double> mockExchangeRates = {
  Currency.KRW: 1.0,
  Currency.USD: 0.00075,  // 1 KRW = 0.00075 USD
  Currency.EUR: 0.00068,  // 1 KRW = 0.00068 EUR
  Currency.JPY: 0.11,     // 1 KRW = 0.11 JPY
  Currency.CNY: 0.0054,   // 1 KRW = 0.0054 CNY
  Currency.VND: 18.5,     // 1 KRW = 18.5 VND
  Currency.THB: 0.027,    // 1 KRW = 0.027 THB
  Currency.SGD: 0.001,    // 1 KRW = 0.001 SGD
};

// Currency display info
Map<Currency, Map<String, dynamic>> currencyInfo = {
  Currency.KRW: {'symbol': '₩', 'code': 'KRW', 'name': 'Korean Won', 'flag': '🇰🇷'},
  Currency.USD: {'symbol': '\$', 'code': 'USD', 'name': 'US Dollar', 'flag': '🇺🇸'},
  Currency.EUR: {'symbol': '€', 'code': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'},
  Currency.JPY: {'symbol': '¥', 'code': 'JPY', 'name': 'Japanese Yen', 'flag': '🇯🇵'},
  Currency.CNY: {'symbol': '¥', 'code': 'CNY', 'name': 'Chinese Yuan', 'flag': '🇨🇳'},
  Currency.VND: {'symbol': '₫', 'code': 'VND', 'name': 'Vietnamese Dong', 'flag': '🇻🇳'},
  Currency.THB: {'symbol': '฿', 'code': 'THB', 'name': 'Thai Baht', 'flag': '🇹🇭'},
  Currency.SGD: {'symbol': 'S\$', 'code': 'SGD', 'name': 'Singapore Dollar', 'flag': '🇸🇬'},
};

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
  final Currency receivedCurrency;
  final double receivedAmount;

  PaymentState({
    this.selectedMethod = PaymentMethod.cash,
    this.customerPay = 0,
    this.isDelivery = false,
    this.deliveryInfo,
    this.discountPercent = 0,
    this.discountAmount = 0,
    this.isPercentageDiscount = true,
    this.receivedCurrency = Currency.KRW,
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
    Currency? receivedCurrency,
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
      receivedCurrency: receivedCurrency ?? this.receivedCurrency,
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

  void setReceivedCurrency(Currency currency) {
    state = state.copyWith(receivedCurrency: currency);
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
    final cart = ref.watch(cartProvider);
    final paymentState = ref.watch(paymentStateProvider);
    final subtotal = ref.read(cartProvider.notifier).subtotal;
    final totalItems = ref.read(cartProvider.notifier).totalItems;
    final formatter = NumberFormat('#,###');

    if (cart.isEmpty) {
      // If cart is empty, go back to product selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/saleProduct');
      });
      return const SizedBox.shrink();
    }

    // Calculate discount
    double discountValue = 0;
    if (paymentState.isPercentageDiscount) {
      discountValue = subtotal * (paymentState.discountPercent / 100);
    } else {
      discountValue = paymentState.discountAmount;
    }
    
    final total = subtotal - discountValue;
    
    // Calculate received amount in KRW
    double receivedInKRW = paymentState.receivedAmount;
    if (paymentState.receivedCurrency != Currency.KRW) {
      // Convert to KRW
      double rate = mockExchangeRates[paymentState.receivedCurrency] ?? 1.0;
      receivedInKRW = paymentState.receivedAmount / rate;
    }
    
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
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
              child: Column(
                children: [
                  TossSectionHeader(
                    title: 'Order Summary',
                    icon: Icons.receipt_long_outlined,
                    trailing: Container(
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
                  ),
                  
                  SizedBox(height: TossSpacing.space2),
                  
                  TossWhiteCard(
                    padding: EdgeInsets.all(TossSpacing.space4),
                    child: Column(
                      children: [
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
                            _showOrderDetails(context, cart, formatter);
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
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Discount Calculator - Cleaner Design
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                children: [
                  TossSectionHeader(
                    title: 'Discount Calculator',
                    icon: Icons.calculate_outlined,
                    iconColor: TossColors.success,
                  ),
                  
                  SizedBox(height: TossSpacing.space2),
                  
                  TossWhiteCard(
                    padding: EdgeInsets.all(TossSpacing.space4),
                    child: Column(
                      children: [
                        // Discount Type Toggle using TossToggleButtonGroup
                        TossToggleButtonGroup(
                          buttons: [
                            TossToggleButtonData(
                              label: 'Percentage (%)',
                              value: 'percentage',
                              icon: Icons.percent,
                              activeColor: TossColors.success,
                            ),
                            TossToggleButtonData(
                              label: 'Amount (₩)',
                              value: 'amount',
                              icon: Icons.money,
                              activeColor: TossColors.success,
                            ),
                          ],
                          selectedValue: paymentState.isPercentageDiscount ? 'percentage' : 'amount',
                          onPressed: (value) {
                            if ((value == 'percentage') != paymentState.isPercentageDiscount) {
                              ref.read(paymentStateProvider.notifier).toggleDiscountType();
                            }
                          },
                        ),
                        
                        SizedBox(height: TossSpacing.space3),
                        
                        // Discount Input using TossNumberInput
                        TossNumberInput(
                          controller: _discountController,
                          focusNode: _discountFocusNode,
                          hintText: '0',
                          prefix: paymentState.isPercentageDiscount ? '' : '₩',
                          suffix: paymentState.isPercentageDiscount ? '%' : '',
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0;
                            if (paymentState.isPercentageDiscount) {
                              ref.read(paymentStateProvider.notifier).setDiscountPercent(amount);
                            } else {
                              ref.read(paymentStateProvider.notifier).setDiscountAmount(amount);
                            }
                          },
                        ),
                        
                        // Quick Discount Buttons using TossChipGroup
                        if (paymentState.isPercentageDiscount) ...[
                          SizedBox(height: TossSpacing.space3),
                          TossChipGroup(
                            items: [5, 10, 15, 20].map((percent) => TossChipItem(
                              value: percent.toString(),
                              label: '$percent%',
                            )).toList(),
                            selectedValue: paymentState.discountPercent > 0 
                                ? paymentState.discountPercent.toString() 
                                : null,
                            onChanged: (value) {
                              if (value != null) {
                                final percent = double.parse(value);
                                _discountController.text = percent.toString();
                                ref.read(paymentStateProvider.notifier).setDiscountPercent(percent);
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Payment Method Section - Clean Design
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                children: [
                  TossSectionHeader(
                    title: 'Payment Method',
                    icon: Icons.payment,
                  ),
                  
                  SizedBox(height: TossSpacing.space2),
                  
                  TossWhiteCard(
                    padding: EdgeInsets.all(TossSpacing.space4),
                    child: _buildPaymentMethodGrid(paymentState.selectedMethod),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Amount Received Section - Cleaner Design
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                children: [
                  TossSectionHeader(
                    title: 'Amount Received',
                    icon: Icons.payments_outlined,
                    iconColor: TossColors.info,
                    trailing: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _receivedAmountController.text = total.toStringAsFixed(0);
                        ref.read(paymentStateProvider.notifier).setReceivedAmount(total);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.full),
                        ),
                        child: Text(
                          'Exact',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.info,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space2),
                  
                  TossWhiteCard(
                    padding: EdgeInsets.all(TossSpacing.space4),
                    child: Column(
                      children: [
                        // Currency Selector using TossChipGroup
                        TossChipGroup(
                          items: Currency.values.map((currency) => TossChipItem(
                            value: currency.toString(),
                            label: '${currencyInfo[currency]!['flag']} ${currencyInfo[currency]!['code']}',
                          )).toList(),
                          selectedValue: paymentState.receivedCurrency.toString(),
                          onChanged: (value) {
                            if (value != null) {
                              final currency = Currency.values.firstWhere(
                                (c) => c.toString() == value,
                              );
                              ref.read(paymentStateProvider.notifier).setReceivedCurrency(currency);
                            }
                          },
                        ),
                        
                        SizedBox(height: TossSpacing.space4),
                        
                        // Amount Input using TossNumberInput
                        TossNumberInput(
                          controller: _receivedAmountController,
                          focusNode: _receivedFocusNode,
                          hintText: '0',
                          prefix: currencyInfo[paymentState.receivedCurrency]!['symbol'],
                          onChanged: (value) {
                            final amount = double.tryParse(value.replaceAll(',', '')) ?? 0;
                            ref.read(paymentStateProvider.notifier).setReceivedAmount(amount);
                          },
                        ),
                        
                        // Exchange Rate Display
                        if (paymentState.receivedCurrency != Currency.KRW && paymentState.receivedAmount > 0) ...[
                          SizedBox(height: TossSpacing.space3),
                          Container(
                            padding: EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              color: TossColors.info.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.currency_exchange,
                                  size: 16,
                                  color: TossColors.info,
                                ),
                                SizedBox(width: TossSpacing.space2),
                                Expanded(
                                  child: Text(
                                    '${currencyInfo[paymentState.receivedCurrency]!['symbol']}${_formatCurrency(paymentState.receivedAmount)} = ₩${formatter.format(receivedInKRW.round())}',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.info,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        // Quick Add Buttons using TossChipGroup
                        SizedBox(height: TossSpacing.space3),
                        TossChipGroup(
                          items: _getQuickAmounts(paymentState.receivedCurrency).map((amount) => TossChipItem(
                            value: amount.toString(),
                            label: '+${currencyInfo[paymentState.receivedCurrency]!['symbol']}${_formatQuickAmount(amount, paymentState.receivedCurrency)}',
                          )).toList(),
                          selectedValue: null, // Quick buttons don't stay selected
                          onChanged: (value) {
                            if (value != null) {
                              final amount = double.parse(value);
                              final currentAmount = double.tryParse(
                                _receivedAmountController.text.replaceAll(',', '')
                              ) ?? 0;
                              final newAmount = currentAmount + amount;
                              _receivedAmountController.text = _formatCurrencyForInput(newAmount, paymentState.receivedCurrency);
                              ref.read(paymentStateProvider.notifier).setReceivedAmount(newAmount);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
            text: 'Complete Payment',
            fullWidth: true,
            isEnabled: receivedInKRW > 0 && !(paymentState.selectedMethod == PaymentMethod.cash && change < 0),
            leadingIcon: Icon(
              Icons.check_circle_outline,
              color: Colors.white,
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

  Widget _buildPaymentMethodGrid(PaymentMethod selectedMethod) {
    final methods = [
      {'method': PaymentMethod.cash, 'icon': Icons.money, 'label': 'Cash'},
      {'method': PaymentMethod.card, 'icon': Icons.credit_card, 'label': 'Card'},
      {'method': PaymentMethod.bankTransfer, 'icon': Icons.swap_horiz, 'label': 'Transfer'},
      {'method': PaymentMethod.digitalWallet, 'icon': Icons.qr_code, 'label': 'QR Code'},
    ];
    
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: TossSpacing.space3,
      crossAxisSpacing: TossSpacing.space3,
      childAspectRatio: 2.5,
      children: methods.map((item) {
        final method = item['method'] as PaymentMethod;
        final icon = item['icon'] as IconData;
        final label = item['label'] as String;
        final isSelected = selectedMethod == method;
        
        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(paymentStateProvider.notifier).setPaymentMethod(method);
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected 
                  ? TossColors.primary.withValues(alpha: 0.1)
                  : TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: isSelected 
                    ? TossColors.primary
                    : TossColors.gray200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected 
                      ? TossColors.primary
                      : TossColors.gray600,
                  size: TossSpacing.iconSM,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected 
                        ? TossColors.primary
                        : TossColors.gray700,
                    fontWeight: isSelected 
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
                        ref.read(cartProvider.notifier).clearCart();
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
                          color: Colors.white,
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
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return '${value.toStringAsFixed(0)}';
  }

  List<double> _getQuickAmounts(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return [10, 20, 50, 100];
      case Currency.EUR:
        return [10, 20, 50, 100];
      case Currency.JPY:
        return [1000, 5000, 10000, 50000];
      case Currency.CNY:
        return [50, 100, 500, 1000];
      case Currency.VND:
        return [100000, 500000, 1000000, 5000000];
      case Currency.THB:
        return [100, 500, 1000, 5000];
      case Currency.SGD:
        return [10, 20, 50, 100];
      case Currency.KRW:
        return [50000, 100000, 500000, 1000000];
    }
  }

  String _formatCurrencyForInput(double value, Currency currency) {
    if (currency == Currency.JPY || currency == Currency.VND || currency == Currency.KRW) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  String _formatQuickAmount(double value, Currency currency) {
    switch (currency) {
      case Currency.VND:
        if (value >= 1000000) {
          return '${(value / 1000000).toStringAsFixed(0)}M';
        } else if (value >= 1000) {
          return '${(value / 1000).toStringAsFixed(0)}K';
        }
        return value.toStringAsFixed(0);
      case Currency.KRW:
      case Currency.JPY:
        if (value >= 10000) {
          return '${(value / 1000).toStringAsFixed(0)}K';
        }
        return value.toStringAsFixed(0);
      default:
        return value.toStringAsFixed(0);
    }
  }
}