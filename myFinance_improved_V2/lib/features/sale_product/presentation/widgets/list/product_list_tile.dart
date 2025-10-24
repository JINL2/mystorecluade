import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_list_tile.dart';
import '../../../domain/entities/sales_product.dart';
import '../../utils/stock_color_helper.dart';
import '../common/product_image_widget.dart';

/// Product list tile widget
///
/// Displays individual product information in a list.
/// Shows product image, name, SKU, price, and stock status.
class ProductListTile extends StatelessWidget {
  final SalesProduct product;
  final VoidCallback? onTap;
  final String currencySymbol;

  const ProductListTile({
    super.key,
    required this.product,
    this.onTap,
    this.currencySymbol = '₩',
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final stockColor = StockColorHelper.getStockColor(
      product.totalStockSummary.totalQuantityOnHand,
    );

    return TossListTile(
      leading: ProductImageWidget(
        imageUrl: product.images.mainImage,
        size: 48,
        fallbackIcon: Icons.inventory_2,
      ),
      title: product.productName,
      subtitle: product.sku,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$currencySymbol${formatter.format(product.pricing.sellingPrice?.round() ?? 0)}',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Stock: ${product.totalStockSummary.totalQuantityOnHand}',
            style: TossTextStyles.caption.copyWith(color: stockColor),
          ),
        ],
      ),
      onTap: product.hasAvailableStock ? onTap : null,
    );
  }
}
