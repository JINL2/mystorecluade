// =====================================================
// TOSS BASE SELECTOR WIDGET
// Reusable UI component for all autonomous selectors
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../../toss/toss_bottom_sheet.dart';
import '../../toss/toss_search_field.dart';
import '../../toss/toss_primary_button.dart';
import '../../toss/toss_secondary_button.dart';
import '../../../../data/models/selector_entities.dart';

// =====================================================
// MULTI SELECTOR WIDGET
// =====================================================
class TossMultiSelector<T> extends StatefulWidget {
  final List<T> items;
  final List<String> selectedIds;
  final List<String> tempSelectedIds;
  final ValueChanged<List<String>>? onTempSelectionChanged;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final SelectorConfig config;
  final String Function(T item) itemTitleBuilder;
  final String Function(T item)? itemSubtitleBuilder;
  final String Function(T item) itemIdBuilder;
  final bool Function(T item, String query)? itemFilterBuilder;
  final bool isLoading;

  const TossMultiSelector({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.tempSelectedIds,
    required this.onTempSelectionChanged,
    required this.onConfirm,
    required this.onCancel,
    required this.config,
    required this.itemTitleBuilder,
    required this.itemIdBuilder,
    this.itemSubtitleBuilder,
    this.itemFilterBuilder,
    this.isLoading = false,
  });

  @override
  State<TossMultiSelector<T>> createState() => _TossMultiSelectorState<T>();
}

class _TossMultiSelectorState<T> extends State<TossMultiSelector<T>> {
  List<T> _filteredItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(TossMultiSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _updateFilteredItems();
    }
  }

  void _updateFilteredItems() {
    if (_searchQuery.isEmpty) {
      _filteredItems = widget.items;
    } else {
      _filteredItems = widget.items.where((item) {
        if (widget.itemFilterBuilder != null) {
          return widget.itemFilterBuilder!(item, _searchQuery);
        }
        // Default filter by title
        return widget.itemTitleBuilder(item)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _updateFilteredItems();
    });
  }

  void _toggleSelection(String itemId) {
    final newSelection = List<String>.from(widget.tempSelectedIds);
    if (newSelection.contains(itemId)) {
      newSelection.remove(itemId);
    } else {
      newSelection.add(itemId);
    }
    widget.onTempSelectionChanged?.call(newSelection);
  }

  void _showMultiSelectionBottomSheet() {
    // Create a local copy of selected IDs for the modal
    List<String> modalSelectedIds = List<String>.from(widget.tempSelectedIds);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54, // Standard barrier color to prevent double barriers
      builder: (context) => TossBottomSheet(
        content: StatefulBuilder(
          builder: (context, setModalState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Select ${widget.config.label}',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: TossColors.gray700),
                    onPressed: () {
                      widget.onCancel?.call();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space3),
              
              // Search field
              if (widget.config.showSearch) ...[ 
                TossSearchField(
                  hintText: widget.config.searchHint ?? 'Search ${widget.config.label.toLowerCase()}',
                  onChanged: (value) {
                    setModalState(() {
                      _filterItems(value);
                    });
                  },
                ),
                const SizedBox(height: TossSpacing.space3),
              ],
              
              // Clear all option
              if (modalSelectedIds.isNotEmpty)
                InkWell(
                  onTap: () {
                    setModalState(() {
                      modalSelectedIds = [];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.clear_all,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                        SizedBox(width: TossSpacing.space3),
                        Text(
                          'Clear all selections',
                          style: TextStyle(color: TossColors.gray700),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Items list
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: widget.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(TossSpacing.space6),
                        child: CircularProgressIndicator(color: TossColors.primary),
                      ),
                    )
                  : _filteredItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(TossSpacing.space6),
                        child: Center(
                          child: Text(
                            _searchQuery.isEmpty
                              ? (widget.config.emptyMessage ?? 'No ${widget.config.label.toLowerCase()} available')
                              : 'No results found',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        separatorBuilder: (context, index) => Container(
                          height: 1,
                          color: TossColors.gray100,
                        ),
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final itemId = widget.itemIdBuilder(item);
                          final isSelected = modalSelectedIds.contains(itemId);
                          
                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                if (modalSelectedIds.contains(itemId)) {
                                  modalSelectedIds.remove(itemId);
                                } else {
                                  modalSelectedIds.add(itemId);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space4,
                                vertical: TossSpacing.space3,
                              ),
                              color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
                              child: Row(
                                children: [
                                  // Checkbox
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected ? TossColors.primary : TossColors.gray300,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      color: isSelected ? TossColors.primary : Colors.white,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: TossSpacing.space3),
                                  
                                  // Icon
                                  if (widget.config.icon != null) ...[ 
                                    Icon(
                                      widget.config.icon,
                                      size: 20,
                                      color: isSelected 
                                        ? TossColors.primary 
                                        : (widget.config.iconColor ?? TossColors.gray500),
                                    ),
                                    const SizedBox(width: TossSpacing.space3),
                                  ],
                                  
                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.itemTitleBuilder(item),
                                          style: TossTextStyles.body.copyWith(
                                            color: isSelected 
                                              ? TossColors.primary 
                                              : TossColors.gray900,
                                            fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        if (widget.itemSubtitleBuilder != null) ...[ 
                                          const SizedBox(height: 2),
                                          Text(
                                            widget.itemSubtitleBuilder!(item),
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
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
              
              const SizedBox(height: TossSpacing.space4),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TossSecondaryButton(
                      text: 'Cancel',
                      onPressed: () {
                        // Restore original selection
                        widget.onTempSelectionChanged?.call(widget.tempSelectedIds);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: TossPrimaryButton(
                      text: 'Confirm (${modalSelectedIds.length})',
                      onPressed: () {
                        // Apply the modal selection to the parent
                        widget.onTempSelectionChanged?.call(modalSelectedIds);
                        widget.onConfirm?.call();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.config.errorText != null && widget.config.errorText!.isNotEmpty;
    final selectedCount = widget.selectedIds.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.config.label,
          style: TossTextStyles.caption.copyWith(
            color: hasError ? TossColors.error : TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TossSpacing.space2),
        
        // Selector Field
        GestureDetector(
          onTap: widget.isLoading || widget.onTempSelectionChanged == null 
            ? null 
            : _showMultiSelectionBottomSheet,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              color: Colors.white,
              border: Border.all(
                color: hasError
                  ? TossColors.error
                  : selectedCount > 0 
                    ? TossColors.primary
                    : TossColors.gray200,
                width: 1,
              ),
              boxShadow: null, // Remove shadow for cleaner look
            ),
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
                  children: [
                    // Icon
                    if (widget.config.icon != null) ...[ 
                      Icon(
                        widget.config.icon,
                        size: 20,
                        color: selectedCount > 0
                          ? (widget.config.iconColor ?? TossColors.primary)
                          : TossColors.gray400,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                    ],
                    
                    // Selected count or hint
                    Expanded(
                      child: widget.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TossColors.primary,
                            ),
                          )
                        : Text(
                            selectedCount > 0
                              ? '$selectedCount ${widget.config.label.toLowerCase()} selected'
                              : (widget.config.hint ?? 'Select ${widget.config.label}'),
                            style: TossTextStyles.body.copyWith(
                              color: selectedCount > 0
                                ? TossColors.gray900
                                : TossColors.gray400,
                              fontWeight: selectedCount > 0 
                                ? FontWeight.w600 
                                : FontWeight.w400,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                    ),
                    
                    // Dropdown icon
                    Icon(
                      Icons.arrow_drop_down,
                      color: selectedCount > 0
                        ? TossColors.primary
                        : TossColors.gray400,
                    ),
                  ],
            ),
          ),
        ),
        
        // Error text
        if (hasError) ...[ 
          const SizedBox(height: TossSpacing.space2),
          Text(
            widget.config.errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ],
    );
  }
}

// =====================================================
// SELECTOR CONFIGURATION
// =====================================================
class SelectorConfig {
  final String label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final bool showClearOption;
  final IconData? icon;
  final Color? iconColor;
  final int? maxHeight;
  final String? emptyMessage;
  final String? searchHint;

  const SelectorConfig({
    required this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.showClearOption = true,
    this.icon,
    this.iconColor,
    this.maxHeight,
    this.emptyMessage,
    this.searchHint,
  });
}

// =====================================================
// SINGLE SELECTOR WIDGET
// =====================================================
class TossSingleSelector<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final SingleSelectionCallback? onChanged;
  final SelectorConfig config;
  final String Function(T item) itemTitleBuilder;
  final String Function(T item)? itemSubtitleBuilder;
  final String Function(T item) itemIdBuilder;
  final bool Function(T item, String query)? itemFilterBuilder;
  final bool isLoading;

  const TossSingleSelector({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.config,
    required this.itemTitleBuilder,
    required this.itemIdBuilder,
    this.itemSubtitleBuilder,
    this.itemFilterBuilder,
    this.isLoading = false,
  });

  @override
  State<TossSingleSelector<T>> createState() => _TossSingleSelectorState<T>();
}

class _TossSingleSelectorState<T> extends State<TossSingleSelector<T>> {
  List<T> _filteredItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(TossSingleSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _updateFilteredItems();
    }
  }

  void _updateFilteredItems() {
    if (_searchQuery.isEmpty) {
      _filteredItems = widget.items;
    } else {
      _filteredItems = widget.items.where((item) {
        if (widget.itemFilterBuilder != null) {
          return widget.itemFilterBuilder!(item, _searchQuery);
        }
        // Default filter by title
        return widget.itemTitleBuilder(item)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _updateFilteredItems();
    });
  }

  void _showSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54, // Standard barrier color to prevent double barriers
      builder: (context) => TossBottomSheet(
        content: StatefulBuilder(
          builder: (context, setModalState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Select ${widget.config.label}',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: TossColors.gray700),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space3),
              
              // Search field
              if (widget.config.showSearch) ...[
                TossSearchField(
                  hintText: widget.config.searchHint ?? 'Search ${widget.config.label.toLowerCase()}',
                  onChanged: (value) {
                    setModalState(() {
                      _filterItems(value);
                    });
                  },
                ),
                const SizedBox(height: TossSpacing.space3),
              ],
              
              // Clear selection option
              if (widget.config.showClearOption && widget.selectedItem != null)
                _buildClearOption(context),
              
              // Items list
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: (widget.config.maxHeight ?? MediaQuery.of(context).size.height * 0.5).toDouble(),
                ),
                child: widget.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(TossSpacing.space6),
                        child: CircularProgressIndicator(color: TossColors.primary),
                      ),
                    )
                  : _filteredItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(TossSpacing.space6),
                        child: Center(
                          child: Text(
                            _searchQuery.isEmpty
                              ? (widget.config.emptyMessage ?? 'No ${widget.config.label.toLowerCase()} available')
                              : 'No results found',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        separatorBuilder: (context, index) => Container(
                          height: 1,
                          color: TossColors.gray100,
                        ),
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final itemId = widget.itemIdBuilder(item);
                          final selectedId = widget.selectedItem != null 
                            ? widget.itemIdBuilder(widget.selectedItem!)
                            : null;
                          final isSelected = itemId == selectedId;
                          
                          return InkWell(
                            onTap: () {
                              widget.onChanged?.call(itemId);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space4,
                                vertical: TossSpacing.space3,
                              ),
                              color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
                              child: Row(
                                children: [
                                  // Icon
                                  if (widget.config.icon != null) ...[
                                    Icon(
                                      widget.config.icon,
                                      size: 20,
                                      color: isSelected 
                                        ? TossColors.primary 
                                        : (widget.config.iconColor ?? TossColors.gray500),
                                    ),
                                    const SizedBox(width: TossSpacing.space3),
                                  ],
                                  
                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.itemTitleBuilder(item),
                                          style: TossTextStyles.body.copyWith(
                                            color: isSelected 
                                              ? TossColors.primary 
                                              : TossColors.gray900,
                                            fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        if (widget.itemSubtitleBuilder != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            widget.itemSubtitleBuilder!(item),
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  
                                  // Check mark for selected
                                  if (isSelected)
                                    const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: TossColors.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearOption(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged?.call(null);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.clear,
              size: 20,
              color: TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space3),
            Text(
              'Clear selection',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.config.errorText != null && widget.config.errorText!.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.config.label,
          style: TossTextStyles.caption.copyWith(
            color: hasError ? TossColors.error : TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TossSpacing.space2),
        
        // Selector Field
        GestureDetector(
          onTap: widget.isLoading || widget.onChanged == null 
            ? null 
            : _showSelectionBottomSheet,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              color: Colors.white,
              border: Border.all(
                color: hasError
                  ? TossColors.error
                  : widget.selectedItem != null 
                    ? TossColors.primary
                    : TossColors.gray200,
                width: 1,
              ),
              boxShadow: null, // Remove shadow for cleaner look
            ),
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
                  children: [
                    // Icon
                    if (widget.config.icon != null) ...[
                      Icon(
                        widget.config.icon,
                        size: 20,
                        color: widget.selectedItem != null
                          ? (widget.config.iconColor ?? TossColors.primary)
                          : TossColors.gray400,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                    ],
                    
                    // Selected value or hint
                    Expanded(
                      child: widget.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TossColors.primary,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.selectedItem != null
                                  ? widget.itemTitleBuilder(widget.selectedItem!)
                                  : (widget.config.hint ?? 'Select ${widget.config.label}'),
                                style: TossTextStyles.body.copyWith(
                                  color: widget.selectedItem != null
                                    ? TossColors.gray900
                                    : TossColors.gray400,
                                  fontWeight: widget.selectedItem != null 
                                    ? FontWeight.w600 
                                    : FontWeight.w400,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (widget.selectedItem != null && widget.itemSubtitleBuilder != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  widget.itemSubtitleBuilder!(widget.selectedItem!),
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ],
                          ),
                    ),
                    
                    // Dropdown icon
                    Icon(
                      Icons.arrow_drop_down,
                      color: widget.selectedItem != null
                        ? TossColors.primary
                        : TossColors.gray400,
                    ),
                  ],
            ),
          ),
        ),
        
        // Error text
        if (hasError) ...[
          const SizedBox(height: TossSpacing.space2),
          Text(
            widget.config.errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ],
    );
  }
}