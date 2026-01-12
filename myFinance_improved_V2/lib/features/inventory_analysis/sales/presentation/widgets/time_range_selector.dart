import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../domain/entities/sales_analytics.dart';

/// Time Range Selector Widget
/// Horizontal scrollable chips for selecting time ranges
class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onChanged;
  final VoidCallback? onCustomTap;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onChanged,
    this.onCustomTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: TimeRange.values
            .map((range) => Padding(
                  padding: const EdgeInsets.only(right: TossSpacing.space2),
                  child: _TimeRangeChip(
                    label: range.label,
                    isSelected: selectedRange == range,
                    onTap: () => onChanged(range),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _TimeRangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeRangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: TossAnimations.normal,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
