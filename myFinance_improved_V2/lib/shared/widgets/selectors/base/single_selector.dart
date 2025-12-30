/// Single Selector Widget
///
/// Generic single-item selector widget using bottom sheet UI.
/// This is the base widget for building domain-specific selectors.
///
/// ## Usage Example
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
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_selection_bottom_sheet.dart';

import 'selector_config.dart';

/// Base single selector widget
///
/// Default: No icons in bottom sheet list (simple text only)
/// With icons: Set [showIcon] to true and provide [itemIconBuilder]
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
