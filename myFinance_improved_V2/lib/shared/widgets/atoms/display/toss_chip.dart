import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Toss-style chip component for filters, selections, and removable tags
///
/// A versatile chip atom that supports:
/// - **Filter Mode**: Toggle selection state with `isSelected` and `onTap`
/// - **Tag Mode**: Display removable tags with `onRemove` callback
/// - **Custom Styling**: Override colors with `backgroundColor`, `textColor`, `borderColor`
///
/// Usage:
/// ```dart
/// // Filter chip (selectable)
/// TossChip(
///   label: 'Active',
///   isSelected: true,
///   onTap: () => toggleFilter(),
/// )
///
/// // Tag chip (removable)
/// TossChip(
///   label: 'VND • Vietnamese Dong',
///   onRemove: () => removeTag(),
/// )
/// ```
class TossChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final Widget? trailing;
  final IconData? icon;
  final bool showCount;
  final int? count;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const TossChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
    this.trailing,
    this.icon,
    this.showCount = false,
    this.count,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  // Chip-specific constants
  static const double _chipIconSize = 14.0;
  static const double _chipBorderRadius = TossBorderRadius.lg; // 12.0 - matches tag style

  /// Whether this chip is in "tag mode" (has onRemove and no selection)
  bool get _isTagMode => onRemove != null && !isSelected;

  /// Get effective background color
  Color get _backgroundColor {
    if (backgroundColor != null) return backgroundColor!;
    if (isSelected) return TossColors.primary;
    return TossColors.white;
  }

  /// Get effective text color
  Color get _textColor {
    if (textColor != null) return textColor!;
    if (isSelected) return TossColors.white;
    return TossColors.gray700;
  }

  /// Get effective border color
  Color get _borderColor {
    if (borderColor != null) return borderColor!;
    if (isSelected) return TossColors.transparent;
    return TossColors.gray200;
  }

  /// Get border radius based on mode
  double get _borderRadius => _isTagMode ? _chipBorderRadius : TossBorderRadius.full;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: _borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: _chipIconSize,
                  color: _textColor,
                ),
                const SizedBox(width: TossSpacing.space1),
              ],
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: _textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showCount && count != null) ...[
                SizedBox(width: TossSpacing.space1),
                Text(
                  '$count',
                  style: TossTextStyles.caption.copyWith(
                    color: isSelected ? TossColors.white : TossColors.gray500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (onRemove != null) ...[
                const SizedBox(width: TossSpacing.space1),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close,
                    size: _chipIconSize,
                    color: _textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
              if (trailing != null && onRemove == null) ...[
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