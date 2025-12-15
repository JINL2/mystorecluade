// Presentation Page: Inventory Management
// Main page for inventory management with Clean Architecture

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_speed_dial.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/product.dart';
import '../providers/inventory_providers.dart';
import '../providers/states/inventory_page_state.dart';
import '../widgets/inventory_product_card.dart';
import '../widgets/move_stock_dialog.dart';
import 'inventory_search_page.dart';

/// Inventory Management Page
class InventoryManagementPage extends ConsumerStatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  ConsumerState<InventoryManagementPage> createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState
    extends ConsumerState<InventoryManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounceTimer;

  // Sorting (client-side only, RPC does not support sorting)
  _SortOption? _currentSort; // null = database default order

  // Filter selections
  String _selectedAvailability = 'All products';
  String _selectedLocation = 'All locations'; // Will be updated from AppState in initState
  String _selectedBrand = 'All brands';
  String _selectedCategory = 'All categories';

  @override
  void initState() {
    super.initState();
    // Set initial location from AppState
    final appState = ref.read(appStateProvider);
    _selectedLocation = appState.storeName.isNotEmpty
        ? appState.storeName
        : 'All locations';
    // Load initial data and metadata
    Future.microtask(() {
      ref.read(inventoryPageProvider.notifier).refresh();
      // Trigger metadata provider to load (it auto-initializes on first read)
      ref.read(inventoryMetadataProvider);
    });
    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load next page when near bottom (200px threshold)
      final pageState = ref.read(inventoryPageProvider);
      debugPrint('[InventoryPage] _onScroll: pixels=${_scrollController.position.pixels.toInt()}, max=${_scrollController.position.maxScrollExtent.toInt()}, canLoadMore=${pageState.canLoadMore}, isLoadingMore=${pageState.isLoadingMore}');
      if (pageState.canLoadMore) {
        debugPrint('[InventoryPage] _onScroll: Calling loadNextPage()');
        ref.read(inventoryPageProvider.notifier).loadNextPage();
      }
    }
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
    // Watch metadata provider to keep it alive and get brands/categories
    ref.watch(inventoryMetadataProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(pageState),
      floatingActionButton: _buildFloatingAddButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: TossColors.gray900,
          size: 22,
        ),
      ),
      title: Text(
        'Inventory',
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      titleSpacing: 0,
      actions: [
        _buildAppBarIconButton(Icons.search, () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const InventorySearchPage(),
            ),
          );
        }),
        _buildAppBarIconButton(Icons.swap_vert, () {
          HapticFeedback.lightImpact();
          _showSortOptionsSheet();
        }),
        _buildAppBarIconButton(Icons.history, () {
          // Handle history tap
        }),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildAppBarIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: TossColors.gray900,
        size: 22,
      ),
      splashRadius: 20,
    );
  }

  Widget _buildBody(InventoryPageState pageState) {
    // Apply local filtering and sorting (RPC doesn't support brand/category/stock filters)
    List<Product> displayProducts = _applyLocalFilters(pageState.products);
    displayProducts = _applyLocalSort(displayProducts);

    if (displayProducts.isEmpty && !pageState.isLoading) {
      return Column(
        children: [
          _buildFilterSection(pageState),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
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
          ),
        ],
      );
    }

    if (pageState.isLoading && displayProducts.isEmpty) {
      return Column(
        children: [
          _buildFilterSection(pageState),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Sticky filter section
        SliverPersistentHeader(
          pinned: true,
          delegate: _FilterHeaderDelegate(
            pageState: pageState,
            selectedAvailability: _selectedAvailability,
            selectedLocation: _selectedLocation,
            selectedBrand: _selectedBrand,
            selectedCategory: _selectedCategory,
            onFilterTap: (filter) {
              _showFilterBottomSheet(filter);
            },
          ),
        ),
        // Product list
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = displayProducts[index];
                final currencySymbol = pageState.currency?.symbol ?? '\$';
                return InventoryProductCard(
                  product: product,
                  currencySymbol: currencySymbol,
                  onTransferTap: () => _showMoveStockDialog(product),
                );
              },
              childCount: displayProducts.length,
            ),
          ),
        ),
        // Loading More Indicator
        if (pageState.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterSection(InventoryPageState pageState) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterPill('Availability', _selectedAvailability),
                const SizedBox(width: 8),
                _buildFilterPill('Location', _selectedLocation),
                const SizedBox(width: 8),
                _buildFilterPill('Brand', _selectedBrand),
                const SizedBox(width: 8),
                _buildFilterPill('Categories', _selectedCategory),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text
          Text(
            'Total on hand: ${pageState.pagination.total} items · Total value: ${_formatCurrency(_calculateTotalValue(pageState.products))}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String title, String subtitle) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          _showFilterBottomSheet(title);
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingAddButton() {
    return TossSpeedDial(
      actions: [
        TossSpeedDialAction(
          icon: Icons.add,
          label: 'Add New Product',
          onPressed: () {
            context.push('/inventoryManagement/addProduct');
          },
        ),
        TossSpeedDialAction(
          icon: Icons.download_outlined,
          label: 'Record Stock In',
          onPressed: () {
            context.pushNamed('stockIn');
          },
        ),
        TossSpeedDialAction(
          icon: Icons.format_list_numbered,
          label: 'Start Inventory Count',
          onPressed: () {
            context.pushNamed('inventoryCount');
          },
        ),
      ],
    );
  }

  void _showFilterBottomSheet(String filterType) {
    final options = _getFilterOptions(filterType);
    final currentSelection = _getCurrentFilterSelection(filterType);

    TossBottomSheet.show(
      context: context,
      title: filterType,
      content: ListView.separated(
        shrinkWrap: true,
        itemCount: options.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: TossColors.gray100,
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == currentSelection;

          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              option,
              style: TossTextStyles.body.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? TossColors.primary : TossColors.gray900,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check, color: TossColors.primary, size: 20)
                : null,
            onTap: () {
              setState(() {
                _setFilterSelection(filterType, option);
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  String _getCurrentFilterSelection(String filterType) {
    switch (filterType) {
      case 'Availability':
        return _selectedAvailability;
      case 'Location':
        return _selectedLocation;
      case 'Brand':
        return _selectedBrand;
      case 'Categories':
        return _selectedCategory;
      default:
        return '';
    }
  }

  void _setFilterSelection(String filterType, String value) {
    switch (filterType) {
      case 'Availability':
        _selectedAvailability = value;
        _onAvailabilityChanged(value);
      case 'Location':
        _selectedLocation = value;
        // Update AppState with new store selection and refresh inventory
        _onLocationChanged(value);
      case 'Brand':
        _selectedBrand = value;
        _onBrandChanged(value);
      case 'Categories':
        _selectedCategory = value;
        _onCategoryChanged(value);
    }
  }

  /// Handle availability filter change
  void _onAvailabilityChanged(String availability) {
    String? stockStatus;
    switch (availability) {
      case 'In stock':
        stockStatus = 'normal';
      case 'Out of stock':
        stockStatus = 'out_of_stock';
      case 'Low stock':
        stockStatus = 'low';
      default:
        stockStatus = null; // All products
    }
    ref.read(inventoryPageProvider.notifier).setStockStatus(stockStatus);
  }

  /// Handle brand filter change
  void _onBrandChanged(String brandName) {
    if (brandName == 'All brands') {
      ref.read(inventoryPageProvider.notifier).setBrand(null);
      return;
    }

    // Find brand ID by name from metadata
    final metadataState = ref.read(inventoryMetadataProvider);
    final brands = metadataState.metadata?.brands ?? [];

    for (final brand in brands) {
      if (brand.name == brandName) {
        ref.read(inventoryPageProvider.notifier).setBrand(brand.id);
        return;
      }
    }
  }

  /// Handle category filter change
  void _onCategoryChanged(String categoryName) {
    if (categoryName == 'All categories') {
      ref.read(inventoryPageProvider.notifier).setCategory(null);
      return;
    }

    // Find category ID by name from metadata
    final metadataState = ref.read(inventoryMetadataProvider);
    final categories = metadataState.metadata?.categories ?? [];

    for (final category in categories) {
      if (category.name == categoryName) {
        ref.read(inventoryPageProvider.notifier).setCategory(category.id);
        return;
      }
    }
  }

  /// Handle location (store) change - update AppState and refresh inventory
  void _onLocationChanged(String storeName) {
    final appState = ref.read(appStateProvider);
    final storeInfo = _getStoreIdByName(storeName);

    if (storeInfo != null && storeInfo['store_id'] != appState.storeChoosen) {
      // Update AppState with new store selection
      ref.read(appStateProvider.notifier).selectStore(
        storeInfo['store_id']!,
        storeName: storeInfo['store_name'],
      );

      // Refresh inventory data for the new store
      ref.read(inventoryPageProvider.notifier).refresh();
    }
  }

  /// Get store_id by store name from AppState
  Map<String, String>? _getStoreIdByName(String storeName) {
    final appState = ref.read(appStateProvider);
    final currentCompanyId = appState.companyChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    // Find current company
    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) return null;

    final storesList = company['stores'] as List<dynamic>? ?? [];

    // Find store by name
    for (final store in storesList) {
      final storeMap = store as Map<String, dynamic>;
      final name = storeMap['store_name'] as String? ?? '';
      if (name == storeName) {
        return {
          'store_id': storeMap['store_id'] as String? ?? '',
          'store_name': name,
        };
      }
    }

    return null;
  }

  List<String> _getFilterOptions(String filterType) {
    switch (filterType) {
      case 'Availability':
        return ['All products', 'In stock', 'Out of stock', 'Low stock'];
      case 'Location':
        return _getStoreOptions();
      case 'Brand':
        return _getBrandOptions();
      case 'Categories':
        return _getCategoryOptions();
      default:
        return ['All'];
    }
  }

  /// Get brand options from inventory metadata
  List<String> _getBrandOptions() {
    final metadataState = ref.read(inventoryMetadataProvider);
    final brands = metadataState.metadata?.brands ?? [];

    if (brands.isEmpty) {
      return ['All brands'];
    }

    return ['All brands', ...brands.map((brand) => brand.name)];
  }

  /// Get category options from inventory metadata
  List<String> _getCategoryOptions() {
    final metadataState = ref.read(inventoryMetadataProvider);
    final categories = metadataState.metadata?.categories ?? [];

    if (categories.isEmpty) {
      return ['All categories'];
    }

    return ['All categories', ...categories.map((category) => category.name)];
  }

  /// Get store options from AppState for Location filter
  List<String> _getStoreOptions() {
    final appState = ref.read(appStateProvider);
    final currentCompanyId = appState.companyChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    // Find current company
    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
      // Fallback: return current store name only
      return [appState.storeName.isNotEmpty ? appState.storeName : 'All locations'];
    }

    final storesList = company['stores'] as List<dynamic>? ?? [];

    if (storesList.isEmpty) {
      return [appState.storeName.isNotEmpty ? appState.storeName : 'All locations'];
    }

    // Extract store names
    final storeNames = storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return storeMap['store_name'] as String? ?? 'Unknown Store';
    }).toList();

    return storeNames;
  }

  double _calculateTotalValue(List<Product> products) {
    return products.fold(0.0, (sum, product) => sum + (product.onHand * product.salePrice));
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Get all stores for the current company from AppState
  List<StoreLocation> _getCompanyStores(AppState appState, Product product) {
    final currentCompanyId = appState.companyChoosen;
    final currentStoreId = appState.storeChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    // Find current company using safe lookup
    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
      // Fallback: return single location with product's on-hand quantity
      return [
        StoreLocation(
          id: currentStoreId,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
          stock: product.onHand,
          isCurrentStore: true,
        ),
      ];
    }

    final storesList = company['stores'] as List<dynamic>? ?? [];

    if (storesList.isEmpty) {
      // No stores found, return single location
      return [
        StoreLocation(
          id: currentStoreId,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
          stock: product.onHand,
          isCurrentStore: true,
        ),
      ];
    }

    // Convert stores to StoreLocation
    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      final storeId = storeMap['store_id'] as String? ?? '';
      final storeName = storeMap['store_name'] as String? ?? 'Unknown Store';
      final isCurrentStore = storeId == currentStoreId;

      return StoreLocation(
        id: storeId,
        name: storeName,
        // For now, show on-hand qty for current store, 0 for others
        stock: isCurrentStore ? product.onHand : 0,
        isCurrentStore: isCurrentStore,
      );
    }).toList();
  }

  void _showMoveStockDialog(Product product) {
    final appState = ref.read(appStateProvider);
    final allStores = _getCompanyStores(appState, product);

    // Find current store as the default "from" location
    final currentStoreId = appState.storeChoosen;
    StoreLocation? fromLocation;
    for (final store in allStores) {
      if (store.id == currentStoreId) {
        fromLocation = store;
        break;
      }
    }
    fromLocation ??= allStores.isNotEmpty ? allStores.first : null;

    if (fromLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No stores available'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    MoveStockDialog.show(
      context: context,
      productName: product.name,
      productId: product.id,
      fromLocation: fromLocation,
      allStores: allStores,
      onSubmit: (fromStore, toStore, quantity) async {
        // Call inventory_move_product_v3 RPC
        Navigator.pop(context);

        try {
          final repository = ref.read(inventoryRepositoryProvider);
          final result = await repository.moveProduct(
            companyId: appState.companyChoosen,
            fromStoreId: fromStore.id,
            toStoreId: toStore.id,
            productId: product.id,
            quantity: quantity,
            updatedBy: appState.userId,
            notes: 'Move ${product.sku}',
          );

          if (result != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Moved $quantity units from ${fromStore.name} to ${toStore.name}'),
                backgroundColor: TossColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
            // Refresh inventory data
            ref.read(inventoryPageProvider.notifier).refresh();
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to move stock: $e'),
                backgroundColor: TossColors.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
    );
  }

  String _getSortLabel() {
    if (_currentSort == null) return 'Name (A-Z)';

    final sort = _currentSort!;
    final isAsc = sort.direction == _SortDirection.asc;

    switch (sort.field) {
      case _SortField.name:
        return isAsc ? 'Name (A-Z)' : 'Name (Z-A)';
      case _SortField.price:
        return isAsc ? 'Price (Low to High)' : 'Price (High to Low)';
      case _SortField.stock:
        return isAsc ? 'Stock (Low to High)' : 'Stock (High to Low)';
      case _SortField.value:
        return 'Value (High to Low)';
    }
  }

  /// Apply client-side filtering for brand, category, and stock status
  /// RPC does not support these filters, so we filter locally
  List<Product> _applyLocalFilters(List<Product> products) {
    if (products.isEmpty) return products;

    return products.where((product) {
      // Brand filter
      if (_selectedBrand != 'All brands') {
        if (product.brandName != _selectedBrand) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != 'All categories') {
        if (product.categoryName != _selectedCategory) {
          return false;
        }
      }

      // Availability (stock status) filter
      if (_selectedAvailability != 'All products') {
        final stockStatus = product.getStockStatus();
        switch (_selectedAvailability) {
          case 'In stock':
            // Include normal, excess, and low stock (anything with stock > 0)
            if (stockStatus == StockStatus.outOfStock) {
              return false;
            }
          case 'Out of stock':
            if (stockStatus != StockStatus.outOfStock) {
              return false;
            }
          case 'Low stock':
            // Include low and critical stock
            if (stockStatus != StockStatus.low && stockStatus != StockStatus.critical) {
              return false;
            }
        }
      }

      return true;
    }).toList();
  }

  List<Product> _applyLocalSort(List<Product> products) {
    if (_currentSort == null) return products;

    final sorted = List<Product>.from(products);
    final sort = _currentSort!;
    final isAsc = sort.direction == _SortDirection.asc;

    switch (sort.field) {
      case _SortField.name:
        sorted.sort((a, b) => isAsc
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name),);
      case _SortField.price:
        sorted.sort((a, b) => isAsc
            ? a.salePrice.compareTo(b.salePrice)
            : b.salePrice.compareTo(a.salePrice),);
      case _SortField.stock:
        sorted.sort((a, b) => isAsc
            ? a.onHand.compareTo(b.onHand)
            : b.onHand.compareTo(a.onHand),);
      case _SortField.value:
        sorted.sort((a, b) =>
            (b.onHand * b.salePrice).compareTo(a.onHand * a.salePrice),);
    }

    return sorted;
  }

  void _showSortOptionsSheet() {
    TossBottomSheet.show(
      context: context,
      title: 'Sort By',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('Name (A-Z)', _SortOption.nameAsc),
            _buildSortOption('Name (Z-A)', _SortOption.nameDesc),
            _buildSortOption('Price (Low to High)', _SortOption.priceAsc),
            _buildSortOption('Price (High to Low)', _SortOption.priceDesc),
            _buildSortOption('Stock (Low to High)', _SortOption.stockAsc),
            _buildSortOption('Stock (High to Low)', _SortOption.stockDesc),
            _buildSortOption('Value (High to Low)', _SortOption.valueDesc),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, _SortOption option) {
    final isSelected = _currentSort == option;
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: TossColors.primary, size: 20)
          : null,
      onTap: () {
        setState(() {
          if (_currentSort == option) {
            // Toggle off if same option is selected
            _currentSort = null;
          } else {
            _currentSort = option;
          }
        });
        Navigator.pop(context);
      },
    );
  }
}

/// Sticky header delegate for filters
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final InventoryPageState pageState;
  final String selectedAvailability;
  final String selectedLocation;
  final String selectedBrand;
  final String selectedCategory;
  final Function(String) onFilterTap;

  _FilterHeaderDelegate({
    required this.pageState,
    required this.selectedAvailability,
    required this.selectedLocation,
    required this.selectedBrand,
    required this.selectedCategory,
    required this.onFilterTap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterPill('Availability', selectedAvailability),
                const SizedBox(width: 8),
                _buildFilterPill('Location', selectedLocation),
                const SizedBox(width: 8),
                _buildFilterPill('Brand', selectedBrand),
                const SizedBox(width: 8),
                _buildFilterPill('Categories', selectedCategory),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text
          Text(
            'Total on hand: ${pageState.pagination.total} items · Total value: ${_formatCurrency(_calculateTotalValue())}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String title, String subtitle) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onFilterTap(title),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalValue() {
    return pageState.products.fold(0.0, (sum, product) => sum + (product.onHand * product.salePrice));
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// Client-side sort options for inventory list
/// Note: Server RPC does not support sorting, so this is handled locally
enum _SortField { name, price, stock, value }

enum _SortDirection { asc, desc }

class _SortOption {
  final _SortField field;
  final _SortDirection direction;

  const _SortOption(this.field, this.direction);

  static const nameAsc = _SortOption(_SortField.name, _SortDirection.asc);
  static const nameDesc = _SortOption(_SortField.name, _SortDirection.desc);
  static const priceAsc = _SortOption(_SortField.price, _SortDirection.asc);
  static const priceDesc = _SortOption(_SortField.price, _SortDirection.desc);
  static const stockAsc = _SortOption(_SortField.stock, _SortDirection.asc);
  static const stockDesc = _SortOption(_SortField.stock, _SortDirection.desc);
  static const valueDesc = _SortOption(_SortField.value, _SortDirection.desc);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SortOption && field == other.field && direction == other.direction;

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;
}
