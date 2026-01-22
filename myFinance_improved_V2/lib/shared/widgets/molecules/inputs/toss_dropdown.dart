import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/trigger_bottom_sheet_common.dart';

/// Toss-style dropdown with bottom sheet selection
///
/// Uses [TriggerBottomSheetCommon] for consistent trigger + sheet UI.
class TossDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<TossDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? errorText;
  final bool isLoading;
  final bool isRequired;

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

    return TriggerBottomSheetCommon<T>(
      label: label,
      value: value,
      displayText: _getDisplayText(),
      hint: hint ?? 'Select $label',
      onChanged: onChanged,
      isLoading: isLoading,
      hasError: hasError,
      errorText: errorText,
      isRequired: isRequired,
      itemCount: items.length,
      isItemSelected: (index) => items[index].value == value,
      itemBuilder: (context, index, isSelected, onSelect) {
        final item = items[index];
        return SelectionListItem(
          item: SelectionItem(
            id: item.value.toString(),
            title: item.label,
            subtitle: item.subtitle,
            icon: item.icon,
          ),
          isSelected: isSelected,
          variant: SelectionItemVariant.minimal,
          onTap: () => onSelect(item.value),
        );
      },
    );
  }

  /// Helper method to get display text
  String? _getDisplayText() {
    if (value == null) return null;
    try {
      final selectedItem = items.firstWhere((item) => item.value == value);
      return selectedItem.label;
    } catch (e) {
      return null;
    }
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
