import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/currency.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Exchange rate step widget for add currency flow
class ExchangeRateStep extends StatelessWidget {
  final CurrencyType selectedCurrencyType;
  final String? baseCurrencySymbol;
  final TextEditingController exchangeRateController;
  final bool isFetchingExchangeRate;
  final double? suggestedExchangeRate;
  final bool isLoading;
  final VoidCallback onAdd;
  final VoidCallback onExchangeRateChanged;

  const ExchangeRateStep({
    super.key,
    required this.selectedCurrencyType,
    required this.baseCurrencySymbol,
    required this.exchangeRateController,
    required this.isFetchingExchangeRate,
    required this.suggestedExchangeRate,
    required this.isLoading,
    required this.onAdd,
    required this.onExchangeRateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Currency selection display
        _buildCurrencyDisplay(),

        // Exchange rate configuration
        _buildExchangeRateConfig(),

        // Bottom action buttons
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildCurrencyDisplay() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          Text(
            selectedCurrencyType.flagEmoji,
            style: TossTextStyles.h3,
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCurrencyType.currencyCode,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                Text(
                  selectedCurrencyType.currencyName,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateConfig() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exchange Rate Configuration',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Exchange rate display
          if (baseCurrencySymbol != null) ...[
            _buildRateDisplay(),
            const SizedBox(height: TossSpacing.space3),
          ],

          // Exchange rate input
          _buildRateInput(),
        ],
      ),
    );
  }

  Widget _buildRateDisplay() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '1 ${selectedCurrencyType.symbol}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: TossColors.gray600,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                '${exchangeRateController.text.isEmpty ? "0" : exchangeRateController.text} $baseCurrencySymbol',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'Base Currency: $baseCurrencySymbol',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exchange Rate',
          style: TossTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: exchangeRateController,
          enabled: !isFetchingExchangeRate && suggestedExchangeRate != null,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: isFetchingExchangeRate ? 'Fetching rate...' : 'Enter exchange rate',
            suffixText: baseCurrencySymbol,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.gray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.primary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.gray200),
            ),
          ),
          onChanged: (_) => onExchangeRateChanged(),
        ),
        const SizedBox(height: TossSpacing.space2),

        // Loading state or suggested rate
        _buildRateStatus(),
      ],
    );
  }

  Widget _buildRateStatus() {
    if (isFetchingExchangeRate) {
      return Row(
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Fetching current exchange rates...',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
            ),
          ),
        ],
      );
    }

    if (suggestedExchangeRate != null) {
      return Row(
        children: [
          const Icon(
            Icons.trending_up,
            size: 14,
            color: TossColors.success,
          ),
          const SizedBox(width: TossSpacing.space1),
          Text(
            'Live rate: ${suggestedExchangeRate!.toStringAsFixed(4)} (from Exchange Rate API)',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.success,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionButtons(BuildContext context) {
    final isEnabled = !isLoading &&
        !isFetchingExchangeRate &&
        exchangeRateController.text.isNotEmpty &&
        suggestedExchangeRate != null;

    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space4),
      padding: const EdgeInsets.only(top: TossSpacing.space4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: TossColors.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: TossSecondaryButton(
              text: 'Cancel',
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Add button
          Expanded(
            flex: 2,
            child: TossPrimaryButton(
              text: 'Add Currency',
              isLoading: isLoading,
              isEnabled: isEnabled,
              onPressed: isEnabled ? onAdd : null,
            ),
          ),
        ],
      ),
    );
  }
}
