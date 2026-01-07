import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';
import '../../pages/shift_stats_tab.dart';

/// Period selector bottom sheet widget
class PeriodSelectorBottomSheet extends StatelessWidget {
  final StatsPeriod selectedPeriod;
  final void Function(StatsPeriod) onPeriodSelected;

  const PeriodSelectorBottomSheet({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(
              top: TossSpacing.space3,
              bottom: TossSpacing.space2,
            ),
            width: TossDimensions.dragHandleWidth,
            height: TossDimensions.dragHandleHeight,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
            child: Text(
              'Select Period',
              style: TossTextStyles.titleMedium,
            ),
          ),
          // Period options
          ...StatsPeriod.values.map((period) => _buildPeriodOption(period)),
          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(StatsPeriod period) {
    final isSelected = period == selectedPeriod;

    return InkWell(
      onTap: () => onPeriodSelected(period),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: TossOpacity.hover) : null,
        ),
        child: Row(
          children: [
            Container(
              width: TossDimensions.avatarLG,
              height: TossDimensions.avatarLG,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: TossOpacity.pressed)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md + 2), // 10px
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: TossSpacing.iconMD,
                color: isSelected ? TossColors.primary : TossColors.gray500,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                period.label,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
                  color: isSelected ? TossColors.gray900 : TossColors.gray700,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: TossSpacing.iconMD,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
