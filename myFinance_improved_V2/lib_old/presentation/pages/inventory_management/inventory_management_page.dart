import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/index.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/toss/toss_list_tile.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../helpers/navigation_helper.dart';
import 'models/product_model.dart';
import 'providers/inventory_providers.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class InventoryManagementPage extends ConsumerStatefulWidget {
  const InventoryManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryManagementPage> createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends ConsumerState<InventoryManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounceTimer;
  
  // Filters
  StockStatus? _selectedStockStatus;
  ProductCategory? _selectedCategory;
  
  // Sorting
  SortOption _currentSort = SortOption.nameAsc;
  bool _sortAscending = true;
  
  // Sample data (replace with actual data source)
  List<Product> _products = _generateDiverseSampleProducts();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
    _applyFiltersAndSort();
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
      _applyFiltersAndSort();
    });
  }

  void _applyFiltersAndSort() {
    setState(() {
      // Apply search
      _filteredProducts = _products.where((product) {
        final searchLower = _searchController.text.toLowerCase();
        return product.name.toLowerCase().contains(searchLower) ||
               product.sku.toLowerCase().contains(searchLower) ||
               (product.barcode?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
      
      // Apply filters
      if (_selectedStockStatus != null) {
        _filteredProducts = _filteredProducts
            .where((p) => p.stockStatus == _selectedStockStatus)
            .toList();
      }
      
      if (_selectedCategory != null) {
        _filteredProducts = _filteredProducts
            .where((p) => p.category == _selectedCategory)
            .toList();
      }
      
      // Apply sorting
      switch (_currentSort) {
        case SortOption.nameAsc:
        case SortOption.nameDesc:
          _filteredProducts.sort((a, b) => 
              _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
          break;
        case SortOption.priceAsc:
        case SortOption.priceDesc:
          _filteredProducts.sort((a, b) => 
              _sortAscending ? a.salePrice.compareTo(b.salePrice) : b.salePrice.compareTo(a.salePrice));
          break;
        case SortOption.stockAsc:
        case SortOption.stockDesc:
          _filteredProducts.sort((a, b) => 
              _sortAscending ? a.onHand.compareTo(b.onHand) : b.onHand.compareTo(a.onHand));
          break;
        case SortOption.valueDesc:
          _filteredProducts.sort((a, b) => 
              b.inventoryValue.compareTo(a.inventoryValue));
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(TossIcons.back),
          onPressed: () => NavigationHelper.safeGoBack(context),
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
      body: _buildSimpleProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get inventory metadata before navigating
          final metadata = await ref.read(inventoryMetadataProvider.future);
          
          final result = await NavigationHelper.navigateTo(
            context,
            '/inventoryManagement/addProduct',
            extra: {'metadata': metadata},
          );
          if (result != null && result is Product) {
            setState(() {
              _products.add(result);
              _applyFiltersAndSort();
            });
          }
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
                color: TossColors.black.withOpacity(0.02),
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
                              size: 22,
                              color: _hasActiveFilters() ? TossColors.primary : TossColors.gray600,
                            ),
                            if (_hasActiveFilters())
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${_getActiveFilterCount()}',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _hasActiveFilters() ? '${_getActiveFilterCount()} filters active' : 'Filters',
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
              
              Container(
                width: 1,
                height: 20,
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
                          Icons.sort_rounded,
                          size: 22,
                          color: _currentSort != SortOption.nameAsc ? TossColors.primary : TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _getSortLabel(),
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Show sort direction indicator
                        if (_currentSort != SortOption.nameAsc)
                          Icon(
                            _sortAscending
                              ? Icons.arrow_upward_rounded 
                              : Icons.arrow_downward_rounded,
                            size: 16,
                            color: TossColors.primary,
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

  Widget _buildSimpleProductList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search and Filter Section (scrolls with content)
          _buildSearchFilterSection(),
          
          // Products content
          if (_filteredProducts.isEmpty)
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
                              color: TossColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: Text(
                              '${_filteredProducts.length} items',
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
                    ..._filteredProducts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final product = entry.value;
                      
                      return Column(
                        children: [
                          _buildProductListTile(product),
                          if (index < _filteredProducts.length - 1)
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
        child: product.images.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
                ),
              )
            : Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatCurrency(product.salePrice),
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
        NavigationHelper.navigateTo(
          context,
          '/inventoryManagement/product/${product.id}',
          extra: {'product': product},
        );
      },
    );
  }

  Color _getStockColor(Product product) {
    if (product.onHand == 0) return TossColors.error;
    switch (product.stockStatus) {
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.optimal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.info;
    }
  }

  String _getSortLabel() {
    switch (_currentSort) {
      case SortOption.nameAsc:
      case SortOption.nameDesc:
        return _sortAscending ? 'Name (A-Z)' : 'Name (Z-A)';
      case SortOption.priceAsc:
      case SortOption.priceDesc:
        return _sortAscending ? 'Price (Low to High)' : 'Price (High to Low)';
      case SortOption.stockAsc:
      case SortOption.stockDesc:
        return _sortAscending ? 'Stock (Low to High)' : 'Stock (High to Low)';
      case SortOption.valueDesc:
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

  void _showFilterOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => _buildFilterSheet(),
    );
  }

  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => _buildSortSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
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
          // Handle
          Container(
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'Filter Products',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                if (_hasActiveFilters())
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedStockStatus = null;
                        _selectedCategory = null;
                        _applyFiltersAndSort();
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Clear All'),
                  ),
              ],
            ),
          ),
          
          // Filter Options
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
              ),
              child: Column(
                children: [
                  // Stock Status Filter
                  _buildFilterSection(
                    'Stock Status',
                    StockStatus.values,
                    _selectedStockStatus,
                    (value) {
                      setState(() {
                        _selectedStockStatus = value;
                        _applyFiltersAndSort();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  
                  // Category Filter
                  _buildFilterSection(
                    'Category',
                    ProductCategory.values,
                    _selectedCategory,
                    (value) {
                      setState(() {
                        _selectedCategory = value;
                        _applyFiltersAndSort();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection<T>(
    String title,
    List<T> options,
    T? selectedValue,
    ValueChanged<T?> onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space6),
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: EdgeInsets.only(bottom: TossSpacing.space3),
            child: Text(
              title,
              style: TossTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
          ),
          
          // All Option
          _buildFilterOption<T>(
            'All ${title}s',
            null,
            selectedValue,
            onChanged,
          ),
          
          // Individual Options
          ...options.map((option) {
            String displayLabel = '';
            if (option is StockStatus) {
              displayLabel = option.name;
            } else if (option is ProductCategory) {
              displayLabel = option.displayName;
            }
            
            return _buildFilterOption<T>(
              displayLabel,
              option,
              selectedValue,
              onChanged,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFilterOption<T>(
    String label,
    T? value,
    T? selectedValue,
    ValueChanged<T?> onChanged,
  ) {
    final isSelected = value == selectedValue;
    
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onChanged(value),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortSheet() {
    final sortOptions = [
      {'value': SortOption.nameAsc, 'label': 'Name', 'icon': Icons.sort_by_alpha},
      {'value': SortOption.priceDesc, 'label': 'Price', 'icon': Icons.attach_money},
      {'value': SortOption.stockDesc, 'label': 'Stock Level', 'icon': Icons.inventory_2},
      {'value': SortOption.valueDesc, 'label': 'Value', 'icon': Icons.trending_up},
    ];
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
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
          // Handle
          Container(
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Sort by',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // Sort Options
          ...sortOptions.map((option) {
            final isSelected = option['value'] == _currentSort;
            return Material(
              color: TossColors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  
                  // If clicking the same sort option, toggle direction
                  if (option['value'] == _currentSort) {
                    setState(() {
                      _sortAscending = !_sortAscending;
                      _applyFiltersAndSort();
                    });
                  } else {
                    // Set new sort option
                    setState(() {
                      _currentSort = option['value'] as SortOption;
                      // Reset to default direction for each sort type
                      if (_currentSort == SortOption.nameAsc || _currentSort == SortOption.nameDesc) {
                        _sortAscending = true; // A-Z by default
                      } else {
                        _sortAscending = false; // High-to-Low by default
                      }
                      _applyFiltersAndSort();
                    });
                  }
                  
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option['icon'] as IconData,
                        size: 20,
                        color: isSelected ? TossColors.primary : TossColors.gray600,
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Text(
                          option['label'] as String,
                          style: TossTextStyles.body.copyWith(
                            color: isSelected ? TossColors.primary : TossColors.gray900,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      // Show direction indicator for selected item
                      if (isSelected) ...[
                        Icon(
                          _sortAscending
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                          size: 16,
                          color: TossColors.primary,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Icon(
                          Icons.check_rounded,
                          color: TossColors.primary,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static List<Product> _generateDiverseSampleProducts() {
    return [
      Product(
        id: '1',
        sku: '1194GZ2BA745',
        name: '고야드 가방 - GOYARD Bag',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        brand: 'GOYARD',
        costPrice: 3500000,
        salePrice: 5100000,
        onHand: 5,
        reorderPoint: 2,
        location: 'A-1-3',
        images: ['https://example.com/goyard1.jpg'],
      ),
      Product(
        id: '2',
        sku: '1193GZ2BA744',
        name: '고야드 가방 - GOYARD Bag',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        brand: 'GOYARD',
        costPrice: 3200000,
        salePrice: 4900000,
        onHand: 0,
        reorderPoint: 3,
        location: 'A-1-4',
        images: [],
      ),
      Product(
        id: '3',
        sku: '1192GZ2BA743',
        name: '고야드 가방 - GOYARD',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        brand: 'GOYARD',
        costPrice: 3200000,
        salePrice: 4900000,
        onHand: 2,
        reorderPoint: 3,
        location: 'A-1-5',
        images: [],
      ),
      Product(
        id: '4',
        sku: '1191GZ2BA742',
        name: '고야드 가방 - GOYARD Bag',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        brand: 'GOYARD',
        costPrice: 3200000,
        salePrice: 4900000,
        onHand: 8,
        reorderPoint: 5,
        location: 'A-2-1',
        images: ['https://example.com/goyard4.jpg'],
      ),
      Product(
        id: '5',
        sku: '1190GZ2BA741',
        name: '고야드 가방 - GOYARD Bag',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        brand: 'GOYARD',
        costPrice: 1800000,
        salePrice: 2600000,
        onHand: 12,
        reorderPoint: 5,
        location: 'A-2-2',
        images: ['https://example.com/goyard5.jpg'],
      ),
      Product(
        id: '6',
        sku: 'EL001',
        name: 'iPhone 15 Pro Max',
        category: ProductCategory.electronics,
        productType: ProductType.simple,
        brand: 'Apple',
        costPrice: 1200000,
        salePrice: 1590000,
        onHand: 15,
        reorderPoint: 5,
        location: 'B-1-1',
        images: [],
      ),
      Product(
        id: '7',
        sku: 'CL001',
        name: '에르메스 실크 스카프',
        category: ProductCategory.clothing,
        productType: ProductType.simple,
        brand: 'Hermes',
        costPrice: 380000,
        salePrice: 520000,
        onHand: 3,
        reorderPoint: 2,
        location: 'C-1-1',
        images: [],
      ),
      Product(
        id: '8',
        sku: 'SH001',
        name: '로이스 레더 구두',
        category: ProductCategory.shoes,
        productType: ProductType.simple,
        brand: 'Loyce',
        costPrice: 250000,
        salePrice: 380000,
        onHand: 7,
        reorderPoint: 3,
        location: 'D-1-1',
        images: [],
      ),
    ];
  }
}

enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  stockAsc,
  stockDesc,
  valueDesc,
}