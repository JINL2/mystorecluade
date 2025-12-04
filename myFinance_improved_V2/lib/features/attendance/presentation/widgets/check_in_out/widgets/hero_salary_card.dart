import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Estimated salary card for hero section
class HeroSalaryCard extends StatelessWidget {
  final String currencySymbol;
  final String estimatedSalary;
  final String? overtimeBonus;

  const HeroSalaryCard({
    super.key,
    required this.currencySymbol,
    required this.estimatedSalary,
    this.overtimeBonus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.white,
            TossColors.gray50,
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TossColors.primary.withOpacity(0.15),
                      TossColors.primary.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 18,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Estimated Salary',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            '$currencySymbol$estimatedSalary',
            style: TossTextStyles.display.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 36,
              height: 1.1,
            ),
          ),
          if (overtimeBonus != null && overtimeBonus!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.successLight,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    size: 14,
                    color: TossColors.success,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    overtimeBonus!,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'overtime',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
