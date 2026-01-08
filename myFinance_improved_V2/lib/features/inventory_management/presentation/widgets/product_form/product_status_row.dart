import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Product status toggle row
///
/// Displays an Active/Inactive toggle switch for product status.
class ProductStatusRow extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const ProductStatusRow({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: TossSpacing.buttonHeightLG),
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label
          Text(
            'Product Status',
            style: TossTextStyles.body.copyWith(
              fontWeight: TossFontWeight.medium,
              color: TossColors.gray600,
            ),
          ),
          // Toggle and status text
          Row(
            children: [
              Text(
                isActive ? 'Active' : 'Inactive',
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: isActive ? TossColors.primary : TossColors.gray500,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              SizedBox(
                height: TossSpacing.iconMD2,
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isActive,
                    onChanged: onChanged,
                    activeTrackColor: TossColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
