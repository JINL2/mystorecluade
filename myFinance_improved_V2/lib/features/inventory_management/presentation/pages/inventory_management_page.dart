// Presentation Page: Inventory Management
// Main page for inventory management with Clean Architecture

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/toss/toss_list_tile.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';
import '../../domain/entities/product.dart';
import '../providers/inventory_providers.dart';
import '../providers/states/inventory_page_state.dart';

/// Inventory Management Page
/// 재고 관리 메인 페이지
class InventoryManagementPage extends ConsumerStatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  ConsumerState<InventoryManagementPage> createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState
    extends ConsumerState<InventoryManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounceTimer;

  // Filters
  StockStatus? _selectedStockStatus;
  String? _selectedCategory;

  // Sorting
  _SortOption? _currentSort; // null = database default order
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    // Load initial data
    Future.microtask(() => ref.read(inventoryPageProvider.notifier).refresh());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Cancel previous timer if it exists
    _searchDebounceTimer?.cancel();

    // Start new timer for debouncing (300ms delay)
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(inventoryPageProvider.notifier).setSearchQuery(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(inventoryPageProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(TossIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Product',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: _buildSimpleProductList(pageState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add product page navigation
          // For now, show a message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Product page - Coming Soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: TossColors.primary,
        child: const Icon(TossIcons.add, color: TossColors.white),
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Column(
      children: [
        // Filter and Sort Controls
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.02),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Filter Section - 50% space
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showFilterOptionsSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              size: 18,
                              color: TossColors.gray600,
                            ),
                            if (_hasActiveFilters())
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _hasActiveFilters()
                                ? 'Filters (${_getActiveFilterCount()})'
                                : 'Filters',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Vertical Divider
              Container(
                width: 1,
                height: 32,
                margin: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                color: TossColors.gray200,
              ),

              // Sort Section - 50% space
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showSortOptionsSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.swap_vert_rounded,
                          size: 18,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _getSortLabel(),
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search Field
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          child: TossSearchField(
            controller: _searchController,
            hintText: 'Search products...',
            onChanged: (value) {
              _onSearchChanged();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleProductList(InventoryPageState pageState) {
    // Apply local filters and sorting
    List<Product> displayProducts = _applyLocalFiltersAndSort(pageState.products);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Search and Filter Section (scrolls with content)
          _buildSearchFilterSection(),

          // Products content
          if (displayProducts.isEmpty && !pageState.isLoading)
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 64,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'No products found',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (pageState.isLoading && displayProducts.isEmpty)
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Container(
              margin: EdgeInsets.all(TossSpacing.space4),
              child: TossWhiteCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Section Header
                    Container(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2_rounded,
                            color: TossColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            'Products',
                            style: TossTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: TossSpacing.space1,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.primary.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: Text(
                              '${displayProducts.length} items',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product List
                    ...displayProducts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final product = entry.value;

                      return Column(
                        children: [
                          _buildProductListTile(product),
                          if (index < displayProducts.length - 1)
                            Divider(
                              height: 1,
                              color: TossColors.gray100,
                              indent: TossSpacing.space4,
                              endIndent: TossSpacing.space4,
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

          // Bottom padding to prevent FAB overlap
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProductListTile(Product product) {
    final pageState = ref.watch(inventoryPageProvider);
    final currencySymbol = pageState.currency?.symbol ?? '₩';

    return TossListTile(
      title: product.name,
      subtitle: product.sku,
      showDivider: false,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$currencySymbol${_formatCurrency(product.salePrice)}',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: 2),
          Text(
            product.onHand.toString(),
            style: TossTextStyles.body.copyWith(
              color: _getStockColor(product),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to product detail
      },
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Color _getStockColor(Product product) {
    if (product.onHand == 0) return TossColors.error;
    final status = product.getStockStatus();
    switch (status) {
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.normal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.info;
      case StockStatus.outOfStock:
        return TossColors.error;
    }
  }

  String _getSortLabel() {
    if (_currentSort == null) return 'Name (A-Z)';

    switch (_currentSort!) {
      case _SortOption.nameAsc:
      case _SortOption.nameDesc:
        return _sortAscending ? 'Name (A-Z)' : 'Name (Z-A)';
      case _SortOption.priceAsc:
      case _SortOption.priceDesc:
        return _sortAscending ? 'Price (Low to High)' : 'Price (High to Low)';
      case _SortOption.stockAsc:
      case _SortOption.stockDesc:
        return _sortAscending ? 'Stock (Low to High)' : 'Stock (High to Low)';
      case _SortOption.valueDesc:
        return 'Value (High to Low)';
    }
  }

  bool _hasActiveFilters() {
    return _selectedStockStatus != null || _selectedCategory != null;
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedStockStatus != null) count++;
    if (_selectedCategory != null) count++;
    return count;
  }

  List<Product> _applyLocalFiltersAndSort(List<Product> products) {
    List<Product> filtered = List.from(products);

    // Apply filters
    if (_selectedStockStatus != null) {
      filtered = filtered
          .where((p) => p.getStockStatus() == _selectedStockStatus)
          .toList();
    }

    if (_selectedCategory != null) {
      filtered = filtered
          .where((p) => p.categoryId == _selectedCategory)
          .toList();
    }

    // Apply sorting only if sort option is selected
    if (_currentSort != null) {
      switch (_currentSort!) {
        case _SortOption.nameAsc:
        case _SortOption.nameDesc:
          filtered.sort((a, b) => _sortAscending
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name));
          break;
        case _SortOption.priceAsc:
        case _SortOption.priceDesc:
          filtered.sort((a, b) => _sortAscending
              ? a.salePrice.compareTo(b.salePrice)
              : b.salePrice.compareTo(a.salePrice));
          break;
        case _SortOption.stockAsc:
        case _SortOption.stockDesc:
          filtered.sort((a, b) => _sortAscending
              ? a.onHand.compareTo(b.onHand)
              : b.onHand.compareTo(a.onHand));
          break;
        case _SortOption.valueDesc:
          filtered.sort((a, b) =>
              (b.onHand * b.salePrice).compareTo(a.onHand * a.salePrice));
          break;
      }
    }
    // If _currentSort is null, keep database order (no sorting)

    return filtered;
  }

  void _showFilterOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_hasActiveFilters())
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedStockStatus = null;
                          _selectedCategory = null;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Clear All'),
                    ),
                ],
              ),
            ),

            // Filter Options
            ListView(
              shrinkWrap: true,
              children: [
                // Stock Status Filter
                Padding(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stock Status',
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Wrap(
                        spacing: TossSpacing.space2,
                        runSpacing: TossSpacing.space2,
                        children: StockStatus.values.map((status) {
                          final isSelected = _selectedStockStatus == status;
                          return FilterChip(
                            label: Text(_getStockStatusLabel(status)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStockStatus =
                                    selected ? status : null;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort By',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Sort Options
            ListView(
              shrinkWrap: true,
              children: [
                _buildSortOption('Name (A-Z)', _SortOption.nameAsc),
                _buildSortOption('Name (Z-A)', _SortOption.nameDesc),
                _buildSortOption(
                    'Price (Low to High)', _SortOption.priceAsc),
                _buildSortOption(
                    'Price (High to Low)', _SortOption.priceDesc),
                _buildSortOption(
                    'Stock (Low to High)', _SortOption.stockAsc),
                _buildSortOption(
                    'Stock (High to Low)', _SortOption.stockDesc),
                _buildSortOption(
                    'Value (High to Low)', _SortOption.valueDesc),
              ],
            ),

            SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, _SortOption option) {
    final isSelected = _currentSort == option;
    return ListTile(
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: TossColors.primary)
          : null,
      onTap: () {
        setState(() {
          _currentSort = option;
          _sortAscending = option == _SortOption.nameAsc ||
              option == _SortOption.priceAsc ||
              option == _SortOption.stockAsc;
        });
        Navigator.pop(context);
      },
    );
  }

  String _getStockStatusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.critical:
        return 'Critical';
      case StockStatus.low:
        return 'Low';
      case StockStatus.normal:
        return 'Normal';
      case StockStatus.excess:
        return 'Excess';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }
}

enum _SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  stockAsc,
  stockDesc,
  valueDesc,
}
