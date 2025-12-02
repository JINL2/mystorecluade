import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../domain/entities/exchange_rate_data.dart' as entities;
import '../helpers/payment_helpers.dart';

/// Currency converter section widget
class CurrencyConverterSection extends StatefulWidget {
  final entities.ExchangeRateData? exchangeRateData;
  final double finalTotal;

  const CurrencyConverterSection({
    super.key,
    required this.exchangeRateData,
    required this.finalTotal,
  });

  @override
  State<CurrencyConverterSection> createState() =>
      _CurrencyConverterSectionState();
}

class _CurrencyConverterSectionState extends State<CurrencyConverterSection> {
  String? _selectedCurrencyCode;

  @override
  Widget build(BuildContext context) {
    if (widget.exchangeRateData == null) return const SizedBox.shrink();

    final baseCurrency = widget.exchangeRateData!.baseCurrency;
    final exchangeRates = widget.exchangeRateData!.rates;

    // Filter out the base currency from the list
    final otherCurrencies = exchangeRates.where((rate) {
      return rate.currencyCode != baseCurrency.currencyCode;
    }).toList();

    if (otherCurrencies.isEmpty) return const SizedBox.shrink();

    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: TossSpacing.space3),
          _buildCurrencyButtons(otherCurrencies),
          if (_selectedCurrencyCode != null) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildConvertedAmount(baseCurrency, otherCurrencies),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(
          Icons.currency_exchange,
          color: TossColors.primary,
          size: TossSpacing.iconSM,
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          'Currency Converter',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyButtons(List<entities.ExchangeRate> otherCurrencies) {
    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: otherCurrencies.map((rate) {
        final currencyCode = rate.currencyCode;
        final symbol = rate.symbol;
        final isSelected = _selectedCurrencyCode == currencyCode;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedCurrencyCode = isSelected ? null : currencyCode;
            });
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
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
                const SizedBox(width: TossSpacing.space1),
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
    );
  }

  Widget _buildConvertedAmount(
    entities.Currency baseCurrency,
    List<entities.ExchangeRate> otherCurrencies,
  ) {
    final selectedRate = otherCurrencies.where((r) {
      return r.currencyCode == _selectedCurrencyCode;
    }).firstOrNull;

    if (selectedRate == null) return const SizedBox.shrink();

    final convertedAmount = widget.finalTotal / selectedRate.rate;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.3),
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
          const SizedBox(height: TossSpacing.space1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${baseCurrency.symbol} ${PaymentHelpers.formatNumber(widget.finalTotal.round())} ${baseCurrency.currencyCode}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: TossColors.gray500,
                  ),
                ],
              ),
              Text(
                '${selectedRate.symbol} ${PaymentHelpers.formatNumber(convertedAmount.round())} $_selectedCurrencyCode',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
