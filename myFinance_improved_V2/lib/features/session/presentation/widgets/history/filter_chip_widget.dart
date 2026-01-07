import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Reusable filter chip widget for session history filter sheet
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? prefixIcon;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? TossColors.primary.withValues(alpha: 0.1)
              : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Center(
          child: prefixIcon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prefixIcon!,
                    const SizedBox(width: TossSpacing.space1),
                    Flexible(
                      child: Text(
                        label,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? TossColors.primary
                              : TossColors.textPrimary,
                          fontWeight:
                              isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Text(
                  label,
                  style: TossTextStyles.bodySmall.copyWith(
                    color:
                        isSelected ? TossColors.primary : TossColors.textPrimary,
                    fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Store chip with smaller padding
class StoreChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const StoreChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? TossColors.primary.withValues(alpha: 0.15)
              : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: isSelected ? TossColors.primary : TossColors.textPrimary,
            fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
          ),
        ),
      ),
    );
  }
}
