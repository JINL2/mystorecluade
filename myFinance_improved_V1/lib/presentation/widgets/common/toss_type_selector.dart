import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';

/// Reusable Toss-style Type Selector Component
/// Displays a grid of selectable type options with icons and labels
class TossTypeSelector<T> extends StatelessWidget {
  final String? label;
  final List<TossTypeOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T>? onChanged;
  final int crossAxisCount;
  final double childAspectRatio;

  const TossTypeSelector({
    super.key,
    this.label,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1.1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TossTextStyles.labelLarge.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
        ],
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: TossSpacing.space3,
          crossAxisSpacing: TossSpacing.space3,
          childAspectRatio: childAspectRatio,
          children: options.map((option) => _buildTypeOption(option)).toList(),
        ),
      ],
    );
  }

  Widget _buildTypeOption(TossTypeOption<T> option) {
    final isSelected = selectedValue == option.value;
    return TossAnimatedWidget(
      duration: TossAnimations.quick,
      curve: TossAnimations.decelerate,
      onTap: () => onChanged?.call(option.value),
      child: AnimatedContainer(
        duration: TossAnimations.normal,
        curve: TossAnimations.standard,
        decoration: BoxDecoration(
          // Toss Principle: Single accent color for all selections
          color: isSelected ? TossColors.primary.withOpacity(0.08) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            // Consistent Toss Blue for all selected states
            color: isSelected ? TossColors.primary : TossColors.gray200,
            width: isSelected ? TossSpacing.space0 + 2 : TossSpacing.space0 + 1,
          ),
          // Simplified shadow - only when selected, always same color
          boxShadow: isSelected ? [
            BoxShadow(
              color: TossColors.primary.withOpacity(0.15),
              blurRadius: TossSpacing.space2,
              offset: const Offset(0, TossSpacing.space1),
            ),
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simplified icon container with smooth color transition
            AnimatedContainer(
              duration: TossAnimations.normal,
              curve: TossAnimations.standard,
              padding: EdgeInsets.all(TossSpacing.space3),
              child: AnimatedSwitcher(
                duration: TossAnimations.quick,
                child: Icon(
                  option.icon,
                  key: ValueKey('${option.value}_${isSelected ? 'selected' : 'unselected'}'),
                  size: TossSpacing.iconLG,
                  // Consistent coloring: Toss Blue when selected, gray when not
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space1),
            AnimatedDefaultTextStyle(
              duration: TossAnimations.normal,
              curve: TossAnimations.standard,
              style: TossTextStyles.caption.copyWith(
                // Consistent text coloring: Toss Blue when selected, gray when not
                color: isSelected ? TossColors.primary : TossColors.gray600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(
                option.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for type selector options
class TossTypeOption<T> {
  final T value;
  final String label;
  final IconData icon;
  final Color color;

  const TossTypeOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}