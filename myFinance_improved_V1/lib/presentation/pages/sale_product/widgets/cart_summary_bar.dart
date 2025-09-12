import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class CartSummaryBar extends StatelessWidget {
  final int itemCount;
  final double subtotal;
  final VoidCallback onReset;
  final VoidCallback onDone;

  const CartSummaryBar({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.onReset,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        border: Border(
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
                    SizedBox(width: TossSpacing.space2),
                    Container(
                      padding: EdgeInsets.symmetric(
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
                  '₩${formatter.format(subtotal.round())}',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            
            // Action Buttons
            Row(
              children: [
                // Reset Button
                SizedBox(
                  width: 100,
                  child: OutlinedButton(
                    onPressed: onReset,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      side: BorderSide(color: TossColors.gray300),
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
                SizedBox(width: TossSpacing.space3),
                
                // Continue Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue to Invoice',
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