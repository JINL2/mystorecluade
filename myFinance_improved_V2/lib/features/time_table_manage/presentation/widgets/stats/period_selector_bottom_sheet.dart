import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
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
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
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
          color: isSelected ? TossColors.primary.withValues(alpha: 0.08) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: 0.12)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray500,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                period.label,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? TossColors.gray900 : TossColors.gray700,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
