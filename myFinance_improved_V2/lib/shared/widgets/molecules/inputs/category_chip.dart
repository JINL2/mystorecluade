import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Category chip with optional close button for removable tags/categories
///
/// Similar to TossChip but designed for category/tag management with removal
class CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CategoryChip({
    super.key,
    required this.label,
    this.onTap,
    this.onRemove,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  // Chip-specific constants (aligned with TossSpacing)
  static const double _chipBorderRadius = TossBorderRadius.xxl; // 20.0
  static const double _chipIconSize = 14.0; // Small icon for chips

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_chipBorderRadius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? TossColors.gray100,
            borderRadius: BorderRadius.circular(_chipBorderRadius),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: _chipIconSize,
                  color: textColor ?? TossColors.gray700,
                ),
                const SizedBox(width: TossSpacing.space1),
              ],
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: textColor ?? TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: TossSpacing.space1),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close,
                    size: _chipIconSize,
                    color: textColor ?? TossColors.gray600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Group of category chips with wrapping layout
class CategoryChipGroup extends StatelessWidget {
  final List<CategoryChipItem> items;
  final Function(CategoryChipItem)? onChipTap;
  final Function(CategoryChipItem)? onChipRemove;
  final double spacing;
  final double runSpacing;
  final bool showRemoveButton;

  const CategoryChipGroup({
    super.key,
    required this.items,
    this.onChipTap,
    this.onChipRemove,
    this.spacing = TossSpacing.space2,
    this.runSpacing = TossSpacing.space2,
    this.showRemoveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: items.map((item) {
        return CategoryChip(
          label: item.label,
          icon: item.icon,
          backgroundColor: item.backgroundColor,
          textColor: item.textColor,
          borderColor: item.borderColor,
          onTap: onChipTap != null ? () => onChipTap!(item) : null,
          onRemove: showRemoveButton && onChipRemove != null
              ? () => onChipRemove!(item)
              : null,
        );
      }).toList(),
    );
  }
}

/// Data class for category chip items
class CategoryChipItem {
  final String id;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CategoryChipItem({
    required this.id,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });
}
