import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import '../../../core/constants/icon_mapper.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// A generic selection item model for the bottom sheet
class TossSelectionItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Map<String, dynamic>? data;
  final bool isSelected;

  const TossSelectionItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.data,
    this.isSelected = false,
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
class TossSelectionBottomSheet extends StatefulWidget {
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
  
  @override
  State<TossSelectionBottomSheet> createState() => _TossSelectionBottomSheetState();
  
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
}

class _TossSelectionBottomSheetState extends State<TossSelectionBottomSheet> {
  late List<TossSelectionItem> filteredItems;
  String searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }
  
  void _filterItems(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items.where((item) {
          final titleLower = item.title.toLowerCase();
          final subtitleLower = (item.subtitle ?? '').toLowerCase();
          return titleLower.contains(searchQuery) || subtitleLower.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate available height for the bottom sheet
    final screenHeight = MediaQuery.of(context).size.height;
    final maxSheetHeight = screenHeight * widget.maxHeightFraction;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxSheetHeight,
      ),
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
              widget.title,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Search bar (if enabled)
          if (widget.showSearch) ...[
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
                onChanged: _filterItems,
              ),
            ),
          ],
          
          // Items list - wrapped in Flexible to prevent overflow
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final isSelected = widget.selectedId == item.id;
                final isLast = index == filteredItems.length - 1;
                
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
    final itemIcon = widget.defaultIcon ?? item.icon ?? IconMapper.getIcon('circle');
    
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        widget.onItemSelected?.call(item);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : TossColors.transparent,
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
                  ? TossColors.primary.withValues(alpha: 0.1) 
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
                  if (widget.showSubtitle && item.subtitle != null) ...[
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

/// Specialized account selector bottom sheet for journal input
class TossAccountSelector {
  /// Show account selection bottom sheet
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> accounts,
    String? selectedAccountId,
    String title = 'Select Account',
  }) async {
    final items = accounts
        .map((account) => TossSelectionItem.fromGeneric(
          id: account['account_id'] ?? '',
          title: account['account_name'] ?? 'Unnamed Account',
          subtitle: account['category_tag'] != null ? 
            '${_getAccountTypeFromCategory(account['category_tag'])} • ${account['category_tag']}' : null,
          icon: IconMapper.getIcon('wallet'),
          data: account,
        ))
        .toList();

    Map<String, dynamic>? selectedAccount;

    await TossSelectionBottomSheet.show(
      context: context,
      title: title,
      items: items,
      selectedId: selectedAccountId,
      showSearch: true,
      maxHeightFraction: 0.7,  // Reduced to 70% to prevent overflow
      onItemSelected: (item) {
        selectedAccount = item.data;
      },
    );

    return selectedAccount;
  }
  
  /// Helper function to determine account type from category tag
  static String _getAccountTypeFromCategory(String? categoryTag) {
    if (categoryTag == null) return 'Asset';
    switch (categoryTag.toLowerCase()) {
      case 'cash':
      case 'receivable':
      case 'fixedasset':
        return 'Asset';
      case 'payable':
      case 'note':
        return 'Liability';
      case 'equity':
      case 'retained':
        return 'Equity';
      case 'revenue':
        return 'Income';
      default:
        return 'Expense';
    }
  }
}