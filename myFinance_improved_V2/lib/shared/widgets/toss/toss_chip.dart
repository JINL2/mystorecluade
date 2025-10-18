import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Toss-style chip component for filters and selections
class TossChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? trailing;
  final IconData? icon;
  final bool showCount;
  final int? count;

  const TossChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.trailing,
    this.icon,
    this.showCount = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? TossColors.primary.withOpacity(0.1)
                : TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border: Border.all(
              color: isSelected
                  ? TossColors.primary
                  : TossColors.gray200,
              width: isSelected ? TossSpacing.space0 + 1.5 : TossSpacing.space0 + 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: TossSpacing.iconXS - 2,
                  color: isSelected
                      ? TossColors.primary
                      : TossColors.gray600,
                ),
                SizedBox(width: TossSpacing.space1),
              ],
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: isSelected
                      ? TossColors.primary
                      : TossColors.gray700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (showCount && count != null && count! > 0) ...[
                SizedBox(width: TossSpacing.space1),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space1,
                    vertical: TossSpacing.space0 + 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? TossColors.primary.withOpacity(0.2)
                        : TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    '$count',
                    style: TossTextStyles.caption.copyWith(
                      color: isSelected
                          ? TossColors.primary
                          : TossColors.gray500,
                      fontSize: TossSpacing.space2 + 2,
                    ),
                  ),
                ),
              ],
              if (trailing != null) ...[
                SizedBox(width: TossSpacing.space1),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Group of Toss chips for filters
class TossChipGroup extends StatelessWidget {
  final List<TossChipItem> items;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final double spacing;
  final double runSpacing;

  const TossChipGroup({
    super.key,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.spacing = TossSpacing.space2,
    this.runSpacing = TossSpacing.space2,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: items.map((item) {
        final isSelected = selectedValue == item.value;
        return TossChip(
          label: item.label,
          isSelected: isSelected,
          icon: item.icon,
          showCount: item.count != null,
          count: item.count,
          onTap: () {
            onChanged?.call(isSelected ? null : item.value);
          },
        );
      }).toList(),
    );
  }
}

/// Data class for chip items
class TossChipItem {
  final String value;
  final String label;
  final IconData? icon;
  final int? count;

  const TossChipItem({
    required this.value,
    required this.label,
    this.icon,
    this.count,
  });
}