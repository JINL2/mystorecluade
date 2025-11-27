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
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 20,
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                'Estimated Salary',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$currencySymbol$estimatedSalary',
                style: TossTextStyles.display.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
              if (overtimeBonus != null && overtimeBonus!.isNotEmpty) ...[
                const SizedBox(height: TossSpacing.space1),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Text(
                        overtimeBonus!,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'overtime bonus',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
