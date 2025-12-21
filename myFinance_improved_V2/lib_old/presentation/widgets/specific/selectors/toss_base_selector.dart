import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../toss/toss_selection_bottom_sheet.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
/// Configuration for selector widgets
class SelectorConfig {
  final String label;
  final String hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final IconData icon;
  final String emptyMessage;
  final String searchHint;

  const SelectorConfig({
    required this.label,
    required this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = false,
    this.icon = Icons.arrow_drop_down,
    this.emptyMessage = 'No items available',
    this.searchHint = 'Search',
  });
}

/// Base single selector widget
class TossSingleSelector<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final void Function(String?) onChanged;
  final bool isLoading;
  final SelectorConfig config;
  final String Function(T) itemTitleBuilder;
  final String Function(T) itemSubtitleBuilder;
  final String Function(T) itemIdBuilder;

  const TossSingleSelector({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.isLoading = false,
    required this.config,
    required this.itemTitleBuilder,
    required this.itemSubtitleBuilder,
    required this.itemIdBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.label,
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () => _showSelector(context),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space3,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: config.errorText != null
                    ? TossColors.error
                    : TossColors.gray200,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedItem != null
                        ? itemTitleBuilder(selectedItem!)
                        : config.hint,
                    style: TossTextStyles.body.copyWith(
                      color: selectedItem != null
                          ? TossColors.textPrimary
                          : TossColors.textTertiary,
                      fontWeight: selectedItem != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  config.icon,
                  color: TossColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        if (config.errorText != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            config.errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  void _showSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => TossSelectionBottomSheet(
        title: config.label,
        items: items.map((item) {
          return TossSelectionItem(
            id: itemIdBuilder(item),
            title: itemTitleBuilder(item),
            subtitle: itemSubtitleBuilder(item),
            isSelected: selectedItem != null && 
                itemIdBuilder(item) == itemIdBuilder(selectedItem!),
          );
        }).toList(),
        onItemSelected: (item) {
          onChanged(item.id);
        },
        showSearch: config.showSearch,
      ),
    );
  }
}

/// Base multi selector widget
class TossMultiSelector<T> extends StatelessWidget {
  final List<T> items;
  final List<String>? selectedIds;
  final List<String> tempSelectedIds;
  final void Function(List<String>) onTempSelectionChanged;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;
  final SelectorConfig config;
  final String Function(T) itemTitleBuilder;
  final String Function(T) itemSubtitleBuilder;
  final String Function(T) itemIdBuilder;

  const TossMultiSelector({
    super.key,
    required this.items,
    this.selectedIds,
    required this.tempSelectedIds,
    required this.onTempSelectionChanged,
    required this.onConfirm,
    required this.onCancel,
    this.isLoading = false,
    required this.config,
    required this.itemTitleBuilder,
    required this.itemSubtitleBuilder,
    required this.itemIdBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.label,
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () => _showSelector(context),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space3,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: config.errorText != null
                    ? TossColors.error
                    : TossColors.gray200,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    tempSelectedIds.isNotEmpty
                        ? '${tempSelectedIds.length} selected'
                        : config.hint,
                    style: TossTextStyles.body.copyWith(
                      color: tempSelectedIds.isNotEmpty
                          ? TossColors.textPrimary
                          : TossColors.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  config.icon,
                  color: TossColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        if (config.errorText != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            config.errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  void _showSelector(BuildContext context) {
    // For multi-select, we'd need a different bottom sheet implementation
    // This is a simplified version
    final currentSelectedIds = Set<String>.from(tempSelectedIds);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => TossSelectionBottomSheet(
        title: config.label,
        items: items.map((item) {
          return TossSelectionItem(
            id: itemIdBuilder(item),
            title: itemTitleBuilder(item),
            subtitle: itemSubtitleBuilder(item),
            isSelected: currentSelectedIds.contains(itemIdBuilder(item)),
          );
        }).toList(),
        onItemSelected: (item) {
          // Toggle selection
          final newSelection = List<String>.from(currentSelectedIds);
          if (newSelection.contains(item.id)) {
            newSelection.remove(item.id);
          } else {
            newSelection.add(item.id);
          }
          onTempSelectionChanged(newSelection);
        },
        showSearch: config.showSearch,
      ),
    );
  }
}