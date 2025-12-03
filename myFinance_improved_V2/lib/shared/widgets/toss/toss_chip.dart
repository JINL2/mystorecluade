import 'package:flutter/material.dart';
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
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? TossColors.primary
                : TossColors.transparent,
            borderRadius: BorderRadius.circular(TossBorderRadius.full),
            border: isSelected ? null : Border.all(
              color: TossColors.gray300,
              width: 1,
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
                      ? TossColors.white
                      : TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space1),
              ],
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: isSelected
                      ? TossColors.white
                      : TossColors.gray700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (showCount && count != null) ...[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: TossTextStyles.caption.copyWith(
                    color: isSelected
                        ? TossColors.white
                        : TossColors.gray500,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: TossSpacing.space1),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Group of Toss chips for filters - styled as segmented control
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
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isSelected = selectedValue == item.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onChanged?.call(item.value);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.primary : TossColors.transparent,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.label,
                      style: TossTextStyles.caption.copyWith(
                        color: isSelected ? TossColors.white : TossColors.gray700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (item.count != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '${item.count}',
                        style: TossTextStyles.caption.copyWith(
                          color: isSelected ? TossColors.white : TossColors.gray500,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
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