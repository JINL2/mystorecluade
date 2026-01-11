import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_opacity.dart';
import '../../../../shared/themes/toss_dimensions.dart';

import '../../../debt_control/presentation/providers/currency_provider.dart';
import 'payment_method_page.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sales_product.dart';
import '../providers/cart_provider.dart';
import '../providers/filtered_products_provider.dart';
import '../providers/sale_preload_provider.dart';
import '../providers/inventory_metadata_provider.dart';
import '../providers/sales_product_provider.dart';
import '../widgets/cart/cart_summary_bar.dart';
import '../widgets/list/product_skeleton_loading.dart';
import '../widgets/list/selectable_product_tile.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class SaleProductPage extends ConsumerStatefulWidget {
  const SaleProductPage({super.key});

  @override
  ConsumerState<SaleProductPage> createState() => _SaleProductPageState();
}

class _SaleProductPageState extends ConsumerState<SaleProductPage>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounceTimer;
  String _selectedBrand = 'All';

  // Flag to skip debounce search when programmatically setting search text
  bool _skipNextSearchDebounce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 2025 Best Practice: Minimal initialization, parallel loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePageData();
    });

    _scrollController.addListener(_onScroll);
  }

  /// Initialize page data with parallel loading (2025 performance pattern)
  /// - Avoids unnecessary invalidations that cause cascade rebuilds
  /// - Uses Future.wait for parallel API calls
  /// - Always loads fresh data for sales (inventory may have changed)
  Future<void> _initializePageData() async {
    // Clear cart synchronously (fast, local operation)
    ref.read(cartNotifierProvider.notifier).clearCart();

    // Clear search query to reset state (skip debounce to prevent duplicate search)
    _skipNextSearchDebounce = true;
    _searchController.clear();

    // Check current metadata state
    final currentMetadata = ref.read(inventoryMetadataNotifierProvider);
    final needsMetadataRefresh = !currentMetadata.hasValue ||
        currentMetadata.valueOrNull == null;

    // Parallel loading - both API calls execute simultaneously
    await Future.wait<void>([
      ref.read(salesProductNotifierProvider.notifier).loadProducts(search: ''),
      if (needsMetadataRefresh)
        ref.read(inventoryMetadataNotifierProvider.notifier).loadMetadata(),
    ]);

    // Preload payment page data in background (don't await)
    _preloadPaymentData();
  }

  /// Preload payment page data in background
  void _preloadPaymentData() {
    // Trigger preload without awaiting - runs in background
    ref.read(salePreloadNotifierProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final salesState = ref.read(salesProductNotifierProvider);
      if (salesState.canLoadMore) {
        ref.read(salesProductNotifierProvider.notifier).loadNextPage();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(salesProductNotifierProvider.notifier).refresh();
    }
  }

  void _onSearchChanged(String value) {
    // Skip if flag is set (programmatic text change from cart item tap)
    if (_skipNextSearchDebounce) {
      _skipNextSearchDebounce = false;
      return;
    }

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(TossAnimations.debounceDelay, () {
      ref.read(salesProductNotifierProvider.notifier).search(value);
    });
  }

  /// Filter products by selected brand
  List<SalesProduct> _filterByBrand(List<SalesProduct> products) {
    if (_selectedBrand == 'All') {
      return products;
    }
    return products
        .where((product) => product.brand == _selectedBrand)
        .toList();
  }

  /// Search for a product by SKU
  /// Called when user taps a cart item in the bottom sheet
  void _searchAndScrollToProduct(String productId, String sku) {
    _searchDebounceTimer?.cancel();

    if (_selectedBrand != 'All') {
      setState(() => _selectedBrand = 'All');
    }

    _skipNextSearchDebounce = true;
    _searchController.text = sku;

    // Smooth transition keeps existing data visible during API call
    ref.read(salesProductNotifierProvider.notifier).search(sku, smoothTransition: true);
  }



  Future<bool> _onWillPop() async {
    final cart = ref.read(cartNotifierProvider);
    if (cart.isEmpty) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TossColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Text('Discard Selection?', style: TossTextStyles.h4),
        content: Text(
          'You have items in your cart. Are you sure you want to discard your selection?',
          style: TossTextStyles.body.copyWith(color: TossColors.gray600),
        ),
        actions: [
          TossButton.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TossButton.textButton(
            text: 'Discard',
            textColor: TossColors.error,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (shouldDiscard == true) {
      ref.read(cartNotifierProvider.notifier).clearCart();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // 2025 Best Practice: Use ref.select for granular rebuilds
    // Only rebuild when specific values change, not entire state objects

    // Products - only rebuild when products list changes
    final allProducts = ref.watch(filteredProductsProvider);

    // Sales state - select only the fields we need
    final isLoading = ref.watch(
      salesProductNotifierProvider.select((s) => s.isLoading),
    );
    final isLoadingMore = ref.watch(
      salesProductNotifierProvider.select((s) => s.isLoadingMore),
    );
    final errorMessage = ref.watch(
      salesProductNotifierProvider.select((s) => s.errorMessage),
    );

    // Cart - optimized: only watch what we need
    // For cart bar visibility, we only need to know if cart has items
    final hasCartItems = ref.watch(
      cartNotifierProvider.select((cart) => cart.isNotEmpty),
    );
    // Full cart data only needed when cart is not empty
    final cart = hasCartItems ? ref.watch(cartNotifierProvider) : <CartItem>[];

    // Currency - simple value, no optimization needed
    final currencySymbol = ref.watch(currencyProvider);

    // Metadata - only need brand names
    final brands = ref.watch(
      inventoryMetadataNotifierProvider.select((s) => s.brandNames),
    );

    // Filter products by selected brand
    final displayProducts = _filterByBrand(allProducts);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: TossColors.white,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                _buildSearchAndBrands(brands),
                Expanded(
                  child: _buildProductList(
                    displayProducts: displayProducts,
                    cart: cart,
                    currencySymbol: currencySymbol,
                    isLoading: isLoading,
                    isLoadingMore: isLoadingMore,
                    errorMessage: errorMessage,
                    allProducts: allProducts,
                  ),
                ),
              ],
            ),
            // Animate cart summary bar when keyboard opens/closes
            if (hasCartItems)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  duration: TossAnimations.normal,
                  curve: TossAnimations.standard,
                  offset: MediaQuery.of(context).viewInsets.bottom > 0
                      ? const Offset(0, 1) // Slide down (hide)
                      : Offset.zero, // Slide up (show)
                  child: AnimatedOpacity(
                    duration: TossAnimations.normal,
                    curve: TossAnimations.standard,
                    opacity: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 0.0
                        : 1.0,
                    child: CartSummaryBar(
                      itemCount: ref.read(cartNotifierProvider.notifier).totalItems,
                      subtotal: ref.read(cartNotifierProvider.notifier).subtotal,
                      currencySymbol: currencySymbol,
                      cartItems: cart,
                      onCreateInvoice: () => _navigateToPayment(cart),
                      onReset: () => ref.read(cartNotifierProvider.notifier).clearCart(),
                      onItemTap: _searchAndScrollToProduct,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return TossAppBar(
      title: 'Sale',
      backgroundColor: TossColors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: TossSpacing.iconMD2),
        onPressed: () async {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget _buildSearchAndBrands(List<String> brands) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
      child: Column(
        children: [
          const SizedBox(height: TossSpacing.space2),
          _buildSearchBar(),
          const SizedBox(height: TossSpacing.space2),
          _buildBrandChips(brands),
          const SizedBox(height: TossSpacing.space2),
          Container(height: TossDimensions.dividerThickness, color: TossColors.border),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TossSearchField(
      controller: _searchController,
      hintText: 'Name, product code, product type,...',
      onChanged: _onSearchChanged,
    );
  }

  Widget _buildBrandChips(List<String> brands) {
    return SizedBox(
      height: TossSpacing.buttonHeightMD,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: TossSpacing.space4),
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isSelected = _selectedBrand == brand;

          return GestureDetector(
            onTap: () => setState(() => _selectedBrand = brand),
            child: Center(
              child: AnimatedContainer(
                duration: TossAnimations.normal,
                curve: TossAnimations.standard,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.badgePaddingHorizontalLG,
                  vertical: TossSpacing.badgePaddingVerticalLG,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.gray100 : TossColors.transparent,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Text(
                  brand,
                  style: TossTextStyles.label.copyWith(
                    fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.medium,
                    color: isSelected ? TossColors.textPrimary : TossColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductList({
    required List<SalesProduct> displayProducts,
    required List<CartItem> cart,
    required String currencySymbol,
    required bool isLoading,
    required bool isLoadingMore,
    required String? errorMessage,
    required List<SalesProduct> allProducts,
  }) {
    // Show skeleton loading if still loading and no products at all
    if (isLoading && allProducts.isEmpty) {
      return const ProductSkeletonLoading();
    }

    if (errorMessage != null && displayProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: TossSpacing.iconXXL, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(errorMessage, style: TossTextStyles.body),
            const SizedBox(height: TossSpacing.space3),
            TossButton.textButton(
              text: 'Retry',
              onPressed: () => ref.read(salesProductNotifierProvider.notifier).refresh(),
            ),
          ],
        ),
      );
    }

    if (displayProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: TossSpacing.icon4XL, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text('No products found',
                style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600)),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        left: TossSpacing.paddingMD,
        right: TossSpacing.paddingMD,
        top: TossSpacing.space1,
        bottom: cart.isNotEmpty ? 180 : TossSpacing.space6,
      ),
      itemCount: displayProducts.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayProducts.length) {
          return const Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: TossLoadingView(),
          );
        }

        final product = displayProducts[index];
        final cartItem = cart.firstWhere(
          (item) => item.productId == product.productId,
          orElse: () => const CartItem(
            id: '',
            productId: '',
            sku: '',
            name: '',
            price: 0,
            quantity: 0,
            available: 0,
          ),
        );

        return SelectableProductTile(
          key: ValueKey(product.productId),
          product: product,
          cartItem: cartItem,
          currencySymbol: currencySymbol,
        );
      },
    );
  }

  Future<void> _navigateToPayment(List<CartItem> cartItems) async {
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final selectedProductsList = cartNotifier.cartProducts;
    final productQuantities = <String, int>{};
    for (var item in cartItems) {
      productQuantities[item.productId] = item.quantity;
    }

    // Get preloaded data (exchange rates + cash locations)
    final preloadAsync = ref.read(salePreloadNotifierProvider);
    SalePreloadData preloadData;

    // If data is already loaded, navigate immediately (no delay)
    if (preloadAsync.hasValue) {
      preloadData = preloadAsync.requireValue;
    } else {
      // Show loading overlay while waiting for data
      _showNavigationLoading();

      try {
        preloadData = await ref.read(salePreloadNotifierProvider.future);
      } catch (e) {
        if (mounted) Navigator.of(context).pop(); // Close loading
        preloadData = const SalePreloadData();
      }

      // Close loading overlay
      if (mounted) Navigator.of(context).pop();
    }

    if (!mounted) return;

    // Navigate to payment page and wait for result
    final saleCompleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => PaymentMethodPage(
          selectedProducts: selectedProductsList,
          productQuantities: productQuantities,
          exchangeRateData: preloadData.exchangeRateData,
          cashLocations: preloadData.cashLocations,
        ),
      ),
    );

    // Only clear cart and refresh if sale was completed successfully
    if (mounted && saleCompleted == true) {
      ref.read(cartNotifierProvider.notifier).clearCart();
      _skipNextSearchDebounce = true;
      _searchController.clear();
      ref.read(salesProductNotifierProvider.notifier).loadProducts(search: '');
    }
  }

  void _showNavigationLoading() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: TossColors.black.withValues(alpha: TossOpacity.heavy),
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
        ),
      ),
    );
  }
}
