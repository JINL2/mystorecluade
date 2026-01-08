import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_opacity.dart';
import '../../../../../shared/themes/toss_font_weight.dart';

/// Reusable section wrapper for LC form
class LCFormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const LCFormSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: TossFontWeight.semibold,
            color: TossColors.gray800,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        ...children,
      ],
    );
  }
}

/// Info row for displaying reference information (e.g., PO Number, PI Number)
class LCInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const LCInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: TossOpacity.subtle),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: TossOpacity.overlay)),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TossTextStyles.bodyMedium.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.bodyMedium.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
