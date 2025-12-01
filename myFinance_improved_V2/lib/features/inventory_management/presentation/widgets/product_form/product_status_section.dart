import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Product status toggle section for edit product page
class ProductStatusSection extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const ProductStatusSection({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.toggle_on_outlined,
            color: TossColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Product Status',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Switch(
            value: isActive,
            onChanged: onChanged,
            activeTrackColor: TossColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TossTextStyles.body.copyWith(
              color: isActive ? TossColors.success : TossColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
