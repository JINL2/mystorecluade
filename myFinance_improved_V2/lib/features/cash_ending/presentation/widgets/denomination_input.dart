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
import '../../../../shared/widgets/toss/toss_quantity_input.dart';
import '../../domain/entities/denomination.dart';

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
    final formattedAmount = NumberFormat('#,###').format(amount);

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
          // Left section: Denomination display
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

          // Right section: Amount display
          Expanded(
            child: Builder(
              builder: (context) {
                final subtotalText = _calculateSubtotal(
                  denomination.value.toInt().toString(),
                  controller.text,
                  currencySymbol,
                );

                // Check if subtotal is zero
                final isZero = subtotalText == '0' || subtotalText.isEmpty;

                return Text(
                  subtotalText,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isZero ? TossColors.gray600 : TossColors.gray900,
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

  // Helper functions (from legacy denomination_widgets.dart)

  /// Enhanced subtotal calculation with comprehensive error handling
  String _calculateSubtotal(String denomValue, String quantity, String currencySymbol) {
    // Edge case handling: null or empty inputs
    if (denomValue.isEmpty || quantity.isEmpty) {
      return '0';
    }

    // Parse values with error handling
    final denom = int.tryParse(denomValue.trim()) ?? 0;
    final qty = int.tryParse(quantity.trim()) ?? 0;

    // Prevent integer overflow for very large calculations
    late final int subtotal;
    try {
      subtotal = denom * qty;
      // Check for overflow (though unlikely with our constraints)
      if (subtotal < 0) {
        // Overflow occurred, use safe fallback
        return '999,999,999'; // Limit to 9 digits
      }
    } catch (e) {
      // Fallback for any calculation errors
      return '0';
    }

    // Format without currency symbol
    try {
      final formatted = NumberFormat('#,###').format(subtotal);

      // If number is too long (more than 9 digits), truncate while maintaining comma alignment
      // Remove commas to count actual digits
      final digitsOnly = formatted.replaceAll(',', '');

      if (digitsOnly.length > 9) {
        // To maintain comma alignment with totals, we need to keep the same structure
        // Example: 4,994,000,000 should show as 4,994,00... (not 499,400,000...)
        // We show first 7 characters (including commas) to prevent overflow
        final truncated = formatted.length > 7 ? formatted.substring(0, 8) : formatted;
        return '$truncated...';
      }

      return formatted;
    } catch (e) {
      // Fallback for number formatting errors
      return subtotal.toString();
    }
  }
}
