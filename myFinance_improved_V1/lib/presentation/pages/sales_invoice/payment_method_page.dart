import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_icons_fa.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../helpers/navigation_helper.dart';
import 'models/invoice_models.dart';
import 'providers/payment_providers.dart';

class PaymentMethodPage extends ConsumerStatefulWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;

  const PaymentMethodPage({
    Key? key,
    required this.selectedProducts,
    required this.productQuantities,
  }) : super(key: key);

  @override
  ConsumerState<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends ConsumerState<PaymentMethodPage> {
  
  // Stable controllers to prevent text clearing
  late TextEditingController _amountController;
  late TextEditingController _discountController;
  String? _lastFocusedCurrencyId;
  
  // Discount type: true for percentage, false for amount
  bool _isPercentageDiscount = false;
  
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _discountController = TextEditingController();
    // Load currency and cash location data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodProvider.notifier).loadCurrencyData();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Payment Method',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: TossSpacing.iconMD),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
      ),
      body: Column(
        children: [
          // Payment Method Selection (moved to top)
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: TossSpacing.space2,
                bottom: TossSpacing.space2,
              ),
              child: _buildPaymentMethodSelection(),
            ),
          ),
          
          // Fixed Bottom Button with safe area below
          SafeArea(
            top: false, // Don't add safe area at top
            child: _buildBottomButton(),
          ),
        ],
      ),
    );
  }


  Widget _buildPaymentMethodSelection() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentState = ref.watch(paymentMethodProvider);
        
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          physics: BouncingScrollPhysics(), // Better scroll behavior
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Dismiss keyboard on scroll
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cash Location Selection
              _buildCashLocationSection(),
              
              // Only show sections after cash location is selected
              if (paymentState.selectedCashLocation != null) ...[
                SizedBox(height: TossSpacing.space4),
                
                // Discount Section - Now shown first after cash location
                _buildEnhancedDiscountSection(),
                
                SizedBox(height: TossSpacing.space4),
                
                // Total Section with Discount Applied
                _buildTotalWithDiscountSection(),
              ],
              
              // Add extra padding for better scrolling when keyboard is open
              SizedBox(height: TossSpacing.space8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCashLocationSection() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentState = ref.watch(paymentMethodProvider);
        
        return TossWhiteCard(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Cash Location',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              if (paymentState.isLoading) ...[
                Container(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: TossColors.primary,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Text(
                        'Loading cash locations...',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (paymentState.error != null) ...[
                Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    border: Border.all(
                      color: TossColors.error.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: TossColors.error,
                        size: TossSpacing.iconSM,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          paymentState.error!,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                TextButton(
                  onPressed: () => ref.read(paymentMethodProvider.notifier).loadCurrencyData(),
                  child: Text('Retry'),
                ),
              ] else if (paymentState.cashLocations.isEmpty) ...[
                Container(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 48,
                        color: TossColors.gray400,
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'No cash locations available',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Cash location dropdown placeholder
                InkWell(
                  onTap: () => _showCashLocationSelection(paymentState.cashLocations),
                  child: Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: paymentState.selectedCashLocation != null ? TossColors.primary : TossColors.gray300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        if (paymentState.selectedCashLocation != null) ...[
                          _getCashLocationIcon(paymentState.selectedCashLocation!.type),
                          SizedBox(width: TossSpacing.space2),
                        ],
                        Expanded(
                          child: Text(
                            paymentState.selectedCashLocation?.displayName ?? 'Select cash location...',
                            style: TossTextStyles.body.copyWith(
                              color: paymentState.selectedCashLocation != null 
                                  ? TossColors.gray900 
                                  : TossColors.gray500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: TossColors.gray500,
                          size: TossSpacing.iconMD,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencySection() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentState = ref.watch(paymentMethodProvider);
        final notifier = ref.read(paymentMethodProvider.notifier);
        
        if (paymentState.currencyResponse == null) {
          return const SizedBox.shrink();
        }
        
        return TossWhiteCard(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(
                    AppIcons.dollarSign,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Payment Currency',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // Currency buttons with amounts
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: paymentState.currencyResponse!.companyCurrencies.map((currency) {
                  final isSelected = paymentState.selectedCurrency?.currencyId == currency.currencyId;
                  final hasAmount = paymentState.currencyAmounts.containsKey(currency.currencyId);
                  final amount = paymentState.currencyAmounts[currency.currencyId];
                  
                  return InkWell(
                    onTap: () {
                      ref.read(paymentMethodProvider.notifier).selectCurrency(currency);
                      notifier.updateCurrency(currency);
                    },
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.primary : (hasAmount ? TossColors.success.withOpacity(0.1) : TossColors.white),
                        border: Border.all(
                          color: isSelected ? TossColors.primary : (hasAmount ? TossColors.success : TossColors.gray300),
                          width: hasAmount ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currency.flagEmoji,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            currency.currencyCode,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? TossColors.white : TossColors.gray900,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            currency.symbol,
                            style: TossTextStyles.caption.copyWith(
                              color: isSelected ? TossColors.white.withOpacity(0.9) : TossColors.gray600,
                            ),
                          ),
                          // Amount badge removed as per user requirement
                          // Only show amounts in the input field below
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              // Amount input field for selected currency
              if (paymentState.focusedCurrencyId != null) ...[
                SizedBox(height: TossSpacing.space4),
                Container(
                  constraints: BoxConstraints(
                    minHeight: 120, // Ensure sufficient height for conversion display
                  ),
                  child: _buildAmountInput(paymentState, notifier),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalSection() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentState = ref.watch(paymentMethodProvider);
        
        if (paymentState.currencyAmounts.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // Find base currency
        final baseCurrency = paymentState.currencyResponse?.baseCurrency;
        if (baseCurrency == null || paymentState.currencyResponse == null) {
          return const SizedBox.shrink();
        }
        
        // Calculate total in base currency
        double totalInBaseCurrency = 0;
        final conversionDetails = <String, Map<String, dynamic>>{};
        
        for (final entry in paymentState.currencyAmounts.entries) {
          final currencyId = entry.key;
          final amount = entry.value;
          
          // Find the currency details
          final currency = paymentState.currencyResponse!.companyCurrencies.firstWhere(
            (c) => c.currencyId == currencyId,
            orElse: () => paymentState.currencyResponse!.companyCurrencies.first,
          );
          
          // Calculate conversion
          double convertedAmount = amount;
          if (currency.exchangeRateToBase != null && currency.exchangeRateToBase! > 0) {
            convertedAmount = amount / currency.exchangeRateToBase!;
          }
          
          totalInBaseCurrency += convertedAmount;
          conversionDetails[currencyId] = {
            'currency': currency,
            'amount': amount,
            'convertedAmount': convertedAmount,
          };
        }
        
        // Apply discount (subtract from total)
        final finalTotal = totalInBaseCurrency - paymentState.discountAmount;
        
        return TossWhiteCard(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Total',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // Individual currency amounts
              ...conversionDetails.values.map((detail) {
                final currency = detail['currency'] as PaymentCurrency;
                final amount = detail['amount'] as double;
                final convertedAmount = detail['convertedAmount'] as double;
                
                return Container(
                  margin: EdgeInsets.only(bottom: TossSpacing.space2),
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currency.flagEmoji,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${currency.symbol} ${amount.toStringAsFixed(0)} ${currency.currencyCode}',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                            ),
                            if (currency.currencyCode != baseCurrency.currencyCode) ...[
                              Text(
                                '≈ ${baseCurrency.symbol} ${convertedAmount.toStringAsFixed(2)} ${baseCurrency.currencyCode}',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (currency.exchangeRateToBase != null) ...[
                        Text(
                          '@ ${currency.exchangeRateToBase!.toStringAsFixed(4)}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
              
              SizedBox(height: TossSpacing.space3),
              
              // Show discount breakdown if discount is applied
              if (paymentState.discountAmount > 0) ...[
                Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                          Text(
                            _formatNumber(totalInBaseCurrency.round()),
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                            ),
                          ),
                          Text(
                            '- ${_formatNumber(paymentState.discountAmount.round())}',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
              ],
              
              // Total in base currency
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  border: Border.all(
                    color: TossColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      baseCurrency.flagEmoji,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total in ${baseCurrency.currencyCode}',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatNumber(finalTotal.round()),
                            style: TossTextStyles.h3.copyWith(
                              fontWeight: FontWeight.bold,
                              color: TossColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmountInput(PaymentMethodState paymentState, PaymentMethodNotifier notifier) {
    final focusedCurrency = paymentState.currencyResponse?.companyCurrencies.firstWhere(
      (c) => c.currencyId == paymentState.focusedCurrencyId,
      orElse: () => paymentState.currencyResponse!.companyCurrencies.first,
    );
    
    if (focusedCurrency == null) return SizedBox.shrink();
    
    final baseCurrency = paymentState.currencyResponse?.baseCurrency;
    final currentAmount = paymentState.currencyAmounts[focusedCurrency.currencyId];
    
    // Only update controller text when currency changes, not when amount changes
    if (_lastFocusedCurrencyId != focusedCurrency.currencyId) {
      _lastFocusedCurrencyId = focusedCurrency.currencyId;
      // Set the text if there's a current amount for this currency
      if (currentAmount != null && currentAmount > 0) {
        _amountController.text = currentAmount.toStringAsFixed(0);
      } else {
        _amountController.clear();
      }
    }
    
    // Calculate conversion to base currency
    double? convertedAmount;
    if (currentAmount != null && 
        focusedCurrency.exchangeRateToBase != null && 
        focusedCurrency.exchangeRateToBase! > 0) {
      convertedAmount = currentAmount / focusedCurrency.exchangeRateToBase!;
    }
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                focusedCurrency.flagEmoji,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Amount in ${focusedCurrency.currencyCode}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            autofocus: true,
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
            decoration: InputDecoration(
              prefixText: '${focusedCurrency.symbol} ',
              prefixStyle: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
              hintText: 'Enter amount in ${focusedCurrency.currencyCode}',
              hintStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
              ),
              filled: true,
              fillColor: TossColors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space3,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide(
                  color: TossColors.gray300,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide(
                  color: TossColors.primary,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide(
                  color: TossColors.gray300,
                  width: 1,
                ),
              ),
            ),
            onChanged: (value) {
              final amount = double.tryParse(value.replaceAll(',', '')) ?? 0;
              notifier.updateCurrencyAmount(focusedCurrency.currencyId, amount);
            },
            onFieldSubmitted: (value) {
              // Hide keyboard and clear focus when done
              FocusScope.of(context).unfocus();
              notifier.setFocusedCurrency(null);
            },
          ),
          
          // Show conversion to base currency if different - Fixed layout to prevent cut-off
          if (baseCurrency != null && 
              focusedCurrency.currencyCode != baseCurrency.currencyCode &&
              convertedAmount != null && 
              convertedAmount > 0) ...[
            SizedBox(height: TossSpacing.space2),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(TossSpacing.space3), // Increased padding
              margin: EdgeInsets.only(bottom: TossSpacing.space2), // Added bottom margin
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.swap_horiz,
                        size: 16,
                        color: TossColors.primary,
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        'Converted Amount',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Row(
                    children: [
                      Text(
                        baseCurrency.flagEmoji,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Expanded(
                        child: Text(
                          '${baseCurrency.symbol} ${convertedAmount.toStringAsFixed(2)} ${baseCurrency.currencyCode}',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    'Exchange Rate: ${focusedCurrency.exchangeRateToBase!.toStringAsFixed(4)}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancedDiscountSection() {
    // Calculate cart total from selected products
    double cartTotal = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final price = product.pricing?.sellingPrice ?? 0;
      cartTotal += price * quantity;
    }
    
    return TossWhiteCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.discount_outlined,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Discount',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Discount Type Toggle
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPercentageDiscount = false;
                      _discountController.clear();
                    });
                    ref.read(paymentMethodProvider.notifier).updateDiscountAmount(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: !_isPercentageDiscount 
                        ? TossColors.primary 
                        : TossColors.gray100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(TossBorderRadius.md),
                        bottomLeft: Radius.circular(TossBorderRadius.md),
                      ),
                      border: Border.all(
                        color: !_isPercentageDiscount
                          ? TossColors.primary
                          : TossColors.gray300,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Amount',
                        style: TossTextStyles.body.copyWith(
                          color: !_isPercentageDiscount
                            ? TossColors.white
                            : TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPercentageDiscount = true;
                      _discountController.clear();
                    });
                    ref.read(paymentMethodProvider.notifier).updateDiscountAmount(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: _isPercentageDiscount 
                        ? TossColors.primary 
                        : TossColors.gray100,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(TossBorderRadius.md),
                        bottomRight: Radius.circular(TossBorderRadius.md),
                      ),
                      border: Border.all(
                        color: _isPercentageDiscount
                          ? TossColors.primary
                          : TossColors.gray300,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Percentage (%)',
                        style: TossTextStyles.body.copyWith(
                          color: _isPercentageDiscount
                            ? TossColors.white
                            : TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Discount Input
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: TossColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isPercentageDiscount 
                    ? 'Discount Percentage' 
                    : 'Discount Amount',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: !_isPercentageDiscount),
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  decoration: InputDecoration(
                    suffixText: _isPercentageDiscount ? '%' : '',
                    suffixStyle: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                    hintText: _isPercentageDiscount 
                      ? 'Enter percentage (0-100)' 
                      : 'Enter discount amount',
                    hintStyle: TossTextStyles.body.copyWith(
                      color: TossColors.gray400,
                    ),
                    filled: true,
                    fillColor: TossColors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(
                        color: TossColors.gray300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(
                        color: TossColors.primary,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(
                        color: TossColors.gray300,
                        width: 1,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    final inputValue = double.tryParse(value.replaceAll(',', '')) ?? 0;
                    double discountAmount = 0;
                    
                    if (_isPercentageDiscount) {
                      // Calculate discount amount from percentage
                      final percentage = inputValue.clamp(0, 100);
                      discountAmount = (cartTotal * percentage) / 100;
                    } else {
                      // Direct amount discount
                      discountAmount = inputValue;
                    }
                    
                    ref.read(paymentMethodProvider.notifier).updateDiscountAmount(discountAmount);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalWithDiscountSection() {
    // Calculate cart total from selected products
    double cartTotal = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final price = product.pricing?.sellingPrice ?? 0;
      cartTotal += price * quantity;
    }
    
    final paymentState = ref.watch(paymentMethodProvider);
    final discountAmount = paymentState.discountAmount;
    final finalTotal = cartTotal - discountAmount;
    
    return TossWhiteCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_outlined,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Total',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Show breakdown
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                    Text(
                      _formatNumber(cartTotal.round()),
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
                if (discountAmount > 0) ...[
                  SizedBox(height: TossSpacing.space2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Discount',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                            ),
                          ),
                          if (_isPercentageDiscount && _discountController.text.isNotEmpty) ...[
                            Text(
                              ' (${_discountController.text}%)',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '- ${_formatNumber(discountAmount.round())}',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Final Total
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: TossColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _formatNumber(finalTotal.round()),
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentState = ref.watch(paymentMethodProvider);
        final notifier = ref.read(paymentMethodProvider.notifier);
        
        // Don't show discount section if no amounts entered
        if (paymentState.currencyAmounts.isEmpty) {
          return const SizedBox.shrink();
        }
        
        final baseCurrency = paymentState.currencyResponse?.baseCurrency;
        if (baseCurrency == null) {
          return const SizedBox.shrink();
        }
        
        return TossWhiteCard(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.discount_outlined,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Discount',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // Discount amount input
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  border: Border.all(
                    color: TossColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          baseCurrency.flagEmoji,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          'Discount in ${baseCurrency.currencyCode}',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TossSpacing.space2),
                    TextFormField(
                      controller: _discountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                      decoration: InputDecoration(
                        prefixText: '',
                        prefixStyle: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Enter discount amount',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray400,
                        ),
                        filled: true,
                        fillColor: TossColors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: BorderSide(
                            color: TossColors.gray300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: BorderSide(
                            color: TossColors.primary,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          borderSide: BorderSide(
                            color: TossColors.gray300,
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final discount = double.tryParse(value.replaceAll(',', '')) ?? 0;
                        notifier.updateDiscountAmount(discount);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Consumer(
      builder: (context, ref, child) {
        final paymentState = ref.watch(paymentMethodProvider);
        
        // Calculate cart total from selected products
        double cartTotal = 0;
        for (final product in widget.selectedProducts) {
          final quantity = widget.productQuantities[product.productId] ?? 0;
          final price = product.pricing?.sellingPrice ?? 0;
          cartTotal += price * quantity;
        }
        
        // Calculate final total after discount
        final discountAmount = paymentState.discountAmount;
        final finalTotal = cartTotal - discountAmount;
        
        // Check if can proceed: need cash location selected AND non-negative total (0 or positive)
        final canProceed = paymentState.selectedCashLocation != null && finalTotal >= 0;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.white,
            boxShadow: [
              BoxShadow(
                color: TossColors.gray300.withOpacity(0.3),
                offset: Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: canProceed ? _proceedToInvoice : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canProceed ? TossColors.primary : TossColors.gray300,
              foregroundColor: TossColors.white,
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
      },
    );
  }

  void _showCashLocationSelection(List<CashLocation> locations) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Select Cash Location',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // Location list
              ...locations.map((location) {
                return InkWell(
                  onTap: () {
                    ref.read(paymentMethodProvider.notifier).selectCashLocation(location);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(TossSpacing.space3),
                    margin: EdgeInsets.only(bottom: TossSpacing.space2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: TossColors.gray200,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        _getCashLocationIcon(location.type),
                        SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.displayName,
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: TossColors.gray900,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space1),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space2,
                                      vertical: TossSpacing.space1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: location.isBank
                                          ? TossColors.primary.withOpacity(0.1)
                                          : TossColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                    ),
                                    child: Text(
                                      location.displayType,
                                      style: TossTextStyles.caption.copyWith(
                                        color: location.isBank
                                            ? TossColors.primary
                                            : TossColors.success,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (location.currencyCode.isNotEmpty) ...[
                                    SizedBox(width: TossSpacing.space2),
                                    Text(
                                      location.currencyCode,
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _getCashLocationIcon(String type) {
    IconData iconData;
    Color iconColor;
    
    switch (type.toLowerCase()) {
      case 'bank':
        iconData = Icons.account_balance;
        iconColor = TossColors.primary;
        break;
      case 'cash':
      default:
        iconData = Icons.payments;
        iconColor = TossColors.success;
        break;
    }
    
    return Icon(
      iconData,
      color: iconColor,
      size: TossSpacing.iconSM,
    );
  }

  void _proceedToInvoice() {
    print('🚀 [PAYMENT_METHOD] Creating invoice with:');
    final paymentState = ref.read(paymentMethodProvider);
    print('📍 Cash Location: ${paymentState.selectedCashLocation?.displayName}');
    print('💰 Currency: ${paymentState.selectedCurrency?.currencyCode}');
    print('📦 Products: ${widget.selectedProducts.length}');
    
    // TODO: Navigate to invoice creation/summary page or complete the flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice created successfully!'),
        backgroundColor: TossColors.success,
      ),
    );
    
    // For now, go back to the main invoice page
    NavigationHelper.safeGoBack(context);
    NavigationHelper.safeGoBack(context);
  }

  
  String _formatNumber(int value) {
    // Always show exact numbers with commas, no K or M abbreviations
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}