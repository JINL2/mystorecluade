import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Toggle button for Mean/Median selection
class BcgToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BcgToggleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: TossAnimations.fast,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space1_5),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TossColors.gray300.withValues(alpha: 0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.gray900 : TossColors.gray500,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Container for Mean/Median toggle
class BcgMeanMedianToggle extends StatelessWidget {
  final bool useMean;
  final ValueChanged<bool> onChanged;

  const BcgMeanMedianToggle({
    super.key,
    required this.useMean,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space0_5),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BcgToggleButton(
            label: 'Median',
            isSelected: !useMean,
            onTap: () => onChanged(false),
          ),
          BcgToggleButton(
            label: 'Mean',
            isSelected: useMean,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

/// Container for Revenue/Qty X-axis toggle
class BcgXAxisToggle extends StatelessWidget {
  final bool useRevenue;
  final ValueChanged<bool> onChanged;

  const BcgXAxisToggle({
    super.key,
    required this.useRevenue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space0_5),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BcgToggleButton(
            label: 'Revenue',
            isSelected: useRevenue,
            onTap: () => onChanged(true),
          ),
          BcgToggleButton(
            label: 'Qty',
            isSelected: !useRevenue,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}
