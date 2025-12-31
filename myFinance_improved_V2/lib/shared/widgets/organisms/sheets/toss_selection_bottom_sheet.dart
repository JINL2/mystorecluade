import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'package:myfinance_improved/core/constants/icon_mapper.dart';

/// A generic selection item model for the bottom sheet
class TossSelectionItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? avatarUrl; // Avatar image URL
  final Map<String, dynamic>? data;
  final bool isSelected;
  final Widget? trailing; // Optional trailing widget (e.g., chip, badge)

  const TossSelectionItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.avatarUrl,
    this.data,
    this.isSelected = false,
    this.trailing,
  });

  /// Factory constructor for store items
  factory TossSelectionItem.fromStore(Map<String, dynamic> store) {
    return TossSelectionItem(
      id: store['store_id']?.toString() ?? '',
      title: store['store_name']?.toString() ?? 'Unnamed Store',
      subtitle: store['store_code']?.toString(),
      icon: IconMapper.getIcon('building'),
      data: store,
    );
  }

  /// Factory constructor for company items
  factory TossSelectionItem.fromCompany(Map<String, dynamic> company) {
    return TossSelectionItem(
      id: company['company_id']?.toString() ?? '',
      title: company['company_name']?.toString() ?? 'Unnamed Company',
      subtitle: company['company_code']?.toString(),
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
    String? avatarUrl,
    Map<String, dynamic>? data,
    Widget? trailing,
  }) {
    return TossSelectionItem(
      id: id,
      title: title,
      subtitle: subtitle,
      icon: icon,
      avatarUrl: avatarUrl,
      data: data,
      trailing: trailing,
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

  /// 🆕 Font weight for selected items (default: w600, cash_ending: w700)
  final FontWeight selectedFontWeight;

  /// 🆕 Font weight for unselected items (default: w400, cash_ending: w500)
  final FontWeight unselectedFontWeight;

  /// 🆕 Icon color for unselected items (default: gray600, cash_ending: gray500)
  final Color unselectedIconColor;

  /// 🆕 Border width for item dividers (default: 1, cash_ending: 0.5)
  final double borderBottomWidth;

  /// 🆕 Check icon (default: circleCheck, cash_ending: check)
  final IconData checkIcon;

  /// 🆕 Whether to enable haptic feedback on selection
  final bool enableHapticFeedback;

  /// Whether to show icon/avatar for items
  final bool showIcon;

  /// Whether to show background highlight on selected item
  final bool showSelectedBackground;

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
    this.selectedFontWeight = FontWeight.w600,
    this.unselectedFontWeight = FontWeight.w400,
    this.unselectedIconColor = TossColors.gray600,
    this.borderBottomWidth = 0,  // Default: no divider
    this.checkIcon = LucideIcons.check,
    this.enableHapticFeedback = false,
    this.showIcon = true,
    this.showSelectedBackground = true,
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
    FontWeight selectedFontWeight = FontWeight.w600,
    FontWeight unselectedFontWeight = FontWeight.w400,
    Color unselectedIconColor = TossColors.gray600,
    double borderBottomWidth = 0,  // Default: no divider
    IconData checkIcon = LucideIcons.check,
    bool enableHapticFeedback = false,
    bool showIcon = true,
    bool showSelectedBackground = true,
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
        selectedFontWeight: selectedFontWeight,
        unselectedFontWeight: unselectedFontWeight,
        unselectedIconColor: unselectedIconColor,
        borderBottomWidth: borderBottomWidth,
        checkIcon: checkIcon,
        enableHapticFeedback: enableHapticFeedback,
        showIcon: showIcon,
        showSelectedBackground: showSelectedBackground,
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
                  prefixIcon: const Icon(
                    LucideIcons.search,
                    size: TossSpacing.iconSM,
                    color: TossColors.gray500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: const BorderSide(color: TossColors.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: const BorderSide(color: TossColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: const BorderSide(color: TossColors.primary),
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
        // Haptic feedback (if enabled)
        if (widget.enableHapticFeedback) {
          HapticFeedback.selectionClick();
        }

        FocusScope.of(context).unfocus();
        widget.onItemSelected?.call(item);
        Navigator.pop(context, item);  // Return the selected item
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: (widget.showSelectedBackground && isSelected)
              ? TossColors.primary.withValues(alpha: 0.05)
              : TossColors.transparent,
          border: (isLast || widget.borderBottomWidth == 0)
              ? null
              : Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: widget.borderBottomWidth,
                  ),
                ),
        ),
        child: Row(
          children: [
            // Avatar or Icon container (only if showIcon is true)
            if (widget.showIcon) ...[
              if (item.avatarUrl != null)
                // Show avatar
                Container(
                  width: TossSpacing.iconXL,
                  height: TossSpacing.iconXL,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? TossColors.primary : TossColors.gray200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      item.avatarUrl!,
                      width: TossSpacing.iconXL,
                      height: TossSpacing.iconXL,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Show fallback icon ONLY when image fails to load
                        return Container(
                          width: TossSpacing.iconXL,
                          height: TossSpacing.iconXL,
                          color: TossColors.gray200,
                          child: const Icon(
                            Icons.person,
                            size: 20,
                            color: TossColors.gray500,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        // Show placeholder while loading
                        return Container(
                          width: TossSpacing.iconXL,
                          height: TossSpacing.iconXL,
                          color: TossColors.gray200,
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                // Show icon container
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
                    color: isSelected ? TossColors.primary : widget.unselectedIconColor,
                  ),
                ),
              const SizedBox(width: TossSpacing.space3),
            ],

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
                      fontWeight: isSelected ? widget.selectedFontWeight : widget.unselectedFontWeight,
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

            // Trailing widget (chip, badge, etc.)
            if (item.trailing != null) ...[
              const SizedBox(width: TossSpacing.space2),
              item.trailing!,
            ],

            // Selected indicator
            if (isSelected)
              Icon(
                widget.checkIcon,
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
        .map((store) => TossSelectionItem.fromStore(store as Map<String, dynamic>))
        .toList();

    Map<String, dynamic>? selectedStore;

    await TossSelectionBottomSheet.show<void>(
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
        .map((company) => TossSelectionItem.fromCompany(company as Map<String, dynamic>))
        .toList();

    Map<String, dynamic>? selectedCompany;

    await TossSelectionBottomSheet.show<void>(
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
    final items = accounts.map((account) {
      final accountMap = account as Map<String, dynamic>;
      return TossSelectionItem.fromGeneric(
        id: accountMap['account_id']?.toString() ?? '',
        title: accountMap['account_name']?.toString() ?? 'Unnamed Account',
        subtitle: accountMap['category_tag'] != null
            ? '${_getAccountTypeFromCategory(accountMap['category_tag']?.toString())} • ${accountMap['category_tag']}'
            : null,
        icon: IconMapper.getIcon('wallet'),
        data: accountMap,
      );
    }).toList();

    Map<String, dynamic>? selectedAccount;

    await TossSelectionBottomSheet.show<void>(
      context: context,
      title: title,
      items: items,
      selectedId: selectedAccountId,
      showSearch: true,
      maxHeightFraction: 0.7,
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