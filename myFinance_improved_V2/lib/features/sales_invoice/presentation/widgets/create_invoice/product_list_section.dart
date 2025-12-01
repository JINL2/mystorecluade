import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../domain/entities/sales_product.dart';
import '../../providers/invoice_creation_provider.dart';
import '../../providers/states/invoice_creation_state.dart';

/// Product list section widget for create invoice page
class ProductListSection extends ConsumerWidget {
  final void Function(SalesProduct product, int count) onUpdateProductCount;

  const ProductListSection({
    super.key,
    required this.onUpdateProductCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceCreationProvider);

    // Show loading state
    if (state.isLoading) {
      return _buildLoadingState();
    }

    // Show error state
    if (state.error != null) {
      return _buildErrorState(ref, state.error!);
    }

    // Show empty state
    if (state.sortedFilteredProducts.isEmpty) {
      return _buildEmptyState(state.searchQuery);
    }

    return _buildProductList(context, ref, state);
  }

  Widget _buildLoadingState() {
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

  Widget _buildErrorState(WidgetRef ref, String error) {
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
            error,
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TossSpacing.space3),
          ElevatedButton(
            onPressed: () =>
                ref.read(invoiceCreationProvider.notifier).refresh(),
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

  Widget _buildEmptyState(String searchQuery) {
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
            searchQuery.isNotEmpty
                ? 'No products found for "$searchQuery"'
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

  Widget _buildProductList(
    BuildContext context,
    WidgetRef ref,
    InvoiceCreationState state,
  ) {
    final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return ListView.builder(
      padding: const EdgeInsets.all(TossSpacing.space4),
      itemCount: state.sortedFilteredProducts.length,
      itemBuilder: (context, index) {
        final product = state.sortedFilteredProducts[index];
        return _buildProductCard(
          context,
          ref,
          product,
          state.productData?.company.currency.symbol ?? '',
          currencyFormat,
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    SalesProduct product,
    String currencySymbol,
    NumberFormat currencyFormat,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: InkWell(
        onTap: () {
          final currentCount = ref
              .read(invoiceCreationProvider.notifier)
              .getProductCount(product.productId);
          onUpdateProductCount(product, currentCount + 1);
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: TossWhiteCard(
          padding: const EdgeInsets.all(TossSpacing.space3),
          child: Row(
            children: [
              // Product Image
              _buildProductImage(product),

              const SizedBox(width: TossSpacing.space3),

              // Product Info
              Expanded(
                child: _buildProductInfo(
                  ref,
                  product,
                  currencySymbol,
                  currencyFormat,
                ),
              ),

              // Add indicator icon for selected items
              _buildSelectionIndicator(ref, product),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(SalesProduct product) {
    return Container(
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
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.inventory_2,
                  color: TossColors.gray400,
                  size: 24,
                ),
              ),
            )
          : const Icon(
              Icons.inventory_2,
              color: TossColors.gray400,
              size: 24,
            ),
    );
  }

  Widget _buildProductInfo(
    WidgetRef ref,
    SalesProduct product,
    String currencySymbol,
    NumberFormat currencyFormat,
  ) {
    return Column(
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
        _buildProductPrice(ref, product, currencySymbol, currencyFormat),
      ],
    );
  }

  Widget _buildProductPrice(
    WidgetRef ref,
    SalesProduct product,
    String currencySymbol,
    NumberFormat currencyFormat,
  ) {
    final price = product.sellingPrice;

    if (price != null && price > 0) {
      return Text(
        '$currencySymbol${currencyFormat.format(price)}',
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
  }

  Widget _buildSelectionIndicator(WidgetRef ref, SalesProduct product) {
    final currentCount = ref
        .watch(invoiceCreationProvider.notifier)
        .getProductCount(product.productId);

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
  }
}
