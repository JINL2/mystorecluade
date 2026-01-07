// Presentation Page: Inventory Management
// Main page for inventory management with Clean Architecture

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../utils/store_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/product.dart';
import '../providers/inventory_providers.dart';
import '../providers/states/inventory_page_state.dart';
import '../widgets/inventory_filter_header.dart';
import '../widgets/inventory_product_card.dart';
import '../widgets/inventory_sort_sheet.dart';
import '../widgets/move_stock_dialog.dart';
import 'inventory_history_page.dart';
import 'inventory_search_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Inventory Management Page
class InventoryManagementPage extends ConsumerStatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  ConsumerState<InventoryManagementPage> createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState
    extends ConsumerState<InventoryManagementPage> {
  final ScrollController _scrollController = ScrollController();

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
      ref.read(inventoryPageNotifierProvider.notifier).refresh();
      // Trigger metadata provider to load (it auto-initializes on first read)
      ref.read(inventoryMetadataNotifierProvider);
    });
    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load next page when near bottom (200px threshold)
      final pageState = ref.read(inventoryPageNotifierProvider);
      if (pageState.canLoadMore) {
        ref.read(inventoryPageNotifierProvider.notifier).loadNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(inventoryPageNotifierProvider);
    // Watch metadata provider to keep it alive and get brands/categories
    ref.watch(inventoryMetadataNotifierProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(pageState),
      floatingActionButton: _buildFloatingAddButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return TossAppBar(
      title: 'Inventory',
      backgroundColor: TossColors.white,
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
        _buildAppBarIconButton(Icons.analytics_outlined, () {
          HapticFeedback.lightImpact();
          final appState = ref.read(appStateProvider);
          context.push(
            '/inventoryAnalysis',
            extra: {
              'companyId': appState.companyChoosen,
              'storeId': appState.storeChoosen,
            },
          );
        }),
        _buildAppBarIconButton(Icons.history, () {
          HapticFeedback.lightImpact();
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (context) => const InventoryHistoryPage(),
            ),
          );
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
    // Server-side filtering and sorting is handled by RPC (get_inventory_page_v5)
    final displayProducts = pageState.products;

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
            child: TossLoadingView(),
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
          delegate: InventoryFilterHeaderDelegate(
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
          padding: const EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space1, TossSpacing.space3, 100),
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
              child: TossLoadingView(),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterSection(InventoryPageState pageState) {
    return InventoryFilterSection(
      pageState: pageState,
      selectedAvailability: _selectedAvailability,
      selectedLocation: _selectedLocation,
      selectedBrand: _selectedBrand,
      selectedCategory: _selectedCategory,
      onFilterTap: _showFilterBottomSheet,
    );
  }

  Widget _buildFloatingAddButton() {
    return TossFAB.expandable(
      actions: [
        TossFABAction(
          icon: Icons.add,
          label: 'Add New Product',
          onPressed: () {
            context.push('/inventoryManagement/addProduct');
          },
        ),
        TossFABAction(
          icon: Icons.download_outlined,
          label: 'Record Stock In',
          onPressed: () {
            // Navigate to Receiving session action page
            context.push('/session/action/receiving');
          },
        ),
        TossFABAction(
          icon: Icons.format_list_numbered,
          label: 'Start Inventory Count',
          onPressed: () {
            // Navigate to Stock Count session action page
            context.push('/session/action/counting');
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
    ref.read(inventoryPageNotifierProvider.notifier).setStockStatus(stockStatus);
  }

  /// Handle brand filter change
  void _onBrandChanged(String brandName) {
    if (brandName == 'All brands') {
      ref.read(inventoryPageNotifierProvider.notifier).setBrand(null);
      return;
    }

    // Find brand ID by name from metadata
    final metadataState = ref.read(inventoryMetadataNotifierProvider);
    final brands = metadataState.metadata?.brands ?? [];

    for (final brand in brands) {
      if (brand.name == brandName) {
        ref.read(inventoryPageNotifierProvider.notifier).setBrand(brand.id);
        return;
      }
    }
  }

  /// Handle category filter change
  void _onCategoryChanged(String categoryName) {
    if (categoryName == 'All categories') {
      ref.read(inventoryPageNotifierProvider.notifier).setCategory(null);
      return;
    }

    // Find category ID by name from metadata
    final metadataState = ref.read(inventoryMetadataNotifierProvider);
    final categories = metadataState.metadata?.categories ?? [];

    for (final category in categories) {
      if (category.name == categoryName) {
        ref.read(inventoryPageNotifierProvider.notifier).setCategory(category.id);
        return;
      }
    }
  }

  /// Handle location (store) change - update AppState and reset filters
  void _onLocationChanged(String storeName) {
    final appState = ref.read(appStateProvider);
    final storeInfo = _getStoreIdByName(storeName);

    if (storeInfo != null && storeInfo['store_id'] != appState.storeChoosen) {
      // Reset UI filter selections
      setState(() {
        _selectedAvailability = 'All products';
        _selectedBrand = 'All brands';
        _selectedCategory = 'All categories';
      });

      // Update AppState with new store selection
      ref.read(appStateProvider.notifier).selectStore(
        storeInfo['store_id']!,
        storeName: storeInfo['store_name'],
      );

      // Clear all filters and refresh for new store
      ref.read(inventoryPageNotifierProvider.notifier).clearFilters();
    }
  }

  /// Get store_id by store name from AppState
  Map<String, String>? _getStoreIdByName(String storeName) {
    final appState = ref.read(appStateProvider);
    final store = StoreUtils.findStoreByName(appState, storeName);
    if (store == null) return null;
    return {
      'store_id': store.id,
      'store_name': store.name,
    };
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
    final metadataState = ref.read(inventoryMetadataNotifierProvider);
    final brands = metadataState.metadata?.brands ?? [];

    if (brands.isEmpty) {
      return ['All brands'];
    }

    return ['All brands', ...brands.map((brand) => brand.name)];
  }

  /// Get category options from inventory metadata
  List<String> _getCategoryOptions() {
    final metadataState = ref.read(inventoryMetadataNotifierProvider);
    final categories = metadataState.metadata?.categories ?? [];

    if (categories.isEmpty) {
      return ['All categories'];
    }

    return ['All categories', ...categories.map((category) => category.name)];
  }

  /// Get store options from AppState for Location filter
  List<String> _getStoreOptions() {
    final appState = ref.read(appStateProvider);
    return StoreUtils.getStoreNames(appState);
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
      TossToast.info(context, 'No stores available');
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
            // Show success dialog
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => TossDialog.success(
                title: 'Stock Moved',
                message: 'Moved $quantity units from ${fromStore.name} to ${toStore.name}',
                primaryButtonText: 'OK',
              ),
            );
            // Refresh inventory data
            ref.read(inventoryPageNotifierProvider.notifier).refresh();
            return true;
          }
          return false;
        } catch (e) {
          if (mounted) {
            // Show error dialog
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (ctx) => TossDialog.error(
                title: 'Move Failed',
                message: e.toString().replaceAll('Exception:', '').trim(),
              ),
            );
          }
          return false;
        }
      },
    );
  }

  void _showSortOptionsSheet() {
    final pageState = ref.read(inventoryPageNotifierProvider);

    // Convert current state to InventorySortOption for display
    InventorySortOption? currentSort;
    if (pageState.sortBy != null && pageState.sortDirection != null) {
      currentSort = InventorySortOption.fromStrings(
        pageState.sortBy!,
        pageState.sortDirection!,
      );
    }

    InventorySortSheet.show(
      context: context,
      currentSort: currentSort,
      onSortChanged: (newSort) {
        if (newSort == null) {
          // Clear sort - use default (created_at desc)
          ref.read(inventoryPageNotifierProvider.notifier).setSorting('created_at', 'desc');
        } else {
          // Apply server-side sorting
          ref.read(inventoryPageNotifierProvider.notifier).setSorting(
            newSort.sortBy,
            newSort.sortDirection,
          );
        }
      },
    );
  }
}
