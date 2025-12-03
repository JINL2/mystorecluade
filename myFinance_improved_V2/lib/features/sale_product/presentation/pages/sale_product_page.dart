import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Shared imports - UI components
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_error_view.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';

// Feature imports
import '../../../debt_control/presentation/providers/currency_provider.dart';
import '../../../sales_invoice/presentation/pages/payment_method_page.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/value_objects/sort_option.dart';
import '../providers/cart_provider.dart';
import '../providers/filtered_products_provider.dart';
import '../providers/sales_product_provider.dart';
import '../widgets/cart/added_items_section.dart';
import '../widgets/cart/cart_summary_bar.dart';
import '../widgets/list/selectable_product_tile.dart';
import '../widgets/modals/sort_options_bottom_sheet.dart';

class SaleProductPage extends ConsumerStatefulWidget {
  const SaleProductPage({super.key});

  @override
  ConsumerState<SaleProductPage> createState() => _SaleProductPageState();
}

class _SaleProductPageState extends ConsumerState<SaleProductPage>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounceTimer;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).clearCart();
      ref.read(salesProductProvider.notifier).refresh();
    });

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
        if (!_isSearchFocused && ref.read(cartProvider).isNotEmpty) {
          _searchController.clear();
        }
      });
    });

    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    _searchFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load next page when near bottom (200px threshold)
      final salesState = ref.read(salesProductProvider);
      if (salesState.canLoadMore) {
        debugPrint('[SaleProductPage] _onScroll: Calling loadNextPage()');
        ref.read(salesProductProvider.notifier).loadNextPage();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(salesProductProvider.notifier).refresh();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(salesProductProvider.notifier).search(value);
    });
  }

  void _showSortOptionsSheet() {
    final currentSort = ref.read(salesProductProvider).sortOption;

    SortOptionsBottomSheet.show(
      context: context,
      currentSort: currentSort,
      onSortChanged: (newSort) {
        ref.read(salesProductProvider.notifier).updateSort(newSort);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesProductProvider);
    final cart = ref.watch(cartProvider);
    final currencySymbol = ref.watch(currencyProvider);

    // Loading state
    if (salesState.isLoading && salesState.products.isEmpty) {
      return TossScaffold(
        backgroundColor: TossColors.gray100,
        appBar: AppBar(
          title: Text('Sales', style: TossTextStyles.h3),
          centerTitle: true,
          backgroundColor: TossColors.gray100,
        ),
        body: const TossLoadingView(message: 'Loading products...'),
      );
    }

    // Error state
    if (salesState.errorMessage != null && salesState.products.isEmpty) {
      return TossScaffold(
        backgroundColor: TossColors.gray100,
        appBar: AppBar(
          title: Text('Sales', style: TossTextStyles.h3),
          centerTitle: true,
          backgroundColor: TossColors.gray100,
        ),
        body: TossErrorView(
          error: salesState.errorMessage!,
          onRetry: () => ref.read(salesProductProvider.notifier).refresh(),
        ),
      );
    }

    // Get filtered products (memoized - only recomputes when dependencies change)
    final displayProducts = ref.watch(filteredProductsProvider);

    final shouldShowProductList = cart.isEmpty || _isSearchFocused;

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        title: Text('Sales', style: TossTextStyles.h3),
        centerTitle: true,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: TossColors.gray100,
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space4,
              TossSpacing.space2,
              TossSpacing.space4,
              TossSpacing.space2,
            ),
            child: TossSearchField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: 'Search products...',
              onChanged: _onSearchChanged,
            ),
          ),

          // Scrollable content with infinite scroll
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Added Items Section (shown when cart has items and search is not focused)
                if (cart.isNotEmpty && !_isSearchFocused)
                  SliverToBoxAdapter(
                    child: AddedItemsSection(
                      cartItems: cart,
                      currencySymbol: currencySymbol,
                    ),
                  ),

                // Only show sort control and product list when needed
                if (shouldShowProductList) ...[
                  // Sort Control
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(
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
                          padding: const EdgeInsets.symmetric(
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
                              const Icon(
                                Icons.sort_rounded,
                                size: 22,
                                color: TossColors.gray600,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Expanded(
                                child: Text(
                                  salesState.sortOption.displayName,
                                  style: TossTextStyles.labelLarge.copyWith(
                                    color: TossColors.gray700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: TossColors.gray500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Products Content
                  if (displayProducts.isEmpty)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_cart_outlined,
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
                    )
                  else ...[
                    // Section Header
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(
                          TossSpacing.space4,
                          TossSpacing.space2,
                          TossSpacing.space4,
                          0,
                        ),
                        child: TossWhiteCard(
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(TossSpacing.space4),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: TossColors.gray100,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.shopping_cart_rounded,
                                  color: TossColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Text(
                                  'Select Products',
                                  style: TossTextStyles.h4.copyWith(
                                    color: TossColors.gray900,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: TossSpacing.space2,
                                    vertical: TossSpacing.space1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                  ),
                                  child: Text(
                                    '${salesState.totalCount} available',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Product List Items
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
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

                          return Container(
                            margin: const EdgeInsets.fromLTRB(
                              TossSpacing.space4,
                              0,
                              TossSpacing.space4,
                              0,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.surface,
                              borderRadius: index == displayProducts.length - 1
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(TossBorderRadius.lg),
                                      bottomRight: Radius.circular(TossBorderRadius.lg),
                                    )
                                  : null,
                            ),
                            child: Column(
                              children: [
                                SelectableProductTile(
                                  product: product,
                                  cartItem: cartItem,
                                  currencySymbol: currencySymbol,
                                  onUnfocusSearch: () => _searchFocusNode.unfocus(),
                                ),
                                if (index < displayProducts.length - 1)
                                  const Divider(
                                    height: 1,
                                    color: TossColors.gray100,
                                    indent: TossSpacing.space4,
                                    endIndent: TossSpacing.space4,
                                  ),
                              ],
                            ),
                          );
                        },
                        childCount: displayProducts.length,
                      ),
                    ),

                    // Loading More Indicator
                    if (salesState.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(TossSpacing.space4),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ],

                // Bottom padding to prevent cart bar overlap
                SliverToBoxAdapter(
                  child: SizedBox(height: cart.isNotEmpty ? 100 : 80),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: cart.isNotEmpty
          ? CartSummaryBar(
              itemCount: ref.read(cartProvider.notifier).totalItems,
              subtotal: ref.read(cartProvider.notifier).subtotal,
              currencySymbol: currencySymbol,
              onReset: () => ref.read(cartProvider.notifier).clearCart(),
              onDone: () {
                // Navigate to payment method page with cart items
                final cartItems = ref.read(cartProvider);
                final cartNotifier = ref.read(cartProvider.notifier);

                // Get SalesProducts directly from cart (stored when added)
                final selectedProductsList = cartNotifier.cartProducts;

                // Convert to the map format for quantities
                final productQuantities = <String, int>{};
                for (var item in cartItems) {
                  productQuantities[item.productId] = item.quantity;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
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
}
