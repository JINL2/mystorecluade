import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/common/enhanced_quantity_selector.dart';
import '../../widgets/toss/toss_list_tile.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../helpers/navigation_helper.dart';
import '../inventory_management/models/product_model.dart';
import 'models/sale_product_models.dart';
import 'widgets/cart_summary_bar.dart';

// Sort Options for Product List
enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  stockAsc,
  stockDesc,
}

// Cart State Provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product) {
    final existingIndex = state.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      // Increase quantity if item already exists
      final updatedItems = [...state];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = updatedItems;
    } else {
      // Add new item
      state = [
        ...state,
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          sku: product.sku,
          name: product.name,
          image: product.images.isNotEmpty ? product.images.first : null,
          price: product.salePrice,
          quantity: 1,
          available: product.available,
          customerOrdered: 0,
        ),
      ];
    }
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    
    state = state.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.subtotal);
  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}

// Mock Products Provider
final productsProvider = Provider<List<Product>>((ref) {
  return [
    Product(
      id: '1',
      sku: '10002',
      name: '비쌈옷',
      category: ProductCategory.clothing,
      productType: ProductType.simple,
      costPrice: 1500000,
      salePrice: 2300000,
      onHand: 10,
      available: 10,
    ),
    Product(
      id: '2',
      sku: '10000-3NT0628',
      name: 'Ami 터셔츠 - Ami T-shirts',
      category: ProductCategory.clothing,
      productType: ProductType.simple,
      costPrice: 800000,
      salePrice: 1500000,
      onHand: 5,
      available: 5,
    ),
    Product(
      id: '3',
      sku: '3043GZ2PQ1065',
      name: 'BOTTEGA',
      category: ProductCategory.bags,
      productType: ProductType.simple,
      costPrice: 900000,
      salePrice: 1700000,
      onHand: 3,
      available: 3,
      images: ['bag1.jpg'],
    ),
    Product(
      id: '4',
      sku: '3030GZ2PQ1052',
      name: 'BOTTEGA',
      category: ProductCategory.bags,
      productType: ProductType.simple,
      costPrice: 2200000,
      salePrice: 4400000,
      onHand: 2,
      available: 2,
      images: ['bag2.jpg'],
    ),
    Product(
      id: '5',
      sku: '3029GZ2PQ1051',
      name: 'BOTTEGA',
      category: ProductCategory.bags,
      productType: ProductType.simple,
      costPrice: 2100000,
      salePrice: 4200000,
      onHand: 4,
      available: 4,
      images: ['bag3.jpg'],
    ),
    Product(
      id: '6',
      sku: '3028GZ2PQ1050',
      name: 'BOTTEGA',
      category: ProductCategory.bags,
      productType: ProductType.simple,
      costPrice: 2100000,
      salePrice: 4200000,
      onHand: 1,
      available: 1,
      images: ['bag4.jpg'],
    ),
  ];
});

class SaleProductPage extends ConsumerStatefulWidget {
  const SaleProductPage({super.key});

  @override
  ConsumerState<SaleProductPage> createState() => _SaleProductPageState();
}

class _SaleProductPageState extends ConsumerState<SaleProductPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool showBarcodeScanner = false;
  
  // Filters
  StockStatus? _selectedStockStatus;
  ProductCategory? _selectedCategory;
  
  // Sorting
  SortOption _currentSort = SortOption.nameAsc;
  bool _sortAscending = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSort() {
    setState(() {
      searchQuery = _searchController.text;
    });
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
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.lg),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Products',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              Text('Stock Status'),
              SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                children: StockStatus.values.map((status) {
                  return FilterChip(
                    label: Text(_getStockStatusLabel(status)),
                    selected: _selectedStockStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStockStatus = selected ? status : null;
                        _applyFiltersAndSort();
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: TossSpacing.space4),
              Text('Category'),
              SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                children: ProductCategory.values.map((category) {
                  return FilterChip(
                    label: Text(_getCategoryLabel(category)),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                        _applyFiltersAndSort();
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              if (_hasActiveFilters()) ...[
                SizedBox(height: TossSpacing.space4),
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
            ],
          ),
        ),
      ),
    );
  }
  
  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.lg),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort Products',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              ...[SortOption.nameAsc, SortOption.priceAsc, SortOption.stockAsc].map((option) {
                return ListTile(
                  title: Text(_getSortOptionLabel(option)),
                  selected: _currentSort == option || 
                          (_currentSort == SortOption.nameDesc && option == SortOption.nameAsc) ||
                          (_currentSort == SortOption.priceDesc && option == SortOption.priceAsc) ||
                          (_currentSort == SortOption.stockDesc && option == SortOption.stockAsc),
                  onTap: () {
                    setState(() {
                      if (_currentSort == option) {
                        _sortAscending = !_sortAscending;
                        _currentSort = _sortAscending ? option : _getDescendingOption(option);
                      } else {
                        _currentSort = option;
                        _sortAscending = true;
                      }
                      _applyFiltersAndSort();
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getSortOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.nameAsc:
        return 'Name';
      case SortOption.priceAsc:
        return 'Price';
      case SortOption.stockAsc:
        return 'Stock';
      default:
        return 'Name';
    }
  }
  
  SortOption _getDescendingOption(SortOption option) {
    switch (option) {
      case SortOption.nameAsc:
        return SortOption.nameDesc;
      case SortOption.priceAsc:
        return SortOption.priceDesc;
      case SortOption.stockAsc:
        return SortOption.stockDesc;
      default:
        return option;
    }
  }
  
  String _getStockStatusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.critical:
        return 'Critical';
      case StockStatus.low:
        return 'Low';
      case StockStatus.optimal:
        return 'Optimal';
      case StockStatus.excess:
        return 'Excess';
    }
  }
  
  String _getCategoryLabel(ProductCategory category) {
    switch (category) {
      case ProductCategory.electronics:
        return 'Electronics';
      case ProductCategory.clothing:
        return 'Clothing';
      case ProductCategory.accessories:
        return 'Accessories';
      case ProductCategory.bags:
        return 'Bags';
      case ProductCategory.shoes:
        return 'Shoes';
      case ProductCategory.jewelry:
        return 'Jewelry';
      case ProductCategory.food:
        return 'Food';
      case ProductCategory.beverages:
        return 'Beverages';
      case ProductCategory.household:
        return 'Household';
      case ProductCategory.beauty:
        return 'Beauty';
      case ProductCategory.sports:
        return 'Sports';
      case ProductCategory.books:
        return 'Books';
      case ProductCategory.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final products = ref.watch(productsProvider);
    
    // Filter and sort products
    var filteredProducts = products.where((product) {
      final searchLower = _searchController.text.toLowerCase();
      final matchesSearch = searchLower.isEmpty || 
                          product.name.toLowerCase().contains(searchLower) ||
                          product.sku.toLowerCase().contains(searchLower) ||
                          (product.barcode?.toLowerCase().contains(searchLower) ?? false);
      
      final matchesStockStatus = _selectedStockStatus == null || product.stockStatus == _selectedStockStatus;
      final matchesCategory = _selectedCategory == null || product.category == _selectedCategory;
      
      return matchesSearch && matchesStockStatus && matchesCategory;
    }).toList();
    
    // Apply sorting
    switch (_currentSort) {
      case SortOption.nameAsc:
      case SortOption.nameDesc:
        filteredProducts.sort((a, b) => 
            _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case SortOption.priceAsc:
      case SortOption.priceDesc:
        filteredProducts.sort((a, b) => 
            _sortAscending ? a.salePrice.compareTo(b.salePrice) : b.salePrice.compareTo(a.salePrice));
        break;
      case SortOption.stockAsc:
      case SortOption.stockDesc:
        filteredProducts.sort((a, b) => 
            _sortAscending ? a.onHand.compareTo(b.onHand) : b.onHand.compareTo(a.onHand));
        break;
    }

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: Text(
          'Sales',
          style: TossTextStyles.h3,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                                          style: TossTextStyles.small.copyWith(
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
            
            // Search Section
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
                prefixIcon: Icons.search,
                onChanged: (value) {
                  _applyFiltersAndSort();
                },
              ),
            ),

            // Products Content
            if (filteredProducts.isEmpty)
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: TossColors.gray400,
                      ),
                      SizedBox(height: TossSpacing.space3),
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
                              Icons.shopping_cart_rounded,
                              color: TossColors.primary,
                              size: 20,
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Text(
                              'Select Products',
                              style: TossTextStyles.h4.copyWith(
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
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Text(
                                '${filteredProducts.length} available',
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
                      ...filteredProducts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final product = entry.value;
                        final cartItem = cart.firstWhere(
                          (item) => item.productId == product.id,
                          orElse: () => CartItem(
                            id: '',
                            productId: '',
                            sku: '',
                            name: '',
                            price: 0,
                            quantity: 0,
                            available: 0,
                          ),
                        );
                        
                        return Column(
                          children: [
                            _buildProductListTile(product, cartItem),
                            if (index < filteredProducts.length - 1)
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
            
            // Bottom padding to prevent cart bar overlap
            SizedBox(height: cart.isNotEmpty ? 100 : 80),
          ],
        ),
      ),
      
      // Cart Summary Bar
      bottomNavigationBar: cart.isNotEmpty
          ? CartSummaryBar(
              itemCount: ref.read(cartProvider.notifier).totalItems,
              subtotal: ref.read(cartProvider.notifier).subtotal,
              onReset: () {
                ref.read(cartProvider.notifier).clearCart();
              },
              onDone: () {
                context.push('/saleProduct/invoice');
              },
            )
          : null,
    );
  }

  Widget _buildProductListTile(Product product, CartItem cartItem) {
    return TossListTile(
      title: product.name,
      subtitle: product.sku,
      showDivider: false,
      leading: Stack(
        clipBehavior: Clip.none,  // Allow badge to extend outside bounds
        children: [
          Container(
            width: TossSpacing.space12,  // 48px using core spacing
            height: TossSpacing.space12,  // 48px using core spacing
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
                          Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
                    ),
                  )
                : Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
          ),
          // Cart quantity badge - properly positioned
          if (cartItem.quantity > 0)
            Positioned(
              right: -TossSpacing.space2,  // -8px for proper overlap
              top: -TossSpacing.space1,     // -4px for proper overlap
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: cartItem.quantity >= 10 ? TossSpacing.space1 : TossSpacing.space1 + 2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  border: Border.all(
                    color: TossColors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                constraints: BoxConstraints(
                  minWidth: TossSpacing.space5,  // 20px minimum width
                  minHeight: TossSpacing.space5, // 20px minimum height
                ),
                child: Center(
                  child: Text(
                    '${cartItem.quantity}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      trailing: Container(
        width: 150,  // Wider to accommodate enhanced selector
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price - always in same position
            Text(
              _formatCurrency(product.salePrice),
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space1),
            // Clean state or quantity selector with smooth animations
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0), // Slide from right
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: cartItem.quantity > 0
                  ? EnhancedQuantitySelector(
                      key: ValueKey('selector-${product.id}'),
                      quantity: cartItem.quantity,
                      maxQuantity: product.available,
                      compactMode: true,
                      onQuantityChanged: (newQuantity) {
                        if (newQuantity <= 0) {
                          ref.read(cartProvider.notifier).removeItem(cartItem.id);
                        } else {
                          ref.read(cartProvider.notifier).updateQuantity(
                            cartItem.id,
                            newQuantity,
                          );
                        }
                      },
                      semanticLabel: 'Quantity for ${product.name}',
                      decrementSemanticLabel: 'Decrease ${product.name} quantity',
                      incrementSemanticLabel: 'Increase ${product.name} quantity',
                    )
                  : Row(
                      key: ValueKey('clean-${product.id}'),
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Only show stock info in clean state - no buttons
                        Text(
                          'Stock: ${product.onHand}',
                          style: TossTextStyles.caption.copyWith(
                            color: _getStockColor(product),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      // Always enable tap to reveal quantity selector
      onTap: () {
        HapticFeedback.lightImpact();
        if (cartItem.quantity == 0) {
          // Add first item to reveal selector
          ref.read(cartProvider.notifier).addItem(product);
        }
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


  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '₩${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '₩${(value / 1000).toStringAsFixed(0)}K';
    }
    return '₩${value.toStringAsFixed(0)}';
  }
}