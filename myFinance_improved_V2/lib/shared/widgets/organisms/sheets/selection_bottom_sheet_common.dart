import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/bottom_sheet_wrapper.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/sheet_header.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/search_field.dart';

/// A common bottom sheet organism for selection lists.
///
/// Composes:
/// - [BottomSheetWrapper] - Surface + Scrim + Animations
/// - [SheetHeader] - DragHandle + Title
/// - [SheetSearchField] - Optional search field
/// - Flexible content slot for list items
///
/// ## 2026 UI/UX Design Principles:
/// - **Composable**: Accepts any widgets as children
/// - **Content-first**: Minimal chrome, focus on the list
/// - **Flexible**: Builder pattern for dynamic lists
/// - **Accessible**: Proper semantics and touch targets
///
/// ## Example Usage:
///
/// ### Simple with children:
/// ```dart
/// SelectionBottomSheetCommon.show(
///   context: context,
///   title: 'Select Location',
///   children: [
///     ListTile(title: Text('Location 1'), onTap: () {}),
///     ListTile(title: Text('Location 2'), onTap: () {}),
///   ],
/// );
/// ```
///
/// ### With builder for dynamic lists:
/// ```dart
/// SelectionBottomSheetCommon.show(
///   context: context,
///   title: 'Select Account',
///   showSearch: true,
///   itemCount: accounts.length,
///   itemBuilder: (context, index) => AccountListTile(
///     account: accounts[index],
///     onTap: () => Navigator.pop(context, accounts[index]),
///   ),
/// );
/// ```
class SelectionBottomSheetCommon extends StatelessWidget {
  /// Title displayed in the header
  final String title;

  /// Whether to show close button in header
  final bool showCloseButton;

  /// Callback when close button is pressed
  final VoidCallback? onClose;

  /// Whether to show search field
  final bool showSearch;

  /// Hint text for search field
  final String searchHint;

  /// Callback when search text changes
  final ValueChanged<String>? onSearchChanged;

  /// Controller for search field
  final TextEditingController? searchController;

  /// Static list of children widgets
  /// Use this for simple, static lists
  final List<Widget>? children;

  /// Builder for dynamic lists
  /// Use this when you have many items or need lazy loading
  final Widget Function(BuildContext, int)? itemBuilder;

  /// Number of items (required when using itemBuilder)
  final int? itemCount;

  /// Maximum height as ratio of screen (0.0 to 1.0)
  final double maxHeightRatio;

  /// Whether the list should be separated by dividers
  final bool showDividers;

  /// Custom padding for the list area
  final EdgeInsets? listPadding;

  /// Spacing between list items (default: 8px)
  /// Set to 0 to let items control their own spacing
  final double itemSpacing;

  const SelectionBottomSheetCommon({
    super.key,
    required this.title,
    this.showCloseButton = false,
    this.onClose,
    this.showSearch = false,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.searchController,
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.maxHeightRatio = 0.7,
    this.showDividers = false,
    this.listPadding,
    this.itemSpacing = TossSpacing.space2, // 8px default
  }) : assert(
          children != null || (itemBuilder != null && itemCount != null),
          'Either children or both itemBuilder and itemCount must be provided',
        );

  /// Show the selection bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    bool showCloseButton = false,
    VoidCallback? onClose,
    bool showSearch = false,
    String searchHint = 'Search...',
    ValueChanged<String>? onSearchChanged,
    TextEditingController? searchController,
    List<Widget>? children,
    Widget Function(BuildContext, int)? itemBuilder,
    int? itemCount,
    double maxHeightRatio = 0.7,
    bool showDividers = false,
    EdgeInsets? listPadding,
    double itemSpacing = TossSpacing.space2,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return BottomSheetWrapper.show<T>(
      context: context,
      maxHeightRatio: maxHeightRatio,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      child: SelectionBottomSheetCommon(
        title: title,
        showCloseButton: showCloseButton,
        onClose: onClose,
        showSearch: showSearch,
        searchHint: searchHint,
        onSearchChanged: onSearchChanged,
        searchController: searchController,
        children: children,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        maxHeightRatio: maxHeightRatio,
        showDividers: showDividers,
        listPadding: listPadding,
        itemSpacing: itemSpacing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with drag handle and title
        SheetHeader(
          title: title,
          showCloseButton: showCloseButton,
          onClose: onClose,
        ),

        // Search field (optional)
        if (showSearch)
          SheetSearchField(
            controller: searchController,
            hintText: searchHint,
            onChanged: onSearchChanged,
          ),

        // List content
        Flexible(
          child: _buildListContent(context),
        ),
      ],
    );
  }

  Widget _buildListContent(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final effectivePadding = listPadding ??
        EdgeInsets.only(
          bottom: bottomPadding + TossSpacing.space4,
        );

    // Use children if provided
    if (children != null) {
      return ListView(
        shrinkWrap: true,
        padding: effectivePadding,
        children: _buildChildrenWithSpacing(children!),
      );
    }

    // Use builder pattern with separated for consistent spacing
    return ListView.separated(
      shrinkWrap: true,
      padding: effectivePadding,
      itemCount: itemCount!,
      separatorBuilder: (context, index) {
        if (showDividers) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: itemSpacing / 2),
              const Divider(height: 1, color: TossColors.gray100),
              SizedBox(height: itemSpacing / 2),
            ],
          );
        }
        return SizedBox(height: itemSpacing);
      },
      itemBuilder: (context, index) => itemBuilder!(context, index),
    );
  }

  List<Widget> _buildChildrenWithSpacing(List<Widget> items) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        if (showDividers) {
          result.add(SizedBox(height: itemSpacing / 2));
          result.add(const Divider(height: 1, color: TossColors.gray100));
          result.add(SizedBox(height: itemSpacing / 2));
        } else {
          result.add(SizedBox(height: itemSpacing));
        }
      }
    }
    return result;
  }
}
