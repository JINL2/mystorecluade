import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/models/index.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/sheet_header.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/search_field.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/bottom_sheet_wrapper.dart';

/// Configuration for ModalBottomSheet appearance
class ModalSheetConfig {
  final double maxHeightFraction;
  final bool showSearch;
  final bool showDividers;
  final bool enableHaptic;
  final SelectionItemVariant itemVariant;
  final IconData? defaultIcon;
  final String searchHint;

  const ModalSheetConfig({
    this.maxHeightFraction = 0.5,
    this.showSearch = false,
    this.showDividers = false,
    this.enableHaptic = false,
    this.itemVariant = SelectionItemVariant.standard,
    this.defaultIcon,
    this.searchHint = 'Search...',
  });

  /// Preset for minimal selection (e.g., Cash Location)
  static const minimal = ModalSheetConfig(
    itemVariant: SelectionItemVariant.minimal,
    maxHeightFraction: 0.4,
  );

  /// Preset for standard selection with icons
  static const standard = ModalSheetConfig(
    itemVariant: SelectionItemVariant.standard,
  );

  /// Preset for searchable lists
  static const searchable = ModalSheetConfig(
    showSearch: true,
    maxHeightFraction: 0.7,
  );

  /// Preset for avatar/user selection
  static const avatar = ModalSheetConfig(
    itemVariant: SelectionItemVariant.avatar,
    maxHeightFraction: 0.6,
  );
}

/// A reusable modal bottom sheet for selecting items
///
/// Can be used anywhere in the app to show a selection list.
///
/// Example usage:
/// ```dart
/// final result = await ModalBottomSheet.show(
///   context: context,
///   title: 'Select Option',
///   items: myItems,
///   selectedId: currentId,
///   config: ModalSheetConfig.minimal,
/// );
/// ```
class ModalBottomSheet extends StatefulWidget {
  final String title;
  final List<SelectionItem> items;
  final String? selectedId;
  final ValueChanged<SelectionItem>? onSelected;
  final ModalSheetConfig config;

  const ModalBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedId,
    this.onSelected,
    this.config = const ModalSheetConfig(),
  });

  /// Show the bottom sheet and return selected item
  static Future<SelectionItem?> show({
    required BuildContext context,
    required String title,
    required List<SelectionItem> items,
    String? selectedId,
    ValueChanged<SelectionItem>? onSelected,
    ModalSheetConfig config = const ModalSheetConfig(),
  }) {
    return BottomSheetWrapper.show<SelectionItem>(
      context: context,
      maxHeightRatio: config.maxHeightFraction,
      child: ModalBottomSheet(
        title: title,
        items: items,
        selectedId: selectedId,
        onSelected: onSelected,
        config: config,
      ),
    );
  }

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  late List<SelectionItem> _filteredItems;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredItems = widget.items.where((item) {
          return item.title.toLowerCase().contains(lowerQuery) ||
              (item.subtitle?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      }
    });
  }

  void _handleSelection(SelectionItem item) {
    widget.onSelected?.call(item);
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight =
        MediaQuery.of(context).size.height * widget.config.maxHeightFraction;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          SheetHeader(title: widget.title),

          // Search (if enabled)
          if (widget.config.showSearch)
            SheetSearchField(
              controller: _searchController,
              onChanged: _filterItems,
              hintText: widget.config.searchHint,
            ),

          // List
          Flexible(
            child: _filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredItems.length,
                    itemBuilder: (_, index) {
                      final item = _filteredItems[index];
                      final isLast = index == _filteredItems.length - 1;

                      return SelectionListItem(
                        item: item,
                        isSelected: item.id == widget.selectedId,
                        variant: widget.config.itemVariant,
                        enableHaptic: widget.config.enableHaptic,
                        showDivider: widget.config.showDividers && !isLast,
                        defaultIcon: widget.config.defaultIcon,
                        onTap: () => _handleSelection(item),
                      );
                    },
                  ),
          ),

          // Bottom safe area padding
          SizedBox(height: bottomPadding + 16),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.searchX, size: 48, color: TossColors.gray300),
          const SizedBox(height: 12),
          Text(
            'No results found',
            style: TextStyle(color: TossColors.gray500),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY ALIASES
// ═══════════════════════════════════════════════════════════════

/// @deprecated Use [ModalSheetConfig] instead
typedef SelectionSheetConfig = ModalSheetConfig;

/// @deprecated Use [ModalBottomSheet] instead
typedef SelectionBottomSheet = ModalBottomSheet;
