import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../domain/entities/exchange_rate_data.dart';
import '../helpers/payment_helpers.dart';

/// Exchange rate panel showing converted amounts in different currencies
class ExchangeRatePanel extends StatefulWidget {
  final ExchangeRateData exchangeRateData;
  final double finalTotal;

  const ExchangeRatePanel({
    super.key,
    required this.exchangeRateData,
    required this.finalTotal,
  });

  @override
  State<ExchangeRatePanel> createState() => _ExchangeRatePanelState();
}

class _ExchangeRatePanelState extends State<ExchangeRatePanel> {
  String? _selectedBaseCurrency;
  String? _selectedSecondaryCurrency;
  final TextEditingController _baseAmountController = TextEditingController();
  final TextEditingController _secondaryAmountController =
      TextEditingController();
  final FocusNode _baseAmountFocusNode = FocusNode();
  final FocusNode _secondaryAmountFocusNode = FocusNode();

  // Track if user has manually edited values
  double? _customBaseAmount;
  double? _customSecondaryAmount;

  @override
  void initState() {
    super.initState();
    // Set default base currency
    _selectedBaseCurrency = widget.exchangeRateData.baseCurrency.currencyCode;

    // Auto-select first non-base currency if available
    final otherCurrencies = widget.exchangeRateData.rates.where((rate) {
      return rate.currencyCode !=
          widget.exchangeRateData.baseCurrency.currencyCode;
    }).toList();

    if (otherCurrencies.isNotEmpty) {
      _selectedSecondaryCurrency = otherCurrencies.first.currencyCode;
    }
  }

  @override
  void dispose() {
    _baseAmountController.dispose();
    _secondaryAmountController.dispose();
    _baseAmountFocusNode.dispose();
    _secondaryAmountFocusNode.dispose();
    super.dispose();
  }

  double _getExchangeRate() {
    final baseCurrencyCode = widget.exchangeRateData.baseCurrency.currencyCode;

    // Get rate for selected base currency (relative to original base)
    double baseRate = 1.0;
    if (_selectedBaseCurrency != baseCurrencyCode) {
      final baseRateData = widget.exchangeRateData.rates
          .where((r) => r.currencyCode == _selectedBaseCurrency)
          .firstOrNull;
      baseRate = baseRateData?.rate ?? 1.0;
    }

    // Get rate for selected secondary currency (relative to original base)
    double secondaryRate = 1.0;
    if (_selectedSecondaryCurrency != baseCurrencyCode) {
      final secondaryRateData = widget.exchangeRateData.rates
          .where((r) => r.currencyCode == _selectedSecondaryCurrency)
          .firstOrNull;
      secondaryRate = secondaryRateData?.rate ?? 1.0;
    }

    // Calculate cross rate: base -> secondary
    // If base is VND (rate 1) and secondary is USD (rate 25000)
    // Then 1 VND = 1/25000 USD, so we divide
    return baseRate / secondaryRate;
  }

  @override
  Widget build(BuildContext context) {
    // Convert base currency to ExchangeRate for unified handling
    final baseCurrencyAsRate = ExchangeRate(
      currencyCode: widget.exchangeRateData.baseCurrency.currencyCode,
      symbol: widget.exchangeRateData.baseCurrency.symbol,
      rate: 1.0,
      name: widget.exchangeRateData.baseCurrency.name,
    );

    final allCurrencies = [
      baseCurrencyAsRate,
      ...widget.exchangeRateData.rates,
    ];

    if (allCurrencies.length < 2) return const SizedBox.shrink();

    // Get selected currencies
    final baseCurrencyData = allCurrencies
        .where((c) => c.currencyCode == _selectedBaseCurrency)
        .firstOrNull ?? baseCurrencyAsRate;
    final secondaryCurrencyData = allCurrencies
        .where((c) => c.currencyCode == _selectedSecondaryCurrency)
        .firstOrNull;

    // Calculate amounts
    final baseAmount = _customBaseAmount ?? widget.finalTotal;
    final exchangeRate = _getExchangeRate();
    final secondaryAmount = _customSecondaryAmount ?? (baseAmount / exchangeRate);

    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        children: [
          // Base currency row
          _buildEditableCurrencyRow(
            currencyCode: baseCurrencyData.currencyCode,
            symbol: baseCurrencyData.symbol,
            amount: baseAmount,
            isBase: true,
            controller: _baseAmountController,
            focusNode: _baseAmountFocusNode,
            onChanged: (value) {
              final parsed = double.tryParse(value.replaceAll(',', '')) ?? 0;
              setState(() {
                _customBaseAmount = parsed;
                // Recalculate secondary based on new base
                _customSecondaryAmount = parsed / exchangeRate;
              });
            },
            onCurrencyTap: () => _showCurrencySelector(
              allCurrencies,
              isForBase: true,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          // Secondary currency row
          if (secondaryCurrencyData != null)
            _buildEditableCurrencyRow(
              currencyCode: secondaryCurrencyData.currencyCode,
              symbol: secondaryCurrencyData.symbol,
              amount: secondaryAmount,
              isBase: false,
              controller: _secondaryAmountController,
              focusNode: _secondaryAmountFocusNode,
              onChanged: (value) {
                final parsed = double.tryParse(value.replaceAll(',', '')) ?? 0;
                setState(() {
                  _customSecondaryAmount = parsed;
                  // Recalculate base based on new secondary
                  _customBaseAmount = parsed * exchangeRate;
                });
              },
              onCurrencyTap: () => _showCurrencySelector(
                allCurrencies,
                isForBase: false,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditableCurrencyRow({
    required String currencyCode,
    required String symbol,
    required double amount,
    required bool isBase,
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onChanged,
    required VoidCallback onCurrencyTap,
  }) {
    final displayHint = PaymentHelpers.formatNumber(amount.round());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Currency selector - both currencies are selectable
        GestureDetector(
          onTap: onCurrencyTap,
          child: Row(
            children: [
              Text(
                currencyCode,
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(width: TossSpacing.space1),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: TossColors.gray900,
              ),
            ],
          ),
        ),
        // Editable amount with underline and currency suffix
        GestureDetector(
          onTap: () => focusNode.requestFocus(),
          child: Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: TossColors.gray200, width: 1),
              ),
            ),
            child: IntrinsicWidth(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsSeparatorInputFormatter(),
                ],
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: displayHint,
                  hintStyle: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                  suffixText: symbol,
                  suffixStyle: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 60),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCurrencySelector(
    List<ExchangeRate> currencies, {
    required bool isForBase,
  }) {
    final currentSelection =
        isForBase ? _selectedBaseCurrency : _selectedSecondaryCurrency;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Currency',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final isSelected =
                        currentSelection == currency.currencyCode;
                    // Don't show the currency that's already selected in the other row
                    final otherSelection =
                        isForBase ? _selectedSecondaryCurrency : _selectedBaseCurrency;
                    if (currency.currencyCode == otherSelection) {
                      return const SizedBox.shrink();
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${currency.symbol} ${currency.currencyCode}',
                        style: TossTextStyles.body.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? TossColors.primary
                              : TossColors.gray900,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: TossColors.primary,
                              size: 24,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          if (isForBase) {
                            _selectedBaseCurrency = currency.currencyCode;
                          } else {
                            _selectedSecondaryCurrency = currency.currencyCode;
                          }
                          // Reset custom amounts when currency changes
                          _customBaseAmount = null;
                          _customSecondaryAmount = null;
                          _baseAmountController.clear();
                          _secondaryAmountController.clear();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Input formatter that adds thousand separators (commas)
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Format with commas
    final number = int.tryParse(digitsOnly) ?? 0;
    final formatted = PaymentHelpers.formatNumber(number);

    // Calculate new cursor position
    final oldCursorPosition = oldValue.selection.end;
    final oldLength = oldValue.text.length;
    final newLength = formatted.length;

    // Keep cursor at relative position
    int newCursorPosition;
    if (newValue.selection.end >= newValue.text.length) {
      newCursorPosition = formatted.length;
    } else {
      final diff = newLength - oldLength;
      newCursorPosition = (oldCursorPosition + diff).clamp(0, formatted.length);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
