import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/constants/icon_mapper.dart';

/// A generic selection item model for the bottom sheet
class TossSelectionItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Map<String, dynamic>? data;

  const TossSelectionItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.data,
  });

  /// Factory constructor for store items
  factory TossSelectionItem.fromStore(Map<String, dynamic> store) {
    return TossSelectionItem(
      id: store['store_id'] ?? '',
      title: store['store_name'] ?? 'Unnamed Store',
      subtitle: store['store_code'] != null ? 'Code: ${store['store_code']}' : null,
      icon: IconMapper.getIcon('building'),
      data: store,
    );
  }

  /// Factory constructor for company items
  factory TossSelectionItem.fromCompany(Map<String, dynamic> company) {
    return TossSelectionItem(
      id: company['company_id'] ?? '',
      title: company['company_name'] ?? 'Unnamed Company',
      subtitle: company['company_code'] != null ? 'Code: ${company['company_code']}' : null,
      icon: IconMapper.getIcon('building'),
      data: company,
    );
  }

  /// Factory constructor for generic items
  factory TossSelectionItem.fromGeneric({
    required String id,
    required String title,
    String? subtitle,
    IconData? icon,
    Map<String, dynamic>? data,
  }) {
    return TossSelectionItem(
      id: id,
      title: title,
      subtitle: subtitle,
      icon: icon,
      data: data,
    );
  }
}

/// A reusable bottom sheet for selecting items following Toss design system
/// 
/// Example usage:
/// ```dart
/// TossSelectionBottomSheet.show(
///   context: context,
///   title: 'Select Store',
///   items: stores.map((store) => TossSelectionItem.fromStore(store)).toList(),
///   selectedId: currentStoreId,
///   onItemSelected: (item) {
///     print('Selected: ${item.title}');
///   },
/// )
/// ```
class TossSelectionBottomSheet extends StatelessWidget {
  /// Title displayed at the top of the bottom sheet
  final String title;
  
  /// List of items to display for selection
  final List<TossSelectionItem> items;
  
  /// Currently selected item ID
  final String? selectedId;
  
  /// Callback when an item is selected
  final ValueChanged<TossSelectionItem>? onItemSelected;
  
  /// Maximum height as a fraction of screen height (0.0 - 1.0)
  final double maxHeightFraction;
  
  /// Whether to show a search bar
  final bool showSearch;
  
  /// Custom icon for items (overrides individual item icons)
  final IconData? defaultIcon;
  
  /// Whether to show subtitle text
  final bool showSubtitle;

  const TossSelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedId,
    this.onItemSelected,
    this.maxHeightFraction = 0.5,
    this.showSearch = false,
    this.defaultIcon,
    this.showSubtitle = true,
  });

  /// Static method to show the bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<TossSelectionItem> items,
    String? selectedId,
    ValueChanged<TossSelectionItem>? onItemSelected,
    double maxHeightFraction = 0.5,
    bool showSearch = false,
    IconData? defaultIcon,
    bool showSubtitle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => TossSelectionBottomSheet(
        title: title,
        items: items,
        selectedId: selectedId,
        onItemSelected: onItemSelected,
        maxHeightFraction: maxHeightFraction,
        showSearch: showSearch,
        defaultIcon: defaultIcon,
        showSubtitle: showSubtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: TossSpacing.iconXL,
            height: TossSpacing.space1,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Text(
              title,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Search bar (if enabled)
          if (showSearch) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space5,
                vertical: TossSpacing.space2,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: TossSpacing.iconSM,
                    color: TossColors.gray500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: BorderSide(color: TossColors.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: BorderSide(color: TossColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: BorderSide(color: TossColors.primary),
                  ),
                ),
                onChanged: (value) {
                  // TODO: Implement search functionality
                },
              ),
            ),
          ],
          
          // Items list
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * maxHeightFraction,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedId == item.id;
                final isLast = index == items.length - 1;
                
                return _buildSelectionItem(
                  context: context,
                  item: item,
                  isSelected: isSelected,
                  isLast: isLast,
                );
              },
            ),
          ),
          
          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildSelectionItem({
    required BuildContext context,
    required TossSelectionItem item,
    required bool isSelected,
    required bool isLast,
  }) {
    final itemIcon = defaultIcon ?? item.icon ?? IconMapper.getIcon('circle');
    
    return InkWell(
      onTap: () {
        onItemSelected?.call(item);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withOpacity(0.05) : TossColors.transparent,
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: isLast ? 0 : 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: TossSpacing.iconXL,
              height: TossSpacing.iconXL,
              decoration: BoxDecoration(
                color: isSelected 
                  ? TossColors.primary.withOpacity(0.1) 
                  : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                itemIcon,
                size: TossSpacing.iconSM,
                color: isSelected ? TossColors.primary : TossColors.gray600,
              ),
            ),
            
            const SizedBox(width: TossSpacing.space3),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  
                  // Subtitle (if enabled and available)
                  if (showSubtitle && item.subtitle != null) ...[
                    const SizedBox(height: TossSpacing.space1/2),
                    Text(
                      item.subtitle!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Selected indicator
            if (isSelected)
              Icon(
                FontAwesomeIcons.circleCheck,
                color: TossColors.primary,
                size: TossSpacing.iconMD,
              ),
          ],
        ),
      ),
    );
  }
}

/// Specialized store selector bottom sheet
class TossStoreSelector {
  /// Show store selection bottom sheet
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> stores,
    String? selectedStoreId,
    String title = 'Select Store',
  }) async {
    final items = stores
        .map((store) => TossSelectionItem.fromStore(store))
        .toList();

    Map<String, dynamic>? selectedStore;

    await TossSelectionBottomSheet.show(
      context: context,
      title: title,
      items: items,
      selectedId: selectedStoreId,
      onItemSelected: (item) {
        selectedStore = item.data;
      },
    );

    return selectedStore;
  }
}

/// Specialized company selector bottom sheet
class TossCompanySelector {
  /// Show company selection bottom sheet
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> companies,
    String? selectedCompanyId,
    String title = 'Select Company',
  }) async {
    final items = companies
        .map((company) => TossSelectionItem.fromCompany(company))
        .toList();

    Map<String, dynamic>? selectedCompany;

    await TossSelectionBottomSheet.show(
      context: context,
      title: title,
      items: items,
      selectedId: selectedCompanyId,
      onItemSelected: (item) {
        selectedCompany = item.data;
      },
    );

    return selectedCompany;
  }
}