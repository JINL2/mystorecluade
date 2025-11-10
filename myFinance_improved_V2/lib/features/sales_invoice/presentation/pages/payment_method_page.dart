import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core imports
import '../../../../core/constants/app_icons_fa.dart';

// Shared imports - themes
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

// Shared imports - widgets
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';

// App-level providers
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';

// Feature imports - sales_invoice
import '../models/cash_location_models.dart';
import '../models/invoice_models.dart';
import '../providers/payment_providers.dart';

// Feature imports - sale_product
import '../../../sale_product/domain/entities/sales_product.dart';
import '../../../sale_product/presentation/providers/cart_provider.dart';
import '../../../sale_product/presentation/providers/sales_product_provider.dart';

// Feature imports - journal_input
import '../../../journal_input/presentation/providers/journal_input_providers.dart';

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
  
  // Exchange rate data
  Map<String, dynamic>? _exchangeRateData;
  String? _selectedCurrencyCode;
  
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _discountController = TextEditingController();
    // Load currency and cash location data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodProvider.notifier).loadCurrencyData();
      _loadExchangeRates();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _discountController.dispose();
    super.dispose();
  }
  
  Future<void> _loadExchangeRates() async {
    final appState = ref.read(appStateProvider);
    final String companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) return;
    
    try {
      final exchangeRatesData = await ref.read(exchangeRatesProvider(companyId).future);
      if (exchangeRatesData != null && mounted) {
        setState(() {
          _exchangeRateData = exchangeRatesData;
        });
      }
    } catch (e) {
      // Exchange rate loading failed - will use default rates
    }
  }
  
  double _convertToSelectedCurrency(double baseAmount, String targetCurrencyCode) {
    if (_exchangeRateData == null) return baseAmount;
    
    final exchangeRates = _exchangeRateData!['exchange_rates'] as List? ?? [];
    final targetRate = exchangeRates.firstWhere(
      (rate) => rate['currency_code'] == targetCurrencyCode,
      orElse: () => {'rate': 1.0},
    );
    
    final rate = (targetRate['rate'] as num).toDouble();
    // Convert from base currency to target currency
    // If base currency is VND and target is KRW, and 1 KRW = 19.01 VND
    // Then to convert VND to KRW: divide by the rate
    return rate > 0 ? baseAmount / rate : baseAmount;
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: 'Payment Method',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: TossSpacing.iconMD),
          onPressed: () => Navigator.pop(context),
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
              // Unified Discount and Total Section - Shown first
              _buildUnifiedDiscountAndTotalSection(),
              
              SizedBox(height: TossSpacing.space4),
              
              // Cash Location Selection - Shown after discount/total
              _buildCashLocationSection(),
              
              // Currency Converter Section - Always shown if exchange rate data is available
              if (_exchangeRateData != null) ...[
                SizedBox(height: TossSpacing.space4),
                _buildCurrencyConverterSection(),
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


  Widget _buildUnifiedDiscountAndTotalSection() {
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
          // Breakdown - styled like Image #2
          Column(
            children: [
              // Subtotal with item count
              Container(
                padding: EdgeInsets.symmetric(
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
                        SizedBox(width: TossSpacing.space2),
                        // Item count in circle
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
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
                      _formatNumber(cartTotal.round()),
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Discount line - cleaner Toss design
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: TossSpacing.space3,
                  horizontal: 0,
                ),
                child: Row(
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
                          SizedBox(width: TossSpacing.space3),
                          // Simplified toggle buttons
                          Container(
                            height: 28,
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPercentageDiscount = false;
                                      _discountController.clear();
                                    });
                                    ref.read(paymentMethodProvider.notifier).updateDiscountAmount(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !_isPercentageDiscount 
                                        ? TossColors.primary 
                                        : Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      'Amount',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: !_isPercentageDiscount
                                          ? TossColors.white
                                          : TossColors.gray600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPercentageDiscount = true;
                                      _discountController.clear();
                                    });
                                    ref.read(paymentMethodProvider.notifier).updateDiscountAmount(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isPercentageDiscount 
                                        ? TossColors.primary 
                                        : Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      '%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _isPercentageDiscount
                                          ? TossColors.white
                                          : TossColors.gray600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Show calculated percentage inline
                          if (discountAmount > 0 && cartTotal > 0) ...[
                            SizedBox(width: TossSpacing.space2),
                            Text(
                              '(${((discountAmount / cartTotal) * 100).toStringAsFixed(2)}%)',
                              style: TextStyle(
                                fontSize: 13,
                                color: TossColors.gray500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Input field with underline
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _discountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: !_isPercentageDiscount),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: TossColors.gray400,
                          ),
                          // Add underline to show it's an input field
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: TossColors.gray300,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: TossColors.primary,
                              width: 1.5,
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 4),
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
                    ),
                  ],
                ),
              ),
              
              // Divider line - only show when there's a discount
              if (discountAmount > 0) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
                  child: Divider(
                    color: TossColors.gray300,
                    height: 1,
                  ),
                ),
              ],
              
              // Final Total
              Container(
                padding: EdgeInsets.symmetric(
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
                      _formatNumber(finalTotal.round()),
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrencyConverterSection() {
    if (_exchangeRateData == null) return Container();
    
    // Calculate the final total amount
    double cartTotal = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final price = product.pricing?.sellingPrice ?? 0;
      cartTotal += price * quantity;
    }
    
    final paymentState = ref.watch(paymentMethodProvider);
    final discountAmount = paymentState.discountAmount;
    final finalTotal = cartTotal - discountAmount;
    
    final baseCurrency = _exchangeRateData!['base_currency'] as Map<String, dynamic>?;
    final exchangeRates = _exchangeRateData!['exchange_rates'] as List? ?? [];
    
    // Filter out the base currency from the list
    final otherCurrencies = exchangeRates.where((rate) {
      return rate['currency_code'] != baseCurrency?['currency_code'];
    }).toList();
    
    if (otherCurrencies.isEmpty) return Container();
    
    return TossWhiteCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.currency_exchange,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Currency Converter',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Currency buttons
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: otherCurrencies.map((rate) {
              final currencyCode = rate['currency_code'] as String;
              final symbol = rate['symbol'] as String;
              final isSelected = _selectedCurrencyCode == currencyCode;
              
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCurrencyCode = isSelected ? null : currencyCode;
                  });
                },
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? TossColors.primary : TossColors.white,
                    border: Border.all(
                      color: isSelected ? TossColors.primary : TossColors.gray300,
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        symbol,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? TossColors.white : TossColors.gray700,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        currencyCode,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? TossColors.white : TossColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          // Show converted amount if a currency is selected
          if (_selectedCurrencyCode != null) ...[
            SizedBox(height: TossSpacing.space3),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Converted Amount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${baseCurrency?['symbol'] ?? ''} ${_formatNumber(finalTotal.round())} ${baseCurrency?['currency_code'] ?? ''}',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: TossColors.gray500,
                          ),
                        ],
                      ),
                      Text(
                        '${otherCurrencies.firstWhere((r) => r['currency_code'] == _selectedCurrencyCode, orElse: () => {'symbol': ''})['symbol']} ${_formatNumber(_convertToSelectedCurrency(finalTotal, _selectedCurrencyCode!).round())} $_selectedCurrencyCode',
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
          child: ElevatedButton(
            onPressed: canProceed ? () => _proceedToInvoice() : null,
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
                    onPressed: () => context.pop(),
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
                    context.pop();
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

  Future<void> _proceedToInvoice() async {
    final paymentState = ref.read(paymentMethodProvider);

    // Get required IDs
    final appState = ref.read(appStateProvider);
    final authState = ref.read(authStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    final userId = authState.value?.id;
    
    // Validate required fields
    if (companyId.isEmpty || storeId.isEmpty || userId == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Missing Information',
          message: 'Please ensure you are logged in and have selected a company and store.',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }
    
    // Format items array for the RPC
    final items = <Map<String, dynamic>>[];
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      if (quantity > 0) {
        final itemData = <String, dynamic>{
          'product_id': product.productId,
          'quantity': quantity,
        };
        
        // Only include unit_price if we have it
        // If not provided, the RPC will use the product's selling_price from the database
        final sellingPrice = product.pricing?.sellingPrice;
        if (sellingPrice != null && sellingPrice > 0) {
          itemData['unit_price'] = sellingPrice;
        }
        
        // Don't include item-level discount_amount since we're using total invoice discount
        items.add(itemData);
      }
    }
    
    if (items.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'No Items',
          message: 'No valid items to invoice',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: TossColors.primary),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Creating invoice...',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    try {
      final supabase = Supabase.instance.client;
      
      // Determine payment method based on cash location type
      String paymentMethod = 'cash'; // Default
      if (paymentState.selectedCashLocation != null) {
        // If it's a bank type, use 'transfer', otherwise 'cash'
        paymentMethod = paymentState.selectedCashLocation!.isBank ? 'transfer' : 'cash';
      }
      
      // Prepare RPC parameters
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_created_by': userId,
        'p_sale_date': DateTime.now().toIso8601String(),
        'p_items': items,
        'p_payment_method': paymentMethod,
        'p_tax_rate': 0.0, // No tax by default
      };
      
      // Add discount if any (as total invoice discount, not item-level)
      // Round to avoid floating point issues
      if (paymentState.discountAmount > 0) {
        params['p_discount_amount'] = paymentState.discountAmount.round();
      }
      
      // Add cash location info as notes for reference
      if (paymentState.selectedCashLocation != null) {
        final cashLoc = paymentState.selectedCashLocation!;
        params['p_notes'] = 'Cash Location: ${cashLoc.displayName} (${cashLoc.displayType})';
      }
      
      
      // Call the RPC
      final response = await supabase.rpc('inventory_create_invoice', params: params);
      
      
      // Close loading dialog
      if (mounted) {
        context.pop();
      }
      
      // Check response
      if (response != null && response['success'] == true) {
        // Success - show invoice number
        final invoiceNumber = (response['invoice_number'] as String?) ?? 'Unknown';
        final totalAmount = response['total_amount'] as num? ?? 0;
        
        // Create journal entry for the cash sales transaction
        try {
          // Only create journal if we have a cash location
          if (paymentState.selectedCashLocation != null) {
            // Create description based on products and discount
            String journalDescription = "";
            
            // Get the base currency code
            final baseCurrencyCode = _exchangeRateData?['base_currency']?['currency_code'] ?? 'VND';
            
            if (widget.selectedProducts.length == 1) {
              // Single product - show product name
              journalDescription = widget.selectedProducts.first.productName;
            } else if (widget.selectedProducts.isNotEmpty) {
              // Multiple products - show first product + count
              final additionalCount = widget.selectedProducts.length - 1;
              journalDescription = "${widget.selectedProducts.first.productName} +$additionalCount products";
            }
            
            // Add discount information if there's a discount
            if (paymentState.discountAmount > 0) {
              final discountFormatted = paymentState.discountAmount.toStringAsFixed(0);
              journalDescription += " ${discountFormatted}${baseCurrencyCode} discount";
            }
            
            // If no products (shouldn't happen), use a default description
            if (journalDescription.isEmpty) {
              journalDescription = "Sales - Invoice $invoiceNumber";
            }
            
            // Prepare journal lines for cash sales
            final journalLines = [
              {
                // Cash account (debit) - increase cash
                "account_id": "d4a7a16e-45a1-47fe-992b-ff807c8673f0", // Fixed cash account ID
                "description": journalDescription,
                "debit": totalAmount.toDouble(), // Ensure it's a double
                "credit": 0.0,
                // Include cash object for cash transactions (required!)
                "cash": {
                  "cash_location_id": paymentState.selectedCashLocation!.id,
                }
              },
              {
                // Sales revenue account (credit) - increase revenue
                "account_id": "e45e7d41-7fda-43a1-ac55-9779f3e59697", // Fixed sales revenue account ID
                "description": journalDescription,
                "debit": 0.0,
                "credit": totalAmount.toDouble(), // Ensure it's a double
                // No cash object needed for non-cash accounts
              }
            ];
            
            // Prepare journal params
            final journalParams = {
              'p_base_amount': totalAmount.toDouble(),
              'p_company_id': companyId,
              'p_created_by': userId,
              'p_description': 'Cash sales - Invoice $invoiceNumber',
              'p_entry_date': DateTime.now().toIso8601String(),
              'p_lines': journalLines,
              'p_store_id': storeId,
              // DO NOT send these parameters for simple cash sales
              // 'p_counterparty_id': not needed for cash sales
              // 'p_if_cash_location_id': not needed for simple sales
            };
            
            
            // Call journal RPC
            final journalResponse = await supabase.rpc(
              'insert_journal_with_everything',
              params: journalParams,
            );

          }
          // No cash location - skip journal entry
        } catch (journalError) {
          // Journal entry creation failed but don't fail the whole transaction
          // The invoice was created successfully, so we continue
        }
        
        // Check for warnings
        final warnings = response['warnings'] as List? ?? [];
        String warningMessage = '';
        if (warnings.isNotEmpty) {
          warningMessage = 'Warnings:\n';
          for (final warning in warnings) {
            if (warning['type'] == 'negative_stock') {
              warningMessage += '⚠️ ${warning['product']} stock will be ${warning['stock_after']}\n';
            } else if (warning['type'] == 'price_below_minimum') {
              warningMessage += '⚠️ ${warning['product']} price is below minimum\n';
            }
          }
        }
        
        // Clear the cart
        ref.read(cartProvider.notifier).clearCart();
        
        // Clear payment method selections for next invoice
        ref.read(paymentMethodProvider.notifier).clearSelections();
        
        // Show Toss-style success bottom sheet
        if (mounted) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isDismissible: false,
            isScrollControlled: true,
            builder: (context) => Container(
              margin: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success icon with animation
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: TossColors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: TossColors.success,
                            size: 36,
                          ),
                        ),
                      ),
                      SizedBox(height: TossSpacing.space4),
                      
                      // Success title
                      Text(
                        'Invoice Created',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      
                      // Invoice number
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Text(
                          invoiceNumber,
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: TossSpacing.space4),
                      
                      // Total amount
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Total Amount',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              _formatNumber((totalAmount as num).toInt()),
                              style: TossTextStyles.h2.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Warnings if any
                      if (warningMessage.isNotEmpty) ...[
                        SizedBox(height: TossSpacing.space3),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(TossSpacing.space3),
                          decoration: BoxDecoration(
                            color: TossColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            border: Border.all(
                              color: TossColors.warning.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: TossColors.warning,
                                  ),
                                  SizedBox(width: TossSpacing.space1),
                                  Text(
                                    'Notice',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.warning,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: TossSpacing.space1),
                              Text(
                                warningMessage.trim(),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray700,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      SizedBox(height: TossSpacing.space5),
                      
                      // OK button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.pop(); // Close bottom sheet
                            // Force refresh of sales product data
                            ref.invalidate(salesProductProvider);
                            // Navigate back to Sales Product page (go back twice: from payment page and invoice selection)
                            context.pop(); // Close payment page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            foregroundColor: TossColors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: TossSpacing.space3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'OK',
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: TossColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      } else {
        // Error
        final errorMessage = response != null && response['message'] != null
            ? (response['message'] as String)
            : 'Failed to create invoice';

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Invoice Creation Failed',
              message: errorMessage,
              primaryButtonText: 'OK',
              onPrimaryPressed: () => context.pop(),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        context.pop();
      }


      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Error creating invoice: ${e.toString()}',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    }
  }

  
  String _formatNumber(int value) {
    // Always show exact numbers with commas, no K or M abbreviations
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}