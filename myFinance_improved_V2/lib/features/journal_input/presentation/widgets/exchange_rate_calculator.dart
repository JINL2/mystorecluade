import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_secondary_button.dart';
import '../providers/journal_input_providers.dart';

class ExchangeRateCalculator extends ConsumerStatefulWidget {
  final String? initialAmount;
  final void Function(String amount) onAmountSelected;
  
  const ExchangeRateCalculator({
    super.key,
    this.initialAmount,
    required this.onAmountSelected,
  });

  @override
  ConsumerState<ExchangeRateCalculator> createState() => _ExchangeRateCalculatorState();
}

class _ExchangeRateCalculatorState extends ConsumerState<ExchangeRateCalculator> {
  final Map<String, TextEditingController> _currencyControllers = {};
  final Map<String, FocusNode> _currencyFocusNodes = {};
  Map<String, dynamic>? _baseCurrency;
  List<Map<String, dynamic>>? _exchangeRates;
  String? _activeCurrencyId;
  
  @override
  void initState() {
    super.initState();
    // Initialize with the initial amount if provided
    if (widget.initialAmount != null && widget.initialAmount!.isNotEmpty) {
      // This will be set for the base currency once loaded
    }
  }
  
  @override
  void dispose() {
    // Safe disposal with error handling
    for (var controller in _currencyControllers.values) {
      try {
        controller.dispose();
      } catch (e) {
        debugPrint('Error disposing controller: $e');
      }
    }

    for (var node in _currencyFocusNodes.values) {
      try {
        node.dispose();
      } catch (e) {
        debugPrint('Error disposing focus node: $e');
      }
    }

    _currencyControllers.clear();
    _currencyFocusNodes.clear();
    super.dispose();
  }
  
  void _updateExchangeRates(String fromCurrencyId, String amount) {
    // Remove commas before parsing
    final cleanAmount = amount.replaceAll(',', '');
    final sourceAmount = double.tryParse(cleanAmount) ?? 0;
    
    final baseCurrencyId = _baseCurrency?['currency_id'] as String?;
    
    if (sourceAmount == 0) {
      // Clear all other fields if amount is 0
      _currencyControllers.forEach((currencyId, controller) {
        if (currencyId != fromCurrencyId) {
          controller.clear();
        }
      });
      return;
    }
    
    // Check if typing in base currency or non-base currency
    if (fromCurrencyId == baseCurrencyId) {
      // Typing in BASE currency: Update ALL other currencies
      _exchangeRates?.forEach((rate) {
        final currencyId = rate['currency_id'] as String?;
        if (currencyId != null && currencyId != fromCurrencyId) {
          final targetRate = (rate['rate'] as num?)?.toDouble() ?? 1.0;
          // The rate represents "1 foreign_currency = X base_currency"
          // So we DIVIDE base by rate to get foreign currency amount
          final targetAmount = sourceAmount / targetRate;
          
          // Format with thousand separators
          final formatter = NumberFormat('#,##0.##', 'en_US');
          _currencyControllers[currencyId]?.text = formatter.format(targetAmount);
        }
      });
    } else {
      // Typing in NON-BASE currency: Only update the base currency
      // First, clear all other non-base currency fields
      _currencyControllers.forEach((currencyId, controller) {
        if (currencyId != fromCurrencyId && currencyId != baseCurrencyId) {
          controller.clear();
        }
      });
      
      // Find the exchange rate for the source currency
      final sourceRateData = _exchangeRates?.firstWhere(
        (rate) => rate['currency_id'] == fromCurrencyId,
        orElse: () => {'rate': 1.0},
      );
      final sourceRate = (sourceRateData?['rate'] as num?)?.toDouble() ?? 1.0;
      
      // Convert to base currency amount
      // The rate represents "1 foreign_currency = X base_currency"
      // So we MULTIPLY to convert from foreign to base
      final baseAmount = sourceAmount * sourceRate;
      
      // Update only the base currency field
      if (baseCurrencyId != null && _currencyControllers[baseCurrencyId] != null) {
        final formatter = NumberFormat('#,##0.##', 'en_US');
        _currencyControllers[baseCurrencyId]!.text = formatter.format(baseAmount);
      }
    }
    
    // Update the active currency
    setState(() {
      _activeCurrencyId = fromCurrencyId;
    });
  }
  
  void _confirmAmount() {
    // Get the base currency amount
    String finalAmount = '0';
    
    if (_baseCurrency != null && _currencyControllers[_baseCurrency!['currency_id']] != null) {
      final controller = _currencyControllers[_baseCurrency!['currency_id']]!;
      finalAmount = controller.text.replaceAll(',', '');
    }
    
    widget.onAmountSelected(finalAmount);
    context.pop();
  }
  
  Widget _buildBaseCurrencyWidget() {
    final baseCurrencyId = _baseCurrency?['currency_id'] as String?;
    if (baseCurrencyId == null) return Container();
    
    final isActive = baseCurrencyId == _activeCurrencyId;
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isActive 
            ? TossColors.primary
            : TossColors.primary.withValues(alpha: 0.3),
          width: isActive ? 2 : 1.5,
        ),
      ),
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  (_baseCurrency!['symbol'] ?? _baseCurrency!['currency_code']) as String,
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_baseCurrency!['currency_name']} (${_baseCurrency!['currency_code']})',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Base Currency',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          TextField(
            controller: _currencyControllers[baseCurrencyId],
            focusNode: _currencyFocusNodes[baseCurrencyId],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TossTextStyles.h2.copyWith(
                color: TossColors.gray400,
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(right: TossSpacing.space3),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: (value) {
              _updateExchangeRates(baseCurrencyId, value);
            },
            onTap: () {
              // Clear ALL fields when switching to base currency
              _currencyControllers.forEach((id, controller) {
                if (id != baseCurrencyId) {
                  controller.clear();
                }
              });
              
              // Set this as the active currency when tapped
              setState(() {
                _activeCurrencyId = baseCurrencyId;
              });
            },
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final exchangeRatesAsync = ref.watch(exchangeRatesProvider(appState.companyChoosen));
    
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside input fields
        FocusScope.of(context).unfocus();
      },
      child: Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exchange Rate Calculator',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: TossColors.gray600),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: TossColors.gray200),
          
          // Content
          Expanded(
            child: exchangeRatesAsync.when(
              data: (data) {
                _baseCurrency = data['base_currency'] as Map<String, dynamic>?;
                _exchangeRates = (data['exchange_rates'] as List<dynamic>?)
                    ?.map((item) => Map<String, dynamic>.from(item as Map))
                    .toList();
                
                // Initialize controllers for each currency if not already done
                _exchangeRates?.forEach((rate) {
                  final currencyId = rate['currency_id'] as String?;
                  if (currencyId != null && !_currencyControllers.containsKey(currencyId)) {
                    _currencyControllers[currencyId] = TextEditingController();
                    _currencyFocusNodes[currencyId] = FocusNode();
                    
                    // Set initial amount for base currency
                    if (widget.initialAmount != null && 
                        widget.initialAmount!.isNotEmpty && 
                        currencyId == _baseCurrency!['currency_id']) {
                      _currencyControllers[currencyId]!.text = widget.initialAmount!;
                      _activeCurrencyId = currencyId;
                    }
                  }
                });
                
                // Filter out base currency from the list
                final nonBaseCurrencies = _exchangeRates?.where((rate) {
                  return rate['currency_id'] != _baseCurrency?['currency_id'];
                }).toList() ?? [];
                
                return Column(
                  children: [
                    // Scrollable content for non-base currencies
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(TossSpacing.space5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Base Currency Info
                            if (_baseCurrency != null) ...[
                              Container(
                                padding: const EdgeInsets.all(TossSpacing.space4),
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                  border: Border.all(
                                    color: TossColors.primary.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 20,
                                      color: TossColors.primary,
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    Expanded(
                                      child: Text(
                                        'Base Currency: ${_baseCurrency!['currency_name']} (${_baseCurrency!['currency_code']})',
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: TossSpacing.space5),
                            ],
                            
                            // Currency Input Fields (excluding base currency)
                            if (nonBaseCurrencies.isNotEmpty) ...[
                              Text(
                                'Enter amount in any currency:',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: TossSpacing.space3),
                              
                              ...nonBaseCurrencies.map((rate) {
                                final currencyId = rate['currency_id'] as String?;
                                if (currencyId == null) return Container(); // Skip if no currency ID
                                
                                final isActive = currencyId == _activeCurrencyId;
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                                  decoration: BoxDecoration(
                                    color: isActive 
                                      ? TossColors.primary.withValues(alpha: 0.03)
                                      : TossColors.white,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                    border: Border.all(
                                      color: isActive 
                                        ? TossColors.primary.withValues(alpha: 0.3)
                                        : TossColors.gray200,
                                      width: isActive ? 1.5 : 1,
                                    ),
                                  ),
                            padding: const EdgeInsets.all(TossSpacing.space3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: TossSpacing.space2,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: TossColors.gray100,
                                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                      ),
                                      child: Text(
                                        (rate['symbol'] ?? rate['currency_code']) as String,
                                        style: TossTextStyles.bodyLarge.copyWith(
                                          color: TossColors.gray700,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    Expanded(
                                      child: Text(
                                        '${rate['currency_name']} (${rate['currency_code']})',
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '1 ${rate['currency_code']} = ${rate['rate']} ${_baseCurrency!['currency_code']}',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                TextField(
                                  controller: _currencyControllers[currencyId],
                                  focusNode: _currencyFocusNodes[currencyId],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.right,
                                  style: TossTextStyles.h3.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: TossTextStyles.h3.copyWith(
                                      color: TossColors.gray400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(right: TossSpacing.space3),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                                  ],
                                  onChanged: (value) {
                                    _updateExchangeRates(currencyId, value);
                                  },
                                  onTap: () {
                                    // Clear ALL fields when switching to a new currency
                                    final baseCurrencyId = _baseCurrency?['currency_id'] as String?;
                                    _currencyControllers.forEach((id, controller) {
                                      if (id != currencyId) {
                                        controller.clear();
                                      }
                                    });
                                    
                                    // Set this as the active currency when tapped
                                    setState(() {
                                      _activeCurrencyId = currencyId;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    // Fixed base currency display at the bottom
                    if (_baseCurrency != null) ...[
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space5),
                        decoration: const BoxDecoration(
                          color: TossColors.gray50,
                          border: Border(
                            top: BorderSide(color: TossColors.gray200, width: 1),
                          ),
                        ),
                        child: _buildBaseCurrencyWidget(),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const SizedBox(
                height: 300,
                child: Center(
                  child: TossLoadingView(),
                ),
              ),
              error: (error, _) => Container(
                height: 300,
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: TossColors.error,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Failed to load exchange rates',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.error,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Text(
                        error.toString(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Footer with SafeArea
          Container(
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(
                top: BorderSide(color: TossColors.gray200, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Row(
                  children: [
                    Expanded(
                      child: TossSecondaryButton(
                        text: 'Cancel',
                        onPressed: () => context.pop(),
                        fullWidth: true,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: TossPrimaryButton(
                        text: 'Use Amount',
                        onPressed: _confirmAmount,
                        fullWidth: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}