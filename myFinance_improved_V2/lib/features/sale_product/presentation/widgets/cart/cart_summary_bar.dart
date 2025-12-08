import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

class CartSummaryBar extends StatelessWidget {
  final int itemCount;
  final double subtotal;
  final VoidCallback onReset;
  final VoidCallback onDone;
  final String currencySymbol;

  const CartSummaryBar({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.onReset,
    required this.onDone,
    this.currencySymbol = '₩',
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        border: const Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Items in Cart',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        '$itemCount',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$currencySymbol${formatter.format(subtotal.round())}',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),

            // Action Buttons
            Row(
              children: [
                // Reset Button
                SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed: onReset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      side: const BorderSide(color: TossColors.gray300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),

                // Continue Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Pay',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
