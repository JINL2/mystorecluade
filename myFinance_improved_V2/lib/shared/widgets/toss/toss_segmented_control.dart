import 'package:flutter/material.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';
import '../../themes/toss_border_radius.dart';

/// TossSegmentedControl - Pill-style segmented control for Week/Month toggle
///
/// Design Specs (from screenshot):
/// - Container: Gray background with rounded corners
/// - Selected: Blue pill with white text
/// - Unselected: Transparent with gray text
/// - Height: ~36px
/// - Animation: Smooth 200ms transition
class TossSegmentedControl extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final EdgeInsets? padding;

  const TossSegmentedControl({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.padding,
  }) : assert(options.length == 2, 'TossSegmentedControl only supports 2 options');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                alignment: Alignment.center,
                child: Text(
                  options[index],
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.white : TossColors.gray600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
