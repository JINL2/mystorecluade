import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_spacing.dart';
import '../form_section_header.dart';
import '../rows/form_price_row.dart';

/// Shared Pricing section for Add/Edit Product pages
class ProductPricingSection extends StatelessWidget {
  final TextEditingController salePriceController;
  final TextEditingController costPriceController;
  final FocusNode salePriceFocusNode;
  final FocusNode costPriceFocusNode;
  final bool isSalePriceFocused;
  final bool isCostPriceFocused;
  final String currencySymbol;

  const ProductPricingSection({
    super.key,
    required this.salePriceController,
    required this.costPriceController,
    required this.salePriceFocusNode,
    required this.costPriceFocusNode,
    required this.isSalePriceFocused,
    required this.isCostPriceFocused,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          const FormSectionHeader(title: 'Pricing'),
          FormPriceRow(
            label: 'Sale price ($currencySymbol)',
            controller: salePriceController,
            focusNode: salePriceFocusNode,
            isFocused: isSalePriceFocused,
            placeholder: 'Enter selling price',
            currencySymbol: currencySymbol,
          ),
          FormPriceRow(
            label: 'Cost of goods ($currencySymbol)',
            controller: costPriceController,
            focusNode: costPriceFocusNode,
            isFocused: isCostPriceFocused,
            placeholder: 'Enter item cost',
            currencySymbol: currencySymbol,
          ),
        ],
      ),
    );
  }
}
