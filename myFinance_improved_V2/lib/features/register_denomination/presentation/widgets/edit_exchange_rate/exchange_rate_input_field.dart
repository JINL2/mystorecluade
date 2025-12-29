import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Exchange rate input field widget
class ExchangeRateInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? baseCurrencySymbol;
  final bool isFetchingRate;

  const ExchangeRateInputField({
    super.key,
    required this.controller,
    this.baseCurrencySymbol,
    this.isFetchingRate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exchange Rate',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
          ],
          textInputAction: TextInputAction.done,
          enabled: !isFetchingRate,
          autofocus: false,
          style: TossTextStyles.body.copyWith(
            color: !isFetchingRate ? TossColors.gray900 : TossColors.gray500,
            fontSize: 16,
          ),
          cursorColor: TossColors.primary,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: 'Enter exchange rate',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            filled: true,
            fillColor: !isFetchingRate ? TossColors.gray50 : TossColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(
                color: TossColors.primary,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space4,
            ),
            prefixIcon: const Icon(Icons.swap_horiz, color: TossColors.gray500),
            suffixText: baseCurrencySymbol,
            suffixStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
      ],
    );
  }
}
