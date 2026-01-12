import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/exchange_rate_data.dart';
import '../helpers/payment_helpers.dart';

// Import real-time exchange rate provider
import '../../../../../register_denomination/presentation/providers/exchange_rate_provider.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Exchange rate panel showing converted amounts in different currencies
/// Uses real-time exchange rates from exchangerate-api.com
class ExchangeRatePanel extends ConsumerStatefulWidget {
  final ExchangeRateData exchangeRateData;
  final double finalTotal;
  final double subtotal;

  /// Callback when user applies the exchange rate converted amount as total payment
  /// Parameters: (convertedVndAmount, calculatedDiscount)
  final void Function(double convertedAmount, double discount)? onApplyAsTotal;

  const ExchangeRatePanel({
    super.key,
    required this.exchangeRateData,
    required this.finalTotal,
    this.subtotal = 0,
    this.onApplyAsTotal,
  });

  @override
  ConsumerState<ExchangeRatePanel> createState() => _ExchangeRatePanelState();
}

class _ExchangeRatePanelState extends ConsumerState<ExchangeRatePanel> {
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

    // Add focus listeners to clear text on focus
    _baseAmountFocusNode.addListener(_onBaseAmountFocusChange);
    _secondaryAmountFocusNode.addListener(_onSecondaryAmountFocusChange);
  }

  void _onBaseAmountFocusChange() {
    if (_baseAmountFocusNode.hasFocus) {
      // Clear custom amount and controller when focused - user starts fresh
      setState(() {
        _customBaseAmount = null;
        _customSecondaryAmount = null;
      });
      _baseAmountController.clear();
      _secondaryAmountController.clear();
    }
  }

  void _onSecondaryAmountFocusChange() {
    if (_secondaryAmountFocusNode.hasFocus) {
      // Clear custom amount and controller when focused - user starts fresh
      setState(() {
        _customBaseAmount = null;
        _customSecondaryAmount = null;
      });
      _baseAmountController.clear();
      _secondaryAmountController.clear();
    }
  }

  @override
  void dispose() {
    _baseAmountFocusNode.removeListener(_onBaseAmountFocusChange);
    _secondaryAmountFocusNode.removeListener(_onSecondaryAmountFocusChange);
    _baseAmountController.dispose();
    _secondaryAmountController.dispose();
    _baseAmountFocusNode.dispose();
    _secondaryAmountFocusNode.dispose();
    super.dispose();
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
            .firstOrNull ??
        baseCurrencyAsRate;
    final secondaryCurrencyData = allCurrencies
        .where((c) => c.currencyCode == _selectedSecondaryCurrency)
        .firstOrNull;

    // Fetch real-time exchange rate from API
    final realTimeRateAsync = ref.watch(
      exchangeRateProvider(
        ExchangeRateParams(
          baseCurrency: _selectedBaseCurrency ?? 'VND',
          targetCurrency: _selectedSecondaryCurrency ?? 'KRW',
        ),
      ),
    );

    return realTimeRateAsync.when(
      data: (realTimeRate) {
        // Use real-time rate (1 base = X target)
        final exchangeRate = realTimeRate ?? 1.0;
        final baseAmount = _customBaseAmount ?? widget.finalTotal;
        final secondaryAmount =
            _customSecondaryAmount ?? (baseAmount * exchangeRate);

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
                  final parsed =
                      double.tryParse(value.replaceAll(',', '')) ?? 0;
                  setState(() {
                    _customBaseAmount = parsed;
                    // Recalculate secondary based on new base
                    _customSecondaryAmount = parsed * exchangeRate;
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
                    final parsed =
                        double.tryParse(value.replaceAll(',', '')) ?? 0;
                    setState(() {
                      _customSecondaryAmount = parsed;
                      // Recalculate base based on new secondary
                      _customBaseAmount = parsed / exchangeRate;
                    });
                  },
                  onCurrencyTap: () => _showCurrencySelector(
                    allCurrencies,
                    isForBase: false,
                  ),
                ),
              // Apply as Total button - only show when:
              // 1. Custom amount is entered
              // 2. Base currency (top row) is the original base currency (e.g., VND)
              // This prevents applying EUR/USD amounts directly as VND totals
              if (_customBaseAmount != null &&
                  widget.onApplyAsTotal != null &&
                  widget.subtotal > 0 &&
                  _selectedBaseCurrency ==
                      widget.exchangeRateData.baseCurrency.currencyCode) ...[
                const SizedBox(height: TossSpacing.space3),
                _buildApplyButton(baseAmount),
              ],
            ],
          ),
        );
      },
      loading: () => TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TossLoadingView.inline(size: 16),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Loading real-time rates...',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
      error: (error, _) => TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 16, color: TossColors.error),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Failed to load rates',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.error,
              ),
            ),
          ],
        ),
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
    // Hide hint when focused so user can type fresh
    final showHint = !focusNode.hasFocus;

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
                  hintText: showHint ? displayHint : null,
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

  Widget _buildApplyButton(double baseAmount) {
    // Calculate discount = subtotal - new total (baseAmount)
    // Positive = discount, Negative = surcharge (e.g., card fee)
    final discount = widget.subtotal - baseAmount;
    final isValid = baseAmount > 0;
    final isSurcharge = discount < 0;
    final displayAmount = discount.abs();

    return GestureDetector(
      onTap: isValid
          ? () {
              widget.onApplyAsTotal?.call(baseAmount, discount);
              // Clear custom amounts after applying
              setState(() {
                _customBaseAmount = null;
                _customSecondaryAmount = null;
                _baseAmountController.clear();
                _secondaryAmountController.clear();
              });
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isValid ? TossColors.primary : TossColors.gray200,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 18,
              color: isValid ? TossColors.white : TossColors.gray400,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Apply as Total',
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isValid ? TossColors.white : TossColors.gray400,
              ),
            ),
            if (discount != 0) ...[
              const SizedBox(width: TossSpacing.space2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space1 + 2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  isSurcharge
                      ? '+${PaymentHelpers.formatNumber(displayAmount.round())}'
                      : '-${PaymentHelpers.formatNumber(displayAmount.round())}',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
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
                    final otherSelection = isForBase
                        ? _selectedSecondaryCurrency
                        : _selectedBaseCurrency;
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
