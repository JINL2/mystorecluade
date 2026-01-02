import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Period selector widget for trend charts
class PeriodSelector extends StatelessWidget {
  final int selectedPeriodDays;
  final ValueChanged<int> onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriodDays,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          _buildPeriodChip(7, '7 Days'),
          const SizedBox(width: TossSpacing.space2),
          _buildPeriodChip(30, '30 Days'),
          const SizedBox(width: TossSpacing.space2),
          _buildPeriodChip(90, '90 Days'),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(int days, String label) {
    final isSelected = selectedPeriodDays == days;

    return GestureDetector(
      onTap: () => onPeriodChanged(days),
      child: AnimatedContainer(
        duration: TossAnimations.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.gray900 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
