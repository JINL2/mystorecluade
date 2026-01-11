// Presentation Page: Inventory Search
// Search page for inventory products

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/product.dart';
import '../../domain/value_objects/pagination_params.dart';
import '../../domain/value_objects/product_filter.dart';
import '../providers/inventory_providers.dart';
import '../widgets/inventory_product_card.dart';
import '../widgets/move_stock_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Inventory Search Page
class InventorySearchPage extends ConsumerStatefulWidget {
  const InventorySearchPage({super.key});

  @override
  ConsumerState<InventorySearchPage> createState() =>
      _InventorySearchPageState();
}

class _InventorySearchPageState extends ConsumerState<InventorySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounceTimer;
  List<Product> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';
  String _currencySymbol = '\$';

  @override
  void initState() {
    super.initState();
    // Auto focus the search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _isSearching = value.isNotEmpty;
    });

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(TossAnimations.debounceDelay, () {
      _performSearch(value);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(inventoryRepositoryProvider);

      final result = await repository.getProducts(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
        pagination: const PaginationParams(page: 1, limit: 100),
        filter: ProductFilter(searchQuery: query),
      );

      if (mounted) {
        setState(() {
          _searchResults = result?.products ?? [];
          _currencySymbol = result?.currency.symbol ?? '\$';
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _buildSearchResults(_currencySymbol),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.arrow_back,
                color: TossColors.gray900,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Search field
          Expanded(
            child: TossSearchField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: 'Search products by name or SKU...',
              autofocus: true,
              onChanged: _onSearchChanged,
              onClear: () {
                setState(() {
                  _searchResults = [];
                  _searchQuery = '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(String currencySymbol) {
    if (_searchQuery.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search,
        title: 'Search Products',
        subtitle: 'Enter product name or SKU to search',
      );
    }

    if (_isSearching) {
      return const TossLoadingView();
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No results found',
        subtitle: 'Try a different search term',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space1, TossSpacing.space3, TossSpacing.space4),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return InventoryProductCard(
          product: product,
          currencySymbol: currencySymbol,
          onTap: () {
            // Add product to provider so ProductDetailPage can find it
            ref.read(inventoryPageNotifierProvider.notifier).addProductIfNotExists(product);
            // Include variantId as query param for variant products to ensure correct page rebuild
            final variantQuery = product.variantId != null ? '?variantId=${product.variantId}' : '';
            context.push('/inventoryManagement/product/${product.id}$variantQuery', extra: product);
          },
          onTransferTap: () => _showMoveStockDialog(product),
        );
      },
    );
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
        // Dialog handles its own loading state and closing
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
            await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => TossDialog.success(
                title: 'Stock Moved',
                message: 'Moved $quantity units from ${fromStore.name} to ${toStore.name}',
                primaryButtonText: 'OK',
              ),
            );
            // Refresh search results
            _performSearch(_searchQuery);
            return true;
          }
          return false;
        } catch (e) {
          if (mounted) {
            // Show error dialog
            await showDialog<bool>(
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

    // Convert stores list to StoreLocation list
    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      final storeId = storeMap['store_id'] as String? ?? '';
      return StoreLocation(
        id: storeId,
        name: storeMap['store_name'] as String? ?? 'Unknown Store',
        stock: product.onHand,
        isCurrentStore: storeId == currentStoreId,
      );
    }).toList();
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.gray700,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            subtitle,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
