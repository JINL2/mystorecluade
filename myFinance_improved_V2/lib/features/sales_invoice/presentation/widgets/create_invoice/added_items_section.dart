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

/// Added items section widget for create invoice page
class AddedItemsSection extends ConsumerWidget {
  final void Function(SalesProduct product, int count) onUpdateProductCount;

  const AddedItemsSection({
    super.key,
    required this.onUpdateProductCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceCreationProvider);
    final selectedProducts = state.selectedProducts;
    final totalItems = state.totalSelectedItems;
    final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

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
          debugPrint(
              'Warning: Product with ID $productId not found in product list');
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
            _buildHeader(totalItems),

            const SizedBox(height: TossSpacing.space3),

            // Selected Products List
            ...selectedProductsList.map((product) {
              final quantity = selectedProducts[product.productId] ?? 0;
              return _buildProductItem(
                context,
                product,
                quantity,
                state.productData?.company.currency.symbol ?? '',
                currencyFormat,
              );
            }),

            // Total Summary
            if (selectedProductsList.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space3),
              _buildTotalSummary(
                selectedProductsList,
                selectedProducts,
                state.productData?.company.currency.symbol ?? '',
                currencyFormat,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int totalItems) {
    return Row(
      children: [
        const Icon(
          Icons.shopping_cart,
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
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    SalesProduct product,
    int quantity,
    String currencySymbol,
    NumberFormat currencyFormat,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
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
          _buildProductImage(product),

          const SizedBox(width: TossSpacing.space3),

          // Product Info
          Expanded(
            child: _buildProductInfo(
              product,
              quantity,
              currencySymbol,
              currencyFormat,
            ),
          ),

          // Quantity Controls
          _buildQuantityControls(product, quantity),

          const SizedBox(width: TossSpacing.space2),

          // Remove Button
          _buildRemoveButton(product),
        ],
      ),
    );
  }

  Widget _buildProductImage(SalesProduct product) {
    return Container(
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
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.inventory_2,
                    color: TossColors.gray400,
                    size: 20),
              ),
            )
          : const Icon(Icons.inventory_2, color: TossColors.gray400, size: 20),
    );
  }

  Widget _buildProductInfo(
    SalesProduct product,
    int quantity,
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
        Text(
          product.sku,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        _buildPriceRow(product, quantity, currencySymbol, currencyFormat),
      ],
    );
  }

  Widget _buildPriceRow(
    SalesProduct product,
    int quantity,
    String currencySymbol,
    NumberFormat currencyFormat,
  ) {
    if (product.sellingPrice != null && product.sellingPrice! > 0) {
      return Row(
        children: [
          Text(
            '$currencySymbol${currencyFormat.format(product.sellingPrice)}',
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
            '$currencySymbol${currencyFormat.format(product.sellingPrice! * quantity)}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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

  Widget _buildQuantityControls(SalesProduct product, int quantity) {
    return Container(
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
            onTap: quantity > 0
                ? () => onUpdateProductCount(product, quantity - 1)
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
                  color: TossColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
                right: BorderSide(
                  color: TossColors.primary.withValues(alpha: 0.2),
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
            onTap: () => onUpdateProductCount(product, quantity + 1),
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
    );
  }

  Widget _buildRemoveButton(SalesProduct product) {
    return InkWell(
      onTap: () => onUpdateProductCount(product, 0),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space2),
        decoration: BoxDecoration(
          color: TossColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: const Icon(
          Icons.close,
          size: 16,
          color: TossColors.error,
        ),
      ),
    );
  }

  Widget _buildTotalSummary(
    List<SalesProduct> selectedProductsList,
    Map<String, int> quantities,
    String currencySymbol,
    NumberFormat currencyFormat,
  ) {
    final total = _calculateTotalAmount(selectedProductsList, quantities);

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.2),
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
            '$currencySymbol${currencyFormat.format(total)}',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalAmount(
    List<SalesProduct> selectedProducts,
    Map<String, int> quantities,
  ) {
    double total = 0.0;
    for (final product in selectedProducts) {
      final quantity = quantities[product.productId] ?? 0;
      final price = product.sellingPrice ?? 0.0;
      total += price * quantity;
    }
    return total;
  }
}
