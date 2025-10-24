import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Shared imports - UI components
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_error_view.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/toss/toss_list_tile.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';

// Feature imports
import '../../../debt_control/presentation/providers/currency_provider.dart';
import '../../../sales_invoice/presentation/pages/payment_method_page.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sales_product.dart';
import '../../domain/value_objects/sort_option.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_product_provider.dart';
import '../providers/use_case_providers.dart';
import '../widgets/cart/cart_summary_bar.dart';
import '../widgets/common/product_image_widget.dart';

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
              ...SortOption.values.map((option) {
                return ListTile(
                  title: Text(option.displayName),
                  selected: currentSort == option,
                  onTap: () {
                    ref.read(salesProductProvider.notifier).updateSort(option);
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
                    // Sort Control
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
                                color: TossColors.gray600,
                              ),
                              SizedBox(width: TossSpacing.space2),
                              Expanded(
                                child: Text(
                                  salesState.sortOption.displayName,
                                  style: TossTextStyles.labelLarge.copyWith(
                                    color: TossColors.gray700,
                                  ),
                                ),
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
                      SizedBox(
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

  Widget _buildProductListTile(SalesProduct product, CartItem cartItem, String currencySymbol) {
    final isSelected = cartItem.quantity > 0;
    final formatter = NumberFormat('#,##0', 'en_US');

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? TossColors.success.withValues(alpha: 0.1) : Colors.transparent,
        border: isSelected
            ? Border.all(
                color: TossColors.success,
                width: 1.5,
              )
            : null,
        borderRadius: isSelected ? BorderRadius.circular(TossBorderRadius.sm) : null,
      ),
      child: TossListTile(
        title: product.productName,
        subtitle: product.sku,
        showDivider: false,
        leading: ProductImageWidget(
          imageUrl: product.images.mainImage,
          size: 48,
          fallbackIcon: Icons.inventory_2,
        ),
        trailing: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Price
              Text(
                '$currencySymbol${formatter.format(product.pricing.sellingPrice?.round() ?? 0)}',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              // Stock info
              Text(
                'Stock: ${product.totalStockSummary.totalQuantityOnHand}',
                style: TossTextStyles.caption.copyWith(
                  color: _getStockColor(product),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          _searchFocusNode.unfocus();

          if (cartItem.quantity == 0) {
            ref.read(cartProvider.notifier).addItem(product);
          } else {
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

  Widget _buildAddedItemsSection(List<CartItem> cartItems, String currencySymbol) {
    final totalAmount = ref.read(cartProvider.notifier).subtotal;
    final totalItems = ref.read(cartProvider.notifier).totalItems;
    final formatter = NumberFormat('#,##0', 'en_US');

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
                const Spacer(),
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
                  color: TossColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Product Image
                    ProductImageWidget(
                      imageUrl: item.image,
                      size: 40,
                      fallbackIcon: Icons.inventory_2,
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
                                '$currencySymbol${formatter.format(item.price.round())}',
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
                                '$currencySymbol${formatter.format(item.subtotal.round())}',
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
                          color: TossColors.primary.withValues(alpha: 0.2),
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
                            borderRadius: const BorderRadius.only(
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
                            decoration: const BoxDecoration(
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
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(TossBorderRadius.sm),
                              bottomRight: Radius.circular(TossBorderRadius.sm),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space2),
                              child: const Icon(
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
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: TossColors.error,
                      ),
                    ),
                  ],
                ),
              );
            }),

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
                    '$currencySymbol${formatter.format(totalAmount.round())}',
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
