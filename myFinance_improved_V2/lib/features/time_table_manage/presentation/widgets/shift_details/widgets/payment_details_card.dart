import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Payment Details Card Widget
///
/// Displays base pay, current bonus, and total pay breakdown.
class PaymentDetailsCard extends StatelessWidget {
  final num basePay;
  final num bonusAmount;

  const PaymentDetailsCard({
    super.key,
    required this.basePay,
    required this.bonusAmount,
  });

  num get totalPay => basePay + bonusAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Payment Details',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Base Pay Row
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
                basePay != 0
                    ? NumberFormat('#,###').format(basePay.toInt())
                    : '0',
                style: TossTextStyles.body.copyWith(
                  color: basePay < 0 ? TossColors.error : TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),

          // Current Bonus Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Bonus',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                bonusAmount > 0
                    ? '+ ${NumberFormat('#,###').format(bonusAmount.toInt())}'
                    : '+ 0',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Divider
          Container(
            margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            height: 1,
            color: TossColors.info.withValues(alpha: 0.2),
          ),

          // Total Pay Row
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
                NumberFormat('#,###').format(totalPay.toInt()),
                style: TossTextStyles.h3.copyWith(
                  color: totalPay < 0 ? TossColors.error : TossColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
