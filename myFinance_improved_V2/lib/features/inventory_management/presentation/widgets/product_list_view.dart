// Widget: Product List View
// Displays list of products with loading indicator

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/inventory_metadata.dart';
import '../../domain/entities/product.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final Currency? currency;
  final ScrollController? scrollController;
  final bool isLoadingMore;
  final Function(Product)? onProductTap;

  const ProductListView({
    super.key,
    required this.products,
    this.currency,
    this.scrollController,
    this.isLoadingMore = false,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(TossSpacing.space3),
      itemCount: products.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final product = products[index];
        return _ProductListItem(
          product: product,
          currency: currency,
          onTap: () => onProductTap?.call(product),
        );
      },
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  final Currency? currency;
  final VoidCallback? onTap;

  const _ProductListItem({
    required this.product,
    this.currency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol = currency?.symbol ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: ListTile(
        onTap: onTap,
        title: Text(
          product.name,
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space1),
            Text('SKU: ${product.sku}'),
            Text('Stock: ${product.onHand}'),
            Text('Price: $currencySymbol${product.salePrice.toStringAsFixed(0)}'),
          ],
        ),
        trailing: _buildStockStatusBadge(product.getStockStatus()),
      ),
    );
  }

  Widget _buildStockStatusBadge(StockStatus status) {
    Color color;
    String label;

    switch (status) {
      case StockStatus.normal:
        color = TossColors.success;
        label = 'Normal';
        break;
      case StockStatus.low:
        color = TossColors.warning;
        label = 'Low';
        break;
      case StockStatus.critical:
        color = TossColors.error;
        label = 'Critical';
        break;
      case StockStatus.outOfStock:
        color = TossColors.error;
        label = 'Out of Stock';
        break;
      case StockStatus.excess:
        color = TossColors.info;
        label = 'Excess';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
