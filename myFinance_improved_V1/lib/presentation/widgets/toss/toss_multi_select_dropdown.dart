import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import 'toss_bottom_sheet.dart';
import 'toss_primary_button.dart';
import 'toss_secondary_button.dart';

class TossMultiSelectItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;

  const TossMultiSelectItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
  });
}

class TossMultiSelectDropdown<T> extends StatefulWidget {
  final String label;
  final List<T>? selectedValues;
  final String hint;
  final List<TossMultiSelectItem<T>> items;
  final void Function(List<T>?) onChanged;
  final bool enabled;
  final String? errorText;
  final bool searchable;
  final int maxSelections;

  const TossMultiSelectDropdown({
    super.key,
    required this.label,
    this.selectedValues,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.errorText,
    this.searchable = true,
    this.maxSelections = 0, // 0 means unlimited
  });

  @override
  State<TossMultiSelectDropdown<T>> createState() => _TossMultiSelectDropdownState<T>();
}

class _TossMultiSelectDropdownState<T> extends State<TossMultiSelectDropdown<T>> {
  late List<T> _tempSelectedValues;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSelectionSheet() {
    _tempSelectedValues = List<T>.from(widget.selectedValues ?? []);
    _searchQuery = '';
    _searchController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final filteredItems = widget.searchable && _searchQuery.isNotEmpty
              ? widget.items.where((item) =>
                  item.label.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  (item.subtitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
                  .toList()
              : widget.items;

          return TossBottomSheet(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select ${widget.label}',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_tempSelectedValues.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Text(
                          '${_tempSelectedValues.length} selected',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Search bar if enabled
                if (widget.searchable) ...[
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setSheetState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search ${widget.label.toLowerCase()}...',
                      hintStyle: TossTextStyles.body.copyWith(
                        color: TossColors.gray400,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: TossColors.gray400,
                      ),
                      filled: true,
                      fillColor: TossColors.gray50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space3,
                      ),
                    ),
                  ),
                  SizedBox(height: TossSpacing.space4),
                ],
                
                // Options list
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) => Divider(
                      color: TossColors.gray100,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = _tempSelectedValues.contains(item.value);
                      final canSelect = widget.maxSelections == 0 ||
                          _tempSelectedValues.length < widget.maxSelections ||
                          isSelected;

                      return InkWell(
                        onTap: canSelect
                            ? () {
                                setSheetState(() {
                                  if (isSelected) {
                                    _tempSelectedValues.remove(item.value);
                                  } else {
                                    _tempSelectedValues.add(item.value);
                                  }
                                });
                              }
                            : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space3,
                            vertical: TossSpacing.space3,
                          ),
                          child: Row(
                            children: [
                              // Checkbox
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? TossColors.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? TossColors.primary
                                        : canSelect
                                            ? TossColors.gray300
                                            : TossColors.gray200,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              
                              SizedBox(width: TossSpacing.space3),
                              
                              // Leading icon if provided
                              if (item.leading != null) ...[
                                item.leading!,
                                SizedBox(width: TossSpacing.space3),
                              ],
                              
                              // Label and subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.label,
                                      style: TossTextStyles.body.copyWith(
                                        color: canSelect
                                            ? TossColors.gray900
                                            : TossColors.gray400,
                                      ),
                                    ),
                                    if (item.subtitle != null)
                                      Text(
                                        item.subtitle!,
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TossSecondaryButton(
                        text: 'Clear',
                        onPressed: () {
                          setSheetState(() {
                            _tempSelectedValues.clear();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: TossPrimaryButton(
                        text: 'Apply',
                        onPressed: () {
                          widget.onChanged(
                            _tempSelectedValues.isEmpty ? null : _tempSelectedValues,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: TossSpacing.space4),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getDisplayText() {
    if (widget.selectedValues == null || widget.selectedValues!.isEmpty) {
      return widget.hint;
    }

    final selectedItems = widget.items
        .where((item) => widget.selectedValues!.contains(item.value))
        .toList();

    if (selectedItems.length == 1) {
      return selectedItems.first.label;
    } else {
      return '${selectedItems.length} items selected';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final isSelected = widget.selectedValues != null && widget.selectedValues!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: TossTextStyles.caption.copyWith(
            color: hasError ? TossColors.error : TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: TossSpacing.space2),
        
        // Dropdown field
        InkWell(
          onTap: widget.enabled ? _showSelectionSheet : null,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: widget.enabled ? Colors.white : TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: hasError
                    ? TossColors.error
                    : isSelected
                        ? TossColors.primary
                        : TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getDisplayText(),
                    style: TossTextStyles.body.copyWith(
                      color: isSelected
                          ? TossColors.gray900
                          : widget.enabled
                              ? TossColors.gray400
                              : TossColors.gray300,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.enabled ? TossColors.gray600 : TossColors.gray300,
                ),
              ],
            ),
          ),
        ),
        
        // Error text
        if (hasError) ...[
          SizedBox(height: TossSpacing.space1),
          Text(
            widget.errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }
}