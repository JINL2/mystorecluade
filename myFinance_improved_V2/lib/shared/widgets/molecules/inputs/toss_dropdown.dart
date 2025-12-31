import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/core/constants/ui_constants.dart';

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
  static const double _maxBottomSheetHeight = 0.8;
  static const double _minBottomSheetHeight = 200.0;
  static const double _handleBarWidth = 36.0;
  static const double _handleBarHeight = 4.0;
  static const double _iconSize = TossSpacing.iconMD;
  static const double _checkIconSize = TossSpacing.iconXS;

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
                style: TossTextStyles.label.copyWith(
                  color: hasError ? TossColors.error : TossColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 2),
                Text(
                  '*',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.w600,
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
                padding: const EdgeInsets.all(TossSpacing.space3),
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
                      Icons.arrow_drop_down,
                      color: TossColors.gray600,
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
        const SizedBox(
          width: 16,
          height: 16,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54, // Standard barrier color to prevent double barriers
      isScrollControlled: true,
      enableDrag: true, // Allow swipe-to-dismiss
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) => _BottomSheetContent<T>(
        label: label,
        items: items,
        value: value,
        onChanged: onChanged,
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

/// Separated bottom sheet content for better maintainability
class _BottomSheetContent<T> extends StatelessWidget {
  final String label;
  final List<TossDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  const _BottomSheetContent({
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * TossDropdown._maxBottomSheetHeight,
        minHeight: TossDropdown._minBottomSheetHeight,
      ),
      decoration: _buildBottomSheetDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandleBar(),
          _buildHeader(context),
          const SizedBox(height: TossSpacing.space3),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
          ),
          const SizedBox(height: TossSpacing.space2),
          _buildOptionsList(context),
        ],
      ),
    );
  }

  BoxDecoration _buildBottomSheetDecoration() {
    return BoxDecoration(
      color: TossColors.surface,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(TossBorderRadius.xl),
        topRight: Radius.circular(TossBorderRadius.xl),
      ),
      boxShadow: [
        BoxShadow(
          color: TossColors.gray900.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  Widget _buildHandleBar() {
    return Container(
      width: TossDropdown._handleBarWidth,
      height: TossDropdown._handleBarHeight,
      margin: const EdgeInsets.only(
        top: TossSpacing.space3,
        bottom: TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray300, // Restore grey handle bar
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildOptionsList(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildOptionItem(context, items[index]),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, TossDropdownItem<T> item) {
    final isSelected = item.value == value;
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: 2,
      ),
      decoration: _buildOptionDecoration(isSelected),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          onTap: () => _handleOptionTap(context, item),
          child: _buildOptionContent(item, isSelected),
        ),
      ),
    );
  }

  BoxDecoration _buildOptionDecoration(bool isSelected) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      color: TossColors.transparent,
    );
  }

  void _handleOptionTap(BuildContext context, TossDropdownItem<T> item) {
    onChanged?.call(item.value);
    Navigator.of(context).pop();
  }

  Widget _buildOptionContent(TossDropdownItem<T> item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Icon (if provided)
          if (item.icon != null) ...[
            Icon(
              item.icon,
              size: TossSpacing.iconMD,
              color: TossColors.gray400,
            ),
            const SizedBox(width: TossSpacing.space3),
          ],
          Expanded(
            child: _buildOptionText(item, isSelected),
          ),
          if (isSelected) _buildCheckIcon(),
        ],
      ),
    );
  }

  Widget _buildOptionText(TossDropdownItem<T> item, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: UIConstants.textSizeLarge,
          ),
        ),
        if (item.subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            item.subtitle!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontSize: UIConstants.textSizeCompact,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckIcon() {
    return const Icon(
      Icons.check,
      color: TossColors.primary,
      size: TossDropdown._iconSize,
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