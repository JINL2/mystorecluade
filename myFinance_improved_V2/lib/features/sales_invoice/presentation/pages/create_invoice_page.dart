import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// import 'app_icons_fa.dart'; // Deprecated - use icon_mapper.dart instead
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';
import '../../domain/entities/sales_product.dart';
import '../providers/invoice_creation_provider.dart';
// TODO: Uncomment when payment_method_page.dart is created
// import 'payment_method_page.dart';

class CreateInvoicePage extends ConsumerStatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Initialize products load when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceCreationProvider.notifier).loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    ref.read(invoiceCreationProvider.notifier).searchProducts(query);
  }

  void _updateProductCount(SalesProduct product, int count) {
    ref.read(invoiceCreationProvider.notifier).updateProductCount(product, count);
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: 'Create Invoice',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.close, size: TossSpacing.iconMD),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Search Field
              _buildSearchSection(),

              // Added Items Section
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(invoiceCreationProvider);
                  if (state.selectedProducts.isNotEmpty) {
                    return _buildAddedItemsSection();
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Product List with bottom padding for button
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 80), // Space for bottom button
                  child: _buildProductList(),
                ),
              ),

              // Fixed Bottom Button
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossSearchField(
        controller: _searchController,
        hintText: 'Search products to add...',
        onChanged: _filterProducts,
      ),
    );
  }

  Widget _buildAddedItemsSection() {
    final state = ref.watch(invoiceCreationProvider);
    final selectedProducts = state.selectedProducts;
    final totalItems = state.totalSelectedItems;

    if (selectedProducts.isEmpty) return const SizedBox.shrink();

    // Get selected product details
    final selectedProductsList = <SalesProduct>[];
    if (state.productData != null) {
      for (final productId in selectedProducts.keys) {
        try {
          final product = state.productData!.products
              .firstWhere((p) => p.productId == productId);
          selectedProductsList.add(product);
        } catch (e) {
          // Product not found, skip it
          debugPrint('Warning: Product with ID $productId not found in product list');
        }
      }
    }

    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  AppIcons.cart,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space2),
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

            const SizedBox(height: TossSpacing.space3),

            // Selected Products List
            ...selectedProductsList.map((product) {
              final quantity = selectedProducts[product.productId] ?? 0;
              return Container(
                margin: const EdgeInsets.only(bottom: TossSpacing.space2),
                padding: const EdgeInsets.all(TossSpacing.space3),
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
                      child: product.mainImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              child: Image.network(
                                product.mainImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.inventory_2, color: TossColors.gray400, size: 20),
                              ),
                            )
                          : const Icon(Icons.inventory_2, color: TossColors.gray400, size: 20),
                    ),

                    const SizedBox(width: TossSpacing.space3),

                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: TossSpacing.space1),
                          Text(
                            product.sku,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space1),
                          Row(
                            children: [
                              if (product.sellingPrice != null && product.sellingPrice! > 0) ...[
                                Text(
                                  '${state.productData?.company.currency.symbol ?? ''}${currencyFormat.format(product.sellingPrice)}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  ' × $quantity',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                                Text(
                                  ' = ',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray400,
                                  ),
                                ),
                                Text(
                                  '${state.productData?.company.currency.symbol ?? ''}${currencyFormat.format(product.sellingPrice! * quantity)}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  'Price not set',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
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
                            onTap: quantity > 0
                                ? () => _updateProductCount(product, quantity - 1)
                                : null,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(TossBorderRadius.sm),
                              bottomLeft: Radius.circular(TossBorderRadius.sm),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(TossSpacing.space2),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: quantity > 0 ? TossColors.primary : TossColors.gray400,
                              ),
                            ),
                          ),

                          // Quantity Display
                          Container(
                            width: 40,
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: TossColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: TossColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              quantity.toString(),
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Increase Button
                          InkWell(
                            onTap: () {
                              _updateProductCount(product, quantity + 1);
                            },
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(TossBorderRadius.sm),
                              bottomRight: Radius.circular(TossBorderRadius.sm),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(TossSpacing.space2),
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

                    const SizedBox(width: TossSpacing.space2),

                    // Remove Button
                    InkWell(
                      onTap: () => _updateProductCount(product, 0),
                      child: Container(
                        padding: const EdgeInsets.all(TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: TossColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: TossColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Total Summary
            if (selectedProductsList.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space3),
              Container(
                padding: const EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: TossColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
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
                      '${state.productData?.company.currency.symbol ?? ''}${currencyFormat.format(_calculateTotalAmount(selectedProductsList, selectedProducts))}',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(invoiceCreationProvider);

        // Show loading state
        if (state.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: TossColors.primary),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  'Loading products...',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          );
        }

        // Show error state
        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: TossColors.error,
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  state.error!,
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TossSpacing.space3),
                ElevatedButton(
                  onPressed: () => ref.read(invoiceCreationProvider.notifier).refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (state.sortedFilteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 64,
                  color: TossColors.gray400,
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  state.searchQuery.isNotEmpty
                      ? 'No products found for "${state.searchQuery}"'
                      : 'No products available',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(TossSpacing.space4),
          itemCount: state.sortedFilteredProducts.length,
          itemBuilder: (context, index) {
            final product = state.sortedFilteredProducts[index];

            return Container(
              margin: const EdgeInsets.only(bottom: TossSpacing.space3),
              child: InkWell(
                onTap: () {
                  final currentCount = ref.read(invoiceCreationProvider.notifier).getProductCount(product.productId);
                  _updateProductCount(product, currentCount + 1);
                },
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: TossWhiteCard(
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: product.mainImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                child: Image.network(
                                  product.mainImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
                                ),
                              )
                            : const Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
                      ),

                      const SizedBox(width: TossSpacing.space3),

                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Row(
                              children: [
                                Text(
                                  product.sku,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                                Text(
                                  ' • ',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray400,
                                  ),
                                ),
                                Text(
                                  '${product.availableQuantity} available',
                                  style: TossTextStyles.caption.copyWith(
                                    color: product.hasAvailableStock
                                        ? TossColors.success
                                        : TossColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            // Product Price
                            Consumer(
                              builder: (context, ref, child) {
                                final state = ref.watch(invoiceCreationProvider);
                                final currency = state.productData?.company.currency;
                                final price = product.sellingPrice;

                                if (price != null && price > 0) {
                                  return Text(
                                    '${currency?.symbol ?? ''}${currencyFormat.format(price)}',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Price not set',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // Add indicator icon for selected items
                      Consumer(
                        builder: (context, ref, child) {
                          final currentCount = ref.watch(invoiceCreationProvider.notifier).getProductCount(product.productId);
                          if (currentCount > 0) {
                            return Container(
                              padding: const EdgeInsets.all(TossSpacing.space2),
                              decoration: BoxDecoration(
                                color: TossColors.primary,
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Text(
                                currentCount.toString(),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return const Icon(
                            Icons.add_circle_outline,
                            color: TossColors.primary,
                            size: TossSpacing.iconMD,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.gray300.withOpacity(0.3),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(invoiceCreationProvider);
          final hasSelectedItems = state.selectedProducts.isNotEmpty;

          return ElevatedButton(
            onPressed: hasSelectedItems ? _proceedToNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasSelectedItems ? TossColors.primary : TossColors.gray300,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              elevation: 0,
            ),
            child: Text(
              'Next',
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  // Calculate total amount for selected products
  double _calculateTotalAmount(List<SalesProduct> selectedProducts, Map<String, int> quantities) {
    double total = 0.0;
    for (final product in selectedProducts) {
      final quantity = quantities[product.productId] ?? 0;
      final price = product.sellingPrice ?? 0.0;
      total += price * quantity;
    }
    return total;
  }

  void _proceedToNext() {
    final state = ref.read(invoiceCreationProvider);

    if (state.selectedProducts.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'No Products Selected',
          message: 'Please add at least one product',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    // TODO: Uncomment when PaymentMethodPage is created
    // Get selected products and their quantities
    // final selectedProducts = <SalesProduct>[];
    // final productQuantities = Map<String, int>.from(state.selectedProducts);

    // if (state.productData != null) {
    //   for (final productId in state.selectedProducts.keys) {
    //     try {
    //       final product = state.productData!.products
    //           .firstWhere((p) => p.productId == productId);
    //       selectedProducts.add(product);
    //     } catch (e) {
    //       debugPrint('Warning: Product with ID $productId not found in product list');
    //     }
    //   }
    // }

    // Navigate to payment method selection page
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     builder: (context) => PaymentMethodPage(
    //       selectedProducts: selectedProducts,
    //       productQuantities: productQuantities,
    //     ),
    //   ),
    // );

    // Temporary placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment method page coming soon (${state.totalSelectedItems} items selected)'),
        backgroundColor: TossColors.primary,
      ),
    );
  }

}
