import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/product.dart';
import '../../pages/product_transactions_page.dart';

/// Top navigation bar for product detail page
class ProductDetailTopBar extends StatelessWidget {
  final Product product;
  final VoidCallback onMoreOptions;

  const ProductDetailTopBar({
    super.key,
    required this.product,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - back button and SKU
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                product.sku,
                style: TossTextStyles.titleLarge.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
          // Right side - edit, history, and more buttons
          Row(
            children: [
              // Edit button
              IconButton(
                onPressed: () {
                  context.push('/inventoryManagement/editProduct/${product.id}');
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: TossColors.gray900,
                  size: 22,
                ),
                splashRadius: 20,
              ),
              // Transaction history button
              IconButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (context) => ProductTransactionsPage(product: product),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.history,
                  color: TossColors.gray900,
                  size: 22,
                ),
                splashRadius: 20,
              ),
              // More options button
              IconButton(
                onPressed: onMoreOptions,
                icon: const Icon(
                  Icons.more_vert,
                  color: TossColors.gray900,
                  size: 22,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
