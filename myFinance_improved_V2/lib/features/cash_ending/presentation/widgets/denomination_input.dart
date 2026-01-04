// lib/features/cash_ending/presentation/widgets/denomination_input.dart
// Adapted from legacy denomination_widgets.dart (lines 293-708)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/denomination.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Denomination input widget - exact legacy UI/UX from denomination_widgets.dart
///
/// Compact 3-column layout (denomination | controls | total)
/// Fixed 40px height with responsive font sizing
class DenominationInput extends StatelessWidget {
  final Denomination denomination;
  final TextEditingController controller;
  final String currencySymbol;
  final VoidCallback onChanged;
  final FocusNode? focusNode;

  // Static NumberFormat to avoid creating new instances on every build
  static final _numberFormat = NumberFormat('#,###');

  const DenominationInput({
    super.key,
    required this.denomination,
    required this.controller,
    required this.currencySymbol,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final amount = denomination.value.toInt();
    final formattedAmount = _numberFormat.format(amount);

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.fromLTRB(
        0, // left - removed 8px padding
        TossSpacing.space2, // top
        0, // right - removed 8px padding to prevent overflow
        TossSpacing.space2, // bottom
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left section: Denomination display - left aligned
          Expanded(
            child: Text(
              '$currencySymbol$formattedAmount',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ),

          // Center section: Quantity input with +/- buttons
          TossQuantityInput(
            value: int.tryParse(controller.text) ?? 0,
            onChanged: (newValue) {
              controller.text = newValue == 0 ? '' : newValue.toString();
              onChanged();
            },
            minValue: 0,
            maxValue: 99999,
            inputWidth: 90,
            buttonSize: 32,
            borderRadius: 6,
          ),

          // Right section: Amount display - right aligned
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                // Calculate subtotal from controller value (not denomination.quantity)
                // because denomination entity doesn't update with user input
                final quantity = int.tryParse(value.text.trim()) ?? 0;
                final subtotal = denomination.value * quantity;
                final subtotalText = _numberFormat.format(subtotal.toInt());

                // Check if subtotal is zero
                final isZero = subtotal == 0;

                return Text(
                  subtotalText,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isZero ? TossColors.gray400 : TossColors.gray900,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // NOTE: Calculation logic removed from widget
  // Business logic (totalAmount) is now handled by Domain Entity (Denomination.totalAmount)
  // This follows Clean Architecture - UI widgets should only handle presentation
}
