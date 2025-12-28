import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
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
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label
          Text(
            'Product Status',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),
          // Toggle and status text
          Row(
            children: [
              Text(
                isActive ? 'Active' : 'Inactive',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive ? TossColors.primary : TossColors.gray500,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 24,
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
