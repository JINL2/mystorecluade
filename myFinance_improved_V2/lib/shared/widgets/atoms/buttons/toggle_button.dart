import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Layout mode for ToggleButtonGroup
enum ToggleButtonLayout {
  /// Each button takes minimum space needed (default, for toolbar/header use)
  compact,

  /// Buttons expand equally to fill available space (for full-width filters)
  expanded,
}

/// Segmented toggle button group - pill-shaped connected buttons
/// Similar to Week/Month toggle style with smooth animation
///
/// Supports two layout modes:
/// - `compact`: Buttons take minimum space (default)
/// - `expanded`: Buttons expand to fill available space
///
/// Example:
/// ```dart
/// // Compact (default) - for toolbars
/// ToggleButtonGroup(
///   items: [...],
///   selectedId: 'week',
///   onToggle: (id) {},
/// )
///
/// // Expanded - for full-width filters
/// ToggleButtonGroup(
///   items: [...],
///   selectedId: 'all',
///   onToggle: (id) {},
///   layout: ToggleButtonLayout.expanded,
/// )
/// ```
class ToggleButtonGroup extends StatelessWidget {
  final List<ToggleButtonItem> items;
  final String selectedId;
  final void Function(String) onToggle;
  final double height;
  final ToggleButtonLayout layout;

  const ToggleButtonGroup({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onToggle,
    this.height = 36,
    this.layout = ToggleButtonLayout.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      padding: const EdgeInsets.all(TossSpacing.space1 / 2),
      child: Row(
        mainAxisSize: layout == ToggleButtonLayout.compact
            ? MainAxisSize.min
            : MainAxisSize.max,
        children: items.map((item) {
          final isSelected = selectedId == item.id;
          final buttonContent = _buildButtonContent(item, isSelected);

          if (layout == ToggleButtonLayout.expanded) {
            return Expanded(child: buttonContent);
          }
          return buttonContent;
        }).toList(),
      ),
    );
  }

  Widget _buildButtonContent(ToggleButtonItem item, bool isSelected) {
    return GestureDetector(
      onTap: () => onToggle(item.id),
      child: AnimatedContainer(
        duration: TossAnimations.normal,
        curve: TossAnimations.standard,
        padding: EdgeInsets.symmetric(
          horizontal: layout == ToggleButtonLayout.expanded
              ? TossSpacing.space2
              : TossSpacing.space4,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.transparent,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: TossSpacing.iconXS,
                  color: isSelected ? TossColors.white : TossColors.gray700,
                ),
                const SizedBox(width: TossSpacing.space1),
              ],
              Flexible(
                child: Text(
                  item.label,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.white : TossColors.gray700,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.count != null) ...[
                const SizedBox(width: TossSpacing.space1),
                Text(
                  '${item.count}',
                  style: TossTextStyles.caption.copyWith(
                    color: isSelected ? TossColors.white.withValues(alpha: 0.8) : TossColors.gray500,
                    fontWeight: FontWeight.w500,
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

/// Data class for toggle button items
class ToggleButtonItem {
  final String id;
  final String label;
  final IconData? icon;
  final int? count;

  const ToggleButtonItem({
    required this.id,
    required this.label,
    this.icon,
    this.count,
  });
}
