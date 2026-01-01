import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';

import '../../../debt_control/presentation/providers/currency_provider.dart';
import 'payment_method_page.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sales_product.dart';
import '../providers/cart_provider.dart';
import '../providers/filtered_products_provider.dart';
import '../providers/sale_preload_provider.dart';
import '../providers/inventory_metadata_provider.dart';
import '../providers/sales_product_provider.dart';
import '../providers/states/sales_product_state.dart';
import '../widgets/cart/cart_summary_bar.dart';
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

  // Map to store GlobalKeys for each product tile by productId
  final Map<String, GlobalKey> _productKeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartNotifierProvider.notifier).clearCart();
      // Invalidate providers to force fresh data load from server
      ref.invalidate(filteredProductsProvider);
      ref.invalidate(salesProductNotifierProvider);
      ref.invalidate(inventoryMetadataNotifierProvider);
      ref.invalidate(salePreloadNotifierProvider);
      // Load metadata, exchange rates, and cash locations
      ref.read(inventoryMetadataNotifierProvider.notifier).loadMetadata();
      ref.read(salePreloadNotifierProvider.notifier).loadAll();
    });

    _scrollController.addListener(_onScroll);
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
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
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

  /// Scroll to a product in the list by productId
  void _scrollToProduct(String productId) {
    // Reset brand filter to "All" so the product is visible
    if (_selectedBrand != 'All') {
      setState(() => _selectedBrand = 'All');
    }

    // Wait for rebuild then scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the same list that's being displayed (after brand filter reset to "All")
      final allProducts = ref.read(filteredProductsProvider);
      final index = allProducts.indexWhere((p) => p.productId == productId);

      if (index != -1 && _scrollController.hasClients) {
        // First, do a rough scroll to approximate position
        // Each product tile is roughly 88px (44px image + padding + spacing)
        const itemHeight = 88.0;
        final targetOffset = index * itemHeight;

        // Clamp to max scroll extent
        final maxScroll = _scrollController.position.maxScrollExtent;
        final clampedOffset = targetOffset.clamp(0.0, maxScroll);

        _scrollController.animateTo(
          clampedOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) {
          // After rough scroll, use GlobalKey to fine-tune position
          Future.delayed(const Duration(milliseconds: 100), () {
            final key = _productKeys[productId];
            if (key?.currentContext != null) {
              Scrollable.ensureVisible(
                key!.currentContext!,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: 0.0,
              );
            }
          });
        });
      }
    });
  }

  /// Get or create a GlobalKey for a product
  GlobalKey _getProductKey(String productId) {
    return _productKeys.putIfAbsent(productId, () => GlobalKey());
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel',
                style: TossTextStyles.body
                    .copyWith(color: TossColors.gray600, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Discard',
                style: TossTextStyles.body
                    .copyWith(color: TossColors.error, fontWeight: FontWeight.w600)),
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
    final salesState = ref.watch(salesProductNotifierProvider);
    final cart = ref.watch(cartNotifierProvider);
    final currencySymbol = ref.watch(currencyProvider);
    final allProducts = ref.watch(filteredProductsProvider);
    final metadataState = ref.watch(inventoryMetadataNotifierProvider);

    // Get brands from metadata
    final brands = metadataState.brandNames;

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
                Expanded(child: _buildProductList(displayProducts, cart, currencySymbol, salesState, allProducts)),
              ],
            ),
            if (cart.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CartSummaryBar(
                  itemCount: ref.read(cartNotifierProvider.notifier).totalItems,
                  subtotal: ref.read(cartNotifierProvider.notifier).subtotal,
                  currencySymbol: currencySymbol,
                  cartItems: cart,
                  onCreateInvoice: () => _navigateToPayment(cart),
                  onItemTap: _scrollToProduct,
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
        icon: const Icon(Icons.arrow_back, size: 24),
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
          Container(height: 1, color: TossColors.border),
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
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isSelected = _selectedBrand == brand;

          return GestureDetector(
            onTap: () => setState(() => _selectedBrand = brand),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.gray100 : Colors.transparent,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Text(
                  brand,
                  style: TossTextStyles.label.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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

  Widget _buildProductList(
    List<SalesProduct> displayProducts,
    List<CartItem> cart,
    String currencySymbol,
    SalesProductState salesState,
    List<SalesProduct> allProducts,
  ) {
    // Show loading if still loading and no products at all
    if (salesState.isLoading && allProducts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (salesState.errorMessage != null && displayProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(salesState.errorMessage ?? 'Error loading products', style: TossTextStyles.body),
            const SizedBox(height: TossSpacing.space3),
            TextButton(
              onPressed: () => ref.read(salesProductNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
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
            const Icon(Icons.shopping_cart_outlined, size: 64, color: TossColors.gray400),
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
      itemCount: displayProducts.length + (salesState.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayProducts.length) {
          return const Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Center(child: CircularProgressIndicator()),
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
          key: _getProductKey(product.productId),
          product: product,
          cartItem: cartItem,
          currencySymbol: currencySymbol,
        );
      },
    );
  }

  void _navigateToPayment(List<CartItem> cartItems) {
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final selectedProductsList = cartNotifier.cartProducts;
    final productQuantities = <String, int>{};
    for (var item in cartItems) {
      productQuantities[item.productId] = item.quantity;
    }

    // Get preloaded data (exchange rates + cash locations)
    final preloadAsync = ref.read(salePreloadNotifierProvider);
    final preloadData = preloadAsync.valueOrNull ?? const SalePreloadData();

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => PaymentMethodPage(
          selectedProducts: selectedProductsList,
          productQuantities: productQuantities,
          exchangeRateData: preloadData.exchangeRateData,
          cashLocations: preloadData.cashLocations,
        ),
      ),
    );
  }
}
