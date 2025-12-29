import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../domain/entities/product.dart';

/// Hero stats section showing Attributes, Cost, and Price
class ProductHeroStats extends StatelessWidget {
  final Product product;
  final String currencySymbol;

  const ProductHeroStats({
    super.key,
    required this.product,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attributes column
          Expanded(
            child: _buildAttributesColumn(),
          ),
          // Divider
          const GrayVerticalDivider(height: 50, horizontalMargin: 12),
          // Cost column
          Expanded(
            child: _buildCostColumn(),
          ),
          // Divider
          Container(
            width: 1,
            height: 50,
            color: TossColors.gray200,
            margin: const EdgeInsets.only(left: 12, right: 8),
          ),
          // Price column
          Expanded(
            child: _buildPriceColumn(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attributes',
          style: TossTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 2),
        if (product.brandName != null)
          Text(
            '· ${product.brandName}',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray900,
              height: 1.2,
            ),
          ),
        const SizedBox(height: 2),
        Text(
          '· ${product.categoryName ?? 'Uncategorized'}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray900,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCostColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cost',
          style: TossTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$currencySymbol${_formatCurrency(product.costPrice)}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray900,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TossTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$currencySymbol${_formatCurrency(product.salePrice)}',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.primary,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
