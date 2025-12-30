import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Manager Stats Card
///
/// Displays key statistics for managers
class ManagerStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;

  const ManagerStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? TossColors.primary;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.paddingXS),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: TossSpacing.marginSM),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.marginMD),
          Text(
            value,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: TossSpacing.marginXS),
            Text(
              subtitle!,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
