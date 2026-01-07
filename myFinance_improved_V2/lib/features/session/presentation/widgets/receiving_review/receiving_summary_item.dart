import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Summary item widget for receiving review stats
class ReceivingSummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const ReceivingSummaryItem({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
        SizedBox(height: TossSpacing.space0_5),
        Text(
          value,
          style: TossTextStyles.bodyMedium.copyWith(
            color: color ?? TossColors.textPrimary,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      ],
    );
  }
}
