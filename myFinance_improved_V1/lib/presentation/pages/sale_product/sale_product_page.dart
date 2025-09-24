import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/toss/toss_list_tile.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../helpers/navigation_helper.dart';
import '../inventory_management/models/product_model.dart';
import '../sales_invoice/models/invoice_models.dart';
import '../sales_invoice/payment_method_page.dart';
import 'models/sale_product_models.dart';
import 'widgets/cart_summary_bar.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import '../debt_control/providers/currency_provider.dart';
import '../../../data/services/inventory_service.dart';
import '../../../data/models/inventory_models.dart';
import '../../providers/app_state_provider.dart';

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

  void addItem(SalesProduct product) {
    final existingIndex = state.indexWhere((item) => item.productId == product.productId);
    
    if (existingIndex >= 0) {
      // Increase quantity if item already exists
      final updatedItems = [...state];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = updatedItems;
    } else {
      // Add new item
      print('🛒 Adding product to cart: ${product.productName}, Price: ${product.pricing.sellingPrice}');
      state = [
        ...state,
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.productId,
          sku: product.sku,
          name: product.productName,
          image: product.images.mainImage,
          price: product.pricing.sellingPrice ?? 0,
          quantity: 1,
          available: product.totalStockSummary.totalQuantityAvailable,
          customerOrdered: 0,
        ),
      ];
      print('🛒 Cart subtotal: $subtotal, Items: $totalItems');
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

// Sales Product Provider State
class SalesProductState {
  final List<SalesProduct> products;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final int currentPage;
  final bool hasNextPage;
  
  const SalesProductState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.currentPage = 1,
    this.hasNextPage = false,
  });
  
  SalesProductState copyWith({
    List<SalesProduct>? products,
    bool? isLoading,
    String? error,
    String? searchQuery,
    int? currentPage,
    bool? hasNextPage,
  }) {
    return SalesProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}

// Convert InventoryProduct to SalesProduct
SalesProduct _convertInventoryToSalesProduct(InventoryProduct inventoryProduct) {
  return SalesProduct(
    productId: inventoryProduct.id,
    productName: inventoryProduct.name,
    sku: inventoryProduct.sku ?? '',
    barcode: inventoryProduct.barcode ?? '',
    productType: 'simple',
    pricing: ProductPricing(
      sellingPrice: inventoryProduct.price,
      costPrice: inventoryProduct.cost ?? 0,
      minPrice: inventoryProduct.cost ?? 0,
      profitAmount: (inventoryProduct.price - (inventoryProduct.cost ?? 0)),
      profitMargin: inventoryProduct.cost != null && inventoryProduct.cost! > 0 
          ? ((inventoryProduct.price - inventoryProduct.cost!) / inventoryProduct.price)
          : 0,
    ),
    totalStockSummary: TotalStockSummary(
      storeCount: 1,
      totalValue: inventoryProduct.price * inventoryProduct.stock,
      totalQuantityOnHand: inventoryProduct.stock,
      totalQuantityAvailable: inventoryProduct.quantityAvailable ?? inventoryProduct.stock,
      totalQuantityReserved: inventoryProduct.quantityReserved ?? 0,
    ),
    images: ProductImages(
      thumbnail: inventoryProduct.imageUrl,
      mainImage: inventoryProduct.imageUrl,
      additionalImages: [],
    ),
    status: ProductStatus(
      isActive: inventoryProduct.isActive,
      createdAt: inventoryProduct.createdAt ?? DateTime.now(),
      isDeleted: false,
      updatedAt: inventoryProduct.updatedAt ?? DateTime.now(),
    ),
    attributes: ProductAttributes(),
    storeStocks: [],
    stockSettings: StockSettings(
      minStock: inventoryProduct.minStock ?? 0,
      maxStock: inventoryProduct.maxStock ?? 100,
      reorderPoint: inventoryProduct.minStock ?? 5,
      reorderQuantity: 20,
    ),
    unit: inventoryProduct.unit,
    brand: inventoryProduct.brandName,
    category: inventoryProduct.categoryName,
  );
}

// Sales Product Notifier
class SalesProductNotifier extends StateNotifier<SalesProductState> {
  final Ref ref;
  final InventoryService _service;
  
  SalesProductNotifier(this.ref, this._service) : super(const SalesProductState()) {
    loadProducts();
  }
  
  Future<void> loadProducts({String? search}) async {
    print('🔍 [SALES_PRODUCT] Loading products with search: $search');
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      print('📋 [SALES_PRODUCT] Company: $companyId, Store: $storeId');
      
      if (companyId.isEmpty || storeId.isEmpty) {
        print('❌ [SALES_PRODUCT] No company or store selected');
        state = state.copyWith(
          isLoading: false,
          error: 'Please select a company and store first',
          products: [],
        );
        return;
      }
      
      final result = await _service.getInventoryPage(
        companyId: companyId,
        storeId: storeId,
        page: 1,
        limit: 100, // Load more products for sales
        search: search ?? state.searchQuery,
      );
      
      if (result != null) {
        print('✅ [SALES_PRODUCT] Products loaded: ${result.products.length}');
        
        // Convert inventory products to sales products
        final salesProducts = result.products
            .map(_convertInventoryToSalesProduct)
            .toList();
        
        state = state.copyWith(
          products: salesProducts,
          isLoading: false,
          searchQuery: search ?? state.searchQuery,
          currentPage: result.pagination.page,
          hasNextPage: result.pagination.hasNext,
        );
      } else {
        print('❌ [SALES_PRODUCT] Failed to load products');
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load products',
          products: [],
        );
      }
    } catch (e) {
      print('❌ [SALES_PRODUCT] Error loading products: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error loading products: $e',
        products: [],
      );
    }
  }
  
  void search(String query) {
    print('🔍 [SALES_PRODUCT] Searching for: $query');
    loadProducts(search: query);
  }
  
  void refresh() {
    print('🔄 [SALES_PRODUCT] Refreshing products');
    loadProducts();
  }
}

// Inventory Service Provider
final salesInventoryServiceProvider = Provider<InventoryService>((ref) {
  return InventoryService();
});

// Sales Product Provider
final salesProductProvider = StateNotifierProvider<SalesProductNotifier, SalesProductState>((ref) {
  final service = ref.watch(salesInventoryServiceProvider);
  
  // Watch for company/store changes and trigger reload
  ref.watch(appStateProvider.select((state) => state.companyChoosen));
  ref.watch(appStateProvider.select((state) => state.storeChoosen));
  
  return SalesProductNotifier(ref, service);
});

// Legacy compatibility - provides just the products list
final productsProvider = Provider<List<SalesProduct>>((ref) {
  final salesState = ref.watch(salesProductProvider);
  return salesState.products;
});

class SaleProductPage extends ConsumerStatefulWidget {
  const SaleProductPage({super.key});

  @override
  ConsumerState<SaleProductPage> createState() => _SaleProductPageState();
}

class _SaleProductPageState extends ConsumerState<SaleProductPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer? _searchDebounceTimer;
  
  // Sorting
  SortOption _currentSort = SortOption.nameAsc;
  bool _sortAscending = true;
  
  // Add search focus state
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    // Clear cart when page loads to ensure fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).clearCart();
    });
    
    // Listen to search focus changes
    _searchFocusNode.addListener(() {
      final cartItems = ref.read(cartProvider);
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
        // Clear search when losing focus to show clean Added Items view
        if (!_isSearchFocused && cartItems.isNotEmpty) {
          _searchController.clear();
          searchQuery = '';
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    
    // Live filtering is now handled in the build method
    // No need to call RPC service for search anymore
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
                      // Sorting is now handled locally in build method
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

  @override
  Widget build(BuildContext context) {
    print('🟢 Building SaleProductPage - Title should be "Sales"');
    final cart = ref.watch(cartProvider);
    final salesState = ref.watch(salesProductProvider);
    final products = salesState.products;
    final currencySymbol = ref.watch(currencyProvider);
    print('💰 Currency symbol: $currencySymbol');
    
    // Handle loading and error states
    if (salesState.isLoading && products.isEmpty) {
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TossTextStyles.h3,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (salesState.error != null && products.isEmpty) {
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TossTextStyles.h3,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
              SizedBox(height: TossSpacing.space3),
              Text(
                salesState.error!,
                textAlign: TextAlign.center,
                style: TossTextStyles.body.copyWith(color: TossColors.gray600),
              ),
              SizedBox(height: TossSpacing.space3),
              ElevatedButton(
                onPressed: () => ref.read(salesProductProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Apply local sorting only (search is handled by RPC)
    var filteredProducts = List<SalesProduct>.from(products);
    
    // Apply sorting
    switch (_currentSort) {
      case SortOption.nameAsc:
      case SortOption.nameDesc:
        filteredProducts.sort((a, b) => 
            _sortAscending ? a.productName.compareTo(b.productName) : b.productName.compareTo(a.productName));
        break;
      case SortOption.priceAsc:
      case SortOption.priceDesc:
        filteredProducts.sort((a, b) {
          final aPrice = a.pricing.sellingPrice ?? 0;
          final bPrice = b.pricing.sellingPrice ?? 0;
          return _sortAscending ? aPrice.compareTo(bPrice) : bPrice.compareTo(aPrice);
        });
        break;
      case SortOption.stockAsc:
      case SortOption.stockDesc:
        filteredProducts.sort((a, b) => 
            _sortAscending 
              ? a.totalStockSummary.totalQuantityOnHand.compareTo(b.totalStockSummary.totalQuantityOnHand) 
              : b.totalStockSummary.totalQuantityOnHand.compareTo(a.totalStockSummary.totalQuantityOnHand));
        break;
    }

    // Determine if product list should be shown
    // Show product list when:
    // 1. Cart is empty (initial state)
    // 2. Search bar is focused (user wants to search/select)
    // 3. Search has text and is not focused (show filtered results)
    final shouldShowProductList = cart.isEmpty || _isSearchFocused || searchQuery.isNotEmpty;
    
    // Apply live filtering based on search query
    var displayProducts = filteredProducts;
    if (searchQuery.isNotEmpty) {
      displayProducts = filteredProducts.where((product) {
        final searchLower = searchQuery.toLowerCase();
        return product.productName.toLowerCase().contains(searchLower) ||
               product.sku.toLowerCase().contains(searchLower);
      }).toList();
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
      body: Column(
        children: [
          // Fixed search section at the top
          Container(
            color: TossColors.gray100,
            padding: EdgeInsets.fromLTRB(
              TossSpacing.space4,
              TossSpacing.space2,
              TossSpacing.space4,
              TossSpacing.space2,
            ),
            child: TossSearchField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: 'Search products...',
              prefixIcon: Icons.search,
              onChanged: _onSearchChanged,
            ),
          ),
          
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Added Items Section (shown when cart has items and search is not focused)
                  if (cart.isNotEmpty && !_isSearchFocused) _buildAddedItemsSection(cart, currencySymbol),
                  
                  // Only show sort control and product list when needed
                  if (shouldShowProductList) ...[
                    // Sort Control (simplified - no filter for now)
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        TossSpacing.space4,
                        TossSpacing.space3,
                        TossSpacing.space4,
                        TossSpacing.space2,
                      ),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showSortOptionsSheet();
                        },
                        child: Container(
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
                                ),
                              ),
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

                    // Products Content
                    if (displayProducts.isEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
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
                                searchQuery.isNotEmpty 
                                  ? 'No products found for "${searchQuery}"'
                                  : 'No products found',
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
                                        '${displayProducts.length} available',
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
                                final cartItem = cart.firstWhere(
                                  (item) => item.productId == product.productId,
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
                                    _buildProductListTile(product, cartItem, currencySymbol),
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
                  ], // End of shouldShowProductList conditional
                  
                  // Bottom padding to prevent cart bar overlap
                  SizedBox(height: cart.isNotEmpty ? 100 : 80),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Cart Summary Bar
      bottomNavigationBar: cart.isNotEmpty
          ? CartSummaryBar(
              itemCount: ref.read(cartProvider.notifier).totalItems,
              subtotal: ref.read(cartProvider.notifier).subtotal,
              currencySymbol: currencySymbol,
              onReset: () {
                ref.read(cartProvider.notifier).clearCart();
              },
              onDone: () {
                // Navigate to payment method page with cart items
                final cartItems = ref.read(cartProvider);
                final products = ref.read(productsProvider);
                
                // Convert cart items to SalesProduct list
                final selectedProductsList = cartItems.map((cartItem) {
                  return products.firstWhere((p) => p.productId == cartItem.productId);
                }).toList();
                
                // Convert to the map format for quantities
                final productQuantities = <String, int>{};
                for (var item in cartItems) {
                  productQuantities[item.productId] = item.quantity;
                }
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethodPage(
                      selectedProducts: selectedProductsList,
                      productQuantities: productQuantities,
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildProductListTile(SalesProduct product, CartItem cartItem, String currencySymbol) {
    final isSelected = cartItem.quantity > 0;
    
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? TossColors.success.withOpacity(0.1) : Colors.transparent,
        border: isSelected ? Border.all(
          color: TossColors.success,
          width: 1.5,
        ) : null,
        borderRadius: isSelected ? BorderRadius.circular(TossBorderRadius.sm) : null,
      ),
      child: TossListTile(
      title: product.productName,
      subtitle: product.sku,
      showDivider: false,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: TossSpacing.space12,
            height: TossSpacing.space12,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: product.images.mainImage != null && product.images.mainImage!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: _buildProductImage(product.images.mainImage!),
                  )
                : Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
          ),
        ],
      ),
      trailing: Container(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price
            Text(
              _formatCurrency(product.pricing.sellingPrice ?? 0, currencySymbol),
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space1),
            // Stock info only
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Stock: ${product.totalStockSummary.totalQuantityOnHand}',
                  style: TossTextStyles.caption.copyWith(
                    color: _getStockColor(product),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        
        // Unfocus search bar when selecting a product
        _searchFocusNode.unfocus();
        
        if (cartItem.quantity == 0) {
          // Add first item to cart
          ref.read(cartProvider.notifier).addItem(product);
        } else {
          // Increase quantity when tapped
          ref.read(cartProvider.notifier).updateQuantity(
            cartItem.id,
            cartItem.quantity + 1,
          );
        }
      },
      ),
    );
  }

  Color _getStockColor(SalesProduct product) {
    final stock = product.totalStockSummary.totalQuantityOnHand;
    if (stock == 0) return TossColors.error;
    if (stock <= 5) return TossColors.warning;
    if (stock <= 20) return TossColors.info;
    return TossColors.success;
  }

  String _formatCurrency(double value, String currencySymbol) {
    // Format with commas for exact numbers, no K or M abbreviations
    final formatter = NumberFormat('#,##0', 'en_US');
    
    // For zero values, you can return a dash or just 0
    if (value == 0) {
      return '${currencySymbol}0';
    }
    
    // Format the value with commas
    String formatted = formatter.format(value.round());
    return '$currencySymbol$formatted';
  }
  
  Widget _buildProductImage(String imageUrl) {
    // Check if it's a valid URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
      );
    }
    // Check if it's an asset path
    else if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
      );
    }
    // Fallback to icon for invalid paths
    else {
      return Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD);
    }
  }

  Widget _buildAddedItemsSection(List<CartItem> cartItems, String currencySymbol) {
    final totalAmount = ref.read(cartProvider.notifier).subtotal;
    final totalItems = ref.read(cartProvider.notifier).totalItems;
    
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Added Items',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  '$totalItems items',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // Cart Items List
            ...cartItems.map((item) {
              return Container(
                margin: EdgeInsets.only(bottom: TossSpacing.space2),
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: TossColors.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Product Image
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: item.image != null && item.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              child: _buildProductImage(item.image!),
                            )
                          : Icon(Icons.inventory_2, color: TossColors.gray400, size: 20),
                    ),
                    
                    SizedBox(width: TossSpacing.space3),
                    
                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: TossSpacing.space1),
                          Text(
                            item.sku,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          SizedBox(height: TossSpacing.space1),
                          Row(
                            children: [
                              Text(
                                _formatCurrency(item.price, currencySymbol),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' × ${item.quantity}',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                              SizedBox(width: TossSpacing.space2),
                              Text(
                                _formatCurrency(item.subtotal, currencySymbol),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        color: TossColors.white,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        border: Border.all(
                          color: TossColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Decrease Button
                          InkWell(
                            onTap: item.quantity > 0
                                ? () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1)
                                : null,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(TossBorderRadius.sm),
                              bottomLeft: Radius.circular(TossBorderRadius.sm),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space2),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: item.quantity > 0 ? TossColors.primary : TossColors.gray400,
                              ),
                            ),
                          ),
                          
                          // Quantity Display
                          Container(
                            width: 40,
                            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                vertical: BorderSide(
                                  color: TossColors.gray200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          // Increase Button
                          InkWell(
                            onTap: () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(TossBorderRadius.sm),
                              bottomRight: Radius.circular(TossBorderRadius.sm),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space2),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: TossColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Remove Button
                    SizedBox(width: TossSpacing.space2),
                    InkWell(
                      onTap: () => ref.read(cartProvider.notifier).removeItem(item.id),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: TossColors.error,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            // Total Section
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  Text(
                    _formatCurrency(totalAmount, currencySymbol),
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}