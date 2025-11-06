import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

class BonusConfirmationDialog extends StatelessWidget {
  final num basePay;
  final num currentBonus;
  final num typedBonus;

  const BonusConfirmationDialog({
    super.key,
    required this.basePay,
    required this.currentBonus,
    required this.typedBonus,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final num currentTotal = basePay + currentBonus;
    final num newTotal = basePay + typedBonus;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      title: Text(
        'Confirm Bonus',
        style: TossTextStyles.h3.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.info.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: TossColors.info.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Payment Summary',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),

                // Base Pay
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Base Pay',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      basePay != 0 ? formatter.format(basePay) : '0',
                      style: TossTextStyles.body.copyWith(
                        color: basePay < 0 ? TossColors.error : TossColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),

                // Current Bonus with arrow to New Bonus
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bonus',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          currentBonus > 0 ? '+ ${formatter.format(currentBonus)}' : '+ 0',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray500,
                            fontWeight: FontWeight.w600,
                            decoration: currentTotal != newTotal ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (currentTotal != newTotal) ...[
                          const SizedBox(width: TossSpacing.space2),
                          const Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: TossColors.info,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            typedBonus > 0 ? '+ ${formatter.format(typedBonus)}' : '+ 0',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.info,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                // Divider
                Container(
                  margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                  height: 1,
                  color: TossColors.info.withValues(alpha: 0.2),
                ),

                // Total Pay
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pay',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatter.format(newTotal),
                      style: TossTextStyles.h3.copyWith(
                        color: newTotal < 0 ? TossColors.error : TossColors.info,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.gray200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                  ),
                  child: Text(
                    'OK',
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
      actions: const [],
    );
  }
}
