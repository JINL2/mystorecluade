import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'toss_dropdown_bottom_sheet.dart';

/// Toss-style dropdown with bottom sheet selection
class TossDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<TossDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? errorText;
  final bool isLoading;
  final bool isRequired;

  // Constants for better maintainability
  static const double _iconSize = TossSpacing.iconMD;

  const TossDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.errorText,
    this.isLoading = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final selectedItem = _getSelectedItem();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (only show if not empty)
        if (label.isNotEmpty) ...[
          Row(
            children: [
              Text(
                label,
                style: hasError
                    ? TossTextStyles.smallSectionTitle.copyWith(color: TossColors.error)
                    : TossTextStyles.smallSectionTitle,
              ),
              if (isRequired) ...[
                SizedBox(width: TossSpacing.space1 / 2),
                Text(
                  '*',
                  style: TossTextStyles.smallSectionTitle.copyWith(
                    color: TossColors.error,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
        ],
        
        // Dropdown Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: TossColors.surface,
            border: Border.all(
              color: hasError
                ? TossColors.error
                : TossColors.border,
              width: hasError ? 2 : 1,
            ),
          ),
          child: Material(
            color: TossColors.transparent,
            child: InkWell(
              onTap: isLoading || onChanged == null 
                ? null 
                : () => _showSelectionBottomSheet(context),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                child: Row(
                  children: [
                    
                    // Selected value or hint
                    Expanded(
                      child: isLoading
                        ? _buildLoadingIndicator(context)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getDisplayText(selectedItem),
                                style: _getDisplayTextStyle(),
                              ),
                              // Remove subtitle display in main field for cleaner look
                            ],
                          ),
                    ),
                    
                    // Dropdown icon
                    const Icon(
                      LucideIcons.chevronDown,
                      color: TossColors.gray700,
                      size: _iconSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Error text
        if (hasError) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildLoadingIndicator(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: TossSpacing.iconSM2,
          height: TossSpacing.iconSM2,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              TossColors.primary,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          'Loading...',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  void _showSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) => TossDropdownBottomSheet<T>(
        title: label,
        items: items,
        selectedValue: value,
        onSelected: (selectedValue) {
          onChanged?.call(selectedValue);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// Helper method to get selected item efficiently
  TossDropdownItem<T>? _getSelectedItem() {
    if (value == null) return null;
    try {
      return items.firstWhere((item) => item.value == value);
    } catch (e) {
      return null; // Return null if value not found in items
    }
  }

  /// Helper method to get display text
  String _getDisplayText(TossDropdownItem<T>? selectedItem) {
    if (selectedItem != null) {
      return selectedItem.label;
    }
    if (value != null) {
      return 'Invalid selection'; // Value exists but not in items
    }
    return hint ?? 'Select $label';
  }

  /// Helper method to get display text style
  TextStyle _getDisplayTextStyle() {
    return TossTextStyles.bodyLarge.copyWith(
      color: value != null ? TossColors.textPrimary : TossColors.textTertiary,
      fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
    );
  }
}

/// Dropdown item with label, optional subtitle, and optional icon
class TossDropdownItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;

  const TossDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}