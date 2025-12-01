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
import '../providers/sales_product_provider.dart';
import '../providers/use_case_providers.dart';
import '../widgets/cart/added_items_section.dart';
import '../widgets/cart/cart_summary_bar.dart';
import '../widgets/list/selectable_product_tile.dart';

class SaleProductPage extends ConsumerStatefulWidget {
  const SaleProductPage({super.key});

  @override
  ConsumerState<SaleProductPage> createState() => _SaleProductPageState();
}

class _SaleProductPageState extends ConsumerState<SaleProductPage>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    _searchFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

    // Only show base options (Asc variants) - tap toggles between Asc/Desc
    final baseOptions = [
      SortOption.nameAsc,
      SortOption.priceAsc,
      SortOption.stockAsc,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      builder: (context) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.lg),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
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
                const SizedBox(height: TossSpacing.space3),
                ...baseOptions.map((option) {
                  final isSelected = currentSort == option ||
                      currentSort == option.toggled;
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Text(option.displayName),
                    selected: isSelected,
                    trailing: isSelected
                        ? Icon(
                            currentSort.isAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      final newSort = isSelected ? currentSort.toggled : option;
                      ref.read(salesProductProvider.notifier).updateSort(newSort);
                      Navigator.pop(context);
                    },
                  );
                }),
                const SizedBox(height: TossSpacing.space2),
              ],
            ),
          ),
        ),
      ),
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

    // Filter and sort products
    final filterUseCase = ref.read(filterProductsUseCaseProvider);
    final displayProducts = filterUseCase.execute(
      products: salesState.products,
      searchQuery: _searchController.text,
      sortOption: salesState.sortOption,
    );

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

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Added Items Section (shown when cart has items and search is not focused)
                  if (cart.isNotEmpty && !_isSearchFocused)
                    AddedItemsSection(
                      cartItems: cart,
                      currencySymbol: currencySymbol,
                    ),

                  // Only show sort control and product list when needed
                  if (shouldShowProductList) ...[
                    // Sort Control
                    Container(
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

                    // Products Content
                    if (displayProducts.isEmpty)
                      SizedBox(
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
                      )
                    else
                      Container(
                        margin: const EdgeInsets.all(TossSpacing.space4),
                        child: TossWhiteCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              // Section Header
                              Container(
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

                                return Column(
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
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                  ],

                  // Bottom padding to prevent cart bar overlap
                  SizedBox(height: cart.isNotEmpty ? 100 : 80),
                ],
              ),
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
                final products = salesState.products;

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
