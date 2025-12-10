import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../domain/entities/sales_product.dart';
import '../../common/product_image_widget.dart';
import '../helpers/payment_helpers.dart';

/// View items section with expandable product list
class ViewItemsSection extends StatefulWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;

  const ViewItemsSection({
    super.key,
    required this.selectedProducts,
    required this.productQuantities,
  });

  @override
  State<ViewItemsSection> createState() => _ViewItemsSectionState();
}

class _ViewItemsSectionState extends State<ViewItemsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return TossWhiteCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header - Always visible
          _buildHeader(),

          // Items list - Expandable
          if (_isExpanded) ...[
            Container(
              height: 1,
              color: TossColors.gray100,
            ),
            _buildItemsList(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(TossBorderRadius.lg),
        bottom: _isExpanded
            ? Radius.zero
            : const Radius.circular(TossBorderRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'View items',
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                // Item count badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: TossColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.selectedProducts.length}',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Icon(
              _isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 18,
              color: TossColors.gray600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        children: widget.selectedProducts.map((product) {
          final quantity = widget.productQuantities[product.productId] ?? 0;
          final price = product.pricing.sellingPrice ?? 0;

          return _buildItemRow(product, quantity, price);
        }).toList(),
      ),
    );
  }

  Widget _buildItemRow(SalesProduct product, int quantity, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ProductImageWidget(
              imageUrl: product.images.mainImage,
              size: 40,
              fallbackIcon: Icons.inventory_2,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.sku,
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w400,
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          // Quantity x Price
          Text(
            '$quantity × ${PaymentHelpers.formatNumber(price.toInt())}',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
