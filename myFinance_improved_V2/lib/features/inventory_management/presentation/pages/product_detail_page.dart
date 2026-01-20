import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/app_state.dart';
import '../../di/inventory_providers.dart';
import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/value_objects/pagination_params.dart';
import '../../domain/value_objects/product_filter.dart';
import '../providers/inventory_providers.dart';
import '../models/store_location.dart';
import '../widgets/move_stock_dialog.dart';
import '../widgets/product_detail/product_detail_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Product Detail Page - New design with compact header and location list
class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;
  final String? variantId;
  final Product? initialProduct;

  const ProductDetailPage({
    super.key,
    required this.productId,
    this.variantId,
    this.initialProduct,
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  bool _hasStockFilter = true;
  List<StoreStock>? _storeStocks;
  bool _isLoadingStocks = true;
  Product? _localProduct;
  bool _isLoadingProduct = false;

  // Page entrance animation
  late AnimationController _pageController;
  late Animation<double> _pageFadeAnimation;

  @override
  void initState() {
    super.initState();
    // Use initial product if provided (from navigation extra)
    _localProduct = widget.initialProduct;

    // Setup page entrance animation
    _pageController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );

    _pageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: TossAnimations.enter),
    );

    // Start page animation
    _pageController.forward();

    _loadStoreStocks();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigate to edit page and handle result
  Future<void> _navigateToEdit(Product product) async {
    final result = await context.push<Product>(
      '/inventoryManagement/editProduct/${product.id}',
      extra: product,
    );

    // If edit page returned an updated product, update local state
    if (result != null && mounted) {
      setState(() {
        _localProduct = result;
      });
      // Refresh store stocks with updated data
      _loadStoreStocks();
    }
  }

  /// Load product from API if not found in provider
  Future<void> _loadProductFromApi() async {
    if (_isLoadingProduct) return;

    setState(() => _isLoadingProduct = true);

    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isEmpty || storeId.isEmpty) {
      setState(() => _isLoadingProduct = false);
      return;
    }

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      // Search by productId - the API will match on ID through search
      final result = await repository.getProducts(
        companyId: companyId,
        storeId: storeId,
        pagination: const PaginationParams(limit: 50),
        filter: ProductFilter(searchQuery: widget.productId),
      );

      if (mounted && result != null && result.products.isNotEmpty) {
        // Find exact match by ID
        final matchedProduct = result.products.cast<Product?>().firstWhere(
          (p) => p?.id == widget.productId,
          orElse: () => null,
        );

        if (matchedProduct != null) {
          setState(() {
            _localProduct = matchedProduct;
            _isLoadingProduct = false;
          });
          // Add to provider for future use
          ref.read(inventoryPageNotifierProvider.notifier).addProductIfNotExists(_localProduct!);
        } else {
          setState(() => _isLoadingProduct = false);
        }
      } else {
        setState(() => _isLoadingProduct = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProduct = false);
      }
    }
  }

  Future<void> _loadStoreStocks() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      setState(() => _isLoadingStocks = false);
      return;
    }

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.getProductStockByStores(
        companyId: companyId,
        productIds: [widget.productId],
      );

      if (mounted && result?.products.isNotEmpty == true) {
        final productStock = result!.products.first;

        // Get current product - prioritize localProduct (updated after edit) or initialProduct which have correct variantId
        // Do NOT use firstWhere on provider list as all variants share same product ID
        final product = _localProduct ?? widget.initialProduct;

        setState(() {
          // For variant products, get stores for specific variantId
          // For non-variant products, use stores directly
          if (productStock.hasVariants && product?.variantId != null) {
            _storeStocks = productStock.getStoresForVariant(product!.variantId!);
          } else {
            _storeStocks = productStock.stores;
          }
          _isLoadingStocks = false;
        });
      } else if (mounted) {
        setState(() {
          _storeStocks = [];
          _isLoadingStocks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStocks = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(inventoryPageNotifierProvider);
    final currencySymbol = productsState.currency?.symbol ?? '';

    // For variant products, use localProduct (updated after edit) or initialProduct which have correct variantId
    // Don't search provider by productId as all variants share the same productId
    // Only fallback to provider search if we don't have localProduct/initialProduct
    // Priority: _localProduct (updated after edit) > initialProduct (from navigation)
    Product? product = _localProduct ?? widget.initialProduct;
    // For variant products, also match variantId to find the correct variant
    product ??= productsState.products.cast<Product?>().firstWhere(
      (p) => p?.id == widget.productId &&
             (widget.variantId == null || p?.variantId == widget.variantId),
      orElse: () => null,
    );

    if (product == null) {
      // Trigger API load if not already loading
      if (!_isLoadingProduct) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadProductFromApi();
        });
      }
      return TossScaffold(
        backgroundColor: TossColors.white,
        body: Column(
          children: [
            // Back button so user can go back
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back_ios, size: TossSpacing.iconMD),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: TossLoadingView()),
          ],
        ),
      );
    }

    // Use final local variable for type promotion
    final currentProduct = product;
    final appState = ref.watch(appStateProvider);
    final stores = _buildStoreLocations(appState, currentProduct, appState.storeChoosen);

    return TossScaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _pageFadeAnimation,
          child: Column(
            children: [
              ProductDetailTopBar(
                product: currentProduct,
                onMoreOptions: () => _showMoreOptions(context, ref, currentProduct),
                onEditPressed: () => _navigateToEdit(currentProduct),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header section - starts at 0ms
                      // Key ensures widget rebuilds when product images change
                      ProductHeaderSection(
                        key: ValueKey('product_header_${currentProduct.id}_${currentProduct.images.hashCode}'),
                        product: currentProduct,
                        animationDelay: 0,
                      ),
                      // Hero stats - starts at 100ms
                      ProductHeroStats(
                        product: currentProduct,
                        currencySymbol: currencySymbol,
                        animationDelay: 100,
                      ),
                      // Animated section divider
                      _AnimatedSectionDivider(animationDelay: 200),
                      // Locations section - starts at 250ms
                      ProductLocationsSection(
                        product: currentProduct,
                        stores: stores,
                        hasStockFilter: _hasStockFilter,
                        isLoading: _isLoadingStocks,
                        animationDelay: 250,
                        onFilterChanged: (value) {
                          setState(() => _hasStockFilter = value);
                        },
                        onStoreTap: (store) => _showMoveStockDialog(
                          context, currentProduct, store, stores,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  List<StoreLocation> _buildStoreLocations(
    AppState appState,
    Product product,
    String currentStoreId,
  ) {
    if (_storeStocks != null && _storeStocks!.isNotEmpty) {
      return _storeStocks!.map((stock) => StoreLocation(
        id: stock.storeId,
        name: stock.storeName,
        stock: stock.quantityOnHand,
        isCurrentStore: stock.storeId == currentStoreId,
      )).toList();
    }
    return _getCompanyStores(appState, product);
  }

  List<StoreLocation> _getCompanyStores(AppState appState, Product product) {
    final currentCompanyId = appState.companyChoosen;
    final currentStoreId = appState.storeChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
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
      return [
        StoreLocation(
          id: currentStoreId,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
          stock: product.onHand,
          isCurrentStore: true,
        ),
      ];
    }

    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      final storeId = storeMap['store_id'] as String? ?? '';
      final storeName = storeMap['store_name'] as String? ?? 'Unknown Store';
      final isCurrentStore = storeId == currentStoreId;

      return StoreLocation(
        id: storeId,
        name: storeName,
        stock: isCurrentStore ? product.onHand : 0,
        isCurrentStore: isCurrentStore,
      );
    }).toList();
  }

  void _showMoveStockDialog(
    BuildContext context,
    Product product,
    StoreLocation fromLocation,
    List<StoreLocation> allStores,
  ) {
    MoveStockDialog.show(
      context: context,
      productName: product.name,
      productId: product.id,
      fromLocation: fromLocation,
      allStores: allStores,
      onSubmit: (fromStore, toStore, quantity) async {
        return await _executeMoveStock(
          context: context,
          product: product,
          fromStore: fromStore,
          toStore: toStore,
          quantity: quantity,
        );
      },
    );
  }

  Future<bool> _executeMoveStock({
    required BuildContext context,
    required Product product,
    required StoreLocation fromStore,
    required StoreLocation toStore,
    required int quantity,
  }) async {
    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(inventoryRepositoryProvider);

      final result = await repository.moveProduct(
        companyId: appState.companyChoosen,
        fromStoreId: fromStore.id,
        toStoreId: toStore.id,
        productId: product.id,
        variantId: product.variantId,
        quantity: quantity,
        updatedBy: appState.userId,
        notes: 'Transfer from ${fromStore.name} to ${toStore.name}',
      );

      if (result != null && mounted) {
        if (context.mounted) {
          await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => TossDialog.success(
              title: 'Stock Moved',
              message: 'Moved $quantity units from ${fromStore.name} to ${toStore.name}',
              primaryButtonText: 'OK',
            ),
          );
        }
        await _loadStoreStocks();
        ref.read(inventoryPageNotifierProvider.notifier).refresh();
        return true;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
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
  }

  void _showMoreOptions(BuildContext context, WidgetRef ref, Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TossSpacing.space2),
            Container(
              width: TossDimensions.dragHandleWidth,
              height: TossDimensions.dragHandleHeight,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: TossColors.error),
              title: Text(
                'Delete Product',
                style: TossTextStyles.body.copyWith(color: TossColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(product);
              },
            ),
            const SizedBox(height: TossSpacing.space2),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TossButton.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TossButton.textButton(
            text: 'Delete',
            textColor: TossColors.error,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen as String?;

      if (companyId == null) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => TossDialog.error(
            title: 'Company Not Selected',
            message: 'Please select a company to delete products.',
            primaryButtonText: 'OK',
          ),
        );
        return;
      }

      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const TossLoadingView(),
      );

      final repository = ref.read(inventoryRepositoryProvider);
      final success = await repository.deleteProducts(
        productIds: [product.id],
        companyId: companyId,
      );

      if (!mounted) return;
      Navigator.of(context).pop();

      if (success) {
        ref.read(inventoryPageNotifierProvider.notifier).refresh();
        if (!mounted) return;
        context.pop();

        if (!mounted) return;
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => TossDialog.success(
            title: 'Product Deleted',
            message: '${product.name} has been successfully deleted.',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.pop(ctx),
          ),
        );
      } else {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => TossDialog.error(
            title: 'Delete Failed',
            message: 'Failed to delete product. Please try again.',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => TossDialog.error(
          title: 'Error',
          message: e.toString().replaceAll('Exception:', '').trim(),
          primaryButtonText: 'OK',
        ),
      );
    }
  }
}

/// Animated section divider with fade-in effect
class _AnimatedSectionDivider extends StatefulWidget {
  final int animationDelay;

  const _AnimatedSectionDivider({this.animationDelay = 0});

  @override
  State<_AnimatedSectionDivider> createState() => _AnimatedSectionDividerState();
}

class _AnimatedSectionDividerState extends State<_AnimatedSectionDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    Future.delayed(
      Duration(milliseconds: widget.animationDelay),
      () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnimation,
        child: Transform.scale(
          scaleY: _scaleAnimation.value,
          child: child,
        ),
      ),
      child: Container(height: TossSpacing.space3 + TossSpacing.space0_5, color: TossColors.gray100),
    );
  }
}
