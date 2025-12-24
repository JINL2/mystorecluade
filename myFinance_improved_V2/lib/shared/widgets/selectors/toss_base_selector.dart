import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_selection_bottom_sheet.dart';

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
  /// Custom label style (if null, uses default TossTextStyles.label)
  final TextStyle? labelStyle;
  /// Whether to hide the built-in label (useful when providing custom label externally)
  final bool hideLabel;

  const SelectorConfig({
    required this.label,
    required this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = false,
    this.icon = Icons.arrow_drop_down,
    this.emptyMessage = 'No items available',
    this.searchHint = 'Search',
    this.labelStyle,
    this.hideLabel = false,
  });
}

/// Base single selector widget
///
/// Default: No icons in bottom sheet list (simple text only)
/// With icons: Set [showIcon] to true and provide [itemIconBuilder]
///
/// Example (simple - no icons):
/// ```dart
/// TossSingleSelector<Store>(
///   items: stores,
///   selectedItem: selectedStore,
///   onChanged: (id) => handleChange(id),
///   config: SelectorConfig(label: 'Store', hint: 'Select store'),
///   itemIdBuilder: (s) => s.id,
///   itemTitleBuilder: (s) => s.name,
///   itemSubtitleBuilder: (s) => '',
/// )
/// ```
///
/// Example (with icons):
/// ```dart
/// TossSingleSelector<Location>(
///   items: locations,
///   selectedItem: selectedLocation,
///   onChanged: (id) => handleChange(id),
///   config: SelectorConfig(label: 'Location', hint: 'Select location'),
///   itemIdBuilder: (l) => l.id,
///   itemTitleBuilder: (l) => l.name,
///   itemSubtitleBuilder: (l) => l.type,
///   showIcon: true,
///   itemIconBuilder: (l) => Icons.location_on,
/// )
/// ```
class TossSingleSelector<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final void Function(String?) onChanged;
  final bool isLoading;
  final SelectorConfig config;
  final String Function(T) itemTitleBuilder;
  final String Function(T) itemSubtitleBuilder;
  final String Function(T) itemIdBuilder;

  /// Whether to show icon in the bottom sheet list (default: false)
  final bool showIcon;

  /// Builder for item icon (only used when [showIcon] is true)
  final IconData Function(T)? itemIconBuilder;

  /// Builder for item avatar URL (only used when [showIcon] is true)
  final String? Function(T)? itemAvatarBuilder;

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
    this.showIcon = false,
    this.itemIconBuilder,
    this.itemAvatarBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (can be hidden if hideLabel is true)
        if (!config.hideLabel) ...[
          Text(
            config.label,
            style: config.labelStyle ?? TossTextStyles.label.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
        ],
        InkWell(
          onTap: () => _showSelector(context),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
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
                        ? itemTitleBuilder(selectedItem as T)
                        : config.hint,
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: selectedItem != null
                          ? TossColors.textPrimary
                          : TossColors.textTertiary,
                      fontWeight: selectedItem != null ? FontWeight.w600 : FontWeight.w400,
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
            icon: showIcon && itemIconBuilder != null ? itemIconBuilder!(item) : null,
            avatarUrl: showIcon && itemAvatarBuilder != null ? itemAvatarBuilder!(item) : null,
            isSelected: selectedItem != null &&
                itemIdBuilder(item) == itemIdBuilder(selectedItem as T),
          );
        }).toList(),
        selectedId: selectedItem != null ? itemIdBuilder(selectedItem as T) : null,
        onItemSelected: (item) {
          onChanged(item.id);
        },
        showSearch: config.showSearch,
        showIcon: showIcon,
      ),
    );
  }
}

/// Base multi selector widget
///
/// Default: No icons in bottom sheet list (simple text only)
/// With icons: Set [showIcon] to true and provide [itemIconBuilder]
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

  /// Whether to show icon in the bottom sheet list (default: false)
  final bool showIcon;

  /// Builder for item icon (only used when [showIcon] is true)
  final IconData Function(T)? itemIconBuilder;

  /// Builder for item avatar URL (only used when [showIcon] is true)
  final String? Function(T)? itemAvatarBuilder;

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
    this.showIcon = false,
    this.itemIconBuilder,
    this.itemAvatarBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (can be hidden if hideLabel is true)
        if (!config.hideLabel) ...[
          Text(
            config.label,
            style: config.labelStyle ?? TossTextStyles.label.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
        ],
        InkWell(
          onTap: () => _showSelector(context),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
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
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: tempSelectedIds.isNotEmpty
                          ? TossColors.textPrimary
                          : TossColors.textTertiary,
                      fontWeight: tempSelectedIds.isNotEmpty ? FontWeight.w600 : FontWeight.w400,
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
            icon: showIcon && itemIconBuilder != null ? itemIconBuilder!(item) : null,
            avatarUrl: showIcon && itemAvatarBuilder != null ? itemAvatarBuilder!(item) : null,
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
        showIcon: showIcon,
      ),
    );
  }
}
